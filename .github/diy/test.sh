#!/bin/bash

# 使用 find 命令查找所有 Makefile 文件，并提取 PKG_VERSION 或 PKG_BASE_VERSION 变量的值
find . -type f -name Makefile -exec grep -E 'PKG_(BASE_)?VERSION\s*?:=' {} \; | awk -F '[:=]' '{print $2}'

