# CHIP-SDK
Everything needed to develop software for C.H.I.P.

While it is possible to install the SDK natively, currently the only supported way is to run it from a virtual machine.

## System Requirements
You'll need VirtualBox and Vagrant.
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
You may need to install Vagrant. There are a couple options: 

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

    ./CHIP-SDK/setup_ubuntu1404.sh
 
Congratulations!  Your C.H.I.P. SDK is almost ready!  To finish up and apply the updated permissions, log out of the virtual machine...

    exit

Now you're ready to Flash a C.H.I.P. from your SDK!

## Prepare your C.H.I.P. for Flashing

First, prepare CHIP with a jumper wire between the UBOOT pin and GND. In other words, connect Pin 7 and Pin 39 on header U14.

Here's a diagram that labels the headers and pins assuming the USB port is oriented up:

![Image of CHIP](https://nextthingco.zendesk.com/hc/en-us/article_attachments/203156518/CHIP_ALPHA_V02_Pinouts.png "Image of jumpered CHIP")

And here's a photo with the jumper plugged in...

![Image of CHIP](https://nextthingco.zendesk.com/hc/en-us/article_attachments/203164668/DSCF2062.JPG "Image of jumpered CHIP")

It's worth noting that this jumper needs to be present only when you connect CHIP to power. If for some reason the wire becomes disconnected after you have powered CHIP, there is no problem or need to panic.

Now connect CHIP to your computer with a micro-USB→USB-B cable. The power LED will illuminate.

It's time to begin! Open a terminal on your computer, and let's start up a virtual machine.

    cd CHIP-SDK
    vagrant up
    vagrant ssh

If everything went well you should see the following prompt:

    vagrant@vagrant-ubuntu-trusty-32:~$
   
Now we're into C.H.I.P. and ready to flash an image.



## Flash a new C.H.I.P. with the NTC buildroot image... 

If you want to flash C.H.I.P. with a custom image, scroll down the page...If you're cool with our current buildroot image, keep going!

With our virtual machine running, we'll start at our *trusty* prompt:

    vagrant@vagrant-ubuntu-trusty-32:~$

Now let's download the latest firmware (i.e. a Linux kernel, U-Boot and a root filesystem all built with buildroot) and flash it to CHIP.

    cd ~/CHIP-tools
    ./chip-update-firmware.sh

This downloads the latest firmware (i.e. a Linux kernel, U-Boot and a root filesystem all built with buildroot) and flashes it to CHIP.

CHIP will boot automatically after flashing.  Booting may take a minute.  If everything went well, you can now log in to your CHIP:

    cu -l /dev/ttyACM0 -s 115200

C.H.I.P.'s login is root. Booting may take a minute.  If everything went well you should be able to run a hardware test...

    hwtest

If everything passed, your C.H.I.P. is ready to go!  Have fun!

## To Flash C.H.I.P. with your own custom buildroot image...

### Start the build process

Logged in to the virtual machine again starting from our *trusty* prompt:

    vagrant@vagrant-ubuntu-trusty-32:~$

Lets' get in there and make something.

    cd ~/CHIP-buildroot
    make chip_defconfig
    make nconfig

From here, you can navigate the menu and select what you want to flash onto your C.H.I.P. and what you don't. Detailing custom buildroot images is outside the scope of this tutorial.  If you're curious, read Free Electrons wonderful [buildroot documentation](http://buildroot.uclibc.org/docs.html).

When you're finished with your selections, exit by hitting the F9 key, which will automatically save your custom buildroot to...  

    /home/vagrant/CHIP-buildroot/.config
   
NOTE: You can save an alternate build by hitting the F6 key, but only the image save to the above path will flash to C.H.I.P.

Now let's build your buildroot...

    make

This will take a while.  Depending on your computer, maybe an hour.  Maybe grab some coffee...


### Flash your own buildroot image

Logged in to the virtual machine again starting from our *trusty* prompt:

    vagrant@vagrant-ubuntu-trusty-32:~$

type... 

    cd ~/CHIP-tools
    BUILDROOT_OUTPUT_DIR=../CHIP-buildroot/output ./chip-fel-flash.sh

CHIP will boot automatically after flashing.  Booting may take a minute.  If everything went well, you can now log in to your CHIP:

    cu -l /dev/ttyACM0 -s 115200

C.H.I.P.'s login is root. If everything went well you should be able to run a hardware test...

    hwtest

If everything passed, your C.H.I.P. is ready to go!  Have fun! 

## Shutdown

To log out of the virtual machine at anytime, type:

    exit
   
The virtual machine will still be running.  To shut it down, type:

    vagrant halt

## Troubleshooting'

In case you run into trouble because the kernel in the VM was updated and the shared vagrant folder can no longer be mounted, update the guest additions by typing the following in the CHIP-SDK directory on the host:

    vagrant plugin install vagrant-vbguest

Also look at [this blog post](http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/)

