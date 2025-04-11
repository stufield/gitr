#' Common Parameters for gitr
#'
#' @name params
#'
#' @param n `integer(1)`. How far back to go from current `HEAD`.
#'   Same as the command line `git log -n` parameter.
#'   For `git stash` commands, zero-index into the stash list.
#'
#' @param file `character(1)`. The path to a file.
#'
#' @param branch `character(1)`. The name of a branch, typically a
#'   feature branch.
#'
#' @param sha `character(1)`. The commit secure hash algorithm (SHA-1).
#'   If `NULL`, typicall reverts to the most recent commit on the current branch.
#'
NULL
