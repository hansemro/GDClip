// SPDX-License-Identifier: MIT
/*
 * Copyright (c) 2022 Hansem Ro <hansemro@outlook.com>
 */

#include "gdclip.h"
#include <string.h>

using namespace godot;

void GDClip::_register_methods() {
    register_method("get_text", &GDClip::get_text);
    register_method("has_image", &GDClip::has_image);
    register_method("get_image_size", &GDClip::get_image_size);
    register_method("get_image_as_pbarray", &GDClip::get_image_as_pbarray);
}

GDClip::GDClip() {
}

GDClip::~GDClip() {
}

void GDClip::_init() {
    return;
}

String GDClip::get_text() {
    std::string text;

    if (clip::get_text(text))
        return String(text.c_str());

    return String();
}

bool GDClip::has_image() {
    return clip::has(clip::image_format());
}

Vector2 GDClip::get_image_size() {
    clip::image img;
    if (GDClip::has_image() && clip::get_image(img)) {
        return Vector2(img.spec().width, img.spec().height);
    }
    return Vector2(0, 0);
}

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
