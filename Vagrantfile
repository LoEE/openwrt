# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "bento/ubuntu-16.04"

  # Install a plugin for changing VM disk size
  required_plugins = %w( vagrant-vbguest vagrant-disksize )
  _retry = false
  required_plugins.each do |plugin|
      unless Vagrant.has_plugin? plugin
          system "vagrant plugin install #{plugin}"
          _retry=true
      end
  end

  if (_retry)
      exec "vagrant " + ARGV.join(' ')
  end

  # Set VM parameters:
  config.disksize.size = '50GB'
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 4
  end

  # Install build dependencies and setup a git "keyring" (simple text file - non-secure)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y build-essential libncurses5-dev python unzip liblz4-tool
    su -u vagrant - git config --global credential.helper store
  SHELL
end
