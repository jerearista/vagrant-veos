# -*- mode: ruby -*-
# # vi: set ft=ruby :
#
# This file can be used to modify the behavior of a vagrant box deployed by
# TestKitchen.Save in 'vagrantfiles/veos.rb' and reference it in '.kitchen.yml':
#
# driver:
#   name: vagrant
#   vm_hostname: false
#   provision: true
#   vagrantfiles:
#     - vagrantfiles/veos.rb
#
#             OR per-VM using:
#
# platforms:
#   - name: vEOS_4.15.3F
#     driver:
#       vagrantfiles:
#         - vagrantfiles/veos.rb

Vagrant.configure(2) do |config|
  # Create additional NICs
  # Ethernet1
  config.vm.network 'private_network', virtualbox__intnet: true,
                                       ip: '169.254.1.11', auto_config: false
  # Ethernet2
  config.vm.network 'private_network', virtualbox__intnet: true,
                                       ip: '169.254.1.11', auto_config: false

  config.vm.provider :virtualbox do |v|
    # Patch NICs to the desired network:
    #  nic1 is always Management1 which is set to dhcp in the basebox.

    # Patch Ethernet1 to a particular internal network
    v.customize ['modifyvm', :id, '--nic2', 'intnet',
                 '--intnet2', 'vEOS-intnet1']
    # Patch Ethernet2 to a particular internal network
    v.customize ['modifyvm', :id, '--nic3', 'intnet',
                 '--intnet3', 'vEOS-intnet2']
  end

  config.vm.provision 'shell', inline: <<-SHELL
    sleep 30
    FastCli -p 15 -c 'configure
    ip route 0.0.0.0/0 10.0.2.2
    end'
    SHELL
end
