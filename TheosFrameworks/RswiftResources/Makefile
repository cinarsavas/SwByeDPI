TARGET = iphone:clang:latest:12.0
ARCHS = arm64 arm64e #armv7
MODULE_NAME = RswiftResources
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

$(LIBRARY_NAME)_FILES = $(shell find . -name "*.swift")
$(LIBRARY_NAME)_SWIFTFLAGS = \
		-module-name $(MODULE_NAME) \
		-emit-module \
		-emit-module-path $(THEOS_OBJ_DIR)/$(MODULE_NAME).swiftmodule
$(LIBRARY_NAME)_LDFLAGS = \
        -Wl,-not_for_dyld_shared_cache \
		-Wl,-install_name,@rpath/lib$(MODULE_NAME).dylib # dylib relative path for importers
$(eval $(call abi_fix,$(LIBRARY_NAME)))

include $(THEOS_MAKE_PATH)/library.mk

# Further import for linker (name.dylib -> 'libname.dylib' link) + stock 'name.dylib' for staging
after-all::
	@cp $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/lib$(LIBRARY_NAME).dylib
	@cp $(THEOS_OBJ_DIR)/arm64/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/arm64/lib$(LIBRARY_NAME).dylib
	@cp $(THEOS_OBJ_DIR)/arm64e/$(LIBRARY_NAME).dylib $(THEOS_OBJ_DIR)/arm64e/lib$(LIBRARY_NAME).dylib
