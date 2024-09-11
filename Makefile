# Makefile for managing a Conda environment
.PHONY: update-env patch-tfold

# Path to the environment YAML file
ENV_FILE="tfold-env.yml"

# Update the Conda environment
update-env:
	conda env update -f ${ENV_FILE}

# Patch tfold
patch-tfold:
	@zsh patch-tfold.sh
