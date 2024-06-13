#!/bin/bash

# Returning a unique id to allow users to toggle on or off in /etc/device-quirks/device-quirks.conf
device_quirk_id(){
    echo "TEMPLATE_EXAMPLE"
}

# Returning the name of the fix to display.
device_quirk_name(){
    echo "Example Quirk fix"
}

# Do the install here.
device_quirk_install(){

    ## if sucessful
    return 0
    ## if failed
    return 1
    ## if already installed
    return 2
}

# Remove the install here.
device_quirk_removal(){

    ## if sucessful
    return 0
    ## if failed
    return 1
    ## if not installed
    return 2
}