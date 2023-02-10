
`%||%` <- function(x, y) {
  if ( is.null(x) || length(x) <= 0L ) {
    y
  } else {
    x
  }
}

todo <- function(...) {
  inform(slug_color("\u2022"), ...)
}

oops <- function(...) {
  inform(slug_color("\u2716"), ...)
}

done <- function(...) {
  inform(slug_color("\u2713", "\033[32m"), ...)
}

info <- function(...) {
  inform(slug_color("\u2139", "\033[36m"), ...)
}

not_interactive <- function() {
  is_testing  <- identical(Sys.getenv("TESTTHAT"), "true")
  is_knitting <- isTRUE(getOption("knitr.in.progress"))
  is_testing || is_knitting || !interactive()
}

slug_color <- function(x, color = "\033[31m") { # default red
  if ( not_interactive() ) {
    x
  } else {
    paste0(color, x, "\033[39m")
  }
}

inform <- function(..., quiet = getOption("signal.quiet", default = FALSE)) {
  if ( !quiet ) {
    msg <- paste0(paste(...), "\n")
    withRestarts(muffleMessage = function() NULL, {
      signalCondition(
        structure(list(message = msg), class = c("message", "condition"))
      )
      cat(msg, sep = "", file = stdout())
    })
  }
  invisible()
}
