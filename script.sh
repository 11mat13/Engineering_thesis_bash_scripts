#! /usr/bin/bash

path=$PWD

source script3.sh

echo -e "\nSetting interfaces:\n\n"

sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint set_config_var enable_uart 1 /boot/config.txt
sudo raspi-config nonint do_serial 1

sudo echo -e "\nInstall Git:\n\n"

sudo apt-get install git

sudo echo -e "\nInstall CMake:\n\n"

sudo apt-get install cmake

sudo echo -e "\nInstall DJI Payload SDK:\n\n"

mkdir DJI
cd DJI
git clone https://github.com/dji-sdk/Payload-SDK.git
cd $path/DJI/Payload-SDK/samples/sample_c/module_sample/
rm -r fc_subscription/

sudo echo -e "\nReconfiguration of DJI Payload SDK files:\n\n"

cd $path/DJI/
git clone https://github.com/11mat13/fc_subscription.git
cp -r $path/DJI/fc_subscription/fc_subscription/ $path/DJI/Payload-SDK/samples/sample_c/module_sample/
cd $path/DJI/Payload-SDK/samples/sample_c/platform/linux/manifold2/
rm CMakeLists.txt
cd application/
rm dji_sdk_config.h
cd $path/DJI/
cp fc_subscription/CMakeLists.txt Payload-SDK/samples/sample_c/platform/linux/manifold2/
cp fc_subscription/version.h Payload-SDK/samples/sample_c/module_sample/
cp fc_subscription/dji_sdk_config.h Payload-SDK/samples/sample_c/platform/linux/manifold2/application/

sudo echo -e "\nInstalling kernel module to run soft uart:\n\n"

cd ~/
sudo echo -e "\ninsmod soft_uart.ko gpio_tx=27 gpio_rx=22" | sudo tee -a /etc/rc.local > /dev/null
sudo reboot
