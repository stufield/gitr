
todo <- function(...) {
  sym <- paste0("\033[31m", "\u2022", "\033[39m")
  inform(sym, ...)
}

oops <- function(...) {
  sym <- paste0("\033[31m", "\u2716", "\033[39m")
  inform(sym, ...)
}

done <- function(...) {
  sym <- paste0("\033[32m", "\u2713", "\033[39m")
  inform(sym, ...)
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
