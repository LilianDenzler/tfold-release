#!/bin/zsh

BASE=$(realpath $(dirname $0))
ROOT=$(dirname $(dirname $BASE))  # root of the project
DATADIR=$(realpath $ROOT/data)
AFPARAMDIR='/mnt/bob/shared/alphafold/params'
imageName="tfold:latest"

# ------------------------------------------------------------------------------
# Run docker container
# ------------------------------------------------------------------------------
docker run --rm \
  --gpus '"device=0"' \
  -v $BASE/input:/input \
  -v $BASE/out-docker:/output \
  -v $DATADIR:/tfold-src/data \
  -v $AFPARAMDIR:/tfold-src/alphafold/parameters/params \
  $imageName \
  --csv_file /input/tfold_input_mhcallele_with_seqtest.csv \
  --outdir /output \
  --inference
