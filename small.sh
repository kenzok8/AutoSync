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

git clone --depth 1 -b packages https://github.com/xiaorouji/openwrt-passwall && mv -n openwrt-passwall/brook openwrt-passwall/chinadns-ng openwrt-passwall/dns2socks openwrt-passwall/dns2tcp openwrt-passwall/v2ray-geodata openwrt-passwall/hysteria openwrt-passwall/ipt2socks openwrt-passwall/pdnsd-alt openwrt-passwall/trojan-go openwrt-passwall/trojan-plus openwrt-passwall/ssocks ./ ; rm -rf openwrt-passwall
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/simple-obfs helloworld/shadowsocks-rust helloworld/shadowsocksr-libev helloworld/trojan helloworld/v2ray-core helloworld/v2ray-plugin helloworld/v2raya helloworld/xray-core helloworld/xray-plugin ./ ; rm -rf helloworld


sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

rm -rf ./*/.git & rm -f ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore

exit 0
