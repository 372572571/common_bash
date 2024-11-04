#!/bin/bash

# Function to initialize the progress bar
init_progress_bar() {
    declare -a ary
    for i in `seq 40 49`
    do
        ary[$i]=" "
        echo -en "\e[$i;5m ${ary[@]}\e[;0m"
    done
}

# Function to update the progress bar with traffic data
update_progress_bar() {
    local in=$1
    local out=$2

    # Clear the previous progress bar content
    echo -en "\r"  # Move the cursor to the beginning of the line

    declare -a ary
    for i in `seq 40 49`
    do
        ary[$i]=" "
    done

    # Display the progress bar with traffic data
    echo -en "\e[40;5m ${ary[@]} 流量进入: ${in} 流量传出: ${out}\e[0m"
}

# Main script for traffic enquiry
if [ $# -ne 1 ]; then
    echo "Usage: $0 <network_interface>"
    exit 1
fi

eth0=$1
echo -e "流量进入------------------流量传出"

# Initialize the progress bar (not strictly necessary for this version)
init_progress_bar

while true; do
    old_in=$(cat /proc/net/dev | grep $eth0 | awk '{print $2}')
    old_out=$(cat /proc/net/dev | grep $eth0 | awk '{print $10}')
    sleep 1
    new_in=$(cat /proc/net/dev | grep $eth0 | awk '{print $2}')
    new_out=$(cat /proc/net/dev | grep $eth0 | awk '{print $10}')
    in=$(printf "%.1f%s" "$((($new_in-$old_in)/1024))" "KB/s")
    out=$(printf "%.1f%s" "$((($new_out-$old_out)/1024))" "KB/s")
    
    # Update the progress bar with traffic data
    update_progress_bar "$in" "$out"
done
