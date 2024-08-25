#!/bin/bash

get_bootloader_info(){
    using_dracut=""
    entry_file=""
    options=""

    # Define the bootloader entry file
    if [ -f "${DQ_WORKING_PATH}/boot/loader/loader.conf" ]; then
        loader_conf_file=$(cat "${DQ_WORKING_PATH}/boot/loader/loader.conf" | grep \.conf | awk '{print $2}') 
        entry_file="${DQ_WORKING_PATH}/boot/loader/entries/${loader_conf_file}"
        options="options"
        bootloader="systemd"
    elif [ -f "${DQ_WORKING_PATH}/etc/default/grub" ]; then
        entry_file="${DQ_WORKING_PATH}/etc/default/grub"
        options="GRUB_CMDLINE_LINUX_DEFAULT="
        bootloader="grub"
    elif [ -f "${DQ_WORKING_PATH}/boot/syslinux/syslinux.cfg" ]; then
        entry_file="${DQ_WORKING_PATH}/boot/syslinux/syslinux.cfg"
        options="APPEND"
        bootloader="syslinux"
    elif [ -f "${DQ_WORKING_PATH}/boot/grub/menu.lst" ]; then
        entry_file="${DQ_WORKING_PATH}/boot/grub/menu.lst"
        options="kernel"
        bootloader="grub-classic"
    elif [ -f "${DQ_WORKING_PATH}/etc/lilo.conf" ]; then
        entry_file="${DQ_WORKING_PATH}/etc/lilo.conf"
        options="append="
        bootloader="lilo"
    elif [ -f "${DQ_WORKING_PATH}/boot/refind_linux.conf" ]; then
        entry_file="${DQ_WORKING_PATH}/boot/refind_linux.conf"
        options="options"
        bootloader="refind"
    else
        echo "No supported bootloader configuration file found."
        return 1
    fi
    return 0
}

append_kernel_option(){
    get_bootloader_info
    if [ ! $? -eq 0 ]; then
        return 1
    fi

    # Define the string to append
    search_string="$1"

    # Check if the string is already present in the entry file
    if grep -qF "$search_string" "$entry_file"; then
        echo "The string '$search_string' is already present in $entry_file"
        return 2
    else
        # If the string is not present, append it to the end of the kernel parameters
        echo "The string '$search_string' is not present in $entry_file"
            echo "Updating $entry_file"
        if [ $bootloader == "systemd" ]; then
            sed -i "/^$options/ s~\$~ $search_string~" "$entry_file"
        elif [ $bootloader == "grub" ]; then
            sed -i "s/quiet/quiet $search_string/" "$entry_file"
        elif [ $bootloader == "syslinux" ]; then
            sed -i "s/quiet/quiet $search_string/" "$entry_file"
        elif [ $bootloader == "grub-classic" ]; then
            sed -i "s/quiet/quiet $search_string/" "$entry_file"
        elif [ $bootloader == "lilo" ]; then
            sed -i "s/quiet/quiet $search_string/" "$entry_file"
        elif [ $bootloader == "refind" ]; then
            sed -i "s/quiet/quiet $search_string/" "$entry_file"
        fi
        echo "Added '$search_string' to the kernel boot parameters in $entry_file"
    fi
    return 0
}


remove_kernel_option(){
    get_bootloader_info
    if [ ! $? -eq 0 ]; then
        return 1
    fi

    # Define the string to remove
    remove_string="$1"

    # Check if the string is present in the entry file
    if grep -qF "$remove_string" "$entry_file"; then
        # If the string is present, remove it from the kernel parameters
        sed -i "s~ $remove_string~~" "$entry_file"
        echo "Removed '$remove_string' from the kernel parameters in $entry_file"
    else
        echo "The string '$remove_string' is not present in $entry_file"
        return 2
    fi
    return 0
}