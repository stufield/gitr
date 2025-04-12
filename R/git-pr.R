#' Git PR Utilities
#'
#' @name pr
#'
#' @inheritParams params
#'
#' @examples
#' \dontrun{
#'   # SHAs from feature branch differ from default br
#'   get_pr_sha()
#'
#'   # commit messages from the SHAs above
#'   # for a PR `branch` -> `remotes/origin/{main,master}`
#'   get_pr_msgs()
#'
#'   # for a feature branch -> default branch
#'   get_pr_msgs("feature")
#' }
NULL

#' @describeIn pr
#'   gets the commit messages for the *current* branch
#'   relative to the `origin/{main,master}` branch in
#'   the remote. Typically these "new" commits
#'   that would be merged as part of a PR to `origin/{main,master}`.
#'
#' @return [get_pr_msgs()]: see [get_commit_msgs()].
#'
#' @export
get_pr_msgs <- function(branch = NULL) {
  sha_vec <- get_pr_sha(branch)
  if ( is.null(sha_vec) ) {
    invisible(list(NULL))
  } else {
    get_commit_msgs(sha = sha_vec)
  }
}

#' @describeIn pr
#'   gets the commit SHA-1 a branch (by default *current*)
#'   relative to the `default` branch in the remote, usually either
#'   `origin/main` or `origin/master`. See [git_default_br()].
#'   If there are un-pushed commit on the current default branch,
#'   it returns them.
#'
#' @inheritParams params
#'
#' @return [get_pr_sha()]: character vector of SHAs
#'   corresponding to the PR (relative to the default branch).
#'
#' @export
get_pr_sha <- function(branch = NULL) {
  if ( is.null(branch) ) {   # do this first; default
    branch <- git_current_br()
  } else if ( length(branch) == 0L || !branch %in% git_local_br() ) {
    stop("`branch` must be a local branch. See `git_local_br()`\n",
         "You passed: ", slug_color(branch), call. = FALSE)
  }
  default <- git_default_br()
  sha_vec <- git("rev-list", "--right-only",
                 paste0("remotes/origin/", default, "..", branch),
                 echo_cmd = FALSE)
  if ( sha_vec$status != 0L || isTRUE(sha_vec$stdout == "") ) {
    NULL
  } else {
    sha_vec$stdout
  }
}
