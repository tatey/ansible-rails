# Ansible Playbooks for Ruby on Rails

Provision and manage a solo server suitable for deploying a Ruby on Rails
application. High level components include:

* Ruby
* PostgreSQL
* Nginx
* Unicorn init scripts
* Capistrano directories

These playbooks have been tested against Vagrant, Binary Lane and
DigitalOcean. They strive to be idempotent, meaning you can confidently
run them again and again to ensure your servers are consistent.

An example `Vagrantfile` is included in this repository.

## Usage

Ansible expects you to have verified the SSH fingerprints of the hosts
you're managing.

    $ ssh-keyscan staging.example.com >> ~/.ssh/known_hosts

Run the bootstrap.yaml playbook as root. This will lock the root account, create
a devop user with sudo access using your SSH public key and restrict SSH
access to users in the ssh group.

    $ ansible-playbook -i staging -u root -k bootstrap.yaml

Run the solo.yaml playblock as devop. This will create a deploy user, configure
init scripts, a firewall, ntp, ruby, postgres, nginx, dotenv, and a
capistrano directory.

    $ ansible-playbook -i staging -u devop solo.yaml

If you want to change dotenv variables without running the rest of the solo.yaml
playbook you can filter tasks using tags.

    $ ansible-playbook -i staging -u devop solo.yaml --tags "dotenv"

From now on you should always run playbooks as the devop user.

## Configuration

The two most important pieces of configuration are inventory files and
group variables.

## License and Copyright

Copyright © 2014 Tate Johnson (http://tatey.com). Released under the MIT
license. See LICENSE.
