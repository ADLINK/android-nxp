#!/bin/bash

#script to read ads1115 channel voltages from sysfs

print_help()
{
	echo "Usage: ads1115_sample [scale] [sample]"
	echo "scale values - "
	echo "	0.1875   (+-6.144 V)"
	echo "	0.125    (+-4.096 V)"
	echo "	0.0625   (+-2.048 V)"
	echo "	0.03125  (+-1.024 V)"
	echo "	0.015625 (+-0.512 V)"
	echo "	0.007813 (+-0.256 V)"

	echo "sampling rate values (SPS) - "
	echo "	8, 16, 32, 64, 128, 250, 475, 860"
	exit
}

if [ "$1" != "0.125" ] && [ "$1" != "0.1875" ] && [ "$1" != "0.0625" ] && [ "$1" != "0.03125" ] && [ "$1" != "0.015625" ] && [ "$1" != "0.007813" ]; then
	echo "Error!"
	print_help
fi

if [ "$2" != "8" ] && [ "$2" != "16" ] && [ "$2" != "32" ] && [ "$2" != "64" ] && [ "$2" != "128" ] && [ "$2" != "250" ] && [ "$2" != "475" ] && [ "$2" != "860" ]; then
	echo "Error!"
	print_help
fi

ads1115_sysfs_path="/sys/class/i2c-dev/i2c-2/device/2-0048/iio:device0"
scale=$1
sampling_freq=$2

if [ ! -d $ads1115_sysfs_path ]; then
	echo "Error! ads1115 device sysfs not found"
	exit
fi

echo -e "\nADS1115 Channel voltages\n"

echo $scale > $ads1115_sysfs_path/"in_voltage0_scale"
echo $scale > $ads1115_sysfs_path/"in_voltage1_scale"
echo $scale > $ads1115_sysfs_path/"in_voltage2_scale"
echo $scale > $ads1115_sysfs_path/"in_voltage3_scale"
echo $scale > $ads1115_sysfs_path/"in_voltage0-voltage3_scale"
echo $scale > $ads1115_sysfs_path/"in_voltage1-voltage3_scale"
echo $scale > $ads1115_sysfs_path/"in_voltage2-voltage3_scale"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage0_sampling_frequency"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage1_sampling_frequency"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage2_sampling_frequency"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage3_sampling_frequency"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage0-voltage1_sampling_frequency"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage1-voltage3_sampling_frequency"
echo $sampling_freq > $ads1115_sysfs_path/"in_voltage2-voltage3_sampling_frequency"

V_A1_GND=$(cat $ads1115_sysfs_path/"in_voltage0_raw")
V_A2_GND=$(cat $ads1115_sysfs_path/"in_voltage1_raw")
V_A3_GND=$(cat $ads1115_sysfs_path/"in_voltage2_raw")
V_A4_GND=$(cat $ads1115_sysfs_path/"in_voltage3_raw")
V_A1_A2=$(cat $ads1115_sysfs_path/"in_voltage0-voltage1_raw")
V_A2_A4=$(cat $ads1115_sysfs_path/"in_voltage1-voltage3_sampling_frequency");
V_A3_A4=$(cat $ads1115_sysfs_path/"in_voltage2-voltage3_sampling_frequency");

v=$(echo $V_A1_GND $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A1 - GND: $v V"
v=$(echo $V_A2_GND $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A2 - GND: $v V"
v=$(echo $V_A3_GND $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A3 - GND: $v V"
v=$(echo $V_A4_GND $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A4 - GND: $v V"
v=$(echo $V_A1_A2 $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A1 - A2: $v V"
v=$(echo $V_A2_A4 $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A2 - A4: $v V"
v=$(echo $V_A3_A4 $scale | awk '{printf "%2.3f\n",$1*$2/1000}')
echo "Voltage A3 - A4: $v V"
echo -e "\n"
