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

# Figure out the version of Android we're building against.
#
PLATFORM_VERSION := $(shell \
	if [ -f $(TARGET_ROOT)/product/$(TARGET_PRODUCT)/system/build.prop ]; then \
		cat $(TARGET_ROOT)/product/$(TARGET_PRODUCT)/system/build.prop | \
			grep ^ro.build.version.release | cut -f2 -d'=' | cut -f1 -d'-'; \
	else \
		echo 2.0; \
	fi)

# ro.build.version.release contains the version number for release builds, or
# the version codename otherwise. In this case we need to assume that the
# version of Android we're building against has the features that are in the
# final release of that version, so we set PLATFORM_VERSION to the
# corresponding release number.
#
ifeq ($(PLATFORM_VERSION),Eclair)
PLATFORM_VERSION := 2.0
else ifeq ($(PLATFORM_VERSION),Froyo)
PLATFORM_VERSION := 2.2
else ifeq ($(PLATFORM_VERSION),Gingerbread)
PLATFORM_VERSION := 2.3
else ifeq ($(shell echo $(PLATFORM_VERSION) | grep -qE "[A-Za-z]+"; echo $$?),0)
PLATFORM_VERSION := 2.4
endif

PLATFORM_VERSION_MAJ := $(shell echo $(PLATFORM_VERSION) | cut -f1 -d'.')
PLATFORM_VERSION_MIN := $(shell echo $(PLATFORM_VERSION) | cut -f2 -d'.')
