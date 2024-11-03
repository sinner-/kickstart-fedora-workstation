# Configure installation method
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-41&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f41&arch=x86_64" --cost=0
repo --name=fedora-cisco-openh264 --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-cisco-openh264-41&arch=x86_64" --install
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-41&arch=x86_64"
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-41&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-41&arch=x86_64"
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-41&arch=x86_64" --cost=0
repo --name=google-chrome --install --baseurl="https://dl.google.com/linux/chrome/rpm/stable/x86_64" --cost=0

# Configure Boot Loader
bootloader --driveorder=nvme0n1

# Remove all existing partitions
clearpart --drives=nvme0n1 --all

# zerombr
zerombr

#Create required partitions (BIOS boot partition and /boot)
reqpart --add-boot

# Create Physical Partition
part pv.01 --ondrive=nvme0n1 --asprimary --size=40000 --grow --encrypted
volgroup vg pv.01
logvol swap --hibernation --vgname=vg --name=swap
logvol / --vgname=vg --name=fedora-root --size=25000 --grow --fstype=xfs

# Configure Firewall
firewall --enabled --port=51413:tcp,8000:tcp

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

# Configure faillock
authselect enable-feature with-faillock

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

#Security
keepassxc
restic
nmap
tcpdump
#wireshark
openssl
firejail
wireguard-tools

#Dev
vim
strace
ffmpeg
ansible
rpmconf
gcc-c++
gcc-gfortran
readline-devel
libX11-devel
libXt-devel
zlib-devel
bzip2-devel
xz-devel
pcre2-devel
libcurl-devel
libffi-devel
python3-devel
python3-virtualenvwrapper
golang
jq
redhat-rpm-config
pykickstart
ipython
ShellCheck
qrencode
genisoimage

#DB
mariadb-server
sqlite

#Usability
rpmfusion-free-release
rpmfusion-nonfree-release
redshift-gtk
system-config-printer
xrandr
tlp

#Office
google-chrome-stable
gnucash
calibre
irssi
thunderbird
vlc
calc
gimp
transmission-gtk
ristretto
xournal
evince
pinta

%end

# Post-installation Script
%post

#Enable GPG keys for installed repos
cat <<EOF >> /etc/yum.repos.d/google-chrome.repo
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

cat <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=10.8.0.1
FallbackDNS=1.1.1.1 1.1.1.2
DNSOverTLS=opportunistic
EOF

cat <<EOF > /etc/NetworkManager/conf.d/dns.conf
[main]
dns=none
systemd-resolved=false
EOF

%end

# Reboot After Installation
reboot --eject
