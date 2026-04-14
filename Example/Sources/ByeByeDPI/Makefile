TARGET := iphone:latest:14.0
ARCHS = arm64 #arm64e
APPLICATION_NAME = ByeByeDPI
INSTALL_TARGET_PROCESSES = $(APPLICATION_NAME)

include $(THEOS)/makefiles/common.mk

# Project root directory location retriever
PROJ_ROOT_DIR_NAME = SwByeDPI
THEOS_PROJECT_DIR := $(shell \
    curr=$$(pwd); \
    while [ "$$(basename "$$curr")" != "$(PROJ_ROOT_DIR_NAME)" ] && [ "$$curr" != "/" ]; do \
        curr=$$(dirname "$$curr"); \
    done; \
    echo "$$curr")
TARGET_HOST_APP_NAME = ByeByeDPI

SWBYEDPI_MODULE_NAME = SwByeDPI
SWBYEDPI_LIB_NAME = lib$(SWBYEDPI_MODULE_NAME)
SWBYEDPI_DIR = $(THEOS_PROJECT_DIR)/Sources/$(SWBYEDPI_MODULE_NAME)
# Shows only build type (debug/release) without arch type, where the swiftmodules are located - can be used only for dylib
SWBYEDPI_COMPILED_MERGED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
SWBYEDPI_COMPILED_ARCH = $(THEOS_OBJ_DIR)
SWBYEDPI_LIB = $(SWBYEDPI_COMPILED_MERGED)/$(SWBYEDPI_LIB_NAME).dylib

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

before-all:: $(SWBYEDPI_LIB)

$(SWBYEDPI_LIB):
	@echo "SwByeDPI compiled lib not found - compiling..."
	$(MAKE) -C $(SWBYEDPI_DIR)
	@echo "SwByeDPI compiling finish"
	
RSWIFTRESOURCES_MODULE_NAME = RswiftResources
RSWIFTRESOURCES_LIB_NAME = lib$(RSWIFTRESOURCES_MODULE_NAME)
RSWIFTRESOURCES_DIR = $(THEOS_PROJECT_DIR)/TheosFrameworks/$(RSWIFTRESOURCES_MODULE_NAME)
# Shows only build type (debug/release) without arch type, where the swiftmodules are located - can be used only for dylib
RSWIFTRESOURCES_COMPILED_MERGED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
RSWIFTRESOURCES_COMPILED_ARCH = $(THEOS_OBJ_DIR)
RSWIFTRESOURCES_LIB = $(RSWIFTRESOURCES_COMPILED_MERGED)/$(RSWIFTRESOURCES_LIB_NAME).dylib

before-all:: $(RSWIFTRESOURCES_LIB)

$(RSWIFTRESOURCES_LIB):
	@echo "RswiftResources compiled lib not found - compiling..."
	$(MAKE) -C $(RSWIFTRESOURCES_DIR)
	@echo "RswiftResources compiling finish"
	
BBD_APPEX_NAME = ByeByeDPITun
BBD_APPEX_DIR = $(THEOS_PROJECT_DIR)/Example/Sources/$(BBD_APPEX_NAME)
BBD_COMPILED_MERGED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
BBD_APPEX = $(BBD_COMPILED_MERGED)/$(BBD_APPEX_NAME).appex

before-all:: $(BBD_APPEX)

$(BBD_APPEX):
	@echo "ByeByeDPITun compiled appex not found - compiling..."
	$(MAKE) -C $(BBD_APPEX_DIR)
	@echo "ByeByeDPITun compiling finish"
	
UI_DIR_FILES = $(wildcard UI/ScreenView/*.swift)
UI_DIR_EXCLUDED_FILES = UI/ScreenView/HomeScreenPrx.swift

$(APPLICATION_NAME)_SWIFT_VERSION = 5
$(APPLICATION_NAME)_BUNDLE_NAME = $(APPLICATION_NAME)
$(APPLICATION_NAME)_INFO_PLIST = Theos-Info.plist
$(APPLICATION_NAME)_CODESIGN_FLAGS = -SByeByeDPIDebug.entitlements # target bundle ID - org.github.byedpi.app
$(APPLICATION_NAME)_RESOURCE_FILES = \
	LaunchScreen.storyboard
$(APPLICATION_NAME)_RESOURCE_DIRS = \
	Base.lproj \
	en.lproj \
	ru.lproj \
	Assets.xcassets \
	Colors.xcassets \
	Icons.xcassets
$(APPLICATION_NAME)_FILES = \
	Constants.swift \
	ByeByeDPIApp.swift \
	Generated/R.generated.swift \
	$(wildcard Controller/*.swift) \
	$(wildcard Extension/*.swift) \
	$(wildcard Model/*.swift) \
	$(wildcard Shortcut/*.swift) \
	$(wildcard Util/*.swift) \
	$(wildcard VModel/*.swift) \
	$(shell find UI/View -name "*.swift") \
	$(shell find UI/ViewModifier -name "*.swift") \
	$(wildcard UI/ScreenView/Analyzer/*.swift) \
	$(wildcard UI/ScreenView/Picker/*.swift) \
	$(wildcard UI/ScreenView/Tester/*.swift) \
    $(filter-out $(UI_DIR_EXCLUDED_FILES), $(UI_DIR_FILES))
$(APPLICATION_NAME)_FRAMEWORKS = \
	SwiftUI \
	CoreFoundation \
	NetworkExtension
$(APPLICATION_NAME)_SWIFTFLAGS = \
	-I$(RSWIFTRESOURCES_COMPILED_ARCH) \
	-I$(SWBYEDPI_COMPILED_ARCH) \
	-I$(BYEDPI_C_DIR)/include \
	-Xcc -I$(BYEDPI_C_DIR)/include \
	-Xcc -fmodule-map-file=$(BYEDPI_C_DIR)/include/module.modulemap
$(APPLICATION_NAME)_LDFLAGS = \
	-L$(RSWIFTRESOURCES_COMPILED_MERGED) -l$(RSWIFTRESOURCES_MODULE_NAME) \
	-L$(SWBYEDPI_COMPILED_MERGED) -l$(SWBYEDPI_MODULE_NAME) -l$(BYEDPIKIT_MODULE_NAME) -l$(BYEDPI_C_MODULE_NAME)

ifneq ($(THEOS_PLATFORM_NAME),macosx)
# New ABI (i.e. objc ptrauth modifications)
# is available on AppleClang on MacOS only.
# These flags make oldabi package fix our library.
$(APPLICATION_NAME)_CFLAGS += -fno-ptrauth-abi-version
$(APPLICATION_NAME)_LDFLAGS = -ld_classic
endif

include $(THEOS_MAKE_PATH)/application.mk

before-package::
	@mkdir -p $(THEOS_STAGING_DIR)/Applications/$(APPLICATION_NAME).app/PlugIns
	@cp -R $(THEOS_OBJ_DIR)/$(BBD_APPEX_NAME).appex $(THEOS_STAGING_DIR)/Applications/$(APPLICATION_NAME).app/PlugIns/
