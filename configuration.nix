
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # "${config.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  
  # https://nixos.wiki/wiki/Libvirt
  # https://discourse.nixos.org/t/set-up-vagrant-with-libvirt-qemu-kvm-on-nixos/14653
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  # The default is false
  boot.cleanTmpDir = false;
  # TODO
  boot.tmpOnTmpfs = false;
  # https://github.com/AtilaSaraiva/nix-dotfiles/blob/main/lib/modules/configHost/default.nix#L271-L273
  # boot.tmpOnTmpfsSize = "95%";
  # 
  # https://github.com/NixOS/nixpkgs/issues/23912#issuecomment-1079692626
  # services.logind.extraConfig = ''
  #   RuntimeDirectorySize=8G
  #  RuntimeDirectoryInodesMax=1048576  
  # '';

  #
  # https://www.reddit.com/r/NixOS/comments/wcxved/i_gave_an_adhoc_lightning_talk_at_mch2022/
  # Matthew Croughan - Use flake.nix, not Dockerfile - MCH2022
  # https://www.youtube.com/embed/0uixRE8xlbY?start=707&end=827&version=3
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs.dconf.enable = true;
  # environment.systemPackages = with pkgs; [ virt-manager ];  

  # TODO: study about this
  # https://github.com/thiagokokada/dotfiles/blob/a221bf1186fd96adcb537a76a57d8c6a19592d0f/_nixos/etc/nixos/misc-configuration.nix#L124-L128
  # 
  # 
  # zramctl
  # swapon -s
  # free -m
  # https://discourse.nixos.org/t/zramswap-enable-true-does-nothing/6734/3
  # https://unix.stackexchange.com/questions/606868/high-ram-and-swap-usage-out-of-seemingly-nowhere#comment1132721_606868
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 10;
  };

  # Is it a must for k8s?
  # Take a look into:
  # https://github.com/NixOS/nixpkgs/blob/9559834db0df7bb274062121cf5696b46e31bc8c/nixos/modules/services/cluster/kubernetes/kubelet.nix#L255-L259
  boot.kernel.sysctl = {
    # If it is enabled it conflicts with what kubelet is doing
    # "net.bridge.bridge-nf-call-ip6tables" = 1;
    # "net.bridge.bridge-nf-call-iptables" = 1;
    "vm.swappiness" = 0;
  };

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
  # The installer was broken!
  # https://github.com/NixOS/nixpkgs/issues/182631#issuecomment-1193307060
  # i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
  #  LC_ADDRESS = "pt_BR.utf8";
  #  LC_IDENTIFICATION = "pt_BR.utf8";
  #  LC_MEASUREMENT = "pt_BR.utf8";
    LC_MONETARY = "pt_BR.UTF-8";
  #  LC_NAME = "pt_BR.utf8";
  #  LC_NUMERIC = "pt_BR.utf8";
  #  LC_PAPER = "pt_BR.utf8";
  #  LC_TELEPHONE = "pt_BR.utf8";
  #  LC_TIME = "pt_BR.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.displayManager.sddm.autoNumlock = true;

  # https://github.com/NixOS/nixpkgs/issues/79707#issuecomment-586696145
  # services.xserver.startDbusSession = false;
  # services.dbus.socketActivated = true;

  # Configure keymap in X11
  #
  # It solved my problem:
  # https://www.vivaolinux.com.br/topico/Debian/Configuracao-de-teclado-abnt2
  #
  # To check the configuration built:
  # cat /etc/X11/xorg.conf.d/00-keyboard.conf
  # 
  # https://nixos.wiki/wiki/Keyboard_Layout_Customization
  # 
  # nix repl --expr 'import <nixpkgs> {}'
  # nixosConfigurations.pedroregispoar.config.services.xserver.xkbVariant
  services.xserver = {
    layout = "br";
    xkbVariant = "abnt2";
  };


  virtualisation.podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    #dockerCompat = true;
  };


  virtualisation = {
    libvirtd = {
      enable = true;
      # Used for UEFI boot
      # https://myme.no/posts/2021-11-25-nixos-home-assistant.html
      qemu.ovmf.enable = true;
    };
  };

  environment.variables = {
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
  };

  # Configure console keymap
  # console.keyMap = "br-abnt2";

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
  # https://search.nixos.org/options?channel=22.05&show=users.users.%3Cname%3E.uid&from=0&size=50&sort=relevance&type=packages&query=users.
  users.users.pedro = {
    createHome = true;
    isNormalUser = true;
    description = "Pedro Regis";
    extraGroups = [
      "networkmanager"
      "audio"
      "libvirtd"
      "wheel"
      "pedro"
      "docker"
      "kvm"
      "qemu-libvirtd"
      "video"
      "disk"
    ];
    packages = with pkgs; [
      firefox
      kate
      vagrant
    #  thunderbird
    ];
    shell = pkgs.zsh;
    # uid = 12321;    
  };

  # users.groups = {   
  #  users = {
  #    gid = pkgs.lib.mkForce 32123;
  #  };
  # };

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
  # https://discourse.nixos.org/t/imagemagicks-convert-command-fails-due-to-fontconfig-error/20518/5
  # https://github.com/NixOS/nixpkgs/issues/176081#issuecomment-1145825623
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # corefonts		  # Microsoft free fonts
      # fira	      	  # Monospace
      # inconsolata     	  # Monospace
      # powerline-fonts
      # ubuntu_font_family
      # unifont		  # International languages

      # arphic-ukai
      # arphic-uming
      ## corefonts # Microsoft free fonts
      # dina-font
      # hack-font
      # dejavu_fonts
      # font-awesome
      # freefont_ttf
      # noto-fonts-emoji
      # noto-fonts-extra
      ## nerdfonts # Really big and now broken
      ## powerline-fonts
      # sudo-font
      # source-sans-pro
      # source-han-sans-japanese
      # source-han-sans-korean
      # source-han-sans-simplified-chinese
      # source-han-sans-traditional-chinese
      # source-sans-pro
      ## symbola # TODO: Was broken
      # ubuntu_font_family
      # xkcd-font
      # wqy_microhei
      # wqy_zenhei
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
    
    # 
    # "relaxed"
    settings.sandbox = true;
    # From:
    # https://github.com/sherubthakur/dotfiles/blob/be96fe7c74df706a8b1b925ca4e7748cab703697/system/configuration.nix#L44
    # pointing to: https://github.com/NixOS/nixpkgs/issues/124215
    # settings.extra-sandbox-paths= [ "/bin/sh=${pkgs.bash}/bin/sh"];
    
    # https://github.com/NixOS/nixpkgs/blob/fd8a7fd07da0f3fc0e27575891f45c2f88e5dd44/nixos/modules/services/misc/nix-daemon.nix#L323
    # Be carefull if using it as false!
    # Ohh crap, in 30/06/2022 I ran something like sudo rm -fr $TMPDIR/* and I destroyed 
    # my system completely because this flag was forced by my self to be false!  
    readOnlyStore = true;

    # nixPath
    # https://github.com/thiagokokada/nix-configs/blob/639501c3acad5971f3abdaffedf9366196e55432/shared/nix.nix#L10-L22
    # https://github.com/NixOS/nix/blob/26c7602c390f8c511f326785b570918b2f468892/tests/setuid.nix#L17
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
     # bottom  # the binary is btm 
     bpytop
    
     # Some utils
     binutils
     coreutils
     dnsutils
     file
     findutils
     lsof
     # inetutils # TODO: it was causing a conflict, insvestigate it!
     nixpkgs-fmt
     ripgrep
     strace
     # util-linux
     # unzip
     tree
     nix-index

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
     # google-chrome
     # chromium
     # freeoffice     
     gitkraken
     klavaro
     spectacle
     # discord
     # spotify
     # tdesktop
     vlc
     xorg.xkill
     # discord
     # spotify 
     # tdesktop
     
     # amazon-ecs-cli
     # awscli
     # docker
     # docker-compose
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

     # libvirt
     # virtmanager
     # qemu
     virt-manager

     pciutils # lspci and others
     coreboot-utils # acpidump-all

     # hello
     # figlet
     # cowsay

     (
       writeScriptBin "nslsr" ''
         #! ${pkgs.runtimeShell} -e
         nix \
         store \
         ls \
         --store https://cache.nixos.org/ \
         --long \
         --recursive \
        "$(nix eval --raw nixpkgs#$1)"
       ''
     )


     (
       writeScriptBin "dag" ''
 
         nix build nixpkgs#$1 --no-link
         nix-store --query --graph --include-outputs \
         "$(nix path-info nixpkgs#$1)" \
         | dot -Tps > $1.ps
       ''
     )

     (
       writeScriptBin "ix" ''
          "$@" | curl -F 'f:1=<-' ix.io
       ''
     )

     (
       writeScriptBin "grh" ''
         #! ${pkgs.runtimeShell} -e
         git reset --hard
       ''
     )

     (
       writeScriptBin "chownme" ''
         #! ${pkgs.runtimeShell} -e
         chown "$(id -u)"':'"$(id -g)" "$@"         
       ''
     )


     (
       writeScriptBin "schownme" ''
         #! ${pkgs.runtimeShell} -e
         sudo -k chown "$(id -u)"':'"$(id -g)" "$@"         
       ''
     )

     (
       writeScriptBin "nfmn" ''
         #! ${pkgs.runtimeShell} -e
         nix flake metadata nixpkgs --json | jq -r '.url'
       ''
     )

     (
       writeScriptBin "nfm" ''
         #! ${pkgs.runtimeShell} -e
         nix flake metadata $1 --json | jq -r '.url'
       ''
     )


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
     
     # sed
     # 
     # sed -i 's/[[:blank:]]*$//' run.sh
     # 
     #  
 
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
         
         # TODO:         
         # sudo rm -fr "$HOME"/.cache 
         sudo rm -fr "$HOME"/.local/share/containers
         sudo rm -frv /var/{tmp,lib,log}/*
         
         nix profile remove '.*'
         
         nix \
         store \
         gc \
         --verbose \
         --option keep-derivations false \
         --option keep-outputs false \
         && nix-collect-garbage --delete-old
         
         # TODO: what is removed when using sudo?
         sudo \
         su \
         -c \
         '
         nix \
         store \
         gc \
         --verbose \
         --option keep-derivations false \
         --option keep-outputs false \
         && nix-collect-garbage --delete-old \
         && nix store optimise --verbose
         '

        test -z "$TMPDIR" || du -hs "$TMPDIR"
        # Too agressive?
        # sudo rm -frv "$TMPDIR"
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

     (
       writeScriptBin "snrt" ''
         #! ${pkgs.runtimeShell} -e
         sudo nixos-rebuild test --flake '/etc/nixos#pedroregispoar'
       ''
     )

     (
       writeScriptBin "snrs" ''
         #! ${pkgs.runtimeShell} -e
         # sudo nixos-rebuild switch --flake /etc/nixos#"$(hostname)"
         sudo nixos-rebuild switch --flake '/etc/nixos#pedroregispoar'
       ''
     )


     (
     writeScriptBin "gacup" ''
       #! ${pkgs.runtimeShell} -e
       
       git add . && git commit -m "Updates commit's sha256" && git push
     ''
     )

     (
     writeScriptBin "gacpwip" ''
       #! ${pkgs.runtimeShell} -e

       git add . && git commit -m "Work In Progess (WIP)" && git push
     ''
     )

     (
     writeScriptBin "gacp" ''
       #! ${pkgs.runtimeShell} -e

       git add . && git commit -m "$1" && git push
     ''         
     )

     (
     writeScriptBin "gac" ''
       #! ${pkgs.runtimeShell} -e

       git add . && git commit -m "$1"
     ''         
     )


     (
     writeScriptBin "ga" ''
       #! ${pkgs.runtimeShell} -e

       git add "$1"
     ''         
     )

     (
     writeScriptBin "g3tc6t" ''
       #! ${pkgs.runtimeShell} -e

       git commit -m "$1" 
     ''         
     )


     (
     writeScriptBin "g3td" ''
       #! ${pkgs.runtimeShell} -e

       git diff
     ''         
     )


     (
     writeScriptBin "g3tp" ''
       #! ${pkgs.runtimeShell} -e

       git push
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
         # function mansf () { man $1 | less -p "^ +$2" }
         # Call the function
         #
         # mansf $1 $2
         man $1 | less -p "^ +$2"
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
