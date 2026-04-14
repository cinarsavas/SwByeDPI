TARGET = iphone:clang:latest:10.0
ARCHS = arm64 arm64e #armv7
MODULE_NAME = ByeDPIKit
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

BYEDPI_C_MODULE_NAME = ByeDPIC
BYEDPI_C_LIB_NAME = lib$(BYEDPI_C_MODULE_NAME)
BYEDPI_C_DIR = $(THEOS_PROJECT_DIR)/Sources/$(BYEDPI_C_MODULE_NAME)
BYEDPI_C_COMPILED = $(THEOS_PROJECT_DIR)/.theos/$(THEOS_OBJ_DIR_NAME)
BYEDPI_C_LIB = $(BYEDPI_C_COMPILED)/$(BYEDPI_C_LIB_NAME).a

before-all:: $(BYEDPI_C_LIB)

$(BYEDPI_C_LIB):
	@echo "ByeDPIC compiled lib not found - compiling..."
	$(MAKE) -C $(BYEDPI_C_DIR)
	@echo "ByeDPIC compiling finish"

$(LIBRARY_NAME)_FILES = \
		ByeDPI.swift \
		Model/BDError.swift
$(LIBRARY_NAME)_LINKAGE_TYPE := static
$(LIBRARY_NAME)_SWIFTFLAGS = \
		-module-name $(MODULE_NAME) \
		-I$(BYEDPI_C_DIR)/include \
		-Xcc -I$(BYEDPI_C_DIR)/include \
		-Xcc -fmodule-map-file=$(BYEDPI_C_DIR)/include/module.modulemap
$(LIBRARY_NAME)_LDFLAGS = \
        -Wl,-not_for_dyld_shared_cache \
		-L$(BYEDPI_C_COMPILED) -l$(BYEDPI_C_MODULE_NAME)
$(eval $(call abi_fix,$(LIBRARY_NAME)))

include $(THEOS_MAKE_PATH)/library.mk

# Further import for linker (name.a -> libname.a) + stock 'name.a' for staging
after-all::
	@cp $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).a $(THEOS_OBJ_DIR)/lib$(LIBRARY_NAME).a
	@cp $(THEOS_OBJ_DIR)/arm64/$(LIBRARY_NAME).a $(THEOS_OBJ_DIR)/arm64/lib$(LIBRARY_NAME).a
	@cp $(THEOS_OBJ_DIR)/arm64e/$(LIBRARY_NAME).a $(THEOS_OBJ_DIR)/arm64e/lib$(LIBRARY_NAME).a
