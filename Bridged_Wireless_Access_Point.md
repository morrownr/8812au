## Bridged Wireless Access Point

A bridged wireless access point works within an existing ethernet
network to add WiFi capability where it does not exist or to extend
the network to WiFi capable computers and devices in areas where the
WiFi signal is weak or otherwise does not meet expectations.

#### Single Band

This document outlines a single band setup using the Raspberry Pi 4B
with a USB 3 WiFi adapter for 5g.

#### Information

This setup does not support WPA3-SAE personal.

-----

2021-04-07

#### Tested Setup

	Raspberry Pi 4B (4gb)

	Raspberry Pi OS (2021-03-04) (32 bit) (kernel 5.10.17-v7l+)

	AC1200 USB WiFi Adapter with rtl88XXxu chipset

	Ethernet connection providing internet

Note: Very few Powered USB 3 Hubs will work well with Raspberry Pi
hardware. The primary problem has to do with the backfeeding of
current into the Raspberry Pi. I have avoided using a powered hub
in this setup to enable a very high degree of stability.

Note: rtl88XXxu chipset based USB adapters require from 504 mA of power
up to well over 800 mA of power depending on the adapter. The Raspberry
Pi 3B, 3B+ and 4B USB subsystems are only able to supple a total of 1200
mA of power to all attached devices.


#### Setup Steps
-----

USB adapter driver installation should be performed and tested prior to
following this guide.

Update system.

```
$ sudo apt update

$ sudo apt full-upgrade
```
-----

Reduce overall power consumption and overclock the CPU a modest amount.

Note: all items in this step are optional and some items are specific to
the Raspberry Pi 4B. If installing to a Raspberry Pi 3b or 3b+ you will
need to use the appropriate settings for that hardward.
```
$ sudo nano /boot/config.txt
```
Change
```
# turn off onboard audio
dtparam=audio=off

# disable DRM VC4 V3D driver on top of the dispmanx display stack
#dtoverlay=vc4-fkms-v3d
#max_framebuffers=2
```
Add
```
# turn off Mainboard LEDs
dtoverlay=act-led

# disable Activity LED
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off

# disable Power LED
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

# turn off Ethernet port LEDs
dtparam=eth_led0=4
dtparam=eth_led1=4

# turn off Bluetooth
dtoverlay=disable-bt

# overclock CPU
over_voltage=1
arm_freq=1600
```
-----

Install needed package. Website - [hostapd](https://w1.fi/hostapd/)
```
$ sudo apt install hostapd
```
-----

Reboot system.
```
$ sudo reboot
```
-----

Enable the wireless access point service and set it to start when your
Raspberry Pi boots.
```
$ sudo systemctl unmask hostapd

$ sudo systemctl enable hostapd
```
-----

Add a bridge network device named br0 by creating a file using the
following command, with the contents below.
```
$ sudo nano /etc/systemd/network/bridge-br0.netdev
```
File contents
```
[NetDev]
Name=br0
Kind=bridge
```
-----

Determine the names of the network interfaces.
```
$ ip link
```
Note: If the interface names are not `eth0` and `wlan0`,
then the interface names used in your system will have to replace
`eth0` and `wlan0` for the remainder of this document.

-----

Bridge the Ethernet network with the wireless network, first add the
built-in Ethernet interface ( eth0 ) as a bridge member by creating the
following file.
```
$ sudo nano /etc/systemd/network/br0-member-eth0.network
```
File contents
```
[Match]
Name=eth0

[Network]
Bridge=br0
```
-----

Enable the systemd-networkd service to create and populate the bridge
when your Raspberry Pi boots.
```
$ sudo systemctl enable systemd-networkd
```
-----

Block the eth0 and wlan0 interfaces from being processed, and let
dhcpcd configure only br0 via DHCP.
```
$ sudo nano /etc/dhcpcd.conf
```
Add the following line above the first `interface xxx` line, if any
```
denyinterfaces wlan0 eth0
```
Go to the end of the file and add the following line
```
interface br0
```
-----

To ensure WiFi radio is not blocked on your Raspberry Pi, execute the
following command.
```
$ sudo rfkill unblock wlan
```
-----

Create the hostapd configuration file.
```
$ sudo nano /etc/hostapd/hostapd.conf
```
File contents
```
# /etc/hostapd/hostapd.conf
# Documentation: https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
# 2021-04-07

# Defaults:
# SSID: pi4
# PASSPHRASE: raspberry
# Band: 5g
# Channel: 36
# Country: US

# needs to match your system
interface=wlan0

bridge=br0
driver=nl80211
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0

# change as desired
ssid=pi4

# change as required
country_code=US

# enable DFS channels
ieee80211d=1
ieee80211h=1

# a = 5g (a/n/ac)
# g = 2g (b/g/n)
hw_mode=a
channel=36
# channel=149

beacon_int=100
dtim_period=2
max_num_sta=32
macaddr_acl=0
ignore_broadcast_ssid=0
rts_threshold=2347
fragm_threshold=2346
#send_probe_response=1

# security
# auth_algs=1 works for WPA-2
# auth_algs=3 required for WPA-3 SAE and Transitional
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
rsn_pairwise=CCMP
# Change as desired
wpa_passphrase=raspberry
# WPA-2 AES
wpa_key_mgmt=WPA-PSK
# WPA3-AES Transitional
#wpa_key_mgmt=SAE WPA-PSK
# WPA-3 SAE
#wpa_key_mgmt=SAE
#wpa_group_rekey=1800
# ieee80211w=1 is required for WPA-3 Transitional
# ieee80211w=2 is required for WPA-3 SAE
#ieee80211w=1
# if parameter is not set, 19 is the default value.
#sae_groups=19 20 21 25 26
# required for WPA-3 Transitional
#sae_require_mfp=1
# if parameter is not 9 set, 5 is the default value.
#sae_anti_clogging_threshold=10

# IEEE 802.11n
ieee80211n=1
wmm_enabled=1
#
# Note: Capabilities can vary even between adapters with the same chipset
#
# rtl8812au - rtl8811au -  rtl8812bu - rtl8811cu - rtl8814au
# 20 MHz channel width for band 1 - 2g
#ht_capab=[SHORT-GI-20][MAX-AMSDU-7935]
# 40 MHz channel width for band 2 - 5g
ht_capab=[HT40+][HT40-][SHORT-GI-20][SHORT-GI-40][MAX-AMSDU-7935]

# IEEE 802.11ac
# 5g
ieee80211ac=1
#
# rtl8812au - rtl8811au -  rtl8812bu - rtl8811cu - rtl8814au
# band 2 - 5g
vht_capab=[MAX-MPDU-11454][SHORT-GI-80][HTC-VHT]
# Note: [TX-STBC-2BY1] causes problems

# Required for 80 MHz width channel operation
# band 2 - 5g
vht_oper_chwidth=1
#
# Use the next line with channel 36
# band 2 - 5g
vht_oper_centr_freq_seg0_idx=42
#
# Use the next with channel 149
# band 2 - 5g
#vht_oper_centr_freq_seg0_idx=155

# Event logger - as desired
#logger_syslog=-1
#logger_syslog_level=2
#logger_stdout=-1
#logger_stdout_level=2

# WMM - as desired
#uapsd_advertisement_enabled=1
#wmm_ac_bk_cwmin=4
#wmm_ac_bk_cwmax=10
#wmm_ac_bk_aifs=7
#wmm_ac_bk_txop_limit=0
#wmm_ac_bk_acm=0
#wmm_ac_be_aifs=3
#wmm_ac_be_cwmin=4
#wmm_ac_be_cwmax=10
#wmm_ac_be_txop_limit=0
#wmm_ac_be_acm=0
#wmm_ac_vi_aifs=2
#wmm_ac_vi_cwmin=3
#wmm_ac_vi_cwmax=4
#wmm_ac_vi_txop_limit=94
#wmm_ac_vi_acm=0
#wmm_ac_vo_aifs=2
#wmm_ac_vo_cwmin=2
#wmm_ac_vo_cwmax=3
#wmm_ac_vo_txop_limit=47
#wmm_ac_vo_acm=0

# TX queue parameters - as desired
#tx_queue_data3_aifs=7
#tx_queue_data3_cwmin=15
#tx_queue_data3_cwmax=1023
#tx_queue_data3_burst=0
#tx_queue_data2_aifs=3
#tx_queue_data2_cwmin=15
#tx_queue_data2_cwmax=63
#tx_queue_data2_burst=0
#tx_queue_data1_aifs=1
#tx_queue_data1_cwmin=7
#tx_queue_data1_cwmax=15
#tx_queue_data1_burst=3.0
#tx_queue_data0_aifs=1
#tx_queue_data0_cwmin=3
#tx_queue_data0_cwmax=7
#tx_queue_data0_burst=1.5

# end of hostapd.conf
```
-----

Establish conf file and log file locations.
```
$ sudo nano /etc/default/hostapd
```
Add to bottom of file
```
DAEMON_CONF="/etc/hostapd/hostapd.conf"
DAEMON_OPTS="-d -K -f /home/pi/hostapd.log"
```
-----

15. Reboot the system.

$ sudo reboot

-----

Enjoy!

-----

iperf3 results - 5g
```
$ iperf3 -c 192.168.1.40
Connecting to host 192.168.1.40, port 5201
[  5] local 192.168.1.83 port 39664 connected to 192.168.1.40 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  51.4 MBytes   431 Mbits/sec    0   1.20 MBytes
[  5]   1.00-2.00   sec  56.2 MBytes   472 Mbits/sec    0   1.66 MBytes
[  5]   2.00-3.00   sec  56.2 MBytes   472 Mbits/sec    0   1.83 MBytes
[  5]   3.00-4.00   sec  56.2 MBytes   472 Mbits/sec    0   1.83 MBytes
[  5]   4.00-5.00   sec  56.2 MBytes   472 Mbits/sec    0   1.92 MBytes
[  5]   5.00-6.00   sec  56.2 MBytes   472 Mbits/sec    0   2.02 MBytes
[  5]   6.00-7.00   sec  57.5 MBytes   482 Mbits/sec    0   2.02 MBytes
[  5]   7.00-8.00   sec  57.5 MBytes   482 Mbits/sec    0   2.13 MBytes
[  5]   8.00-9.00   sec  56.2 MBytes   472 Mbits/sec    0   2.13 MBytes
[  5]   9.00-10.00  sec  56.2 MBytes   472 Mbits/sec    0   2.24 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   560 MBytes   470 Mbits/sec    0   sender
[  5]   0.00-10.01  sec   557 MBytes   467 Mbits/sec        receiver

```
