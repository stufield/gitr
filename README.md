
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The `gitr` Package

<!-- badges: start -->

![GitHub
version](https://img.shields.io/badge/Version-0.0.1.9000-success.svg?style=flat&logo=github)
[![CRAN
status](http://www.r-pkg.org/badges/version/gitr)](https://cran.r-project.org/package=gitr)
[![R-CMD-check](https://github.com/stufield/gitr/workflows/R-CMD-check/badge.svg)](https://github.com/stufield/gitr/actions)
[![](https://cranlogs.r-pkg.org/badges/grand-total/gitr)](https://cran.r-project.org/package=gitr)
[![Codecov test
coverage](https://codecov.io/gh/stufield/gitr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/stufield/gitr?branch=main)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://choosealicense.com/licenses/mit/)
<!-- badges: end -->

## Overview

A light-weight, dependency-free, application programming interface (API)
to access system-level [Git](https://git-scm.com/downloads) commands
from within `R`. Contains wrappers and defaults for common data science
workflows as well as [Zsh](https://github.com/ohmyzsh/ohmyzsh) plugin
aliases (see below). A generalized API syntax is also available. A
system installation of [Git](https://git-scm.com/downloads) is required.

If you run into any issues/problems with `gitr` full documentation of
the most recent [release](https://github.com/stufield/gitr/releases) can
be found at the [pkgdown website](https://stufield.github.io/gitr/). If
the issue persists I encourage you to consult the
[issues](https://github.com/stufield/gitr/issues/) page and, if
appropriate, submit an issue and/or feature request.

## Disclaimer

Use at own risk :smiley_cat:, however, PRs are encouraged for ideas that
I’ve missed. The functionality contained in `gitr` are *heavily*
influenced by **my** personal data science workflows and may not suit
all users. However, if you have an idea that would make the package
better, more widely usable, and/or efficient, please submit an
[issue](https://github.com/stufield/gitr/issues/) or [pull
request](https://github.com/stufield/gitr/pulls/).

## Installation

The easiest way to install `gitr` is to install directly from CRAN:

``` r
install.packages("gitr")
```

Alternatively install the development version from GitHub:

``` r
remotes::install_github("stufield/gitr")
```

To install a *specific* tagged release, use:

``` r
remotes::install_github("stufield/gitr@v0.0.1")
```

------------------------------------------------------------------------

## Load

``` r
library(gitr)
```

## Example

Here are some basic examples of the functionality grouped by common
actions:

#### Basics

``` r
git_version()
#> [1] "2.39.1"
```

``` r
git_current_br()
#> [1] "main"
```

``` r
git_default_br()
#> [1] "main"
```

#### Core Engine

``` r
(git("branch", "foo"))
#> Running git branch foo
#> $status
#> [1] 0
#> 
#> $stdout
#> [1] ""
#> 
#> $stderr
#> [1] ""

git("branch", "-av")$stdout |>
  cat(sep = "\n")
#> Running git branch -av 
#>   foo                          06ee33e Minor tweak to trim_sha() and export is_sha()
#> * main                         06ee33e Minor tweak to trim_sha() and export is_sha()
#>   remotes/origin/gh-pages      dd2529d Built site for gitr: 0.0.1@5e98f89
#>   remotes/origin/main          06ee33e Minor tweak to trim_sha() and export is_sha()
#>   remotes/origin/prep-for-cran bb5a9bf Clean up URLs
#>   remotes/origin/submit-cran   378ef59 Increment version number to 0.0.1

git("branch", "-D", "foo")$stdout
#> Running git branch -D foo
#> [1] "Deleted branch foo (was 06ee33e)."
```

#### Commits

``` r
get_commit_msgs(n = 3)
#> Running git log --format=%H -n 3
#> [[1]]
#> [1] "Minor tweak to trim_sha() and export is_sha()"   
#> [2] ""                                                
#> [3] "- now returns 'sha' if not a sha or empty string"
#> [4] "- new function `is_sha()`"                       
#> [5] "- added new unit tests"                          
#> [6] "- fixes #9"                                      
#> [7] ""                                                
#> attr(,"sha")
#> [1] "06ee33e"
#> attr(,"author")
#> [1] "stu.g.field@gmail.com"
#> 
#> [[2]]
#> [1] "Tweak DESCRIPTION and README.Rmd pkg descriptions"
#> [2] ""                                                 
#> [3] "- added new link to 'Zsh'"                        
#> [4] ""                                                 
#> attr(,"sha")
#> [1] "e2789f3"
#> attr(,"author")
#> [1] "stu.g.field@gmail.com"
#> 
#> [[3]]
#> [1] "Update README badge"         ""                            "- add new 'downloads' badge"
#> [4] ""                           
#> attr(,"sha")
#> [1] "8f19ea7"
#> attr(,"author")
#> [1] "stu.g.field@gmail.com"
```

``` r
glog(5)
#> Running git log --oneline --graph --decorate -n 5 
#> * 06ee33e (HEAD -> main, origin/main) Minor tweak to trim_sha() and export is_sha()
#> * e2789f3 Tweak DESCRIPTION and README.Rmd pkg descriptions
#> * 8f19ea7 Update README badge
#> * aa7333d Update PR template
#> * d15f3f8 Increment version number to 0.0.1.9000
```

``` r
git_diffcommits()
#> Running git diff HEAD~2..HEAD~1 
#> diff --git a/DESCRIPTION b/DESCRIPTION
#> index 1f59fde..28fdc29 100644
#> --- a/DESCRIPTION
#> +++ b/DESCRIPTION
#> @@ -9,9 +9,10 @@ Authors@R: c(
#>             comment = c(ORCID = "0000-0002-1024-5859"))
#>      )
#>  Description: A light-weight, dependency-free, application programming interface
#> -    (API) to access system-level 'Git' commands from within 'R'. Contains wrappers
#> -    and defaults for common data science workflows as well as
#> -    'Zsh' plugin aliases. A generalized API syntax is also available.
#> +    (API) to access system-level 'Git' commands from within 'R'.
#> +    Contains wrappers and defaults for common data science workflows as well as
#> +    'Zsh' <https://github.com/ohmyzsh/ohmyzsh> plugin aliases.
#> +    A generalized API syntax is also available.
#>      A system installation of 'Git' <https://git-scm.com/downloads> is required.
#>  License: MIT + file LICENSE
#>  URL: https://stufield.github.io/gitr/
#> diff --git a/README.Rmd b/README.Rmd
#> index adf598d..d8a6e67 100644
#> --- a/README.Rmd
#> +++ b/README.Rmd
#> @@ -33,12 +33,13 @@ ver <- paste0("https://img.shields.io/badge/Version-", ver,
#>  
#>  ## Overview
#>  
#> -A light-weight, dependency-free, API to access system-level git
#> -commands from within R.
#> -It contains wrappers and defaults for common data science workflows as well as
#> -[Z-shell](https://github.com/ohmyzsh/ohmyzsh) and it's plugins (see below).
#> -Generalized API syntax is also available.
#> -A system installation of git is required.
#> +A light-weight, dependency-free, application programming interface
#> +(API) to access system-level [Git](https://git-scm.com/downloads) commands from within `R`.
#> +Contains wrappers and defaults for common data science workflows as well as
#> +[Zsh](https://github.com/ohmyzsh/ohmyzsh) plugin aliases (see below).
#> +A generalized API syntax is also available.
#> +A system installation of [Git](https://git-scm.com/downloads) is required.
#> +
#>  
#>  If you run into any issues/problems with `gitr` full documentation
#>  of the most recent
#> diff --git a/man/gitr-package.Rd b/man/gitr-package.Rd
#> index c890a20..abd2858 100644
#> --- a/man/gitr-package.Rd
#> +++ b/man/gitr-package.Rd
#> @@ -6,7 +6,7 @@
#>  \alias{gitr-package}
#>  \title{gitr: A Lightweight API for 'Git'}
#>  \description{
#> -A light-weight, dependency-free, application programming interface (API) to access system-level 'Git' commands from within 'R'. Contains wrappers and defaults for common data science workflows as well as 'Zsh' plugin aliases. A generalized API syntax is also available. A system installation of 'Git' \url{https://git-scm.com/downloads} is required.
#> +A light-weight, dependency-free, application programming interface (API) to access system-level 'Git' commands from within 'R'. Contains wrappers and defaults for common data science workflows as well as 'Zsh' \url{https://github.com/ohmyzsh/ohmyzsh} plugin aliases. A generalized API syntax is also available. A system installation of 'Git' \url{https://git-scm.com/downloads} is required.
#>  }
#>  \seealso{
#>  Useful links:
```

``` r
git_reset_hard()
```

``` r
git_reset_soft()
```

``` r
git_uncommit()
```

``` r
git_unstage("DESCRIPTION")
```

#### SHA1

``` r
is_sha("d670c93733f3e1d7c95df7f61ebf6ca0476f14e3")
#> [1] TRUE

is_sha("foo")
#> [1] FALSE

trim_sha("d670c93733f3e1d7c95df7f61ebf6ca0476f14e3")
#> [1] "d670c93"

trim_sha("foo")
#> [1] "foo"
```

#### Tags

``` r
git_recent_tag()
#> Running git tag -n
#> [1] "v0.0.1"
```

``` r
git_tag_info()
#>           tag tag_sha target_sha           message    author                   email        user
#> v0.0.1 v0.0.1 fc7e99a    5e98f89 Release of v0.0.1 Stu Field <stu.g.field@gmail.com> stu.g.field
#>                               tagdate size                              path
#> v0.0.1 Wed Feb 15 12:53:58 2023 -0700  148 /Users/runner/work/gitr/gitr/.git
```

#### Situation Report

``` r
git_sitrep()
#> Using Git version: 2.39.1 
#> 
#> Current branch: main
#> Default branch: main 
#> 
#> Repo status:
#> Running git status -s 
#> 
#> 
#> Branches:
#> Running git branch -a 
#> * main
#>   remotes/origin/gh-pages
#>   remotes/origin/main
#>   remotes/origin/prep-for-cran
#>   remotes/origin/submit-cran
#> 
#> Local status:
#> ✓ OK
#> 
#> Upstream remotes: origin 
#> * main 06ee33e [origin/main] Minor tweak to trim_sha() and export is_sha()
#> 
#> Commit log: main 
#> Running git log --oneline --graph --decorate -n 5 
#> * 06ee33e (HEAD -> main, origin/main) Minor tweak to trim_sha() and export is_sha()
#> * e2789f3 Tweak DESCRIPTION and README.Rmd pkg descriptions
#> * 8f19ea7 Update README badge
#> * aa7333d Update PR template
#> * d15f3f8 Increment version number to 0.0.1.9000
```

------------------------------------------------------------------------

## ZSH-aliases available in `gitr`

| alias             | git command                                 |
|:------------------|:--------------------------------------------|
| `ga()`            | `git add`                                   |
| `gst()`           | `git status`                                |
| `gss()`           | `git status -s`                             |
| `gau()`           | `git add -u`                                |
| `gaa()`           | `git add --all`                             |
| `gb()`            | `git branch`                                |
| `gba()`           | `git branch -a`                             |
| `gbd()`           | `git branch -d/-D`                          |
| `gdf()`           | `git diff <file>`                           |
| `gbnm()`          | `git branch --no-merged`                    |
| `gbmm()`          | `git branch --merged`                       |
| `gbr()`           | `git branch --remote`                       |
| `gac()`, `gcn`    | `git commit --no-verify --no-edit --amend`  |
| `gcc()`           | `git commit`                                |
| `gco()`           | `git checkout`                              |
| `gcb()`           | `git checkout -b`                           |
| `gcm()`           | `git checkout git_default_br()`             |
| `gcf()`           | `git config --list`                         |
| `gnuke()`         | `git reset --hard && git clean -dfx`        |
| `gcmsg()`         | `git commit -m`                             |
| `gp()`            | `git push`                                  |
| `gpu()`           | `git push -u`                               |
| `gpd()`           | `git push --dry-run`                        |
| `gpf()`           | `git push --force-with-lease`               |
| `gpr()`           | `git pull --rebase --autostash -v`          |
| `glog()`          | `git log --oneline --decorate --graph`      |
| `gwip()`          | `git add -u && commit --no-verify -m "wip"` |
| `gclean()`        | `git clean -f -d`                           |
| `grm()`           | `git rm`                                    |
| `grmc()`          | `git rm --cached`                           |
| `gsta()`          | `git stash`                                 |
| `gstl()`          | `git stash list`                            |
| `gpop()`,`gstp()` | `git stash pop`                             |
| `gstaa()`         | `git stash apply`                           |
| `gstd()`          | `git stash drop`                            |
| `gstc()`          | `git stash clear`                           |
| `gsts()`          | `git stash show --text`                     |
| `gtn()`           | `git tag -n`                                |
| `grba()`          | `git rebase --abort`                        |
| `grbc()`          | `git rebase --continue`                     |
| `grbs()`          | `git rebase --skip`                         |
| `grbm()`          | `git rebase git_default_br()`               |
| `grv()`           | `git remote -v`                             |

------------------------------------------------------------------------

## Full list of ZSH-aliases

For general reference, here is a list of the available aliases via the
`git-plugin` from [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh).

See also [Oh-My-Zsh](https://ohmyz.sh) for general installation.

#### Aliases

| alias                             | git command                                                                                                                                             |
|:----------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `gapa`                            | `git add --patch`                                                                                                                                       |
| `gav`                             | `git add --verbose`                                                                                                                                     |
| `gloga`                           | `git log --oneline --decorate --graph --all`                                                                                                            |
| `gup`                             | `git pull --rebase`                                                                                                                                     |
| `gupv`                            | `git pull --rebase -v`                                                                                                                                  |
| `gupa`                            | `git pull --rebase --autostash`                                                                                                                         |
| `gupav`                           | `git pull --rebase --autostash -v`                                                                                                                      |
| `gap`                             | `git apply`                                                                                                                                             |
| `gapt`                            | `git apply --3way`                                                                                                                                      |
| `gbda`                            | `git branch --no-color --merged | command grep -vE ^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$) | command xargs git branch -d 2>/dev/null` |
| `gbl`                             | `git blame -b -w`                                                                                                                                       |
| `gbs`                             | `git bisect`                                                                                                                                            |
| `gbsb`                            | `git bisect bad`                                                                                                                                        |
| `gbsg`                            | `git bisect good`                                                                                                                                       |
| `gbsr`                            | `git bisect reset`                                                                                                                                      |
| `gbss`                            | `git bisect start`                                                                                                                                      |
| `gca`                             | `git commit -v -a`                                                                                                                                      |
| `gca!`                            | `git commit -v -a --amend`                                                                                                                              |
| `gcan!`                           | `git commit -v -a --no-edit --amend`                                                                                                                    |
| `gcans!`                          | `git commit -v -a -s --no-edit --amend`                                                                                                                 |
| `gcam`                            | `git commit -a -m`                                                                                                                                      |
| `gcsm`                            | `git commit -s -m`                                                                                                                                      |
| `gcas`                            | `git commit -a -s`                                                                                                                                      |
| `gcasm`                           | `git commit -a -s -m`                                                                                                                                   |
| `gcl`                             | `git clone --recurse-submodules`                                                                                                                        |
| `gcor`                            | `git checkout --recurse-submodules`                                                                                                                     |
| `gcd`                             | `git checkout $(git_develop_branch)`                                                                                                                    |
| `gcount`                          | `git shortlog -sn`                                                                                                                                      |
| `gcp`                             | `git cherry-pick`                                                                                                                                       |
| `gcpa`                            | `git cherry-pick --abort`                                                                                                                               |
| `gcpc`                            | `git cherry-pick --continue`                                                                                                                            |
| `gcs`                             | `git commit -S`                                                                                                                                         |
| `gcss`                            | `git commit -S -s`                                                                                                                                      |
| `gcssm`                           | `git commit -S -s -m`                                                                                                                                   |
| `gdca`                            | `git diff --cached`                                                                                                                                     |
| `gdcw`                            | `git diff --cached --word-diff`                                                                                                                         |
| `gdct`                            | `git describe --tags \$(git rev-list --tags --max-count=1)`                                                                                             |
| `gds`                             | `git diff --staged`                                                                                                                                     |
| `gdt`                             | `git diff-tree --no-commit-id --name-only -r`                                                                                                           |
| `gdup`                            | `git diff @{upstream}`                                                                                                                                  |
| `gdw`                             | `git diff --word-diff`                                                                                                                                  |
| `gf`                              | `git fetch`                                                                                                                                             |
| `gfo`                             | `git fetch origin`                                                                                                                                      |
| `gfg`                             | `git ls-files \| grep`                                                                                                                                  |
| `gg`                              | `git gui citool`                                                                                                                                        |
| `gga`                             | `git gui citool --amend`                                                                                                                                |
| `ggpur`                           | `ggu`                                                                                                                                                   |
| `ggpull`                          | `git pull origin \$(git_current_branch)`                                                                                                                |
| `ggpush`                          | `git push origin \$(git_current_branch)`                                                                                                                |
| `ggsup`                           | `git branch --set-upstream-to=origin/$(git_current_branch)`                                                                                             |
| `gpsup`                           | `git push --set-upstream origin \$(git_current_branch)`                                                                                                 |
| `ghh`                             | `git help`                                                                                                                                              |
| `gignore`                         | `git update-index --assume-unchanged`                                                                                                                   |
| `gignored`                        | `git ls-files -v | grep "^[[:lower:]]"`                                                                                                                 |
| `git-svn-dcommit-push`            | `git svn dcommit && git push github \$(git_main_branch):svntrunk`                                                                                       |
| `gl`                              | `git pull`                                                                                                                                              |
| `glg`                             | `git log --stat`                                                                                                                                        |
| `glgp`                            | `git log --stat -p`                                                                                                                                     |
| `glgg`                            | `git log --graph`                                                                                                                                       |
| `glgga`                           | `git log --graph --decorate --all`                                                                                                                      |
| `glgm`                            | `git log --graph --max-count=10`                                                                                                                        |
| `glo`                             | `git log --oneline --decorate`                                                                                                                          |
| `glol`                            | `git log --graph --pretty`                                                                                                                              |
| `glols="git log --graph --pretty` | `%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"`                                                                  |
| `glod="git log --graph --pretty`  | `%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"`                                                                         |
| `glods="git log --graph --pretty` | `%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"`                                                            |
| `glola="git log --graph --pretty` | `%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"`                                                                   |
| `gm`                              | `git merge`                                                                                                                                             |
| `gmom`                            | `git merge origin/$(git_main_branch)`                                                                                                                   |
| `gmtl`                            | `git mergetool --no-prompt`                                                                                                                             |
| `gmtlvim`                         | `git mergetool --no-prompt --tool=vimdiff`                                                                                                              |
| `gmum`                            | `git merge upstream/\$(git_main_branch)`                                                                                                                |
| `gma`                             | `git merge --abort`                                                                                                                                     |
| `gpf!`                            | `git push --force`                                                                                                                                      |
| `gpoat`                           | `git push origin --all && git push origin --tags`                                                                                                       |
| `gpv`                             | `git push -v`                                                                                                                                           |
| `gr`                              | `git remote`                                                                                                                                            |
| `gra`                             | `git remote add`                                                                                                                                        |
| `grb`                             | `git rebase`                                                                                                                                            |
| `grbd`                            | `git rebase \$(git_develop_branch)`                                                                                                                     |
| `grbi`                            | `git rebase -i`                                                                                                                                         |
| `grbo`                            | `git rebase --onto`                                                                                                                                     |
| `grev`                            | `git revert`                                                                                                                                            |
| `grh`                             | `git reset`                                                                                                                                             |
| `grhh`                            | `git reset --hard`                                                                                                                                      |
| `groh`                            | `git reset origin/\$(git_current_branch) --hard`                                                                                                        |
| `grmv`                            | `git remote rename`                                                                                                                                     |
| `grrm`                            | `git remote remove`                                                                                                                                     |
| `grs`                             | `git restore`                                                                                                                                           |
| `grset`                           | `git remote set-url`                                                                                                                                    |
| `grss`                            | `git restore --source`                                                                                                                                  |
| `grst`                            | `git restore --staged`                                                                                                                                  |
| `grt`                             | `cd \$(git rev-parse --show-toplevel \|\| echo .)`                                                                                                      |
| `gru`                             | `git reset --`                                                                                                                                          |
| `grup`                            | `git remote update`                                                                                                                                     |
| `gsb`                             | `git status -sb`                                                                                                                                        |
| `gsd`                             | `git svn dcommit`                                                                                                                                       |
| `gsh`                             | `git show`                                                                                                                                              |
| `gsi`                             | `git submodule init`                                                                                                                                    |
| `gsps`                            | `git show --pretty=short --show-signature`                                                                                                              |
| `gsr`                             | `git svn rebase`                                                                                                                                        |
| `gstu`                            | `gsta --include-untracked`                                                                                                                              |
| `gstall`                          | `git stash --all`                                                                                                                                       |
| `gsu`                             | `git submodule update`                                                                                                                                  |
| `gsw`                             | `git switch`                                                                                                                                            |
| `gswc`                            | `git switch -c`                                                                                                                                         |
| `gswm`                            | `git switch $(git_main_branch)`                                                                                                                         |
| `gswd`                            | `git switch $(git_develop_branch)`                                                                                                                      |
| `gts`                             | `git tag -s`                                                                                                                                            |
| `gtv`                             | `git tag | sort -V`                                                                                                                                     |
| `gtl`                             | `gtl(){ git tag --sort=-v:refname -n -l ${1}* }; noglob gtl`                                                                                            |
| `gunignore`                       | `git update-index --no-assume-unchanged`                                                                                                                |
| `gunwip`                          | `git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1`                                                                                           |
| `glum`                            | `git pull upstream \$(git_main_branch)`                                                                                                                 |
| `gwch`                            | `git whatchanged -p --abbrev-commit --pretty=medium`                                                                                                    |
| `gam`                             | `git am`                                                                                                                                                |
| `gamc`                            | `git am --continue`                                                                                                                                     |
| `gams`                            | `git am --skip`                                                                                                                                         |
| `gama`                            | `git am --abort`                                                                                                                                        |
| `gamscp`                          | `git am --show-current-patch`                                                                                                                           |

#### LICENSE

Please note that this package package is released with a
[LICENSE](https://github.com/stufield/gitr/blob/main/LICENSE.md). By
using in this package you agree to abide by its terms.

------------------------------------------------------------------------

Created by [Rmarkdown](https://github.com/rstudio/rmarkdown) (v2.20) and
R version 4.2.2 (2022-10-31).
