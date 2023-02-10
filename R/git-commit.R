#' Git Commit Utilities


#' @name commit
#' @inheritParams params
#' @return `NULL` ... invisibly.
NULL

#' @describeIn commit
#'   gets the commit messages corresponding to the commit `sha`.
#' @return A list containing commit message entries. The `sha` and `author`
#'   of each commit is added as attributes.
#' @export
get_commit_msgs <- function(sha = NULL, n = 1) {
  if ( is.null(sha) ) {
    sha <- git("log", "--format=%H", "-n", n)$stdout
  }
  stopifnot(length(sha) > 0, sha != "", !is.na(sha), is.character(sha))
  lapply(sha, function(.x) {
    structure(
      git("log", "--format=%B", "-1", .x, echo_cmd = FALSE)$stdout,
      sha    = trim_sha(.x),
      author = git("log", "--format=%ae", "-1", .x, echo_cmd = FALSE)$stdout
    )
  })
}

#' @describeIn commit
#'   scrapes `n` commit messages for useful change log commits
#'   to be used to create a `NEWS.md`.
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

#' @describeIn commit
#'   un-stages a file from the index to the working directory.
#'   Default un-stages *all* files.
#' @inheritParams params
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

#' @describeIn commit
#'   un-commits the most recently committed file(s) and
#'   add them to the staging area.
#' @export
git_reset_soft <- function(n = 1) {
  if ( is_git() ) {
    out <- git("reset", "--soft", paste0("HEAD~", n))
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn commit
#'   un-commits the most recently committed file(s) and
#'   add them to the staging area. Wrapper around [git_reset_soft()]
#' @export
git_uncommit <- function() {
  git_reset_soft("1")
}

#' @describeIn commit
#'   `git reset --hard origin/<branch>`.
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

#' @describeIn commit
#'   gets the diff of the corresponding 2 commits. Order matters.
#' @param top Numeric. The commit to consider the "top" of the commit stack.
#'   Defaults to `HEAD` or `n = 1`.
#' @export
git_diffcommits <- function(top = 1, n = 2) {
  if ( is_git() ) {
    out <- git("diff", paste0("HEAD~", n, "..HEAD~", top))
    if ( not_interactive() ) {
      return(cat(out$stdout, sep = "\n"))
    } else {
      tmp <- gsub("(^\\+.*$)", "\033[32m\\1\033[0m", out$stdout)
      gsub("(^\\-.*$)", "\033[31m\\1\033[0m", tmp) |> cat(sep = "\n")
    }
  }
  invisible()
}
