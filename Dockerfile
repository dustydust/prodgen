FROM nvidia/cuda:11.8.0-base-ubuntu20.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update
RUN apt-get install -y \
    python3.10 \
    python3.10-distutils \
    python3-pip \
    python3.10-dev python3-opencv python3.10-venv \
    build-essential \
    git wget curl \
    libglib2.0-0 libgl1 libjpeg-dev zlib1g-dev libpng-dev \
    google-perftools \
    ffmpeg

# Set Python 3.10 as the default Python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
RUN python3 -m ensurepip --upgrade && \
    pip3 install --upgrade pip setuptools wheel

#ENV COMMANDLINE_ARGS="--xformers --api"
ENV REQS_FILE=requirements_docker.txt

# Fix for install torch in cuda docker container, need to install before torch and main reqs.txt
RUN pip3 install networkx==3.1

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .
RUN chmod +x webui.sh

# Clone additional extensions into the 'extensions' directory
RUN git clone https://github.com/huchenlei/sd-forge-ic-light.git extensions/sd-forge-ic-light && \
    git clone https://github.com/huchenlei/sd-webui-model-patcher.git extensions/sd-webui-model-patcher && \
    git clone https://github.com/John-WL/sd-webui-inpaint-background.git extensions/sd-webui-inpaint-background && \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git extensions/stable-diffusion-webui-rembg

# We need custom api.py because main repo have a bug that produce an error when we make
# api call outside from UI
COPY modules/api/api.py /app/modules/api/api.py
COPY requirements_docker.txt /app/requirements_docker.txt

# Expose the port for the web UI and the API
EXPOSE 7860

# Run the webui.sh script with the defined command-line arguments
CMD ["./webui.sh", "-f", "--listen", "--port", "7860", "--xformers", "--api"]
