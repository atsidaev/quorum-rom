#!/usr/bin/env python3

from PIL import Image
import math
import sys

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

def bin_to_png(bin_file_name, png_file_name):
    # Png is always 8 chars width (64 px)
    CHARS_X = 8
    WIDTH = CHARS_X * 8

    font = open(bin_file_name, "rb").read()
    height = math.ceil(len(font) / 8)
    chars_y = height // 8
    result = Image.new("RGB", (WIDTH, height), WHITE)

    pos = 0
    for cy in range(chars_y):
        for cx in range(CHARS_X):
            for line in range(8):
                if pos < len(font):
                    mask = 0x80
                    for i in range(8):
                        result.putpixel((cx * 8 + i, cy * 8 + line), BLACK if font[pos] & mask else WHITE)
                        mask >>= 1
                    pos += 1

    result.save(png_file_name)

def png_to_bin(png_file_name, bin_file_name):
    img = Image.open(png_file_name)
    result = []

    assert img.height % 8 == 0
    assert img.width % 8 == 0

    chars_y = img.height // 8
    chars_x = img.width // 8

    for cy in range(chars_y):
        for cx in range(chars_x):
            for line in range(8):
                line_byte = 0
                mask = 0x80
                for i in range(8):
                    if img.getpixel((cx * 8 + i, cy * 8 + line)) != WHITE:
                        line_byte |= mask
                    mask >>= 1
                result.append(line_byte)
    open(bin_file_name, "wb").write(bytes(result))

if len(sys.argv) != 3:
    print("Usage: fontbin <source.bin> <destination.png>")
    print("   Or: fontbin <source.png> <destination.bin>")
    exit(1)

p1 = sys.argv[1]
p2 = sys.argv[2]
if p1.lower().endswith(".png"):
    png_to_bin(p1, p2)
else:
    bin_to_png(p1, p2)