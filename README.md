


`sudo nixos-rebuild switch --flake '/etc/nixos#pedroregispoar'`


```bash
sudo su

nix flake update \
&& nixos-rebuild switch --flake '/etc/nixos#pedroregispoar' \
&& nix store gc \
&& nix-collect-garbage --delete-old \
&& nix store optimise
```

To list all generations:
`sudo nix-env --profile /nix/var/nix/profiles/system --list-generations`



Lists entries from `/boot/loader/entries`:
`ls /boot/loader/entries`


`sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old`

sudo bash -c "cd /boot/loader/entries; ls | xargs echo"



`sudo bash -c "cd /boot/loader/entries; ls | grep -v 'nixos-generation-13.conf' | xargs rm"`
Adapted from: [gist](https://gist.github.com/xeppaka/f6126eebe030a000aa14ed63cc6e8496)

[--profile-name](https://stackoverflow.com/a/35664788)



`readlink "$(readlink ~/.nix-profile)"`

`nix-env --list-generations | grep current | awk '{print $1}'`

`tree /nix/var/nix/profiles`

`sudo nix-env --list-generations --profile /nix/var/nix/profiles/system`

`sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}'`

[Current generation number](https://discourse.nixos.org/t/current-generation-number/3029/7)




[how to find which packages are installed system-wide in NixOS?](https://unix.stackexchange.com/questions/422147/how-to-find-which-packages-are-installed-system-wide-in-nixos). I think it is related, what about packages intalled with `nix-shell`? See `nix-env --query --installed --out-path | cat` and https://nixos.wiki/wiki/Nix_command/profile and https://www.reddit.com/r/NixOS/comments/j4k2zz/does_anyone_use_flakes_to_manage_their_entire/ghrs271/?utm_source=reddit&utm_medium=web2x&context=3


TODO:
- https://gist.github.com/mx00s/ea2462a3fe6fdaa65692fe7ee824de3e
- https://grahamc.com/blog/erase-your-darlings
- https://news.ycombinator.com/item?id=22856199


```bash
nix \
build \
github:PedroRegisPOAR/NixOS-configuration.nix#nixosConfigurations.pedroregispoar.config.system.build.toplevel

result/init
```
