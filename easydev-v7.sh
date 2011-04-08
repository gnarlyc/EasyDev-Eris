#!/bin/bash
# Armin Čoralić http://blog.coralic.nl
# Part 1 modified by gnarlyc
# Part 2 created mostly by gnarlyc although I just took the commands from the CM site and made them into a script.
# Thanks to Conap & Workshed for helping to work out the kinks.
# Thanks to dsixda for script examples in his kitchen
# Thanks to workshed for the new CM7 vendor tree for the Eris, and re-editing this script!!

echo "***********     EasyDev -v7 CM Edition     **********"
echo ""
echo "***********            Team ADX            **********"

echo ""
echo "***    Installing dependencies    ***"
echo ""
add-apt-repository "deb http://archive.canonical.com/ lucid partner"
apt-get update
apt-get install git-core gnupg flex bison gperf libsdl-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev sun-java6-jdk pngcrush schedtool g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline5-dev gcc-4.3-multilib g++-4.3-multilib

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
chmod a+x unzip-files.sh
chmod a+x extract-files.sh
./unzip-files.sh
./extract-files.sh

echo ""
echo "***    Get RomManager    ***"
echo ""
cd $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/
./get-rommanager

# Google Apps option
case $gapps in
   2) echo ""; echo " Ok, no Google Apps will be installed. "; echo "";;
   *) echo ""; echo "***     Installing Google Apps    ***"; echo ""; ./get-google-files -v gb
mkdir -p out/target/product/desirec/system/app/
mkdir -p out/target/product/desirec/system/etc/permissions/
mkdir -p out/target/product/desirec/system/lib/
mkdir -p out/target/product/desirec/system/framework/
cd $KITCHEN_ROOT/EasyDev/CM7/vendor/cyanogen/proprietary/
cp BooksPhone.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/BooksPhone.apk
cp CarHomeGoogle.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/CarHomeGoogle.apk
cp FOTAKill.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/FOTAKill.apk
cp GenieWidget.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GenieWidget.apk
cp GoogleBackupTransport.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GoogleBackupTransport.apk
cp GoogleCalendarSyncAdapter.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GoogleCalendarSyncAdapter.apk
cp GoogleContactsSyncAdapter.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GoogleContactsSyncAdapter.apk
cp GoogleFeedback.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GoogleFeedback.apk
cp GooglePartnerSetup.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GooglePartnerSetup.apk
cp GoogleQuickSearchBox.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GoogleQuickSearchBox.apk
cp GoogleServicesFramework.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/GoogleServicesFramework.apk
cp LatinImeTutorial.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/LatinImeTutorial.apk
cp MarketUpdater.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/MarketUpdater.apk
cp MediaUploader.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/MediaUploader.apk
cp NetworkLocation.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/NetworkLocation.apk
cp OneTimeInitializer.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/OneTimeInitializer.apk
cp SetupWizard.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/SetupWizard.apk
cp Talk.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/Talk.apk
cp Vending.apk $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/app/Vending.apk
cp com.google.android.maps.xml $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/etc/permissions/com.google.android.maps.xml
cp features.xml $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/etc/permissions/features.xml
cp libvoicesearch.so $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/lib/libvoicesearch.so
cp com.google.android.maps.jar $KITCHEN_ROOT/EasyDev/CM7/out/target/product/desirec/system/framework/com.google.android.maps.jar
;;  
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
