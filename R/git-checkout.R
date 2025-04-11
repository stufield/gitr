#' Git Checkout
#'
#' Checks out as a branch if doesn't exist. Branch
#'   oriented workflow for switching between branches.
#'   If `file` is passed, checks out the file. A common
#'   shortcut to undoing local changes to a file(s).
#'   Can be a vector of multiple files.
#'
#' @name checkout
#'
#' @inheritParams params
#'
#' @return `NULL` ... invisibly.
#'
#' @examples
#' \dontrun{
#'   git_checkout("feature-br")
#'
#'   git_checkout(file = "DESCRIPTION")
#' }
#' @export
git_checkout <- function(branch = NULL, file = NULL) {
  if ( !is_git() ) {
    return(invisible())
  }

  if ( is.null(branch) && is.null(file) ) {
    stop("You must pass a either `branch` or a `file` to checkout.",
         call. = FALSE)
  } else if ( is.null(branch) ) {
    gitr_checkout_file(file)
  } else if ( is.null(file) ) {
    gitr_checkout_branch(branch)
  } else {
    stop("You cannot pass *both* a `branch` and a `file` to checkout.",
         call. = FALSE)
  }

  invisible()
}


# helpers ----
gitr_checkout_file <- function(file) {
  tracked_files <- git("ls-files", echo_cmd = FALSE)$stdout
  stopifnot(
    "the `file` must be tracked by git." = file %in% tracked_files
  )
  out <- git("checkout", file)
  if ( getOption("gitr_echo_cmd", TRUE) ) {
    cat(out$stdout, sep = "\n")
    #cat(out$stderr, sep = "\n")
  }
}

gitr_checkout_branch <- function(branch) {
  br_exists <- branch %in% git_local_br()
  tracked_files <- git("ls-files", echo_cmd = FALSE)$stdout

  if ( branch %in% tracked_files ) {
    stop("`branch` cannot have the same name as a tracked file.",
         call. = FALSE)
  }

  if ( br_exists ) {
    out <- git("checkout", branch)
  } else {
    out <- git("checkout", "-b", branch)
  }

  if ( getOption("gitr_echo_cmd", TRUE) ) {
    cat(out$stdout, sep = "\n")
    #cat(out$stderr, sep = "\n")
  }
}
