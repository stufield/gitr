#' Git Situation Report
#'
#' Get a situation report of the current git repository.
#'
#' @export
git_sitrep <- function() {
  if ( is_git() ) {
    cat("Using Git version:", slug_color(git_version(), "\033[34m"), "\n")
    cat("\nCurrent Branch:", slug_color(git_current_br(),"\033[32m"), "\n")
    cat("\nDefault Branch:", slug_color(git_default_br(),"\033[36m"), "\n")

    cat("\nBranches:\n")
    gba()

    cat("\nRepo status:\n")
    gss()

    br <- trimws(gsub("\\*", "", git("branch", echo_cmd = FALSE)$stdout))
    rt <- trimws(git("branch", "-r", echo_cmd = FALSE)$stdout)
    lgl <- vapply(br, function(.x) any(grepl(paste0(.x, "$"), rt)), NA)
    br <- br[lgl]
    up <- lapply(br, function(branch) {
      be <- git("rev-list", "--count", paste0(branch, "..@{upstream}"),
                echo_cmd = FALSE)$stdout
      ah <- git("rev-list", "--count", paste0("@{upstream}..", branch),
                echo_cmd = FALSE)$stdout
      data.frame(branch = branch, ahead = ah, behind = be)
    })
    cat("\nUpstream remote:\n")
    print(do.call(rbind, up))

    cat("\nCommit", slug_color(git_current_br(), "\033[32m"), "Log:\n")
    glog(5)
  } else {
    invisible()
  }
}
