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

git clone --depth 1 https://github.com/kenzok78/wall && mv -n wall/brook wall/chinadns-ng wall/dns2socks wall/dns2tcp wall/v2ray-geodata wall/hysteria wall/ipt2socks wall/pdnsd-alt wall/trojan-go wall/trojan-plus wall/ssocks  wall/simple-obfs wall/shadowsocks-rust wall/shadowsocksr-libev wall/trojan wall/v2ray-core wall/v2ray-plugin wall/v2raya wall/xray-core wall/xray-plugin ./ ; rm -rf wall

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/' chinadns-ng/Makefile
rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore

exit 0
