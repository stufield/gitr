#' Git Utilities
#'
#' Provides functionality for system-level Git commands from within R.
#'
#' @name git
#' @inheritParams processx::run
#' @param n Numeric. How far back to go from current HEAD. Same as the
#' command line `git log -n` parameter.
#' @param branch Character. The name of a branch, typically a
#' feature branch.
#' @param sha Character. Commit SHA or hash to pull messages from.
#' If `NULL`, the most recent commit on the current branch.
#' @param ... Additional arguments passed to the system
#' command-line `git <command> [<args>]` call.
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
#' # for a PR `branch` -> `remotes/origin/master`
#' lapply(get_pr_msgs(), lint_commit_msg)           # current branch
#' lapply(get_pr_msgs("feature"), lint_commit_msg)  # `feature` branch
#'
#' get_recent_tag()
#' }
NULL


#' @describeIn git
#' Execute a `git` command line call from within R.
#' @importFrom processx run
#' @export
git <- function(..., echo_cmd = TRUE, echo = FALSE) {
  processx::run(
    "git", c(...),
    echo_cmd = echo_cmd,
    echo = echo,
    error_on_status = TRUE
  )
}

#' @describeIn git
#' Get the commit messages corresponding to the commit `sha`.
#' Adds author and `sha` attributes to each commit for downstream use.
#' @export
get_commit_msgs <- function(sha = NULL, n = 1) {
  if ( is.null(sha) ) {
    sha <- strsplit(git("log", "--format=%H", "-n", n)$stdout, "\n")[[1L]]
  }
  stopifnot(length(sha) > 0, sha != "", !is.na(sha), is.character(sha))
  lapply(sha, function(.x) {
    structure(
      strsplit(git("log", "--format=%B", "-1", .x, echo_cmd = FALSE)$stdout, "\n")[[1L]],
      sha    = substr(.x, 1, 7),
      author = trimws(git("log", "--format=%ae", "-1", .x, echo_cmd = FALSE)$stdout)
    )
  })
}

#' @describeIn git
#' Gets the commit messages for the *current* branch relative to
#' the `origin/master` branch in the remote. Typically these "new" commits
#' that would be merged as part of a PR to `origin/master`.
#' @export
get_pr_msgs <- function(branch = NULL) {
  sha_vec <- get_pr_sha(branch)
  if ( is.null(sha_vec) ) {
    invisible(list(NULL))
  } else {
    get_commit_msgs(sha = strsplit(sha_vec, "\n")[[1L]])
  }
}

#' @describeIn git
#' Gets the commit SHA1 *current* branch relative to
#' the `origin/master` branch in the remote.
#' @export
get_pr_sha <- function(branch = NULL) {
  if ( is.null(branch) ) {
    branch <- trimws(git("branch", "--show-current", echo_cmd = FALSE)$stdout)
  }
  sha_vec <- try(
    git("rev-list", "--right-only", paste0("remotes/origin/master..", branch),
        echo_cmd = FALSE)$stdout,
    silent = TRUE
  )
  if ( sha_vec == "" || inherits(sha_vec, "try-error") ) {
    NULL
  } else {
    strsplit(sha_vec, "\n")[[1L]]
  }
}

#' @describeIn git
#' Lint a commit message for typical commit style best practices for `git`.
#' @param x A single commit message from `get_commit_msgs()`.
#' @export
lint_commit_msg <- function(x) {
  if ( length(x) == 0 ) {
    return(0)
  }
  sha <- attr(x, "sha")
  cnt <- 0
  if ( grepl("^[a-z]", x[1L]) ) {
    warning("Title should begin with a capital (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  if ( grepl("\\.$", x[1L]) ) {
    warning("Title should not end with a period (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  if ( nchar(x[1L]) > 60 ) {
    warning("Title is too long (", nchar(x[1L]), ") for (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  if ( isTRUE(x[2L] != "") ) {
    warning("Title should be followed by empty line (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  star <- vapply(x, grepl, pattern = "^\\*", NA)
  if ( any(star) ) {
    warning("Please use `-` for bullets (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  bullet_space <- vapply(x, grepl, pattern = "^-[a-zA-Z]", NA)
  if ( any(bullet_space) ) {
    warning("Please place space following `-` bullet (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  wip <- vapply(x, grepl, pattern = "WIP", ignore.case = TRUE, NA)
  if ( any(wip) ) {
    warning("Work in progress commit detected! (", sha, ")", call. = FALSE)
    cnt <- cnt + 1
  }
  invisible(sum(cnt))
}

#' @describeIn git
#' Get the *most* recent `git` tag.
#' @export
get_recent_tag <- function() {
  tag <- utils::tail(strsplit(git("tag", "-n")$stdout, "\n")[[1L]], 1L)
  gsub("(^v[0-9]+\\.[0-9]+\\.[0-9]+).*", "\\1", tag)
}

#' @describeIn git `git checkout` as a branch if doesnt' exist.
git_checkout <- function(branch = NULL) {
  if ( is.null(branch) ) {
    stop("You must pass a branch to checkout.", call. = FALSE)
  }
  if ( is_git() ) {
    br <- git("branch", "--list", branch, echo_cmd = FALSE)
    files <- strsplit(git("ls-files", echo_cmd = FALSE)$stdout, "\n")[[1L]]
    if ( !(branch %in% files) && identical(br$stdout, "") ) {
      out <- git("checkout", "-b", branch)   # branch doesn't yet exist
    } else {
      out <- git("checkout", branch)
    }
    cat(out$stdout, "\n")
    cat(out$stderr)
  }
  invisible()
}

#' @describeIn git Is current working directory a `git` repository?
is_git <- function() {
  in_repo <- dir.exists(".git")
  if ( !in_repo ) {
    oops("not a git repository")
  }
  in_repo
}

#' @describeIn git Scrape `n` commit message for useful changelog commits.
#' @export
scrape_commits <- function(n) {
  commit_list <- get_commit_msgs(n = n)
  todo("Scraping",  n, "commit messages")
  names(commit_list) <- vapply(commit_list, attr, which = "sha", "a")
  # discard uninformative commits:
  #  - commits length 1
  #  - standard commit patterns
  keep_lgl <- !vapply(commit_list, function(.x) {
    .msg <- .x[1L]
    a <- length(.x) == 2L   # if Subject line only
    b <- grepl("Merge pull request", .msg, ignore.case = TRUE) |
      grepl("Merge branch", .msg, ignore.case = TRUE) |
      grepl("Bump to dev", .msg, ignore.case = TRUE) |
      grepl("Pull request #[0-9]+", .msg, ignore.case = TRUE) |
      grepl("Update README", .msg, ignore.case = TRUE) |
      grepl("skip-edge", .msg, ignore.case = TRUE) |
      grepl("Increment version", .msg, ignore.case = TRUE) |
      grepl("Update.*pkgdown", .msg)
    (a || b)
    }, FUN.VALUE = NA)
  done("Found", sum(keep_lgl), "NEWS-worthy entries")
  commit_list[keep_lgl]
}
