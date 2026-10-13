# Git Utilities

Provides functionality for system-level Git commands from within R.

## Usage

``` r
git(..., echo_cmd = TRUE)

is_git()

git_version()
```

## Arguments

- ...:

  Additional arguments passed to the system command-line
  `git <command> [<args>]` call.

- echo_cmd:

  `logical(1)`. Whether to print the command to run to the console. Can
  be over-ridden globally via `option(gitr_echo_cmd = FALSE)`.

## Value

`git()`: The system call ... invisibly.

`is_git()`: `logical(1)`.

`git_version()`: `character(1)`. The system version of `git`.

## Functions

- `git()`: executes a `git` command line call from within R.

- `is_git()`: is current working directory a `git` repository?

- `git_version()`: gets the version of git in use.

## Examples

``` r
if (FALSE) { # \dontrun{
  git("status", "-s")

  git("reset", "--soft", "HEAD~1")

  git("tag", "-n")

  is_git()

  git_version()
} # }
```
