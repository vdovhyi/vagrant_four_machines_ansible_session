# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"

    N = 2

    #DB Server
    config.vm.define "db_server" do |db_server|
      db_server.vm.provision :shell, :path => "scenario_db.sh"
      db_server.vm.network "private_network", ip: "192.168.56.30"
    end
    #WebServers
    (1..N).each do |machine_id|
      config.vm.define "machine#{machine_id}" do |machine|
        machine.vm.hostname = "machine#{machine_id}"
        machine.vm.network "private_network", ip: "192.168.56.#{20+machine_id}"
        machine.vm.provision :shell, :path => "php.sh"
      end
    end
    #Ansible,haproxy
    config.vm.define "ansible_master" do |ansible_master|
      ansible_master.vm.hostname = "ansible"
      ansible_master.vm.network "private_network", ip: "192.168.56.20"
      config.vm.provision "file", 
      	source: "ansible", 
      	destination: "/home/vagrant/"
      config.vm.provision "shell", inline: <<-SHELL
        mkdir /home/vagrant/ansible/ssh_keys
        echo "[WEB_SERVERS]">/home/vagrant/ansible/hosts.txt
        chown -R vagrant:vagrant /home/vagrant/ansible
      SHELL
      (1..N).each do |machine_id|
      	config.vm.provision "shell", inline: <<-SHELL
      	if [ -f /home/vagrant/ansible/ssh_keys/private_key#{machine_id} ]; 
          then rm /home/vagrant/ansible/ssh_keys/private_key#{machine_id}
        fi
        SHELL
      	config.vm.provision "file", 
      	  source: ".vagrant/machines/machine#{machine_id}/virtualbox/private_key", 
      	  destination: "/home/vagrant/ansible/ssh_keys/private_key#{machine_id}"
        config.vm.provision "shell", inline: <<-SHELL
          echo "machine#{machine_id}\t ansible_ssh_host=192.168.56.#{20+machine_id} ansible_user=vagrant ansible_ssh_private_key_file=/home/vagrant/ansible/ssh_keys/private_key#{machine_id}">>/home/vagrant/ansible/hosts.txt
          chmod 400 /home/vagrant/ansible/ssh_keys/private_key#{machine_id}
        SHELL
      end
      ansible_master.vm.provision :shell, :path => "ansible_master.sh"
    end
 
end


#    (1..N-1).each do |machine_id|
#      ANSIBLE_RAW_SSH_ARGS << "-o IdentityFile=#{ENV["VAGRANT_DOTFILE_PATH"]}/machines/machine#{machine_id}/#{VAGRANT_VM_PROVIDER}/private_key"
#    end
#
#    (1..N).each do |machine_id|
#      config.vm.define "machine#{machine_id}" do |machine|
#        machine.vm.hostname = "machine#{machine_id}"
#        machine.vm.network "private_network", ip: "192.168.56.#{20+machine_id}"
#        ####machine.vm.provision "shell", :inline => "sudo ip link set eth1 mtu 1462", run: "always" 
#        if machine_id == N
#          machine.vm.provision :ansible do |ansible|
#            ansible.playbook = "example.yml"
#            ansible.limit = 'all'
#           ansible.inventory_path = "static_inventory"
#            ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS
#          end
#        end
		#machine.vm.provision :file do |file|
		#	file.source      = '.vagrant\machines\machine1\virtualbox\private_key'
      	#	file.destination = '/home/vagrant/.ssh/id_rsa'
    	#end

#      end
#    end



