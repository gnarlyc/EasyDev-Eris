#!/bin/bash
# Armin Čoralić http://blog.coralic.nl
# Part 1 modified by gnarlyc
# Part 2 created mostly by gnarlyc although I just took the commands from the CM site and made them into a script.
# Thanks to Conap & Workshed for helping to work out the kinks.
# Thanks to dsixda for script examples in his kitchen
# Thanks to workshed for the new vendor tree for CM7!!

echo "***********     EasyDev -v7 CM Edition     **********"
echo ""
echo "***********            Team ADX            **********"

echo ""
echo "***    Installing dependencies    ***"
echo ""
add-apt-repository "deb http://archive.canonical.com/ lucid partner"
apt-get update
apt-get install git-core gnupg flex bison gperf libsdl-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev sun-java6-jdk pngcrush

echo ""
echo "***    Declaring variables    ***"
echo ""
export KITCHEN_ROOT=`pwd`
export VT_REPO=https://github.com/workshed64/android_device_htc_desirec_gb.git
export KERNEL_REPO=https://github.com/Conap30/htc_kernel_desirec_cfs.git
export KERN_SOURCE_DIR=htc_kernel_desirec_cfs

read -p " Press enter to continue "
echo ""
echo "***    Setting up the folders    ***"
echo ""
mkdir -p $KITCHEN_ROOT/EasyDev/CM7/

if [ ! -d $KITCHEN_ROOT/EasyDev/bin ]
   then
      mkdir $KITCHEN_ROOT/EasyDev/bin
fi

echo ""
echo "***    Checking for existing ROM    ***"
echo ""
if [ ! -f $KITCHEN_ROOT/*.zip ]
   then
      echo ""
      read -p "***     Please place a prebuilt ROM in $KITCHEN_ROOT !"
      echo ""
fi

#echo ""
#echo "***    Checking for existing RomManager.apk    ***"
#echo ""
#if [ ! -f $KITCHEN_ROOT/RomManager.apk ]
#   then
#      echo ""
#      read -p "***     Please place RomManager.apk in $KITCHEN_ROOT !"
#      echo ""
#fi

echo ""
echo "***    Asking questions upfront    ***"
echo ""
echo " Would you like to install Google apps ?"
echo ""
echo " 1. Full (default) "
echo " 2. Tiny "
echo " 3. None "
echo ""
echo -n "Please enter your choice: "
read gapps


echo ""
echo " What version of CM would you like to build ?"
echo ""
echo " 1. Gingerbread (CM7) (default)"
#echo " 2. Froyo "
echo ""
echo -n "Please enter your choice: "
read cmversion
case $cmversion in
#   2) echo""; echo " Pulling CM7 Froyo source "; export cmversion=froyo;;
   *) echo""; echo " Pulling CM7 source"; export cmversion=gingerbread;;
esac

echo ""
echo " Which kernel would you like to compile into the ROM? "
echo ""
echo "  1. DecafuctCFS current (default)"
echo "  2. DecafuctBFS current "
echo "  3. stock HTC "
echo ""
echo -n "Please enter your choice: "
read kernel_ver

echo ""
echo -n " Would you like to 'make clean' (y/n-default)? "
read clean

echo ""
echo -n " Would you like to run the squisher? (y-default/n)"
read squisher

read -p " Press enter to continue "
export PATH=$PATH:$KITCHEN_ROOT/EasyDev/bin
if [ ! -d $KITCHEN_ROOT/EasyDev/CM7/.repo/ ]
   then

      echo ""
      echo "***    Setting PATH and getting 'repo'    ***"
      echo ""
      curl http://android.git.kernel.org/repo > $KITCHEN_ROOT/EasyDev/bin/repo
      chmod a+x $KITCHEN_ROOT/EasyDev/bin/repo

      echo ""
      echo "***    Initialize GIT repo    ***"
      echo ""
      cd $KITCHEN_ROOT/EasyDev/CM7
      repo init -u git://github.com/CyanogenMod/android.git -b $cmversion
fi

read -p " Press enter to continue "
echo ""
echo "***    Sync repo    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7
repo sync

#read -p " Press enter to continue "
## Cleanup (optional, but I like to start fresh... Just comment out if you want.)
#echo ""
#echo "***     Cleanup old vendor tree    ***"
#echo ""
#cd $KITCHEN_ROOT/EasyDev/CM7/device/htc/
#rm -rf desirec/
#rm -rf android_device_htc_desirec

#read -p " Press enter to continue "
#echo ""
#echo "***    Sync vendor tree    ***"
#echo ""
#git clone $VT_REPO

# rename the resulting folder
#mv android_device_htc_desirec/ desirec/

#read -p " Press enter to continue "
#echo ""
#echo "***    Copying build files from vendor tree    ***"
#echo ""
#cp $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/vendor/cyanogen_desirec.mk $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/products/cyanogen_desirec.mk
#cp $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/vendor/AndroidProducts.mk $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/products/AndroidProducts.mk
#cp $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/vendor/vendorsetup.sh $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/vendorsetup.sh

#read -p " Press enter to continue "
#echo ""
#echo "***    Removing unneeded folder    ***"
#echo ""
#rm -rf desirec/vendor/

read -p " Press enter to continue "
echo ""
echo "***    Copying existing ROM to $KITCHEN_ROOT/EasyDev/CM7/ for unzip-files.sh to process    ***"
echo ""
cd $KITCHEN_ROOT
file=$(ls | grep .zip); mv $file desirec_update.zip
cp $KITCHEN_ROOT/desirec_update.zip $KITCHEN_ROOT/EasyDev/CM7/desirec_update.zip

#read -p " Press enter to continue "
# I don't know why it wouldn't work for me without modding this. I can't change the source directly, so...
#echo ""
#echo "***    Adding 'ro.modversion=CyanogenMod6-Eris' to system.prop    ***"
#echo ""
#echo 'ro.modversion=CyanogenMod6-Eris' >> $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/system.prop

read -p " Press enter to continue "
echo ""
echo "***    Run unzip-files.sh    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec
./unzip-files.sh
./extract-files.sh

read -p " Press enter to continue "
echo ""
echo "***    Get RomManager    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/
./get-rommanager
#cp -p $KITCHEN_ROOT/RomManager.apk $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/proprietary/

read -p " Press enter to continue "
# Google Apps option
case $gapps in
   2) echo ""; echo "***     Installing Google Apps (Tiny)   ***"; echo ""; ./get-google-files -v MDPI-Tiny;;
   3) echo ""; echo " Ok, no Google Apps will be installed. "; echo "";;
   *) echo ""; echo "***     Installing Google Apps    ***"; echo ""; ./get-google-files -v MDPI;;
esac

read -p " Press enter to continue "
echo ""
echo "***    Run envsetup.sh    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7
. build/envsetup.sh

read -p " Press enter to continue "
echo ""
echo "***    lunch cyangen_desirec-eng    ***"
echo ""
lunch cyanogen_desirec-eng

# kernel option
case $kernel_ver in
  1) export KERNEL_REPO=https://github.com/Conap30/htc_kernel_desirec_cfs.git; export KERN_SOURCE_DIR=htc_kernel_desirec_cfs;;
  2) export KERNEL_REPO=https://github.com/Conap30/htc_kernel_desirec_bfs.git; export KERN_SOURCE_DIR=htc_kernel_desirec_bfs;;
  3) export KERNEL_REPO=https://github.com/gnarlyc/desirec_2.6.29.git; export KERN_SOURCE_DIR=desirec_2.6.29;;
  *) echo "Invalid option";; 
esac

read -p " Press enter to continue "
echo ""
echo "***    Syncing kernel source    ***"
echo ""
if [ ! -d $KITCHEN_ROOT/EasyDev/kernels/$KERN_SOURCE_DIR ]
	then 
		mkdir -p $KITCHEN_ROOT/EasyDev/kernels/
		cd $KITCHEN_ROOT/EasyDev/kernels/
		git clone $KERNEL_REPO
	else
		cd $KITCHEN_ROOT/EasyDev/kernels/$KERN_SOURCE_DIR/
		git pull
fi

read -p " Press enter to continue "
echo ""
echo "***    Compiling kernel    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/kernels/$KERN_SOURCE_DIR/
export ARCH=arm
export CROSS_COMPILE=arm-eabi-
export PATH=$PATH:$KITCHEN_ROOT/EasyDev/CM7/prebuilt/linux-x86/toolchain/arm-eabi-4.4.0/bin
make -j$(grep -c processor /proc/cpuinfo)

read -p " Press enter to continue "
echo ""
echo "***    Copying zImage to kernel in vendor tree    ***"
echo ""
rm $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/kernel
cp arch/arm/boot/zImage $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/kernel

read -p " Press enter to continue "
echo ""
echo "***    Compiling wlan module    ***"
echo ""
export KERNEL_DIR=$KITCHEN_ROOT/EasyDev/kernels/$KERN_SOURCE_DIR/
cd $KITCHEN_ROOT/EasyDev/CM7/system/wlan/ti/sta_dk_4_0_4_32/
make -j$(grep -c processor /proc/cpuinfo)

read -p " Press enter to continue "
echo ""
echo "***    Copying wlan.ko to vendor tree    ***"
echo ""
rm $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/modules/wlan.ko
cp wlan.ko $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec/modules/wlan.ko

read -p " Press enter to continue "
# make clean option
case $clean in
   y) cd $KITCHEN_ROOT/EasyDev/CM7; make clean;;
   *) echo " Ok, no 'make clean' will be done.";;
esac

read -p " Press enter to continue "
echo ""
echo "***    Compiling CM7    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7
make -j4 otapackage

read -p " Press enter to continue "
# squisher option
case $squisher in 
   n) echo ""; echo "Your ROM should be in $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec "; echo ""; exit 1;;
   *) $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/tools/squisher;;
esac

echo ""
echo "Your ROM should be in $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec "
echo ""
