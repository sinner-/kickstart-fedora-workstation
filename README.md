## Fedora Workstation Kickstart File

### Overview

Part of an overall project to adopt the "cattle" approach to my personal computing.

Assuming the distribution does its job correctly, I can use this project along with
good backups in my homedir to have a consistent environment on any installed target.

Designed to:

* Deploy Fedora (tested on F23) with a repeatable and automated method.
* Provide a single source of truth for the software I like to use.
* Encapsulate any optimisations/tricks I like to apply.

### Requirements
* This README assumes installation to a device with:
  * An internet connected ethernet port.
  * At least 15GB of HDD.
  * A webserver to host this kickstart file once it is configured.
* For machines with no eth port, use `livecd-iso-to-disk` then add the ks file to the USB.
  * https://github.com/rhinstaller/livecd-tools/blob/master/tools/livecd-iso-to-disk.sh

### Use
* Clone and enter this repository with:
  * `git clone https://github.com/sinner-/kickstart-fedora-workstation`.
  * `cd kickstart-fedora-workstation`.
* Configure the LUKS full disk encryption passphrase:
  * `sed -i 's/fdepassphrase/YOUR_FULL_DISK_ENCRYPTION_PASSPHRASE/' workstation.ks`.
* Configure the builtin users password:
  * `sed -i 's/userpassword/YOUR_USER_PASSWORD/' workstation.ks`.
* If you're not me you will probably also want to run:
  * `sed -i 's/sina-laptop/YOUR_DESIRED_HOSTNAME/' workstation.ks`.
    * (run this command before the next one to avoid sed mixups)
  * `sed -i 's/sina/YOUR_NAME/' workstation.ks`.
  * `sed -i 's/^timezone/timezone Yourcountry\/Yourcity/' workstation.ks`.
* Upload the kickstart file to your webserver. I normally use another local linux machine:
  * `python -m SimpleHTTPServer` (starts on port 8000).
* *SECURITY REMINDER:*
  * *FDE PASSWORD AND USER PASSWORD WILL BE PRESENT IN THE FILE IN PLAINTEXT*
  * *KICKSTART FILE WILL BE ACCESSIBLE FROM THE WEBSERVER*
  * *DO NOT USE THIS PROJECT UNLESS YOU ARE CAPABLE OF SECURING THIS SENSITIVE INFO*
* Boot Fedora Workstation netinst on the target install machine.
* At the boot screen, press UP to select the "install without verify" option and then TAB.
* Append the kickstart directive to the end of the boot string:
  * `inst.ks=http://<WEB_SERVER_IP>:<PORT>/workstation.ks`
* Hit ENTER. Install will begin and complete without any further prompt.
