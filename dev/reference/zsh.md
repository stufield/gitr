# Z-shell Aliases

Provides functions to common Z-shell git plugin aliases.

## Usage

``` r
glog(n = 10L)

gcc(...)

gcmsg(msg = "wip")

gco(branch = NULL)

gcb(branch = NULL)

gpr()

gp(...)

gpu()

gpd()

gst()

gss()

gba()

gbd(branch = NULL, force = FALSE)

gbmm(branch = gitr_default_br())

gbnm(branch = gitr_default_br())

gbm(branch = NULL)

ga(...)

gaa()

gau()

gsta()

gstl()

gstaa(n = 0L)

gstd(n = 0L)

gstc()

gsts(text = FALSE)

gpop()

gstp()

gtn()

gfa()

gac()

gwip()

gclean(dry_run = TRUE)

gdf(file = NULL, staged = FALSE)

gpf()

gnuke()

gcf(global = FALSE)

gcm()

grm(...)

grbc()

grba()

grbs()

grbm()

grv()
```

## Arguments

- n:

  `integer(1)`. How far back to go from current `HEAD`. Same as the
  command line `git log -n` parameter. For `git stash` commands,
  zero-index into the stash list.

- ...:

  Additional arguments passed to the system command-line
  `git <command> [<args>]` call.

- msg:

  `character(1)`. The message for the commit subject line.

- branch:

  `character(1)`. The name of a branch, typically a feature branch.

- force:

  `logical(1)`. Should the branch delete be forced with the `-D` flag?

- text:

  `logical(1)`. Show the text diffs from the stash.

- dry_run:

  `logical(1)`. Clean as dry-run?

- file:

  A full file path within the repository to diff.

- staged:

  `logical(1)`. Compare a staged file to `HEAD`? Otherwise the working
  directory is compared to the index (`staged` or `HEAD`).

- global:

  `logical(1)`. Query global repository. Alternatively local
  configuration only.

## Value

Most aliases invisibly return `NULL` ... with some exceptions.

## Functions

- `glog()`: Get the `git` log in a pretty format for the `n` most recent
  commits.

- `gcc()`: `git commit ...`. To avoid masking the
  [`base::gc()`](https://rdrr.io/r/base/gc.html) function, this alias
  has been re-mapped to `gcc()`.

- `gcmsg()`: `git commit -m <msg>`.

- `gco()`: `git checkout`.

- `gcb()`: `git checkout -b <branch>`.

- `gpr()`: `git pull --rebase`.

- `gp()`: `git push`.

- `gpu()`: `git push -u origin`.

- `gpd()`: `git push --dry-run`.

- `gst()`: `git status`.

- `gss()`: `git status -s`.

- `gba()`: `git branch -a`.

- `gbd()`: `git branch -dD`.

- `gbmm()`: `git branch --merged <branch>`.

- `gbnm()`: `git branch --no-merged <branch>`.

- `gbm()`: `git branch -m`.

- `ga()`: `git add ...`.

- `gaa()`: `git add --all`.

- `gau()`: `git add -u`.

- `gsta()`: `git stash`.

- `gstl()`: `git stash list`.

- `gstaa()`: `git stash apply`. **Note** zero-indexing!

- `gstd()`: `git stash drop`. **Note** zero-indexing!

- `gstc()`: `git stash clear`. Danger!

- `gsts()`: `git stash show`.

- `gpop()`: `git stash pop --quiet --index`.

- `gstp()`: See `gpop()`.

- `gtn()`: `git tag -n`.

- `gfa()`: `git fetch --all --prune`.

- `gac()`: `git commit --no-verify --amend --no-edit`.

- `gwip()`: `git commit --no-verify -m 'wip'`.

- `gclean()`: `git clean -f -d`.

- `gdf()`: `git diff <file>`.

- `gpf()`: `git push --force-with-lease`.

- `gnuke()`: `git reset --hard && git clean -df`.

- `gcf()`: `git config --local` or `git config --global`.

- `gcm()`: Checkout the default branch.

- `grm()`: `git rm ...`.

- `grbc()`: `git rebase --continue`.

- `grba()`: `git rebase --abort`.

- `grbs()`: `git rebase --skip`.

- `grbm()`: `git rebase gitr_default_br()`.

- `grv()`: `git remote -v`.

## Examples

``` r
if (FALSE) { # \dontrun{
  glog()
} # }
```
