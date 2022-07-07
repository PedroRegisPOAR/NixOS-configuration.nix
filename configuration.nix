# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";


  # https://nix.dev/tutorials/building-bootable-iso-image
  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  # https://www.reddit.com/r/NixOS/comments/ni79b8/list_of_all_nixos_supported_file_systems/
  #
  # For allow mount HDD
  # https://www.reddit.com/r/NixOS/comments/f2e9cb/unable_to_mount_external_drives_properly_in_nixos/
  boot.supportedFilesystems = [ 
    # "btrfs"
    # "cifs"
    # "exfat"
    # "ext2"
    # "ext3"
    # "ext4"
    # "f2fs"
    # "fat16"
    # "fat32"
    # "fat8"
    # "ntfs"
    # "reiserfs"
    # "vfat"
    # "xfs"
    # "zfs"
   "ntfs3g"
   "exfat-utils"
 ];
  # boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];  

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Recife";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.utf8";
    LC_IDENTIFICATION = "pt_BR.utf8";
    LC_MEASUREMENT = "pt_BR.utf8";
    LC_MONETARY = "pt_BR.utf8";
    LC_NAME = "pt_BR.utf8";
    LC_NUMERIC = "pt_BR.utf8";
    LC_PAPER = "pt_BR.utf8";
    LC_TELEPHONE = "pt_BR.utf8";
    LC_TIME = "pt_BR.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pedro = {
    isNormalUser = true;
    description = "Pedro Regis";
    extraGroups = [ "networkmanager" "audio" "libvirtd" "wheel" "pedro" "docker" "kvm" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };


  # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119 
  # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
  # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      shebang = "echo '#!/usr/bin/env bash'"; # https://stackoverflow.com/questions/10376206/what-is-the-preferred-bash-shebang#comment72209991_10383546
      nfmt = "nix run nixpkgs#nixpkgs-fmt **/*.nix *.nix";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
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
      # git config --global user.email "pedroalencarregis@hotmail.com" 2> /dev/null
      # git config --global user.name "Pedro Regis" 2> /dev/null
      source $ZSH/oh-my-zsh.sh

      # https://stackoverflow.com/questions/41017917/add-newline-to-oh-my-zsh-theme/59095798#59095798
      # https://www.reddit.com/r/NixOS/comments/qvn0jk/comment/hly69o4/?utm_source=reddit&utm_medium=web2x&context=3
      # export NEWLINE =$'\n'
      # export PROMPT='%n ''${NEWLINE} $ '

      # https://stackoverflow.com/a/44301984
      # autoload -Uz promptinit
      # promptinit
      # 
      # PROMPT="
      # %n@%m:%~ $ "

    '';

    ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    promptInit = "";
  };

  # TODO: study about this
  # https://github.com/thiagokokada/dotfiles/blob/a221bf1186fd96adcb537a76a57d8c6a19592d0f/_nixos/etc/nixos/misc-configuration.nix#L124-L128
  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  # };

  # Probably solve many warns about fonts
  # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts		  # Microsoft free fonts
      fira	      	  # Monospace
      inconsolata     	  # Monospace
      powerline-fonts
      ubuntu_font_family
      unifont		  # International languages
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  #
  nix = {
     package = pkgs.nixFlakes;
     extraOptions = ''
       experimental-features = nix-command flakes 
   '';

    # From:
    # https://github.com/sherubthakur/dotfiles/blob/be96fe7c74df706a8b1b925ca4e7748cab703697/system/configuration.nix#L44
    # pointing to: https://github.com/NixOS/nixpkgs/issues/124215
    settings.extra-sandbox-paths= [ "/bin/sh=${pkgs.bash}/bin/sh"];
    
    # https://github.com/NixOS/nixpkgs/blob/fd8a7fd07da0f3fc0e27575891f45c2f88e5dd44/nixos/modules/services/misc/nix-daemon.nix#L323
    # Be carefull if using it as false!
    # Ohh crap, around 20/06/2022 I ran something like sudo rm -fr $TMPDIR/* and I destroyed 
    # my system completely because this flag was forced to be false!  
    readOnlyStore = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     # shell stuff
     direnv
     nix-direnv
     fzf
     neovim
     oh-my-zsh
     zsh
     zsh-autosuggestions
     zsh-completions
     bottom  # the binary is btm 
     
     # Some utils
     binutils
     coreutils
     dnsutils
     file
     findutils
     inetutils # TODO: it was causing a conflict, insvestigate it!
     nixpkgs-fmt
     ripgrep
     strace
     util-linux
     unzip
     tree

     gzip
     unrar
     unzip
     
     curl    
     wget
    
     graphviz # dot command comes from here
     jq
     unixtools.xxd
    
     # Caching compilers
     gcc
     # gcc6
     
     # anydesk
     # discord
     firefox
     # freeoffice     
     gitkraken
     klavaro
     spectacle
     # spotify
     # tdesktop
     vlc
     xorg.xkill
     
     # amazon-ecs-cli
     # awscli
     docker
     docker-compose
     git
     gnumake
     gnupg
     gparted
     
     youtube-dl
     htop
     jetbrains.pycharm-community
     keepassxc
     okular
     libreoffice
     # freeoffice
     obsidian
     # python38Full
     peek
     insomnia
     # terraform     

     #nodejs
     #qgis
     #rubber
     #tectonic
     #haskellPackages.pandoc
     #vscode-with-extensions
     #wxmaxima

     libvirt
     virtmanager
     qemu

     pciutils # lspci and others
     coreboot-utils # acpidump-all

     # hello
     # figlet
     # cowsay

     # TODO:
	#nix \
	#store \
	#ls \
	#--store https://cache.nixos.org/ \
	#--long \
	#--recursive \
	#"$(nix eval --raw nixpkgs#gtk3.dev)"

     # Helper script to print the IOMMU groups of PCI devices.
     (
       writeScriptBin "list-iommu-groups" ''
         #! ${pkgs.runtimeShell} -e
         shopt -s nullglob
         for g in /sys/kernel/iommu_groups/*; do
           echo "IOMMU Group ''${g##*/}:"
           for d in $g/devices/*; do
             echo -e "\t$(lspci -nns ''${d##*/})"
           done;
         done;
       ''
     )
  

     # Helper script: to free space.
     (
       writeScriptBin "free-space" ''
         #! ${pkgs.runtimeShell} -e
         
         # Really useful to find folders with huge size
         # du -cksh /* 2> /dev/null | sort -rh
         # du -cksh "$HOME"/* 2> /dev/null | sort -rh
         # find ~ \( -name '*.iso' -o -name '*.qcow2*' -o -name '*.img' -o -name 'result' \) -exec echo -n -- {} + | tr ' ' '\n'
         # du -hs "$HOME"/.cache "$HOME"/.local
         
         # find ~ \( -iname '*.iso' -o -iname '*.qcow2*' -o -iname '*.img' -o -iname 'result' \) -exec echo -n -- {} + 2> /dev/null | tr ' ' '\n'
         #
         # sudo rm -fr "$HOME"/.cache "$HOME"/.local
         #
         # nix store gc --verbose \
         # --option keep-derivations false \
         # --option keep-outputs false
         #
         # nix-collect-garbage --delete-old
         if command -v docker &> /dev/null
         then
           docker ps --all --quiet | xargs --no-run-if-empty docker stop \
           && docker ps --all --quiet | xargs --no-run-if-empty docker rm \
           && docker images --quiet | xargs --no-run-if-empty docker rmi --force \
           && docker container prune --force \
           && docker image prune --force \
           && docker network prune --force
         fi                 
         if command -v podman &> /dev/null
         then
           podman pod prune --force
    
           podman ps --all --quiet | xargs --no-run-if-empty podman rm --force \
           && podman images --quiet | xargs --no-run-if-empty podman rmi --force \
           && podman container prune --force \
           && podman images --quiet | podman image prune --force \
           && podman network ls --quiet | xargs --no-run-if-empty podman network rm \
           && podman pod list --quiet | xargs --no-run-if-empty podman pod rm --force
         fi
         nix profile remove '.*'
         
         find ~ \( -iname '*.iso' -o -iname '*.qcow2*' -o -iname '*.img' -o -iname 'result' \) -exec rm -frv -- {} + 2> /dev/null | tr ' ' '\n'
         
         sudo rm -fr "$HOME"/.cache "$HOME"/.local/share/containers
         
         nix store gc --verbose \
              --option keep-derivations false \
              --option keep-outputs false \
         && nix-collect-garbage --delete-old
        du -hs "$TMPDIR"
        sudo rm -frv "$TMPDIR"
        ''
     )

     # Helper script
     (
       writeScriptBin "crw" ''
         #! ${pkgs.runtimeShell} -e
         
	 cat "$(readlink -f "$(which $1)")"
       ''
     )

     (
       writeScriptBin "erw" ''
         #! ${pkgs.runtimeShell} -e
         echo "$(readlink -f "$(which $1)")"
       ''
     )

     # to kill processes that are using an file.
     # 
     # https://stackoverflow.com/a/24554952
     # https://www.baeldung.com/linux/find-process-file-is-busy
     # 
     # kill -TERM $(lsof -t filename)
     
     (
       writeScriptBin "mansf" ''
         #! ${pkgs.runtimeShell} -e
         # https://unix.stackexchange.com/a/302792
         # msf, stand for: Man Search Flag
         function mansf () { man $1 | less -p "^ +$2" }
         # Call the function
         mansf $1 $2
       ''
     )
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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
