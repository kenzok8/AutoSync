#!/bin/bash

# 假设您的插件版本号可以通过执行命令来获取，例如 sing-box version
PLUGIN_VERSION=$(${{ matrix.packages }} version | grep "$PKG_VERSION")

# 将版本号输出到标准输出
echo "$PLUGIN_VERSION"
