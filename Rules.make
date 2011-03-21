#Rules.make

PLATFORM=LinuxOMAP3

################# FIELDS MODIFIABLE BY THE USER ###############################
#set home area HOME (relative location for all SDK operations)
HOME=$(ANDROID_ROOT_DIR)/external/ti_android_sgx_sdk/SDK
#Current Directory where Graphics SDK is installed
GRAPHICS_INSTALL_DIR=$(ANDROID_ROOT_DIR)/external/ti_android_sgx_sdk/SDK
#Android Specific
#Path of Android Root FS
ANDROID_ROOT=$(ANDROID_ROOT_DIR)/out/target/product/$(TARGET_PRODUCT)
#set toolchain root path for arm-eabi
CSTOOL_DIR=$(ANDROID_ROOT_DIR)/prebuilt/linux-x86/toolchain/arm-eabi-4.4.0
CSTOOL_PREFIX=arm-eabi-
CSTOOL_PATH=$(CSTOOL_DIR)/bin

CSTOOL_LIBSTDC++_PATH=$(CSTOOL_DIR)/arm-none-linux-gnueabi/libc/usr/lib

#set the kernel installation path
KERNEL_INSTALL_DIR=$(ANDROID_ROOT_DIR)/kernel
TARGETFS_INSTALL_DIR=$(ANDROID_ROOT)

GFX_TARGETFS_KERMOD_PATH=$(TARGETFS_INSTALL_DIR)/lib/modules/2.6.32

#Android 
ANDROID_DISCIMAGE=$(TARGETFS_INSTALL_DIR)/

######################### PRE-DEFINED VARIABLES ###############################
######################## NOT MODIFIABLE BY USER ###############################

ANDROID_PRODUCT=zoom3

EURASIAROOT=$(GRAPHICS_INSTALL_DIR)/GFX_Linux_KM

GFX_OGLES_SDKPATH=$(GRAPHICS_INSTALL_DIR)/GFX_Linux_SDK/OGLES/SDKPackage

GFX_OGLES2_SDKPATH=$(GRAPHICS_INSTALL_DIR)/GFX_Linux_SDK/OGLES2/SDKPackage

GFX_OVG_SDKPATH=$(GRAPHICS_INSTALL_DIR)/GFX_Linux_SDK/OVG/SDKPackage

GFX_REL_ES3_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es3.x

GFX_DBG_ES3_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es3.x

GFX_REL_ES5_PDUMP_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es5.x_pdump

GFX_REL_ES6_PDUMP_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es6.x_pdump

GFX_REL_ES5_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es5.x

GFX_REL_ES6_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es6.x

GFX_DBG_ES5_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es5.x

GFX_DBG_ES6_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es6.x

GFX_REL_ES2_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es2.x

GFX_DBG_ES2_LIB_SRCPATH=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es2.x

GFX_OGLES_REL_LIB_DESTPATH=$(GFX_OGLES_SDKPATH)/Builds/OGLES/LinuxOMAP3

GFX_OGLES2_REL_LIB_DESTPATH=$(GFX_OGLES2_SDKPATH)/Builds/OGLES2/LinuxOMAP3

GFX_OVG_REL_LIB_DESTPATH=$(GFX_OVG_SDKPATH)/Builds/OVG/LinuxOMAP3

#Android Specific
GFX_REL_ES3_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es3.x_android

GFX_DBG_ES3_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es3.x_android

GFX_REL_ES5_PDUMP_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es5.x_pdump_android

GFX_REL_ES6_PDUMP_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es6.x_pdump_android

GFX_REL_ES5_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es5.x_android

GFX_REL_ES6_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es6.x_android

GFX_DBG_ES5_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es5.x_android

GFX_DBG_ES6_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es6.x_android

GFX_REL_ES2_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_rel_es2.x_android

GFX_DBG_ES2_LIB_SRCPATH_ANDROID=$(GRAPHICS_INSTALL_DIR)/gfx_dbg_es2.x_android

#End Android Specific


GFX_KERNMOD_SRCPATH=$(GRAPHICS_INSTALL_DIR)/GFX_Linux_KM

GFX_PKG_TARGETFS_PATH = $(GRAPHICS_INSTALL_DIR)/targetfs

GFX_LIBRARY_TARGET_PATH = $(TARGETFS_INSTALL_DIR)/opt/gfxlibraries

GFX_DEVMEM2_SRCPATH = $(GRAPHICS_INSTALL_DIR)/tools/devmem2

# Where to copy the resulting executables and data to (when executing 'make
# install') in a proper file structure. This EXEC_DIR should either be visible
# from the target, or you will have to copy this (whole) directory onto the
# target filesystem.
EXEC_DIR=$(TARGETFS_INSTALL_DIR)/opt/gfxsdkdemos
################################################################################
