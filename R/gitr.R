#' Git Utilities
#'
#' Provides functionality for system-level
#'   Git commands from within R.
#'
#' @name git
#'
#' @examples
#' \dontrun{
#'   git("status -s")
#'
#'   git("reset --soft HEAD~1")
#'
#'   git("tag -n")
#'
#'   is_git()
#'
#'   git_version()
#' }
NULL


#' @describeIn git
#'   executes a `git` command line call from within R.
#'
#' @param echo_cmd `logical(1)`. Whether to print the
#'   command to run to the console. Can be over-ridden
#'   globally via `option(gitr_echo_cmd = FALSE)`.
#'
#' @param ... Additional arguments passed to the system
#'   command-line `git <command> [<args>]` call.
#'
#' @return [git()]: The system call ... invisibly.
#'
#' @export
git <- function(..., echo_cmd = TRUE) {
  if ( getOption("gitr_echo_cmd", echo_cmd) ) {
    cat("Running", slug_color(c("git", c(...)), "\033[034m"), "\n")
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
#'
#' @return `is_git()`: `logical(1)`.
#'
#' @export
is_git <- function() {
  dir <- base::system2("git", "rev-parse --git-dir",
                       stdout = FALSE, stderr = FALSE)
  in_repo  <- dir.exists(".git") || ( dir == 0L )
  if ( !in_repo ) {
    oops("Not a git repository")
  }
  in_repo
}

#' @describeIn git
#'   gets the version of git in use.
#'
#' @return `git_version()`: `character(1)`.
#'   The system version of `git`.
#'
#' @export
git_version <- function() {
  ver <- git("--version", echo_cmd = FALSE)$stdout
  gsub(".*([1-3]\\.[0-9]{1,3}\\.[0-9]{1,3}).*", "\\1", ver)
}
