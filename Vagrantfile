# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

PREPARE_ENV = <<EOF

sudo apt-get update -y
sudo apt-get install -y git

EOF

docker_login = false

if File.exists? "#{__dir__}/.docker-credentials.rb"
  require "#{__dir__}/.docker-credentials.rb"

  PREPARE_BUILD = <<EOF

CYBERDOJO_LOCATION=/usr/src/cyberdojo

if ! [ -d "$CYBERDOJO_LOCATION" ]; then
  git clone https://github.com/JonJagger/cyberdojo.git "$CYBERDOJO_LOCATION"
fi

sudo docker login --username="#{DOCKER_USERNAME}" --password="#{DOCKER_PASSWORD}" --email="#{DOCKER_EMAIL}"

if ! grep DOCKER_USERNAME /home/vagrant/.bashrc; then
  echo 'export DOCKER_USERNAME="#{DOCKER_USERNAME}"' >> /home/vagrant/.bashrc
fi

EOF

  docker_login = true
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.synced_folder "scripts", "/home/vagrant/scripts"
  config.vm.synced_folder "templates", "/home/vagrant/templates"
  config.vm.synced_folder "projects", "/home/vagrant/projects"

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    vb.gui = false

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provision "docker" do end

  config.vm.provision "shell", inline: PREPARE_ENV

  if docker_login
    config.vm.provision "shell", inline: PREPARE_BUILD
  end
end
