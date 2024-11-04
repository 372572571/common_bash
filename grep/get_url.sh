#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# 定义输入文件
input_file=$1
out_file="extracted_urls.txt"
echo $dir
# 使用grep和正则表达式提取URL
grep -oP '(http|https)://[a-zA-Z0-9./?=_-]*' "$input_file" > "$out_file"

# 将临时文件中的URL读取到数组中
readarray -t urls < "$out_file"

# 删除临时文件
rm $out_file

# 获取$1的文件名，不包括路径和扩展
filename=$(basename -- "$1")
filename="${filename%.*}"
# 中文问题改为md5
# echo -n "hello" | md5sum
md=$(echo -n "$1" | md5sum | awk '{print $1}') 
echo $md
# 创建一个目录+文件名，用于存储下载的文件
out_dir="$2/$md"
mkdir -p "$out_dir"

# 打印数组中的URL
for url in "${urls[@]}"; do
    #判断 是否资源文件 
    # cpu=$(echo "$cpu_info" | awk 'FNR==5 {print $2}')
    res= $(grep 'jpg\|png\|gif\|jpeg\|css\|js\|ico\|svg\|woff\|woff2\|ttf\|eot\|otf' <<< "$url" &> /dev/null)
    # 检查上一个命令的退出状态码
    if [ $? -eq 1 ]; then
        continue
    fi
    echo "$url"
    # 判断是否安装wget
    if ! command -v wget &> /dev/null; then
        echo "wget is not installed. Please install it to download the files."
        exit 1
    fi
    # 替换原文内容
    # 如果下载文件已存在则删除
    if [ -f "$out_dir/$(basename -- "$url")" ]; then
        # 删除文件
        rm "$out_dir/$(basename -- "$url")"
    fi
    sed -i "s|$url|$out_dir/$(basename -- "$url")|g" "$input_file"
    # 下载文件
    wget -P "$out_dir" "$url"
done