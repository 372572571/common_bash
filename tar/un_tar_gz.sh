#!/bin/bash

# `tar xvpfz  -C`
# - `f`：表示指定归档文件的名称。
# - `x`：选项告诉 `tar` 从归档文件中提取文件。。
# - `v`：表示详细模式，显示归档过程中的信息。
# - `p`：表示保留文件的权限和属性。
# - `z`：选项告诉 `tar` 使用 gzip 解压缩归档文件。

# `-C` 选项用于指定提取的文件将放置的目录。例如，如果您想将名为 `archive.tar.gz` 的归档文件的内容提取到名为 `/tmp` 的目录中，可以使用以下命令：
# tar xvpfz archive.tar.gz -C /tmp
# 此命令将 `archive.tar.gz` 文件的内容提取到 `/tmp` 目录。

# --help
# 提示
if [ "$1" == "--help" ]; then
    echo "Usage: $0 <tar.gz file> <destination folder>"
    echo "Unpack a tar.gz file to a destination folder."
    exit 0
fi 

# 是否安装了 `tar` 命令
if ! command -v tar &> /dev/null; then
    echo "tar command could not be found"
    exit 1
fi
# 检查参数个数
if [ $# -ne 2 ]; then
    echo "Usage: $0 <tar.gz file> <destination folder>"
    exit 1
fi

# 检查文件是否存在
if [ ! -f $1 ]; then
    echo "File not found!"
    exit 1
fi

# 检查文件格式是否正确
if [[ $1 != *.tar.gz ]]; then
    echo "File is not a tar.gz file!"
    exit 1
fi

# 检查目标文件夹是否存在
if [ ! -d $2 ]; then
    echo "Destination folder does not exist!"
    exit 1
fi

# 解压缩 tar.gz 文件
tar xvpfz $1 -C $2
