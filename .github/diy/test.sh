#!/bin/bash

# 使用环境变量 MATRIX_PACKAGES 来引用插件名称，并运行命令
PLUGIN_VERSION=$($MATRIX_PACKAGES version | grep "$PKG_VERSION")

# 将版本号输出到标准输出
echo "$PLUGIN_VERSION"

