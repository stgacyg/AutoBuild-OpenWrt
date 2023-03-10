#!/bin/bash
#============================================================
# File name: diy-script.sh
# Description: OpenWrt DIY script (After Update feeds)
# Lisence: MIT
# Author: cnbbx
#============================================================

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.0./192.168.11./g' feeds/luciApp/applications/luci-app-pptp-server/root/etc/config/pptpd

# Modify hostname
sed -i 's/OpenWrt/Cnbbx/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/OpenWrt/Cnbbx/g' package/base-files/files/bin/config_generate

# Cancel power on and disable WIFI
sed -i '/set wireless.radio${devidx}.disabled/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/bootstrap/argon/g' feeds/luci/modules/luci-base/root/etc/config/luci

# Modify Packages
sed -i 's/+ariang//g'  feeds/luci/applications/luci-app-aria2/Makefile
sed -i 's/+alist//g'  feeds/luciApp/applications/luci-app-alist/Makefile

# Compressed xray
cd feeds/packages/net/
rm -rf xray-core
ln -sf ../../../feeds/small/xray-core/ xray-core
sed -i -e "/GoPackage/a  \\\t$\(STAGING_DIR_HOST\)\/bin\/upx --lzma --best $\(PKG_INSTALL_DIR\)\/usr\/bin\/main" feeds/small/xray-core/Makefile
cp -f /dev/null feeds/kenzo/luci-app-ssr-plus/root/etc/ssrplus/gfw_list.conf
cp -f /dev/null feeds/kenzo/luci-app-ssr-plus/root/etc/ssrplus/china_ssr.txt

# Set lan wan
sed -i '/lenovo,newifi-d1/a \\tyouku,youku_yk-l2\|\\'  target/linux/ramips/mt7621/base-files/etc/board.d/02_network

# Rom Size
echo '# Rom Size' >> .config
echo 'CONFIG_TARGET_KERNEL_PARTSIZE=16' >> .config
echo 'CONFIG_TARGET_ROOTFS_PARTSIZE=32' >> .config

# Modify the version number
sed -i '/CONFIG_IMAGEOPT/d' .config
sed -i '/CONFIG_VERSIONOPT/d' .config
sed -i '/CONFIG_VERSION_DIST/d' .config
sed -i '/CONFIG_VERSION_NUMBER/d' .config
sed -i '/CONFIG_VERSION_CODE/d' .config
sed -i '/CONFIG_VERSION_HOME_URL/d' .config
echo '# Image Configurations' >> .config
echo 'CONFIG_IMAGEOPT=y' >> .config
echo 'CONFIG_VERSIONOPT=y' >> .config
echo 'CONFIG_VERSION_DIST="Cnbbx"' >> .config
echo 'CONFIG_VERSION_NUMBER="R22.03"' >> .config
echo "CONFIG_VERSION_CODE=\"build $(TZ=UTC-8 date "+%Y.%m.%d")"\" >> .config
echo 'CONFIG_VERSION_HOME_URL="http://youku.i.cnbbx.com/"' >> .config

# sed -i 's/not//g'  feeds/luci/modules/luci-base/src/mkversion.sh

# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="Cnbbx"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"Cnbbx"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config 
