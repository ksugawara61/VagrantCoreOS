# -*- mode: ruby -*-
# vi: set ft=ruby :

# constraint variables
VAGRANT_API_VERSION = "2"
UPDATE_CHANNEL = "alpha"

# setting variables for node
$node_vm_memory = 2048
$node_vm_cpus = 2

Vagrant.require_version ">= 1.6.0"

# Make sure the vagrant-ignition plugin is installed
required_plugins = %w(vagrant-ignition)

Vagrant.configure(VAGRANT_API_VERSION) do |config|

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.vm.box = "coreos-#{UPDATE_CHANNEL}"
  config.vm.box_url = "https://#{UPDATE_CHANNEL}.release.core-os.net/amd64-usr/current/coreos_production_vagrant_virtualbox.json"

  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false
    # enable ignition (this is always done on virtualbox as this is how the ssh key is added to the system)
    config.ignition.enabled = true
  end

  config.vm.provision :shell, path: "bin/setup.sh"

  # for node setting
  config.vm.define :node001 do |v|
    ip = "172.16.1.170"
    hostname = "node001"

    v.vm.network "forwarded_port", guest:80,   host: 80
    v.vm.network "forwarded_port", guest:443,  host: 443
    v.vm.network "private_network", ip: ip

    v.ignition.ip = ip
    v.ignition.hostname = hostname
    v.ignition.drive_name = hostname

    v.vm.provider :virtualbox do |vb|
      vb.memory = $node_vm_memory
      vb.cpus = $node_vm_cpus
    end
  end

end
