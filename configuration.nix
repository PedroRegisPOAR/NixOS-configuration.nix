# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;

  environment.systemPackages = with pkgs; [

    # shell stuff
    fzf
    neovim
    oh-my-zsh
    zsh
    zsh-autosuggestions
    zsh-completions
    bottom # the binary is btm 

    # Some utils
    # binutils
    coreutils
    # dnsutils
    # file
    # findutils
    # inetutils # TODO: it was causing a conflict, insvestigate it!
    # nixpkgs-fmt
    # ripgrep
    # strace
    # util-linux
    # unzip
    # tree

    # gzip
    # unrar
    # unzip

    # curl
    # wget

    # graphviz # dot command comes from here
    # jq
    # unixtools.xxd

    # Caching compilers
    # gcc
    # gcc6

    # anydesk
    # discord
    firefox
    # freeoffice     
    gitkraken
    # klavaro
    # spectacle # to printscreen
    # spotify
    # tdesktop
    # vlc
    # xorg.xkill

    # amazon-ecs-cli
    # awscli
    # docker
    # docker-compose
    git
    # gnumake
    # gnupg
    # gparted

    # youtube-dl
    htop
    jetbrains.pycharm-community
    # keepassxc
    # okular
    # libreoffice
    # python38Full
    # peek
    # insomnia
    # terraform     

    #nodejs
    #qgis
    #rubber
    #tectonic
    #haskellPackages.pandoc
    #vscode-with-extensions
    #wxmaxima
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # https://github.com/NixOS/nixpkgs/blob/release-20.03/nixos/modules/hardware/all-firmware.nix
  hardware.enableRedistributableFirmware = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # https://github.com/NixOS/nixpkgs/pull/44896
  # services.xserver.desktopManager = {
  #  xfce.enable = true;
  #  default = "xfce";
  #};

  services.xserver.displayManager.defaultSession = "xfce";

  # services.xserver.desktopManager.gnome3.enable = true;

  # https://t.me/nixosbrasil/26612
  services.smartd.enable = true;

  # Supposedly better for the SSD.
  # https://discourse.nixos.org/t/update-build-config-error/5889/7
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pedro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "pedro" "kvm" ]; # Enable ‘sudo’ for the user.
  };

  users.extraUsers.pedro = {
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  # virtualisation.docker.enable = true;

  # virtualisation.podman = {
  #  enable = true;
  #  # Create a `docker` alias for podman, to use it as a drop-in replacement
  #  #dockerCompat = true;
  # };

  # environment.etc."containers/registries.conf" = {
  #  mode = "0644";
  #  text = ''
  #    [registries.search]
  #    registries = ['docker.io', 'localhost']
  #  '';
  # };

  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # programs.gnupg.agent.enable = true;

  # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119 
  # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
  # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      export ZSH_THEME="agnoster"
      export ZSH_CUSTOM=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
      plugins=( 
                colored-man-pages
                docker
                git
                #zsh-autosuggestions # Why this causes an warn?
                #zsh-syntax-highlighting
              )
      source $ZSH/oh-my-zsh.sh
    '';
    ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    promptInit = "";
  };

  # TODO: study about this
  # https://github.com/thiagokokada/dotfiles/blob/a221bf1186fd96adcb537a76a57d8c6a19592d0f/_nixos/etc/nixos/misc-configuration.nix#L124-L128
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Probably solve many warns about fonts
  # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      fira # Monospace
      inconsolata # Monospace
      powerline-fonts
      ubuntu_font_family
      unifont # International languages
    ];
  };

  # https://discourse.nixos.org/t/cpu-governor-powersave-no-effect/7973/3
  # powerManagement = {
  #  enable = true;
  #  powertop.enable = false;
  # };
  #
  # https://github.com/NixOS/nixpkgs/issues/19757#issuecomment-255536338
  # https://github.com/NixOS/nixpkgs/issues/19757#issuecomment-255537336
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

}

