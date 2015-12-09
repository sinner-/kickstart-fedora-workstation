# Configure installation method
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/appe-kickstart-syntax-reference.html#sect-kickstart-commands-install
install
url --url=http://download.fedoraproject.org/pub/fedora/linux/releases/23/Everything/x86_64/os
url --url=http://download.fedoraproject.org/pub/fedora/linux/updates/23/x86_64/
repo --name=rpmfusion-free --baseurl=http://download1.rpmfusion.org/free/fedora/releases/23/Everything/x86_64/os
repo --name=rpmfusion-free-updates --baseurl=http://download1.rpmfusion.org/free/fedora/updates/23/x86_64
repo --name=rpmfusion-non-free  --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/23/Everything/x86_64/os
repo --name=rpmfusion-non-free-updates --baseurl=http://download1.rpmfusion.org/nonfree/fedora/updates/23/x86_64
repo --name=google-chrome --baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64

# zerombr
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-zerombr.html
zerombr

# Configure Boot Loader
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-bootloader.html
bootloader --location=mbr --driveorder=sda

# Create Physical Partition
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-part.html
part /boot --size=500 --asprimary --ondrive=sda --fstype=ext4
part swap --recommended --ondrive=sda
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
@base-x
@core
@firefox
@fonts
@guest-desktop-agents
@hardware-support
@libreoffice
@multimedia
@networkmanager-submodules
@printing
@workstation-product
@xfce-desktop
@xfce-apps
@xfce-extra-plugins
@xfce-media
@development-tools
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
vlc
google-chrome-stable
%end

# Post-Installation Script
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-postinstall.html
%post
# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startxfce4
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

# Enable services
systemctl enable sshd.service

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
systemctl disable libvirtd.service
systemctl disable avahi-daemon.service

#Install Adobe Flash Plugin
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
dnf install flash-plugin
%end

# Reboot After Installation
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-reboot.html
reboot --eject
