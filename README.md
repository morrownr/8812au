# rtl8812au

## Realtek 8812AU driver version 5.6.4.2

Only supports 8812AU chipset.

Works fine with 5.8.rc3 kernel. Source now builds with no warnings or errors.

Added (cosmeticly edited) original Realtek_Changelog.txt, this README.md and dkms.conf.

Added device USB IDs, sorted by ID number.
Added regdb files.

Removed LED control, which was added for driver version 5.2.20

### Building

To build and install module manually:
```sh
$ make
$ sudo make install
```

To use dkms install:

```sh
  (as root, or sudo) copy source folder contents to /usr/src/rtl8812au-5.6.4.2
```

```sh
$ sudo dkms add -m rtl8812au -v 5.6.4.2
$ sudo dkms build -m rtl8812au -v 5.6.4.2
$ sudo dkms install -m rtl8812au -v 5.6.4.2
```

To use dkms uninstall and remove:

```sh
$ sudo dkms remove -m rtl8812au -v 5.6.4.2 --all
```

### NetworkManager

As others have noted, people using NetworkManager need to add this stanza to /etc/NetworkManager/NetworkManager.conf

```sh
  [device]
  wifi.scan-rand-mac-address=no
```

### Regdb files

If needed, copy the regulatory database files in regdb/ to /lib/firmware/

```sh
$ sudo cp ./regdb/* /lib/firmware/
```
