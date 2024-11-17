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
