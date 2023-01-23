FROM  nvidia/cuda:10.1-cudnn8-devel-ubuntu18.04

RUN apt update \
    && apt install -y \
    wget \
    bzip2 \
    git \
    curl \
    unzip \
    file \
    xz-utils \
    sudo \
    python3 \
    python3-pip

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

COPY conda_requirements.yml /tmp/

RUN pip install --upgrade pip && \
    conda init && \
    conda install mamba -c conda-forge && \
    mamba env create -f /tmp/conda_requirements.yml && \
    echo "conda activate adv_ml" >> ~/.bashrc

RUN apt-get autoremove -y && apt-get clean && \
  rm -rf /usr/local/src/*

