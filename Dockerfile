FROM nvcr.io/nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

SHELL ["/bin/bash", "-lc"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git git-lfs build-essential pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && git lfs install

ENV CONDA_DIR=/opt/conda
RUN curl -fsSL -o /tmp/Anaconda3-2025.06-0-Linux-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2025.06-0-Linux-x86_64.sh && \
    bash /tmp/Anaconda3-2025.06-0-Linux-x86_64.sh -b -p ${CONDA_DIR} && \
    rm -f /tmp/Anaconda3-2025.06-0-Linux-x86_64.sh
ENV PATH=${CONDA_DIR}/bin:${PATH}

RUN conda update -n base -c defaults conda -y && \
    conda create -n sg_benchmark python=3.8 -y && \
    conda install -n sg_benchmark -c pytorch -y \
      pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=10.1 && \
    conda clean -afy

ENV CONDA_DEFAULT_ENV=sg_benchmark
ENV PATH=${CONDA_DIR}/envs/sg_benchmark/bin:${CONDA_DIR}/bin:${PATH}

WORKDIR /workspace
RUN git clone https://github.com/yesaouo/VinVLVisualBackbone_2025.git && \
    cd VinVLVisualBackbone_2025 && \
    git lfs pull && \
    python -m pip install -U --no-cache-dir pip && \
    pip install --no-cache-dir -r requirements.txt && \
    cd scene_graph_benchmark && \
    python setup.py build develop && \
    rm -rf /root/.cache/pip

WORKDIR /workspace/VinVLVisualBackbone_2025
CMD ["/bin/bash"]
