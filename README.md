# CHIP-SDK
Everything needed to develop software for C.H.I.P.

While it is possible to install the SDK natively on your computer, currently the only supported way is to run it from a virtual machine.

## System Requirements
A version of Windows, Mac OS X or your favourite Linux distribution running VirtualBox and Vagrant.
For the virtual machine at least of free 1 GB RAM are necessary.
Up to 40 GB of disk space may be used.

## Installation

### VirtualBox
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install the [Oracle VM VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads) for the host - this is necessary to flash C.H.I.P from inside the virtual machine.
3. Operating system specific stuff:
   - If you are on Windows, you need to add the VirtualBox installation directory to your PATH.
   - In case of a Ubuntu host: add your user to the vboxusers group!

### Vagrant
You may need to install Vagrant. There's a couple options: 

* Download from [the Vagrant website](https://www.vagrantup.com/downloads.html)
* On OS X, you can use the [homebrew](http://brew.sh) package manager: 
    1. you'll need [Cask](http://caskroom.io), so if you don't have it: `brew install caskroom/cask/brew-cask`
    2. then `brew cask install vagrant`

### Git
Installation of Git depends on your operating system:
* On Windows, look at https://git-scm.com/download/win
* On a Debian based Linux you can do: `sudo apt-get install git`
* On Mac OS, the most convenient way is [homebrew](http://brew.sh): `brew install git`

### Clone the CHIP-SDK Git repository
Assuming you have `git` in your PATH, open up a terminal and type:

    git clone https://github.com/NextThingCo/CHIP-SDK

### Start up the virtual machine

In a shell on the host, change to the the CHIP-SDK directory and sart up the virtual machine:

    cd CHIP-SDK
    vagrant up

A couple notes for the bleary eyed. If you get an error like:

    error: The guest machine entered an invalid state while waiting for it to boot.

This probably means your version of VirtualBox needs updating and/or needs the [Extension Pack](https://www.virtualbox.org/wiki/Downloads). Update as necessary and try `vagrant up` again.

If you get the error:

    error: Couldn't open file /Volumes/Satellite/gitbins/CHIP-SDK/base
    
that means you didn't `cd CHIP-SDK`.

### Login

In  the same shell on the host type the following:

    vagrant ssh

If everything went well you should see the following prompt:

    vagrant@vagrant-ubuntu-trusty-32:~$

Now run the setup script that installs the necessary software inside of the virtual machine:

    cd CHIP-SDK
    ./setup_ubuntu1404.sh

## Flash a new C.H.I.P for the first time

Jumper the CHIP in FEL mode and then connect it to the USB port of your computer.
Start the virtual machine and login as described above.
When you see the `vagrant@vagrant-ubuntu-trusty-32:~$` prompt, type:

    cd CHIP-SDK/CHIP-tools
    ./chip-update-firmware.sh

This downloads the latest firmware (i.e. a Linux kernel, U-Boot and a root filesystem all built with buildroot) and flashes it CHIP.

## Build your own flash image for CHIP

### Start the build process

Logged into the virtual machine (you should see the `vagrant@vagrant-ubuntu-trusty-32:~` prompt) type:

    cd CHIP-SDK/CHIP-buildroot
    make chip_defconfig
    make nconfig #(optional - in case you want to add software)
    make

### Flash your own buildroot image

Logged in to the virtual machine type:

    cd ~/CHIP-SDK/CHIP-tools
    BUILDROOT_OUTPUT_DIR=../CHIP-buildroot/output ./chip-fel-flash.sh

### Shutdown

If you are still logged into the virtual machine, log out:

    exit
    
Then, in the host-shell type:

    vagrant halt

### Troubleshooting
In case you run into trouble because the kernel in the VM was updated and the shared vagrant folder can no longer be mounted, update the guest additions by typing the following in the CHIP-SDK directory on the host:

    vagrant plugin install vagrant-vbguest

Also look at [this blog post](http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/)

