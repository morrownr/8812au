### 8812au ( 8812au.ko )

### Linux Driver for the RealTek RTL8812AU Chipset.

- Driver Version: 5.9.3.2 (Realtek)
- Plus updates and testing from the Linux community

### Supported Features:

- IEEE 802.11 b/g/n/ac WiFi compliant
- 802.1x, WEP, WPA TKIP and WPA2 AES/Mixed mode for PSK and TLS (Radius)
- WPS - PIN and PBC Methods
- IEEE 802.11b/g/n/ac Client mode
- Wireless security for WEP, WPA TKIP, WPA2 AES PSK and WPA3-SAE Personal
- Site survey scan and manual connect
- WPA/WPA2 TLS client
- Power saving mode
- AP Mode (WiFi Hotspot)
- Monitor mode

### Supported Kernels:

- Kernels: 2.6.24 ~ 5.8 (Realtek)
- Kernel: 5.9

### Supported Linux Distributions:

- Ubuntu - https://ubuntu.com/
- Mint - https://linuxmint.com/

### Tested Linux Distributions:

- Ubuntu 20.10 Beta
- Mint 20
- Ubuntu 20.04
- Mint 19.3
- Ubuntu 18.04

### Tested Hardware:

- Alfa - AWUS036ACH: amazon.com/dp/B00VEEBOPG


## Supported Devices:

* Numerous products that are based on the supported chipset.

### DKMS:
This driver can be installed using DKMS. DKMS is a system utility which will automatically recompile and install a kernel module when a new kernel is installed. To make use of DKMS, install the `dkms` package. On Debian (based) systems, such as Ubuntu and Mint, installation is accomplished like this:
```
$ sudo apt-get install dkms
```

Note: The installation of `dkms` in Mint or Ubuntu will result in the installation of the various development tools and required headers, if not previously installed, so no addition action is necessary on these distros.

### Installation of the Driver:

Note: The installation instructions I am providing are for the novice user. Experienced users are welcome to alter the installation to meet their needs.

Note: The quick way to open a terminal in Mint or Ubuntu: Ctrl+Alt+T (hold down on the Ctrl and Alt keys then press the T key.)

Note: My technique is to create a folder in my home directory to hold source packages. I call it `src`.

Create a folder to hold the downloaded driver file by first opening a terminal (Ctrl+Alt+T).

In the terminal, create the folder to hold the driver file:
```
$ mkdir src
```

Get the latest version of the driver from: `https://github.com/morrownr/8812au`

Download the driver by clicking on the green `Code` button.

Click on `Download ZIP` and save `8812au-5.9.3.2.zip` in your `Downloads` folder.

Upzip `8812au-5.9.3.2.zip`. A folder called `8812au-5.9.3.2` should be created.

Open a terminal and enter the folder called `8812au-5.9.3.2`:

```
$ cd ~/Downloads/8812au-5.9.3.2
```

Execute the following command:
```
$ sudo ./dkms-install.sh
```
```
$ sudo reboot
```
### Removal of the Driver:

Open a terminal in the directory with the source code and execute the following command:
```
$ sudo ./dkms-remove.sh
```
```
$ sudo reboot
```

### Entering Monitor Mode with 'iw' and 'ip':
Start by making sure the system recognizes the Wi-Fi interface:
```
$ sudo iw dev
```

The output shows the Wi-Fi interface name and the current mode among other things. The interface name will be something like `wlx00c0cafre8ba` and is required for the below commands. I will use `wlan0` as the interface name but you need to substitute your interface name.

Take the interface down:
```
$ sudo ip link set wlan0 down
```

Set monitor mode:
```
$ sudo iw wlan0 set monitor control
```

Bring the interface up:
```
$ sudo ip link set wlan0 up
```

Verify the mode has changed:
```
$ sudo iw dev
```

### Reverting to Managed Mode with 'iw' and 'ip':

Take the interface down:
```
$ sudo ip link set wlan0 down
```

Set managed mode:
```
$ sudo iw wlan0 set type managed
```

Bring the interface up:
```
$ sudo ip link set wlan0 up
```

Verify the mode has changed:
```
$ sudo iw dev
```

### USB 3 Support

I have included a file called `88x2bu.conf` that will be installed in `/etc/modeprob.d` by default.

`8812au.conf` passes a parameter to the driver during boot that turns USB 3 mode on.

See what your USB mode is:

```
$ lsusb -t
```

USB 2 =  480M

USB 3 = 5000M

Note: If there is a problem, delete `88x2bu.conf`.


### Enjoy
