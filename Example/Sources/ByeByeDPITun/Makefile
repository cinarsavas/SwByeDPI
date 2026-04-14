TARGET := iphone:latest:14.0
# HevSocks5Tunnel supports only arm64
ARCHS = arm64 #arm64e
APPEX_NAME = ByeByeDPITun
INSTALL_TARGET_PROCESSES = $(APPEX_NAME)

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
TARGET_HOST_APP_NAME = ByeByeDPI

BYEDPIKIT_MODULE_NAME = ByeDPIKit
BYEDPIKIT_LIB_NAME = lib$(BYEDPIKIT_MODULE_NAME)
BYEDPIKIT_DIR = $(THEOS_PROJECT_DIR)/Sources/$(BYEDPIKIT_MODULE_NAME)
# Shows only build type (debug/release) without arch type, where the swiftmodules are located - can be used only for dylib
BYEDPIKIT_COMPILED_MERGED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
BYEDPIKIT_COMPILED_ARCH = $(THEOS_OBJ_DIR)
BYEDPIKIT_LIB = $(BYEDPIKIT_COMPILED_MERGED)/$(BYEDPIKIT_LIB_NAME).a

BYEDPI_C_MODULE_NAME = ByeDPIC
BYEDPI_C_LIB_NAME = lib$(BYEDPI_C_MODULE_NAME)
BYEDPI_C_DIR = $(THEOS_PROJECT_DIR)/Sources/$(BYEDPI_C_MODULE_NAME)

before-all:: $(BYEDPIKIT_LIB)

$(BYEDPIKIT_LIB):
	@echo "ByeDPIKit compiled lib not found - compiling..."
	$(MAKE) -C $(BYEDPIKIT_DIR)
	@echo "ByeDPIKit compiling finish"

# Tun2SOCKSKit
TUN2SOCKSKIT_MODULE_NAME = Tun2SocksKit
TUN2SOCKSKIT_LIB_NAME = lib$(TUN2SOCKSKIT_MODULE_NAME)
TUN2SOCKSKIT_DIR = $(THEOS_PROJECT_DIR)/TheosFrameworks/$(TUN2SOCKSKIT_MODULE_NAME)
# Shows only build type (debug/release) without arch type, where the swiftmodules are located - can be used only for dylib
TUN2SOCKSKIT_COMPILED_MERGED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
TUN2SOCKSKIT_COMPILED_ARCH = $(THEOS_OBJ_DIR)
TUN2SOCKSKIT_LIB = $(TUN2SOCKSKIT_COMPILED_MERGED)/$(TUN2SOCKSKIT_LIB_NAME).dylib

TUN2SOCKSKIT_C_MODULE_NAME = Tun2SocksKitC
TUN2SOCKSKIT_C_LIB_NAME = lib$(TUN2SOCKSKIT_C_MODULE_NAME)
TUN2SOCKSKIT_C_DIR = $(TUN2SOCKSKIT_DIR)/$(TUN2SOCKSKIT_C_MODULE_NAME)
TUN2SOCKSKIT_C_COMPILED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
TUN2SOCKSKIT_C_LIB = $(TUN2SOCKSKIT_C_COMPILED)/$(TUN2SOCKSKIT_C_LIB_NAME).a

HEVSOCKS5TUNNEL_MODULE_NAME = HevSocks5Tunnel
HEVSOCKS5TUNNEL_DIR = $(TUN2SOCKSKIT_DIR)
HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH = $(HEVSOCKS5TUNNEL_DIR)/$(HEVSOCKS5TUNNEL_MODULE_NAME).xcframework

before-all:: $(TUN2SOCKSKIT_LIB)

$(TUN2SOCKSKIT_LIB):
	@echo "Tun2SocksKit compiled lib not found - compiling..."
	$(MAKE) -C $(TUN2SOCKSKIT_DIR)
	@echo "Tun2SocksKit compiling finish"

$(APPEX_NAME)_INFO_PLIST = Theos-Info.plist
$(APPEX_NAME)_CODESIGN_FLAGS = -SByeByeDPITunDebug.entitlements # target bundle ID - org.github.byedpi.app.tun
$(APPEX_NAME)_FILES = \
		Constants.swift \
		PacketTunnelProvider.swift \
		UserDefaultsAppKeys.swift \
		UserDefaultsAppProperties.swift \
		Extension/CFNotificationName+VPN.swift \
		Extension/NETunnelProviderProtocol+CustomProps.swift \
		Extension/Socks5Tunnel+Async.swift
$(APPEX_NAME)_FRAMEWORKS = \
		CoreFoundation \
		NetworkExtension
$(APPEX_NAME)_SWIFTFLAGS = \
		-I$(TUN2SOCKSKIT_COMPILED_ARCH) \
		-I$(TUN2SOCKSKIT_C_DIR) \
        -I$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64/Headers \
        -Xcc -I$(TUN2SOCKSKIT_C_DIR) \
        -Xcc -I$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64/Headers \
        -Xcc -fmodule-map-file=$(TUN2SOCKSKIT_C_DIR)/module.modulemap \
        -Xcc -fmodule-map-file=$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64/Headers/module.modulemap \
		-I$(BYEDPIKIT_COMPILED_ARCH) \
		-I$(BYEDPI_C_DIR)/include \
		-Xcc -I$(BYEDPI_C_DIR)/include \
		-Xcc -fmodule-map-file=$(BYEDPI_C_DIR)/include/module.modulemap
$(APPEX_NAME)_LDFLAGS = \
        -Wl,-not_for_dyld_shared_cache \
		-L$(BYEDPIKIT_COMPILED_MERGED) -l$(BYEDPIKIT_MODULE_NAME) -l$(BYEDPI_C_MODULE_NAME) \
		-L$(TUN2SOCKSKIT_COMPILED_MERGED) -l$(TUN2SOCKSKIT_MODULE_NAME) -l$(TUN2SOCKSKIT_C_MODULE_NAME) \
        -L$(HEVSOCKS5TUNNEL_XCFRAMEWORK_PATH)/ios-arm64 -lhev-socks5-tunnel \
		-Wl,-rpath,/Library/Frameworks -Wl,-rpath,@executable_path/Frameworks
$(APPEX_NAME)_INSTALL_PATH = /Applications/$(TARGET_HOST_APP_NAME).app/PlugIns
$(eval $(call abi_fix,$(APPEX_NAME)))

include $(THEOS_MAKE_PATH)/appex.mk
