# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# oo

{ config, pkgs, ... }:

{
  #flakes perhaps
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  #Virtualization
  virtualisation.docker.enable = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.initrd.luks.devices."root" = {
      
      device = "/dev/sda3";
      preLVM = true;
 
   };
   environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
  
  #Trying to save battery
  services.tlp = {
      enable = true;
      extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=schedutil
      '';
  };
  
  #REEEEE /run/user/1000 fix
  services.logind.extraConfig = ''
    RuntimeDirectorySize=2G
  '';

  #Fonts
  fonts.fonts = with pkgs; [
    nerdfonts
  ];
  boot.initrd.availableKernelModules = [
        # trimmed irrelevant ones
        "thinkpad_acpi"
      ];
  services.upower.enable = true;

  services.xserver.extraLayouts.semimak = {
    description = "The semimak typing layout";
    languages   = [ "eng" ];
    symbolsFile = /home/mark/Documents/semimak;
  };


  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
   boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  #Virtualization
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  
  networking.hostName = "t430"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.userControlled.enable = true;


  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };    

  # Configure keymap in X11
  services.xserver.layout = "semimak";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #doas setup
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ "mark" ];
    keepEnv = true;
  }];
  security.doas.extraConfig = ''
    permit persist keepenv :wheel
  '';
  # Enable sound.
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     neovim rustup
     taskwarrior
     i2p libreoffice

     micro # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gitFull python39Full
    python39Packages.python-lsp-server
    wget alacritty
    light atom
    rust-analyzer
    joplin-desktop
    signal-desktop
    alsa-utils
    chromium
    tor-browser-bundle-bin
    keepassxc

    #Cybersecurity
    #metasploit
    #nmap aircrack-ng
    #john hashcat
    #thc-hydra
    #zap wireshark
    #I should use a nix shell for this
    #I did the nix shell thing, infosec.nix

    #Sys management
    s-tui stress
    openssl bintools-unwrapped
    pkg-config
    wpa_supplicant_gui
    pavucontrol gcc
    libsForQt5.kdeconnect-kde

    #Funny show-offs
    cmatrix neofetch
    pfetch cowsay
    bottom
    bsdgames


   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
   #networking.firewall.allowedTCPPorts = [ ... ];
   #networking.firewall.allowedUDPPorts = [ ... ];
   networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } { from = 4000; to = 5000; }];
   networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  #Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
