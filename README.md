## Fedora Workstation Kickstart File

Bringing you a clean Fedora installation since F23.

Tested as working on Fedora 29.

### Overview

Part of an overall project to adopt the "cattle" approach to my personal computing.

Assuming the distribution does its job correctly, I can use this project along with
good backups in my homedir to have a consistent environment on any installed target.

Designed to:

* Deploy Fedora with a repeatable and automated method.
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
* If you're not me you will probably want to run:
  * `sed -i 's/sina-laptop/YOUR_DESIRED_HOSTNAME/' workstation.ks`.
    * (run this command before the next one to avoid sed mixups)
  * `sed -i 's/sina/YOUR_NAME/' workstation.ks`.
  * `sed -i 's/^timezone/timezone Yourcountry\/Yourcity/' workstation.ks`.
* Run the kickstart.py script which will ask you for the user password and FDE passphrase and then launch a HTTP server:
  * `python3 kickstart.py`
* Install Fedora Workstation netinst to a usb with `dd if=netinst.iso of=/dev/sdx bs=1M oflag=sync status=progress`.
* Boot Fedora Workstation netinst on the target install machine.
* At the boot screen, press UP to select the "install without verify" option and then TAB.
* Insert the kickstart directive into the the boot string **before** the `quiet` directive.:
  * `inst.ks=http://<WEB_SERVER_IP>:<PORT>/workstation.ks`
* Hit ENTER. Install will begin and complete without any further prompt.
