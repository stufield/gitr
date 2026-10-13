# Git Checkout

Checks out as a branch if doesn't exist. Branch oriented workflow for
switching between branches. If `file` is passed, checks out the file. A
common shortcut to undoing local changes to a file(s). Can be a vector
of multiple files.

## Usage

``` r
gitr_checkout(branch = NULL, file = NULL)
```

## Arguments

- branch:

  `character(1)`. The name of a branch, typically a feature branch.

- file:

  `character(1)`. The path to a file.

## Value

`NULL` ... invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
  gitr_checkout("feature-br")

  gitr_checkout(file = "DESCRIPTION")
} # }
```
