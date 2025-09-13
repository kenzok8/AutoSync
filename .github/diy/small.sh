#!/bin/bash

# 增强版本追踪脚本
# 功能：追踪每个软件包的版本变化并生成详细的提交信息

# 创建版本信息目录
mkdir -p .version_info

# 函数：获取软件包版本
get_package_version() {
    local pkg_dir="$1"
    local pkg_name=$(basename "$pkg_dir")
    local version=""
    
    if [[ -f "$pkg_dir/Makefile" ]]; then
        # 尝试从Makefile获取版本信息
        version=$(grep -E "PKG_VERSION|PKG_SOURCE_VERSION|PKG_COMMIT" "$pkg_dir/Makefile" | head -1 | cut -d'=' -f2 | tr -d ' ')
        
        # 如果没找到版本，尝试获取git commit hash
        if [[ -z "$version" && -d "$pkg_dir/.git" ]]; then
            version=$(cd "$pkg_dir" && git rev-parse --short HEAD 2>/dev/null)
        fi
        
        # 如果还是没找到，检查是否有源码版本定义
        if [[ -z "$version" ]]; then
            version=$(grep -E "PKG_SOURCE_URL.*tag|PKG_SOURCE_URL.*commit" "$pkg_dir/Makefile" | grep -oE '[a-f0-9]{7,40}|v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        fi
    fi
    
    # 如果都没找到，使用未知版本
    [[ -z "$version" ]] && version="unknown"
    
    echo "$version"
}

# 函数：记录软件包信息
record_package_info() {
    local pkg_name="$1"
    local old_version="$2"
    local new_version="$3"
    local action="$4"  # add, update, remove
    
    case "$action" in
        "add")
            echo "  + $pkg_name: add $new_version"
            ;;
        "update")
            if [[ "$old_version" != "$new_version" ]]; then
                echo "  * $pkg_name: update to $new_version (from $old_version)"
            fi
            ;;
        "remove")
            echo "  - $pkg_name: remove $old_version"
            ;;
    esac
}

# 保存当前版本信息（如果存在）
if [[ -f ".version_info/current_versions.txt" ]]; then
    cp ".version_info/current_versions.txt" ".version_info/previous_versions.txt"
else
    touch ".version_info/previous_versions.txt"
fi

# 清空当前版本文件
> ".version_info/current_versions.txt"
> ".version_info/changes.txt"

echo "=== 开始收集软件包版本信息 ===" >&2

# 原始的git clone和处理逻辑
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

# 执行原始的克隆和移动操作
git clone --depth 1 https://github.com/kenzok8/wall && mv -n wall/* ./ ; rm -rf {UnblockNeteaseMusic,adguardhome,alist,ddns-go,docker,dockerd,filebrowser,gost,lucky,mosdns,sagernet-core,smartdns,ucl,upx-static,upx} && rm -rf wall
git clone --depth 1 -b v5-lua https://github.com/sbwml/luci-app-mosdns openwrt-mos && mv -n openwrt-mos/luci-app-mosdns ./; rm -rf openwrt-mos
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns openwrt-mos1 && mv -n openwrt-mos1/{mosdns,v2dat} ./; rm -rf openwrt-mos1
git clone --depth 1 https://github.com/vernesong/OpenClash && mv -n OpenClash/luci-app-openclash ./; rm -rf OpenClash
git clone --depth 1 -b main https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/{luci-app-ssr-plus,tuic-client,shadow-tls} ./ ; rm -rf helloworld
git clone --depth 1 https://github.com/kiddin9/kwrt-packages && mv -n kwrt-packages/luci-app-bypass ./ ; rm -rf kwrt-packages
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-momo OpenWrt-momo && mv -n OpenWrt-momo/*momo ./ ; rm -rf OpenWrt-momo
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki OpenWrt-nikki && mv -n OpenWrt-nikki/*nikki ./ ; rm -rf OpenWrt-nikki
git clone --depth 1 https://github.com/muink/openwrt-fchomo openwrt-fchomo && mv -n openwrt-fchomo/*homo ./ ; rm -rf openwrt-fchomo
git clone --depth 1 https://github.com/immortalwrt/homeproxy luci-app-homeproxy

# 应用原有的sed修改
sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile
sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile

# 清理git相关文件
rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore

echo "=== 开始分析软件包版本信息 ===" >&2

# 收集当前所有软件包的版本信息
for pkg_dir in */; do
    [[ ! -d "$pkg_dir" ]] && continue
    pkg_name=$(basename "$pkg_dir")
    
    # 跳过版本信息目录和提交目录
    [[ "$pkg_name" == ".version_info" ]] && continue
    [[ "$pkg_name" == "commit" ]] && continue
    
    version=$(get_package_version "$pkg_dir")
    echo "$pkg_name=$version" >> ".version_info/current_versions.txt"
    echo "收集到 $pkg_name: $version" >&2
done

# 对比版本变化
echo "=== 分析版本变化 ===" >&2

# 读取之前的版本信息
declare -A previous_versions
if [[ -f ".version_info/previous_versions.txt" ]]; then
    while IFS='=' read -r pkg version; do
        [[ -n "$pkg" && -n "$version" ]] && previous_versions["$pkg"]="$version"
    done < ".version_info/previous_versions.txt"
fi

# 读取当前版本信息
declare -A current_versions
while IFS='=' read -r pkg version; do
    [[ -n "$pkg" && -n "$version" ]] && current_versions["$pkg"]="$version"
done < ".version_info/current_versions.txt"

# 检查更新的软件包
echo "Updated packages:" >> ".version_info/changes.txt"
has_updates=false

for pkg in "${!current_versions[@]}"; do
    current_ver="${current_versions[$pkg]}"
    previous_ver="${previous_versions[$pkg]:-}"
    
    if [[ -z "$previous_ver" ]]; then
        # 新增的软件包
        record_package_info "$pkg" "" "$current_ver" "add" >> ".version_info/changes.txt"
        has_updates=true
    elif [[ "$previous_ver" != "$current_ver" ]]; then
        # 更新的软件包
        record_package_info "$pkg" "$previous_ver" "$current_ver" "update" >> ".version_info/changes.txt"
        has_updates=true
    fi
done

# 检查删除的软件包
for pkg in "${!previous_versions[@]}"; do
    if [[ -z "${current_versions[$pkg]:-}" ]]; then
        previous_ver="${previous_versions[$pkg]}"
        record_package_info "$pkg" "$previous_ver" "" "remove" >> ".version_info/changes.txt"
        has_updates=true
    fi
done

if [[ "$has_updates" == "false" ]]; then
    echo "  No package updates" >> ".version_info/changes.txt"
fi

echo "=== 版本分析完成 ===" >&2
cat ".version_info/changes.txt" >&2

exit 0
