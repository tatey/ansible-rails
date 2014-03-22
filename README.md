Bootstrap Vagrant

    vagrant init vagrant init hashicorp/precise32
    vagrant up

Add users and configure SSH

    ansible-playbook -i hosts --private-key=~/.vagrant.d/insecure_private_key -u vagrant users.yaml

Initialize application directory for Capistrano.

    ansible-playbook -i hosts -u devop app.yaml

Install Ruby.

    ansible-playbook -i hosts -u devop ruby.yaml
