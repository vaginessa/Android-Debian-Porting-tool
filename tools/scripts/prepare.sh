#!/bin/sh

# Get device codename and save it to a file
adb start-server
echo "Please plug in your phone through usb to continue, the script will start automatic."
adb 'wait-for-device'
adb shell "getprop ro.product.device" > ${PWD}/device.txt
device=`tr -d '\r' < device.txt`
# Creating Directories
mkdir ${PWD}/devices/$device
mkdir ${PWD}/devices/$device/data
mkdir ${PWD}/devices/$device/patches
mkdir ${PWD}/devices/$device/bootimage

# Pulling info from device
adb shell "ls /dev" >${PWD}/devices/$device/data/dev
adb shell "ls /dev/input" >${PWD}/devices/$device/data/input
adb shell "ls /dev/graphic" >${PWD}/devices/$device/data/graphic
adb shell "ls /dev/graphics" >${PWD}/devices/$device/data/graphics
adb shell "ls -al /dev/block/platform/*/by-name" >${PWD}/devices/$device/data/partitions



# Creating some variables
graphic=`tr -d '\r' < ${PWD}/devices/$device/data/graphic`
graphics=`tr -d '\r' < ${PWD}/devices/$device/data/graphics`
# Echo some info
echo "Make sure this info is correct before proceeding to the next step."
echo "Codename: $device"

# Make a "/dev/graphic(s) No such file or directory" check
if [ "$graphics" = "/dev/graphics: No such file or directory" -a "$graphic" = "/dev/graphic: No such file or directory" ]; then
	echo "No Framebuffer found, aborting"
	exit
else if [ "$graphic" = "/dev/graphic: No such file or directory" ]; then
	 	echo "Framebuffer: $graphics"
		framebuffer=$graphics
else if [ "$graphics" = "/dev/graphics: No such file or directory" ]; then
 			echo "Framebuffer: $graphic"
			framebuffer=$graphic
		
		fi
	fi
fi

# Creating a patch for your framebuffer
echo "Patching chroot with your Framebuffer: $framebuffer"
cp ${PWD}/files/linux_chroot/init.stage2 ${PWD}/devices/$device/patches/init.stage2
sed -i -n '1' -e "s/fb1/$framebuffer/g" ${PWD}/devices/$device/patches/init.stage2


# Done
echo "Done with setting up, make sure to place your Cyanogenmod boot.img in ${PWD}/devices/$device/bootimage"


