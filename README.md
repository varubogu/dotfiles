# dotfiles

A solution for managing dotfiles based on YADM.

## Setup

It will be the same no matter how many times you do it.

Root setup

```bash
bash -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/setup/setup.bash )"
```

Rootless setup

```bash
bash -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/setup/setup.bash ) -noroot"
```

Windows setup

```ps1
$scriptUrl = "https://raw.github.com/varubogu/dotfiles/master/.local/bin/setup/setup_win.ps1"
$scriptContent = Invoke-RestMethod -Uri $scriptUrl
Invoke-Expression $scriptContent
```
[!NOTE]
> ⚠️ For Windows, you need to install the latest version of PowerShell, the app installer, and Winget.

### setup overview

1. Install YADM (For Mac, install HomeBrew and use it to install YADM.)
2. Cloning a dot file repository with YADM
3. Create XDG Base Directory structure
4. Create symlinks for configuration files 💡
5. Detects available package managers and installs apps.


## Structure

### Output

```bash
# alias:pstr
~/dotfiles/bin/struct/print_struct.sh
```

### relational path view

~/.local/share/struct/find.txt

### tree view

~/.local/share/struct/tree.txt

## Policy
