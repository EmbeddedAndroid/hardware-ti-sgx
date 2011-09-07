#Rules.make

################# FIELDS MODIFIABLE BY THE USER ###############################
#set home area HOME (relative location for all SDK operations)
HOME=$(ANDROID_ROOT_DIR)/hardware/ti/sgx

#Current Directory where Graphics SDK is installed
GRAPHICS_INSTALL_DIR=$(ANDROID_ROOT_DIR)/hardware/ti/sgx

#Path of Android Framework
ANDROID_ROOT=$(ANDROID_ROOT_DIR)

#set toolchain root path for arm-eabi
CSTOOL_DIR=$(ANDROID_ROOT_DIR)/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3
CSTOOL_PREFIX=arm-eabi-
CSTOOL_PATH=$(CSTOOL_DIR)/bin

CSTOOL_LIBSTDC++_PATH=$(CSTOOL_DIR)/arm-none-linux-gnueabi/libc/usr/lib

#set the kernel installation path
KERNEL_INSTALL_DIR=$(ANDROID_ROOT_DIR)/kernel
#set filesystem path
TARGETFS_INSTALL_DIR=$(ANDROID_ROOT_DIR)/out/target/product/$(TARGET_PRODUCT)

#Android 
ANDROID_DISCIMAGE=$(TARGETFS_INSTALL_DIR)/
DISCIMAGE=$(ANDROID_DISCIMAGE)


######################### PRE-DEFINED VARIABLES ###############################
######################## NOT MODIFIABLE BY USER ###############################

EURASIAROOT=$(GRAPHICS_INSTALL_DIR)

GFX_REL_ES3_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es3.x
GFX_REL_ES4_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es4.x
GFX_REL_ES5_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es5.x
GFX_REL_ES6_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es6.x
GFX_REL_ES7_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es7.x

#Android Specific

GFX_REL_ES3_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es3.x_android
GFX_REL_ES4_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es4.x_android
GFX_REL_ES5_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es5.x_android
GFX_REL_ES6_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es6.x_android
GFX_REL_ES7_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es7.x_android

#End Android Specific

GFX_DEVMEM2_SRCPATH = $(GRAPHICS_INSTALL_DIR)/tools/devmem2
GFX_KERNMOD_SRCPATH=$(GRAPHICS_INSTALL_DIR)
