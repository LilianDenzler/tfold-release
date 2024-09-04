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

```shell
out-docker
├── best_models.csv
├── inputs
│   └── input.pckl
├── outputs
│   ├── 0
│   │   ├── result_model_1_0.pkl
│   │   ├── result_model_1_1.pkl
│   │   ├── result_model_1_2.pkl
│   │   ├── result_model_1_3.pkl
│   │   ├── result_model_1_4.pkl
│   │   ├── structure_model_1_0.pdb
│   │   ├── structure_model_1_1.pdb
│   │   ├── structure_model_1_2.pdb
│   │   ├── structure_model_1_3.pdb
│   │   └── structure_model_1_4.pdb
│   └── 1
│       ├── result_model_1_0.pkl
│       ├── result_model_1_1.pkl
│       ├── result_model_1_2.pkl
│       ├── result_model_1_3.pkl
│       ├── result_model_1_4.pkl
│       ├── structure_model_1_0.pdb
│       ├── structure_model_1_1.pdb
│       ├── structure_model_1_2.pdb
│       ├── structure_model_1_3.pdb
│       └── structure_model_1_4.pdb
├── result_df.pckl
├── splits
│   └── split_aa.csv
├── target_df.pckl
├── tfold_input_mhcallele_with_seqtest_nounknown_above8.csv
└── tfold_input_mhcallele_with_seqtest_nounknown.csv

out-apptainer
├── best_models.csv
├── inputs
│   └── input.pckl
├── outputs
│   ├── 0
│   │   ├── result_model_1_0.pkl
│   │   ├── result_model_1_1.pkl
│   │   ├── result_model_1_2.pkl
│   │   ├── result_model_1_3.pkl
│   │   ├── result_model_1_4.pkl
│   │   ├── structure_model_1_0.pdb
│   │   ├── structure_model_1_1.pdb
│   │   ├── structure_model_1_2.pdb
│   │   ├── structure_model_1_3.pdb
│   │   └── structure_model_1_4.pdb
│   └── 1
│       ├── result_model_1_0.pkl
│       ├── result_model_1_1.pkl
│       ├── result_model_1_2.pkl
│       ├── result_model_1_3.pkl
│       ├── result_model_1_4.pkl
│       ├── structure_model_1_0.pdb
│       ├── structure_model_1_1.pdb
│       ├── structure_model_1_2.pdb
│       ├── structure_model_1_3.pdb
│       └── structure_model_1_4.pdb
├── result_df.pckl
├── splits
│   └── split_aa.csv
├── target_df.pckl
├── tfold_input_mhcallele_with_seqtest_nounknown_above8.csv
└── tfold_input_mhcallele_with_seqtest_nounknown.csv
```