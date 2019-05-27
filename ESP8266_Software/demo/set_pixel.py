import requests
import json

# example using /setPixel to set every pixel in the display

host = "192.168.0.21"
url = f"http://{host}/setPixel"

for i in range(32):
    for j in range(32):
        payload = {"x": i, "y":j, "r": i*8, "g": j*8, "b": 0}
        r = requests.post(url, data=json.dumps(payload) )

