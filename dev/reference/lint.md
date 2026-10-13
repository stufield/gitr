# Common Lints for Commit Messages

Lint a commit message for typical commit style and best practices for
git.

## Usage

``` r
lint_commit_msg(x)
```

## Arguments

- x:

  A single commit message from
  [`gitr_commit_msgs()`](https://stufield.github.io/gitr/dev/reference/commit.md).

## Value

`integer(1)`. Invisibly returns the number of detected lints in the
message.

## Examples

``` r
if (FALSE) { # \dontrun{
  lapply(gitr_commit_msgs(7L), lint_commit_msg)
} # }
```
