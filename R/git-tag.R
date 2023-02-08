#' Git Tag Utilities


#' @name tag
NULL


#' @describeIn tag
#'   Get the *most* recent `git` tag.
#' @export
git_recent_tag <- function() {
  tag <- utils::tail(git("tag", "-n")$stdout, 1L)
  gsub("(^v[0-9]+\\.[0-9]+\\.[0-9]+).*", "\\1", tag)
}

#' @describeIn tag
#'   Gets a data frame summary of the current git repository tags.
#' @export
git_tag_info <- function() {
  is_git()
  no_tags <- identical(git("tag", "-l", echo_cmd = FALSE)$stdout, "")
  if ( no_tags ) {
    stop("No tags in repository ...", call. = FALSE)
  }
  tags <- git("tag", "--sort=-v:refname",
    "--format='%(tag)\t%(objectname:short)\t%(object)\t%(subject)\t%(taggername)\t%(taggeremail)\t%(taggeremail:localpart)\t%(taggerdate)\t%(objectsize)'",
    echo_cmd = FALSE)$stdout
  tags <- strsplit(tags, "\t")
  ret  <- data.frame(do.call(rbind, tags))
  names(ret) <- c("tag", "tag_sha", "target_sha", "message",
                  "author", "email", "user", "tagdate", "size")
  rownames(ret)  <- ret$tag
  ret$target_sha <- substr(ret$target_sha, 1, 7)
  ret$path       <- file.path(normalizePath("."), ".git")
  ret
}
