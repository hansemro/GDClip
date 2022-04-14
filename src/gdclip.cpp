// SPDX-License-Identifier: MIT
/*
 * Copyright (c) 2022 Hansem Ro <hansemro@outlook.com>
 */

#include "gdclip.h"
#include <string.h>

#if defined(WINDOWS)
#define RED_MASK 0xff0000
#define GREEN_MASK 0xff00
#define BLUE_MASK 0xff
#define ALPHA_MASK 0xff000000
#define RED_SHIFT 16
#define GREEN_SHIFT 8
#define BLUE_SHIFT 0
#define ALPHA_SHIFT 24
#else
#define RED_MASK 0xff
#define GREEN_MASK 0xff00
#define BLUE_MASK 0xff0000
#define ALPHA_MASK 0xff000000
#define RED_SHIFT 0
#define GREEN_SHIFT 8
#define BLUE_SHIFT 16
#define ALPHA_SHIFT 24
#endif

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
#if defined(WINDOWS)
    if (text.length() == 0)
        return clip::clear();
#endif
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
 */
PoolByteArray GDClip::get_image_as_pbarray() {
    PoolByteArray ret = PoolByteArray();
    clip::image img;
    clip::image_spec spec;
    if (GDClip::has_image() && clip::get_image(img)) {
        spec = img.spec();
        uint8_t bpp = spec.bits_per_pixel;
#if defined(LINUX)
        if (!spec.alpha_mask && bpp == 32)
            bpp = 24;
#endif
        switch (bpp) {
        case 32:
            for (unsigned long y = 0; y < spec.height; ++y) {
                uint32_t *p = (uint32_t *)(img.data() + spec.bytes_per_row * y);
                for (unsigned long x = 0; x < spec.width; ++x, ++p) {
                    ret.append((*p & spec.red_mask) >> spec.red_shift);
                    ret.append((*p & spec.green_mask) >> spec.green_shift);
                    ret.append((*p & spec.blue_mask) >> spec.blue_shift);
                    ret.append((*p & spec.alpha_mask) >> spec.alpha_shift);
                }
            }
            break;
        case 24:
            for (unsigned long y = 0; y < spec.height; ++y) {
                uint32_t *p = (uint32_t *)(img.data() + spec.bytes_per_row * y);
                for (unsigned long x = 0; x < spec.width; ++x, ++p) {
                    ret.append((*p & spec.red_mask) >> spec.red_shift);
                    ret.append((*p & spec.green_mask) >> spec.green_shift);
                    ret.append((*p & spec.blue_mask) >> spec.blue_shift);
                    ret.append(255);
                }
            }
            break;
        }
    }
    return ret;
}

/*
 * Set image in clipboard from PoolByteArray and returns true if successful.
 * Returns false if width or height is zero or if pbarray image size is less
 * than width*height*4.
 */
bool GDClip::set_image_from_pbarray(PoolByteArray rgba8_image, uint32_t width, uint32_t height) {
    if (width && height && rgba8_image.size() >= width*height*4) {
        uint32_t *data = new uint32_t(width*height);
        clip::image_spec spec = {
            .width = width,
            .height = height,
            .bits_per_pixel = 32,
            .bytes_per_row = width*4,
            .red_mask = RED_MASK,
            .green_mask = GREEN_MASK,
            .blue_mask = BLUE_MASK,
            .alpha_mask = ALPHA_MASK,
            .red_shift = RED_SHIFT,
            .green_shift = GREEN_SHIFT,
            .blue_shift = BLUE_SHIFT,
            .alpha_shift = ALPHA_SHIFT
        };
        for (unsigned long pixel = 0; pixel < width*height; ++pixel) {
            data[pixel] = (rgba8_image[pixel*4 + 0] << RED_SHIFT) |
                          (rgba8_image[pixel*4 + 1] << GREEN_SHIFT) |
                          (rgba8_image[pixel*4 + 2] << BLUE_SHIFT) |
                          (rgba8_image[pixel*4 + 3] << ALPHA_SHIFT);
        }
        clip::image img(data, spec);
        return clip::set_image(img);
    }
    return false;
}
