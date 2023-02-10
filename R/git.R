#' Git Utilities
#'
#' Provides functionality for system-level git commands from within R.
#'
#' @name git
#' @examples
#' \dontrun{
#' git("status", "-s")
#'
#' get_commit_msgs()
#'
#' get_commit_msgs(n = 3)
#'
#' get_pr_msgs()
#'
#' # lint most recent 3 commit message
#' lapply(get_commit_msgs(n = 3), lint_commit_msg)
#'
#' # for a PR `branch` -> `remotes/origin/{main,master}`
#' lapply(get_pr_msgs(), lint_commit_msg)           # current branch
#' lapply(get_pr_msgs("feature"), lint_commit_msg)  # `feature` branch
#'
#' get_recent_tag()
#' }
NULL


#' @describeIn git
#'   executes a `git` command line call from within R.
#' @param echo_cmd Logical. Whether to print the command to run to the console.
#' @param ... Additional arguments passed to the system
#'   command-line `git <command> [<args>]` call.
#' @return [git()]: The system call ... invisibly.
#' @export
git <- function(..., echo_cmd = TRUE) {
  if ( echo_cmd ) {
    cat("Running git", c(...), "\n")
  }
  res  <- list(status = 0L, stdout = "", stderr = "")
  call <- suppressWarnings(
    base::system2("git", c(...), stdout = TRUE, stderr = TRUE)
  )
  status <- attr(call, "status")
  if ( is.null(status) ) {
    res$stdout <- call %||% ""   # character(0) -> ""
  } else {
    res$status <- status
    res$stderr <- as.character(call)
    cat(slug_color("System command 'git' failed:\n"),
        slug_color(res$stderr, "\033[036m"), sep = "\n")
  }
  invisible(res)
}

#' @describeIn git
#'   is current working directory a `git` repository?
#' @return `is_git()`: Logical.
#' @export
is_git <- function() {
  dir <- base::system2("git", "rev-parse --git-dir", stdout = FALSE, stderr = FALSE)
  in_repo  <- dir.exists(".git") || (dir == 0L)
  if ( !in_repo ) {
    oops("Not a git repository")
  }
  in_repo
}

#' @describeIn git
#'   gets the version of git in use.
#' @return `git_version()`: Character. The system version of `git`.
#' @export
git_version <- function() {
  ver <- git("--version", echo_cmd = FALSE)$stdout
  gsub(".*([1-3]\\.[0-9]{1,3}\\.[0-9]{1,3}).*", "\\1", ver)
}

#' @describeIn git
#'   `git checkout` as a branch if doesn't exist. Branch
#'   oriented workflow for switching between branches.
#' @inheritParams params
#' @return `git_checkout()`: `NULL` ... invisibly.
#' @export
git_checkout <- function(branch = NULL) {
  if ( is.null(branch) ) {
    stop("You must pass a branch to checkout.", call. = FALSE)
  }
  if ( is_git() ) {
    br <- git("branch", "--list", branch, echo_cmd = FALSE)
    files <- git("ls-files", echo_cmd = FALSE)$stdout
    if ( !(branch %in% files) && identical(br$stdout, "") ) {
      out <- git("checkout", "-b", branch)   # branch doesn't yet exist
    } else {
      out <- git("checkout", branch)
    }
    cat(out$stdout, sep = "\n")
    cat(out$stderr, sep = "\n")
  }
  invisible()
}
