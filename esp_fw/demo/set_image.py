import requests
import json
import base64

# example using /setImage to set the entire image of the display at once

host = "192.168.0.21"
url = f"http://{host}/setImage"


rgb_pixels = bytearray(3*1024)
pixel_counter = 0

for i in range(32):
    for j in range(32):
        rgb_pixels[pixel_counter] = i*8   # r
        rgb_pixels[pixel_counter+1] = j*8 # g
        rgb_pixels[pixel_counter+2] = 0   # b
        pixel_counter += 3

image_base64 = base64.b64encode(rgb_pixels)
payload = {"image_base64": image_base64.decode("utf-8") }

#print(json.dumps(payload ))
r = requests.post(led_panel_url, data=json.dumps(payload))
