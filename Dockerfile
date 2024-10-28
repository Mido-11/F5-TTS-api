# Use a PyTorch image with CUDA support
FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

# Set user and prevent interaction during installation
USER root
ARG DEBIAN_FRONTEND=noninteractive

LABEL github_repo="https://github.com/SWivid/F5-TTS"

# Install necessary libraries and dependencies
RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set up working directory and clone F5-TTS
WORKDIR /workspace
RUN git clone https://github.com/SWivid/F5-TTS.git \
    && cd F5-TTS \
    && pip install -e .[eval]

# Install Flask for serving the API
RUN pip install Flask

# Set the working directory to F5-TTS
WORKDIR /workspace/F5-TTS

# Expose port 5000 for the Flask API
EXPOSE 5000

# Set environment variable for shell
ENV SHELL=/bin/bash

# Run the Flask API server
CMD ["python", "tts_api.py"]
