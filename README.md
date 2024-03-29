# GDClip: Clip + Godot

**Status: Unsupported as a similar feature now exists in Godot 4.2!**

Version: v0.2

Language: GDNative (C++)

Tested on Godot Engine v3.4.x (Windows + Linux/X11 + macOS)

GDClip is a Windows/macOS/Linux copy/paste clipboard library wrapper of
[clip](https://github.com/dacap/clip) for Godot programs.

This repo also includes a small demo featuring paste functionality and
unit tests.

## Dependencies

- Common: `make`, `scons`, `git`
- Linux: `gcc`, `libx11-dev`/`libx11-devel`, `libpng-dev`/`libpng-devel`
- macOS: Command Line Tools for Xcode
- Windows: `MSYS2`, `mingw-w64-cross-gcc`

## Building and Running Demo

0. Install required dependencies for your platform.

```
# Windows w/ MSYS2
pacman -S mingw-w64-cross-gcc scons make git
# macOS w/ Command Line Tools for Xcode
pip3 install scons
# Arch Linux
sudo pacman -S gcc libx11 libpng git make scons
```

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

If cross-compiling, see [Wiki](https://github.com/hansemro/GDClip/wiki) for
more information.

## GDClip API

### get_version

```
String get_version()
```

Returns GDClip library version as Godot String.

### clear

```
bool clear()
```

Clears clipboard content and returns true if successful.

### get_text

```
String get_text()
```

Returns text content from clipboard as Godot String.

If there is no text in the clipboard, then an empty String is returned.

### set_text

```
bool set_text(String text)
```

Set text in clipboard and returns true if successful.

If text is empty, then this function should return true.

### has_image

```
bool has_image()
```

Returns true if clipboard contains an image and false otherwise.

### get_image_size

```
PoolIntArray get_image_size()
```

Returns `[width, height]` of image in clipboard as PoolIntArray.

If there is no image, then this function returns `[0, 0]`.

### get_image_as_pbarray

```
PoolByteArray get_image_as_pbarray()
```

Returns PoolByteArray containing RGBA8888 values of the image in the clipboard.

If there is no image in the clipboard, then this function returns an empty
PoolByteArray.

### set_image_from_pbarray

```
bool set_image_from_pbarray(PoolByteArray image, uint32_t width, uint32_t height)
```

Set image in clipboard from PoolByteArray and returns true if successful.

Returns false if width or height is zero, or if PoolByteArray image size is
less than `width*height*sizeof(uint32_t)`.

## Usage in GDScript Project

1. Clone repo inside Godot project and build library file(s) at `GDClip/bin`

```
git clone https://github.com/hansemro/GDClip
cd GDClip
make PLATFORM=<linux|osx|windows> build
```

2. Create gdclip.gdnlib (in `GDClip/bin/`) containing the following:

```
[general]

singleton=true
load_once=true
symbol_prefix="godot_"
reloadable=false

[entry]

X11.64="res://GDClip/bin/x11/libgdclip.so"
Windows.64="res://GDClip/bin/win64/libgdclip.dll"
OSX.64="res://GDClip/bin/osx/libgdclip.dylib"

[dependencies]

X11.64=[]
Windows.64=[]
OSX.64=[]
```

Update library paths if necessary.

3. Create gdclip.gdns file (in `GDClip/bin/`) containing the following:

```
[gd_resource type="NativeScript" load_steps=2 format=2]

[ext_resource path="res://GDClip/bin/gdclip.gdnlib" type="GDNativeLibrary" id=1]

[resource]
resource_name = "gdclip"
class_name = "GDClip"
library = ExtResource( 1 )
```

Update path if necessary.

4. Load `gdclip.gdns` as a resource in an appropriate GDScript file.

```
onready var gdclip = preload("res://GDClip/bin/gdclip.gdns").new()
```

5. Access GDClip API functions as needed.

```
# get text from clipboard
var text = gdclip.get_text()

# write text to clipboard
gdclip.set_text("Hello World")

# clear clipboard
gdclip.clear()

# get image and image size from clipboard and add to scene
var pbarray = gdclip.get_image_as_pbarray()
var size = gdclip.get_image_size()
var image = Image.new()
image.create_from_data(size[0], size[1], false, Image.FORMAT_RGBA8, pbarray)
var texture = ImageTexture.new()
texture.create_from_image(image)
var spr = Sprite.new()
spr.set_texture(texture)
spr.position = Vector2(100, 100)
SomeScene.add_child(spr)
```

## License
- [clip](https://github.com/dacap/clip): MIT
- [godot-cpp](https://github.com/godotengine/godot-cpp): MIT
