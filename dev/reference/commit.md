# Git Commit Utilities

Git Commit Utilities

## Usage

``` r
gitr_commit_msgs(sha = NULL, n = 1L)

scrape_commits(n)

gitr_unstage(file = NULL)

gitr_staged()

gitr_reset_soft(n = 1L)

gitr_uncommit()

gitr_reset_hard()

gitr_diff_commits(top = 1L, n = 2L)
```

## Arguments

- sha:

  `character(n)`. The commit secure hash algorithm (SHA-1). If `NULL`,
  typically points to the most recent commit on the current branch.

- n:

  `integer(1)`. How far back to go from current `HEAD`. Same as the
  command line `git log -n` parameter. For `git stash` commands,
  zero-index into the stash list.

- file:

  `character(1)`. The path to a file.

- top:

  `integer(1)`. The commit to consider the "top" of the commit stack.
  Defaults to `HEAD~0` or `top = 1`.

## Value

`NULL` ... invisibly.

A list containing commit message entries. The `sha` and `author` of each
commit is added as attributes.

`gitr_staged()`: `character(n)` of staged file paths; `character(0)` if
nothing is staged.

## Functions

- `gitr_commit_msgs()`: gets the commit messages corresponding to the
  commit `sha`. `sha` can be `character(n)`, but must be valid SHAs
  corresponding to commits in the repository.

- `scrape_commits()`: scrapes `n` commit messages for useful change log
  commits to be used to create a `NEWS.md`.

- `gitr_unstage()`: un-stages a file from the index to the working
  directory. Default un-stages *all* files.

- `gitr_staged()`: gets the files currently staged for commit. Paths are
  relative to the repository root.

- `gitr_reset_soft()`: un-commits the most recently committed file(s)
  and add them to the staging area.

- `gitr_uncommit()`: un-commits the most recently committed file(s) and
  add them to the staging area. Wrapper around `gitr_reset_soft()`

- `gitr_reset_hard()`: `git reset --hard origin/<branch>`.

- `gitr_diff_commits()`: gets the diff of the corresponding 2 commits.
  Order matters!

## Examples

``` r
if (FALSE) { # \dontrun{
  gitr_commit_msgs()

  gitr_commit_msgs(n = 3)
} # }
```
