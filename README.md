# vagrant-veos
Sample builder to create vagrant vEOS boxes from the Aboot.iso and vEOS-lab.iso files available to registered users at Arista software downloads.

## Requirements

* Registration at https://www.arista.com/
* https://www.packer.io/
* https://www.VirtualBox.org/
* Booting the box requires https://www.VagrantUp.com/

## Usage

To build a vagrant box for Arista vEOS, first, you need to download 2 files from http://arista.com/ which requires registration.

* Go to http://www.arista.com/
* Login
* Click on Software Downloads (bottom left)
* Expand vEOS
* Download Aboot-\*.iso (example: Aboot-veos-2.1.0.iso)
* Download the vmdk for the desired vEOS version (example: vEOS-lab.4.15.0F.vmdk)
* Save the 2 files to the packer/source/ directory as Aboot-vEOS.iso and vEOS.vmdk, respectively.
* cd packer/
* Build the basebox: ``packer build -var “version=4.15.0F” vEOS-4-i386.json``
* The completed basebox will be in ../builds/

## Booting your first vEOS box

The following commands will add your new basebox and display your available
vagrant boxes, then create an initial environment, boot the VM, login to the
bash shell, enter the EOS CLI, display the EOS version, exit, and destroy the
VM.   You can customize how your vEOS node starts up by editing the Vagrantfile
created by ``vagrant init``.

    vagrant box add --name vEOS-lab-4.15.0F ../builds/vEOS-lab-4.15.0F-virtualbox.box
    vagrant box list

Create a new environment and define which box you wish to use

    mkdir vEOS-test
    cd vEOS-test
    vagrant init vEOS-4.15.0F

Optionally, add any additional configuration to your Vagrantfile, then ‘up’ your VM and login

    vagrant up
    vagrant ssh
    -bash-4.1# FastCli
    localhost> enable
    localhost# show version

Logout and destroy the VM (All changes since boot will be lost)

    CTRL+D
    CTRL+D
    vagrant destroy

## Adding additional configuration to the Vagrantfile

    # Add additional NICs to the VM:
    #   NIC1 (Management 1) - is created in the the basebox and vagrant always uses this via DHCP to communicate with the VM.
    #   The default Vagrantfile template includes Ethernet1 and Ethernet2.  Add lines similar to those below to create
    #     additional NICs which will be Ethernet 3-n                                
    #   Using link-local addresses to satisfy the Vagrantfile config parser, only.  They will not be used by vEOS.
    #config.vm.network 'private_network', ip: '169.254.1.11', auto_config: false, virtualbox__intnet: true
    #config.vm.network 'private_network', virtualbox__intnet: 'mynetwork-1', ip: '169.254.1.11', auto_config: false
    # Create Ethernet3
    config.vm.network 'private_network', virtualbox__intnet: true, ip: '169.254.1.11', auto_config: false
    # Create Ethernet4
    config.vm.network 'private_network', virtualbox__intnet: true, ip: '169.254.1.11', auto_config: false

    config.vm.provider “virtualbox” do |v|
      # Unconnent for debugging or to see the console during ZTP
      #v.gui = true

      # Networking:
      #  nic1 is always Management1 which is set to dhcp in the basebox.
      #
      # Patch Ethernet1 to a particular internal network
      v.customize [“modifyvm”, :id, “--nic2”, “intnet”, “--intnet2”, “vEOS-intnet1”]
      # Patch Ethernet2 to a particular internal network
      v.customize [“modifyvm”, :id, “--nic3”, “intnet”, “--intnet3”, “vEOS-intnet2”]
    end

    # Configure a forwarded port to access eAPI on vEOS
    # https://username:password@localhost:8443/command-api
    config.vm.network “forwarded_port”, guest: 443, host: 8443

    # The sample, below is preconfigured in the basebox
    # Enable eAPI in the EOS config
    config.vm.provision 'shell', inline: <<-SHELL
      FastCli -p 15 -c "configure
      username vagrant privilege 15 role network-admin secret vagrant
      management api http-commands
        no shutdown
      end
      copy running-config startup-config"
    SHELL
    
    # Provision files on to flash:
    config.vm.provision 'file', source: 'files/rc.eos', destination: '/mnt/flash/rc.eos'
    config.vm.provision 'file', source: 'files/rphm-1.1.0-1.rpm', destination: '/mnt/flash/rphm-1.1.0-1.rpm'

## Support

The contents of this repository are provided as-is with no warranty.  However, as I use this, myself, I have considerable interest in ensuring it works reliably and stays up to date.  Community support is encouraged.
