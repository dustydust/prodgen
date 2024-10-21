# ProdGen

### Overview
That technology consist 2 parts:
- RunScript
- Backend (Automatic1111)

**RunScript** receive image, prompt from user and send it to **Backend** as JSON (image as base64)
**Backend** get an input (prompt and image, process it with given params and return back

![example with dark ambient colors](./examples/darks.png)
<p align="center">Example with dark ambient color and env transformation</p>

## Installation
### Ubuntu without Docker (or WSL2)

Consider you have installed python 3.8+

##### Backend

```
$ chmod +x install_backend.sh && chmod +x download_weights.sh
$ ./install_backend.sh
$ ./download_weights.sh
$ cd stable-diffusion-webui
$ COMMANDLINE_ARGS="--api --xformers" bash ./webui.sh &
```
`install_backend.sh` and `webui.sh` will take some time: download all packages, weights, extensions and create **venv** inside `./stable-diffusion-webui` directory. After you will see a message with exposed service on ```http://127.0.0.1:7860```

##### RunScript

```
$ chmod +x create_venv.sh
$ ./create_venv.sh
$ source venv/bin/activate
```
`create_venv.sh` will create **venv** to allow `run.py` make requests to **backend**

If you have different ENV manager like Anaconda, you can just run
```
$ pip install -r requirements.txt
```

### Docker
To run this with full docker support (consider that you use a Nvidia GPU and drivers that [support Docker](https://docs.docker.com/compose/how-tos/gpu-support/). Also works with WSL2)

```
$ chmod +x download_weights_docker.sh && ./download_weights_docker.sh
$ docker-compose up
```

That command will prepare and run AUTOMATIC1111 in Docker with GPU support. Please, be patient, script will download CUDA image, torch, safetensors, etc. It will take some time.
After you will see a message with exposed service with ```http://127.0.0.1:7860```

After docker compose you need to complete **RunScript** procedure


## Run
Inside `RunScript` env


```
$ (venv) python run.py --input_path out.png --output_path "outputs/run" --prompt "bag on the top of roof, sunny day, sunset and palms background"
```
Default output dir is `outputs/run`, if there just a dir, result image will be with mask `DDMMYYYY-HHMMSS.png` 


### Parameters to control

`input_path` - Input image to process

`output_path` - Directory/path to file to save processed image

`output_path` - Prompt to be generated


`more_details` - LoRA to control generated details

![](./examples/lora_more_details.png)

`lora_sdxl_render` - LoRA to control cinematic style (kind of universal LUT)

![](./examples/lora_sdxl_render.png)


#### Technical features

Floating objects:
- Manually point "what is it" and "where it is". 
  For example "A bag on the table". Assume that we have only one mask SD will generate what we expect (examples grid with random seed)
- Generate plane mask under the mask object. 
  For example, at the step when we get main object mask, we can calculate bottom boundary of object, so we can generate background with plane, then add the object with inpainting (shadows will appear), that apply IC light color correction to the whole scene
- Add special keywords to user prompt inside script 

"Cinematic" style
- At this moment with IC Light we ofter gen too bright and saturated colors, like applied LUT tables. We can change this with different pipeline and IMG2IMG processing, for example, without IC Light, or merge/blend image with original masked. Anyway, there are a lot of ways to do it with precise quality

Mask segmentation
- Because mask segmentation is hidden step inside IC Light pipeline, we can't control this, so result my vary
- Implement different steps with explicit mask segmentation (select models to object segmentation / background remove) 

##### TODO:

- [ ] Light control: position, type
- [ ] Outpainting implementation
- [ ] Upscaler
- [ ] Object segmentation control
- [ ] Cinematic / DSLR / Phone photo styles
- [ ] Implement sampler choice
- [ ] Batch processing
- [ ] Inference speedup
- [ ] Queue progress bar


