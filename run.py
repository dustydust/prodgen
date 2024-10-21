import os
import io
import base64
import requests
import argparse
from PIL import Image
from datetime import datetime


def process_image(
        input_path: str,
        user_prompt: str,
        seed: int = -1,
        steps: int = 20,
        cfg_scale: float = 1.0,
        denoise_strength: float = 0.9,
        lora_details: float = 0.5,
        lora_sdxl_render: float = 0.5
    ):
    try:
        img = Image.open(input_path)
    except Exception as e:
        print(f"Failed to open image: {e}")
        return False

    img_width, img_height = img.size
    img_buffer = io.BytesIO()
    img.save(img_buffer, format="PNG")  # Save image to buffer
    img_binary = img_buffer.getvalue()  # Get binary data
    img_base64 = base64.b64encode(img_binary).decode('utf-8')  # Convert to base64

    prompt = f" \
             {user_prompt}, \
             masterpiece, best quality, highres, \
             <lora:more_details:{lora_details}> <lora:SDXLrender_v2.0:{lora_sdxl_render}>"

    payload = {
        "alwayson_scripts": {
            "IC Light": {
                "args": [
                    {
                        "bg_source_fbc": "Use Background Image",
                        "bg_source_fc": "None",
                        "detail_transfer": False,
                        "detail_transfer_blur_radius": 5,
                        "detail_transfer_use_raw_input": False,
                        "enabled": True,
                        "input_fg": img_base64,
                        "model_type": "IC-Light.SD15.FC",
                        "reinforce_fg": False,
                        "remove_bg": False,
                        "uploaded_bg": None
                    }
                ]
            },
            "Refiner": {"args": [False, "", 0.8]},
            "Sampler": {"args": [20, "DPM++ 2S a", "Automatic"]},
            "Seed": {"args": [-1, False, -1, 0, 0, 0]}
        },
        "batch_size": 1,
        "cfg_scale": cfg_scale,
        "comments": {},
        "denoising_strength": denoise_strength,
        "disable_extra_networks": False,
        "do_not_save_grid": False,
        "do_not_save_samples": False,
        "enable_hr": False,
        "height": img_height,
        "hr_negative_prompt": "",
        "hr_prompt": "",
        "hr_resize_x": 0,
        "hr_resize_y": 0,
        "hr_scale": 2,
        "hr_second_pass_steps": 0,
        "hr_upscaler": "Latent",
        "n_iter": 1,
        "negative_prompt": "(worst quality, low quality, normal quality:2, floating:2, floating object, float) JuggernautNegative-neg",
        "override_settings": {},
        "override_settings_restore_afterwards": True,
        "prompt": prompt,
        "restore_faces": False,
        "s_churn": 0.0,
        "s_min_uncond": 0.0,
        "s_noise": 1.0,
        "s_tmax": None,
        "s_tmin": 0.0,
        "sampler_name": "DPM++ 2S a",
        "scheduler": "Automatic",
        "script_args": [],
        "script_name": None,
        "seed": seed,
        "seed_enable_extras": True,
        "seed_resize_from_h": -1,
        "seed_resize_from_w": -1,
        "steps": steps,
        "styles": [],
        "subseed": -1,
        "subseed_strength": 0,
        "tiling": False,
        "width": img_width
    }

    try:
        print(f"Image processing...")
        response = requests.post(url='http://127.0.0.1:7860/sdapi/v1/txt2img', json=payload)
    except Exception as e:
        print(f"Failed to send request: {e}")
        return False

    if response.status_code == 200:
        base64_image = response.json()['images'][0]
        return base64_image
    else:
        print(f"Response error, code: {response.status_code}")
        return False


def save_base64_image(base64_str: str, output_path: str) -> bool:
    # Check if output_path is a directory
    if os.path.isdir(output_path):
        # If it's a directory, create the directory (if not exists) and use timestamp for the filename
        os.makedirs(output_path, exist_ok=True)
        timestamp = datetime.now().strftime("%d%m%Y-%H%M%S")
        output_file = os.path.join(output_path, f"{timestamp}.png")
    else:
        # If output_path includes a filename, extract the directory and use the provided filename
        output_dir = os.path.dirname(output_path)
        if output_dir:  # Ensure directory exists if part of the path
            os.makedirs(output_dir, exist_ok=True)
        output_file = output_path  # Use the provided path with filename
    # Decode the base64 string and save the image
    try:
        with open(output_file, "wb") as file:
            file.write(base64.b64decode(base64_str))
        print(f"Image saved to: {output_file}")
        return True
    except Exception as e:
        print(f"Failed to save image: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description='Process an image.')
    parser.add_argument('--input_path', type=str, required=True, help='Path to the input image')
    parser.add_argument('--output_path', type=str, default='outputs/run',
                        help='Directory where the output image will be saved')
    parser.add_argument('--prompt', type=str, required=True, help='User prompt description')
    parser.add_argument('--seed', type=int, default=-1)
    parser.add_argument('--cfg_scale', type=float, default=1.0, help='Recommended range [0.1 - 0.2]')
    parser.add_argument('--steps', type=int, default=20, help='Recommended range [20 - 40]')
    parser.add_argument('--denoise_strength', type=float, default=0.9, help='Recommended range [0.75 - 0.9]')
    parser.add_argument('--lora_details', type=float, default=0.5, help='Postprocessing. Recommended range [0.25 - 0.75]')
    parser.add_argument('--lora_sdxl_render', type=float, default=0.5, help='Postprocessing. Recommended range [0.25 - 1]')

    args = parser.parse_args()

    user_prompt = args.prompt
    print(f"User Prompt: {user_prompt}")

    base64_img = process_image(
        args.input_path,
        user_prompt=args.prompt,
        seed=args.seed,
        cfg_scale=args.cfg_scale,
        steps=args.steps,
        denoise_strength=args.denoise_strength,
        lora_details=args.lora_details,
        lora_sdxl_render=args.lora_sdxl_render
    )
    save_base64_image(base64_img, args.output_path)


if __name__ == "__main__":
    main()
