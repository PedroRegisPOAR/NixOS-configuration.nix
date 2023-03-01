
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
  console.font = "Twitter Color Emoji"; # https://stackoverflow.com/questions/51922651/in-nixos-is-there-a-way-to-get-a-list-of-available-console-fonts
  i18n.extraLocaleSettings = {
    # LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
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

  # TODO: document it
  # It was not working
  # services.xserver.excludePackages = with pkgs.xorg; [ fontmiscmisc fontcursormisc ];

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
      fontconfig = {

#        # https://gist.github.com/IgnoredAmbience/7c99b6cf9a8b73c9312a71d1209d9bbb?permalink_comment_id=3502481#gistcomment-3502481
#        localConf = ''
#            <?xml version="1.0" encoding="UTF-8"?>
#            <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
#            <!--
#            Noto Mono + Color Emoji Font Configuration.
#            This config seems to ensure that *all* monospace fonts are affected without breaking
#            <code> blocks elsewhere. The significant change appears to be setting binding="weak"
#            on line 22.
#            Currently the only Terminal Emulator I'm aware that supports colour fonts is Konsole.
#            Usage:
#            0. Ensure that the Noto fonts are installed on your machine.
#            1. Install this file to ~/.config/fontconfig/conf.d/99-noto-mono-color-emoji.conf
#            2. Run `fc-cache`
#            3. Set Konsole to use "Noto Mono" as the font.
#            4. Restart Konsole.
#            -->
#            <fontconfig>
#              <match>
#                <test name="family"><string>Monospace</string></test>
#                <edit name="family" mode="append_last" binding="weak">
#                  <string>Noto Color Emoji</string>
#                </edit>
#              </match>
#            </fontconfig>
#        '';

#        localConf = ''
#        <?xml version="1.0" encoding="UTF-8"?>
#        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
#        <fontconfig>
#
#         <alias>
#           <family>sans-serif</family>
#           <prefer>
#             <family>Main sans-serif font name goes here</family>
#             <family>Noto Color Emoji</family>
#             <family>Noto Emoji</family>
#           </prefer>
#         </alias>
#
#         <alias>
#           <family>serif</family>
#           <prefer>
#             <family>Main serif font name goes here</family>
#             <family>Noto Color Emoji</family>
#             <family>Noto Emoji</family>
#           </prefer>
#         </alias>
#
#         <alias>
#          <family>monospace</family>
#          <prefer>
#            <family>Main monospace font name goes here</family>
#            <family>Noto Color Emoji</family>
#            <family>Noto Emoji</family>
#           </prefer>
#         </alias>
#        </fontconfig>
#        '';

        localConf = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
            <fontconfig>
              <alias binding="weak">
                <family>monospace</family>
                <prefer>
                  <family>emoji</family>
                </prefer>
              </alias>
              <alias binding="weak">
                <family>sans-serif</family>
                <prefer>
                  <family>emoji</family>
                </prefer>
              </alias>
              <alias binding="weak">
                <family>serif</family>
                <prefer>
                  <family>emoji</family>
                </prefer>
              </alias>
            </fontconfig>
        '';

#        localConf = ''
#            <?xml version="1.0" encoding="UTF-8"?><!DOCTYPE fontconfig SYSTEM "fonts.dtd">
#            <fontconfig>
#            <match>
#             <test name="family"><string>sans-serif</string></test>
#             <edit name="family" mode="prepend" binding="strong">
#             <string>Noto Color Emoji</string>
#             </edit>
#             </match>
#            <match>
#             <test name="family"><string>serif</string></test>
#             <edit name="family" mode="prepend" binding="strong">
#             <string>Noto Color Emoji</string>
#             </edit>
#             </match>
#            <match>
#             <test name="family"><string>Apple Color Emoji</string></test>
#             <edit name="family" mode="prepend" binding="strong">
#             <string>Noto Color Emoji</string>
#             </edit>
#             </match>
#            </fontconfig>
#        '';

      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "FreeMono" ];
        sansSerif = [ "FreeSans" ];
        serif = [ "FreeSerif" ];
      };
    };
    fonts = with pkgs; [
       # fontconfig

        # Broken:
        # apple-fonts
        # cantarell_fonts
        # fira-code-symbol
        # fontconfig-penultimate # It was a fork of the abandoned
        # maple-mono-SC-NF
        # material-symbols
        # mplus-outline-fonts
        # pragmataPro
        # pxplus-ibm-vga8-bin
        # sf-mono-liga
        # sfmono
        # terminus # terminus has been removed, it was unmaintained in nixpkgs
        # terminus-td1
        # ttf-ms-win10
        # ttfautohunt
        # unfree

        #andagii
        #anonymousPro
        #arc-icon-theme
        #arkpandora_ttf
        #arphic-ukai
        #arphic-uming
        #aurulent-sans
        #babelstone-han # https://www.reddit.com/r/NixOS/comments/10lyw6d/certain_asian_characters_show_as_boxes/
        #baekmuk-ttf
        #cabin
        #caladea
        #cantarell-fonts
        #carlito
        #cascadia-code
        #clearlyU
        #cm_unicode
        #comfortaa
        #comic-neue
        #comic-relief
        #corefonts           # Microsoft free fonts
        #crimson
        #curie
        #dejavu_fonts
        #dina-font
        #dina-font-pcf
        #ditaa
        #dosis
        #eb-garamond
        #emacs-all-the-icons-fonts
        #emojione
        #encode-sans
        #envypn-font
        #etBook
        #faba-icon-theme
        #faba-mono-icons
        #fantasque-sans-mono
        #fira                # Monospace
        #fira-code
        #fira-code-symbols
        #fira-mono
        #font-awesome # Old named as: font-awesome-ttf
        #font-awesome_4
        #font-awesome_5 # 6 breaks polybar?
        #font-manager
        #freefont_ttf
        #ftgl
        #gbdfed
        #gentium-book-basic
        #ghostscript
        #ghostscriptX
        #gnome3.gnome-font-viewer
        #go-font
        #gohufont
        #google-fonts # this kills doom emacs performance for some reason. Do not use. Missing fc-cache -v ?
        #gtk2fontsel
        #hack-font
        #hanazono
        #hasklig
        #helvetica-neue-lt-std
        #ia-writer-duospace
        #ibm-plex
        #inconsolata
        #inconsolata         # Monospace
        #inconsolata-lgc
        #inconsolata-nerdfont
        #inter
        #iosevka
        #iosevka-bin
        #iosevka-comfy.comfy
        #jetbrains-mono
        #jost
        #joypixels # joypixels.acceptLicense = true;
        #jre
        #junicode
        #kawkab-mono-font
        #lato
        #lexend
        #liberastika
        #liberation_ttf
        #libertine
        #libre-baskerville
        #libre-franklin
        #lmmath
        #lmodern
        #lobster-two
        #lxappearance
        #maia-icon-theme
        #marathi-cursive
        #material-design-icons
        #material-icons
        #meslo-lg
        #meslo-lgs-nf
        #migu
        #moka-icon-theme
        #monoid # https://larsenwork.com/monoid/
        #mononoki
        #montserrat
        #mph_2b_damase
        #mro-unicode
        #nafees
        #nerdfonts # Really big
        #norwester-font
        #noto-fonts
        #noto-fonts-cjk
        #noto-fonts-cjk-sans
        #noto-fonts-cjk-serif
        #noto-fonts-emoji
        #noto-fonts-emoji-blob-bin
        #noto-fonts-extra
        #numix-icon-theme
        #numix-icon-theme-circle
        #numix-icon-theme-square
        #office-code-pro
        #oldsindhi
        #oldstandard
        #open-dyslexic
        #open-sans
        #openmoji-black
        #openmoji-color
        #overpass
        #oxygen-icons5
        #oxygenfonts
        #paper-icon-theme
        #paratype-pt-mono
        #paratype-pt-sans
        #paratype-pt-serif
        #pecita
        #plantuml
        #poly
        #powerline
        #powerline-fonts
        #profont
        #proggyfonts
        #quattrocento
        #quattrocento-sans
        #raleway
        #recursive
        #roboto
        #roboto-mono
        #roboto-slab
        #rxvt-unicode-emoji
        #sampradaya
        #sarasa-gothic # A CJK programming font based on Iosevka and Source Han Sans
        #scientifica
        #shrikhand
        #signwriting
        #siji # bitmap icons
        #silver-searcher
        #soundfont-fluid
        #source-code-pro
        #source-han-sans
        #source-han-sans-japanese
        #source-han-sans-korean
        #source-han-sans-simplified-chinese
        #source-han-sans-traditional-chinese
        #source-han-serif-japanese
        #source-han-serif-korean
        #source-han-serif-simplified-chinese
        #source-han-serif-traditional-chinese
        #source-sans
        #source-sans-pro
        #source-serif-pro
        #stix-two
        #sudo-font
        #symbola
        #tai-ahom
        #tango-icon-theme
        #tempora_lgc
        #terminus_font
        #terminus_font_ttf
        #tewi-font
        #tewi-font # bitmap icons + letters
        #theano
        #tipa
        #ttf_bitstream_vera
        #ttmkfdir
        #twemoji-color-font
        #twitter-color-emoji
        #ubuntu_font_family
        #uni-vga
        #unifont             # International languages
        #unifont_upper
        #vanilla-dmz
        #vegur
        #victor-mono
        #vistafonts
        #vistafonts-chs
        #vistafonts-cht
        #weather-icons
        #work-sans
        #wqy_microhei
        #wqy_zenhei
        #xfontsel
        #xkcd-font

        nerdfonts
        powerline
        powerline-fonts
        # twemoji-color-font
        twitter-color-emoji
        rxvt-unicode-emoji
        emojione
        noto-fonts-emoji-blob-bin
        # ttf_bitstream_vera
        # babelstone-han
        # google-fonts
        noto-fonts-emoji

    ];
    enableDefaultFonts = false;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.joypixels.acceptLicense = true;

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
     fontforge-gtk # Really helps: https://joyofhaskell.com/posts/2018-11-30-font-name.html

    
     # Some utils
     binutils
     coreutils
     dnsutils
     file
     findutils
     lsof
     # inetutils # TODO: it was causing a conflict, insvestigate it!
     nixpkgs-fmt
     nixos-option
     hydra-check
     ripgrep
     strace
     # util-linux
     # unzip
     tree
     nix-index
     # xorg.xhost

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
     
     # sl
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
       writeScriptBin "yte" ''
         echo "https://www.youtube.com/embed/""$1""?start=""$2""&end=""$3""&version=3"
       ''
     )

     # The best? https://stackoverflow.com/a/7045517
     # https://serverfault.com/a/397537
     # https://serverfault.com/questions/377943/how-do-i-read-multiple-lines-from-stdin-into-a-variable/397537#comment1200050_397537
     # https://stackoverflow.com/questions/1167746/how-to-assign-a-heredoc-value-to-a-variable-in-bash
     # https://stackoverflow.com/a/37222377
     # https://serverfault.com/questions/72476/clean-way-to-write-complex-multi-line-string-to-a-variable
     #
     # coreutils fold: 
     # - https://unix.stackexchange.com/a/25174
     # - https://askubuntu.com/a/1398721
     # - https://unix.stackexchange.com/a/231915
     (
       writeScriptBin "ytt" ''
         myVar=$(</dev/stdin)
         
         # echo "$myVar"
         echo "$myVar" | grep -vE '[0-9][0-9]:[0-9][0-9]$' | tr '\n' ' ' | fold -sw 80
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
       git status .

       git add . && git commit -m "Updates commit's sha256" && git push
     ''
     )

     (
     writeScriptBin "gacpwip" ''
       #! ${pkgs.runtimeShell} -e
       
       git status .
       git add . && git commit -m "Work In Progess (WIP)" && git push
     ''
     )

     (
     writeScriptBin "gacp" ''
       #! ${pkgs.runtimeShell} -e
       git status .
       git add . && git commit -m "$1" && git push
     ''         
     )

     (
     writeScriptBin "gac" ''
       #! ${pkgs.runtimeShell} -e
       git status .
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
       git status .

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

     (
       writeScriptBin "pppi" ''
         #! ${pkgs.runtimeShell} -e
         podman pull $1
         podman inspect $1 | jq ".[].Digest"
       ''
     )

  ];


  # TODO: testar
  # https://www.reddit.com/r/NixOS/comments/fsummx/how_to_list_all_installed_packages_on_nixos/
  # https://discourse.nixos.org/t/can-i-inspect-the-installed-versions-of-system-packages/2763/15
  # https://functor.tokyo/blog/2018-02-20-show-packages-installed-on-nixos
  #  environment.etc."current-system-packages".text =
  #    let
  #      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
  #      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.unique packages);
  #      formatted = builtins.concatStringsSep "\n" sortedUnique;
  #    in
  #    formatted;

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

