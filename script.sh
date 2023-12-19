#! /usr/bin/bash
sudo apt-get install git
sudo apt-get install cmake
mkdir DJI
cd DJI
git clone https://github.com/dji-sdk/Payload-SDK.git
cd Payload-SDK/samples/sample_c/module_sample/
rm -r fc_subscription/
cd ~/DJI/
git clone https://github.com/11mat13/fc_subscription.git
cp -r fc_subscription/fc_subscription/ Payload-SDK/samples/sample_c/module_sample/
cd Payload-SDK/samples/sample_c/platform/linux/manifold2/
rm CMakeLists.txt
cd ~/DJI/
cp fc_subsrciption/CMakeLists.txt Payload-SDK/samples/sample_c/platform/linux/manifold2/


