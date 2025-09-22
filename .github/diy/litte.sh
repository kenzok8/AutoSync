#!/bin/bash

# 版本提取函数
extract_version() {
    local repo_url="$1"
    local local_dir="$2"
    local pkg_name="$3"
    
    if [ -d "$local_dir" ]; then
        # 尝试从 git 获取最新 tag
        cd "$local_dir"
        if git rev-parse --git-dir > /dev/null 2>&1; then
            latest_tag=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')
            if [ -n "$latest_tag" ]; then
                echo "提取到 $pkg_name 版本: $latest_tag"
                # 更新 Makefile 中的版本信息
                if [ -f "Makefile" ]; then
                    sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$latest_tag/" Makefile 2>/dev/null || true
                fi
            fi
        fi
        cd - > /dev/null
    fi
}

function git_sparse_clone() {
branch="$1" rurl="$2" localdir="$3" && shift 3
git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
cd $localdir
git sparse-checkout init --cone
git sparse-checkout set $@
mv -n $@ ../
cd ..
rm -rf $localdir
}

function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}

# 主要的包克隆逻辑
echo "开始克隆包..."

git clone --depth 1 https://github.com/sirpdboy/luci-app-lucky
git clone --depth 1 https://github.com/kiddin9/luci-app-dnsfilter
git clone --depth 1 https://github.com/yaof2/luci-app-ikoolproxy
git clone --depth 1 https://github.com/ntlf9t/luci-app-easymesh
git clone --depth 1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon
git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced
git clone --depth 1 https://github.com/sirpdboy/luci-theme-opentopd
git clone --depth 1 https://github.com/hubbylei/luci-app-clash
git clone --depth 1 https://github.com/derisamedia/luci-theme-alpha
git clone --depth 1 -b v5-lua https://github.com/sbwml/luci-app-mosdns openwrt-mos && mv -n openwrt-mos/luci-app-mosdns ./; rm -rf openwrt-mos
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns openwrt-mos1 && mv -n openwrt-mos1/{mosdns,v2dat} ./; rm -rf openwrt-mos1
#git clone --depth 1 https://github.com/sbwml/luci-app-daed daed1 && mv -n daed1/*daed ./; rm -rf daed1
git clone --depth 1 https://github.com/kenzok8/luci-theme-ifit ifit && mv -n ifit/luci-theme-ifit ./;rm -rf ifit
git clone --depth 1 https://github.com/kenzok78/luci-theme-argone
git clone --depth 1 https://github.com/kenzok78/luci-app-argone-config
git clone --depth 1 https://github.com/kenzok78/luci-app-adguardhome
git clone --depth 1 https://github.com/kenzok78/luci-app-fileassistant
git clone --depth 1 https://github.com/kenzok78/luci-theme-design
git clone --depth 1 https://github.com/kenzok78/luci-app-guest-wifi
#git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns
git clone --depth 1 https://github.com/Huangjoe123/luci-app-eqos
git clone --depth 1 https://github.com/sirpdboy/luci-app-partexp
git clone --depth 1 -b master https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic
git clone --depth 1 https://github.com/ophub/luci-app-amlogic amlogic && mv -n amlogic/luci-app-amlogic ./;rm -rf amlogic
git clone --depth 1 https://github.com/linkease/istore && mv -n istore/luci/* ./; rm -rf istore
git clone --depth 1 https://github.com/linkease/nas-packages && mv -n nas-packages/network/services/{ddnsto,quickstart} ./; rm -rf nas-packages
git clone --depth 1 https://github.com/linkease/nas-packages-luci && mv -n nas-packages-luci/luci/{luci-app-ddnsto,luci-app-istorex,luci-app-quickstart} ./; rm -rf nas-packages-luci
git clone --depth 1 https://github.com/messense/aliyundrive-webdav aliyundrive && mv -n aliyundrive/openwrt/* ./ ; rm -rf aliyundrive
git clone --depth 1 https://github.com/honwen/luci-app-aliddns
git clone --depth 1 -b lua https://github.com/sbwml/luci-app-alist openwrt-alist1 && mv -n openwrt-alist1/luci-app-alist ./ ; rm -rf openwrt-alist1
git clone --depth 1 https://github.com/lisaac/luci-app-dockerman dockerman && mv -n dockerman/applications/* ./; rm -rf dockerman
git clone --depth 1 https://github.com/vernesong/OpenClash && mv -n OpenClash/luci-app-openclash ./; rm -rf OpenClash
git clone --depth 1 https://github.com/kenzok8/litte && mv -n litte/luci-theme-atmaterial_new litte/luci-theme-tomato ./ ; rm -rf litte
git clone --depth 1 https://github.com/kenzok8/wall && mv -n wall/* ./ ; rm -rf wall
git clone --depth 1 https://github.com/QiuSimons/luci-app-daed-next daed1 && mvdir daed1
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go ddnsgo && mv -n ddnsgo/luci-app-ddns-go ./; rm -rf ddnsgo
git clone --depth 1 -b main https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/{luci-app-ssr-plus,tuic-client,shadow-tls} ./ ; rm -rf helloworld
git clone --depth 1 https://github.com/kiddin9/kwrt-packages && mv -n kwrt-packages/luci-app-bypass ./ ; rm -rf kwrt-packages
git clone --depth 1 https://github.com/immortalwrt/packages && mv -n packages/net/cdnspeedtest ./ ; rm -rf packages
git clone --depth 1 https://github.com/immortalwrt/packages && mv -n packages/lang/lua-maxminddb ./ ; rm -rf packages
#git clone --depth 1 -b openwrt-18.06 https://github.com/immortalwrt/luci && mv -n luci/applications/{luci-app-gost,luci-app-filebrowser} ./ && rm -rf luci
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-momo OpenWrt-momo && mv -n OpenWrt-momo/*momo ./ ; rm -rf OpenWrt-momo
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki OpenWrt-nikki && mv -n OpenWrt-nikki/*nikki ./ ; rm -rf OpenWrt-nikki
git clone --depth 1 https://github.com/muink/openwrt-fchomo openwrt-fchomo && mv -n openwrt-fchomo/*homo ./ ; rm -rf openwrt-fchomo
git clone --depth 1 https://github.com/immortalwrt/homeproxy luci-app-homeproxy
git clone --depth 1 https://github.com/muink/openwrt-fchomo openwrt-fchomo && mv -n openwrt-fchomo/*homo ./ ; rm -rf openwrt-fchomo
git clone --depth 1 https://github.com/sirpdboy/luci-theme-kucat openwrt-kucat && mv -n openwrt-kucat/luci-theme-kucat ./ ; rm -rf openwrt-kucat
git clone --depth 1 https://github.com/AngelaCooljx/luci-theme-material3
git clone --depth 1 https://github.com/sbwml/luci-app-openlist2 oplist && mvdir oplist
git clone --depth 1 https://github.com/immortalwrt/luci && mv -n luci/applications/{luci-app-argon-config,luci-app-adblock-fast,luci-app-dae,luci-app-daed,luci-app-diskman,luci-app-filebrowser-go,luci-app-filebrowser,luci-app-gost,luci-app-microsocks,luci-app-openlist,luci-app-qbittorrent,luci-app-snmpd,luci-app-smartdns,luci-app-transmission,luci-app-v2raya,luci-app-watchcat,luci-app-eoip，luci-app-smartdns} ./ ; rm -rf luci

echo "完成包克隆和版本提取"

# 原有的 sed 处理逻辑
sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?2. Clash For OpenWRT?3. Applications?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
-e 's/ca-certificates/ca-bundle/' \
*/Makefile

sed -i 's/luci-lib-ipkg/luci-base/g' luci-app-store/Makefile
sed -i 's/+dockerd/+dockerd +cgroupfs-mount/' luci-app-docker*/Makefile
sed -i '$i /etc/init.d/dockerd restart &' luci-app-docker*/root/etc/uci-defaults/*
sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile
sed -i 's/\(+luci-compat\)/\1 +luci-theme-argon/' luci-app-argon-config/Makefile
sed -i 's/\(+luci-compat\)/\1 +luci-theme-design/' luci-theme-design-config/Makefile
sed -i 's/\(+luci-compat\)/\1 +luci-theme-argone/' luci-app-argone-config/Makefile

rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore create_acl_for_luci.err create_acl_for_luci.ok create_acl_for_luci.warn
sed -i '/entry({"admin", "nas"}, firstchild(), "NAS", 45).dependent = false/d; s/entry({"admin", "network", "eqos"}, cbi("eqos"), _("EQoS"))/entry({"admin", "network", "eqos"}, cbi("eqos"), _("EQoS"), 121).dependent = true/' luci-app-eqos/luasrc/controller/eqos.lua
sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore

echo "脚本执行完成"
exit 0
