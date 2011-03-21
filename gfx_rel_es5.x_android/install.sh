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

# Auto-generated for omap3630_android from embedded.pj 1.5.15.2766
#

# PVR Consumer services version number
#
PVRVERSION=1.5.15.2766

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
# $1=fromfile, $2=destfilename, $3=blurb $4=chmod-flags
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

	# If it already exists then back it up if there isn't a back-up already.
	#
	#if [ -f $DESTFILE ]; then
	#	if [ ! -f ${DESTFILE}.old ]; then
	#		$DOIT mv $DESTFILE ${DESTFILE}.old ||
	#				bail "Couldn't back up $DESTFILE";
	#		[ -n "$VERBOSE" ] && echo "Backed up $DESTFILE";
	#	fi
	#fi

	# Delete the original so that permissions don't persist.
	#
	$DOIT rm -f $DESTFILE

	$DOIT cp -f $1 $DESTFILE || bail "Couldn't copy $1 to $DESTFILE"
	$DOIT chmod 644 ${DESTFILE}
	if [ "$4" ]; then
		$DOIT chmod $4 ${DESTFILE};
	fi
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
	$DOIT echo "version 1.5.15.2766" >${DISCIMAGE}${DDK_INSTALL_LOG}
	# Install the standard scripts
	#
	install_file rc.pvr /system/bin/sgx/rc.pvr "boot script" a+x

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
		install_file pvrsrvkm.ko /system/bin/sgx/pvrsrvkm.ko "kernel module"



if [ -z "$NO_DISPLAYMOD" ]; then
		install_file omaplfb.ko /system/bin/sgx/omaplfb.ko "kernel module"

fi

if [ -z "$NO_BCDEVICE" ]; then
		install_file bc_example.ko /system/bin/sgx/bc_example.ko "kernel module"

fi

#	$DOIT touch ${DISCIMAGE}/lib/modules/modprobe.conf
#	$DOIT touch ${DISCIMAGE}/etc/modules.conf
#	$DOIT rm -f /tmp/modules.$$.tmp

	# Install the standard libraries
	#

	install_file libGLESv1_CM_POWERVR_SGX530_125.so /system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so.1.1.15.2766 "shared library"
	install_link libGLESv1_CM_POWERVR_SGX530_125.so.1.1.15.2766 /system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so

	install_file libGLESv2_POWERVR_SGX530_125.so /system/lib/egl/libGLESv2_POWERVR_SGX530_125.so.1.1.15.2766 "shared library"
	install_link libGLESv2_POWERVR_SGX530_125.so.1.1.15.2766 /system/lib/egl/libGLESv2_POWERVR_SGX530_125.so

	install_file libglslcompiler.so /system/lib/libglslcompiler.so.1.1.15.2766 "shared library"
	install_link libglslcompiler.so.1.1.15.2766 /system/lib/libglslcompiler.so


	install_file libIMGegl.so /system/lib/libIMGegl.so.1.1.15.2766 "shared library"
	install_link libIMGegl.so.1.1.15.2766 /system/lib/libIMGegl.so
	install_file libEGL_POWERVR_SGX530_125.so /system/lib/egl/libEGL_POWERVR_SGX530_125.so.1.1.15.2766 "shared library"
	install_link libEGL_POWERVR_SGX530_125.so.1.1.15.2766 /system/lib/egl/libEGL_POWERVR_SGX530_125.so
	install_file libpvr2d.so /system/lib/libpvr2d.so.1.1.15.2766 "shared library"
	install_link libpvr2d.so.1.1.15.2766 /system/lib/libpvr2d.so



	install_file libsrv_um.so /system/lib/libsrv_um.so.1.1.15.2766 "shared library"
	install_link libsrv_um.so.1.1.15.2766 /system/lib/libsrv_um.so
	install_file libPVRScopeServices.so /system/lib/libPVRScopeServices.so.1.1.15.2766 "shared library"
	install_link libPVRScopeServices.so.1.1.15.2766 /system/lib/libPVRScopeServices.so



	install_file gralloc.omap3.so /system/lib/hw/gralloc.omap3.so.1.1.15.2766 "shared library"
	install_link gralloc.omap3.so.1.1.15.2766 /system/lib/hw/gralloc.omap3.so

	install_file libfakehal.so /system/lib/libfakehal.so.1.1.15.2766 "shared library"
	install_link libfakehal.so.1.1.15.2766 /system/lib/libfakehal.so

	install_file libpvrANDROID_WSEGL.so /system/lib/libpvrANDROID_WSEGL.so.1.1.15.2766 "shared library"
	install_link libpvrANDROID_WSEGL.so.1.1.15.2766 /system/lib/libpvrANDROID_WSEGL.so

	install_file libsfutil.so /system/lib/libsfutil.so.1.1.15.2766 "shared library"
	install_link libsfutil.so.1.1.15.2766 /system/lib/libsfutil.so


	# Install the standard executables
	#

	install_file pvrsrvinit /system/bin/pvrsrvinit "binary" a+x
	install_file sgx_init_test /system/bin/sgx_init_test "binary" a+x



	# Install the standard unittests
	#
	install_file gles2test1 /system/bin/gles2test1 "binary" a+x
	install_file glsltest1_vertshader.txt /system/bin/glsltest1_vertshader.txt "shader" a+x
	install_file glsltest1_fragshaderA.txt /system/bin/glsltest1_fragshaderA.txt "shader" a+x
	install_file glsltest1_fragshaderB.txt /system/bin/glsltest1_fragshaderB.txt "shader" a+x
	install_file gles2_texture_stream /system/bin/gles2_texture_stream "binary" a+x

	install_file gles1test1 /system/bin/gles1test1 "binary" a+x
	install_file gles1_texture_stream /system/bin/gles1_texture_stream "binary" a+x

	install_file services_test /system/bin/services_test "binary" a+x
	install_file sgx_blit_test /system/bin/sgx_blit_test "binary" a+x
	install_file sgx_flip_test /system/bin/sgx_flip_test "binary" a+x
	install_file sgx_render_flip_test /system/bin/sgx_render_flip_test "binary" a+x
	install_file pvr2d_test /system/bin/pvr2d_test "binary" a+x
	install_file eglinfo /system/bin/eglinfo "binary" a+x
##GLESUNITTEST(egl_test)dnl
##GLES2UNITTEST(gl2info)dnl
##ifelse(SUPPORT_PVR2D,1,[[UNITTEST(pvr2dtest)]])dnl
##ifdef([[_BUFFER_CLASS_DEVICE_]],
##	if [ -z "$NO_BCDEVICE" ]; then
##	UNITTEST(sw_camera_ctrl)dnl
##	UNITTEST(ogles_camera_ext)dnl
##fi)

	install_file hal_client_test /system/bin/hal_client_test "binary" a+x
	install_file hal_server_test /system/bin/hal_server_test "binary" a+x
	install_file framebuffer_test /system/bin/framebuffer_test "binary" a+x
	install_file texture_benchmark /system/bin/texture_benchmark "binary" a+x
	install_file xmultiegltest /system/bin/xmultiegltest "binary" a+x
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
		shift; shift;
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
echo "Installing PowerVR Consumer/Embedded DDK 1.5.15.2766 on $from"
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
