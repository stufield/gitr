#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

.onLoad <- function(...) {
  # a polite check warning the user that 'git' was not
  # found with Sys.which()
  if ( identical(Sys.which("git"), c(git = "")) ) {
    oops("Unable to confirm path to the 'git' executable")
    todo("Do you have 'git' installed?")
    info("Perhaps try:", slug_color("Sys.which(\"git\")", "\033[90m"))
  }
  invisible()
}
