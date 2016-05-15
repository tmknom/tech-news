VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/centos-6.7"
  config.vm.network :private_network, ip: "192.168.100.10"
  config.vm.hostname = 'tech-news'

  #config.vm.provision :shell, path: "provisioning/provision.sh"
  config.vm.provision :shell, inline: "yum -y update --exclude=kernel*"

  # Vagrantが遅いのでその対策
  # http://qiita.com/itopan88/items/06d7c7a08f2d681b042a
  #
  # 初めて実行する場合は下記のスクリプトを実行
  # $ sudo provisioning/install_vagrant_sudoers.sh
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  #config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc']

  config.vm.provider :virtualbox do |v|
    # デフォルトのメモリサイズだとメモリが足りないためMySQL5.6が動かない
    # http://nekopunch.hatenablog.com/entry/2014/03/22/020507
    v.customize ["modifyvm", :id, "--memory", 1024]

    # CPU数の割り当てを増やす
    # http://qiita.com/d_nishiyama85/items/c50c95795865ae7f714b
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--ioapic", "on"]

    # Vagrant+CentOSの組み合わせでネットワークが遅い場合の対策
    # http://qiita.com/s-kiriki/items/357dc585ee562789ac7b
    # v.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    # v.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

end

