#!/bin/bash

echo "**********************"
echo "1. Update your server"
echo "**********************"

apt-get install -y language-pack-en
update-locale LANG=en_US.UTF-8

echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" | sudo tee -a /etc/apt/sources.list
apt-get update
apt-get dist-upgrade

echo "*********************************"
echo "2. Install key for BigBlueButton"
echo "*********************************"

wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -
echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
apt-get update

echo "******************"
echo "3. Install ffmpeg"
echo "******************"

apt-get install -y build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libvpx-dev libxfixes-dev zlib1g-dev pkg-config netcat
FFMPEG_VERSION=2.3.3
cd /usr/local/src
if [ ! -d "/usr/local/src/ffmpeg-${FFMPEG_VERSION}" ]; then
  sudo wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  sudo tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi
cd "ffmpeg-${FFMPEG_VERSION}"
./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
make
checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default
chmod +x install-ffmpeg.sh
ffmpeg -version

echo "*************************"
echo "4. Install BigBlueButton"
echo "*************************"

apt-get update
apt-get install -y bigbluebutton

echo "*********************"
echo "5. Install API Demos"
echo "*********************"

apt-get install -y bbb-demo

echo "***********************"
echo "6. Enable webRTC audio"
echo "***********************"

sudo bbb-conf --enablewebrtc

echo "**********************"
echo "7. Do a Clean Restart"
echo "**********************"

bbb-conf --clean
bbb-conf --check

echo "****************"
echo "インストール完了"
echo "****************"

