#!/bin/bash

# 检查是否提供了足够的参数
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repository> <commit_hash>"
    echo "Example: $0 github.com/zmicro-team/ztlib bb0f8f9c7dfe338763202a012adbd49cd3fd19c1"
    exit 1
fi

# 解析参数
REPOSITORY=$1
COMMIT_HASH=$2

# 克隆临时目录中的仓库
TEMP_DIR=$(mktemp -d)
git clone --quiet $REPOSITORY $TEMP_DIR
cd $TEMP_DIR

# 获取提交日期并转换为伪版本格式
COMMIT_DATE=$(git show -s --format=%ci $COMMIT_HASH)
PSEUDO_VERSION=$(date -u -d "$COMMIT_DATE" +v0.0.0-%Y%m%d%H%M%S)

# 生成完整的伪版本
FULL_VERSION="${PSEUDO_VERSION}-${COMMIT_HASH:0:12}"

# 输出 require 行
echo "require $REPOSITORY $FULL_VERSION"

# 清理临时目录
cd ..
rm -rf $TEMP_DIR
