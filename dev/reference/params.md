# Common Parameters for gitr

Common Parameters for gitr

## Arguments

- n:

  `integer(1)`. How far back to go from current `HEAD`. Same as the
  command line `git log -n` parameter. For `git stash` commands,
  zero-index into the stash list.

- file:

  `character(1)`. The path to a file.

- branch:

  `character(1)`. The name of a branch, typically a feature branch.

- sha:

  `character(n)`. The commit secure hash algorithm (SHA-1). If `NULL`,
  typically points to the most recent commit on the current branch.
