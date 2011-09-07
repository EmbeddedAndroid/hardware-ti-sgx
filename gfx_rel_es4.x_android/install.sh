#!/bin/sh

# PowerVR SGX DDK for Embedded Linux - installation script
#
# Copyright	2004-2006 by Imagination Technologies Limited.
#				All rights reserved.  No part of this software, either
#				material or conceptual may be copied or distributed,
#				transmitted, transcribed, stored in a retrieval system
#				or translated into any human or computer language in any
#				form by any means, electronic, mechanical, manual or
#				other-wise, or disclosed to third parties without the
#				express written permission of Imagination Technologies
#				Limited, Unit 8, HomePark Industrial Estate,
#				King's Langley, Hertfordshire, WD4 8LZ, U.K.

# Auto-generated for omap4430_android from embedded.pj 1.7.17.4352
#

# PVR Consumer services version number
#
PVRVERSION=1.7.17.4352

# Where we record what we did so we can undo it.
#
DDK_INSTALL_LOG=/powervr_ddk_install.log

# basic installation function
# $1=blurb
#
bail()
{
    echo "$1" >&2
    echo "" >&2
    echo "Installation failed" >&2
    exit 1
}

# basic installation function
# $1=fromfile, $2=destfilename, $3=blurb, $4=chmod-flags, $5=chown-flags
#
install_file()
{
	DESTFILE=${DISCIMAGE}$2
	DESTDIR=`dirname $DESTFILE`

	if [ ! -e $1 ]; then
		 	[ -n "$VERBOSE" ] && echo "skipping file $1 -> $2"
		 return
	fi
	
	# Destination directory - make sure it's there and writable
	#
	if [ -d "${DESTDIR}" ]; then
		if [ ! -w "${DESTDIR}" ]; then
			bail "${DESTDIR} is not writable."
		fi
	else
		$DOIT mkdir -p ${DESTDIR} || bail "Couldn't mkdir -p ${DESTDIR}"
		[ -n "$VERBOSE" ] && echo "Created directory `dirname $2`"
	fi

	# Delete the original so that permissions don't persist.
	#
	$DOIT rm -f $DESTFILE

	$DOIT cp -f $1 $DESTFILE || bail "Couldn't copy $1 to $DESTFILE"
	$DOIT chmod $4 ${DESTFILE}
	$DOIT chown $5 ${DESTFILE}

	echo "$3 `basename $1` -> $2"
	$DOIT echo "file $2" >>${DISCIMAGE}${DDK_INSTALL_LOG}
}

# Install a symbolic link
# $1=fromfile, $2=destfilename
#
install_link()
{
	DESTFILE=${DISCIMAGE}$2
	DESTDIR=`dirname $DESTFILE`

	if [ ! -e ${DESTDIR}/$1 ]; then
		 [ -n "$VERBOSE" ] && echo $DOIT "skipping link ${DESTDIR}/$1"
		 return
	fi

	# Destination directory - make sure it's there and writable
	#
	if [ -d "${DESTDIR}" ]; then
		if [ ! -w "${DESTDIR}" ]; then
			bail "${DESTDIR} is not writable."
		fi
	else
		$DOIT mkdir -p ${DESTDIR} || bail "Couldn't mkdir -p ${DESTDIR}"
		[ -n "$VERBOSE" ] && echo "Created directory `dirname $2`"
	fi

	# Delete the original so that permissions don't persist.
	#
	$DOIT rm -f $DESTFILE

	$DOIT ln -s $1 $DESTFILE || bail "Couldn't link $1 to $DESTFILE"
	$DOIT echo "link $2" >>${DISCIMAGE}${DDK_INSTALL_LOG}
	[ -n "$VERBOSE" ] && echo " linked `basename $1` -> $2"
}

# Tree-based installation function
# $1 = fromdir $2=destdir $3=blurb
#
install_tree()
{
	# Make the destination directory if it's not there
	#
	if [ ! -d ${DISCIMAGE}$2 ]; then
		$DOIT mkdir -p ${DISCIMAGE}$2 || bail "Couldn't mkdir -p ${DISCIMAGE}$2"
	fi
	if [ "$DONTDOIT" ]; then
		echo "### tar -C $1 -cf - . | tar -C ${DISCIMAGE}$2 -x${VERBOSE}f -" 
	else
		tar -C $1 -cf - . | tar -C ${DISCIMAGE}$2 -x${VERBOSE}f -
	fi
	if [ $? = 0 ]; then
		echo "Installed $3 in ${DISCIMAGE}$2"
		$DOIT echo "tree $2" >>${DISCIMAGE}${DDK_INSTALL_LOG}
	else
		echo "Failed copying $3 from $1 to ${DISCIMAGE}$2"
	fi
}

# Uninstall something.
#
uninstall()
{
	if [ ! -f ${DISCIMAGE}${DDK_INSTALL_LOG} ]; then
		echo "Nothing to un-install."
		return;
	fi

	BAD=0
	VERSION=""
	while read type data; do
		case $type in
		version)	# do nothing
			echo "Uninstalling existing version $data"
			VERSION="$data"
			;;
		link|file) 
			if [ -z "$VERSION" ]; then
				BAD=1;
				echo "No version record at head of ${DISCIMAGE}${DDK_INSTALL_LOG}"
			elif ! $DOIT rm -f ${DISCIMAGE}${data}; then
				BAD=1;
			else
				[ -n "$VERBOSE" ] && echo "Deleted $type $data"
			fi
			;;
		tree)		# so far, do nothing
			;;
		esac
	done < ${DISCIMAGE}${DDK_INSTALL_LOG};

	if [ $BAD = 0 ]; then
		echo "Uninstallation completed."
		$DOIT rm -f ${DISCIMAGE}${DDK_INSTALL_LOG}
	else
		echo "Uninstallation failed!!!"
	fi
}

# Help on how to invoke
#
usage()
{
	echo "usage: $0 [options...]"
	echo ""
	echo "Options: -v            verbose mode"
	echo "         -n            dry-run mode"
	echo "         -u            uninstall-only mode"
	echo "         --no-pvr      don't install PowerVR driver components"
	echo "         --no-x        don't install X window system"
	echo "         --no-display  don't install integrated PowerVR display module"
	echo "         --no-bcdevice don't install buffer class device module"
	echo "         --root path   use path as the root of the install file system"
	exit 1
}

install_pvr()
{
	$DOIT echo "version 1.7.17.4352" >${DISCIMAGE}${DDK_INSTALL_LOG}
	# Install the standard scripts
	#
	install_file rc.pvr /system/bin/sgx/rc.pvr "boot script" 0755 0:0

	# Check the kernel module directory is there
	#
	if [ ! -d "${DISCIMAGE}" ]; then
		echo ""
		echo "Can't find  on file system installation root"
		echo -n "There is no kernel module area setup yet. "
		if [ "$from" = target ]; then
			echo "On your build machine you should invoke:"
			echo
			echo " $ cd \$KERNELDIR"
			echo " $ make INSTALL_MOD_PATH=\$DISCIMAGE modules_install"
		else
			echo "You should invoke:"
			echo
			echo " $ cd $KERNELDIR"
			echo " $ make INSTALL_MOD_PATH=$DISCIMAGE modules_install"
		fi
		echo
		exit 1;
	fi

	# Install the standard kernel modules
	# Touch some files that might not exist so that busybox/modprobe don't complain
	#
	
	install_file pvrsrvkm.ko /system/bin/sgx/pvrsrvkm.ko "kernel module" 0644 0:0

if [ -z "$NO_DISPLAYMOD" ]; then
		install_file omaplfb.ko /system/bin/sgx/omaplfb.ko "kernel module" 0644 0:0

fi

if [ -z "$NO_BCDEVICE" ]; then
		install_file bc_example.ko /bc_example.ko "kernel module" 0644 0:0

fi



	# Install the standard libraries
	#
	install_file libGLESv1_CM_POWERVR_SGX530_125.so /system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libGLESv1_CM_POWERVR_SGX530_125.so.1.1.17.4352 /system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so


	install_file libusc.so /system/lib/libusc.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libusc.so.1.1.17.4352 /system/lib/libusc.so

	install_file libGLESv2_POWERVR_SGX530_125.so /system/lib/egl/libGLESv2_POWERVR_SGX530_125.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libGLESv2_POWERVR_SGX530_125.so.1.1.17.4352 /system/lib/egl/libGLESv2_POWERVR_SGX530_125.so

	install_file libglslcompiler.so /system/lib/libglslcompiler.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libglslcompiler.so.1.1.17.4352 /system/lib/libglslcompiler.so



	install_file libIMGegl.so /system/lib/libIMGegl.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libIMGegl.so.1.1.17.4352 /system/lib/libIMGegl.so
	install_file libEGL_POWERVR_SGX530_125.so /system/lib/egl/libEGL_POWERVR_SGX530_125.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libEGL_POWERVR_SGX530_125.so.1.1.17.4352 /system/lib/egl/libEGL_POWERVR_SGX530_125.so
	install_file libpvr2d.so /system/lib/libpvr2d.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libpvr2d.so.1.1.17.4352 /system/lib/libpvr2d.so

	install_file libpvrPVR2D_FRONTWSEGL.so /system/lib/libpvrPVR2D_FRONTWSEGL.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libpvrPVR2D_FRONTWSEGL.so.1.1.17.4352 /system/lib/libpvrPVR2D_FRONTWSEGL.so


	install_file libsrv_um.so /system/lib/libsrv_um.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libsrv_um.so.1.1.17.4352 /system/lib/libsrv_um.so
	install_file libsrv_init.so /system/lib/libsrv_init.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libsrv_init.so.1.1.17.4352 /system/lib/libsrv_init.so
	install_file libPVRScopeServices.so /system/lib/libPVRScopeServices.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libPVRScopeServices.so.1.1.17.4352 /system/lib/libPVRScopeServices.so



	install_file gralloc.omap3.so /system/lib/hw/gralloc.omap3.so.1.1.17.4352 "shared library" 0644 0:0
	install_link gralloc.omap3.so.1.1.17.4352 /system/lib/hw/gralloc.omap3.so

	install_file libpvrANDROID_WSEGL.so /system/lib/libpvrANDROID_WSEGL.so.1.1.17.4352 "shared library" 0644 0:0
	install_link libpvrANDROID_WSEGL.so.1.1.17.4352 /system/lib/libpvrANDROID_WSEGL.so



	# Install the standard executables
	#

	install_file pvrsrvinit /system/bin/pvrsrvinit "binary" 0755 0:0
	install_file sgx_init_test /system/bin/sgx_init_test "binary" 0755 0:0
	install_file devmem2 /system/bin/devmem2 "binary" 0755 0:0



	# Install the standard unittests
	#


	if [ ! -d ${DISCIMAGE}/data ]; then
		mkdir ${DISCIMAGE}/data
		chown 1000:1000 ${DISCIMAGE}/data
		chmod 0771 ${DISCIMAGE}/data
	fi

	if [ ! -d ${DISCIMAGE}/data/app ]; then
		mkdir ${DISCIMAGE}/data/app
		chown 1000:1000 ${DISCIMAGE}/data/app
		chmod 0771 ${DISCIMAGE}/data/app
	fi

	install_file services_test /system/bin/services_test "binary" 0755 0:0
	install_file sgx_blit_test /system/bin/sgx_blit_test "binary" 0755 0:0
	install_file sgx_clipblit_test /system/bin/sgx_clipblit_test "binary" 0755 0:0
	install_file sgx_flip_test /system/bin/sgx_flip_test "binary" 0755 0:0
	install_file sgx_render_flip_test /system/bin/sgx_render_flip_test "binary" 0755 0:0
	install_file pvr2d_test /system/bin/pvr2d_test "binary" 0755 0:0


	install_file testwrap /system/bin/testwrap "binary" 0755 0:0

	install_file gles1test1.apk /data/app/gles1test1.apk "binary" 0644 1000:1000
	install_file gles1_texture_stream.apk /data/app/gles1_texture_stream.apk "binary" 0644 1000:1000

	install_file gles2test1.apk /data/app/gles2test1.apk "binary" 0644 1000:1000
	install_file gles2_texture_stream.apk /data/app/gles2_texture_stream.apk "binary" 0644 1000:1000
	install_file eglinfo.apk /data/app/eglinfo.apk "binary" 0644 1000:1000
	install_file launcher.apk /data/app/launcher.apk "binary" 0644 1000:1000


	install_file hal_client_test /system/bin/hal_client_test "binary" 0755 0:0
	install_file hal_server_test /system/bin/hal_server_test "binary" 0755 0:0
	install_file framebuffer_test /system/bin/framebuffer_test "binary" 0755 0:0
	install_file texture_benchmark /system/bin/texture_benchmark "binary" 0755 0:0



	VENDOR_LIB_NAME=`echo libEGL_POWERVR_SGX530_125.so | sed 's,libEGL_\|\.so,,g'`
	$DOIT cat >${DISCIMAGE}/system/lib/egl/egl.cfg <<EOF
0 0 android
0 1 ${VENDOR_LIB_NAME}
EOF
	$DOIT echo "file /system/lib/egl/egl.cfg" >>${DISCIMAGE}${DDK_INSTALL_LOG}
}


# Work out if there are any special instructions.
#
while [ "$1" ]; do
	case "$1" in
	-v|--verbose)
		VERBOSE=v;
		;;
	-r|--root)
		DISCIMAGE=$2;
		shift;
		;;
	-u|--uninstall)
		UNINSTALL=y
		;;
	-n)	DOIT=echo
		;;
	--no-pvr)
		NO_PVR=y
		;;
	--no-x)
		NO_X=y
		;;
	--no-display)
		NO_DISPLAYMOD=y
		;;
	--no-bcdevice)
		NO_BCDEVICE=y
		;;
	-h | --help | *)	
		usage
		;;
	esac
	shift
done

# Find out where we are?  On the target?  On the host?
#
case `uname -m` in
arm*)	host=0;
		from=target;
		DISCIMAGE=/;
		;;
sh*)	host=0;
		from=target;
		DISCIMAGE=/;
		;;
i?86*)	host=1;
		from=host;
		if [ -z "$DISCIMAGE" ]; then	
			echo "DISCIMAGE must be set for installation to be possible." >&2
			exit 1
		fi
		;;
x86_64*)	host=1;
		from=host;
		if [ -z "$DISCIMAGE" ]; then	
			echo "DISCIMAGE must be set for installation to be possible." >&2
			exit 1
		fi
		;;
*)		echo "Don't know host to perform on machine type `uname -m`" >&2;
		exit 1
		;;
esac

if [ ! -d "$DISCIMAGE" ]; then
	echo "$0: $DISCIMAGE does not exist." >&2
	exit 1
fi

echo
echo "Installing PowerVR Consumer/Embedded DDK 1.7.17.4352 on $from"
echo
echo "File system installation root is $DISCIMAGE"
echo

# Uninstall whatever's there already.
#
uninstall
[ -n "$UNINSTALL" ] && exit

#  Now start installing things we want.
#
[ -z "$NO_PVR" ] && install_pvr

# All done...
#
echo 
echo "Installation complete!"
if [ "$host" = 0 ]; then
   echo "You may now reboot your target."
fi
echo
