## Monitor Mode Testing

2021-05-15

Tested with Kali Linux (amd64) and an Alfa AWUS036ACM (mt7612u) adapter.

2021-04-23

Tested with Raspberry Pi OS (arm32) and an Alfa AWUS036ACHM (mt7610u) adapter.

2021-05-28

Tested with Linux Mint 20.1 and a USB WiFi adapter based on the rtl8814au chipset.

-----

Update system

Code:
```
$ sudo apt update
```
```
sudo apt full-upgrade
```
```
sudo reboot
```
-----

Ensure WiFi radio is not blocked

Code:
```
sudo rfkill unblock wlan
```

-----

Install the aircrack-ng package

Code:
```
sudo apt install aircrack-ng
```

-----

Determine the name(s) and status of wifi interfaces
```
$ ip a
```
Note: The output shows the WiFi interface name and the current
mode among other things. The interface name may be something like
`wlx00c0cafre8ba` depending on the Linux distro you are using. The
wifi interface name is wlan0 is used in the document but you may
need to substitute the name of your wifi interface while following
this document.

-----

Disable interfering processes

Option 1, the standard way:

Code:
```
sudo airmon-ng start kill
```
Option 2, another way that may work:

Note: I use multiple wifi adapters in my system and I need to stay connected
to the internet while testing monitor mode. This option works well for me
and allows me to stay connected.

Ensure Network Manager doesn't cause problems

Code:
```
sudo nano /etc/NetworkManager/NetworkManager.conf
```
add
```
[keyfile]
unmanaged-devices=interface-name:mon0;interface-name:mon1
```
-----

### Change to monitor mode

Option for Realtek drivers:

Take the interface down

Code:
```
sudo ip link set wlan0 down
```

Rename the interface to mon0

Code:
```
sudo ip link set wlan0 name mon0
```

Set monitor mode

Code:
```
sudo iw mon0 set monitor control
```

Bring the interface up

Code:
```
sudo ip link set mon0 up
```

Verify the mode has changed

Code:
```
$ ip a
```

Option for in-kernal drivers such as Mediatek and Atheros:

Add monitor interface

Code:
```
sudo iw phy phy0 interface add mon0 type monitor
```
-----

### Change txpower

Code:
```
sudo iw dev mon0 set txpower fixed 1600
```

-----

### Test injection

Code:
```
sudo airodump-ng mon0 --band ag
```
```
sudo iw dev mon0 set channel 149 (or whatever channel you want)
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

Take the interface down

Code:
```
sudo ip link set mon0 down
```

Rename the interface to wlan0

Code:
```
sudo ip link set wlan0 name wlan0
```

Set managed mode

Code:
```
sudo iw wlan0 set type managed
```

Bring the interface up

Code:
```
$ sudo ip link set wlan0 up
```

Verify the mode has changed

Code:
```
$ iw dev
```

-----

### Change the MAC Address before entering Monitor Mode

Take down things that might interfere

Code:
```
sudo airmon-ng check kill
```
Check the WiFi interface name

Code:
```
iw dev
```
Take the interface down

Code:
```
sudo ip link set dev <your interface name here> down
```
Change the MAC address

Code:
```
sudo ip link set dev <your interface name here> address <your new mac address>
```
Set monitor mode

Code:
```
$ sudo iw <your interface name here> set monitor control
```
Bring the interface up

Code:
```
$ sudo ip link set dev <your interface name here> up
```
Verify the MAC address and mode has changed

Code:
```
$ iw dev
```
