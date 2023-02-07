
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The `gitr` Package

<!-- badges: start -->
<!-- badges: end -->

A light-weight, dependency-free, API to access system-level ‘git’
commands from within `R`. It contains wrappers and defaults for common
data science workflows as well as
[Z-shell](https://github.com/ohmyzsh/ohmyzsh) and it’s plugins (see
below). Generalized API syntax is also available. A system installation
of ‘git’ is required.

## Disclaimer

Use at own risk :smiley\_cat:, however, PRs are encouraged for ideas
that I’ve missed. The functionality contained in `gitr` are *heavily*
influenced by **my** personal data scienct workflows and may not suit
all users. However, if you have an idea that would make the package
better, more widely usable, and/or efficient, please submit an
[issue](https://github.com/SomaLogic/SomaDataIO/issues/) or [Pull
Request](https://github.com/SomaLogic/SomaDataIO/pulls/).

## Installation

Currently you can only install development version of `gitr` via:

``` r
remotes::install_github("stufield/gitr")
```

------------------------------------------------------------------------

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(gitr)
```

``` r
git_default_br()
#> [1] "main"
```

``` r
git_current_br()
#> [1] "main"
```

``` r
git_version()
#> [1] "2.39.0"
```

``` r
glog()
#> Running git log --oneline --graph --decorate -n 10 
#> * cfdd08f (HEAD -> main) Add new `git_uncommit()` wrapper
#> * 7f9be14 Upgrades to new roxygen2 version v7.2.3
#> * e575d97 (origin/main, origin/HEAD) Add generalized Makefile
#> * 05048c8 Clean up README
#> * 71c4e7b Name change `gc()` -> `gcc()` to avoid mask
#> * 066deb5 Move away from assuming `master` as default branch
#> * 8bb1f36 Clean up coloring for non-interactive sessions
#> * 549cb14 Bugfix in `git_default_br()`
#> * 3e3afd3 Add new `git_tag_info()`
#> * 5c2ec81 Rename get_recent_tag() -> git_recent_tag()
```

``` r
git_sitrep()
#> Using Git version: 2.39.0 
#> 
#> Current Branch: main 
#> 
#> Default Branch: main 
#> 
#> Branches:
#> Running git branch -a 
#> * main
#>   testbr
#>   remotes/origin/HEAD -> origin/main
#>   remotes/origin/main
#>   remotes/origin/testbr
#> 
#> Repo status:
#> Running git status -s 
#>  M DESCRIPTION
#>  M LICENSE.md
#>  M README.Rmd
#> ?? inst/
#> 
#> Upstream remote:
#>   branch ahead behind
#> 1   main     2      0
#> 2 testbr     2     12
#> 
#> Commit main Log:
#> Running git log --oneline --graph --decorate -n 5 
#> * cfdd08f (HEAD -> main) Add new `git_uncommit()` wrapper
#> * 7f9be14 Upgrades to new roxygen2 version v7.2.3
#> * e575d97 (origin/main, origin/HEAD) Add generalized Makefile
#> * 05048c8 Clean up README
#> * 71c4e7b Name change `gc()` -> `gcc()` to avoid mask
```

------------------------------------------------------------------------

## ZSH-aliases available in `gitr`

| alias               | git command                              |
|:--------------------|:-----------------------------------------|
| `ga()`              | git add                                  |
| `gst()`             | git status                               |
| `gss()`             | git status -s                            |
| `gau()`             | git add -u                               |
| `gaa()`             | git add –all                             |
| `gb()`              | git branch                               |
| `gba()`             | git branch -a                            |
| `gbd()`             | git branch -d/-D                         |
| `gdf()`             | git diff <file>                          |
| `gbnm()`            | git branch –no-merged                    |
| `gbmm()`            | git branch –merged                       |
| `gbr()`             | git branch –remote                       |
| `gac()`, `gcn`      | git commit –no-verify –no-edit –amend    |
| `gcc()`             | git commit                               |
| `gco()`             | git checkout                             |
| `gcb()`             | git checkout -b                          |
| `gcm()`             | git checkout `git_default_br()`          |
| `gcf()`             | git config –list                         |
| `gnuke()`,gpristine | git reset –hard && git clean -dfx        |
| `gcmsg()`           | git commit -m                            |
| `gp()`              | git push                                 |
| `gpu()`             | git push -u                              |
| `gpd()`             | git push –dry-run                        |
| `gpf()`             | git push –force-with-lease               |
| `gpr()`             | git pull –rebase –autostash -v           |
| `glog()`            | git log –oneline –decorate –graph        |
| `gwip()`            | git add -u && commit –no-verify -m “wip” |
| `gclean()`          | git clean -f -d                          |
| `grm()`             | git rm                                   |
| `grmc()`            | git rm –cached                           |
| `gsta()`            | git stash                                |
| `gstl()`            | git stash list                           |
| `gpop()`,`gstp()`   | git stash pop                            |
| `gstaa()`           | git stash apply                          |
| `gstd()`            | git stash drop                           |
| `gstc()`            | git stash clear                          |
| `gsts()`            | git stash show `--text`                  |
| `gtn()`             | git tag -n                               |
| `grba()`            | git rebase –abort                        |
| `grbc()`            | git rebase –continue                     |
| `grbs()`            | git rebase –skip                         |
| `grbm()`            | git rebase `git_default_br()`            |
| `grv()`             | git remote -v                            |

------------------------------------------------------------------------

## Full list of ZSH-aliases

For general reference, here is a list of the available aliases via the
`git-plugin` from [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh).

See also [Oh-My-Zsh](https://ohmyz.sh) for general installation.

| alias                         | git command                                                                                     |
|:------------------------------|:------------------------------------------------------------------------------------------------|
| gapa                          | git add –patch                                                                                  |
| gav                           | git add –verbose                                                                                |
| gloga                         | git log –oneline –decorate –graph –all                                                          |
| gup                           | git pull –rebase                                                                                |
| gupv                          | git pull –rebase -v                                                                             |
| gupa                          | git pull –rebase –autostash                                                                     |
| gupav                         | git pull –rebase –autostash -v                                                                  |
| gap                           | git apply                                                                                       |
| gapt                          | git apply –3way’                                                                                |
| gbda                          | git branch –no-color –merged                                                                    |
| gpsup                         | git push –set-upstream origin \$(git\_current\_branch)                                          |
| ghh                           | git help                                                                                        |
| gignore                       | git update-index –assume-unchanged                                                              |
| gignored                      | git ls-files -v                                                                                 |
| git-svn-dcommit-push          | git svn dcommit && git push github \$(git\_main\_branch):svntrunk                               |
| gk                            | –all –branches &!                                                                               |
| gke                           | –all \$(git log -g –pretty=%h) &!                                                               |
| gl                            | git pull                                                                                        |
| glg                           | git log –stat                                                                                   |
| glgp                          | git log –stat -p                                                                                |
| glgg                          | git log –graph                                                                                  |
| glgga                         | git log –graph –decorate –all                                                                   |
| glgm                          | git log –graph –max-count=10                                                                    |
| glo                           | git log –oneline –decorate                                                                      |
| glol                          | git log –graph –pretty                                                                          |
| glols="git log –graph –pretty | %Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)&lt;%an&gt;%Creset’ –stat"       |
| glod="git log –graph –pretty  | %Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)&lt;%an&gt;%Creset’"             |
| glods="git log –graph –pretty | %Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)&lt;%an&gt;%Creset’ –date=short" |
| glola="git log –graph –pretty | %Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)&lt;%an&gt;%Creset’ –all"        |
| gm                            | git merge                                                                                       |
| gmom                          | git merge origin/\$(git\_main\_branch)                                                          |
| gmtl                          | git mergetool –no-prompt                                                                        |
| gmtlvim                       | git mergetool –no-prompt –tool=vimdiff                                                          |
| gmum                          | git merge upstream/\$(git\_main\_branch)                                                        |
| gma                           | git merge –abort                                                                                |
| gpf!                          | git push –force                                                                                 |
| gpoat                         | git push origin –all && git push origin –tags                                                   |
| gpv                           | git push -v                                                                                     |
| gr                            | git remote                                                                                      |
| gra                           | git remote add                                                                                  |
| grb                           | git rebase                                                                                      |
| grbd                          | git rebase \$(git\_develop\_branch)                                                             |
| grbi                          | git rebase -i                                                                                   |
| grbo                          | git rebase –onto                                                                                |
| grev                          | git revert                                                                                      |
| grh                           | git reset                                                                                       |
| grhh                          | git reset –hard                                                                                 |
| groh                          | git reset origin/\$(git\_current\_branch) –hard                                                 |
| grmv                          | git remote rename                                                                               |
| grrm                          | git remote remove                                                                               |
| grs                           | git restore                                                                                     |
| grset                         | git remote set-url                                                                              |
| grss                          | git restore –source                                                                             |
| grst                          | git restore –staged                                                                             |
| grt                           | cd \$(git rev-parse –show-toplevel \|\| echo .)                                                 |
| gru                           | git reset –                                                                                     |
| grup                          | git remote update                                                                               |
| gsb                           | git status -sb                                                                                  |
| gsd                           | git svn dcommit                                                                                 |
| gsh                           | git show                                                                                        |
| gsi                           | git submodule init                                                                              |
| gsps                          | git show –pretty=short –show-signature                                                          |
| gsr                           | git svn rebase                                                                                  |
| gstu                          | gsta –include-untracked                                                                         |
| gstall                        | git stash –all                                                                                  |
| gsu                           | git submodule update                                                                            |
| gsw                           | git switch                                                                                      |
| gswc                          | git switch -c                                                                                   |
| gswm                          | git switch \$(git\_main\_branch)                                                                |
| gswd                          | git switch \$(git\_develop\_branch)                                                             |
| gts                           | git tag -s                                                                                      |
| gtv                           | git tag                                                                                         |
| gtl                           | gtl(){ git tag –sort=-v:refname -n -l \${1}\* }; noglob gtl                                     |
| gunignore                     | git update-index –no-assume-unchanged                                                           |
| gunwip                        | git log -n 1                                                                                    |
| glum                          | git pull upstream \$(git\_main\_branch)                                                         |
| gwch                          | git whatchanged -p –abbrev-commit –pretty=medium                                                |
| gam                           | git am                                                                                          |
| gamc                          | git am –continue                                                                                |
| gams                          | git am –skip                                                                                    |
| gama                          | git am –abort                                                                                   |
| gamscp                        | git am –show-current-patch                                                                      |

#### LICENSE

Please note that this package package is released with a
[LICENSE](LICENSE). By using in this package you agree to abide by its
terms.

------------------------------------------------------------------------

Created by [Rmarkdown](https://github.com/rstudio/rmarkdown) (v2.20) and
R version 4.2.2 (2022-10-31).
