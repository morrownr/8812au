## Monitor Mode Testing


### For Debian based Linux Distros such as Raspberry Pi OS, Kali and Ubuntu
-----

Update system
```
sudo apt update
```
```
sudo apt full-upgrade
```
```
sudo reboot
```
-----

Ensure WiFi radio is not blocked
```
sudo rfkill unblock wlan
```

-----

Install the aircrack-ng package
```
sudo apt install aircrack-ng
```

-----

Information

The wifi interface name ```wlan0``` is used in this document but you will need
to substitute the name of your wifi interface while using this document.

-----

Disable interfering processes

Option 1, the standard way:
```
sudo airmon-ng start kill
```
Option 2, another way that works for me on Linux Mint and Ubuntu:

Note: I use multiple wifi adapters in my system and I need to stay connected
to the internet while testing drivers. This option works well for me and allows
me to stay connected by allowing Network Manager to continue managing wlan1
while wlan0 is used for monitor mode.

Ensure Network Manager doesn't cause problems
```
sudo nano /etc/NetworkManager/NetworkManager.conf
```
add
```
[keyfile]
unmanaged-devices=interface-name:mon0;interface-name:mon1
```
Note: The above tells Network Manager to leave the mon0 and mon1 interfaces
alone.

-----

### Change to monitor mode

Check the wifi interface name and mode
```
iw dev
```

Take the interface down
```
sudo ip link set wlan0 down
```

Option for Reaktek drivers

Rename the interface to mon0
```
sudo ip link set wlan0 name mon0
```

Option for Mediatek or Atheros drivers
```
sudo iw phy phy0 interface add mon0 type monitor
```

Set monitor mode
```
sudo iw mon0 set monitor control
```

Bring the interface up
```
sudo ip link set mon0 up
```

Verify the mode has changed
```
iw dev
```

-----

### Change txpower (example)
```
sudo iw dev mon0 set txpower fixed 1600
```

-----

### Test injection
```
sudo airodump-ng mon0 --band ag
```
Set the channel of your choice
```
sudo iw dev mon0 set channel 36
```
```
sudo aireplay-ng --test mon0
```

-----

### Test deauth
```
sudo airodump-ng mon0 --band ag
```
```
sudo airodump-ng mon0 --bssid <routerMAC> --channel <channel of router>
```
2 Ghz:
```
sudo aireplay-ng --deauth 0 -c <deviceMAC> -a <routerMAC> mon0
```
5 Ghz:
```
sudo aireplay-ng --deauth 0 -c <deviceMAC> -a <routerMAC> mon0 -D
```

-----

### Revert to Managed Mode

Check the wifi interface name and mode
```
iw dev
```

Take the wifi interface down
```
sudo ip link set mon0 down
```

Rename the wifi interface to wlan0
```
sudo ip link set wlan0 name wlan0
```

Set managed mode
```
sudo iw wlan0 set type managed
```

Bring the wifi interface up
```
sudo ip link set wlan0 up
```

Verify the wifi interface name and mode has changed
```
iw dev
```

-----

### Change the MAC Address before entering Monitor Mode

Check the wifi interface name, MAC address and mode
```
iw dev
```

Take the wifi interface down
```
sudo ip link set dev wlan0 down
```

Change the MAC address
```
sudo ip link set dev wlan0 address <new mac address>
```

Rename the wifi interface to mon0
```
sudo ip link set wlan0 name mon0
```

Set monitor mode
```
sudo iw mon0 set monitor control
```

Bring the wifi interface up
```
sudo ip link set dev mon0 up
```

Verify the wifi interface name, MAC address and mode has changed
```
iw dev
```

-----
