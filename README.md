Bootstrap Vagrant

    vagrant init vagrant init hashicorp/precise32
    vagrant up

Users and SSH

    ansible-playbook -i hosts --private-key=~/.vagrant.d/insecure_private_key -u vagrant users.yaml

Application directory

    ansible-playbook -i hosts -u devop app.yaml

Environment variables

    ansible-playbook -i hosts -u devop env_vars.yaml

Ruby

    ansible-playbook -i hosts -u devop ruby.yaml

PostgreSQL

    ansible-playbook -i hosts -u devop postgres.yaml
