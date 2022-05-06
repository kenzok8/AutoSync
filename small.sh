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

git clone --depth 1 -b packages https://github.com/xiaorouji/openwrt-passwall && mv -n openwrt-passwall/chinadns-ng openwrt-passwall/dns2socks openwrt-passwall/hysteria openwrt-passwall/ipt2socks openwrt-passwall/pdnsd-alt openwrt-passwall/trojan-go openwrt-passwall/trojan-plus openwrt-passwall/ssocks ./ ; rm -rf openwrt-passwall
svn export --force https://github.com/kenzok78/small-package/trunk/brook
svn export --force https://github.com/openwrt/packages/trunk/net/shadowsocks-libev
svn export --force https://github.com/fw876/helloworld/trunk/simple-obfs
svn export --force https://github.com/fw876/helloworld/trunk/shadowsocks-rust
svn export --force https://github.com/fw876/helloworld/trunk/shadowsocksr-libev
svn export --force https://github.com/fw876/helloworld/trunk/trojan
svn export --force https://github.com/fw876/helloworld/trunk/v2ray-core
svn export --force https://github.com/fw876/helloworld/trunk/v2ray-geodata
svn export --force https://github.com/fw876/helloworld/trunk/v2ray-plugin
svn export --force https://github.com/fw876/helloworld/trunk/v2raya
svn export --force https://github.com/fw876/helloworld/trunk/xray-core
svn export --force https://github.com/fw876/helloworld/trunk/xray-plugin

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

rm -rf ./*/.git & rm -f ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore

exit 0
