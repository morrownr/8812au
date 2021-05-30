## Monitor Mode Operation and Testing

2021-05-15

Tested with Kali Linux (amd64) and an Alfa AWUS036ACM (mt7612u) adapter.

2021-04-23

Tested with Raspberry Pi OS (arm32) and an Alfa AWUS036ACHM (mt7610u) adapter.

2021-05-28

Tested with Linux Mint 20.1 and a USB WiFi adapter based on the rtl8814au chipset.

-----

Update system
```
$ sudo apt update
$ sudo apt full-upgrade
$ sudo reboot
```

Rename the interface to mon0
```
sudo ip link set wlan0 name mon0
```

Take the interface down
```
$ sudo ip link set <your interface name here> down
```

Set monitor mode
```
$ sudo iw <your interface name here> set monitor control
```

Bring the interface up
```
$ sudo ip link set <your interface name here> up
```

Verify the mode has changed
```
$ iw dev
```
-----

### Revert to Managed Mode

Take the interface down
```
$ sudo ip link set <your interface name here> down
```

Set managed mode
```
$ sudo iw <your interface name here> set type managed
```

Bring the interface up
```
$ sudo ip link set <your interface name here> up
```

Verify the mode has changed
```
$ iw dev
```
-----

### Change the MAC Address before entering Monitor Mode

Take down things that might interfere
```
$ sudo airmon-ng check kill
```
Check the WiFi interface name
```
$ iw dev
```
Take the interface down
```
$ sudo ip link set dev <your interface name here> down
```
Change the MAC address
```
$ sudo ip link set dev <your interface name here> address <your new mac address>
```
Set monitor mode
```
$ sudo iw <your interface name here> set monitor control
```
Bring the interface up
```
$ sudo ip link set dev <your interface name here> up
```
Verify the MAC address and mode has changed
```
$ iw dev
```
