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

# Cross-Compile for Windows on Linux

Status: Builds with MinGW cross-compiler and works with Wine.

1. Install mingw-w64.

```
# Arch Linux
sudo pacman -S mingw-w64-gcc
```

2. Run `make PLATFORM=windows build`.

3. Open demo in Godot and export Windows build.

4. Test build with wine and enjoy :)

# Cross-Compile for (x86_64) macOS/OSX on Linux

Status: Builds in Darling environment but untested.

1. Install darling.

```
# Arch Linux
yay -S darling-git
```

2. Download Command Line Tools for Xcode (12.4) from Apple Developer portal.

3. Install Command Line Tools in darling shell.

```
$ darling shell
Darling [.]$ hdiutil attach /path/to/Command_Line_tools_for_Xcode_12.4.dmg
Darling [.]$ cd /Volumes/Command_Line_Tools_for_Xcode_12.4/
Darling [.]$ /usr/bin/installer -pkg Command\ Line\ Tools.pkg -target /
```

4. Build library with `make PLATFORM=osx`.

5. Open demo in Godot and export OSX build.

6. Run in real OSX environment and enjoy :)

# License
- [clip](https://github.com/dacap/clip): MIT
- [godot-cpp](https://github.com/godotengine/godot-cpp): MIT
