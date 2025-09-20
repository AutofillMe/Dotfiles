# Dotfiles
Stores dotfiles for use with GNU stow

```
git clone git@github.com:AutofillMe/Dotfiles.git ~/.dotfiles
```

# Setup SSH
To generate a SSH key in order to be able to clone this repo, first on local machine:

```
ssh-keygen -t rsa -C "snyder.jacob@proton.me"
```

Then, after accepting all defaults:

```
ssh-add ~/.ssh/id_rsa
```

Finally, print the public key to the screen using
```cat ~/.ssh/id_rsa.pub```
and copy and paste into GitHub

# Fix Right-Click Terminal to Ghostty
Run `kcmshell6 componentchooser` and choose `Ghostty`

# Fix Default Text Editor
Run `kcmshell6 componentchooser` and choose `Neovim`
