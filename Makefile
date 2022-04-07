# Platform options: linux, osx, windows
PLATFORM ?= linux
NPROC ?= 4

.PHONY: all
all: build

.PHONY: prep
clip:
	git submodule update --init clip
godot-cpp:
	git submodule update --init godot-cpp
	cd godot-cpp && scons platform=${PLATFORM} generate_bindings=yes -j${NPROC}
prep: clip godot-cpp

.PHONY: build
build: prep
	scons platform=${PLATFORM}

.PHONY: clean
clean:
	-rm demo/bin/*/*
	-rm clip/*.os
	-rm src/*.os
