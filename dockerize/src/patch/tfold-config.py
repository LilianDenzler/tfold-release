### SET THESE DIRECTORIES ################################################################################

# tfold data folder
# e.g. '/data/vmikhayl/tfold-release/data'
data_dir = "/tfold-src/data"

# a tmp folder to store data from blastp alignments
seq_tools_tmp_dir = "/tfold-src/tmp"
##########################################################################################################

# seq_tools
seq_tools_data_dir = f"{data_dir}/seq_tools"

# TFold comes with a python wrapper for netMHCpan-4.1/IIpan-3.4,4.0.
# If you want to use it, set variables below. Otherwise, these variables aren't be used.

# path to templates
template_source_dir = f"{data_dir}/experimental_structures/processed_updated"

# seqnn settings
seqnn_params = {
    "max_core_len_I": 12,  # peptide input length is this +2  #(core truncation, indep from reg number)
    "max_pep_len_I": 15,  # to set max number of registers   #(reg number)
    "max_pep_len_II": 25,  # to set max number of registers
    "n_mhc_I": 26,  # mhc pseudoseq length
    "n_mhc_II": 30,  # mhc pseudoseq length
    "n_tail_bits": 3,  # n bits to encode tails; shared between cl 1 and 2
}

# seqnn params, weights and model lists
seqnn_obj_dir = f"{data_dir}/obj/seqnn"

# parameters for making AlphaFold inputs
af_input_params = {
    "I": {
        "templates_per_register": 20,
        "pep_gap_penalty": 1,
        "mhc_cutoff": 20,
        "score_cutoff": None,
        "kd_threshold": 10.0,
        "use_mhc_msa": False,
        "use_paired_msa": True,
        "tile_registers": False,
        "shuffle": False,
    },
    "II": {
        "templates_per_register": 20,
        "pep_gap_penalty": 1,
        "mhc_cutoff": 25,
        "score_cutoff": None,
        "kd_threshold": 100.0,
        "use_mhc_msa": False,
        "use_paired_msa": True,  # added 2022-11-22 (discovery run_11)
        "tile_registers": False,
        "shuffle": False,
    },
}
