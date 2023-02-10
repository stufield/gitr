#' SHA1 Utilities


#' @name sha
#' @inheritParams params
NULL

#' @describeIn sha
#'   trims the `SHA-1` hash from the default full length to the
#'   human-readable short version.
#' @return Character. The trimmed `sha`.
#' @export
trim_sha <- function(sha) {
  stopifnot(
    "`sha` must be a character." = is.character(sha),
    "`sha` must be longer than 7 chars." = nchar(sha) > 7
  )
  substr(sha, start = 1L, stop = 7L)
}
