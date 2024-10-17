# PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
    PREFIX := /
endif

ifeq ($(VERSION),)
	VERSION := $(shell git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g')
endif

.PHONY: install bin modules udev systemd firmware sysctl scripts conf license

install: bin modules udev systemd firmware sysctl scripts conf license

# Install binaries
bin:
	install -v -m755 -D -t "${PREFIX}/usr/bin/" usr/bin/*

# Install module tweaks
modules:
	install -v -m644 -D -t "${PREFIX}/usr/lib/modprobe.d/" usr/lib/modprobe.d/*
	install -v -m644 -D -t "${PREFIX}/usr/lib/modules-load.d/" usr/lib/modules-load.d/*

# Install udev tweaks
udev:
	install -v -m644 -D -t "${PREFIX}/usr/lib/udev/rules.d/" usr/lib/udev/rules.d/*
	install -v -m644 -D -t "${PREFIX}/usr/lib/udev/hwdb.d/" usr/lib/udev/hwdb.d/*

# Install systemd units
systemd:
	install -v -m644 -D -t "${PREFIX}/usr/lib/systemd/user/" usr/lib/systemd/user/*
	install -v -m644 -D -t "${PREFIX}/usr/lib/systemd/system/" usr/lib/systemd/system/*
	install -v -m755 -D -t "${PREFIX}/usr/lib/systemd/system-sleep/" usr/lib/systemd/system-sleep/*

# Install firmware
firmware:
	mkdir -p "${PREFIX}/usr/lib/firmware/"
	cp -rv usr/lib/firmware/* "${PREFIX}/usr/lib/firmware/"

# Install sysctl configurations
sysctl:
	install -v -m644 -D -t "${PREFIX}/usr/lib/sysctl.d/" usr/lib/sysctl.d/*

# Install scripts
scripts:
	mkdir -p "${PREFIX}/usr/share/device-quirks"
	cp -rv usr/share/device-quirks/* "${PREFIX}/usr/share/device-quirks/."

# Install device-quirks config
conf:
	mkdir -p "${PREFIX}/etc/device-quirks"
	cp -rv etc/device-quirks/* "${PREFIX}/etc/device-quirks/."

# Install license
license:
	install -v -m644 -D -t "${PREFIX}/usr/share/licenses/${_pkgbase}/" LICENSE