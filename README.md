Bootstrap Vagrant

    vagrant init vagrant init hashicorp/precise32
    vagrant up

Install Ruby

    ansible-playbook -i hosts --private-key=~/.vagrant.d/insecure_private_key -u vagrant ruby.yaml

Install Nginx

    ansible-playbook -i hosts --private-key=~/.vagrant.d/insecure_private_key -u vagrant nginx.yaml
