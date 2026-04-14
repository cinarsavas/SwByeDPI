TARGET = iphone:clang:latest:9.0
ARCHS = arm64 arm64e #armv7 armv7s
# libByeDPIC name instead of ByeDPIC for further static lib link
MODULE_NAME = ByeDPIC
LIBRARY_NAME = lib$(MODULE_NAME)
INSTALL_TARGET_PROCESSES = $(LIBRARY_NAME)

include $(THEOS)/makefiles/common.mk

define abi_fix
ifneq ($(THEOS_PLATFORM_NAME),macosx)
# New ABI (i.e. objc ptrauth modifications)
# is available on AppleClang on MacOS only.
# These flags make oldabi package fix our library.
$(1)_CFLAGS += -fno-ptrauth-abi-version
$(1)_LDFLAGS += -ld_classic
endif
endef

# Project root directory location retriever
PROJ_ROOT_DIR_NAME = SwByeDPI
THEOS_PROJECT_DIR := $(shell \
    curr=$$(pwd); \
    while [ "$$(basename "$$curr")" != "$(PROJ_ROOT_DIR_NAME)" ] && [ "$$curr" != "/" ]; do \
        curr=$$(dirname "$$curr"); \
    done; \
    echo "$$curr")

$(LIBRARY_NAME)_FILES := \
		byedpi/ciadpi_main.c \
		byedpi/conev.c \
		byedpi/desync.c \
		byedpi/extend.c \
		byedpi/mpool.c \
		byedpi/packets.c \
		byedpi/proxy.c \
		ciadpi_bridge.c
$(LIBRARY_NAME)_LINKAGE_TYPE := static
$(LIBRARY_NAME)_CFLAGS := \
	    -fobjc-arc \
		-I. \
		-Iinclude \
		-Ibyedpi \
		-UDAEMON \
		-Dmain=ciadpi_main \
		-Wno-format \
		-Wno-unused-variable \
		-Wno-unused-function \
		-Wno-unused-but-set-variable \
		-Wno-unknown-attributes \
		-Wno-deprecated-declarations \
		-Wno-implicit-function-declaration
$(LIBRARY_NAME)_SWIFTFLAGS = -module-name $(MODULE_NAME)
$(eval $(call abi_fix,$(LIBRARY_NAME)))

include $(THEOS_MAKE_PATH)/library.mk
