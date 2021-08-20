sudo apt update
sudo apt install git -y

rm -rf git-strage-setup
mkdir git-strage-setup
wget https://raw.githubusercontent.com/shir0areed/git-strage/master/git-strage-setup/Makefile -P git-strage-setup
cd git-strage-setup
make
cd ../

rm -rf vim-setup
git-read vim-setup
cd vim-setup
make
cd ../

rm -rf alsa-setup
git-read alsa-setup
cd alsa-setup
make
cd ../

rm -rf ffmpeg-setup
git-read ffmpeg-setup
cd ffmpeg-setup
make
cd ../

rm -rf wait-timesync-setup
git-read wait-timesync-setup
cd wait-timesync-setup
make
cd ../

rm -rf fflive-setup
git-read fflive-setup
cd fflive-setup
make
cd ../

rm -rf clock-driver
git clone git@github.com:shir0areed/clock-driver.git
cd clock-driver/clock-driver
make
sudo make install
cd ../

echo "Installation completed, please reboot."

