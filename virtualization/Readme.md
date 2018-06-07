
# Setup
Pre-requisites, install some new software:

    brew cask install virtualbox virtualbox-extension-pack
    brew cask install vagrant
    vagrant plugin install vagrant-vbguest
    brew install packer ansible terraform-provisioner-ansible terraform doctl


# First Step : Your first VM
You can start you first VM and checking if the previous step did work with the following:

    git clone https://github.com/BLaurent/lighting_talk
    cd lighting_talk/virtualization/webserver
    vagrant up
    vagrant ssh


If everything goes well you should be see a shell.

# Second step : Seting up a Web server

The configuration of the VM is declared in the *Vagrantfile*, at the end of this file you should see something like that uncomment it, to enable the setup of the VM via ansible. 

    config.vm.provision "ansible" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.playbook = "./ansible-nginx/playbook.yml"
        ansible.extra_vars = {
            ansible_python_interpreter: "/usr/bin/python3",
        }
    end 

After uncommenting you need to recreate the VM:

    vagrant destroy -f && vagrant up && vagrant ssh

Pay attention to the output of the shell to see all operations applied
You can check that you have a web server running in your VM with this command

    ps aux | grep nginx


Ok the nginx is running but I cannot access it from outside the VM.
Edit the *Vagrantfile*  and uncomment :

    config.vm.network "forwarded_port", guest: 80, host: 8888

You need to reload the config:

    vagrant reload

Open a web browser and type the following URL: http://localhost:8888/

An epic Hello World should be displayed.


# Third Step : VM image creation

We have validated the creation locally we need to make things a bit more systematic.
For that we will use *packer* and start from scatch which mean we no longer rely on virtual box pre-configured images but raw iso from ubuntu web site in our case.

*Packer* rely on a json file to create VM images for different cloud provider and environement : AWS, Azure, GCP, ..., VirtualBox 

Since we are starting from scratch we need to boot and install all package that are required to be able to run ansible.

*packer.json* file are splitted in several sections: *builders*, *provisioners*, *post-processors*,...

For each builder we will generate an image type: AMI, OVA, ...
Let start by building and image for virtualbox

    packer build -only=virtualbox-iso packer.json

At the end you have a virtual box capable machine embadding a nginx and our simple website.

Enter the duck *directory* and do

    vagrant up && vagrant ssh

Open a web browser and type the following URL: http://localhost:8888/
Et Voila !!! 

# Forth step : VM image creation and test on Digital Ocean

First things to do is to change the API key in the *packer.json* file with yours.

    {
      "type": "digitalocean",
      "api_token": "XXXXXXXXXXX",
      "image": "ubuntu-16-04-x64",
      "region": "fra1",
      "size": "512mb",
      "ssh_username": "root"
    },

Then to create an image compatible with Digital Ocean, you just need to launch :

    packer build -only=digitalocean packer.json

In the end you will have a nice image reading to be used with a droplet

*We assume you have you digital ocean configured*

Get the list of image, region, machine available

    doctl compute image list
    doctl compute region list
    doctl compute size list

Create a droplet using this image

    doctl compute droplet create --image XXXXXX --region fra1 --size s-1vcpu-1gb packer-test

where XXXXX will be replace by the image id you have retrieve with the previous three commands.

After that you need to get the public IP of your droplet

    doctl compute droplet list

Open a web browser and type the following URL: http://IP
Et Voila !!! 


Do not forget to delete your images and droplets at the end of your tests

    doctl compute image list
    doctl compute droplet list

Then 
    
    doctl compute image delete XXX
    doctl compute droplet delete YYYY


