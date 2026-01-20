# Forensic Arch - Building a Minimal,Modular DFIR Linux distribution

## High level Overview
The project is split into two repositories to separate concerns:

`forensic-arch-iso` - Builds a custom Arch Linux ISO

`forensic-arch` - Applies post-install configuration

## Steps to create the iso file
1. clone the `forensic-arch-iso` (in a arch env)

2.  `cd forensic-arch-iso` (You must be in the directory that contains profiledef.sh)

3. Change the github repo username in `configs/forensic/airootfs/root/customize_airootfs.sh`  
(this can be changed in the repo itself since its username is OPCI)

4. Create a build output directory `mkdir -p out`

5. Run mkarchiso 
    ```bash
    mkarchiso -w work -o out .
    ```
    or
    ```bash
    mkarchiso -w path/to/work_dir -o path/to/out_dir path/to/profile
    ```
6. This iso will then be present in out/

7. Use this iso file in a vm to test it out



## General File infomation


### `profiledef.sh`

Defines metadata for the ISO:
- ISO name
- Label
- Boot modes (BIOS / UEFI)
- Build configuration

### `packages.x86_64`

Lists packages that are available **inside the live ISO**.

### `customize_airootfs.sh`

This script runs **at ISO build time**, not during installation.

### `airootfs`

The airootfs directory defines the filesystem of the live ISO environment.

Anything placed inside airootfs/ becomes part of the temporary root filesystem when booting the ISO.