# https://docs.fedoraproject.org/en-US/fedora/f32/install-guide/appendixes/Kickstart_Syntax_Reference/

# Configure installation method
install
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-32&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f32&arch=x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-32&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-32&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-32&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-32&arch=x86_64" --cost=0
repo --name=google-chrome --install --baseurl="https://dl.google.com/linux/chrome/rpm/stable/x86_64" --cost=0

# Configure Boot Loader
bootloader --location=mbr --driveorder=sda

# Remove all existing partitions
clearpart --all --drives=sda

# Create Physical Partition
part /boot --size=512 --asprimary --ondrive=sda --fstype=xfs
part swap --size=10240 --ondrive=sda $fdepass
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs $fdepass

# zerombr
zerombr

# Configure Firewall
firewall --enabled

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp --hostname=sina-laptop

# Configure Keyboard Layouts
keyboard us

# Configure Language During Installation
lang en_AU

# Services to enable/disable
services --disabled=mlocate-updatedb,mlocate-updatedb.timer,bluetooth,bluetooth.target,geoclue,avahi-daemon

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
pcre-devel
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
%end

# Post-installation Script
%post
# Disable IPv6
cat <<EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

#Enable GPG keys for installed repos
cat <<EOF >> /etc/yum.repos.d/google-chrome.repo
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

%end

# Reboot After Installation
reboot --eject
