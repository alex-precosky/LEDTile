import argparse
from PIL import ImageSequence
from PyQt5.QtWidgets import (QApplication, QWidget, QLineEdit,
                             QPushButton, QLabel, QHBoxLayout)
import sys
import time
from pyLEDPanelLib.pyLEDPanel import (get_image_from_url,
                                      send_set_animation_frame,
                                      send_start_animation)

# Keeping the LED tile on a static IP address. Could also try zeroconf but
# didn't have much luck with that working across OSs
HOST = "192.168.0.117"


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
    img = get_image_from_url(image_url)
    print("Ìmage received")

    num_frames = 0
    for frame in ImageSequence.Iterator(img):
        print(f"Sending frame {num_frames}")

        try:
            send_set_animation_frame(num_frames, frame, led_panel_url)
        except TimeoutError:
            print("HTTP Request timed out")
            return

        time.sleep(0.1)
        num_frames += 1

    delay_ms = 100
    print(f"Starting animation. {num_frames} frames, {delay_ms} ms frame delay")
    try:
        send_start_animation(num_frames, delay_ms, HOST)
    except TimeoutError:
        print("HTTP Request timed out")
        return


def do_gui_prompt():
    app = QApplication(sys.argv)

    # Do not delete `gui` - it needs to keep existing
    gui = ShowImageURLWindow()
    app.exec_()


if __name__ == "__main__":

    ARGS = parse_arguments()

    if ARGS.url is not None:
        IMAGE_URL = ARGS.url
        show_url_image(IMAGE_URL, HOST)
    else:
        do_gui_prompt()
