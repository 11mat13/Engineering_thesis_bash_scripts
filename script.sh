#! /usr/bin/bash

path=$PWD
sudo apt-get install git
sudo apt-get install cmake
mkdir DJI
cd DJI
git clone https://github.com/dji-sdk/Payload-SDK.git
cd $path/DJI/Payload-SDK/samples/sample_c/module_sample/
rm -r fc_subscription/
cd $path/DJI/
git clone https://github.com/11mat13/fc_subscription.git
cp -r $path/DJI/fc_subscription/fc_subscription/ $path/DJI/Payload-SDK/samples/sample_c/module_sample/
cd $path/DJI/Payload-SDK/samples/sample_c/platform/linux/manifold2/
rm CMakeLists.txt
cd $path/DJI/
cp fc_subscription/CMakeLists.txt Payload-SDK/samples/sample_c/platform/linux/manifold2/


