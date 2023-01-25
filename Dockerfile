FROM  nvidia/cuda:10.1-cudnn8-devel-ubuntu18.04
SHELL ["/bin/bash", "-l", "-c"] 

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
#USER $USERNAME

RUN sudo apt-get update \
  && sudo apt-get install -y \
  wget \
  bzip2 \
  git \
  curl \
  unzip \
  file \
  xz-utils 

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"


RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 


COPY conda_requirements.yml /tmp/

RUN conda init bash
RUN conda install mamba -c conda-forge 
RUN mamba env create -f /tmp/conda_requirements.yml 
RUN echo "conda activate adv_ml" >> ~/.bashrc

RUN sudo apt-get autoremove -y && sudo apt-get clean && \
  rm -rf /usr/local/src/*

