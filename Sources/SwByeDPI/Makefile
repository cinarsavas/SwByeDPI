TARGET = iphone:clang:latest:10.0
ARCHS = arm64 arm64e #armv7
MODULE_NAME = SwByeDPI
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
PROJ_DIR_NAME = Sources/SwByeDPI
THEOS_PROJECT_DIR := $(shell \
	curr=$$(realpath $(CURDIR)/..); \
	while [ "$$(basename "$$curr")" != "$(PROJ_ROOT_DIR_NAME)" ] && [ "$$curr" != "/" ]; do \
		curr=$$(dirname "$$curr"); \
	done; \
	echo "$$curr")

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

$(LIBRARY_NAME)_FILES = $(shell find . -name "*.swift")
$(LIBRARY_NAME)_SWIFTFLAGS = \
		-module-name $(MODULE_NAME) \
		-emit-module \
		-emit-module-path $(THEOS_OBJ_DIR)/$(MODULE_NAME).swiftmodule \
		-I$(BYEDPIKIT_COMPILED_ARCH) \
		-I$(BYEDPI_C_DIR)/include \
		-Xcc -I$(BYEDPI_C_DIR)/include \
		-Xcc -fmodule-map-file=$(BYEDPI_C_DIR)/include/module.modulemap
$(LIBRARY_NAME)_LDFLAGS = \
        -Wl,-not_for_dyld_shared_cache \
		-Wl,-install_name,@rpath/lib$(MODULE_NAME).dylib \
		-Wl,-rpath,@loader_path/. \
		-L$(BYEDPIKIT_COMPILED_MERGED) -l$(BYEDPIKIT_MODULE_NAME) -l$(BYEDPI_C_MODULE_NAME)
$(eval $(call abi_fix,$(LIBRARY_NAME)))

include $(THEOS_MAKE_PATH)/library.mk

# Further import for linker (name.dylib -> 'libname.dylib' link) + stock 'name.dylib' for staging
after-all::
	@cp $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/lib$(LIBRARY_NAME).dylib
	@cp $(THEOS_OBJ_DIR)/arm64/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/arm64/lib$(LIBRARY_NAME).dylib
	@cp $(THEOS_OBJ_DIR)/arm64e/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/arm64e/lib$(LIBRARY_NAME).dylib
