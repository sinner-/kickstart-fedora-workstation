# https://docs.fedoraproject.org/en-US/fedora/f34/install-guide/appendixes/Kickstart_Syntax_Reference/

# Configure installation method
url --mirrorlist="https://mirrors.fedoraproject.org/metalink?repo=fedora-34&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f34&arch=x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-34&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-34&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-34&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-34&arch=x86_64" --cost=0
repo --name=google-chrome --install --baseurl="https://dl.google.com/linux/chrome/rpm/stable/x86_64" --cost=0

# Configure Boot Loader
bootloader --driveorder=sda

# Remove all existing partitions
clearpart --drives=sda --all

# zerombr
zerombr

#Create required partitions (BIOS boot partition and /boot)
reqpart --add-boot

# Create Physical Partition
part swap --size=10240 --ondrive=sda $fdepass
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs $fdepass

# Configure Firewall
firewall --enabled

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp --hostname=sina-laptop

# Configure Keyboard Layouts
keyboard us

# Configure Language During Installation
lang en_AU

# Services to enable/disable
services --disabled=mlocate-updatedb,mlocate-updatedb.timer,geoclue,avahi-daemon

# Configure Time Zone
timezone Australia/Sydney

# Configure X Window System
xconfig --startxonboot

# Set Root Password
rootpw --lock

# Create User Account
user --name=sina --password=$userpass --iscrypted --groups=wheel

# Perform Installation in Text Mode
text

# Package Selection
%packages
-openssh-server
-gssproxy
-nfs-utils
-sssd*
-abrt*
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
keepassxc
redshift-gtk
google-chrome-stable
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
calc
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
xz-devel
pcre2-devel
libcurl-devel
python3-virtualenvwrapper
python3-devel
golang
mariadb-server
transmission-gtk
libffi-devel
sqlite
exfat-utils
fuse-exfat
jq
icedtea-web
ristretto
argon2
xournal
pykickstart
evince
firejail
ShellCheck
geteltorito
genisoimage
%end

# Post-installation Script
%post

#Enable GPG keys for installed repos
cat <<EOF >> /etc/yum.repos.d/google-chrome.repo
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

%end

# Reboot After Installation
reboot --eject
