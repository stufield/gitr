#' Git Branch Utilities
#'
#' @name branch
#'
#' @return `character(1)`. The name of the respective
#'   branch if found, otherwise `NULL`.
NULL

#' @describeIn branch
#'   gets the default "main" branch, typically either
#'   `master`, `main`, or `trunk`.
#'
#' @export
git_default_br <- function() {
  if ( is_git() ) {
    sink(tempfile())
    on.exit(sink())
    root <- c("refs/heads/", "refs/remotes/origin/", "refs/remotes/upstream/")
    refs <- paste0(rep(root, each = 3L), c("main", "trunk", "master"))
    for ( ref in refs ) {
      st <- git("show-ref", "-q", "--verify", ref, echo_cmd = FALSE)$status
      if ( st == 0L ) {
        return(basename(ref))
      } else {
        next
      }
    }
    stop("Unable to determine default branch.", call. = FALSE)
  }
  invisible()
}

#' @describeIn branch
#'   gets the *current* branch.
#'
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

#' @describeIn branch
#'   gets all the *local* branches.
#'
#' @export
git_local_br <- function() {
  if ( is_git() ) {
    ref <- git("branch", "--list", echo_cmd = FALSE)$stdout
    gsub("^[^[:alnum:]]*(.*)[^[:alnum:]]*$", "\\1", ref)
  } else {
    invisible()
  }
}
