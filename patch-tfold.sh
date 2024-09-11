#!/bin/zsh

# ----------------------------------------
# correct paths in tfold/config.py
# ----------------------------------------
dataDir=$(realpath ./data)
seq_tools_tmp_dir=$(realpath /tmp)
# sed
sed -i "s|data_dir='.*'|data_dir='$dataDir'|" tfold/config.py
sed -i "s|seq_tools_tmp_dir='.*'|seq_tools_tmp_dir='$seq_tools_tmp_dir'|" tfold/config.py

# ----------------------------------------
# correct paths in tfold_patch/tfold_config.py
# ----------------------------------------
dataDir=$(realpath ./alphafold/parameters)
alphafoldDir=$(realpath ./alphafold)
tfoldDataDir=$(realpath ./data)
kalignBinary=$(realpath $(which kalign))
# sed
sed -i "s|data_dir='.*'|data_dir='$dataDir'|" tfold_patch/tfold_config.py
sed -i "s|alphafold_dir='.*'|alphafold_dir='$alphafoldDir'|" tfold_patch/tfold_config.py
sed -i "s|tfold_data_dir='.*'|tfold_data_dir='$tfoldDataDir'|" tfold_patch/tfold_config.py
sed -i "s|kalign_binary_path='.*'|kalign_binary_path='$kalignBinary'|" tfold_patch/tfold_config.py
