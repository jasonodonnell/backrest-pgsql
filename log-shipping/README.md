# Virtual Environment

This is the virtualization blueprint to deploy:
* PostgreSQL (Primary and Log Shipping Replica)
* pgBackrest (Dedicated Backup Host)

## Requirements

* Vagrant (tested on 1.8.6)
* Virtual Box (tested on 5.1.6)
* `vagrant-hostmanager` plugin

To install `vagrant-hostmanager` run the following:

```bash
$ vagrant plugin install vagrant-hostmanager
```

## Deploy

```bash
$ vagrant up
```
