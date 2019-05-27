import argparse
from PIL import Image, ImageSequence
from PyQt5.QtWidgets import (QApplication, QWidget, QLineEdit,
                             QPushButton, QLabel, QHBoxLayout)
import sys
import time
from pyLEDPanelLib.pyLEDPanel import get_scaled_image, send_set_animation_frame, send_start_animation

HOST = "192.168.0.119"

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
        show_url_image(image_url, HOST)
        self.qleURL.clear()

def parse_arguments():
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('--url', )
    return parser.parse_args()


def show_url_image(image_url, led_panel_url):
    img = get_scaled_image(image_url)
    print("Ìmage received")

    num_frames = 0
    for frame in ImageSequence.Iterator(img):
        print(f"Sending frame {num_frames}")
        send_set_animation_frame(num_frames, frame, led_panel_url)
        time.sleep(0.1)
        num_frames += 1

    print("Starting animation")
    send_start_animation(num_frames,100, HOST)


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
