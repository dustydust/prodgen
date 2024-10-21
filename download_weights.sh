#!/bin/bash

# Create the necessary directories
mkdir -p stable-diffusion-webui/models/ic-light
mkdir -p stable-diffusion-webui/models/u2net
mkdir -p stable-diffusion-webui/models/Lora

# Check and download the Juggernaut Reborn model
if [ ! -f "stable-diffusion-webui/models/Stable-diffusion/juggernaut_reborn.safetensors" ]; then
    echo "Downloading juggernaut_reborn..."
    curl --progress-bar -L -o stable-diffusion-webui/models/Stable-diffusion/juggernaut_reborn.safetensors \
        "https://civitai.com/api/download/models/274039?type=Model&format=SafeTensor&size=pruned&fp=fp16" || {
        echo "Failed to download Juggernaut Reborn model."
        exit 1
    }
else
    echo "Juggernaut Reborn model already exists. Skipping download."
fi

# Check and download IC-Light.SD15.FBC
if [ ! -f "stable-diffusion-webui/models/ic-light/IC-Light.SD15.FBC.safetensors" ]; then
    echo "Downloading IC-Light.SD15.FBC..."
    curl --progress-bar -L -o stable-diffusion-webui/models/ic-light/IC-Light.SD15.FBC.safetensors \
        "https://github.com/Haoming02/sd-forge-ic-light/releases/download/mdl/IC-Light.SD15.FBC.safetensors" || {
        echo "Failed to download FBC model."
        exit 1
    }
else
    echo "IC-Light.SD15.FBC already exists. Skipping download."
fi

# Check and download IC-Light.SD15.FC
if [ ! -f "stable-diffusion-webui/models/ic-light/IC-Light.SD15.FC.safetensors" ]; then
    echo "Downloading IC-Light.SD15.FC..."
    curl --progress-bar -L -o stable-diffusion-webui/models/ic-light/IC-Light.SD15.FC.safetensors \
        "https://github.com/Haoming02/sd-forge-ic-light/releases/download/mdl/IC-Light.SD15.FC.safetensors" || {
        echo "Failed to download FC model."
        exit 1
    }
else
    echo "IC-Light.SD15.FC already exists. Skipping download."
fi

# Check and download u2net_human_seg
if [ ! -f "stable-diffusion-webui/models/u2net/u2net_human_seg.onnx" ]; then
    echo "Downloading u2net_human_seg..."
    curl --progress-bar -L -o stable-diffusion-webui/models/u2net/u2net_human_seg.onnx \
        "https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_human_seg.onnx" || {
        echo "Failed to download u2net_human_seg.onnx."
        exit 1
    }
else
    echo "u2net_human_seg.onnx already exists. Skipping download."
fi

# Check and download more_details.safetensors
if [ ! -f "stable-diffusion-webui/models/Lora/more_details.safetensors" ]; then
    echo "Downloading more_details..."
    curl --progress-bar -L -o stable-diffusion-webui/models/Lora/more_details.safetensors \
        "https://huggingface.co/digiplay/LORA/resolve/fa075647d8164b327ba07e430bdb3fd02f147a62/more_details.safetensors" || {
        echo "Failed to download more_details.safetensors."
        exit 1
    }
else
    echo "more_details.safetensors already exists. Skipping download."
fi

# Check and download SDXLrender_v2.0.safetensors
if [ ! -f "stable-diffusion-webui/models/Lora/SDXLrender_v2.0.safetensors" ]; then
    echo "Downloading SDXLrender_v2.0..."
    curl --progress-bar -L -o stable-diffusion-webui/models/Lora/SDXLrender_v2.0.safetensors \
        "https://huggingface.co/philz1337x/loras/resolve/main/SDXLrender_v2.0.safetensors" || {
        echo "Failed to download SDXLrender_v2.0.safetensors."
        exit 1
    }
else
    echo "SDXLrender_v2.0.safetensors already exists. Skipping download."
fi
echo "Done"