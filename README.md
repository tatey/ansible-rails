# Ansible

Manage a solo server for ruby on rails on a computer of your choice.

## Usage

### Vagrant

    $ vagrant init vagrant init hashicorp/precise32
    $ vagrant up

### Bootstrap

Create a devop user with your public key and lock down ssh.

    $ ansible-playbook -i vagrant --private-key=~/.vagrant.d/insecure_private_key -u vagrant bootstrap.yaml

### Solo

Create a deploy user, configure init scripts, install ruby, install
postgres, install nginx and configure a firewall.

    $ ansible-playbook -i vagrant -u devop solo.yaml

Configure dotenv without running the rest of the playbook.

    $ ansible-playbook -i vagrant -u devop solo.yaml --tags "dotenv"
