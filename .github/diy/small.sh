#!/bin/bash

# 简化版本追踪脚本
set -e  # 遇到错误时退出

# 创建版本信息目录
mkdir -p .version_info

# 函数：获取软件包版本
get_package_version() {
    local pkg_dir="$1"
    local version=""
    
    if [[ -f "$pkg_dir/Makefile" ]]; then
        # 尝试从Makefile获取版本信息
        version=$(grep -E "^PKG_VERSION|^PKG_SOURCE_VERSION" "$pkg_dir/Makefile" | head -1 | cut -d'=' -f2 | tr -d ' "' | head -c 20)
        
        # 如果没找到版本，尝试获取日期
        if [[ -z "$version" ]]; then
            version=$(grep -E "^PKG_SOURCE_DATE" "$pkg_dir/Makefile" | head -1 | cut -d'=' -f2 | tr -d ' "')
        fi
        
        # 如果还没找到，使用时间戳
        if [[ -z "$version" ]]; then
            version=$(stat -c %Y "$pkg_dir/Makefile" 2>/dev/null || echo "unknown")
        fi
    fi
    
    # 如果都没找到，使用默认值
    [[ -z "$version" ]] && version="latest"
    
    echo "$version"
}

# 保存当前版本信息（如果存在）
if [[ -f ".version_info/current_versions.txt" ]]; then
    mv ".version_info/current_versions.txt" ".version_info/previous_versions.txt"
else
    touch ".version_info/previous_versions.txt"
fi

# 原始的函数定义
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

echo "=== Starting package clone operations ===" >&2

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

echo "=== Applying Makefile modifications ===" >&2

# 应用原有的sed修改
sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile
sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile

# 清理git相关文件
rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore

echo "=== Collecting version information ===" >&2

# 收集当前所有软件包的版本信息
> ".version_info/current_versions.txt"
for pkg_dir in */; do
    [[ ! -d "$pkg_dir" ]] && continue
    pkg_name=$(basename "$pkg_dir")
    
    # 跳过特殊目录
    [[ "$pkg_name" == ".version_info" ]] && continue
    [[ "$pkg_name" == "commit" ]] && continue
    
    version=$(get_package_version "$pkg_dir")
    echo "$pkg_name=$version" >> ".version_info/current_versions.txt"
    echo "  $pkg_name: $version" >&2
done

echo "=== Analyzing version changes ===" >&2

# 分析版本变化
> ".version_info/changes.txt"

# 读取版本信息到关联数组
declare -A previous_versions current_versions

if [[ -f ".version_info/previous_versions.txt" ]]; then
    while IFS='=' read -r pkg version; do
        [[ -n "$pkg" && -n "$version" ]] && previous_versions["$pkg"]="$version"
    done < ".version_info/previous_versions.txt"
fi

while IFS='=' read -r pkg version; do
    [[ -n "$pkg" && -n "$version" ]] && current_versions["$pkg"]="$version"
done < ".version_info/current_versions.txt"

# 生成变化报告
echo "Updated packages:" >> ".version_info/changes.txt"
has_changes=false

# 检查新增和更新的包
for pkg in "${!current_versions[@]}"; do
    current_ver="${current_versions[$pkg]}"
    previous_ver="${previous_versions[$pkg]:-}"
    
    if [[ -z "$previous_ver" ]]; then
        echo "  + $pkg: add $current_ver" >> ".version_info/changes.txt"
        has_changes=true
    elif [[ "$previous_ver" != "$current_ver" ]]; then
        echo "  * $pkg: update to $current_ver (from $previous_ver)" >> ".version_info/changes.txt"
        has_changes=true
    fi
done

# 检查删除的包
for pkg in "${!previous_versions[@]}"; do
    if [[ -z "${current_versions[$pkg]:-}" ]]; then
        echo "  - $pkg: remove ${previous_versions[$pkg]}" >> ".version_info/changes.txt"
        has_changes=true
    fi
done

if [[ "$has_changes" == "false" ]]; then
    echo "  No package updates" >> ".version_info/changes.txt"
fi

echo "=== Version analysis completed ===" >&2
if [[ -f ".version_info/changes.txt" ]]; then
    cat ".version_info/changes.txt" >&2
fi

echo "=== Script execution completed successfully ===" >&2
exit 0
