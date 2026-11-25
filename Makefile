ARCHS = armv7
TARGET = iphone:clang:9.3:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FileProviderSandboxFix
FileProviderSandboxFix_FILES = Tweak.x
FileProviderSandboxFix_CFLAGS = -fobjc-arc
FileProviderSandboxFix_FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
