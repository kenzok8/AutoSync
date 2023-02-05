#!/bin/bash
# --------------------------------------------------------
# Script for creating ACL file for each LuCI APP

bash diy/create_acl_for_luci.sh -a >/dev/null 2>&1
bash diy/convert_translation.sh -a >dev/null 2>&1

rm -rf create_acl_for_luci.err & rm -rf create_acl_for_luci.ok
rm -rf create_acl_for_luci.warn

exit 0
