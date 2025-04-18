#' SHA1 Utilities
#'
#' @name sha
#'
#' @inheritParams params
NULL

#' @describeIn sha
#'   trims the `SHA-1` hash from the default full
#'   length to the human-readable short version.
#'
#' @return [gitr_trim_sha()]: `character(1)`. The trimmed `sha`.
#'   If `sha` is not a `SHA1` hash, the identical string unchanged.
#'
#' @export
gitr_trim_sha <- function(sha) {
  idx <- which(is_sha(sha))
  sha[idx] <- substr(sha[idx], start = 1L, stop = 7L)
  sha
}

#' @describeIn sha
#'   determines whether strings to be tested are a `SHA1` hash
#'   via regular expression (`"^[a-f0-9]{5,40}$"`) match.
#'
#' @return [is_sha()]: `logical(1)`. If `sha` matches the
#'   `SHA1` expected pattern.
#'
#' @seealso [grepl()]
#'
#' @export
is_sha <- function(sha) {
  grepl("^[a-f0-9]{5,40}$", sha)
}

#' @describeIn sha
#'   gets the current (most recent commit) SHA.
#'
#' @return [gitr_current_sha()]: `character(1)`. The `sha`
#'   of the current commit.
#'
#' @export
gitr_current_sha <- function() {
  sha <- git("rev-parse HEAD")$stdout
  gitr_trim_sha(sha)
}
