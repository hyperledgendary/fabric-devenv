# fabric-devenv

[Vagrant](https://www.vagrantup.com) environment to help get started with [Hyperledger Fabric](https://hyperledger-fabric.readthedocs.io/en/latest/).


## Ingredients

You'll need to stock your machine with all these healthy ingredients if you don't have them already:

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/docs/installation/)
    - **Note:** fabric-devenv requires Vagrant 2.0.3 or greater
3. [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Method

To configure a development environment for Hyperledger Fabric 2.2.0, run the following commands:

```
git clone https://github.com/hyperledgendary/fabric-devenv.git
cd fabric-devenv
vagrant up
```

When the development environment has finished cooking, log in using:

```
vagrant ssh
```

## Serving suggestion

Now that you have a working development environment, the VSCode [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) capability is a great way to use it.

After installing the extension, use the 'Remote-SSH: Connect to Host...' VSCode command to connect to the development environment.

**Note:** You'll need to pick `Configure SSH Hosts...` the first time to add a host for the development environment to your SSH configuration file. To get the required SSH configuration, run:

```
vagrant ssh-config
```

## Alternative toppings

To install specific versions of Fabric, set a `HLF_VERSION` environment variable before running `vagrant up`. 

For example, to install the 2.4.3 version of Fabric use:

```
HLF_VERSION=2.4.3 vagrant up
```

Or on Windows:

```
set HLF_VERSION=2.4.3
vagrant up
```

Supported `HLF_VERSION` values:

- Specific `1.4`, `2.0`, `2.1`, `2.2`, `2.3`, or `2.4` version numbers

## Cooking tips

### Extra dishes

If you want to set up several VMs with different versions, or for different purposes, you can clone the _fabric-devenv_ repository into different directories. For example,

```
git clone https://github.com/hyperledgendary/fabric-devenv.git fabric-tutorial
```

Or simply copy an existing clone. The different directory names should show up in the VirtualBox UI after running `vagrant up` if you need to update the VM settings for any of your environments.

### Larger portions

The development environment has an extra 20GB disk on top of the normal storage.
The _opt_ and _home_ directories have 5GB each, leaving another 10GB if you run out of storage.

The following commands will show disk usage and volume group information respectively:

```
df
sudo vgdisplay -v
```

For example, if they show that the home directory is full and there is still enough unallocated space, you can increase the size using these commands:

```
sudo lvextend -L +5G /dev/vagrant/home
sudo resize2fs /dev/vagrant/home
```

### Clearing up

When you've finished with a development environment you can suspend it using `vagrant suspend` and resume later using `vagrant up`.

Alternatively, if you've finished with Fabric or want to start again, `vagrant destroy` will completely remove the virtual machine and the extra disk.

### Known problems

The [Vagrant cachier plugin](http://fgrehm.viewdocs.io/vagrant-cachier/) appears to cause problems with the latest version of Vagrant.
