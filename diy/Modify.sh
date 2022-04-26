#!/bin/bash
# --------------------------------------------------------
# Script for creating ACL file for each LuCI APP
sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?2. Clash For OpenWRT?3. Applications?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
*/Makefile

sed -i 's/luci-lib-ipkg/luci-base/g' luci-app-store/Makefile
sed -i "s/nas/services/g" `grep nas -rl luci-app-fileassistant`
sed -i "s/NAS/Services/g" `grep NAS -rl luci-app-fileassistant`

exit 0
