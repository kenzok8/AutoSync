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

# wall 里除 sing-box 外全部保留；sing-box 改由下方 VIKINGYFY 与 luci-app-homeproxy 成对提供
git clone --depth 1 https://github.com/kenzok8/wall && rm -rf wall/sing-box && mv -n wall/* ./ ; rm -rf {UnblockNeteaseMusic,adguardhome,alist,ddns-go,docker,dockerd,filebrowser,gost,lucky,mosdns,sagernet-core,smartdns,ucl,upx-static,upx} && rm -rf wall
git clone --depth 1 https://github.com/kenzok8/openwrt-daede openwrt-daede && cp -rf openwrt-daede/{dae,daed,luci-app-daede} ./; rm -rf openwrt-daede
git clone --depth 1 -b v5 https://github.com/sbwml/luci-app-mosdns openwrt-mos && mv -n openwrt-mos/{luci-app-mosdns,mosdns,geo2txt} ./ && rm -rf openwrt-mos
git clone --depth 1 https://github.com/vernesong/OpenClash && mv -n OpenClash/luci-app-openclash ./; rm -rf OpenClash
git clone --depth 1 -b main https://github.com/Openwrt-Passwall/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/luci-app-ssr-plus ./ ; rm -rf helloworld
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-momo OpenWrt-momo && mv -n OpenWrt-momo/*momo ./ ; rm -rf OpenWrt-momo
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki OpenWrt-nikki && mv -n OpenWrt-nikki/*nikki ./ ; rm -rf OpenWrt-nikki
git clone --depth 1 https://github.com/kenzok8/openwrt-clashoo openwrt-clashoo && mv -n openwrt-clashoo/*clashoo ./; rm -rf openwrt-clashoo
git clone --depth 1 https://github.com/muink/openwrt-fchomo openwrt-fchomo && mv -n openwrt-fchomo/*homo ./ ; rm -rf openwrt-fchomo
#git clone --depth 1 https://github.com/QiuSimons/luci-app-honk wrt-honk && mv -n wrt-honk/*honk ./ ; rm -rf wrt-honk
git clone --depth 1 https://github.com/kenzok8/openwrt-honk openwrt-honk && mv -n openwrt-honk/*honk ./; rm -rf openwrt-honk
# luci-app-homeproxy 与 sing-box 必须成对取自同一上游：新版 luci 运行时会硬校验 sing-box >= 1.15，
# 且依赖其 1.15 配置项与 DNS TCP 补丁，配置 wall 的 1.14.x 会导致插件无法启动
git_sparse_clone main https://github.com/VIKINGYFY/packages vk-packages luci-app-homeproxy sing-box

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile
sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile
# sing-box 1.15 把 independent_cache / store_rdrc 从警告升级为 FATAL，momo 默认值仍开启会导致内核启动失败
sed -i -e "s/option 'dns_independent_cache' '1'/option 'dns_independent_cache' '0'/" \
       -e "s/option 'cache_store_rdrc' '1'/option 'cache_store_rdrc' '0'/" momo/files/momo.conf

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
