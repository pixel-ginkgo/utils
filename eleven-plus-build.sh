#!/usr/bin/env bash

#
# Pixel Experience 11 build script
#

ORG_URL="https://github.com/pixel-ginkgo"
MANIFEST_URL="git://github.com/PixelExperience/manifest.git"
BRANCH="eleven"

repo init -u $MANIFEST_URL -b $BRANCH-plus
repo sync --force-sync -c -q --no-tag --no-clone-bundle --optimized-fetch --current-branch -f -j16 || exit 0

git clone $ORG_URL/device_xiaomi_ginkgo -b $BRANCH device/xiaomi/ginkgo
git clone $ORG_URL/kernel_xiaomi_ginkgo -b $BRANCH kernel/xiaomi/ginkgo
git clone $ORG_URL/vendor_xiaomi_ginkgo -b $BRANCH vendor/xiaomi/ginkgo
git clone $ORG_URL/prebuilts_clang_host_linux-x86_clang-sdllvm -b $BRANCH prebuilts/clang/host/linux-x86/clang-sdllvm

rm -rf hardware/qcom-caf/sm8150/display
git clone $ORG_URL/hardware_qcom-caf_sm8150_display -b $BRANCH hardware/qcom-caf/sm8150/display

cd vendor/aosp
git fetch $ORG_URL/vendor_aosp
git cherry-pick 6b4719b2decf6837bb55a378161d3d064a35f5d1 # build: Switch to DarkJoker360 build type
cd ../..

. build/envsetup.sh
lunch aosp_ginkgo-userdebug
mka bacon -j32
