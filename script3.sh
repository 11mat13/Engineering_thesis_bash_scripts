#! /usr/bin/bash

git clone https://github.com/adrianomarto/soft_uart
git clone https://github.com/11mat13/termios.git
sudo apt-get install raspberrypi-kernel-headers
cd soft_uart
rm module.c
cd ..
cp termios/module.c soft_uart/
cd soft_uart/
make
sudo make install
cd ..
