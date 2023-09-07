#!/bin/bash

# 示例：使用环境变量来引用 matrix.packages 变量
PLUGIN_VERSION=$("$matrix_packages" version | grep "$PKG_VERSION")

# 将版本号输出到标准输出
echo "$PLUGIN_VERSION"
