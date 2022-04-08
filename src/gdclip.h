// SPDX-License-Identifier: MIT
/*
 * Copyright (c) 2022 Hansem Ro <hansemro@outlook.com>
 */

#ifndef GDCLIP_H
#define GDCLIP_H

#include <Godot.hpp>
#include <Node.hpp>
#include "clip.h"

namespace godot {

class GDClip : public Node {
    GODOT_CLASS(GDClip, Node)

public:
    static void _register_methods();

    GDClip();
    ~GDClip();

    void _init();

    String get_text();

    bool has_image();

    PoolIntArray get_image_size();

    PoolByteArray get_image_as_pbarray();
};

}

#endif
