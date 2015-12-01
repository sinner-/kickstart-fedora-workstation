# Configure installation method
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/appe-kickstart-syntax-reference.html#sect-kickstart-commands-install
install
url --url=http://download.fedoraproject.org/pub/fedora/linux/releases/23/Everything/x86_64/os

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
@xfce-office
@development-tools
gnome-keyring-pam
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
ansible
ipython
#chromium, skype, vlc, flashplugin, MultiBitHD, virtualbox, firejail
%end

# Reboot After Installation
# https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/sect-kickstart-commands-reboot.html
reboot --eject
