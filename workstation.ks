# Configure installation method
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/appe-kickstart-syntax-reference.html#sect-kickstart-commands-install
install
url --url="http://download.fedoraproject.org/pub/fedora/linux/releases/23/Everything/x86_64/os"
repo --name=fedora-updates --baseurl="http://download.fedoraproject.org/pub/fedora/linux/updates/23/x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-23&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-23&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-nonfree --mirrorlist="http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-23&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-23&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=google-chrome --baseurl="http://dl.google.com/linux/chrome/rpm/stable/x86_64"
repo --name=fedora-virtualbox --baseurl="http://download.virtualbox.org/virtualbox/rpm/fedora/23/x86_64"
repo --name=adobe-flash --baseurl="http://linuxdownload.adobe.com/linux/x86_64"

# zerombr
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-zerombr.html
zerombr

# Configure Boot Loader
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-bootloader.html
bootloader --location=mbr --driveorder=sda

# Create Physical Partition
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-part.html
part /boot --size=500 --asprimary --ondrive=sda --fstype=ext4
part swap --recommended --ondrive=sda --encrypted --passphrase=fdepassphrase
part / --size=2048 --grow --asprimary --ondrive=sda --fstype=ext4 --encrypted --passphrase=fdepassphrase

# Remove all existing partitions
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-clearpart.html
clearpart --all --drives=sda

# Configure Firewall
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-network-configuration.html#sect-kickstart-commands-firewall
firewall --enabled --ssh

# Configure Network Interfaces
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-network.html
network --onboot yes --bootproto=dhcp --hostname=sina-laptop

# Configure Keyboard Layouts
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-environment.html#sect-kickstart-commands-keyboard
keyboard us

# Configure Language During Installation
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-lang.html
lang en_AU

# Configure X Window System
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-xconfig.html
xconfig --startxonboot

# Configure Time Zone
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-timezone.html
timezone Australia/Sydney

# Configure Authentication
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-users-groups.html#sect-kickstart-commands-auth
auth --passalgo=sha512

# Create User Account
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-user.html
user --name=sina --password=userpassword --plaintext --groups=wheel

# Set Root Password
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-rootpw.html
rootpw --lock

# Perform Installation in Text Mode
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-text.html
text

# Package Selection
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-packages.html
%packages
-mlocate
@core
@standard
@hardware-support
@guest-desktop-agents
@base-x
@firefox
@fonts
@libreoffice
@multimedia
@networkmanager-submodules
@printing
@xfce-desktop
@xfce-apps
@xfce-extra-plugins
@xfce-media
@development-tools
kernel-devel
gnome-keyring-pam
lightdm
system-config-printer
openssh-server
vim
NetworkManager-openvpn-gnome
keepassx
R
redshift-gtk
gimp
gnucash
duplicity
calibre
irssi
nmap
tcpdump
ansible
ipython
thunderbird
vlc
google-chrome-stable
VirtualBox
flash-plugin
noip
dkms
android-tools
xpra
calc
gitflow
gstreamer-plugins-ugly
gstreamer1-plugins-ugly

#skype deps
alsa-lib.i686
fontconfig.i686
freetype.i686
glib2.i686
libSM.i686
libXScrnSaver.i686
libXi.i686
libXrandr.i686
libXrender.i686
libXv.i686
libstdc++.i686
pulseaudio-libs.i686
qt.i686
qt-x11.i686
zlib.i686
qtwebkit.i686
%end

# Post-installation Script
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-postinstall.html
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

rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-23.noarch.rpm
rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-nonfree-release-23.noarch.rpm

cat << EOF > /etc/yum.repos.d/fedora-virtualbox.repo
[virtualbox]
name=VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/23/x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/oracle_vbox.asc
EOF
wget -q -O /etc/pki/rpm-gpg/oracle_vbox.asc https://www.virtualbox.org/download/oracle_vbox.asc

# Harden sshd options
echo "" > /etc/ssh/sshd_config


echo "filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab" > /home/sina/.vimrc

# Enable services
systemctl enable sshd.service
systemctl enable noip.service

# Disable services
systemctl disable avahi-daemon.socket
systemctl disable nfs-client.target
systemctl disable rpcbind.socket
systemctl disable iscsiuio.socket
systemctl disable iscsid.socket
systemctl disable nfs-config.service
systemctl disable iscsi-shutdown.service
systemctl disable gssproxy.service
systemctl disable bluetooth.service
systemctl disable proc-fs-nfsd.mount
systemctl disable var-lib-nfs-rpc_pipefs.mount
%end

# Reboot After Installation
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-reboot.html
reboot --eject
