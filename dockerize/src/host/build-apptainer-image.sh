#!/bin/bash

set -e

# Aim: Scrip to build tfold image
# Usage: Correct the root path and run the script

##############################################################################
# FUNCTION                                                                   #
##############################################################################
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

# NOTE: Change this ROOT path to your project root path
ROOT="/home/zcbtlm0/Scratch/tfold-release"

##############################################################################
# MAIN                                                                       #
##############################################################################
# chagne to the root directory of the project
cd $ROOT || exit 1 "Cannot change to the root directory of the project, check the ROOT path"

# [x] TODO: add command to build the image
sudo apptainer build ./dockerize/tfold-apptainer.sif ./dockerize/apptainer.def
