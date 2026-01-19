# Forensic Arch Project – Documentation

## 1. Project Overview

This project aims to build a custom Arch Linux–based forensic operating system using ArchISO.
The project is divided into two repositories:

1. forensic-arch-iso  
   → Responsible for building the bootable ISO image.

2. forensic-arch  
   → Contains configuration files and package lists used for installing and configuring
     the system after boot or during installation.

Both repositories are interlinked and must be kept in sync for successful builds and deployments.

The ISO is currently in an early skeleton stage and contains experimental and unrefined scripts.

---

## 2. Why Two Repositories?

### forensic-arch-iso
Purpose:
- Build environment
- ArchISO profile
- Scripts to generate ISO
- Boot configuration

This repository decides:
- What goes into the live ISO
- How the live environment boots
- What scripts run during startup

### forensic-arch
Purpose:
- Package lists
- System configuration
- Tool installation
- Forensic environment setup

This repository decides:
- What tools are installed
- How the system is configured after install
- User environment and forensic workflow tools

The ISO repository may pull or reference files from the forensic-arch repository.

---

## 3. What is ArchISO?

ArchISO is the official tool used to create Arch Linux live ISOs.

Main components:
- Profile directory (configs)
- Package lists
- System hooks
- Bootloader configs

Build flow:
1. Read profile configuration
2. Install selected packages into rootfs
3. Apply custom configs
4. Generate bootable ISO

Reference:
https://deepwiki.com/archlinux/archiso

---

## 4. Repository Structure (forensic-arch-iso)

### /bin

Contains helper scripts related to:
- ISO building
- Automation
- Environment setup

Most files are shell scripts.
These scripts usually:
- Call archiso build commands
- Copy configuration files
- Prepare output directories

(Needs cleanup and documentation in future)

---

### /configs/forensic

This is the ArchISO profile directory.

Typical ArchISO profile contains:

- profiledef.sh
- packages.x86_64
- pacman.conf
- airootfs/ directory

This folder controls:
- What packages are included in the live ISO
- System configuration inside the live environment
- Startup services

---

### profiledef.sh (if present)

Defines:
- ISO name
- Label
- Boot modes (BIOS/UEFI)
- Compression
- Output paths

This file is mandatory for ArchISO profiles.

---

### packages.x86_64 (if present)

Plain text list of packages installed into live system.

Includes:
- Base Arch packages
- Desktop environment (if any)
- Forensic tools

Each line = one package.

---

### airootfs/

Files placed here are copied directly into the live filesystem.

Used for:
- Custom configs
- Startup scripts
- Systemd services
- User settings

Structure inside mirrors Linux root filesystem:
- /etc
- /usr
- /home
- etc.

---

## 5. Repository Structure (forensic-arch)

This repository contains:

- System configuration files
- Package group definitions
- Tool installation scripts

Used for:
- Post-install setup
- Maintaining forensic tool lists
- Consistent configuration across systems

It acts like a blueprint for installed systems,
while forensic-arch-iso builds the live environment.

---

## 6. Build Environment Requirements

Recommended setup:
- Arch Linux virtual machine
- Minimum 20GB disk space

Reason:
- Each ISO build consumes ~1.1–1.5GB
- Build directories store rootfs images
- Multiple build attempts accumulate data

Required tools:
- archiso package
- git
- base-devel

---

## 7. Development Workflow

Branch protection is enabled on main branch.
To start contributing follow the below step.

Steps:

1. Fork or create branch:
   ```bash
   git checkout -b <branchname>
  
and start developing
