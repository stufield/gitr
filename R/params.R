#' Common Parameters for gitr
#'
#' @name params
#'
#' @param n Numeric. How far back to go from current `HEAD`.
#'   Same as the command line `git log -n` parameter.
#'   For `git stash` commands, zero-index into the stash list.
#'
#' @param file Character. The path name to a file.
#'
#' @param branch Character. The name of a branch, typically a
#'   feature branch.
#'
#' @param sha Character. The commit SHA-1 hash to pull messages from.
#'   If `NULL`, the most recent commit on the current branch.
#'
NULL
