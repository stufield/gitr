#' Common Lints for Commit Messages
#'
#' Lint a commit message for typical commit style and
#'   best practices for git.
#'
#' @name lint
#'
#' @param x A single commit message from [get_commit_msgs()].
#'
#' @return `integer(1)`. Invisibly returns the
#'   number of detected lints in the message.
#'
#' @examples
#' \dontrun{
#'   lapply(get_commit_msgs(7L), lint_commit_msg)
#' }
#' @export
lint_commit_msg <- function(x) {
  if ( length(x) == 0L ) {
    return(0L)
  }
  sha <- attr(x, "sha") %||% "\u2716"
  cnt <- 0L
  if ( grepl("^[a-z]", x[1L]) ) {
    warning("Title should begin with a capital (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  if ( grepl("\\.$", x[1L]) ) {
    warning("Title should not end with a period (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  if ( nchar(x[1L]) > 60L ) {
    warning("Title is too long (", nchar(x[1L]), ") for (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  if ( isTRUE(x[2L] != "") ) {
    warning("Title should be followed by empty line (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  star <- vapply(x, grepl, pattern = "^\\*", NA)
  if ( any(star) ) {
    warning("Please use `-` for bullets (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  bullet_space <- vapply(x, grepl, pattern = "^-[a-zA-Z]", NA)
  if ( any(bullet_space) ) {
    warning("Please place space following `-` bullet (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  wip <- vapply(x, grepl, pattern = "WIP", ignore.case = TRUE, NA)
  if ( any(wip) ) {
    warning("Work in progress commit detected! (", sha, ")", call. = FALSE)
    cnt <- cnt + 1L
  }
  y <- paste(x, collapse = "\n")
  issue <- grepl("[A-Z]{2,10}-[0-9]{1,4}", y)
  gh    <- grepl("fixes .*#[0-9]{1,4}|closes .*#[0-9]{1,4}", y, ignore.case = TRUE)
  if ( !(issue || gh) ) {
    warning("Could not find an issue number in commit message (", sha, ")",
            call. = FALSE)
    cnt <- cnt + 1L
  }
  invisible(sum(cnt))
}
