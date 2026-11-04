# Vim-style keyboard navigation

This keyd configuration adds system-wide navigation shortcuts using Caps Lock
as a layer key. Tap Caps Lock to toggle Caps Lock normally. Hold Caps Lock
while pressing one of the keys below to navigate.

| Shortcut | Action |
| --- | --- |
| Caps Lock + h | Left |
| Caps Lock + j | Down |
| Caps Lock + k | Up |
| Caps Lock + l | Right |
| Caps Lock + u | Home |
| Caps Lock + o | End |
| Caps Lock + i | Page Up |
| Caps Lock + m | Page Down |

The h/j/k/l keys follow Vim's movement layout. The other keys are custom
navigation mappings. The configuration applies to all keyboards (`[ids] *`).

## Setup on Linux

Install keyd using your distribution's package manager, then restore the
configuration from these dotfiles and install it in keyd's system directory:

```sh
chezmoi apply ~/.config/keyd/default.conf
sudo install -Dm644 ~/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
sudo keyd reload
```

After changing the configuration in your dotfiles, repeat the apply, install,
and reload commands to activate the updated mappings.
