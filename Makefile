ROOT_DIR := $(notdir $(CURDIR))
ifndef QCONFIG
QCONFIG=qconfig.mk
endif
include $(QCONFIG)
unexport ROOT_DIR

export JLEVEL := $(shell cat /proc/cpuinfo | grep processor | wc -l)

export EXTRAVERSION := $(shell echo -n -$(shell git rev-parse --verify --short HEAD 2>/dev/null); if git diff-index --name-only HEAD 2>/dev/null | read dummy ; then echo -n "-dirty" ; fi)

LIST=CPU
include recurse.mk

all:
	$(MAKE) -C src/scene-ideas $@
	$(MAKE) -C src/scene-terrain $@
	$(MAKE) -C src/libmatrix $@
	$(MAKE) -C src $@

clean:
	$(MAKE) -C src/scene-ideas $@
	$(MAKE) -C src/scene-terrain $@
	$(MAKE) -C src/libmatrix $@
	$(MAKE) -C src $@
