#' Common Lints for Commit Messages
#'
#' Lint a commit message for typical commit style and
#' best practices for git.
#'
#' @name lint
#' @param x A single commit message from [get_commit_msgs()].
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
