# Notes

This is an example of running tfold locally. Use this to test if your local setup is working correctly.

## run test

```bash
# go back to the root directory
cd ../  # ~/tfold-release
# run the test
mkdir -p ./tset/out
zsh run-tfold.sh -f test/input/tfold_input_mhcallele_with_seqtest.csv -o ./test/out
```

## Expected output

```plaintext
out
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
│   ├── 1
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
│   ├── 2
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
│   └── 3
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

