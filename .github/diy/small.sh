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

git clone --depth 1 https://github.com/kenzok8/wall && mv -n wall/* ./ ; rm -rf {UnblockNeteaseMusic,adguardhome,alist,ddns-go,docker,dockerd,filebrowser,gost,lucky,mosdns,sagernet-core,smartdns,ucl,upx-static,upx} && rm -rf wall
git clone --depth 1 -b v5-lua https://github.com/sbwml/luci-app-mosdns openwrt-mos && mv -n openwrt-mos/luci-app-mosdns ./; rm -rf openwrt-mos
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns openwrt-mos1 && mv -n openwrt-mos1/mosdns ./; rm -rf openwrt-mos1
git clone --depth 1 https://github.com/kenzok8/jell jell-v2dat && mv -n jell-v2dat/v2dat ./; rm -rf jell-v2dat
git clone --depth 1 https://github.com/vernesong/OpenClash && mv -n OpenClash/luci-app-openclash ./; rm -rf OpenClash
git clone --depth 1 -b main https://github.com/Openwrt-Passwall/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/luci-app-ssr-plus ./ ; rm -rf helloworld
#git clone --depth 1 https://github.com/morytyann/OpenWrt-mihomo OpenWrt-mihomo && mv -n OpenWrt-mihomo/*mihomo ./ ; rm -rf OpenWrt-mihomo
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-momo OpenWrt-momo && mv -n OpenWrt-momo/*momo ./ ; rm -rf OpenWrt-momo
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki OpenWrt-nikki && mv -n OpenWrt-nikki/*nikki ./ ; rm -rf OpenWrt-nikki
git clone --depth 1 https://github.com/muink/openwrt-fchomo openwrt-fchomo && mv -n openwrt-fchomo/*homo ./ ; rm -rf openwrt-fchomo
git clone --depth 1 https://github.com/immortalwrt/homeproxy luci-app-homeproxy

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile
sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile

# ── 提前保存各包的上游最新 commit 信息（在删除 .git 之前）──
echo "保存上游 commit 信息..."
: > /tmp/upstream_commit_msgs.txt
for dir in */; do
    pkg="${dir%/}"
    [ -d "$pkg/.git" ] || continue
    msg=$(git -C "$pkg" log -1 --pretty=format:'%s' 2>/dev/null)
    [ -n "$msg" ] && printf '%s|%s\n' "$pkg" "$msg" >> /tmp/upstream_commit_msgs.txt
done
echo "已保存 $(wc -l < /tmp/upstream_commit_msgs.txt) 个包的 commit 信息"

rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore
exit 0
