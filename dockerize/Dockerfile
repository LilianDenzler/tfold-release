# Use the NVIDIA CUDA base image
# FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# Set the working directory
WORKDIR /tfold-release

# Install zsh, sudo, curl, wget, and other utilities
RUN apt-get update && apt-get install -yq zsh sudo curl wget jq vim git-core gnupg locales && apt-get clean

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true \
    && sudo chsh -s /bin/zsh

# Set zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Arguments for Conda installation
ARG CONDA_VER=latest
ARG PLATFORM=Linux
ARG OS_TYPE=x86_64

# ------------------------------------------------------------------------------
# Install Miniconda
# ------------------------------------------------------------------------------
RUN curl -LO "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-${PLATFORM}-${OS_TYPE}.sh" \
    && bash Miniconda3-${CONDA_VER}-${PLATFORM}-${OS_TYPE}.sh -p /miniconda -b \
    && rm Miniconda3-${CONDA_VER}-${PLATFORM}-${OS_TYPE}.sh

# Update Conda and set the environment path
ENV PATH=/miniconda/bin:${PATH}

# ------------------------------------------------------------------------------
# Install dependencies
# ------------------------------------------------------------------------------
# install blastp
RUN apt update && apt install -y ncbi-blast+

# RUN apt-get update \
#   && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#       build-essential \
#       cmake \
#       cuda-command-line-tools-11-6 \
#       kalign \
#   && rm -rf /var/lib/apt/lists/* \
#   && apt-get autoremove -y \
#   && apt-get clean

# ------------------------------------------------------------------------------
# Main tfold
# ------------------------------------------------------------------------------
# Install the Conda environment from the environment.yml file
COPY dockerize/tfold-env.yml .
RUN conda env create -f tfold-env.yml

# COPY src files from the host to the container
RUN mkdir /tfold-src
# placeholder to mount the data directory from the host
RUN mkdir /tfold-src/data
RUN mkdir /tfold-src/data/seq_tools
# other placeholder directories
RUN mkdir -p /tfold-src/tmp
RUN mkdir -p /tfold-src/alphafold/parameters/params
# copy src files
COPY ./collect_results.py              /tfold-src
COPY ./model_pmhcs.py                  /tfold-src
COPY ./tfold_msa_tools.py              /tfold-src
COPY ./tfold_run_alphafold.py          /tfold-src
COPY ./tfold                           /tfold-src/tfold
COPY ./tfold_patch                     /tfold-src/tfold_patch
COPY ./alphafold/alphafold             /tfold-src/alphafold
COPY ./alphafold/LICENSE               /tfold-src/alphafold
COPY ./alphafold/README.md             /tfold-src/alphafold
COPY ./alphafold/CONTRIBUTING.md       /tfold-src/alphafold
COPY ./alphafold/run_alphafold_test.py /tfold-src/alphafold
COPY ./alphafold/requirements.txt      /tfold-src/alphafold
COPY ./alphafold/setup.py              /tfold-src/alphafold
COPY ./alphafold/run_alphafold.py      /tfold-src/alphafold
# patch config.py
COPY ./dockerize/src/patch/tfold-config.py /tfold-src/tfold/config.py
COPY ./dockerize/src/patch/tfold-patch-config.py /tfold-src/tfold_patch/tfold_config.py
# ENTRYPOINT file
COPY ./dockerize/src/entrypoint/run-tfold.sh /tfold-src/

# Make sure the bash script is executable
RUN chmod +x /tfold-src/run-tfold.sh

# ENTRYPOINT
WORKDIR /tfold-src
ENTRYPOINT [ "zsh", "run-tfold.sh" ]