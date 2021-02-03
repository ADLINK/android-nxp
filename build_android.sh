#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'

if [ -z "$WORKSPACE" ];then
	WORKSPACE=$PWD
	echo "Setting WORKSPACE to $WORKSPACE"
fi

if [ -z "$android_builddir" ];then
	android_dir=android_build
	android_builddir=$WORKSPACE/$android_dir
	echo "Setting android_builddir to $android_builddir"
fi

imx_files="imx-p9.0.0_2.0.0-ga"
adlink_files="adlink"
patches="$WORKSPACE"/patches

echo -e "${YELLOW}"
echo -e "Adlink IMX8M\nAndroid version - 9.0\n\
Release version - 1v0\n\
NXP android manifest - imx-p9.0.0_2.0.0-ga.xml\n"
echo -e "${NC}"

check_tools()
{
	if ! [ -x "$(command -v repo)" ]; then
  		echo -e "${RED}Error: repo is not installed.${NC}"
  		exit 1
	fi
	if ! [ -x "$(command -v git)" ]; then
  		echo -e "${RED}Error: git is not installed.${NC}"
  		exit 1
	fi
	if ! [ -x "$(command -v curl)" ]; then
  		echo -e "${RED}Error: curl is not installed.${NC}"
  		exit 1
	fi
}

clone_android()
{
	cd $WORKSPACE
	echo -e "${YELLOW}Repo init started .... ${NC}"
	if [ ! -d "$android_builddir" ]; then
		mkdir "$android_dir"
		cd "$android_dir"

		mkdir repobin
		curl https://storage.googleapis.com/git-repo-downloads/repo > ./repobin/repo
		chmod a+x ./repobin/repo

		./repobin/repo init -u https://source.codeaurora.org/external/imx/imx-manifest.git -b imx-android-pie -m imx-p9.0.0_2.0.0-ga.xml

		rc=$?
		if [ "$rc" != 0 ]; then
			echo -e "${RED}Repo Init failure${NC}"
			cd $WORKSPACE
			rm -rf $android_dir
			exit 1
		fi
	else
		cd "$android_builddir"
	fi

	echo -e "${YELLOW}Repo sync started .... ${NC}"
	./repobin/repo sync -j4
	rc=$?
	if [ "$rc" != 0 ]; then
		echo -e "${RED}Repo sync failure${NC}"
		exit 1
	fi
	echo -e "\n${GREEN}Android source clone completed .... ${NC}\n"
}

copy_vendor_files()
{
	cd $WORKSPACE
	
	echo -e "${YELLOW}copying vendor files .... ${NC}"
	tar -xvzf imx-p9.0.0_2.0.0-ga.tar.gz
	rc=$?
	if [ "$rc" != 0 ]; then
		echo -e "${RED}NXP package $imx_files.tar.gz not present in current directory${NC}\n\n"
		echo -e "${YELLOW}Please download package into current directory from below path: ${NC}\n"
		echo -e "${YELLOW}https://www.nxp.com/webapp/sps/download/license.jsp?colCode=P9.0.0_2.0.0_GA_ANDROID_SOURCE&appType=file1&DOWNLOAD_ID=null${NC}\n"
		exit 1
	fi
	
	cp -r "$WORKSPACE"/"$imx_files"/vendor/nxp "$android_builddir"/vendor/
	cp -r "$WORKSPACE"/"$imx_files"/EULA.txt "$android_builddir"
	cp -r "$WORKSPACE"/"$imx_files"/SCR* "$android_builddir"
	cp -r "$WORKSPACE"/"$adlink_files" "$android_builddir"/vendor/
}

apply_patches()
{
	echo -e "${YELLOW}Applying patches ... ${NC}"
	cd $patches
	flist=$(cat list)
	for i in $flist
	do
		cp "$i"/*.patch "$android_builddir"/"$i"
		cd "$android_builddir"/"$i"
		rm -rf .git/rebase-apply/
		git am *.patch
		rm *.patch
		cd "$patches"
	done
	echo -e "${GREEN}All patches applied ... ${NC}"
}

build_android()
{
	echo -e "${YELLOW}Starting build ... ${NC}"
	cd $android_builddir
	source build/envsetup.sh
	lunch evk_8mq-userdebug
	make -j4

	cd $WORKSPACE
	mkdir binaries
	cp "$android_builddir"/device/fsl/common/tools/fsl-sdcard-partition.sh ./binaries
	cp "$android_builddir"/out/target/product/evk_8mq/*.img ./binaries
	cp "$android_builddir"/vendor/adlink/uboot/u-boot-imx8mq.imx ./binaries

	echo -e "${GREEN}compiled files copied to directory binaries${NC}" 
}

#check_tools
#clone_android
copy_vendor_files
apply_patches
build_android

