// SPDX-License-Identifier: MIT
/*
 * Copyright (c) 2022 Hansem Ro <hansemro@outlook.com>
 */

#ifndef GDCLIP_H
#define GDCLIP_H

#define LIBGDCLIP_VERSION "v0.1"

#include <Godot.hpp>
#include <Node.hpp>
#include "clip.h"

namespace godot {

class GDClip : public Node {
    GODOT_CLASS(GDClip, Node)

private:
    const char* version = LIBGDCLIP_VERSION;

public:
    static void _register_methods();

    GDClip();
    ~GDClip();

    void _init();

    String get_version();

    bool clear();

    String get_text();

    bool set_text(String text);

    bool has_image();

    PoolIntArray get_image_size();

    PoolByteArray get_image_as_pbarray();

    bool set_image_from_pbarray(PoolByteArray rgba8_image, uint32_t width, uint32_t height);
};

}

#endif
