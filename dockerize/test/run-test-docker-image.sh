#!/bin/zsh

BASE=$(realpath $(dirname $0))
ROOT=$(dirname $(dirname $BASE))  # root of the project
DATADIR=$(realpath $ROOT/data)
AFPARAMDIR='/mnt/bob/shared/alphafold/params'
imageName="tfold:latest"

# ------------------------------------------------------------------------------
# Test case 1
# ------------------------------------------------------------------------------
docker run --rm \
  --gpus '"device=1"' \
  -v $BASE/input:/input \
  -v $BASE/out:/output \
  -v $DATADIR:/tfold-src/data \
  -v $AFPARAMDIR:/tfold-src/alphafold/parameters/params \
  $imageName \
  --csv_file /input/pMHC_sequence.csv \
  --outdir /output \
  --date_cutoff "" \
  --inference


# ------------------------------------------------------------------------------
# Test case 2
# ------------------------------------------------------------------------------
# docker run --rm \
#   --gpus '"device=0"' \
#   -v $BASE/input:/input \
#   -v $BASE/out-vdj:/output \
#   -v $DATADIR:/tfold-src/data \
#   -v $AFPARAMDIR:/tfold-src/alphafold/parameters/params \
#   $imageName \
#   --csv_file /input/VDJDB_pMHC_input.csv \
#   --outdir /output \
#   --date_cutoff ""