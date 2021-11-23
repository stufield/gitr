#' Z-shell Aliases
#'
#' Provides ZSH-like aliases to common Z-shell plugin aliases.
#'
#' @name zsh
#' @param n Numeric. How far back to go from current HEAD. Same as the
#' command line `git log -n` parameter.
#' @param branch Character. The name of a branch, typically a
#' feature branch.
#' @param dry.run Logical. Clean as dry-run?
#' @examples
#' \dontrun{
#' glog()
#' }
NULL

#' @describeIn zsh
#' Get the `git` log in a pretty format for the `n` most recent commits.
#' @export
glog <- function(n = 10) {
  if ( is_git() ) {
    log <- git("log", "--oneline", "--graph", "--decorate", "-n", n)$stdout
    out <- strsplit(log, "\n")[[1L]]
    out <- gsub("^\\*", "\033[33m*\033[0m", out)               # *s
    out <- gsub("( [a-f0-9]{7} )", "\033[32m\\1\033[0m", out)  # sha1
    out <- gsub("(tag: v[^\\)]+)", "\033[34m\\1\033[0m", out)  # tags
    out <- gsub("(origin/[^\\)]+)", "\033[31m\\1\033[0m", out) # remote branches
    out <- gsub("HEAD -> ([^,\\)]+)", "\033[36mHEAD -> \033[32m\\1\033[0m", out)
    cat(out, sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git checkout`.
#' @export
gco <- function(branch = NULL) {
  git_checkout(branch)
}

#' @describeIn zsh `git pull --rebase`.
#' @export
gpr <- function() {
  if ( is_git() ) {
    invisible(git("pull", "--rebase", "--autostash", "-v"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git status -s`.
#' @export
gss <- function() {
  if ( is_git() ) {
    out <- strsplit(git("status", "-s")$stdout, "\n")[[1L]]
    gsub("^(.)(.)", "\033[32m\\1\033[31m\\2\033[0m", out) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git branch -a`.
#' @export
gba <- function() {
  if ( is_git() ) {
    out <- strsplit(git("branch", "-a")$stdout, "\n")[[1L]]
    out <- gsub("(^\\* .+)", "\033[32m\\1\033[0m", out)
    gsub("(remotes/.+)", "\033[31m\\1\033[0m", out) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git add -u`.
#' @export
gau <- function() {
  if ( is_git() ) {
    invisible(git("add", "-u"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash pop`.
#' @export
gpop <- function() {
  if ( is_git() ) {
    invisible(git("stash", "pop", "--index"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git tag -n`.
#' @export
gta <- function() {
  if ( is_git() ) {
    out <- rev(strsplit(git("tag", "-n")$stdout, "\n")[[1L]])
    gsub("^(v[0-9]+\\.[0-9]+\\.[0-9]+)", "\033[31m\\1\033[0m", out) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git fetch --all --prune`.
#' @export
gfa <- function() {
  if ( is_git() ) {
    out <- git("fetch", "--all", "--prune")
    cat(out$stdout, "\n")
    cat(out$stderr)
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git commit --amend --no-edit`.
#' @export
gac <- function() {
  if ( is_git() ) {
    invisible(git("commit", "--amend", "--no-edit"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git commit -m 'wip'`.
#' @export
gwip <- function() {
  if ( is_git() ) {
    gau()
    invisible(git("commit", "-m", "wip"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git clean -f -d`.
#' @export
gclean <- function(dry.run = TRUE) {
  if ( is_git() ) {
    if ( dry.run ) {
      out <- git("clean", "-f", "-d", "-n")$stdout
    } else {
      out <- git("clean", "-f", "-d")$stdout
    }
    cat(out)
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git diff <file>`.
#' @param file A full file path within the repository to diff.
#' @export
gdf <- function(file = NULL) {
  stopifnot(!is.null(file))
  if ( is_git() ) {
    out <- strsplit(git("diff", file)$stdout, "\n")[[1L]]
    out <- gsub("(^\\+.*$)", "\033[32m\\1\033[0m", out)
    out <- gsub("(^\\-.*$)", "\033[31m\\1\033[0m", out)
    cat(out, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git reset --hard`.
#' @export
gnuke <- function() {
  if ( is_git() ) {
    out <- git("reset", "--hard")$stdout
    cat(out)
    gclean(FALSE)
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git config --local` or `git config --global`.
#' @param global Logical. Query global repository. Alternatively local config.
#' @export
gcf <- function(global = FALSE) {
  if ( !global && is_git() ) {
    out <- git("config", "--list", "--local")
  } else {
    out <- git("config", "--list", "--global")
  }
  out <- strsplit(out$stdout, "\n")[[1L]]
  gsub("(^.*)=(.*$)", "\033[31m\\1\033[0m = \033[36m\\2\033[0m", out) |>
    cat(sep = "\n")
  invisible()
}
