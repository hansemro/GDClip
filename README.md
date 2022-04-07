# GDClip: Clip + Godot

Language: GDNative (C++)

Tested on Godot Engine v3.4.3 (Linux/X11)

`clip` is a cross-platform copy/paste clipboard library with image support. This
demo leverages this library to enable image-paste functionality in Godot.

# Additional Dependencies

- Common: `make`
- Linux: `libx11-dev`/`libx11-devel`, `libpng-dev`/`libpng-devel`
- macOS: TODO
- Windows: TODO

# Building and Running Demo

TODO (Need to test on macOS + Windows before writing guide)

0. Install required dependencies for your platform.

1. Clone repo and build for your platform:

```
git clone https://github.com/hansemro/GDClip
cd GDClip
make PLATFORM=<linux|osx|windows> build
```

2. Open demo/project.godot in Godot.

3. Copy an image into clipboard before running demo.

If successful, you should see the image pasted in the center of the demo
window.

# GDClip Usage

TODO (Need to test on macOS + Windows before writing guide)

See src/gdclip.h for available functions.

See demo/Main.gd for example usage.

# License
- [clip](https://github.com/dacap/clip): MIT
- [godot-cpp](https://github.com/godotengine/godot-cpp): MIT
