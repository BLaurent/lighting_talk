
#Setup
brew install sshfs
brew cask install osxfuse
vagrant plugin install vagrant-sshfs
vagrant plugin install vagrant-vbguest
brew install packer ansible terraform-provisioner-ansible terraform
brew cask install vagrant
curl -o GE_External_Root_CA_2_1.crt -kl https://static.gecirtnotification.com/browser_remediation/packages/GE_External_Root_CA_2_1.crt
sudo bash
cat GE_External_Root_CA_2_1.crt >> /opt/vagrant/embedded/cacert.pem
exit

vagrant plugin install vagrant-proxyconf


cd lighting_talk/virtualization/webserver
vagrant up

vagrant ssh
