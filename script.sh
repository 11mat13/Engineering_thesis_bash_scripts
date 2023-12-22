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
git clone -b release/v3.3 https://github.com/dji-sdk/Payload-SDK.git
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
module_name="soft_uart" # Replace with your module name (without the .ko extension)
module_path=$(modinfo -n "$module_name" 2>/dev/null)
insert_cmd="insmod $module_path gpio_tx=27 gpio_rx=22"

# Check if the module was found and modinfo didn't produce an error
if [[ -n $module_path && -f $module_path ]]; then
    # sudo echo -e "\ninsmod $module_path gpio_tx=27 gpio_rx=22" | sudo tee -a /etc/rc.local > /dev/null
    sudo sed -i "\|exit 0|i$insert_cmd" /etc/rc.local
    sudo chmod +x /etc/rc.local
    touch /etc/systemd/system/rc-local.service
    sudo echo -e "[Unit]\nDescription=/etc/rc.local Compatibility\nConditionPathExists=/etc/rc.local\nExecStart=/etc/rc.local start\nTimeoutSec=0\nStandardOutput=tty\nRemainAfterExit=yes\nSysVStartPriority=99\n\n[Install]\nWantedBy=multi-user.target\nEOF" | sudo tee -a /etc/systemd/system/rc-local.service > /dev/null
    sudo systemctl enable rc-local
else
    echo "Module not found or modinfo failed"
fi
sudo reboot
