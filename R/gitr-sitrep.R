#' Git Situation Report
#'
#' Get a situation report of the current git repository.
#'
#' @name sitrep
#'
#' @return `NULL` ... invisibly.
#'
#' @export
gitr_sitrep <- function() {
  if ( is_git() ) {
    cat("Using Git version: ", slug_color(git_version(), "\033[34m"), "\n\n", sep = "")
    cat("Current branch: ", slug_color(gitr_current_br(), "\033[32m"), "\n", sep = "")
    cat("Default branch: ", slug_color(gitr_default_br(), "\033[36m"), "\n", sep = "")

    cat("\nRepo status:\n")
    gss()

    cat("\nBranches:\n")
    gba()

    br <- gitr_current_br()
    be <- git("rev-list --count", paste0(br, "..@{upstream}"),
              echo_cmd = FALSE)$stdout
    ah <- git("rev-list --count", paste0("@{upstream}..", br),
              echo_cmd = FALSE)$stdout
    remote <- git("remote show", echo_cmd = FALSE)$stdout

    cat("\nLocal status:\n")
    if ( ah == "0" && be == "0" ) {
      done("OK")
    }
    if ( ah > "0" ) {
      plur <- ifelse(ah == "1", "commit.\n", "commits.\n")
      cat("Your local branch", slug_color(br),
          "is ahead of", slug_color(paste0(remote, "/", br), "\033[34m"),
          "by", ah, plur)
    }
    if ( be > "0" ) {
      plur <- ifelse(be == "1", "commit.\n", "commits.\n")
      cat("Your local branch", slug_color(br),
          "is behind", slug_color(paste0(remote, "/", br), "\033[34m"),
          "by", be, plur)
    }

    cat("\nUpstream remotes: ", slug_color(remote, "\033[33m"), "\n", sep = "")
    br_verb <- git("branch -vv", echo_cmd = FALSE)$stdout
    if ( not_interactive() ) {
      cat(br_verb, sep = "\n")
    } else {
      br_verb |>
        gsub(pattern = "(^\\* [[:alnum:]|_-]+ )", replacement = "\033[32m\\1\033[0m") |>
        gsub(pattern = "(origin/[[:alnum:]|_-]+)", replacement = "\033[34m\\1\033[0m") |>
        cat(sep = "\n")
    }

    cat("\nCommit log: ", slug_color(br, "\033[32m"), "\n", sep = "")
    glog(5L)
  } else {
    invisible(NULL)
  }
}
