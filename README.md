### 8812au ( 8812au.ko )

### Linux Driver for the RealTek RTL8812AU Chipset.

- Driver Version: 5.9.3.2 (Realtek)
- Updates from the Linux community

### Supported Kernels:

- Tested on kernels 5.4 and 5.8

### Tested Linux Distributions:

Kernel 5.4:

- Mint 20		( https://linuxmint.com/ )
- Ubuntu 20.04	( https://ubuntu.com/    )
- Mint 19.3
- Ubuntu 18.04

Kernel 5.8

- Ubuntu 20.10 Beta

### Tested Hardware:

- Alfa - AWUS036ACH: amazon.com/dp/B00VEEBOPG


## Supported Devices:

* Numerous products that are based on the supported chipset.

### DKMS:
This driver can be installed using DKMS. DKMS is a system utility which will automatically recompile and install a kernel module when a new kernel is installed. To make use of DKMS, install the `dkms` package. On Debian (based) systems, such as Ubuntu and Mint, installation is accomplished like this:
```
$ sudo apt-get install dkms
```

### Installation of the Driver:

Note: The installation instructions I am providing are for the novice user. Experienced users are welcome to alter the installation to meet their needs.

Go to `https://github.com/morrownr/8812au` for the latest version of the driver.

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
