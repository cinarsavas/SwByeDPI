TARGET := iphone:latest:14.0
# HevSocks5Tunnel supports only arm64
DEBUG = 0
FINALPACKAGE = 1
PACKAGE_FORMAT = ipa

include $(THEOS)/makefiles/common.mk

SUBPROJECTS = \
	Sources/ByeDPIC \
	Sources/ByeDPIKit \
	Sources/SwByeDPI \
	TheosFrameworks/RswiftResources \
	TheosFrameworks/Tun2SocksKit/Tun2SocksKitC \
	TheosFrameworks/Tun2SocksKit \
	Example/Sources/ByeByeDPITun \
	Example/Sources/ByeByeDPI
include $(THEOS_MAKE_PATH)/aggregate.mk
