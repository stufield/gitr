#' Git Tag Utilities
#'
#' @name tag
#'
#' @examples
#' \dontrun{
#'   gitr_recent_tag()
#'
#'   gitr_tag_info()
#' }
NULL

#' @describeIn tag
#'   gets the *most* recent `git` tag.
#'
#' @return [gitr_recent_tag()]: `character(1)`. The most recent tag.
#'
#' @export
gitr_recent_tag <- function() {
  utils::head(git("tag --sort=-taggerdate", echo_cmd = FALSE)$stdout, 1L)
}

#' @describeIn tag
#'   gets a data frame summary of
#'   the current git repository tags.
#'
#' @return [gitr_tag_info()]: A data frame summarizing the repository tags.
#'
#' @export
gitr_tag_info <- function() {
  is_git()
  no_tags <- identical(git("tag -l", echo_cmd = FALSE)$stdout, "")
  if ( no_tags ) {
    info("No tags in repository ...")
    return(invisible(NULL))
  }
  tags <- git("tag --sort=-v:refname",
    "--format=\"%(tag)\t%(objectname:short)\t%(object)\t%(subject)\t%(taggername)\t%(taggeremail)\t%(taggeremail:localpart)\t%(taggerdate)\t%(objectsize)\"",
    echo_cmd = FALSE)$stdout
  tags <- strsplit(tags, "\t")
  ret  <- data.frame(do.call(rbind, tags))
  names(ret) <- c("tag", "tag_sha", "target_sha", "message",
                  "author", "email", "user", "tagdate", "size")
  rownames(ret)  <- ret$tag
  ret$target_sha <- gitr_trim_sha(ret$target_sha)
  ret$path       <- file.path(normalizePath("."), ".git")
  ret
}
