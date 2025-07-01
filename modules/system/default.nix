{ config, lib, pkgs, ... }:
{
  imports = [
    # ./example.nix - add your modules here
  ];

  environment.systemPackages = with pkgs; [
    # Using 'with pkgs' to avoid repeating 'pkgs.'
    git
    vim
    htop
    fzf
    btop
    fish
    ghostty
  ];
}
