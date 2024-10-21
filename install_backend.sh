#!/bin/bash

# Clone the stable-diffusion-webui repository
echo "Cloning stable-diffusion-webui repository..."
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui

# Clone additional extensions into the 'extensions' directory
echo "Cloning additional extensions..."
git clone https://github.com/huchenlei/sd-forge-ic-light.git stable-diffusion-webui/extensions/sd-forge-ic-light
git clone https://github.com/huchenlei/sd-webui-model-patcher.git stable-diffusion-webui/extensions/sd-webui-model-patcher
git clone https://github.com/John-WL/sd-webui-inpaint-background.git stable-diffusion-webui/extensions/sd-webui-inpaint-background
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git stable-diffusion-webui/extensions/stable-diffusion-webui-rembg

# Copy custom api.py file
echo "Copying custom api.py..."
if [ -f modules/api/api.py ]; then
    cp modules/api/api.py stable-diffusion-webui/modules/api/api.py
    echo "Custom api.py copied successfully."
else
    echo "Custom api.py does not exist."
    exit 1
fi

## Navigate into the stable-diffusion-webui directory
#cd stable-diffusion-webui || {
#    echo "Directory stable-diffusion-webui does not exist."
#    exit 1
#}
#
## Set the environment variable for command line arguments
#export COMMANDLINE_ARGS="--api --xformers"
#
### Run the web UI
##echo "Starting the web UI..."
##./webui.sh &