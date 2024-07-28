#!/bin/bash

apply_initramfs() { 
    # This directory is the same for both mkinitcpio "acpi_override" hook and dracut
    mkdir -p "${DQ_WORKING_PATH}/etc/initcpio/acpi_override"

    # setup dracut acpi_override for dracut
    local dracut_file="${DQ_WORKING_PATH}/etc/dracut.conf.d/acpi_override.conf"
    if [ -d "${DQ_WORKING_PATH}/etc/dracut.conf.d/" ]; then
        echo "acpi_override=yes" > "${dracut_file}"

        # ${DQ_WORKING_PATH} must not be used as initramfs has to be generated in a chroot to work anyway
        echo "acpi_table_dir=\"/etc/initcpio/acpi_override\"" >> "${dracut_file}"

        echo "[INFO] dracut has acpi_override enabled"
    fi

    # setup dracut acpi_override for mkinitcpio
    local mkinitcpio_file="${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
    if [ -f "${mkinitcpio_file}" ]; then
        if cat "${mkinitcpio_file}" | grep -Fq "acpi_override"; then
            echo "[INFO] mkinitcpio has acpi_override already enabled"
        else
            if cat "${mkinitcpio_file}" | grep -Fq "microcode" ; then
                echo "Appending acpi_override before microcode hook"
                if sed -i 's|microcode|acpi_override microcode|g' "${mkinitcpio_file}"; then
                    echo "[INFO] mkinitcpio has acpi_override enabled"
                else
                    echo "[ERROR] Could not enable acpi_override from mkinitcpio"
                fi
            else
                echo "[ERROR] microcode hook not found"
            fi
        fi
    fi
}

rollback_initramfs() {
    rm -rf "${DQ_WORKING_PATH}/etc/initcpio/acpi_override"

    local dracut_file="${DQ_WORKING_PATH}/etc/dracut.conf.d/acpi_override.conf"
    if [ -d "${DQ_WORKING_PATH}/etc/dracut.conf.d/" ]; then
        if rm -f "${dracut_file}"; then
            echo "[INFO] dracut has acpi_override disabled"
        else
            echo "[ERROR] disabling acpi_override failed"
        fi
    fi

    # setup dracut acpi_override for mkinitcpio
    local mkinitcpio_file="${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
    if [ -f "${mkinitcpio_file}" ]; then
        if cat "${mkinitcpio_file}" | grep -Fq "acpi_override"; then
            echo "Removing acpi_override before microcode hook"
            if sed -i 's|acpi_override microcode|microcode|g' "${mkinitcpio_file}"; then
                echo "[INFO] mkinitcpio has acpi_override disabled"
            else
                echo "[ERROR] Could not disable acpi_override from mkinitcpio"
            fi
        else
            echo "[INFO] mkinitcpio has acpi_override already disabled"
        fi
    fi
}

generate_initramfs() { 
    local kernel_version=$(file "${DQ_WORKING_PATH}/boot/vmlinuz-linux" | grep -oP "version\s+\K.+" | awk '{print $1}')

    local mkinitcpio_file="${DQ_WORKING_PATH}/etc/mkinitcpio.conf"
    if [ -d "${DQ_WORKING_PATH}/etc/dracut.conf.d/" ]; then
        dracut --host-only --force --kver="${kernel_version}" "${DQ_WORKING_PATH}/boot/initramfs-linux.img"

        for file in $(find "${DQ_WORKING_PATH}/usr/lib/modules/" -name "pkgbase" -type f); Do
            local pkgbase=$(cat $file)
            local pkg_kernel_version=$(file "${file%'/pkgbase'}/vmlinuz" | grep -oP "version\s+\K.+" | awk '{print $1}')

            install -Dm0644 "/${file%'/pkgbase'}/vmlinuz" "${DQ_WORKING_PATH}/boot/vmlinuz-${pkgbase}"
            dracut --force --hostonly "${DQ_WORKING_PATH}/boot/initramfs-${pkgbase}.img" --kver "$pkg_kernel_version"
        done

    elif [ -f "${mkinitcpio_file}" ]; then
        mkinitcpio -P
    fi
}

process_initramfs() {
    get_firmware_override_status
    ## Quirk fixes allowed
    if [ $? -eq 1 ]; then
        apply_initramfs
    else
        rollback_initramfs
    fi

    generate_initramfs
}