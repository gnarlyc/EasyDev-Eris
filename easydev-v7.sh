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
      read -p "***    Please place a prebuilt ROM in $KITCHEN_ROOT !"
      echo ""
fi

echo ""
echo "***    Asking questions upfront    ***"
echo ""
echo " Would you like to install Google apps ?"
echo ""
echo " 1. Yes (default) "
echo " 2. No "
echo ""
echo -n "Please enter your choice: "
read gapps

echo ""
echo -n " Would you like to 'make clean' (y/n-default)? "
read clean

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
      repo init -u git://github.com/CyanogenMod/android.git -b gingerbread
fi

echo ""
echo "***    Sync repo    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7
repo sync -j16

echo ""
echo "***    Copying existing ROM to $KITCHEN_ROOT/EasyDev/CM7/ for unzip-files.sh to process    ***"
echo ""
cd $KITCHEN_ROOT
file=$(ls | grep .zip); mv $file desirec_update.zip
cp $KITCHEN_ROOT/desirec_update.zip $KITCHEN_ROOT/EasyDev/CM7/desirec_update.zip

echo ""
echo "***    Run unzip-files.sh    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7/device/htc/desirec
./unzip-files.sh
./extract-files.sh

echo ""
echo "***    Get RomManager    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/
./get-rommanager

# Google Apps option
case $gapps in
   *) echo ""; echo "***     Installing Google Apps    ***"; echo ""; ./get-google-files -v gb;;
   2) echo ""; echo " Ok, no Google Apps will be installed. "; echo "";;  
esac

echo ""
echo "***    Run envsetup.sh    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7
. build/envsetup.sh

echo ""
echo "***    lunch cyangen_desirec-eng    ***"
echo ""
lunch cyanogen_desirec-eng

echo ""
echo "***    Compiling CM7    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7
mka bacon

echo ""
echo "Your ROM should be in $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec "
echo ""
