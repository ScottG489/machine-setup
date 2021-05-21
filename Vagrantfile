Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.hostname = "scott-vm"
  config.disksize.size = '30GB'

  config.vm.define "linux" do |lin|
    lin.vm.provider "virtualbox" do |v|
      v.cpus = 4
      v.memory = 8000
    end

    lin.vm.provision "ansible" do |ansible|
      ansible.playbook = "desktop-master-playbook.yml"
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
