import argparse
import urllib.request
from PIL import Image
import requests
import json
import base64
from PyQt5.QtWidgets import (QApplication, QWidget, QLineEdit,
                             QPushButton, QLabel, QHBoxLayout)
import sys


HOST = "192.168.0.11"
LED_PANEL_URL = f"http://{HOST}/setImage"


class ShowImageURLWindow(QWidget):

    def __init__(self):
        super().__init__()

        hbox = QHBoxLayout()

        lbl1 = QLabel('URL:')

        self.qleURL = QLineEdit()

        btn = QPushButton('Ok!')
        btn.resize(btn.sizeHint())
        btn.clicked.connect(self.handle_ok)

        hbox.addWidget(lbl1)
        hbox.addWidget(self.qleURL)
        hbox.addWidget(btn)
        self.setLayout(hbox)

        self.setGeometry(300, 100, 700, 100)
        self.setWindowTitle('LED Panel URL Getter')

        self.show()

    def handle_ok(self):
        image_url = self.qleURL.text()
        show_url_image(image_url, LED_PANEL_URL)
        self.qleURL.clear()

def parse_arguments():
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('--url', )
    return parser.parse_args()


def show_url_image(image_url, led_panel_url):
    # get image data
    response = urllib.request.urlopen(image_url)
    img_data = response

    # use PIL Image.open or something
    img = Image.open(img_data)

    img = img.resize((32,32), Image.BICUBIC)
    imgFrame = img.convert(mode="RGBA")


    rgb_pixels = bytearray(3*1024)
    pixel_counter = 0

    for col in range(32):
        for row in range(32):

            pixel = imgFrame.getpixel((row,col))

            rgb_pixels[pixel_counter] = pixel[0]
            rgb_pixels[pixel_counter+1] = pixel[1]
            rgb_pixels[pixel_counter+2] = pixel[2]
            pixel_counter += 3

            
    image_base64 = base64.b64encode(rgb_pixels)
    payload = {"image_base64": image_base64.decode("utf-8") }

    r = requests.post(led_panel_url, data=json.dumps(payload))


def do_gui_prompt():
    app = QApplication(sys.argv)

    gui = ShowImageURLWindow()
    app.exec_()

if __name__ == "__main__":


    ARGS = parse_arguments()
    
    if ARGS.url is not None:
        IMAGE_URL = ARGS.url
        show_url_image(IMAGE_URL, LED_PANEL_URL)
    else:
        do_gui_prompt()
