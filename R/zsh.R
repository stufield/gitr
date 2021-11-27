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
#' @inheritParams git
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
    out <- git("log", "--oneline", "--graph", "--decorate", "-n", n)$stdout
    out <- gsub("^\\*", "\033[33m*\033[0m", out)               # *s
    out <- gsub("( [a-f0-9]{7} )", "\033[32m\\1\033[0m", out)  # sha1
    out <- gsub("(tag: v[^\\)]+)", "\033[34m\\1\033[0m", out)  # tags
    out <- gsub("(origin/[^\\)]+)", "\033[31m\\1\033[0m", out) # remote branches
    out <- gsub("HEAD -> ([^,\\)]+)", "\033[36mHEAD -> \033[32m\\1\033[0m", out)
    cat(out, sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git commit ...`.
#' @export
gc <- function(...) {
  git("commit", c(...))
}

#' @describeIn zsh `git commit -m <msg>`.
#' @param msg Character. The message for the commit subject line.
#' @export
gcmsg <- function(msg = "wip") {
  git("commit", "--no-verify", "-m", msg)
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
    git("pull", "--rebase", "--autostash", "-v")
  }
  invisible()
}

#' @describeIn zsh `git push`.
#' @export
gp <- function(...) {
  if ( is_git() ) {
    git("push", c(...))
  }
  invisible()
}

#' @describeIn zsh `git push --dry-run`.
#' @export
gpd <- function() {
  if ( is_git() ) {
    out <- git("push", "--dry-run")$stdout
    cat(out, sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git status -s`.
#' @export
gss <- function() {
  if ( is_git() ) {
    out <- git("status", "-s")$stdout
    gsub("^(.)(.)", "\033[32m\\1\033[31m\\2\033[0m", out) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git branch -a`.
#' @export
gba <- function() {
  if ( is_git() ) {
    out <- git("branch", "-a")$stdout
    out <- gsub("(^\\* .+)", "\033[32m\\1\033[0m", out)
    gsub("(remotes/.+)", "\033[31m\\1\033[0m", out) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git branch -dD`.
#' @param force Loogical. Should the branch delete be forced with the `-D` flag?
#' @export
gbd <- function(branch = NULL, force = FALSE) {
  if ( is_git() ) {
    stopifnot(!is.null(branch))
    git("branch", ifelse(force, "-D", "-d"), branch)
  }
  invisible()
}

#' @describeIn zsh `git branch --merged <branch>`.
#' @export
gbmm <- function(branch = "master") {
  if ( is_git() ) {
    out <- git("branch", "--merged", branch)
    gsub("(.+)", "\033[32m\\1\033[0m", out$stdout) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git branch --no-merged <branch>`.
#' @export
gbnm <- function(branch = "master") {
  if ( is_git() ) {
    out <- git("branch", "--no-merged", branch)
    gsub("(.+)", "\033[31m\\1\033[0m", out$stdout) |> cat(sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git branch -m`.
#' @export
gbm <- function(branch = NULL) {
  if ( is_git() ) {
    stopifnot(!is.null(branch))
    git("branch", "-m", branch)
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

#' @describeIn zsh `git stash pop --index`.
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
    out <- rev(git("tag", "-n")$stdout)
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

#' @describeIn zsh `git commit --no-verify --amend --no-edit`.
#' @export
gac <- function() {
  if ( is_git() ) {
    invisible(git("commit", "--no-verify", "--amend", "--no-edit"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git commit --no-verify -m 'wip'`.
#' @export
gwip <- function() {
  if ( is_git() ) {
    gau()
    invisible(gcmsg())
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
    cat(out, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git diff <file>`.
#' @param file A full file path within the repository to diff.
#' @param staged Logical. Should the staged file be compared to HEAD?
#' @export
gdf <- function(file = NULL, staged = FALSE) { # sldfj
  stopifnot(!is.null(file))
  if ( is_git() ) {
    if ( staged ) {
      out <- git("diff", "--cached", file)$stdout
    } else {
      out <- git("diff", file)$stdout
    }
    tmp <- gsub("(^\\+.*$)", "\033[32m\\1\033[0m", out)
    tmp <- gsub("(^\\-.*$)", "\033[31m\\1\033[0m", tmp)
    cat(tmp, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git push --force-with-lease`.
#' @export
gpf <- function() {
  if ( is_git() ) {
    out <- git("push", "--force-with-lease")
    cat(out$stdout, sep = "\n")
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
    cat(out, sep = "\n")
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
  gsub("(^.*)=(.*$)", "\033[31m\\1\033[0m = \033[36m\\2\033[0m", out$stdout) |>
    cat(sep = "\n")
  invisible()
}

#' @describeIn zsh Checkout the default branch.
#' @export
gcm <- function() {
  if ( is_git() ) {
    git_checkout(git_default_br())
  }
  invisible()
}

#' @describeIn zsh `git rm ...`.
#' @export
grm <- function(...) {
  if ( is_git() ) {
    out <- git("rm", c(...))$stdout
    cat(out, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}
