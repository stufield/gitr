#' Git Utilities
#'
#' Provides functionality for system-level Git commands from within R.
#'
#' @name git
#' @param n Numeric. How far back to go from current HEAD. Same as the
#' command line `git log -n` parameter.
#' @param echo_cmd Logical. Whether to print the command to run to the console.
#' @param file,branch Character. The name of a file or branch, typically a
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
#' @export
git <- function(..., echo_cmd = TRUE) {
  if ( echo_cmd) {
    cat("Running git", c(...), "\n")
  }
  res  <- list(status = 0, stdout = "", stderr = "")
  call <- suppressWarnings(
    base::system2("git", c(...), stdout = TRUE, stderr = TRUE)
  )
  status <- attr(call, "status")
  if ( is.null(status) ) {
    res$stdout <- call %||% ""
  } else {
    res$status <- status
    res$stderr <- as.character(call)
    cat("\033[031mSystem command 'git' failed:\n", res$stderr, sep = "\n")
  }
  invisible(res)
}

#' @describeIn git
#' Get the commit messages corresponding to the commit `sha`.
#' Adds author and `sha` attributes to each commit for downstream use.
#' @export
get_commit_msgs <- function(sha = NULL, n = 1) {
  if ( is.null(sha) ) {
    sha <- git("log", "--format=%H", "-n", n)$stdout
  }
  stopifnot(length(sha) > 0, sha != "", !is.na(sha), is.character(sha))
  lapply(sha, function(.x) {
    structure(
      git("log", "--format=%B", "-1", .x, echo_cmd = FALSE)$stdout,
      sha    = substr(.x, 1, 7),
      author = git("log", "--format=%ae", "-1", .x, echo_cmd = FALSE)$stdout
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
    get_commit_msgs(sha = sha_vec)
  }
}

#' @describeIn git
#' Gets the commit SHA1 *current* branch relative to
#' the `origin/master` branch in the remote.
#' @export
get_pr_sha <- function(branch = NULL) {
  if ( is.null(branch) ) {
    branch <- git_current_br()
  }
  sha_vec <- git("rev-list", "--right-only",
                 paste0("remotes/origin/master..", branch),
                 echo_cmd = FALSE)
  if ( sha_vec$status == 1 || sha_vec$stdout == "" ) {
    NULL
  } else {
    sha_vec$stdout
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
  tag <- utils::tail(git("tag", "-n")$stdout, 1L)
  gsub("(^v[0-9]+\\.[0-9]+\\.[0-9]+).*", "\\1", tag)
}

#' @describeIn git `git checkout` as a branch if doesn't exist. Branch
#' oriented workflow for switching between branches.
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

#' @describeIn git Is current working directory a `git` repository?
#' @export
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

#' @describeIn git Gets the version of git in use.
#' @export
git_version <- function() {
  ver <- git("--version", echo_cmd = FALSE)$stdout
  gsub(".*([1-3]\\.[0-9]{1,3}\\.[0-9]{1,3}).*", "\\1", ver)
}

#' @describeIn git Gets the default "main" branch.
#' @export
git_default_br <- function() {
  if ( is_git() ) {
    refs <- git("show-ref", echo_cmd = FALSE)$stdout
    refs <- gsub("[a-f0-9]{40} ", "", refs)
    root <- c("heads/", "remotes/origin/", "remotes/upstream/")
    for ( i in root ) {
      if ( paste0(i, "main") %in% refs) {
        return("main")
      } else if ( paste0(i, "trunk") %in% refs) {
        return("trunk")
      } else {
        next
      }
    }
  }
  "master"
}

#' @describeIn git Gets the *current* branch.
#' @export
git_current_br <- function() {
  if ( is_git() ) {
    #git("rev-parse", "--abbrev-ref", "HEAD", echo_cmd = FALSE)$stdout
    ref <- git("symbolic-ref --quiet HEAD", echo_cmd = FALSE)$stdout
    gsub("refs/heads/", "", ref)
  } else {
    invisible()
  }
}

#' @describeIn git Unstage file from the index to the working directory.
#' Default unstages *all* files.
#' @export
git_unstage <- function(file = NULL) {
  if ( is_git() ) {
    if ( is.null(file) ) {
      out <- git("reset", "HEAD")
    } else {
      out <- git("reset", "HEAD", file)
    }
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn git Uncommit the most recently committed file(s) and
#' add them to the staging area.
#' @export
git_reset_soft <- function() {
  if ( is_git() ) {
    out <- git("reset", "--soft", "HEAD~1")
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn git `git reset --hard origin/<branch>`.
#' @export
git_reset_hard <- function() {
  if ( is_git() ) {
    out <- git("reset", "--hard", paste0("origin/", git_current_br()))
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}
