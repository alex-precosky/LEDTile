import base64
from PIL import Image, ImageSequence
import requests
import urllib.request
import json
import time

POST_TIMEOUT_SECONDS = 1


# Throws TimeoutError if the http request times out
def send_set_animation_frame(frame_index, frame, destination_host):
    destination_url = f"http://{destination_host}/setAnimationFrame"

    rgb_pixels = bytearray(3*1024)
    pixel_counter = 0

    frame = frame.resize((32, 32), Image.BICUBIC)
    frame = frame.convert(mode="RGBA")

    for col in range(32):
        for row in range(32):

            pixel = frame.getpixel((row, col))

            rgb_pixels[pixel_counter] = pixel[0]
            rgb_pixels[pixel_counter+1] = pixel[1]
            rgb_pixels[pixel_counter+2] = pixel[2]
            pixel_counter += 3

    image_base64 = base64.b64encode(rgb_pixels)
    payload = {"frame_index": frame_index,
               "image_base64": image_base64.decode("utf-8")}

    try:
        requests.post(destination_url, data=json.dumps(payload),
                      timeout=POST_TIMEOUT_SECONDS)
    except requests.exceptions.ConnectTimeout:
        raise TimeoutError

    time.sleep(0.1)


def send_start_animation(num_frames, delay_ms, destination_host):
    destination_url = f"http://{destination_host}/startAnimation"

    payload = {"num_frames": num_frames, "delay_ms": delay_ms}
    try:
        requests.post(destination_url, data=json.dumps(payload),
                      timeout=POST_TIMEOUT_SECONDS)
    except requests.exceptions.ConnectTimeout:
        raise TimeoutError


def get_scaled_image(image_url):
    # get image data
    response = urllib.request.urlopen(image_url)
    img_data = response

    # use PIL Image.open or something
    img = Image.open(img_data)

    return img
