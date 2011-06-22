#
# Copyright (C) Imagination Technologies Ltd. All rights reserved.
# 
# This program is free software; you can redistribute it and/or modify it
# under the terms and conditions of the GNU General Public License,
# version 2, as published by the Free Software Foundation.
# 
# This program is distributed in the hope it will be useful but, except 
# as otherwise stated in writing, without any warranty; without even the 
# implied warranty of merchantability or fitness for a particular purpose. 
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
# 
# The full GNU General Public License is included in this distribution in
# the file called "COPYING".
#
# Contact Information:
# Imagination Technologies Ltd. <gpl-support@imgtec.com>
# Home Park Estate, Kings Langley, Herts, WD4 8LZ, UK 
# 
#

include ../common/android/platform_version.mk

is_at_least_froyo := \
	$(shell ( test $(PLATFORM_VERSION_MAJ) -gt 2 || \
				( test $(PLATFORM_VERSION_MAJ) -eq 2 && \
				  test $(PLATFORM_VERSION_MIN) -ge 2 ) ) && echo 1 || echo 0)

is_at_least_gingerbread := \
	$(shell ( test $(PLATFORM_VERSION_MAJ) -gt 2 || \
				( test $(PLATFORM_VERSION_MAJ) -eq 2 && \
				  test $(PLATFORM_VERSION_MIN) -ge 3 ) ) && echo 1 || echo 0)

# Basic support option tuning for Android
#
SUPPORT_ANDROID_PLATFORM := 1
SUPPORT_OPENGLES1_V1_ONLY := 1
SUPPORT_OPENVG := 0
SUPPORT_OPENGL := 0
SUPPORT_OPENCL := 0

# Meminfo IDs are required for buffer stamps
#
SUPPORT_MEMINFO_IDS := 1
# Composition requires texture dependencies
#
SUPPORT_EGL_IMAGE_SYNC_DEPENDENCY := 1

# Need multi-process support in PDUMP
#
SUPPORT_PDUMP_MULTI_PROCESS := 1

# Always print debugging after 5 seconds of no activity
#
CLIENT_DRIVER_DEFAULT_WAIT_RETRIES := 50

# Android WSEGL is always the same
#
OPK_DEFAULT := libpvrANDROID_WSEGL.so

# We always build with at least these components
#
KERNEL_COMPONENTS := srvkm 

##############################################################################
# EGL connect/disconnect hooks only available since Froyo
#
ifeq ($(is_at_least_froyo),1)
PVR_ANDROID_HAS_CONNECT_DISCONNECT := 1
endif

##############################################################################
# Override surface field name for older versions
#
ifeq ($(is_at_least_gingerbread),0)
SYS_CFLAGS_UM.1 += -DPVR_ANDROID_SURFACE_FIELD_NAME=\"mSurface\"
endif

##############################################################################
# We provide eglhelper.h for our tests
#
UNITTEST_INCLUDES := eurasiacon/android

# Handle newer versions of Android
#
ifeq ($(is_at_least_gingerbread),1)
UNITTEST_INCLUDES += $(ANDROID_ROOT)/frameworks/base/native/include
endif

# Android has GLES (v1), EGL and KHR headers..
#
UNITTEST_INCLUDES += $(ANDROID_ROOT)/frameworks/base/opengl/include

# But it doesn't have OpenVG headers
#
UNITTEST_INCLUDES += eurasiacon/unittests/include

##############################################################################
# Future versions moved proprietary libraries to a vendor directory
#
ifeq ($(is_at_least_gingerbread),1)
SHLIB_DESTDIR := /system/lib
DEMO_DESTDIR := /system/bin
else
SHLIB_DESTDIR := /system/lib
DEMO_DESTDIR := /system/bin
endif

##############################################################################
# We can support OpenCL in the build since Froyo (stlport was added in 2.2)
#
ifeq ($(is_at_least_froyo),1)
SYS_CXXFLAGS := \
 -fuse-cxa-atexit \
 $(SYS_CFLAGS) \
 -I$(ANDROID_ROOT)/bionic \
 -I$(ANDROID_ROOT)/external/stlport/stlport
else
$(if $(SUPPORT_OPENCL),$(error SUPPORT_OPENCL not supported prior to Froyo),)
SYS_CXXFLAGS := \
 $(SYS_CFLAGS) \
 -I$(ANDROID_ROOT)/bionic/libstdc++/include
endif

# EGL libraries go in a special place
#
EGL_DESTDIR := $(SHLIB_DESTDIR)/egl
