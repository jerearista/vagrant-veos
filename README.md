# vagrant-veos
Sample builder to create vagrant vEOS boxes from the Aboot.iso and vEOS-lab.iso files available to registered users at Arista software downloads.

## Requirements

* Registration at https://www.arista.com/
* https://www.packer.io/
* https://www.VirtualBox.org/
* Booting the box requires https://www.VagrantUp.com/

## Useage

To build a vagrant box for Arista vEOS, first, you need to download 2 files from http://arista.com/ which requires registration.

* Go to http://www.arista.com/
* Login
* Click on Software Downloads (bottom left)
* Expand vEOS
* Download Aboot-\*.iso (example: Aboot-veos-2.1.0.iso)
* Download the vmdk for the desired vEOS version (example: vEOS-lab.4.14.5F.vmdk)
* Save the 2 files to the packer/source/ directory as Aboot-vEOS.iso and vEOS.vmdk, respectively.
* cd packer/
* Build the basebox: ``packer build -var “version=4.14.5F” vEOS-4-i386.json``
* The completed basebox will be in ../builds/

## Booting your first vEOS box

The following commands will add your new basebox and display your available
vagrant boxes, then create an initial environment, boot the VM, login to the
bash shell, enter the EOS CLI, display the EOS version, exit, and destroy the
VM.   You can customize how your vEOS node starts up by editing the Vagrantfile
created by ``vagrant init``.

    vagrant box add vEOS-4.14.5F ../builds/vEOS_4.14.5F_virtualbox.box
    vagrant box list

    mkdir vEOS-test
    cd vEOS-test
    vagrant init vEOS-4.14.5F
    vagrant up
    vagrant ssh
    -bash-4.1# FastCLI
    localhost> enable
    localhost# show version
    CTRL+D
    vagrant destroy


