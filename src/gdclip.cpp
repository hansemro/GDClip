// SPDX-License-Identifier: MIT
/*
 * Copyright (c) 2022 Hansem Ro <hansemro@outlook.com>
 */

#include "gdclip.h"
#include <string.h>

using namespace godot;

void GDClip::_register_methods() {
    register_method("clear", &GDClip::clear);
    register_method("get_text", &GDClip::get_text);
    register_method("set_text", &GDClip::set_text);
    register_method("has_image", &GDClip::has_image);
    register_method("get_image_size", &GDClip::get_image_size);
    register_method("get_image_as_pbarray", &GDClip::get_image_as_pbarray);
    register_method("set_image_from_pbarray", &GDClip::set_image_from_pbarray);
}

GDClip::GDClip() {
}

GDClip::~GDClip() {
}

void GDClip::_init() {
    return;
}

/*
 * Clear clipboard contents and returns true if successful.
 */
bool GDClip::clear() {
    return clip::clear();
}

/*
 * Returns String containing text content from clipboard. If there is no text
 * in the clipboard, then this function returns an empty String object.
 */
String GDClip::get_text() {
    std::string text;

    if (clip::get_text(text))
        return String(text.c_str());

    return String();
}

/*
 * Set text in clipboard and returns true if successful.
 */
bool GDClip::set_text(String text) {
    return clip::set_text(text.utf8().get_data());
}

/*
 * Returns true if clipboard contains an image and false otherwise.
 */
bool GDClip::has_image() {
    return clip::has(clip::image_format());
}

/*
 * Returns PoolIntArray([width, height]) of image in the clipboard. If there is no
 * image in the clipboard, then this function returns PoolIntArray([0, 0]).
 */
PoolIntArray GDClip::get_image_size() {
    PoolIntArray size = PoolIntArray();
    clip::image_spec spec;
    if (GDClip::has_image() && clip::get_image_spec(spec)) {
        size.append(spec.width);
        size.append(spec.height);
    } else {
        size.append(0);
        size.append(0);
    }
    return size;
}

/*
 * Returns PoolByteArray containing image from clipboard. If there is no image
 * in the clipboard, then this function returns an empty PoolByteArray object.
 *
 * Note: clip::get_image retrieves an image in RGBA8888 format regardless of
 * image's original format (!?)
 */
PoolByteArray GDClip::get_image_as_pbarray() {
    PoolByteArray ret = PoolByteArray();
    clip::image img;
    if (GDClip::has_image() && clip::get_image(img)) {
        for (unsigned long y = 0; y < img.spec().height; ++y) {
            char* p = img.data() + img.spec().bytes_per_row * y;
            for (unsigned long x = 0; x < img.spec().width; ++x) {
                for (unsigned long byte = 0; byte < img.spec().bits_per_pixel/8; ++byte, ++p) {
                    ret.append((*p) & 0xff);
                }
            }
        }
    }
    return ret;
}

/*
 * Set image in clipboard from PoolByteArray and returns true if successful.
 * Returns false if width or height is zero.
 */
bool GDClip::set_image_from_pbarray(PoolByteArray rgba8_image, uint32_t width, uint32_t height) {
    if (width && height) {
        uint32_t *data = new uint32_t(width*height);
        clip::image_spec spec = {
            .width = width,
            .height = height,
            .bits_per_pixel = 32,
            .bytes_per_row = width*4,
            .red_mask = 0xff,
            .green_mask = 0xff00,
            .blue_mask = 0xff0000,
            .alpha_mask = 0xff000000,
            .red_shift = 0,
            .green_shift = 8,
            .blue_shift = 16,
            .alpha_shift = 24
        };
        for (unsigned long pixel = 0; pixel < width*height; ++pixel) {
            data[pixel] =   (rgba8_image[pixel*4 + 0] & 0xff);       // R
            data[pixel] |=  (rgba8_image[pixel*4 + 1] & 0xff) << 8;  // G
            data[pixel] |=  (rgba8_image[pixel*4 + 2] & 0xff) << 16; // B
            data[pixel] |=  (rgba8_image[pixel*4 + 3] & 0xff) << 24; // A
        }
        clip::image img(data, spec);
        return clip::set_image(img);
    }
    return false;
}
