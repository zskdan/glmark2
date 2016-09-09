ifndef QCONFIG
QCONFIG=qconfig.mk
endif
include $(QCONFIG)

NAME = scene-terrain

define PINFO
PINFO DESCRIPTION= bench glmark2
endef

include $(MKFILES_ROOT)/qmacros.mk
USEFILE =
INSTALLDIR = usr/lib

CCFLAGS += -I../../../../ \
	   -I../../../../libmatrix \
           -fpermissive -Wall -Wextra -Wnon-virtual-dtor \
           -Wno-error=unused-parameter -DHAVE_STDLIB_H=1 \
	   -DGLMARK2_USE_GLESv2 -DGLMARK2_USE_SCREEN -DGLMARK2_USE_EGL \
           -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE_STDINT_H=1 \
           -DHAVE_STDIO_H=1 -DHAVE_JPEGLIB_H=1 -DHAVE_MEMSET=1 -DHAVE_SQRT=1 \
           -DHAVE_LIBPNG=1 -DHAVE_EGL=1 -DHAVE_GLESV2=1 -DHAVE_DRM=1 \
           -DGLMARK_DATA_PATH=\"/base/usr/share/glmark2\" \
           -DGLMARK_VERSION=\"2014.03\" -DUSE_EXCEPTIONS \
           -ggdb -O0

LIBS = 

include $(MKFILES_ROOT)/qtargets.mk
