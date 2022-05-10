#!/bin/bash
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

git clone --depth 1 https://github.com/kiddin9/luci-app-dnsfilter
git clone --depth 1 https://github.com/yaof2/luci-app-ikoolproxy
git clone --depth 1 https://github.com/tty228/luci-app-serverchan
git clone --depth 1 https://github.com/ntlf9t/luci-app-easymesh
git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config
git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr
git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced
git clone --depth 1 https://github.com/jefferymvp/luci-app-koolproxyR
git clone --depth 1 https://github.com/hubbylei/luci-app-clash
git clone --depth 1 https://github.com/QiuSimons/openwrt-mos && mv -n openwrt-mos/*mosdns ./ ; rm -rf openwrt-mos
git clone --depth 1 https://github.com/kenzok8/luci-theme-ifit ifit && mv -n ifit/luci-theme-ifit ./;rm -rf ifit
git clone --depth 1 https://github.com/kenzok78/luci-theme-argonne
git clone --depth 1 https://github.com/kenzok78/luci-app-argonne-config
git clone --depth 1 https://github.com/thinktip/luci-theme-neobird
git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns
git clone --depth 1 https://github.com/Huangjoe123/luci-app-eqos
git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic
git clone --depth 1 -b luci https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2
git clone --depth 1 https://github.com/kiddin9/openwrt-bypass && mv -n openwrt-bypass/luci-app-bypass openwrt-bypass/lua-maxminddb ./ ; rm -rf openwrt-bypass
git clone --depth 1 https://github.com/ophub/luci-app-amlogic amlogic && mv -n amlogic/luci-app-amlogic ./;rm -rf amlogic
git clone --depth 1 https://github.com/linkease/istore && mv -n istore/luci/* ./; rm -rf istore
git clone --depth 1 https://github.com/linkease/nas-packages && mv -n nas-packages/network/services/ddnsto ./; rm -rf nas-packages
git clone --depth 1 https://github.com/linkease/nas-packages-luci && mv -n nas-packages-luci/luci/luci-app-ddnsto ./; rm -rf nas-packages-luci
git clone --depth 1 https://github.com/messense/aliyundrive-webdav aliyundrive && mv -n aliyundrive/openwrt/* ./ ; rm -rf aliyundrive
git clone --depth 1 https://github.com/lisaac/luci-app-dockerman dockerman && mv -n dockerman/applications/* ./; rm -rf dockerman

svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant
svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-filebrowser
svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-aliddns
svn export https://github.com/immortalwrt/packages/trunk/net/gost
svn export https://github.com/immortalwrt/packages/trunk/net/smartdns
svn export https://github.com/immortalwrt/packages/trunk/utils/filebrowser
svn export https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-koolddns
svn export https://github.com/kenzok8/jell/trunk/luci-app-adguardhome
svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome
svn export https://github.com/kenzok8/litte/trunk/luci-theme-atmaterial_new
svn export https://github.com/kenzok8/litte/trunk/luci-theme-mcat
svn export https://github.com/kenzok8/litte/trunk/luci-theme-tomato
svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-diskman
svn export https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus
svn export https://github.com/fw876/helloworld/trunk/naiveproxy
svn export https://github.com/fw876/helloworld/trunk/tcping
svn export https://github.com/coolsnowwolf/packages/trunk/net/microsocks
svn export https://github.com/coolsnowwolf/packages/trunk/net/redsocks2
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash
svn export https://github.com/Lienol/openwrt-package/trunk/luci-app-ssr-mudb-server
svn export https://github.com/coolsnowwolf/packages/trunk/multimedia/UnblockNeteaseMusic

rm -rf ./*/.git & rm -rf ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore

for e in $(ls -d luci-*/po); do
	if [[ -d $e/zh-cn && ! -d $e/zh_Hans ]]; then
		ln -s zh-cn $e/zh_Hans 2>/dev/null
	elif [[ -d $e/zh_Hans && ! -d $e/zh-cn ]]; then
		ln -s zh_Hans $e/zh-cn 2>/dev/null
	fi
done

exit 0

