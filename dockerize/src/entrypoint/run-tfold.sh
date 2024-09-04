#!/bin/zsh

set -e

# Aim: Run tfold image entrypoint
# Input:
# Output:
# Usage:
# Example:
# Dependencies:

##############################################################################
# FUNCTION                                                                   #
##############################################################################
scriptName=$(basename $0)
function usage() {
  echo "Usage: $scriptName --csv_file <csv_file> --outdir <outdir> --date_cutoff <date_cutoff>"
  echo "  --csv_file    | -f    : Path to the csv file"
  echo "  --outdir      | -o    : Output directory, default to a folder named output under the current directory"
  echo "  --date_cutoff | -date : Date cutoff for template search, default to empty string '' "
  echo "  --inference   | -i    : Inference mode"
  echo "  --level               : Log level (default: INFO)"
  echo "  --help        | -h    : Print this help message"
  # add example
  echo "Example:"
  echo "$scriptName \\
    --csv_file /path/to/csv_file.csv \\
    --outdir /path/to/output \\
    --date_cutoff 2022-09-26"
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
# Set configuration variables
BASE=$(dirname $(realpath $0))

##############################################################################
# INPUT                                                                      #
##############################################################################
# default vars
outDir=$PWD/output
dateCutoff=""
inference=false

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
    --date_cutoff | -date)
      if [[ -n "$2" && "$2" != "--"* ]]; then
        dateCutoff="$2"
        shift 2
      else
        dateCutoff=""  # Set to empty string if no valid value is provided
        shift 1
      fi;;
    --inference | -i)
      inference=true
      shift;; # (Optional) Inference mode
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
# if dateCutoff is not set, set $dateCutoff to ""
[[ -z $dateCutoff ]] && dateCutoff=""
# ensure outDir exists
mkdir -p $outDir

# assert required arguments
[[ -z "$csvFile" ]] && { echo "Missing required argument: --csv_file"; usage; exit 1; }

##############################################################################
# MAIN                                                                       #
##############################################################################
# activate conda
print_msg "Activating conda environment ..."
conda init zsh > /dev/null
source /miniconda/etc/profile.d/conda.sh
conda activate tfold-env
print_msg "Activating conda environment ... Done"

# Extract just the filename from input_file
inputFilename=$(getStemName "$csvFile")

# Construct the path for the cleaned file
cleanedFile="${outDir}/${inputFilename}_nounknown.csv"
cleanedFile2="${outDir}/${inputFilename}_nounknown_above8.csv"

# Remove lines containing 'UNKNOWNSEQUENCE!' and save to a new file
grep -v 'UNKNOWNSEQUENCE!' "$csvFile" > "$cleanedFile"
# Remove rows where the length of 'pep' (assuming 'pep' is the first column) is 7
awk -F, 'NR==1 || (length($3) >= 7 && length($3) <= 15)' "$cleanedFile" > "$cleanedFile2"

LINES_PER_FILE=500
SPLIT_DIR="${outDir}/splits"
# Create output directory if it doesn't exist
mkdir -p "$SPLIT_DIR"
# Split the CSV file, keeping the header in each split file
HEADER=$(head -n 1 "$cleanedFile2")
tail -n +2 "$cleanedFile2" | split -l $LINES_PER_FILE - "$SPLIT_DIR/split_"

# Add header back to each split file
for file in "$SPLIT_DIR"/split_*; do
    echo "$HEADER" | cat - "$file" > "$file.csv"
    rm "$file"  # Remove the original file without the .csv extension
done

for file in "$SPLIT_DIR"/*.csv; do
  # Run the Python scripts
  # This creates the input files for the tfold_run_alphafold.py script
  # writes to $outDir/inputs/
  echo "Processing $file"
  print_msg "Running the model_pmhcs.py script ..."
  python model_pmhcs.py \
    "$file" \
    "$outDir"
  print_msg "Running the model_pmhcs.py script ... Done"

  print_msg "Running the tfold_run_alphafold.py script ..."
  # if inference is set to true, run the inference mode
  if [[ $inference == true ]]; then
    python tfold_run_alphafold.py \
      --inputs "$outDir/inputs/input.pckl" \
      --output_dir "$outDir/outputs" \
      --inference
  else
    python tfold_run_alphafold.py \
      --inputs "$outDir/inputs/input.pckl" \
      --output_dir "$outDir/outputs"
  fi
  print_msg "Running the tfold_run_alphafold.py script ... Done"

  print_msg "Running the collect_results.py script ..."
  python collect_results.py "$outDir"
  print_msg "Running the collect_results.py script ... Done"
done
echo "All done!"
