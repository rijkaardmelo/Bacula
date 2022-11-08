Vagrant.configure("2") do |config|
    # O sistema operacional que vai ser instalado nas maquinas virtuais
    config.vm.box = "ubuntu/jammy64"
    
    config.vm.define "Bacula" do |bacula|
        # Configurando a rede
        bacula.vm.network "public_network", ip: "10.200.4.200", netmask: "255.255.0.0"
        
        # Configurando a maquina virtual
        bacula.vm.provider "virtualbox" do |vb|
          vb.memory = 1024
          vb.cpus = 1
          vb.name = "Bacula"
        end

        bacula.vm.provision "shell",
            inline: "apt update && apt -y upgrade && apt -y dist-upgrade"
    end
end