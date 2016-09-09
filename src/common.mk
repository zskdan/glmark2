EARLY_DIRS=libmatrix scene-ideas scene-terrain

ifndef QCONFIG
QCONFIG=qconfig.mk
endif
include $(QCONFIG)

NAME = glmark2

define PINFO
PINFO DESCRIPTION= bench glmark2
endef

include $(MKFILES_ROOT)/qmacros.mk
USEFILE =
INSTALLDIR = usr/bin

CCFLAGS += -fpermissive -Wall -Wextra -Wnon-virtual-dtor \
           -Wno-error=unused-parameter -DHAVE_STDLIB_H=1 \
	   -DGLMARK2_USE_GLESv2 -DGLMARK2_USE_SCREEN -DGLMARK2_USE_EGL \
           -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE_STDINT_H=1 \
           -DHAVE_STDIO_H=1 -DHAVE_JPEGLIB_H=1 -DHAVE_MEMSET=1 -DHAVE_SQRT=1 \
           -DHAVE_LIBPNG=1 -DHAVE_EGL=1 -DHAVE_GLESV2=1 -DHAVE_DRM=1 \
           -DGLMARK_DATA_PATH=\"/base/usr/share/glmark2\" \
           -DGLMARK_VERSION=\"2014.03\" -DUSE_EXCEPTIONS \
	   -I../../../libmatrix  -I../../../scene-ideas -I../../../scene-terrain \
           -ggdb -O0

SRCS =  \
benchmark-collection.cpp \
benchmark.cpp \
canvas-android.cpp \
canvas-generic.cpp \
gl-headers.cpp \
gl-state-egl.cpp \
gl-visual-config.cpp \
image-reader.cpp \
main.cpp \
main-loop.cpp \
mesh.cpp \
model.cpp \
native-state-screen.cpp \
options.cpp \
scene-buffer.cpp \
scene-build.cpp \
scene-bump.cpp \
scene-clear.cpp \
scene-conditionals.cpp \
scene.cpp \
scene-default-options.cpp \
scene-desktop.cpp \
scene-effect-2d.cpp \
scene-function.cpp \
scene-grid.cpp \
scene-ideas.cpp \
scene-jellyfish.cpp \
scene-loop.cpp \
scene-pulsar.cpp \
scene-refract.cpp \
scene-shading.cpp \
scene-shadow.cpp \
scene-terrain.cpp \
scene-texture.cpp \
text-renderer.cpp \
texture.cpp \

MYROOTDIR   := /net/frbuild/build/zakariae/wayland/benchs/glmark2.2

ifeq ($(CPU),arm)
SUFFIX=.v7
endif

LIB_VARIANT := a.le$(SUFFIX)

EXTRA_LIBVPATH += $(MYROOTDIR)/src/libmatrix/$(OS)/$(CPU)/$(LIB_VARIANT) \
                  $(MYROOTDIR)/src/scene-ideas/$(OS)/$(CPU)/$(LIB_VARIANT) \
		  $(MYROOTDIR)/src/scene-terrain/$(OS)/$(CPU)/$(LIB_VARIANT) \

LIBS = matrix scene-ideas scene-terrain \

LDFLAGS += -lpng -ljpeg -lm -lscreen -lEGL -lGLESv2 \

include $(MKFILES_ROOT)/qtargets.mk
