#' Git Branch Utilities


#' @name branch
NULL

#' @describeIn branch
#'   Gets the default "main" branch, typically either `master`, `main`, or `trunk`.
#' @export
git_default_br <- function() {
  if ( is_git() ) {
    sink(tempfile())
    on.exit(sink())
    root <- c("refs/heads/", "refs/remotes/origin/", "refs/remotes/upstream/")
    refs <- paste0(rep(root, each = 3L), c("main", "trunk", "master"))
    for ( ref in refs ) {
      st <- git("show-ref", "-q", "--verify", ref, echo_cmd = FALSE)$status
      if ( st == 0L ) return(basename(ref)) else next
    }
    stop("Unable to determine default branch.", call. = FALSE)
  }
  invisible()
}

#' @describeIn branch
#'   Gets the *current* branch.
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