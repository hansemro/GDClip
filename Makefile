# Platform options: linux, osx, windows
PLATFORM ?= linux
NPROC ?= 4
# Target options: debug, release
TARGET ?= debug

MINGW64_PREFIX=x86_64-w64-mingw32-
CXXFLAGS = -O3 -std=c++14 -fPIC -I. -Igodot-cpp/ -Igodot-cpp/godot-headers -Igodot-cpp/include -Igodot-cpp/include/gen -Igodot-cpp/include/core -Iclip/
CLIP_CXXFLAGS = -O3 -std=c++14 -fPIC -Iclip/
LIBS = -Lgodot-cpp/bin
WIN64_LIBFLAGS = ${LIBS} -lgodot-cpp.windows.${TARGET}.64 -lshlwapi -lwindowscodecs -lole32 -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic
LINUX_LIBFLAGS = ${LIBS} -lgodot-cpp.linux.${TARGET}.64 -lpng -lpthread -lxcb
OSX_LIBFLAGS = ${LIBS} -lgodot-cpp.osx.${TARGET}.x86_64 -Wl,-framework,Cocoa

.PHONY: all
all: build

.PHONY: clip godot-cpp prep
clip:
	git submodule update --init clip
godot-cpp:
	git submodule update --init --recursive godot-cpp
godot-cpp/bin/libgodot-cpp.windows.${TARGET}.64.a:
	cd godot-cpp && scons use_mingw=yes platform=windows target=${TARGET} generate_bindings=yes -j${NPROC}
godot-cpp/bin/libgodot-cpp.linux.${TARGET}.64.a:
	cd godot-cpp && scons platform=linux target=${TARGET} generate_bindings=yes -j${NPROC}
godot-cpp/bin/libgodot-cpp.osx.${TARGET}.x86_64.a:
	cd godot-cpp && scons macos_arch=x86_64 platform=osx target=${TARGET} generate_bindings=yes -j${NPROC}
prep: clip godot-cpp

.PHONY: build build_linux build_windows build_osx
build: prep build_${PLATFORM}

build_linux: godot-cpp/bin/libgodot-cpp.linux.${TARGET}.64.a bin/libgdclip.so
%.linux.o: %.cpp
	g++ $(CLIP_CXXFLAGS) -DHAVE_PNG_H -o $@ -c $^
src/%.linux.o: src/%.cpp
	g++ $(CXXFLAGS) -DLINUX -o $@ -c $<
bin/libgdclip.so: src/gdclip.linux.o src/gdlibrary.linux.o clip/clip.linux.o clip/clip_x11.linux.o clip/image.linux.o
	test -d bin || mkdir -p bin
	g++ $(CXXFLAGS) -shared -o $@ $^ ${LINUX_LIBFLAGS}
	test -d demo/bin/x11 || mkdir -p demo/bin/x11
	cp $@ demo/bin/x11/

build_windows: godot-cpp/bin/libgodot-cpp.windows.${TARGET}.64.a bin/libgdclip.dll
%.windows.o: %.cpp
	${MINGW64_PREFIX}g++ $(CLIP_CXXFLAGS) -o $@ -c $^
src/%.windows.o: src/%.cpp
	${MINGW64_PREFIX}g++ $(CXXFLAGS) -DWINDOWS -o $@ -c $^
bin/libgdclip.dll: src/gdclip.windows.o src/gdlibrary.windows.o clip/clip.windows.o clip/clip_win.windows.o clip/image.windows.o
	test -d bin || mkdir -p bin
	${MINGW64_PREFIX}g++ $(CXXFLAGS) -shared -o $@ $^ ${WIN64_LIBFLAGS}
	test -d demo/bin/win64 || mkdir -p demo/bin/win64
	cp $@ demo/bin/win64/

build_osx: godot-cpp/bin/libgodot-cpp.osx.${TARGET}.x86_64.a bin/libgdclip.dylib
%.osx.o: %.cpp
	g++ $(CXXFLAGS) -o $@ -c $^
%.osx.o: %.mm
	g++ $(CXXFLAGS) -o $@ -c $^
bin/libgdclip.dylib: src/gdclip.osx.o src/gdlibrary.osx.o clip/clip.osx.o clip/clip_osx.osx.o clip/image.osx.o
	test -d bin || mkdir -p bin
	g++ $(CXXFLAGS) -shared -o $@ $^ ${OSX_LIBFLAGS}
	test -d demo/bin/osx || mkdir -p demo/bin/osx
	cp $@ demo/bin/osx/

.PHONY: clean
clean:
	-rm bin/*
	-rm demo/bin/*/*
	-rm clip/*.o*
	-rm src/*.o*
	-rm godot-cpp/bin/*
