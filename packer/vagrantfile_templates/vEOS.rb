# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = 'vEOS-lab-4.21.0F'

  config.vm.provider 'virtualbox' do |_, override|
    # Disable synced folders
    config.vm.synced_folder '.', '/vagrant', disabled: true
  end

  # In EOS, root, if enabled, is the only user that can ssh directly to bash.
  config.ssh.username = 'root'
end
