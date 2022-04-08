#
#!/bin/bash
# © 2021 GitHub, Inc.
#====================================================================
# Copyright (c) 2019-2021 iplcdn <https://iplcdn.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/MuaCat/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#====================================================================

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/10.10.10.1/10.0.0.1/g' package/base-files/files/bin/config_generate
#Boos4721源编译的固件特别说明： 管理地址：10.10.10.1 登陆密码：boos 无线密码：1234567890

# Modify hostname
#sed -i 's/OpenWrt/OpenWrt/g' package/base-files/files/bin/config_generate 

# Delete default password
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings
# Delete default password:boos
#sed -i '/HBAtVXABp7XbvVjG4193B/d' package/lean/default-settings/files/zzz-default-settings

# Modify the version number版本号里显示一个自己的名字（AutoBuild $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
sed -i 's/OpenWrt /AutoBuild $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g' package/lean/default-settings/files/zzz-default-settings

# 修改主机名字，把Xiaomi-R4A修改你喜欢的就行（不能纯数字或者使用中文）
#sed -i '/uci commit system/i\uci set system.@system[0].hostname='Xiaomi-R4A'' package/lean/default-settings/files/zzz-default-settings

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
# themes添加（svn co 命令意思：指定版本如https://github）

# 修改默认wifi名称ssid为100
#sed -i 's/ssid=OpenWrt/ssid=100/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#开启MU-MIMO
sed -i 's/mu_beamformer=0/mu_beamformer=1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#wifi加密方式，没有是none
#sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#wifi密码
sed -i 's/key=password/key=gds.2021/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修复核心及添加温度显示
#sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
#sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# Add kernel build user
#[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
#    echo 'CONFIG_KERNEL_BUILD_USER="OpenWrt"' >>.config ||
#    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"OpenWrt"@' .config

# Add kernel build domain
#[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
#    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
#    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config
#================================================================================================
# 修改连接数
#sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=165535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#修正连接数（by ベ七秒鱼ベ）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# themes添加（svn co 命令意思：指定版本如https://github）
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

git clone https://github.com/kiddin9/openwrt-packages.git package/openwrt-packages

git clone https://github.com/sirpdboy/luci-app-netdata.git package/luci-app-netdata

#添加额外非必须软件包
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/vernesong/OpenClash.git package/OpenClash
#git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot
git clone https://github.com/riverscn/openwrt-iptvhelper.git package/openwrt-iptvhelper
#git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
#添加smartdns
git clone https://github.com/kiddin9/luci-app-dnsfilter.git package/luci-app-dnsfilter
git clone https://github.com/pymumu/openwrt-smartdns package/smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
#================================================================================================
git clone https://github.com/xiaoqingfengATGH/feeds-xiaoqingfeng.git
#移除不用软件包    
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-wrtbwmon
rm -rf feeds/packages/net/smartdns

#添加额外软件包
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/immortalwrt/packages.git
#replace mirrors
#rm -rf ./include
#rm -rf ./ scripts
#svn co https://github.com/immortalwrt/immortalwrt/trunk/include
#svn co https://github.com/immortalwrt/immortalwrt/trunk/scripts

git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/luci-app-ttnode
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman
git clone https://github.com/rufengsuixing/luci-app-autoipsetadder.git package/luci-app-autoipsetadder
git clone https://github.com/mchome/openwrt-dogcom.git package/openwrt-dogcom
git clone https://github.com/mchome/luci-app-dogcom.git package/luci-app-dogcom
#git clone https://github.com/garypang13/luci-app-dnsfilter package/luci-app-dnsfilter
#git clone https://github.com/small-5/luci-app-adblock-plus package/luci-app-adblock-plus
svn co https://github.com/HoldOnBro/packages/trunk/luci-app-adblock-plus package/luci-app-adblock-plus
git clone https://github.com/iwrt/luci-app-ikoolproxy package/luci-app-ikoolproxy

#git clone https://github.com/vernesong/OpenClash.git package/OpenClash
#cp -r package/OpenClash/luci-app-openclash package/
#rm -rf package/OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
#svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-filebrowser package/luci-app-filebrowser
#svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/utils/filebrowser package/filebrowser
#svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-fileassistant package/luci-app-fileassistant
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-socat package/luci-app-socat
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks package/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/hysteria package/hysteria
svn co https://github.com/fw876/helloworld/trunk/xray-core package/xray-core
svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/simple-obfs package/simple-obfs
svn co https://github.com/fw876/helloworld/trunk/trojan package/trojan
svn co https://github.com/fw876/helloworld/trunk/v2ray-core package/v2ray-core
svn co https://github.com/fw876/helloworld/trunk/v2ray-geodata package/v2ray-geodata
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/xray-core
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-gost package/luci-app-gost
#svn co https://github.com/kenzok8/openwrt-packages/trunk/gost package/gost
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-gost package/luci-app-gost
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/gost package/gost
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
# cd package/luci-app-serverchan && git reset --hard 6387b3b47b03d95d3f3bcd42ff98db5bb84fd056 && git pull && cd ../..
svn co https://github.com/brvphoenix/wrtbwmon/trunk/wrtbwmon package/wrtbwmon
git clone https://github.com/brvphoenix/luci-app-wrtbwmon
cd luci-app-wrtbwmon
git reset --hard ff7773abbf71120fc39a276393b29ba47353a7e2
cp -r luci-app-wrtbwmon ../package/
cd ..
# themes
git clone https://github.com/Leo-Jo-My/luci-theme-Butterfly package/luci-theme-Butterfly
git clone https://github.com/Leo-Jo-My/luci-theme-Butterfly-dark package/luci-theme-Butterfly-dark
svn co https://github.com/apollo-ng/luci-theme-darkmatter/trunk/luci/themes/luci-theme-darkmatter package/luci-theme-darkmatter
svn co https://github.com/solidus1983/luci-theme-opentomato/trunk/luci/themes/luci-theme-opentomato package/luci-theme-opentomato
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge package/luci-theme-edge
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-argon_new package/luci-theme-argon_new
svn co https://github.com/rosywrt/luci-theme-rosy/trunk/luci-theme-rosy package/luci-theme-rosy
#svn co https://github.com/rosywrt/luci-theme-purple/trunk/luci-theme-purple package/luci-theme-purple
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
git clone https://github.com/xrouterservice/luci-app-koolddns.git package/luci-app-koolddns
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/naiveproxy
#赋予koolddns权限
chmod 0755 package/luci-app-koolddns/root/etc/init.d/koolddns
chmod 0755 package/luci-app-koolddns/root/usr/share/koolddns/aliddns

svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-unblockneteasemusic-mini package/luci-app-unblockneteasemusic-mini
#添加subweb&subconverter
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/quickjspp package/quickjspp
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/jpcre2 package/jpcre2
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/libcron/ package/libcron
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/rapidjson package/rapidjson
#svn co https://github.com/immortalwrt/immortalwrt/trunk/package/ctcgfw/subweb package/subweb
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/subconverter package/subconverter
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/toml11 package/toml11
#添加smartdns
#svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/smartdns package/smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/smartdns package/smartdns
#svn co https://github.com/garypang13/openwrt-packages/trunk/smartdns-le package/smartdns-le
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-smartdns package/luci-app-smartdns
#添加istore
svn co https://github.com/linkease/istore-ui/trunk/app-store-ui package/app-store-ui
svn co https://github.com/linkease/istore/trunk/luci/luci-app-store package/luci-app-store
sed -i 's/luci-lib-ipkg/luci-base/g' package/luci-app-store/Makefile
#git clone https://github.com/pymumu/openwrt-smartdns package/smartdns
#git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
svn co https://github.com/linkease/ddnsto-openwrt/trunk/ddnsto package/ddnsto
svn co https://github.com/linkease/ddnsto-openwrt/trunk/luci-app-ddnsto package/luci-app-ddnsto
#添加ksmbd
#svn co https://github.com/openwrt/luci/trunk/applications/luci-app-ksmbd package/luci-app-ksmbd
#添加udp2raw
#git clone https://github.com/sensec/openwrt-udp2raw package/openwrt-udp2raw
#git clone https://github.com/sensec/luci-app-udp2raw package/luci-app-udp2raw
#sed -i "s/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=f2f90a9a150be94d50af555b53657a2a4309f287/" package/openwrt-udp2raw/Makefile
#sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=20200920\.0/" package/openwrt-udp2raw/Makefile
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/udp2raw package/udp2raw
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-udp2raw package/luci-app-udp2raw
#添加luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
#添加luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
#修改晶晨宝盒默认配置

# 1.Set the download repository of the OpenWrt files to your github.com
sed -i "s|https.*/OpenWrt|https://github.com/HoldOnBro/Actions-OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic

# 2.Set the keywords of Tags in your github.com Releases
#sed -i "s|ARMv8|ARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

# 3.Set the suffix of the OPENWRT files in your github.com Releases
sed -i "s|.img.gz|_FOL+SFE.img.gz|g" package/luci-app-amlogic/root/etc/config/amlogic

# 4.Set the download path of the kernel in your github.com repository
sed -i "s|opt/kernel|BuildARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

#添加argon-config 使用 最新argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}
#svn co https://github.com/immortalwrt/immortalwrt/trunk/include/download.mk include/download.mk
#svn co https://github.com/immortalwrt/immortalwrt/trunk/include/package-immortalwrt.mk include/package-immortalwrt.mk

#readd cpufreq for aarch64
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(aarch64\|\|arm\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile

#replace coremark.sh with the new one
cp -f $GITHUB_WORKSPACE/general/coremark.sh feeds/packages/utils/coremark/

find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-alt/shadowsocksr-libev-ssr-redir/g' {}
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-server/shadowsocksr-libev-ssr-server/g' {}

#修改bypass的makefile
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}

svn co https://github.com/kiddin9/openwrt-bypass/trunk/luci-app-bypass package/luci-app-bypass
#find package/luci-app-bypass/* -maxdepth 8 -path "*" | xargs -i sed -i 's/smartdns-le/smartdns/g' {}

#temp fix for dnsforwarder
#sed -i "s/PKG_SOURCE_URL:=.*/PKG_SOURCE_URL:=https:\/\/github\.com\/1715173329\/dnsforwarder\.git/" package/lean/dnsforwarder/Makefile
#sed -i "s/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=587e61ae4d75dc976f538088b715a3c8ee26c144/" package/lean/dnsforwarder/Makefile
#sed -i "s/\ \ URL:=.*/\ \ URL:=https:\/\/github\.com\/1715173329\/dnsforwarder/" package/lean/dnsforwarder/Makefile

./scripts/feeds update -a
./scripts/feeds install -a
#================================================================================================
