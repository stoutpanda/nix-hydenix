# Hydenix Structure and Package Management Guide

## Overview
Hydenix is a NixOS configuration framework that implements HyDE (a Hyprland dotfiles configuration) using Nix. It provides its own module system (`hydenix` and `hydenix.hm` options) that wraps around standard NixOS and home-manager configurations.

## Template Structure
```
your-flake-directory/
├── flake.nix                    # Main entry point
├── flake.lock                   # Lock file for reproducibility
├── configuration.nix            # System configuration
├── hardware-configuration.nix   # Hardware-specific config
└── modules/
    ├── system/                  # System-wide configurations
    │   └── default.nix         # System modules entry point
    └── hm/                     # Home-manager configurations
        └── default.nix         # User-specific configs
```

## Where to Add Packages

### 1. **System-wide Packages** (available to all users)
Location: `configuration.nix` or `modules/system/default.nix`

```nix
# In configuration.nix
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    firefox
  ];
}
```

### 2. **User-specific Packages** (via home-manager)
Location: `modules/hm/default.nix`

```nix
# In modules/hm/default.nix
{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    spotify
    vscode
  ];
}
```

### 3. **Modular System Packages**
For better organization, create separate modules:

```nix
# modules/system/packages.nix
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Development tools
    gcc
    nodejs
    python3
    
    # System utilities
    btop
    ncdu
    tree
  ];
}
```

Then import in `modules/system/default.nix`:
```nix
{ ... }:
{
  imports = [
    ./packages.nix
  ];
}
```

## Package Sources in Hydenix

Hydenix provides two package sets:
- `pkgs` - Hydenix's curated package set (stable, tested versions)
- `pkgs.userPkgs` - Your personal nixpkgs (from your flake input)

Example usage:
```nix
environment.systemPackages = [
  pkgs.firefox              # From Hydenix's package set
  pkgs.userPkgs.discord    # From your nixpkgs
];
```

## Best Practices

1. **Start Simple**: Add packages directly to `configuration.nix` or `modules/hm/default.nix`

2. **Modularize as You Grow**: Split into separate files when configuration gets large:
   - `modules/system/packages.nix` - System packages
   - `modules/system/services.nix` - System services
   - `modules/system/networking.nix` - Network configuration

3. **Use Module Pattern**: 
   ```nix
   { config, lib, pkgs, ... }:  # Always include ... for compatibility
   {
     # Your configuration
   }
   ```

4. **Keep Hydenix Separate**: Don't modify Hydenix's internal packages - add your own alongside them

## Quick Reference

| Package Type | Location | Example |
|--------------|----------|---------|
| System-wide | `configuration.nix` | `environment.systemPackages = [ pkgs.vim ];` |
| User-specific | `modules/hm/default.nix` | `home.packages = [ pkgs.firefox ];` |
| Modular system | `modules/system/*.nix` | Create topic-specific modules |
| From other flakes | Any module | `inputs.some-flake.packages.${system}.package-name` |
| Custom/overlay | Overlay in flake | Define custom packages or modifications |

## Adding Packages from Other Sources

### From unstable nixpkgs:
```nix
# If configured with overlay
environment.systemPackages = [
  pkgs.unstable.some-new-package
];
```

### From other flakes:
```nix
# In flake.nix inputs
inputs.another-flake.url = "github:owner/repo";

# In module
environment.systemPackages = [
  inputs.another-flake.packages.${pkgs.system}.package-name
];
```

### Custom packages:
```nix
environment.systemPackages = [
  (pkgs.writeScriptBin "my-script" ''
    #!/usr/bin/env bash
    echo "Hello!"
  '')
];
```

## Remember
- Hydenix is just a NixOS configuration framework
- Standard NixOS patterns apply
- The `...` in function parameters is important for module compatibility
- Always `git add` files before rebuilding (flakes only see tracked files)
- Run `sudo nixos-rebuild switch --flake .` to apply changes
