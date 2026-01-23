# General File infomation

### customize_airootfs.sh 
 This file is depricated and does not contain documentation anywhere
 - the only mention of this is in forums and in reddit
 - so based on what I understood from the src code this is a build script hook
 - it just runs this file when it is present
  
 What this file contains (I might be wrong)
 - so first we are creating a forensics profile
 - any profile that is created before arch install is only for the installation process
 - that explains why I was not able to find this user after the installation
 - we are also overriding getty to autologin 
 - getty is the first thing that starts so normally,it starts, we login as root and then type archinstall or do manual installation
 - but since this is getting overrided it auto logins to forensics user and opens bash
 - since bash runs .bash_profile 
 - where arch install gets executed
 

### profiledef.sh

Defines metadata for the ISO:
- ISO name
- Label
- Boot modes (BIOS / UEFI)
- Build configuration
- conatins the file permissions also

### packages.x86_64

Lists packages that are available **inside the live ISO**.
These packages will not be installed in the iso but will be present during installation

These are for arch packages available through pacman

### pacman.conf

Any custom definied arch packages that needs to be included are defined here

### airootfs

The airootfs directory defines the filesystem of the live ISO environment.
Anything placed inside airootfs/ becomes part of the temporary root filesystem when booting the ISO.
