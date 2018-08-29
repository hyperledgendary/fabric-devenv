# fabric-devenv

[Vagrant](https://www.vagrantup.com) environment to help get started with [Hyperledger Fabric](https://hyperledger-fabric.readthedocs.io/en/latest/).


## Ingredients

You'll need to stock your machine with all these healthy ingredients if you don't have them already:

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/docs/installation/)
    - **Note:** fabric-devenv requires Vagrant 2.0.3 or greater
3. [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Method

To configure a development environment for Hyperledger Fabric (TBC), run the following commands:

```
git clone https://github.com/jt-nti/fabric-devenv.git
cd fabric-devenv
vagrant up
```

When the development environment has finished cooking, log in using:

```
vagrant ssh
```

## Serving suggestion

Now that you have a working development environment, why not... cook up some smart contracts (TBC)!

## Alternative toppings

To install specific versions of Fabric, set a `FABRIC_VERSION` environment variable before running `vagrant up`. 

For example... TBC:

```
FABRIC_VERSION=???? vagrant up
```

Or on Windows:

```
set FABRIC_VERSION=????
vagrant up
```

Supported `FABRIC_VERSION` values:

- TBC

## Cooking tips

### Extra dishes

If you want to set up several VMs with different versions, or for different purposes, you can clone the _fabric-devenv_ repository into different directories. For example,

```
git clone https://github.com/jt-nti/fabric-devenv.git fabric-tutorial
```

Or simply copy an existing clone. The different directory names should show up in the VirtualBox UI after running `vagrant up` if you need to update the VM settings for any of your environments.

### Clearing up

When you've finished with a development environment you can suspend it using `vagrant suspend` and resume later using `vagrant up`

Alternatively, if you've finished with Fabric or want to start again, `vagrant destroy` will completely remove the virtual machine.
