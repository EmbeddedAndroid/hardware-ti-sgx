# Makefile to build DEVMEM2

include ../../Rules.make

.PHONY: clean

TARGETFSDIR  = ../../targetfs/
CROSS_COMPILE=$(CSTOOL_PATH)/$(CSTOOL_PREFIX)

PLAT_CC  = $(CROSS_COMPILE)gcc
PLAT_CPP = $(CROSS_COMPILE)g++
PLAT_AR  = $(CROSS_COMPILE)ar

DEBUG_RELEASE = Release
PLAT_CFLAGS   = -Wall -DRELEASE -O2
TOOLCHAIN = $(CSTOOL_DIR)
PLAT_OBJPATH = ./Obj
PLAT_LINK =  -lm -ldl -lc -fno-short-enums -L$(ANDROID_ROOT)/out/target/product/$(TARGET_PRODUCT)/obj/lib/ -Wl,-dynamic-linker,/system/bin/linker -nostdlib -Wl,-T,$(ANDROID_ROOT)/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/arm-eabi/lib/ldscripts/armelf.x
OBJECTS1 = $(ANDROID_ROOT)/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/arm-eabi/lib/ldscripts/armelf.x $(ANDROID_ROOT)/out/target/product/$(TARGET_PRODUCT)/obj/lib/crtbegin_dynamic.o $(ANDROID_ROOT)/out/target/product/$(TARGET_PRODUCT)/obj/lib/crtend_android.o
 
SRCNAME = devmem2

OUTNAME = devmem2

OBJECTS = $(PLAT_OBJPATH)/$(SRCNAME).o

INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/include \
	    -I$(ANDROID_ROOT)/bionic/libc/arch-arm/include \
	    -I$(ANDROID_ROOT)/bionic/libc/kernel/arch-arm/ \
            -I$(ANDROID_ROOT)/bionic/libc/kernel/common

$(PLAT_OBJPATH)/$(OUTNAME) : $(OBJECTS) 
	mkdir -p $(PLAT_OBJPATH)
	$(PLAT_CPP) -o $(PLAT_OBJPATH)/$(OUTNAME) $(OBJECTS) $(OBJECTS1) $(OBJECTS2) $(LINK) $(PLAT_LINK) $(VG_LINK) $(PVR2D_LINK)

$(PLAT_OBJPATH)/%.o: %.cpp 
	mkdir -p $(PLAT_OBJPATH)
	$(PLAT_CC) $(PLAT_CFLAGS) -c $(COMMON_INCLUDES) $(INCLUDES) $^ -o $@

$(PLAT_OBJPATH)/%.o: %.c 
	mkdir -p $(PLAT_OBJPATH)
	$(PLAT_CC) $(PLAT_CFLAGS) -c $(COMMON_INCLUDES) $(INCLUDES) $^ -o $@

install:
ifeq ($(OMAPES),4.x)
	@echo "copying devmem2 to $(GFX_REL_ES4_LIB_SRCPATH_ANDROID)"
	cp $(PLAT_OBJPATH)/$(OUTNAME) $(GFX_REL_ES4_LIB_SRCPATH_ANDROID)
endif

ifeq ($(OMAPES),5.x)
	@echo "copying devmem2 to $(GFX_REL_ES5_LIB_SRCPATH_ANDROID)"
	cp $(PLAT_OBJPATH)/$(OUTNAME) $(GFX_REL_ES5_LIB_SRCPATH_ANDROID)
endif

ifeq ($(OMAPES),6.x)
	@echo "copying devmem2 to $(GFX_REL_ES6_LIB_SRCPATH_ANDROID)"
	cp $(PLAT_OBJPATH)/$(OUTNAME) $(GFX_REL_ES6_LIB_SRCPATH_ANDROID)
endif

clean:
	rm -rf $(PLAT_OBJPATH) *.o
