#!/bin/zsh

set -e

# Aim: Run tfold container on the host machine
# Input:
# Output:
# Usage:
# Example:
# Dependencies:

##############################################################################
# FUNCTION                                                                   #
##############################################################################
function usage() {
  #echo "Usage: $(basename $0) --abdbid <abdbid> --ab_chain <ab_chain> --ag_chain <ag_chain> --abdb <abdb> --s3bucket <s3bucket> --outdir <outdir> --clean <clean>"
  #echo "  --abdbid   : AbDb id"
  #echo "  --ab_chain : Ab chain ids, if multiple, wrap in quotes e.g. 'H L' (default: H L)"
  #echo "  --ag_chain : Ag chain id"
  #echo "  --abdb     : AbDb directory (default: /home/ubuntu/AbDb/asepv1-1724)"
  #echo "  --outdir   : Output directory (default: $PWD)"
  #echo "  --clean    : Clean up the output directory (default: false)"
  #echo "  --s3bucket : (optional) S3 bucket to upload the output"
  #echo "  --esm2_ckpt_host_path : (optional) ESM2 checkpoint host path (default: /home/ubuntu/trained_models/ESM2)"
  #echo "  --help     : Print this help message"
  # add example
  echo "Example:"
  #echo "$(basename $0) --abdbid 7djz_0P --ab_chain 'H L' --ag_chain C --abdb /mnt/Data/AbDb/abdb_newdata_20220926 --outdir ./test  --esm2_ckpt_host_path /mnt/Data/trained_models/ESM2"
  exit 1
}

# Function to print timestamp
print_timestamp() {
  date +"%Y%m%d-%H%M%S"  # e.g. 20240318-085729
}

# Define severity levels
declare -A severity_levels
severity_levels=(
  [DEBUG]=10
  [INFO]=20
  [WARNING]=30
  [ERROR]=40
)

# Print message with time only if level is greater than INFO, to stderr
MINLOGLEVEL="INFO"
print_msg() {
  local message="$1"
  local level=${2:-INFO}

  if [[ ${severity_levels[$level]} -ge ${severity_levels[$MINLOGLEVEL]} ]]; then
    >&2 echo "[$level] $(print_timestamp): $1"        # showing messages
  else
    echo "[$level] $(print_timestamp): $message" >&2  # NOT showing messages
  fi
}

# read input (non-silent)
read_input() {
  echo -n "$1"
  read $2
}

# read input silently
read_input_silent() {
  echo -n "$1"
  read -s $2
  echo
}

ask_reset() {
  local varName=${1:-"it"}
  # do you want to reset?
  while true; do
    read_input "Do you want to reset ${varName}? [y/n]: " reset
    case $reset in
      [Yy]* )
        return 1
        break
        ;;
      [Nn]* )
        return 0
        break
        ;;
      * )
        echo "Please answer yes or no."
        ;;
    esac
  done
}

# a function to get file name without the extension
function getStemName() {
  local file=$1
  baseName=$(basename $file)
  echo ${baseName%.*}
}

##############################################################################
# CONFIG                                                                     #
##############################################################################
BASE=$(dirname $(realpath $0))

##############################################################################
# INPUT                                                                      #
##############################################################################
# Default vars
imageName="tfold:latest"

# Parse command line options
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --csv_file | -f)
      csvFile="$2"
      shift 2;; # (Required) Path to the csv file
    --outdir | -o)
      outDir="$2"
      shift 2;; # (Optional) output dir, default to a folder named output under the current directory
    --data_folder | -data)
      DATADIR="$2"
      shift 2;; # (Required) Data folder for tfold
    --af_param_folder | -afparam)
      AFPARAMDIR="$2"
      shift 2;; # (Required) AlphaFold parameter folder
    --date_cutoff | -date)
      dateCutoff="$2"
      shift 2;; # (Optional) Date cutoff for template search
    --image_name | -I)
      imageName="$2"
      shift 2;; # past argument and value
    --level)
      MINLOGLEVEL="$2"
      shift 2;; # past argument and value
    --help|-h)
      usage
      shift # past argument
      exit 1;;
    *)
      echo "Illegal option: $key"
      usage
      exit 1;;
  esac
done

# ensures the output directory exists
mkdir -p $outDir

# assert input file exists
[[ -f $csvFile ]] || { print_msg "Input file $csvFile does not exist"; exit 1; }
[[ -z $DATADIR ]] && { print_msg "Data folder $DATADIR is not set"; exit 1; }
[[ ! -d $DATADIR ]] && { print_msg "Data folder $DATADIR does not exist"; exit 1; }
[[ -z $AFPARAMDIR ]] && { print_msg "AlphaFold parameter folder $AFPARAMDIR is not set"; exit 1; }
[[ ! -d $AFPARAMDIR ]] && { print_msg "AlphaFold parameter folder $AFPARAMDIR does not exist"; exit 1; }
# if dateCutoff is not set, set $dateCutoff to ""
[[ -z $dateCutoff ]] && dateCutoff=""

##############################################################################
# MAIN                                                                       #
##############################################################################
# turn paths into realpath
outDir=$(realpath $outDir)
csvFile=$(realpath $csvFile)
DATADIR=$(realpath $DATADIR)

# ensure the image exists
if ! docker image inspect $imageName &> /dev/null; then
  print_msg "Docker image $imageName does not exist"
  exit 1
fi

# make a temp directory with prefix tfold-input
tmpDir=$(mktemp -d -t tfold-input-XXXXXXXXXX)

# copy input files there
cp $csvFile $tmpDir
fn=$(basename $csvFile)

echo "csvFile: $csvFile"
echo "outDir: $outDir"
echo "DATADIR: $DATADIR"
echo "AFPARAMDIR: $AFPARAMDIR"
echo "dateCutoff: $dateCutoff"
echo "imageName: $imageName"
echo "tmpDir: $tmpDir"



# run the container
docker run --rm \
  --gpus '"device=0"' \
  -v $tmpDir:/input \
  -v $outDir:/output \
  -v $DATADIR:/tfold-src/data \
  -v $AFPARAMDIR:/tfold-src/alphafold/parameters/params \
  $imageName \
  --csv_file /input/$fn \
  --outdir /output \
  --date_cutoff $dateCutoff