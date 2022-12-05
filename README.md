# Here are some notes about my NixOS system


```bash
nixos-version --json | jq -r .nixpkgsRevision
```
From: https://www.tweag.io/blog/2020-07-31-nixos-flakes/


```bash
nix flake metadata '/etc/nixos#pedroregispoar'
```

### Testing



```bash
sudo nixos-rebuild test --flake '/etc/nixos#pedroregispoar'
```

It brings up to PATH new scripts and does other stuff too.


```bash
sudo nixos-rebuild switch --flake '/etc/nixos#pedroregispoar'
```

TODO: test it
```bash
sudo \
su \
-c \
"
nix flake update \
&& nixos-rebuild switch --flake '/etc/nixos#pedroregispoar'
"
```


```bash
nix \
flake \
update \
--override-input \
nixpkgs \
"$(nix flake metadata github:NixOS/nixpkgs/nixos-22.05 --json | jq -r .url)"
```


```bash
nix \
flake \
metadata \
'github:NixOS/nix?ref=2.10.3' --json | jq -r .url
```


```bash
nix \
flake \
update \
--override-input \
nixpkgs-unstable \
"$(nix flake metadata github:NixOS/nixpkgs/nixpkgs-unstable --json | jq -r .url)"
```


```bash
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
```

To list all generations:
```bash
sudo nix-env --profile /nix/var/nix/profiles/system --list-generations
```



```bash
nix profile list --profile "${HOME}"/.nix-profile
nix profile install nixpkgs#hello
nix profile list --profile "${HOME}"/.nix-profile
```

```bash
nix show-derivation /run/current-system
```


Lists entries from `/boot/loader/entries`:
```bash
[ -d /sys/firmware/efi/efivars ] && ls -al /boot/efi/loader/entries/nixos-generation-* || ls -al /boot/loader/entries
# test -d /sys/firmware/efi/efivars && ls -al /boot/efi/loader/entries/nixos-generation-* || ls -al /boot/loader/entries
```
Refs.:
- https://nixos.wiki/wiki/Bootloader


```bash
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
```

TODO: it only works in legacy mode!
```bash
sudo bash -c "cd /boot/loader/entries; ls | xargs echo"
```


Really hacky/broken code.
```bash
sudo bash -c "cd /boot/loader/entries; ls | grep -v 'nixos-generation-13.conf' | xargs rm"
```
Adapted from: [gist](https://gist.github.com/xeppaka/f6126eebe030a000aa14ed63cc6e8496) and 
[--profile-name](https://stackoverflow.com/a/35664788)



```bash
readlink "$(readlink ~/.nix-profile)"

nix-env --list-generations | grep current | awk '{print $1}'

tree /nix/var/nix/profiles

sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}'
```
[Current generation number](https://discourse.nixos.org/t/current-generation-number/3029/7)




[how to find which packages are installed system-wide in NixOS?](https://unix.stackexchange.com/questions/422147/how-to-find-which-packages-are-installed-system-wide-in-nixos). I think it is related, what about packages intalled with `nix-shell`? See `nix-env --query --installed --out-path | cat` and https://nixos.wiki/wiki/Nix_command/profile and https://www.reddit.com/r/NixOS/comments/j4k2zz/does_anyone_use_flakes_to_manage_their_entire/ghrs271/?utm_source=reddit&utm_medium=web2x&context=3


TODO:
- https://gist.github.com/mx00s/ea2462a3fe6fdaa65692fe7ee824de3e
- https://grahamc.com/blog/erase-your-darlings
- https://news.ycombinator.com/item?id=22856199


Building this NixOS system using only `nix` (in future it is going to be the nix static one):
```bash
nix \
build \
github:PedroRegisPOAR/NixOS-configuration.nix#nixosConfigurations.pedroregispoar.config.system.build.toplevel

ls -al result/init
```



```bash
ls -al /nix/store | rg podman
```


#### Change https to ssh local git repository

```bash
git \
remote \
set-url \
origin \
$(git remote show origin | grep "Fetch URL" | sed 's/ *Fetch URL: //' | sed 's/https:\/\/github.com\//git@github.com:/')
```
Refs.:
- missing it


```bash
git rm --cached <file>

# or

git rm -r --cached <folder>
```
From: https://stackoverflow.com/a/1274447



```bash
# git config --list
# 
# git config user.name \
# && git config user.email

git config user.name && git config user.email || cat << EOF > ~/.gitconfig
[user]
    name = PedroRegisPOAR
    email = pedroalencarregis@hotmail.com
EOF
```


### nix repl

For flake systems:


```bash
nix repl
```

Part 1:
**or**

```bash
nix repl --expr 'import <nixpkgs>{}'
```
Refs.:
- https://discourse.nixos.org/t/nix-2-10-0-released/20291


Part 2 (tip, hit tab after the `.` in `nixosConfigurations.`):
```bash
nix repl> :lf /etc/nixos
nix repl> nixosConfigurations.
```
Refs.:
- https://www.reddit.com/r/NixOS/comments/u6fl8j/how_to_the_entire_configurationnix_into_nix_repl/


Search for `nix-repl` in https://xeiaso.net/blog/nix-flakes-3-2022-04-07

Tip: use `:t` to print the type of the thing
Refs.:
- https://nixos.wiki/wiki/Nix_Expression_Language



```bash
nix repl --expr 'import <nixpkgs> {}' <<<':doc builtins.getFlake'
```

```bash
nix repl --expr 'import <nixpkgs> {}' <<<'builtins.attrNames gcc'
```

```bash
nix repl --expr 'import <nixpkgs> {}' <<<'builtins.attrNames python3Packages' | tr ' ' '\n' | wc -l
```

```bash
# see uname -a output
nix repl --expr 'import <nixpkgs> {}' <<<'stdenv.hostPlatform.system'
```

Other refs.:
- https://nix.dev/anti-patterns/language
- https://bnikolic.co.uk/nix-cheatsheet.html
- https://nixos.wiki/wiki/Nix_Quirks#Q:_Why_not_x:x.3F


###


```bash
DEFAULT_ROUTE=$(ip route show default | awk '/default/ {print $3}')
ping -c 1 $DEFAULT_ROUTE
```


ip route show default 0.0.0.0/0


```bash
ip -j a s $(ip -j r s default | jq -r '.[].dev') | jq -r '.[0].addr_info[0].local'
```

