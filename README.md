
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The `gitr` Package

<!-- badges: start -->
<!-- badges: end -->

The goal of gitr is to …

## Installation

You can install the released version of gitr from
[CRAN](https://CRAN.R-project.org) with:

``` r
remotes::install_github("stufield/gitr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(gitr)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
glog()
#> Running git log --oneline --graph --decorate -n 10
#> [33m*[0m[32m 7891e84 [0m([36mHEAD -> [32mmaster[0m, [31morigin/master[0m) Initial commit
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
