# Test built image

To run the test scripts, you need to create the output directories because they are
mounted to the container. You can do this by running the following commands:

```bash
# if use docker
mkdir -p ./out

# if use apptainer
mkdir -p ./out-apptainer
```

If use the input file ./input/pMHC_sequence.csv, running either the docker or singularity container, you will expect the following outputs in a new directory `./out` or `./out-apptainer`:

## Expected output

