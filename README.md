# Virtual Environment

This is the virtualization blueprint to deploy PostgreSQL 9.6 and pgBackrest to replicate in two different ways:
* Streaming Replication
* Log Shipping

## Requirements

* Vagrant (tested on 1.8.6)
* Virtual Box (tested on 5.1.6)
* `vagrant-hostmanager` plugin

To install `vagrant-hostmanager` run the following:

```bash
$ vagrant plugin install vagrant-hostmanager
```
