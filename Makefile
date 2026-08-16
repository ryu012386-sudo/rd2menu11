# RD2 Flag Menu dylib・医ョ繝ｼ繧ｿ繝輔Λ繧ｰ譁ｹ蠑上・substrate髱樔ｾ晏ｭ倥・繧ｳ繝ｼ繝画隼螟峨↑縺暦ｼ・ARCHS = arm64
TARGET = iphone:clang:latest:14.0
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RD2FlagMenu
RD2FlagMenu_FILES = RD2FlagMenu.mm
RD2FlagMenu_FRAMEWORKS = UIKit CoreGraphics QuartzCore
RD2FlagMenu_CCFLAGS = -fobjc-arc
RD2FlagMenu_CFLAGS  = -fobjc-arc
RD2FlagMenu_LDFLAGS = -install_name @executable_path/Frameworks/RD2FlagMenu.dylib

include $(THEOS_MAKE_PATH)/tweak.mk
