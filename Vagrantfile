Vagrant.configure("2") do |config|
 
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :private_network, ip: "192.168.33.121"
     
    config.vm.synced_folder "./", "/vagrant", id: "vagrant-root", owner: "www-data", group: "www-data"  

    config.vm.provision :puppet do |puppet|
        puppet.facter = { 
            "fqdn" => "modx.local", 
            "docroot" => '/vagrant/www/',
            "vagrant" => "1"
        }
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.options = ['--verbose']
    end

end
