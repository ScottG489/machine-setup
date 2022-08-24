Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.hostname = "scott-vm"

  config.vm.define "desktop" do |lin|
    lin.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 8000
    end

    lin.vm.provision "ansible", type: "ansible" do |ansible|
      ansible.playbook = "desktop-master-playbook.yml"
    end

    lin.vm.provision "test", type: "ansible" do |ansible|
      ansible.playbook = "test_playbook/test-playbook.yml"
    end
  end

  config.vm.define "server" do |lin|
    lin.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 4000
    end

    lin.vm.provision "ansible" do |ansible|
      ansible.playbook = "server-master-playbook.yml"
    end
  end

  config.vm.define "home-assistant-server" do |lin|
    lin.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 4000
    end

    lin.vm.provision "ansible" do |ansible|
      ansible.playbook = "home-assistant-server-master-playbook.yml"
    end
  end

  config.vm.define "windows" do |win|
    win.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 8000
    end

    win.vm.provision "ansible" do |ansible|
      ansible.playbook = "windows-host-playbook.yml"
      ansible.inventory_path = ".vagrant/provisioners/ansible/inventory"
    end
  end

  config.vm.define "mac" do |mac|
    mac.vm.provider "parallels" do |v|
      v.cpus = 4
      v.memory = 8000
    end

    mac.vm.provision "ansible" do |ansible|
      ansible.playbook = "mac-host-playbook.yml"
    end
  end

end
