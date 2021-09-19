{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mark";
  home.homeDirectory = "/home/mark";
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = ".config/rofi/nord.rasi";
  };
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set langmap=qh,wj,uk,ol
      
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      { plugin = rust-vim;
        config = "syntax enable
filetype plugin indent on";
      }
    ];
  };
  programs.git = {
    enable = true;
    userName = "Mark Wilkinson";
    userEmail = "mht197@protonmail.com";
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
