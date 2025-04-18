#' Git Commit Utilities
#'
#' @name commit
#'
#' @inheritParams params
#'
#' @examples
#' \dontrun{
#'   gitr_commit_msgs()
#'
#'   gitr_commit_msgs(n = 3)
#' }
#'
#' @return `NULL` ... invisibly.
NULL

#' @describeIn commit
#'   gets the commit messages corresponding to the commit `sha`.
#'   `sha` can be `character(n)`, but must be valid SHAs
#'   corresponding to commits in the repository.
#'
#' @return A list containing commit message entries.
#'   The `sha` and `author` of each commit is added as attributes.
#'
#' @export
gitr_commit_msgs <- function(sha = NULL, n = 1L) {
  if ( is.null(sha) ) {  # do this first
    sha <- git("log --format=%H -n", n)$stdout
  } else {
    stopifnot(
      "`sha` must be `character(1)`." = length(sha) > 0L,
      "`sha` cannot be NA."           = !is.na(sha),
      "`sha` cannot be empty ''."     = sha != "",
      "`sha` must be `character(1)`." = is.character(sha)
    )
  }
  lapply(sha, function(.x) {
    structure(
      git("log --format=%B -1", .x, echo_cmd = FALSE)$stdout,
      sha    = gitr_trim_sha(.x),
      author = git("log --format=%ae -1", .x, echo_cmd = FALSE)$stdout
    )
  })
}

#' @describeIn commit
#'   scrapes `n` commit messages for useful change log commits
#'   to be used to create a `NEWS.md`.
#'
#' @export
scrape_commits <- function(n) {
  commit_list <- gitr_commit_msgs(n = n)
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
      grepl("Re-build README", .msg, ignore.case = TRUE) |
      grepl("Increment version", .msg, ignore.case = TRUE) |
      grepl("Update.*pkgdown", .msg)
    (a || b)
    }, FUN.VALUE = NA)
  ent <- ifelse(sum(keep_lgl) == 1, "entry", "entries")
  done("Found", sum(keep_lgl), "NEWS-worthy", ent)
  commit_list[keep_lgl]
}

#' @describeIn commit
#'   un-stages a file from the index to the working directory.
#'   Default un-stages *all* files.
#'
#' @inheritParams params
#'
#' @export
gitr_unstage <- function(file = NULL) {
  if ( is_git() ) {
    if ( is.null(file) ) {
      out <- git("reset HEAD")
    } else {
      out <- git("reset HEAD", file)
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
#'
#' @export
gitr_reset_soft <- function(n = 1L) {
  if ( is_git() ) {
    out <- git("reset --soft", paste0("HEAD~", n))
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn commit
#'   un-commits the most recently committed
#'   file(s) and add them to the staging area.
#'   Wrapper around [gitr_reset_soft()]
#'
#' @export
gitr_uncommit <- function() {
  gitr_reset_soft("1")
}

#' @describeIn commit
#'   `git reset --hard origin/<branch>`.
#'
#' @export
gitr_reset_hard <- function() {
  if ( is_git() ) {
    out <- git("reset --hard", paste0("origin/", gitr_current_br()))
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn commit
#'   gets the diff of the corresponding 2 commits.
#'   Order matters!
#'
#' @param top `integer(1)`. The commit to consider the
#'   "top" of the commit stack.
#'   Defaults to `HEAD~0` or `top = 1`.
#'
#' @export
gitr_diff_commits <- function(top = 1L, n = 2L) {
  if ( is_git() ) {
    out <- git("diff", sprintf("HEAD~%i..HEAD~%i", n - 1L, top - 1L))
    if ( not_interactive() ) {
      return(cat(out$stdout, sep = "\n"))
    } else {
      tmp <- gsub("(^\\+.*$)", "\033[32m\\1\033[0m", out$stdout)
      gsub("(^\\-.*$)", "\033[31m\\1\033[0m", tmp) |> cat(sep = "\n")
    }
  }
  invisible()
}
