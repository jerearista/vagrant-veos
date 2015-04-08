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

Create a new environment and define which box you wish to use

    mkdir vEOS-test
    cd vEOS-test
    vagrant init vEOS-4.14.5F

Optionally, add any additional configuration to your Vagrantfile, then ‘up’ your VM and login

    vagrant up
    vagrant ssh
    -bash-4.1# FastCLI
    localhost> enable
    localhost# show version

Logout and destroy the VM (All changes since boot will be lost)

    CTRL+D
    CTRL+D
    vagrant destroy

## Adding additional configuration to the Vagrantfile

    config.vm.provider “virtualbox” do |v|
      # Debugging or to see the console during ZTP
      v.gui = true

      # Networking:
      #  nic1 is always Management1 which is set to dhcp in the basebox.
      #
      # Patch Ethernet1 to an internal network
      v.customize [“modifyvm”, :id, “--nic2”, “intnet”, “--intnet2”, “vEOS-intnet1”]
      # Patch Ethernet2 to an internal network
      v.customize [“modifyvm”, :id, “--nic3”, “intnet”, “--intnet3”, “vEOS-intnet2”]
    end 

    # Configure a forwarded port to access eAPI on vEOS
    # https://username:password@localhost:8443/command-api
    config.vm.network “forwarded_port”, guest: 443, host: 8443

    # The sample, below is preconfigured in the basebox
    # Enable eAPI in the EOS config
    config.vm.provision "shell", inline: <<-SHELL
      FastCli -p 15 -c "configure
      management api http-commands
        no shutdown
      end
      copy running-config startup-config"
    SHELL

## Support

The contents of this repository are provided as-is with no warranty.  However, as I use this, myself, there is considerable value in ensuring this works reliably and stays up to date.  Community support is encouraged.
