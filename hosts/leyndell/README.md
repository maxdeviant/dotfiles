# leyndell

`leyndell` is my Mac mini.

## Introduction

I use [Home Manager](https://github.com/nix-community/home-manager) to do most of the heavy lifting for my dotfiles.

## Installation

```sh
git clone git@github.com:maxdeviant/dotfiles.git
cd ~/dotfiles/hosts/leyndell
yes | ./install
home-manager switch
```

## Updating Zed settings

```sh
nickel export --format json common/config/zed/settings.ncl > hosts/leyndell/config/zed/settings.json
```

```sh
nickel export --format json common/config/zed/keymap.ncl > hosts/leyndell/config/zed/keymap.json
```
