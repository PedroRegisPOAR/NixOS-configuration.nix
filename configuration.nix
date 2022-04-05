# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

#let
#  pkgs = import npkgs { system = "x86_64-linux"; };
#
#  #myScript = pkgs.writeShellScriptBin "helloWorld" "echo Hello World";
#in
{
  imports =
    [ # Include the results of the hardware scan.
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

    # From:
    # https://github.com/sherubthakur/dotfiles/blob/be96fe7c74df706a8b1b925ca4e7748cab703697/system/configuration.nix#L44
    # pointing to: https://github.com/NixOS/nixpkgs/issues/124215
    settings.extra-sandbox-paths= [ "/bin/sh=${pkgs.bash}/bin/sh"];
    
    # https://github.com/NixOS/nixpkgs/blob/fd8a7fd07da0f3fc0e27575891f45c2f88e5dd44/nixos/modules/services/misc/nix-daemon.nix#L323
    # Be carefull if using it as false!
    readOnlyStore = false;
  };

   

   # TODO:
   # https://knowledge.rootknecht.net/nixos-configuration#automaticgarbagecollection

#  nix = {
#    package = pkgs.nixUnstable;
#    extraOptions = ''
#      experimental-features = nix-command flakes
#    '';
#  };
 
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     
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
     # inetutils # TODO: it was causing a conflict, insvestigate it!
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
     tdesktop
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
     # libreoffice
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
         nix profile remove '.*' \
         && find ~ \( -iname '*.iso' -o -iname '*.qcow2*' -o -iname '*.img' -o -iname 'result' \) -exec rm -fv -- {} + 2> /dev/null | tr ' ' '\n' \
         && sudo rm -fr "$HOME"/.cache "$HOME"/.local \
         && nix store gc --verbose \
              --option keep-derivations false \
              --option keep-outputs false \
         && nix-collect-garbage --delete-old
       ''
     )

     # Helper script
     (
       writeScriptBin "crw" ''
         #! ${pkgs.runtimeShell} -e
         
	 cat "$(readlink -f "$(which $1)")"	
       ''
     )


     # to kill processes that are using an file.
     # 
     # https://stackoverflow.com/a/24554952
     # https://www.baeldung.com/linux/find-process-file-is-busy
     # 
     # kill -TERM $(lsof -t filename)

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
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  # https://github.com/NixOS/nixpkgs/blob/release-20.03/nixos/modules/hardware/all-firmware.nix
  hardware.enableRedistributableFirmware = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
  }; 

  # https://nixos.wiki/wiki/Libvirt
  #
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # https://alexbakker.me/post/nixos-pci-passthrough-qemu-vfio.html
  # https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Setting_up_IOMMU
  # https://gist.github.com/GrimKriegor/b38fa6d83c3b540844104584fdb7274d#kernel-parameters
  # https://www.reddit.com/r/VFIO/comments/ma2whf/got_valorant_working_on_a_single_gpu_setup_on/
  #
  # IOMMU stuff
  # https://stackoverflow.com/a/23840271
  # https://www.kernel.org/doc/Documentation/Intel-IOMMU.txt
  #
  # pcie_acs_override=downstream,multifunction stuff
  # https://forum.level1techs.com/t/x470-taichi-on-board-usb-controller-passthrough/151088/13
  # https://gist.github.com/jpotier/e4829f9cd7d9442731aa223e00245f3f#file-vfio-nix-L56
  #
  # https://github.com/brodyck/nix-bidaya/blob/3a4b7bc0f941338677b7f77dd4189f8bc7c753d5/cfg/gpu-passthrough.nix#L74-L76
  #
  # https://github.com/meatcar/dots/blob/10441bd3d851e4176b39c2ad6f8704164ff5f9b3/modules/vfio/default.nix#L3
  # https://github.com/luis-caldas/nix/blob/72c228f9d488e472417577fe4955f67ef895a4b0/config/survivor/headless.nix#L13
  #
  # boot.kernelParams = [
  #  "iommu=1"
  #  "intel_iommu=on"
  #  "iommu=pt"
  #  "pcie_acs_override=downstream,multifunction"
  #  "kvm.ignore_msrs=1"
  #  "kvm.report_ignored_msrs=0"
  #  "vfio_iommu_type1.allow_unsafe_interrupts=1"
  #  "rd.driver.pre=vfio-pci"
  #  "video=vesafb:off,efifb:off"
  #  "nofb"
  # ];

  # https://nixos.mayflower.consulting/blog/2020/06/17/windows-vm-performance/
  # boot.blacklistedKernelModules = ["nouveau"];

  # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
  boot.kernelModules = [
    # "pci-stub"
    "kvm-intel"
    # "vfio"
    # "vfio_iommu_type1"
    # "vfio_pci"
    # "vfio_virqfd"
  ];

  # https://github.com/NixOS/nixpkgs/issues/18473#issuecomment-246069509
  # https://gist.github.com/jpotier/e4829f9cd7d9442731aa223e00245f3f#file-vfio-nix-L62-L63
  # boot.initrd.kernelModules = [
  #  "vfio_virqfd"
  #  "vfio_pci"
  #  "vfio_iommu_type1"
  #  "vfio"
  # ];

  boot.kernel.sysctl = { "net.netfilter.nf_conntrack_max" = 131072; };

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

  # services.xserver.displayManager.defaultSession = "xfce"; 

  # services.xserver.desktopManager.gnome3.enable = true;

  # https://t.me/nixosbrasil/26612
  services.smartd.enable = true;

  # Supposedly better for the SSD.
  # https://discourse.nixos.org/t/update-build-config-error/5889/7
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pedro = {
    isNormalUser = true;
    
    # https://nixos.wiki/wiki/Libvirt
    extraGroups = [ "audio" "libvirtd" "wheel" "pedro" "docker" "kvm"]; # Enable ‘sudo’ for the user.
  };

  users.extraUsers.pedro = {
    shell = pkgs.zsh;
  };

  # It is a hack, minkube only works if calling `sudo -k -n podman` does NOT ask for password.
  # The hardcoded path is because i am not using the podman installed in the system, but the one 
  # in a flake that i am using at work. For now let it be hardcoded :|
  # 
  # It looks like there is a bug too:
  # https://unix.stackexchange.com/questions/377362/in-nixos-how-to-add-a-user-to-the-sudoers-file
  # https://www.reddit.com/r/NixOS/comments/nzks7u/running_sudo_without_password/
  # https://github.com/NixOS/nixpkgs/issues/58276
  #security.sudo.extraConfig = ''
  #  %wheel	ALL=(root)	NOPASSWD:SETENV: /nix/store/h63yf7a2ccfimas30i0wn54fp8c8h3qf-podman-rootless-derivation/bin/podman 
  #'';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  # Is it usefull for some other thing?
  virtualisation.docker.enable = true;
 
  #virtualisation.podman = {
  #  enable = true;
  #  # Create a `docker` alias for podman, to use it as a drop-in replacement
  #  #dockerCompat = true;
  #};

#  environment.etc."containers/registries.conf" = {
#    mode="0644";
#    text=''
#      [registries.search]
#      registries = ['docker.io', 'localhost']
#    '';
#  };

  # virtualisation.libvirtd = {
  #   allowedBridges = [
  #     "nm-bridge"
  #     "virbr0"
  #   ];
  #  enable = true;
  #  qemu.runAsRoot = false;
  #  qemu.ovmf.enable = true;
  #  qemu.ovmf.package = pkgs.OVMFFull;

    # https://gist.github.com/techhazard/1be07805081a4d7a51c527e452b87b26#gistcomment-2087168
    # qemuVerbatimConfig = ''
    #  nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
    #'';

  # };

#  environment.etc."libvirt/qemu.conf" = {
#    mode="0644";
#    text=''
#      nvram = [ "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
#    '';
#  };

  nixpkgs.config.allowUnfree = true;  

  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # programs.gnupg.agent.enable = true;

  /*
  # https://knowledge.rootknecht.net/nixos-configuration
  programs.zsh.enable = true;

  programs.zsh.enableCompletion = true;

  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    # Customize your oh-my-zsh options here
    ZSH_THEME="agnoster"

    bindkey '\e[5~' history-beginning-search-backward
    bindkey '\e[6~' history-beginning-search-forward

    HISTFILESIZE=500000
    HISTSIZE=500000
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_DUPS
    setopt INC_APPEND_HISTORY
    autoload -U compinit && compinit
    unsetopt menu_complete
    setopt completealiases

    if [ -f ~/.aliases ]; then
      source ~/.aliases
    fi

    plugins=(
       colored-man-pages
       docker
       git
       zsh-autosuggestions
       zsh-syntax-highlighting
       )
    
    # https://keybase.pub/peterwilli/NixOS%20Shared%20Stuff/configuration.nix
    # Custom Git Commands
    # git config --global alias.ac '!git add -A && git commit' 2> /dev/null # O que isso faz?
    git config --global user.email "pedroregispoar@gmail.com" 2> /dev/null
    git config --global user.name "Pedro Regis" 2> /dev/null

    source $ZSH/oh-my-zsh.sh
  '';  
  programs.zsh.promptInit = "";
  */
  
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
      corefonts		  # Microsoft free fonts
      fira	      	  # Monospace
      inconsolata     	  # Monospace
      powerline-fonts
      ubuntu_font_family
      unifont		  # International languages
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

