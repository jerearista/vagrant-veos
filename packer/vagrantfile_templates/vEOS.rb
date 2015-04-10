# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "vEOS_4.14.4F"

  config.vm.provider 'virtualbox' do |_, override|
    # Disable synced folders
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  # In EOS, root, if enabled, is the only user that can ssh directly to bash.
  config.ssh.username = "root"

  # Network Interfaces:  
  # NIC1 (Management 1) - is created in the the basebox.
  # Uncomment to create additional NICs which will be Ethernet 1-n                                
  #   Using link-local addresses to satisfy the Vagrantfile config parser, only.
  #config.vm.network "private_network", ip: "192.168.1.3", auto_config: false, virtualbox__intnet: true
  #config.vm.network "private_network", virtualbox__intnet: "mynetwork-1", ip: "169.254.1.11", auto_config: false
  # Create Ethernet1
  config.vm.network "private_network", virtualbox__intnet: true, ip: "169.254.1.11", auto_config: false
  # Create Ethernet2
  config.vm.network "private_network", virtualbox__intnet: true, ip: "169.254.1.11", auto_config: false


  # Enable eAPI in the EOS config
  config.vm.provision "shell", inline: <<-SHELL
    FastCli -p 15 -c "configure
    username vagrant privilege 15 role network-admin secret vagrant
    management api http-commands
      no shutdown
    end
    copy running-config startup-config"
  SHELL

  # Enable eAPI over HTTP in the EOS config
  #  FastCli -p 15 -c "configure
  #  username vagrant privilege 15 role network-admin secret vagrant
  #  management api http-commands
  #    no protocol https
  #    protocol http
  #    no shutdown
  #  end
  #  copy running-config startup-config"
  #SHELL
end
