#!/bin/zsh

BASE=$(realpath $(dirname $0))   # ~/tfold-release/dockerize/test
ROOT=$(dirname $(dirname $BASE)) # root of the project
DATADIR=$(realpath $ROOT/data)
AFPARAMDIR='/mnt/bob/shared/alphafold/params'
apptainerImageFile=$(dirname $BASE)/'tfold-apptainer.sif' # ~/tfold-release/dockerize

# ------------------------------------------------------------------------------
# Run apptainer container
# ------------------------------------------------------------------------------
CUDA_VISIBLE_DEVICES=0 apptainer exec --nv \
  --bind $BASE/input:/input \
  --bind $BASE/out-apptainer:/output \
  --bind $DATADIR:/tfold-src/data \
  --bind $AFPARAMDIR:/tfold-src/alphafold/parameters/params \
  --pwd /tfold-src \
  $apptainerImageFile \
  zsh ./run-tfold.sh \
  --csv_file /input/tfold_input_mhcallele_with_seqtest.csv \
  --outdir /output \
  --inference
