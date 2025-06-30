{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.thunderbird
    pkgs.chromium
    pkgs.obsidian
    pkgs.gh
    pkgs.protonmail-desktop
  ];
}
