# Configure installation method
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/appe-kickstart-syntax-reference.html#sect-kickstart-commands-install
install
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-26&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f26&arch=x86_64" --cost=100
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-26&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-26&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-26&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-26&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=google-chrome --baseurl="http://dl.google.com/linux/chrome/rpm/stable/x86_64"

# zerombr
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-zerombr.html
zerombr

# Configure Boot Loader
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-bootloader.html
bootloader --location=mbr --driveorder=sda

# Create Physical Partition
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-part.html
part /boot --size=512 --asprimary --ondrive=sda --fstype=xfs
part swap --size=10240 --ondrive=sda --encrypted --passphrase=fdepassphrase
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs --encrypted --passphrase=fdepassphrase

# Remove all existing partitions
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-clearpart.html
clearpart --all --drives=sda

# Configure Firewall
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-network-configuration.html#sect-kickstart-commands-firewall
firewall --enabled --ssh

# Configure Network Interfaces
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-network.html
network --onboot yes --bootproto=dhcp --hostname=sina-laptop

# Configure Keyboard Layouts
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-environment.html#sect-kickstart-commands-keyboard
keyboard us

# Configure Language During Installation
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-lang.html
lang en_AU

# Configure X Window System
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-xconfig.html
xconfig --startxonboot

# Configure Time Zone
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-timezone.html
timezone Australia/Sydney

# Configure Authentication
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-users-groups.html#sect-kickstart-commands-auth
auth --passalgo=sha512

# Create User Account
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-user.html
user --name=sina --password=userpassword --plaintext --groups=wheel

# Set Root Password
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-rootpw.html
rootpw --lock

# Perform Installation in Text Mode
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-text.html
text

# Package Selection
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-packages.html
%packages
-bluez
@core
@standard
@hardware-support
@base-x
@firefox
@fonts
@libreoffice
@multimedia
@networkmanager-submodules
@printing
@xfce-desktop
@development-tools
vim
NetworkManager-openvpn-gnome
keepassx
redshift-gtk
gimp
gnucash
duplicity
calibre
irssi
nmap
tcpdump
ansible
thunderbird
vlc
google-chrome-stable
calc
gitflow
gstreamer-plugins-ugly
gstreamer1-plugins-ugly
redhat-rpm-config
rpmconf
strace
wireshark
ffmpeg
system-config-printer
git-review
gcc-c++
readline-devel
gcc-gfortran
libX11-devel
libXt-devel
zlib-devel
bzip2-devel
lzma-devel
xz-devel
pcre-devel
libcurl-devel
python-virtualenvwrapper
python-devel
python3-devel
golang
libimobiledevice
libimobiledevice-utils
usbmuxd
ifuse
mariadb-server
transmission-gtk
libffi-devel
%end

# Post-installation Script
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-postinstall.html
%post
# Persist extra repos and import keys.
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF
rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub

rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-26.noarch.rpm
rpm -ivh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-26.noarch.rpm

# Harden sshd options
echo "" > /etc/ssh/sshd_config

#vimrc configuration
echo "filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set nohlsearch" > /home/sina/.vimrc

cat <<EOF > /home/sina/.bashrc
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
source /usr/bin/virtualenvwrapper.sh
export GOPATH=/home/sina/Development/go
export PATH=$PATH:/home/sina/Development/go/bin
alias irssi='firejail irssi'
EOF

# Disable IPv6
cat <<EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# Enable services
systemctl enable usbmuxd

# Disable services
systemctl disable gssproxy
systemctl disable sssd
systemctl disable bluetooth.target
systemctl disable avahi-daemon
systemctl disable abrtd 
systemctl disable abrt-ccpp
systemctl disable mlocate-updatedb
systemctl disable mlocate-updatedb.timer
%end

# Reboot After Installation
# https://docs.fedoraproject.org/en-US/Fedora/26/html/Installation_Guide/sect-kickstart-commands-reboot.html
reboot --eject
