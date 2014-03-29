# Ansible Playbooks for Ruby on Rails

Provision and manage a solo server suitable for deploying a Ruby on Rails
application on Ubuntu 12.04 LTS. High level components include:

* Ruby
* PostgreSQL
* Nginx
* Unicorn init scripts
* Capistrano directories

These playbooks have been tested against [Vagrant][1], [Binary Lane][2] and
[DigitalOcean][3]. They strive to be idempotent, meaning you can confidently
run them again and again to ensure your servers are consistent. It takes
about 10 minutes to go from a fresh installation of Ubuntu to a fully
provisioned server.

An example `Vagrantfile` is included in this repository.

## Usage

Ansible expects you to have verified the SSH fingerprints of the hosts
you're managing.

    $ ssh-keyscan staging.example.com >> ~/.ssh/known_hosts

Run the bootstrap.yaml playbook as root. This will lock the root account, create
a devop user with sudo access using your SSH public key (`~/.ssh/id_rsa.pub`)
and restrict SSH access to key based authentication for users in the ssh group.

    $ ansible-playbook -i inventories/staging -u root -k bootstrap.yaml

Run the solo.yaml playblock as devop. This will create a deploy user, configure
init scripts, a firewall, ntp, ruby, postgres, nginx, dotenv, and a
capistrano directory.

    $ ansible-playbook -i inventories/staging -u devop solo.yaml

If you want to change dotenv variables without running the rest of the solo.yaml
playbook you can filter tasks using tags.

    $ ansible-playbook -i inventories/staging -u devop solo.yaml --tags "dotenv"

From now on you should always run playbooks as the devop user.

## Configuration

The two most important pieces of configuration are inventory files and
group variables. Each inventory file is paired with a group variable file.

Inventory files reside in `inventories/` and define the hosts you manage
with these Ansible playbooks.

Group variable files reside in `group_vars/` and define variables needed by
the playbooks for a given inventory. Variables include where the application
directory should reside, the name of the deploy user and name of the database
user.

You'll want to copy the example files and populate them with your own
variables.

## Vagrant

If you want to test these playbooks against vagrant on your local computer
you can use the vagrant inventory and group variable files.

    $ vagrant up
    $ ansible-playbook -i inventories/vagrant --private-key=~/.vagrant.d/insecure_private_key -u vagrant bootstrap.yaml
    $ ansible-playbook -i inventories/vagrant -u devop solo.yaml

## Feedback

If you think something is off, or you know a better way of doing something then
I'd love to have your feedback. Please open an issue or send me an email. My
email is tate@tatey.com.

These playbooks are designed for a solo server because that's the problem I
needed to solve. In future, I may need to split these into web and database
roles. Problem for future Tate.

## License and Copyright

Copyright © 2014 Tate Johnson (http://tatey.com). Released under the MIT
license. See LICENSE.

[1]: http://www.vagrantup.com/
[2]: https://www.binarylane.com.au/
[3]: https://digitalocean.com/
