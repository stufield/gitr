#' Git PR Utilities


#' @name pr
NULL


#' @describeIn pr
#'   gets the commit messages for the *current* branch relative to
#'   the `origin/{main,master}` branch in the remote. Typically these "new" commits
#'   that would be merged as part of a PR to `origin/{main,master}`.
#' @inheritParams params
#' @return [get_pr_msgs()]: see [get_commit_msgs()].
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
#'   gets the commit SHA1 *current* branch relative to
#'   the `default` branch in the remote, usually either `origin/main` or
#'   `origin/master`. See [git_default_br()].
#' @inheritParams params
#' @return [get_pr_sha()]: character vector of `sha`s corresponding to the PR
#'   (relative to the default branch).
#' @export
get_pr_sha <- function(branch = NULL) {
  if ( is.null(branch) ) {
    branch <- git_current_br()
  }
  default <- git_default_br()
  sha_vec <- git("rev-list", "--right-only",
                 paste0("remotes/origin/", default, "..", branch),
                 echo_cmd = FALSE)
  if ( sha_vec$status != 0L || isTRUE(sha_vec == "") ) {
    NULL
  } else {
    sha_vec$stdout
  }
}
