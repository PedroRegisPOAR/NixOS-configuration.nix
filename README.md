





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




[how to find which packages are installed system-wide in NixOS?](https://unix.stackexchange.com/questions/422147/how-to-find-which-packages-are-installed-system-wide-in-nixos)
	
