# -*- mode: ruby -*-
# vi: set ft=ruby :

# Unfortunately need to require a very recent version due to
# issues caused by default Vagrant box hosting moving to
# vagrantcloud.com
# See https://github.com/hashicorp/vagrant/issues/9442
Vagrant.require_version ">= 2.0.3"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Set up the quickstart environment on 18.04 LTS Ubuntu
  config.vm.box = "ubuntu/bionic64"

  # Optionally cache packages
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Port forwarding
  config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
  config.vm.network "forwarded_port", guest: 4200, host: 4200, auto_correct: true
  config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 7050, host: 7050, auto_correct: true
  config.vm.network "forwarded_port", guest: 7051, host: 7051, auto_correct: true
  config.vm.network "forwarded_port", guest: 7052, host: 7052, auto_correct: true
  config.vm.network "forwarded_port", guest: 7054, host: 7054, auto_correct: true
  config.vm.network "forwarded_port", guest: 7055, host: 7055, auto_correct: true
  config.vm.network "forwarded_port", guest: 7056, host: 7056, auto_correct: true
  config.vm.network "forwarded_port", guest: 9051, host: 9051, auto_correct: true
  config.vm.network "forwarded_port", guest: 9052, host: 9052, auto_correct: true

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  #config.vm.synced_folder "go/src", "/home/vagrant/go/src", create: true

  # VirtualBox configuration
  config.vm.provider "virtualbox" do |vb|
    # Increase memory allocated to vm (for build tasks)
    vb.memory = 6192

    # Add disk space
    disk = File.join(File.realpath(File.expand_path(__dir__)), "fabric-devenv-disk.vmdk").to_s
    if not File.exists?(disk)
      vb.customize [ "createmedium", "disk", "--filename", disk, "--format", "vmdk", "--size", 1024 * 20 ]
      vb.customize ["storageattach", :id,  "--storagectl", "SCSI", "--port", 2, "--device", 0, "--type", "hdd", "--medium", disk]
    end
  end

  # Configure additional disk space
  config.vm.provision "provision-disk", type: "shell", path: "provision-disk.sh", privileged: true

  # Configure vagrant user .profile
  config.vm.provision "provision-user-profile", type: "shell", path: "provision-user-profile.sh", privileged: false
  
  # Install required software
  config.vm.provision "provision-root", type: "shell", path: "provision-root.sh", privileged: true, args: ENV['HLF_VERSION']
  config.vm.provision "provision-user", type: "shell", path: "provision-user.sh", privileged: false, args: ENV['HLF_VERSION']

end
