<div align=center>

# dotnix

ARCHIVED BECAUSE I DON'T USE NIXOS ANYMORE

[![NixOS](https://img.shields.io/badge/NixOS-22.05-informational.svg?logo=nixos)](https://github.com/nixos/nixpkgs) [![AwesomeWM](https://img.shields.io/badge/AwesomeWM-git-blue.svg?logo=lua)](https://github.com/awesomeWM/awesome)

</div>

<a href="https://awesomewm.org/"><img alt="AwesomeWM Logo" height="160" align = "left" src="https://upload.wikimedia.org/wikipedia/commons/0/07/Awesome_logo.svg"></a>

Welcome to my system configuration files! Ironically, nothing here is actually under my `$HOME` directory. My system is managed by Nix, which I have no idea how to use. My AwesomeWM and Neovim configuration files are still written in lua, as the number of edits, features, and customizations I have done on them are too massive for me to convert those configs to Nix. The only configuration left to convert to Nix is **wezterm**.

**Note**: Please don't use this as a template NixOS setup - I have been using NixOS for a year and I still don't know what I'm doing.

<br />

<div>

<img src="https://github.com/JavaCafe01/dotfiles/blob/master/.github/assets/main.png" alt="img" align="right" width="450px">

| Type  | Used |
| :---:  | :---:  |
| OS  | [NixOS](https://nixos.org/)  |
| Window Manager  | [AwesomeWM](https://github.com/awesomeWM/awesome)  |
| Terminal | [Wezterm](https://github.com/wez/wezterm) |
| Editor | [Neovim](https://neovim.io/) |
| File Manager | Nautilus |
| Shell | Zsh |
  
</div>

<br />

## Setup for NixOS
1. Get the latest [NixOS ISO](https://nixos.org/download.html) and boot into the installer/environment.
2. Format and mount your disks.
3. Follow these commands (you might need root privileges):

```bash
# Get into a Nix shell with Nix unstable and git
nix-shell -p git nixUnstable

# Clone my dotfiles (it has submodules)
git clone https://github.com/JavaCafe01/dotfiles /mnt/etc/nixos --recurse-submodules

# Remove this file
rm /mnt/etc/nixos/hosts/thonkpad/hardware-configuration.nix

# Generate a config and copy the hardware configuration, disregarding the generated configuration.nix
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/thonkpad/
rm /mnt/etc/nixos/configuration.nix

# Make sure you're in the configuration directory
cd /mnt/etc/nixos

# Install this NixOS configuration with flakes
nixos-install --flake '.#thonkpad'
```
4. Reboot, login as root, and change the password for your user using `passwd`.
5. Log in as your normal user.
6. Follow these commands:

```bash
# change ownership of configuration folder
sudo chown -R $USER /etc/nixos

# go into the configuration folder
cd /etc/nixos

# Install the home manager configuration
home-manager switch --flake '.#javacafe01'
```

## Setup for NixOS-WSL
*coming soon*


## AwesomeWM Modules
### [bling](https://github.com/BlingCorp/bling)
- Adds new layouts, modules, and widgets that try to primarily focus on window management
### [layout-machi](https://github.com/xinhaoyuan/layout-machi)
- Manual layout for Awesome with an interactive editor
### [UPower Battery Widget](https://github.com/Aire-One/awesome-battery_widget)
- A widget accessing **UPower** for battery info with LGI
### [rubato](https://github.com/andOrlando/rubato)
- Creates smooth animations with a slope curve for awesomeWM (Awestore, but not really)
### Better Resize
- An improved method of resizing clients in the tiled layout
### Save Floats
- Saves positions of clients in the floating layout

## More Screenshots

<details>
<summary>Lockscreen</summary>
<br>
<div align=center>
<img src="https://github.com/JavaCafe01/dotfiles/blob/master/.github/assets/lockscreen.png" alt="img" align="center" width="800px">
</div>
</details>

<details>
<summary>Neovim</summary>
<br>
<div align=center>
<img src="https://github.com/JavaCafe01/dotfiles/blob/master/.github/assets/vim.png" alt="img" align="center" width="600px">
</div>
</details>

## Credits
* [fortuneteller2k/nix-config](https://github.com/fortuneteller2k/nix-config)
* [elenapan/dotfiles](https://github.com/elenapan/dotfiles)
