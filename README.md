# dotfiles

## Setup

It will be the same no matter how many times you do it.

Root setup

```bash
bash -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/init/setup.sh )"
```

Rootless setup

```bash
bash -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/init/setup_rootless.sh )"
```

Windows setup

```ps1
pwsh -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/init/setup.ps1 )"
```

## Structure

### Output

```bash
# alias:pstr
~/dotfiles/bin/struct/print_struct
```

### relational path view

/var/find.txt

### tree view

/var/tree.txt

## Policy