# -*- mode: ruby -*-
# vi: set ft=ruby :

# constraint variables
VAGRANT_API_VERSION = '2'.freeze
UPDATE_CHANNEL = 'stable'.freeze

# setting variables for node
node_ip = '172.16.1.170'
node_hostname = 'node001'
node_vm_memory = 2048
node_vm_cpus = 2
node_port_array = [80, 443, 3000, 3001, 3002, 3003, 5601, 9200]

Vagrant.require_version '>= 1.6.0'

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

  config.vm.provision :shell, path: 'bin/setup.sh'

  # for node setting
  config.vm.define :node001 do |v|
    config.vm.hostname = node_hostname
    node_port_array.each do |port|
      config.vm.network 'forwarded_port', guest: port, host: port
    end
    v.vm.network 'private_network', ip: node_ip

    v.ignition.ip = node_ip
    v.ignition.hostname = node_hostname
    v.ignition.drive_name = node_hostname

    v.vm.provider :virtualbox do |vb|
      vb.memory = node_vm_memory
      vb.cpus = node_vm_cpus
    end
  end

  config.trigger.before [:up, :reload] do |trigger|
    trigger.info = 'Starging script for before up...'
    trigger.run = {
      path: './bin/before_up_proxy.sh'
    }
  end

  config.trigger.after [:up, :reload] do |trigger|
    trigger.info = 'Starging script for after up...'
    trigger.run = {
      path: './bin/after_up_proxy.sh'
    }
  end

  config.vm.synced_folder(
    './share', '/home/core/share',
    id: 'core',
    nfs: true,
    mount_options: [ 'nolock,vers=3,udp' ]
  )
end
