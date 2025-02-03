#!/bin/bash

process_vendor_quirks() {
    local VENDOR="$1"

    if [[ $? -eq 0 ]]; then
        for script in "$DQ_PATH/scripts/$VENDOR/scripts.d/"*".sh"; do
            if [[ -f "$script" ]]; then
                source "$script"

                check_device_compatiblity "$(device_quirk_id)"
                if [[ $? -eq 0 ]]; then
                    get_firmware_override_status
                    ## Quirk fixes allowed
                    if [ $? -eq 1 ]; then
                        get_quirk_id_status "$(device_quirk_id)"
                        if [ $? -eq 1 ]; then
                            echo "Quirk fix: $(device_quirk_name) has been staged for installation."
                            device_quirk_install
                            if [[ $? -eq 0 ]]; then
                                set_quirk_id_status "$(device_quirk_id)"
                                echo "Quirk fix: $(device_quirk_name) has been applied, DQ_$(device_quirk_id) has been added to your device-quirks.conf"
                            elif [[ $? -eq 2 ]]; then
                                echo "Quirk fix: $(device_quirk_name) already installed."
                            else
                                echo "Quirk fix: $(device_quirk_name) has failed to install."
                            fi
                        else
                            echo "Quirk fix: $(device_quirk_name) has been staged for removal (1)."
                            device_quirk_removal
                            if [[ $? -eq 0 ]]; then
                                echo "Quirk fix: $(device_quirk_name) has been removed."
                            elif [[ $? -eq 2 ]]; then
                                echo "Quirk fix: $(device_quirk_name) is not installed."
                            else
                                echo "Quirk fix: $(device_quirk_name) has failed to remove."
                            fi
                        fi
                    else
                        echo "Quirk fix: $(device_quirk_name) has been staged for removal (2)."
                        device_quirk_removal
                        if [[ $? -eq 0 ]]; then
                            echo "Quirk fix: $(device_quirk_name) has been removed."
                        elif [[ $? -eq 2 ]]; then
                            echo "Quirk fix: $(device_quirk_name) is not installed."
                        else
                            echo "Quirk fix: $(device_quirk_name) has failed to remove."
                        fi
                    fi
                fi
            fi
        done
    else
        echo "$VENDOR has no board specific quirks to apply."
    fi
}