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
git clone --depth 1 https://github.com/kenzok78/luci-theme-argonne
git clone --depth 1 https://github.com/kenzok78/luci-app-argonne-config
git clone --depth 1 https://github.com/thinktip/luci-theme-neobird
git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns
git clone --depth 1 https://github.com/Huangjoe123/luci-app-eqos
git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic
git clone --depth 1 -b luci https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2
git clone --depth 1 https://github.com/kiddin9/openwrt-bypass && mv -n openwrt-bypass/luci-app-bypass openwrt-bypass/lua-maxminddb ./ ; rm -rf openwrt-bypass
git clone --depth 1 https://github.com/ophub/luci-app-amlogic amlogic && mv -n amlogic/luci-app-amlogic amlogic/depends/* ./;rm -rf amlogic
git clone --depth 1 https://github.com/linkease/istore && mv -n istore/luci/* ./; rm -rf istore
git clone --depth 1 https://github.com/linkease/nas-packages && mv -n nas-packages/network/services/ddnsto ./; rm -rf nas-packages
git clone --depth 1 https://github.com/linkease/nas-packages-luci && mv -n nas-packages-luci/luci/luci-app-ddnsto ./; rm -rf nas-packages-luci
git clone --depth 1 https://github.com/messense/aliyundrive-webdav aliyundrive && mv -n aliyundrive/openwrt/* ./ ; rm -rf aliyundrive
git clone --depth 1 https://github.com/lisaac/luci-app-dockerman dockerman && mv -n dockerman/applications/* ./; rm -rf dockerman

svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant
svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-filebrowser
svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-aliddns
svn export https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-koolddns
svn export https://github.com/kenzok8/luci-theme-ifit/trunk/luci-theme-ifit
svn export https://github.com/kenzok8/jell/trunk/luci-app-adguardhome
svn export https://github.com/kenzok8/jell/trunk/adguardhome
svn export https://github.com/kenzok8/jell/trunk/smartdns
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
svn export https://github.com/immortalwrt/packages/trunk/net/gost
svn export https://github.com/immortalwrt/packages/trunk/utils/filebrowser

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?2. Clash For OpenWRT?3. Applications?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

sed -i 's/luci-lib-ipkg/luci-base/g' luci-app-store/Makefile
sed -i "s/nas/services/g" `grep nas -rl luci-app-fileassistant`
sed -i "s/NAS/Services/g" `grep NAS -rl luci-app-fileassistant`

rm -rf ./*/.git & rm -rf ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore


for e in $(ls -d luci-*/po); do
	if [[ -d $e/zh-cn && ! -d $e/zh_Hans ]]; then
		ln -s zh-cn $e/zh_Hans 2>/dev/null
	elif [[ -d $e/zh_Hans && ! -d $e/zh-cn ]]; then
		ln -s zh_Hans $e/zh-cn 2>/dev/null
	fi
done


error_font="\033[31m[Error]$\033[0m "
success_font="\033[32m[Success]\033[0m "
info_font="\033[36m[Info]\033[0m "

function echo_green_bg(){
	echo -e "\033[42;37m$1\033[0m"
}

function echo_yellow_bg(){
	echo -e "\033[43;37m$1\033[0m"
}

function echo_red_bg(){
	echo -e "\033[41;37m$1\033[0m"
}

function clean_outdated_files(){
	rm -f "create_acl_for_luci.err" "create_acl_for_luci.warn" "create_acl_for_luci.ok"
}

function check_if_acl_exist(){
	ls "$1"/root/usr/share/rpcd/acl.d/*.json >/dev/null 2>&1 && return 0 || return 1
}

function check_config_files(){
	[ "$(ls "$1"/root/etc/config/* 2>/dev/null | wc -l)" -ne "1" ] && return 0 || return 1
}

function get_config_name(){
	ls "$1"/root/etc/config/* 2>/dev/null | awk -F '/' '{print $NF}'
}

function create_acl_file(){
	mkdir -p "$1"
	echo -e "{
	\"$2\": {
		\"description\": \"Grant UCI access for $2\",
		\"read\": {
			\"uci\": [ \"$3\" ]
		},
		\"write\": {
			\"uci\": [ \"$3\" ]
		}
	}
}" > "$1/$2.json"
}

function auto_create_acl(){
	luci_app_list="$(find ./ -maxdepth 2 | grep -Eo ".*luci-app-[a-zA-Z0-9_-]+" | sort -s)"

	[ "$(echo -e "${luci_app_list}" | wc -l)" -gt "0" ] && for i in ${luci_app_list}
	do
		if check_if_acl_exist "$i"; then
			echo_yellow_bg "$i: has ACL file already, skipping..." | tee -a create_acl_for_luci.warn
		elif check_config_files "$i"; then
			echo_red_bg "$i: has no/multi config file(s), skipping..." | tee -a create_acl_for_luci.err
		else
			create_acl_file "$i/root/usr/share/rpcd/acl.d" "${i##*/}" "$(get_config_name "$i")"
			echo_green_bg "$i: ACL file has been generated." | tee -a create_acl_for_luci.ok
		fi
	done
}

while getopts "achml:n:p:" input_arg  
do
	case $input_arg in
	a)
		auto_create_acl
		exit
		;;
	m)
		manual_mode=1
		;;
	p)
		acl_path="$OPTARG"
		;;
	l)
		luci_name="$OPTARG"
		;;
	n)
		conf_name="$OPTARG"
		;;
	c)
		clean_outdated_files
		exit
		;;
	h|?|*)
		echo -e "${info_font}Usage: $0 [-a|-m (-p <path-to-acl>) -l <luci-name> -n <conf-name>|-c]"
		exit 2
		;;
	esac
done

if [ "*${manual_mode}*" == "*1*" ] && [ -n "${luci_name}" ] && [ -n "${conf_name}" ]; then
	acl_path="${acl_path:-root/usr/share/rpcd/acl.d}"
	if create_acl_file "${acl_path}" "${luci_name}" "${conf_name}"; then
		echo -e "${success_font}Output file: $(ls "${acl_path}/${luci_name}.json")"
		echo_green_bg "$(cat "${acl_path}/${luci_name}.json")"
		echo_green_bg "${luci_name}: ACL file has been generated." >> "create_acl_for_luci.ok"
		[ -e "create_acl_for_luci.err" ] && sed -i "/${luci_name}/d" "create_acl_for_luci.err"
	else
		echo -e "${error_font}Failed to create file ${acl_path}/${luci_name}.json"
		echo_red_bg "${luci_name}: Failed to create ACL file." >> "create_acl_for_luci.err"
	fi
else
	echo -e "${info_font}Usage: $0 [-a|-m -p <path-to-acl> -l <luci-name> -n <conf-name>|-c]"
	exit 2
fi



exit 0


