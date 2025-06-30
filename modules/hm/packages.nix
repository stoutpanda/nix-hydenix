{ config, lib, pkgs, ... }:
let
  # Create an alias for clarity
  myPkgs = pkgs.userPkgs;
in
{
  home.packages = with myPkgs; [
    thunderbird
    chromium
    obsidian
    gh
    protonmail-desktop
  ];
}
