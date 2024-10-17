#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "OXP_BITRATE_OVERRIDE"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Force audio bitrate to 16bit 96Khz"
}

# Do the install here.
device_quirk_install(){

    if [[! -d "$DQ_WORKING_PATH/etc/wireplumber" ]]; then
        cp -a "$DQ_WORKING_PATH/usr/share/wireplumber" "$DQ_WORKING_PATH/etc/"
        if [ ! $? -eq 0 ]; then
            echo "Failed to copy from $DQ_WORKING_PATH/usr/share/wireplumber to $DQ_WORKING_PATH/etc/"
            return 1
        fi
    fi

    if [[ -z $(diff -r -q "$DQ_WORKING_PATH/usr/share/wireplumber" "$DQ_WORKING_PATH/etc/wireplumber") ]]; then
        sed -i -e 's/--\["audio.format"\]/\["audio.format"\]/' -e 's/--\["audio.rate"\]/\["audio.rate"\]/' -e 's/44100/96000/' "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" 
        if [ ! $? -eq 0 ]; then
            echo "Failed to update settings in $DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua"
            return 1
        fi
    elif [[ -e "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" ]]; then
        local grep_returns=$(grep -e '--\["audio.rate"\]' -e '--\["audio.format"\]' "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" | grep 96000 )
        if [ $? -eq 0 ]; then
            return 2
        else
            sed -i -e 's/--\["audio.format"\]/\["audio.format"\]/' -e 's/--\["audio.rate"\]/\["audio.rate"\]/' -e 's/44100/96000/' "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" 
            if [ ! $? -eq 0 ]; then
                echo "Failed to update settings in $DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua"
                return 1
            fi
        fi
    fi

    return 0
}

# Remove the install here.
device_quirk_removal(){

    if [[ -e "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" ]]; then
        local grep_returns=$(grep -e '--\["audio.rate"\]' -e '--\["audio.format"\]' "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" | grep 96000 )
        if [ $? -eq 0 ]; then
            sed -i -e 's/\["audio.format"\]/--\["audio.format"\]/' -e 's/\["audio.rate"\]/--\["audio.rate"\]/' -e 's/= 96000,/= 44100,/' "$DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua" 
            if [ ! $? -eq 0 ]; then
                echo "Failed to update settings in $DQ_WORKING_PATH/etc/wireplumber/main.lua.d/50-alsa-config.lua"
                return 1
            fi
        else
            if [[ -z $(diff -r -q "$DQ_WORKING_PATH/usr/share/wireplumber" "$DQ_WORKING_PATH/etc/wireplumber") ]]; then
                rm -rf "$DQ_WORKING_PATH/etc/wireplumber"
                if [ ! $? -eq 0 ]; then
                    echo "Failed to delete $DQ_WORKING_PATH/etc/wireplumber"
                    return 1
                fi
            fi
            return 2
        fi
    fi

    return 0
}