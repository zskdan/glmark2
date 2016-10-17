LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CPP_EXTENSION := .cc
LOCAL_MODULE := libglmark2-matrix
LOCAL_CFLAGS := -DGLMARK2_USE_GLESv2 -Wall -Wextra -Wnon-virtual-dtor \
                -Wno-error=unused-parameter -fpermissive
LOCAL_C_INCLUDES := $(LOCAL_PATH)/src
LOCAL_SRC_FILES := $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/libmatrix/*.cc))

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libglmark2-png
LOCAL_SRC_FILES := $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/libpng/*.c))

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libglmark2-jpeg
LOCAL_CFLAGS := -Wall -Wextra -Wno-error=attributes \
                -fpermissive -DBMP_SUPPORTED -DPPM_SUPPORTED \
                -DC_ARITH_CODING_SUPPORTED -DD_ARITH_CODING_SUPPORTED \
                -DMEM_SRCDST_SUPPORTED -DWITH_SIMD -DJPEG_LIB_VERSION=62\
                -Wno-error=unused-parameter -Wno-error=unused-function -Wno-error=unused-variable

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src/libjpeg-turbo/
LOCAL_SRC_FILES := $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/libjpeg-turbo/simd/jsimd_$(TARGET_ARCH).c)) \
                   $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/libjpeg-turbo/simd/jsimd_$(TARGET_ARCH)_neon.S)) \
                   $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/libjpeg-turbo/*.c))

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_CPP_EXTENSION := .cc
LOCAL_MODULE := libglmark2-ideas
LOCAL_CFLAGS := -DGLMARK_DATA_PATH="" -DGLMARK2_USE_GLESv2 -Wall -Wextra\
                -Wnon-virtual-dtor -Wno-error=unused-parameter -fpermissive
LOCAL_C_INCLUDES := $(LOCAL_PATH)/src \
                    $(LOCAL_PATH)/src/libmatrix
LOCAL_SRC_FILES := $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/scene-ideas/*.cc))

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

export EXTRAVERSION := $(shell echo -n -$(shell git rev-parse --verify --short HEAD 2>/dev/null); if git diff-index --name-only HEAD 2>/dev/null | read dummy ; then echo -n "-dirty" ; fi)

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libglmark2-android
LOCAL_STATIC_LIBRARIES := libglmark2-matrix libglmark2-png libglmark2-ideas libglmark2-jpeg
LOCAL_CFLAGS := -DGLMARK_DATA_PATH="" -DGLMARK_VERSION="\"2014.03$(EXTRAVERSION)\"" \
                -DGLMARK2_USE_GLESv2 -Wall -Wextra -Wnon-virtual-dtor \
                -Wno-error=unused-parameter -fpermissive
LOCAL_LDLIBS := -landroid -llog -lGLESv2 -lEGL -lz
LOCAL_C_INCLUDES := $(LOCAL_PATH)/src \
                    $(LOCAL_PATH)/src/libmatrix \
                    $(LOCAL_PATH)/src/scene-ideas \
                    $(LOCAL_PATH)/src/scene-terrain \
                    $(LOCAL_PATH)/src/libjpeg-turbo \
                    $(LOCAL_PATH)/src/libpng
LOCAL_SRC_FILES := $(filter-out src/canvas% src/gl-state% src/native-state% src/main.cpp, \
                     $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/*.cpp))) \
                   $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/scene-terrain/*.cpp)) \
                   src/canvas-android.cpp

include $(BUILD_SHARED_LIBRARY)
