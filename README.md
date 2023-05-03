
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gitr

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

## Installing

The easiest way to install `gitr` is to install directly from
[CRAN](https://cran.r-project.org/web/packages/gitr/index.html):

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

## Loading

``` r
library(gitr)
```

## Examples

Here are some basic examples of the functionality grouped by common
actions:

#### Basics

``` r
git_version()
#> [1] "2.39.0"
```

``` r
git_current_br()
#> [1] "main"
```

``` r
git_default_br()
#> [1] "main"
```

#### The Core Engine

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
#>   foo                                    dbca034 Re-build README.Rmd
#> * main                                   dbca034 Re-build README.Rmd
#>   remotes/origin/HEAD                    -> origin/main
#>   remotes/origin/bugfix-get-pr-sha       ce27db7 Fix bug in get_pr_sha() (#11)
#>   remotes/origin/gh-pages                334a885 Built site for gitr: 0.0.1@68b3652
#>   remotes/origin/main                    dbca034 Re-build README.Rmd
#>   remotes/origin/pkgdown-update          9466ecd wip
#>   remotes/origin/prep-for-cran           bb5a9bf Clean up URLs
#>   remotes/origin/submit-cran             378ef59 Increment version number to 0.0.1
#>   remotes/origin/update-pkgdown-new-look 0018001 Update GHAs

git("branch", "-D", "foo")$stdout
#> Running git branch -D foo
#> [1] "Deleted branch foo (was dbca034)."
```

#### Committing

``` r
get_commit_msgs(n = 3)
#> Running git log --format=%H -n 3
#> [[1]]
#> [1] "Re-build README.Rmd" ""                   
#> attr(,"sha")
#> [1] "dbca034"
#> attr(,"author")
#> [1] "stufield@users.noreply.github.com"
#> 
#> [[2]]
#> [1] "Remove rmarkdown footer for README and vignette"
#> [2] ""                                               
#> attr(,"sha")
#> [1] "185ebb6"
#> attr(,"author")
#> [1] "stu.g.field@gmail.com"
#> 
#> [[3]]
#> [1] "Update DESCRIPTION with tidytemplate Needs" ""                                          
#> attr(,"sha")
#> [1] "d6cbbb9"
#> attr(,"author")
#> [1] "stu.g.field@gmail.com"
```

``` r
glog(5)
#> Running git log --oneline --graph --decorate -n 5 
#> * dbca034 (HEAD -> main, origin/main, origin/HEAD) Re-build README.Rmd
#> * 185ebb6 Remove rmarkdown footer for README and vignette
#> * d6cbbb9 Update DESCRIPTION with tidytemplate Needs
#> * 0ae6d0c New pkgdown tidy theme and bootstrap 5
#> * 9d669f2 Improve GHA triggers
```

``` r
git_diffcommits()
#> Running git diff HEAD~2..HEAD~1 
#> diff --git a/Makefile b/Makefile
#> index d45a1e8..d7d9d37 100644
#> --- a/Makefile
#> +++ b/Makefile
#> @@ -13,13 +13,12 @@ RSCRIPT = Rscript --vanilla
#>  all: check clean
#>  
#>  roxygen:
#> -    @ $(RSCRIPT) \
#> -    -e "devtools::document(roclets = c('rd', 'collate', 'namespace'))"
#> +    @ $(RSCRIPT) -e "roxygen2::roxygenise()"
#>  
#>  readme:
#> -    @ echo "Rendering README.Rmd"
#>      @ $(RSCRIPT) \
#> -    -e "Sys.setenv(RSTUDIO_PANDOC='/Applications/RStudio.app/Contents/MacOS/pandoc')" \
#> +    -e "Sys.setenv(RSTUDIO_PANDOC='/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools')" \
#> +    -e "options(cli.width = 80L)" \
#>      -e "rmarkdown::render('README.Rmd', quiet = TRUE)"
#>      @ $(RM) README.html
#>  
#> @@ -45,11 +44,6 @@ check: build
#>      @ cd ..;\
#>      $(RCMD) check --no-manual $(PKGNAME)_$(PKGVERS).tar.gz
#>  
#> -install_deps:
#> -    @ $(RSCRIPT) \
#> -    -e "if (!requireNamespace('remotes')) install.packages('remotes')" \
#> -    -e "remotes::install_deps(dependencies = TRUE)"
#> -
#>  install:
#>      @ R CMD INSTALL --use-vanilla --preclean --resave-data .
#>  
#> diff --git a/README.Rmd b/README.Rmd
#> index 11f2282..ca663a8 100644
#> --- a/README.Rmd
#> +++ b/README.Rmd
#> @@ -18,7 +18,7 @@ ver <- paste0("https://img.shields.io/badge/Version-", ver,
#>                "-success.svg?style=flat&logo=github")
#>  ```
#>  
#> -# The `gitr` Package
#> +# gitr
#>  
#>  <!-- badges: start -->
#>  ![GitHub version](`r ver`)
#> @@ -31,8 +31,6 @@ ver <- paste0("https://img.shields.io/badge/Version-", ver,
#>  <!-- badges: end -->
#>  
#>  
#> -## Overview
#> -
#>  A light-weight, dependency-free, application programming interface
#>  (API) to access system-level [Git](https://git-scm.com/downloads) commands from within `R`.
#>  Contains wrappers and defaults for common data science workflows as well as
#> @@ -379,8 +377,3 @@ Please note that this package package is released with
#>  a [LICENSE](https://github.com/stufield/gitr/blob/main/LICENSE.md).
#>  By using in this package you agree to abide by its terms.
#>  
#> -
#> -----------
#> -
#> -Created by [Rmarkdown](https://github.com/rstudio/rmarkdown)
#> -(v`r utils::packageVersion("rmarkdown")`) and `r R.version$version.string`.
#> diff --git a/README.md b/README.md
#> index 790d1e9..9eb5fd1 100644
#> --- a/README.md
#> +++ b/README.md
#> @@ -1,7 +1,7 @@
#>  
#>  <!-- README.md is generated from README.Rmd. Please edit that file -->
#>  
#> -# The `gitr` Package
#> +# gitr
#>  
#>  <!-- badges: start -->
#>  
#> @@ -19,8 +19,6 @@ stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://
#>  MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://choosealicense.com/licenses/mit/)
#>  <!-- badges: end -->
#>  
#> -## Overview
#> -
#>  A light-weight, dependency-free, application programming interface (API)
#>  to access system-level [Git](https://git-scm.com/downloads) commands
#>  from within `R`. Contains wrappers and defaults for common data science
#> @@ -83,7 +81,7 @@ actions:
#>  
#>  ``` r
#>  git_version()
#> -#> [1] "2.39.2"
#> +#> [1] "2.39.0"
#>  ```
#>  
#>  ``` r
#> @@ -113,16 +111,21 @@ git_default_br()
#>  git("branch", "-av")$stdout |>
#>    cat(sep = "\n")
#>  #> Running git branch -av 
#> -#>   foo                          90eaa95 Tweak README.Rmd
#> -#> * main                         90eaa95 Tweak README.Rmd
#> -#>   remotes/origin/gh-pages      16f3e84 Built site for gitr: 0.0.1.9000@06ee33e
#> -#>   remotes/origin/main          90eaa95 Tweak README.Rmd
#> -#>   remotes/origin/prep-for-cran bb5a9bf Clean up URLs
#> -#>   remotes/origin/submit-cran   378ef59 Increment version number to 0.0.1
#> +#>   foo                                    d6cbbb9 Update DESCRIPTION with tidytemplate Needs
#> +#>   force-pkgdown                          72ad53a wip
#> +#> * main                                   d6cbbb9 Update DESCRIPTION with tidytemplate Needs
#> +#>   remotes/origin/HEAD                    -> origin/main
#> +#>   remotes/origin/bugfix-get-pr-sha       ce27db7 Fix bug in get_pr_sha() (#11)
#> +#>   remotes/origin/force-pkgdown           72ad53a wip
#> +#>   remotes/origin/gh-pages                be5ce29 Built site for gitr: 0.0.1@dbedad6
#> +#>   remotes/origin/main                    d6cbbb9 Update DESCRIPTION with tidytemplate Needs
#> +#>   remotes/origin/prep-for-cran           bb5a9bf Clean up URLs
#> +#>   remotes/origin/submit-cran             378ef59 Increment version number to 0.0.1
#> +#>   remotes/origin/update-pkgdown-new-look 0018001 Update GHAs
#>  
#>  git("branch", "-D", "foo")$stdout
#>  #> Running git branch -D foo
#> -#> [1] "Deleted branch foo (was 90eaa95)."
#> +#> [1] "Deleted branch foo (was d6cbbb9)."
#>  ```
#>  
#>  #### Committing
#> @@ -131,76 +134,80 @@ git("branch", "-D", "foo")$stdout
#>  get_commit_msgs(n = 3)
#>  #> Running git log --format=%H -n 3
#>  #> [[1]]
#> -#> [1] "Tweak README.Rmd" ""                
#> +#> [1] "Update DESCRIPTION with tidytemplate Needs" ""                                          
#>  #> attr(,"sha")
#> -#> [1] "90eaa95"
#> +#> [1] "d6cbbb9"
#>  #> attr(,"author")
#>  #> [1] "stu.g.field@gmail.com"
#>  #> 
#>  #> [[2]]
#> -#> [1] "Minor clean up of hooks" ""                       
#> +#> [1] "New pkgdown tidy theme and bootstrap 5" ""                                      
#>  #> attr(,"sha")
#> -#> [1] "b51b8a9"
#> +#> [1] "0ae6d0c"
#>  #> attr(,"author")
#>  #> [1] "stu.g.field@gmail.com"
#>  #> 
#>  #> [[3]]
#> -#> [1] "Re-build README.Rmd" ""                   
#> +#> [1] "Improve GHA triggers" ""                    
#>  #> attr(,"sha")
#> -#> [1] "8a015b2"
#> +#> [1] "9d669f2"
#>  #> attr(,"author")
#> -#> [1] "stufield@users.noreply.github.com"
#> +#> [1] "stu.g.field@gmail.com"
#>  ```
#>  
#>  ``` r
#>  glog(5)
#>  #> Running git log --oneline --graph --decorate -n 5 
#> -#> * 90eaa95 (HEAD -> main, origin/main) Tweak README.Rmd
#> -#> * b51b8a9 Minor clean up of hooks
#> -#> * 8a015b2 Re-build README.Rmd
#> -#> * 06ee33e Minor tweak to trim_sha() and export is_sha()
#> -#> * e2789f3 Tweak DESCRIPTION and README.Rmd pkg descriptions
#> +#> * d6cbbb9 (HEAD -> main, origin/main, origin/HEAD) Update DESCRIPTION with tidytemplate Needs
#> +#> * 0ae6d0c New pkgdown tidy theme and bootstrap 5
#> +#> * 9d669f2 Improve GHA triggers
#> +#> * 179896e fix test-coverage.yaml to upload to Codecov
#> +#> * 0d17278 correct .gitignore
#>  ```
#>  
#>  ``` r
#>  git_diffcommits()
#>  #> Running git diff HEAD~2..HEAD~1 
#> -#> diff --git a/inst/hooks/pre-commit b/inst/hooks/pre-commit
#> -#> index 44593b7..3648cac 100755
#> -#> --- a/inst/hooks/pre-commit
#> -#> +++ b/inst/hooks/pre-commit
#> -#> @@ -12,18 +12,8 @@ if (requireNamespace("spelling", quietly = TRUE) && file.exists("DESCRIPTION"))
#> -#>    }
#> -#>  }
#> +#> diff --git a/_pkgdown.yml b/_pkgdown.yml
#> +#> index 65a4632..a09b3e3 100644
#> +#> --- a/_pkgdown.yml
#> +#> +++ b/_pkgdown.yml
#> +#> @@ -1,13 +1,20 @@
#> +#>  url: https://github.com/stufield/gitr
#>  #>  
#> -#> -# check .lintr file
#> -#> -#if (git2r::in_repository()) {
#> -#> -# git_status <- git2r::status(staged = FALSE)
#> -#> -# if (any(unlist(git_status) == ".lintr")) {
#> -#> -#   stop("Unstaged changes to .lintr file. Stage the .lintr ",
#> -#> -#        "file or discard the changes to it. ", call. = FALSE)
#> -#> -# }
#> -#> -#}
#> -#> -
#> -#> -#files <- list.files("R", full.names = TRUE)
#> -#> -
#> -#>  # check lints
#> -#> +#files <- list.files("R", full.names = TRUE)
#> -#>  #lints <- lapply(files, function(path) {
#> -#>  #  lints <- somaverse::lintFile(path)
#> -#>  #  if (length(lints) > 0) {
#> -#> diff --git a/inst/hooks/prepare-commit-msg b/inst/hooks/prepare-commit-msg
#> -#> index 0d6e149..4948d5c 100755
#> -#> --- a/inst/hooks/prepare-commit-msg
#> -#> +++ b/inst/hooks/prepare-commit-msg
#> -#> @@ -26,7 +26,6 @@ SHA1=$3
#> +#> +development:
#> +#> +  mode: auto
#> +#> +
#> +#> +authors:
#> +#> +  Stu Field:
#> +#> +    href: https://github.com/stufield
#> +#> +
#> +#>  home:
#> +#> -  strip_header: true
#> +#>    links:
#> +#>    - text: Learn more about me
#> +#>      href: https://github.com/stufield
#>  #>  
#> -#>  echo "commit message file:"
#> -#>  echo $COMMIT_MSG_FILE
#> -#> -cat $COMMIT_MSG_FILE
#> +#>  template:
#> +#>    bootstrap: 5
#> +#> +  package: tidytemplate
#> +#>    bslib:
#> +#>      bg: "#202123"      # dark theme
#> +#>      fg: "#B8BCC2"      # dark theme
#> +#> @@ -16,13 +23,6 @@ template:
#> +#>      btn-border-radius: 0.25rem
#> +#>      base_font: {google: "Roboto"}
#>  #>  
#> -#>  echo "commit message source:"
#> -#>  echo $COMMIT_SOURCE
#> +#> -authors:
#> +#> -  Stu Field:
#> +#> -    href: https://github.com/stufield
#> +#> -
#> +#> -development:
#> +#> -  mode: auto
#> +#> -
#> +#>  articles:
#> +#>    - title: Getting Started
#> +#>      navbar: ~
#>  ```
#>  
#>  ``` r
#> @@ -247,44 +254,51 @@ git_recent_tag()
#>  git_tag_info()
#>  #>           tag tag_sha target_sha           message    author                   email        user
#>  #> v0.0.1 v0.0.1 fc7e99a    5e98f89 Release of v0.0.1 Stu Field <stu.g.field@gmail.com> stu.g.field
#> -#>                               tagdate size                              path
#> -#> v0.0.1 Wed Feb 15 12:53:58 2023 -0700  148 /Users/runner/work/gitr/gitr/.git
#> +#>                               tagdate size                       path
#> +#> v0.0.1 Wed Feb 15 12:53:58 2023 -0700  148 /Users/sfield/gh/gitr/.git
#>  ```
#>  
#>  #### Situation Report
#>  
#>  ``` r
#>  git_sitrep()
#> -#> Using Git version: 2.39.2 
#> +#> Using Git version: 2.39.0 
#>  #> 
#>  #> Current branch: main
#>  #> Default branch: main 
#>  #> 
#>  #> Repo status:
#>  #> Running git status -s 
#> -#> 
#> +#>  M Makefile
#> +#>  M README.Rmd
#>  #> 
#>  #> Branches:
#>  #> Running git branch -a 
#> +#>   force-pkgdown
#>  #> * main
#> +#>   remotes/origin/HEAD -> origin/main
#> +#>   remotes/origin/bugfix-get-pr-sha
#> +#>   remotes/origin/force-pkgdown
#>  #>   remotes/origin/gh-pages
#>  #>   remotes/origin/main
#>  #>   remotes/origin/prep-for-cran
#>  #>   remotes/origin/submit-cran
#> +#>   remotes/origin/update-pkgdown-new-look
#>  #> 
#>  #> Local status:
#>  #> ✓ OK
#>  #> 
#>  #> Upstream remotes: origin 
#> -#> * main 90eaa95 [origin/main] Tweak README.Rmd
#> +#>   force-pkgdown 72ad53a [origin/force-pkgdown] wip
#> +#> * main          d6cbbb9 [origin/main] Update DESCRIPTION with tidytemplate Needs
#>  #> 
#>  #> Commit log: main 
#>  #> Running git log --oneline --graph --decorate -n 5 
#> -#> * 90eaa95 (HEAD -> main, origin/main) Tweak README.Rmd
#> -#> * b51b8a9 Minor clean up of hooks
#> -#> * 8a015b2 Re-build README.Rmd
#> -#> * 06ee33e Minor tweak to trim_sha() and export is_sha()
#> -#> * e2789f3 Tweak DESCRIPTION and README.Rmd pkg descriptions
#> +#> * d6cbbb9 (HEAD -> main, origin/main, origin/HEAD) Update DESCRIPTION with tidytemplate Needs
#> +#> * 0ae6d0c New pkgdown tidy theme and bootstrap 5
#> +#> * 9d669f2 Improve GHA triggers
#> +#> * 179896e fix test-coverage.yaml to upload to Codecov
#> +#> * 0d17278 correct .gitignore
#>  ```
#>  
#>  ------------------------------------------------------------------------
#> @@ -478,8 +492,3 @@ See also [Oh-My-Zsh](https://ohmyz.sh) for general installation.
#>  Please note that this package package is released with a
#>  [LICENSE](https://github.com/stufield/gitr/blob/main/LICENSE.md). By
#>  using in this package you agree to abide by its terms.
#> -
#> -------------------------------------------------------------------------
#> -
#> -Created by [Rmarkdown](https://github.com/rstudio/rmarkdown) (v2.20) and
#> -R version 4.2.2 (2022-10-31).
#> diff --git a/vignettes/gitr.Rmd b/vignettes/gitr.Rmd
#> index 4238b82..c7a1b09 100644
#> --- a/vignettes/gitr.Rmd
#> +++ b/vignettes/gitr.Rmd
#> @@ -61,7 +61,3 @@ In the meantime please see the package [README](https://github.com/stufield/gitr
#>    - [https://choosealicense.com/licenses/mit/](https://choosealicense.com/licenses/mit/)
#>    - [https://tldrlegal.com/license/mit-license/](https://tldrlegal.com/license/mit-license)
#>  
#> ----------------------
#> -
#> -Created by [Rmarkdown](https://github.com/rstudio/rmarkdown)
#> -(v`r utils::packageVersion("rmarkdown")`) and `r R.version$version.string`.
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
#>                               tagdate size                       path
#> v0.0.1 Wed Feb 15 12:53:58 2023 -0700  148 /Users/sfield/gh/gitr/.git
```

#### Situation Report

``` r
git_sitrep()
#> Using Git version: 2.39.0 
#> 
#> Current branch: main
#> Default branch: main 
#> 
#> Repo status:
#> Running git status -s 
#>  M README.Rmd
#> 
#> Branches:
#> Running git branch -a 
#> * main
#>   remotes/origin/HEAD -> origin/main
#>   remotes/origin/bugfix-get-pr-sha
#>   remotes/origin/gh-pages
#>   remotes/origin/main
#>   remotes/origin/pkgdown-update
#>   remotes/origin/prep-for-cran
#>   remotes/origin/submit-cran
#>   remotes/origin/update-pkgdown-new-look
#> 
#> Local status:
#> ✓ OK
#> 
#> Upstream remotes: origin 
#> * main dbca034 [origin/main] Re-build README.Rmd
#> 
#> Commit log: main 
#> Running git log --oneline --graph --decorate -n 5 
#> * dbca034 (HEAD -> main, origin/main, origin/HEAD) Re-build README.Rmd
#> * 185ebb6 Remove rmarkdown footer for README and vignette
#> * d6cbbb9 Update DESCRIPTION with tidytemplate Needs
#> * 0ae6d0c New pkgdown tidy theme and bootstrap 5
#> * 9d669f2 Improve GHA triggers
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

Please note that this package is released with a
[LICENSE](https://github.com/stufield/gitr/blob/main/LICENSE.md). By
using in this package you agree to abide by its terms.
