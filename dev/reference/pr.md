# Git PR Utilities

Git PR Utilities

## Usage

``` r
gitr_pr_msgs(branch = NULL)

gitr_pr_sha(branch = NULL)
```

## Arguments

- branch:

  `character(1)`. The name of a branch, typically a feature branch.

## Value

`gitr_pr_msgs()`: see
[`gitr_commit_msgs()`](https://stufield.github.io/gitr/dev/reference/commit.md).

`gitr_pr_sha()`: character vector of SHAs corresponding to the PR
(relative to the default branch).

## Functions

- `gitr_pr_msgs()`: gets the commit messages for the *current* branch
  relative to the `origin/{main,master}` branch in the remote. Typically
  these "new" commits that would be merged as part of a PR to
  `origin/{main,master}`.

- `gitr_pr_sha()`: gets the commit SHA-1 a branch (by default *current*)
  relative to the `default` branch in the remote, usually either
  `origin/main` or `origin/master`. See
  [`gitr_default_br()`](https://stufield.github.io/gitr/dev/reference/branch.md).
  If there are un-pushed commit on the current default branch, it
  returns them.

## Examples

``` r
if (FALSE) { # \dontrun{
  # SHAs from feature branch differ from default br
  gitr_pr_sha()

  # commit messages from the SHAs above
  # for a PR `branch` -> `remotes/origin/{main,master}`
  gitr_pr_msgs()

  # for a feature branch -> default branch
  gitr_pr_msgs("feature")
} # }
```
