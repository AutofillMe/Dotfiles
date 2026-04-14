# Dotfiles
Stores dotfiles for use with GNU stow on Nobara Linux 43 (Fedora)

**!!!WARNING!!!**
This is built for use in Fedora (dnf) based distros and has configs specific to Nobara 43.  I cannot guaruntee that it will work on any other distro, or even newer versions of Nobara.

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
```
cat ~/.ssh/id_rsa.pub
```
and copy and paste into GitHub

# Clone Repo
Download repo after setting up SSH

```
git clone git@github.com:AutofillMe/Dotfiles.git ~/.dotfiles
```

or via HTTPS

```
git clone https://github.com/AutofillMe/Dotfiles.git ~/.dotfiles
```

# Other Customization Automation TODO:
- [ ] Remove Icon Bounce
- [ ] Posy Cursor
- [ ] WatchDogs Splash
- [ ] Where is my SDDM
- [ ] Disable Mouse Shake
- [ ] Breeze Dark Theme
