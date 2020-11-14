# consensas-ansible

## Introduction

A couple of [Ansible](https://www.ansible.com/) scripts that 
you might find useful.

* K8S Quickstart - quickly set up a Kubernetes installation
* Ubuntu Install - set up Ubuntu on a base installation
* Node Install - install the latest Node.JS

You'll need to have Ansible installed on your computer and
root access to edit [/etc/hosts](https://www.thegeekdiary.com/understanding-etc-hosts-file-in-linux/).
It's nice to have Kubernetes on your computer, so you
can communicate with the K8S cluster.

One word of advice: make these your own - copy and
modify as you see fit for your system. Don't expect
super parameterized general scripts here. It's a 
jumping off point.

## Inventory 

Ansible uses an "inventory" file to describe all the hosts upon
which it's going to operate on. In these examples, we just have 
the inventory in this folder rather than use the system-wide
inventory.

Here's an example inventory for AWS with a Kubernetes Master
and two Workers, named aws-0001, and then aws-0002 and onwards.

    all:
      hosts:
        aws-[0000:9999]:
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /Users/david/.aws/production.pem
      children:
        master:
          hosts:
            aws-0001:
        worker:
          hosts:
            aws-0002:
            aws-0003:

You should edit /etc/hosts to add the IP addresses for aws

    52.201.0.193    aws-0001
    34.227.235.37   aws-0002
    34.227.235.38   aws-0003

If you have [SSH login without password](https://phoenixnap.com/kb/setup-passwordless-ssh)
setup, you can do the following. In this particular case, make sure that 
user `david` can sudo root commands.

    all:
      hosts:
        server-[0000:9999]:
          ansible_user: david
      children:
        master:
          hosts:
            aws-0001:
        worker:
          hosts:
            aws-0002:
            aws-0003:
              

**Important** - if you customize and use your own naming
scheme, you'll have to modify `k8s/Kubernetes-Master.sh`,
is Kubernetes **requires** that you tell it the DNS name
you'll using to talk to it.

## Tools

### K8S Quickstart

This repository very quickly will set up a [Kubernetes](https://kubernetes.io/)
system on AWS (trivially adapted to other clouds or machines on the LAN).

K8S is (to me) a very very complicated system, but one nice thing about it
is if you run into trouble, you can usually just tear it down and rebuild. 
I originally wrote this when we were having difficulty getting
networking working: this let me try out a whole bunch of different
options in a matter of minutes.

#### Create AWS Instances

If you already have some computers available, or some Raspberry Pis or whatever,
you can more or less ignore this step. 

* Log in to your AWS Account and go to [EC2](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Home:)
* Go to the [Launch Wizard](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:)
* Look for the AMI called **Ubuntu Server 20.04 LTS (HVM), SSD Volume Type** and go through the
  setup step by step
  * **Instance Type** to taste. `t2.medium` is the minimum - it will require at least 2 cores
  * **Configure Instance Details**: select the number of instances to create - you need at least 2 for K8S,
    Everything else should be fine
  * **Add Storage**: should be fine
  * **Add Tags**: to taste
  * **Configure Security Group**: make sure there is open (0.0.0.0/32) SSH (port 22) 
    and Kubernetes (port 6443) access. 
    *Not sure if VPC open is the default but this is required too*.
    From a security point of view, this isn't ideal
    and you'll want to narrow it down, but explaining AWS Security Groups is out of scope.
  * **Review Instance Launch**: review and press **Launch**. 
    Create a keypair if you haven't already and store in `~/.aws`. Make
    sure that folder is `chmod 700`. The keypair is stored
    in a `PEM` file which is needed for accessing AWS.
* Go back to the EC2 home page and name the servers `aws-0001` and so on

#### Notes on networking

If you're just playing around and plan to be starting and stopping the instances
frequently (so you don't get charged), consider assigning ElasticIP addresses 
to your instances, otherwise the IP will change every time you start and stop.
Another option is to use IPv6, though I have not played with this. 

If the IP addresses change, you will have to edit `$HOME/.ssh/known_hosts` and
delete the old IP addresses first.

If you're not familiar with AWS, just be aware every host has two IP address:
one for its Virtual Private Cloud (VPC) inside AWS, and the other is public 
for the world to see.

If you get long hangs and then failures, likely the issue is something is 
being blocked because of your security rules.

#### Set up local inventory

* Copy the names and **Public IPv4** (or **ElasticIP**) addresses and add to `/etc/hosts` on your computer
* Make sure `inventory.yaml` also reflects the hosts you created **AND** your PEM file.
  It should look something like this (assuming you created 3 hosts). 

`inventory.yaml`:

    all:
      hosts:
        aws-[0000:9999]:
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /Users/david/.aws/davidjanes.pem
      children:
        master:
          hosts:
            aws-0001:
        worker:
          hosts:
            aws-0002:
            aws-0003:

#### Base Ubuntu setup

Run this script, which will install Python, Node.JS, curl and vim.

    sh ubuntu/Ubuntu-Initialize.sh

It can be parameterized with a single argument, the name of a host
or a collection of hosts, e.g, `master,workers`, in case you add
something later.

Note that this script, like all others here are basically *idempotent*:
you can safely run it multiple times.

#### Setup Kubernetes 

First, run this script. This will install Kubernetes, Container.io,
system level configuration (e.g. turning off swap) needed to 
run K8S on all the hosts.  For reference, though we used very little of this 
[read more](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/).

    sh k8s/Kubernetes-Common.sh

Next - and order is very important here - run this script:

