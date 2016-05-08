VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/centos-6.7"
  config.vm.network :private_network, ip: "192.168.100.10"
  config.vm.hostname = 'tech-news'

  config.vm.provision :shell, path: "provisioning/provision.sh"

  # Vagrantが遅いのでその対策
  # http://qiita.com/itopan88/items/06d7c7a08f2d681b042a
  #
  # 初めて実行する場合は下記のスクリプトを実行
  # $ sudo provisioning/install_vagrant_sudoers.sh
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.provider :virtualbox do |v|
    # デフォルトのメモリサイズだとメモリが足りないためMySQL5.6が動かない
    # http://nekopunch.hatenablog.com/entry/2014/03/22/020507
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

end

