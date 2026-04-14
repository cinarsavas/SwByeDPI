TARGET = iphone:clang:latest:12.0
# HevSocks5Tunnel.xcframework supports only arm64
ARCHS = arm64 #arm64e #armv7
MODULE_NAME = Tun2SocksKit
LIBRARY_NAME = $(MODULE_NAME)
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

TUN2SOCKSKIT_C_MODULE_NAME = Tun2SocksKitC
TUN2SOCKSKIT_C_LIB_NAME = lib$(TUN2SOCKSKIT_C_MODULE_NAME)
TUN2SOCKSKIT_C_DIR = $(THEOS_PROJECT_DIR)/TheosFrameworks/$(MODULE_NAME)/$(TUN2SOCKSKIT_C_MODULE_NAME)
TUN2SOCKSKIT_C_COMPILED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
TUN2SOCKSKIT_C_LIB = $(TUN2SOCKSKIT_C_COMPILED)/$(TUN2SOCKSKIT_C_LIB_NAME).a

HEVSOCKS5TUNNEL_MODULE_NAME = HevSocks5Tunnel
HEVSOCKS5TUNNEL_DIR = $(THEOS_PROJECT_DIR)/TheosFrameworks/$(MODULE_NAME)
HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH = $(HEVSOCKS5TUNNEL_DIR)/$(HEVSOCKS5TUNNEL_MODULE_NAME).xcframework

before-all:: $(TUN2SOCKSKIT_C_LIB)

$(TUN2SOCKSKIT_C_LIB):
	@echo "Tun2SocksKitC compiled lib not found - compiling..."
	$(MAKE) -C $(TUN2SOCKSKIT_C_DIR)
	@echo "Tun2SocksKitC compiling finish"

$(LIBRARY_NAME)_FILES = \
		Tunnel.swift
$(LIBRARY_NAME)_SWIFTFLAGS = \
		-module-name $(MODULE_NAME) \
		-emit-module \
        -emit-module-path $(THEOS_OBJ_DIR)/$(MODULE_NAME).swiftmodule \
        -I$(TUN2SOCKSKIT_C_DIR) \
        -I$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64/Headers \
        -Xcc -I$(TUN2SOCKSKIT_C_DIR) \
        -Xcc -I$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64/Headers \
        -Xcc -fmodule-map-file=$(TUN2SOCKSKIT_C_DIR)/module.modulemap \
        -Xcc -fmodule-map-file=$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64/Headers/module.modulemap
$(LIBRARY_NAME)_LDFLAGS = \
        -Wl,-not_for_dyld_shared_cache \
        -Wl,-install_name,@rpath/lib$(MODULE_NAME).dylib \
        -L$(TUN2SOCKSKIT_C_COMPILED) -l$(TUN2SOCKSKIT_C_MODULE_NAME) \
        -L$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64 -lhev-socks5-tunnel \
		-Wl,-rpath,/Library/Frameworks -Wl,-rpath,@executable_path/Frameworks
$(eval $(call abi_fix,$(LIBRARY_NAME)))

include $(THEOS_MAKE_PATH)/library.mk

# Further import for linker (name.dylib -> 'libname.dylib' link) + stock 'name.dylib' for staging
after-all::
	@cp $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/lib$(LIBRARY_NAME).dylib
	@cp $(THEOS_OBJ_DIR)/arm64/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/arm64/lib$(LIBRARY_NAME).dylib
