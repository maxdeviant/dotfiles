# dotfiles

> ~ sweet ~

Welcome to my [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) repository!

## Structure

Here is a breakdown of the structure of the repository:

- [`hosts`](./hosts) contains the dotfiles for my different hosts
  - [`firelink`](./hosts/firelink) is my tower running NixOS
  - [`ringed-city`](./hosts/ringed-city) is my work MacBook running macOS (with Nix)
- [`nixos`](./nixos) contains my NixOS configuration
  - This is currently based on `firelink` but will eventually be made system-agnostic

## Installation

This guide will walk through how to install NixOS using the [configuration](./nixos/configuration.nix) provided in this repo. It is more or less a streamlined version of the "Installation" portion of the [NixOS Manual](https://nixos.org/nixos/manual/index.html), so you may want to consult that if you have questions.

Note that a lot of this guide is fairly opinionated, so you'll most likely want to tailor it to your own needs.

### Obtaining the installation medium

The first thing you'll need is a NixOS installation medium. For that, you'll need to [download](https://nixos.org/nixos/download.html) the NixOS ISO and create an installation medium, like a bootable USB.

Obtaining the installation medium is outside the scope of this guide, so the rest of the guide will assume you have one.

### Installing NixOS

Once booted into the NixOS installation medium you'll be greeted with a shell prompt.

From here you can download the installation script with `curl`:

```
$ curl -o install.sh https://raw.githubusercontent.com/maxdeviant/dotfiles/master/nixos/install.sh
$ chmod +x install.sh
```

In order to perform the install you need to be running as `root`, so you'll need to drop into a root shell:

```
$ sudo su
```

The installation script takes a single argument: the block device on which to install NixOS. You can use `lsblk` to see which devices are available.

Once you have identified the block device you want to install NixOS on (e.g., `/dev/sda` or `/dev/nvme0n1`), pass it as the first argument to the installation script:

```
# ./install.sh /dev/sda
```

> If you want to see what `install.sh` will do before running it you can pass the `--dry-run` flag.

The installation script may prompt you for input a few times. Navigate the prompts until the script finishes successfully. At the end of the install you'll be prompted to set the password for the `root` user.

Once the script has completed successfully and the `root` password has been set you should be all set to restart the computer and boot into NixOS:

```
# reboot
```

### Installing Home Manager

Installing NixOS is only half the story. In order to get the system completely up and running we also need to install [Home Manager](https://github.com/rycee/home-manager) to configure our user environment.

I'm still in the process of documenting/automating this phase of the setup.
