#' Z-shell Aliases
#'
#' Provides functions to common Z-shell git plugin aliases.
#'
#' @name zsh
#'
#' @inheritParams params
#' @inheritParams git
#'
#' @return Most aliases invisibly return `NULL` ... with some exceptions.
#'
#' @examples
#' \dontrun{
#'   glog()
#' }
NULL

#' @describeIn zsh
#'   Get the `git` log in a pretty format for the
#'   `n` most recent commits.
#'
#' @export
glog <- function(n = 10L) {
  if ( is_git() ) {
    out <- git("log", "--oneline", "--graph", "--decorate", "-n", n)$stdout
    if ( not_interactive() ) {
      cat(out, sep = "\n")
    } else {
      out <- gsub("^\\*", "\033[33m*\033[0m", out)               # *s
      out <- gsub("( [a-f0-9]{7} )", "\033[32m\\1\033[0m", out)  # sha1
      out <- gsub("(tag: v[^\\)]+)", "\033[34m\\1\033[0m", out)  # tags
      out <- gsub("(origin/[^\\)]+)", "\033[31m\\1\033[0m", out) # remote branches
      out <- gsub("HEAD -> ([^,\\)]+)", "\033[36mHEAD -> \033[32m\\1\033[0m", out)
      cat(out, sep = "\n")
    }
  }
  invisible()
}

#' @describeIn zsh
#'   `git commit ...`. To avoid masking the [base::gc()] function,
#'   this alias has been re-mapped to [gcc()].
#'
#' @export
gcc <- function(...) {
  git("commit", c(...))
}

#' @describeIn zsh `git commit -m <msg>`.
#'
#' @param msg `character(1)`. The message for the commit subject line.
#'
#' @export
gcmsg <- function(msg = "wip") {
  git("commit", "--no-verify", "-m", encodeString(msg, quote = "'"))
}

#' @describeIn zsh `git checkout`.
#'
#' @export
gco <- function(branch = NULL) {
  git_checkout(branch)
}

#' @describeIn zsh `git checkout -b <branch>`.
#'
#' @export
gcb <- function(branch = NULL) {
  stopifnot(!is.null(branch))
  git("checkout", "-b", branch)
}

#' @describeIn zsh `git pull --rebase`.
#'
#' @export
gpr <- function() {
  if ( is_git() ) {
    git("pull", "--rebase", "--autostash", "-v")
  }
  invisible()
}

#' @describeIn zsh `git push`.
#'
#' @export
gp <- function(...) {
  if ( is_git() ) {
    git("push", c(...))
  }
  invisible()
}

#' @describeIn zsh `git push -u origin`.
#'
#' @export
gpu <- function() {
  if ( is_git() ) {
    git("push", "-u", "origin")
  }
  invisible()
}

#' @describeIn zsh `git push --dry-run`.
#'
#' @export
gpd <- function() {
  if ( is_git() ) {
    out <- git("push", "--dry-run")$stdout
    cat(out, sep = "\n")
  }
  invisible()
}

#' @describeIn zsh `git status`.
#'
#' @export
gst <- function() {
  if ( is_git() ) {
    out <- git("status")$stdout
    cat(out, sep = "\n")
  }
  invisible(out)
}

#' @describeIn zsh `git status -s`.
#'
#' @export
gss <- function() {
  if ( is_git() ) {
    out <- git("status", "-s")$stdout
    if ( not_interactive() ) {
      cat(out, sep = "\n")
    } else {
      gsub("^(.)(.)", "\033[32m\\1\033[31m\\2\033[0m", out) |> cat(sep = "\n")
    }
  }
  invisible(out)
}

#' @describeIn zsh `git branch -a`.
#'
#' @export
gba <- function() {
  if ( is_git() ) {
    out <- git("branch", "-a")$stdout
    if ( not_interactive() ) {
      cat(out, sep = "\n")
    } else {
      out <- gsub("(^\\* .+)", "\033[32m\\1\033[0m", out)
      out <- gsub("(remotes/.+)", "\033[31m\\1\033[0m", out)
      cat(out, sep = "\n")
    }
  }
  invisible()
}

#' @describeIn zsh `git branch -dD`.
#'
#' @param force `logical(1)`. Should the branch
#'   delete be forced with the `-D` flag?
#'
#' @export
gbd <- function(branch = NULL, force = FALSE) {
  if ( is_git() ) {
    stopifnot(!is.null(branch))
    git("branch", ifelse(force, "-D", "-d"), branch)
  }
  invisible()
}

#' @describeIn zsh `git branch --merged <branch>`.
#'
#' @export
gbmm <- function(branch = git_default_br()) {
  if ( is_git() ) {
    out <- git("branch", "--merged", branch)
    if ( not_interactive() ) {
      cat(out$stdout, sep = "\n")
    } else {
      gsub("(.+)", "\033[32m\\1\033[0m", out$stdout) |> cat(sep = "\n")
    }
  }
  invisible()
}

#' @describeIn zsh `git branch --no-merged <branch>`.
#'
#' @export
gbnm <- function(branch = git_default_br()) {
  if ( is_git() ) {
    out <- git("branch", "--no-merged", branch)
    if ( not_interactive() ) {
      cat(out$stdout, sep = "\n")
    } else {
      gsub("(.+)", "\033[31m\\1\033[0m", out$stdout) |> cat(sep = "\n")
    }
  }
  invisible()
}

#' @describeIn zsh `git branch -m`.
#'
#' @export
gbm <- function(branch = NULL) {
  if ( is_git() ) {
    stopifnot(!is.null(branch))
    git("branch", "-m", branch)
  }
  invisible()
}

#' @describeIn zsh `git add ...`.
#'
#' @export
ga <- function(...) {
  if ( is_git() ) {
    invisible(git("add", c(...)))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git add --all`.
#'
#' @export
gaa <- function() {
  if ( is_git() ) {
    invisible(git("add", "--all"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git add -u`.
#'
#' @export
gau <- function() {
  if ( is_git() ) {
    invisible(git("add", "-u"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash`.
#'
#' @export
gsta <- function() {
  if ( is_git() ) {
    invisible(git("stash"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash list`.
#'
#' @export
gstl <- function() {
  if ( is_git() ) {
    out <- git("stash", "list")
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash apply`.
#'   **Note** zero-indexing!
#'
#' @export
gstaa <- function(n = 0) {
  if ( is_git() ) {
    invisible(git("stash", "apply", paste0("stash@{", n, "}")))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash drop`.
#'   **Note** zero-indexing!
#'
#' @export
gstd <- function(n = 0) {
  if ( is_git() ) {
    invisible(git("stash", "drop", paste0("stash@{", n, "}")))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash clear`. Danger!
#'
#' @export
gstc <- function() {
  if ( is_git() ) {
    invisible(git("stash", "clear"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash show`.
#'
#' @param text `logical(1)`. Show the text diffs from the stash.
#'
#' @export
gsts <- function(text = FALSE) {
  if ( is_git() ) {
    if ( text ) {
      out <- git("stash", "show", "--text")$stdout
      tmp <- gsub("(^\\+.*$)", "\033[32m\\1\033[0m", out)
      tmp <- gsub("(^\\-.*$)", "\033[31m\\1\033[0m", tmp)
    } else {
      out <- git("stash", "show")$stdout
      tmp <- gsub("(\\+)", "\033[32m\\1\033[0m", out)
      tmp <- gsub("(\\-)", "\033[31m\\1\033[0m", tmp)
    }
    cat(tmp, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}

#' @describeIn zsh `git stash pop --quiet --index`.
#'
#' @export
gpop <- function() {
  if ( is_git() ) {
    invisible(git("stash", "pop", "--quiet", "--index"))
  } else {
    invisible()
  }
}

#' @describeIn zsh See `gpop()`.
#'
#' @export
gstp <- gpop

#' @describeIn zsh `git tag -n`.
#'
#' @export
gtn <- function() {
  if ( is_git() ) {
    out <- rev(git("tag", "-n")$stdout)
    if ( not_interactive() ) {
      cat(out, sep = "\n")
    } else {
      out <- gsub("^(v[0-9]+\\.[0-9]+\\.[0-9]+)", "\033[31m\\1\033[0m", out)
      cat(out, sep = "\n")
    }
  }
  invisible()
}

#' @describeIn zsh `git fetch --all --prune`.
#'
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
#'
#' @export
gac <- function() {
  if ( is_git() ) {
    invisible(git("commit", "--no-verify", "--amend", "--no-edit"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git commit --no-verify -m 'wip'`.
#'
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
#'
#' @param dry_run `logical(1)`. Clean as dry-run?
#'
#' @export
gclean <- function(dry_run = TRUE) {
  if ( is_git() ) {
    if ( dry_run ) {
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
#'
#' @param file A full file path within the repository to diff.
#'
#' @param staged `logical(1)`. Compare a staged file to `HEAD`?
#'   Otherwise the working directory is compared to the
#'   index (`staged` or `HEAD`).
#'
#' @export
gdf <- function(file = NULL, staged = FALSE) {
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
#'
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

#' @describeIn zsh `git reset --hard && git clean -df`.
#'
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
#'
#' @param global `logical(1)`. Query global repository.
#'   Alternatively local configuration only.
#'
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
#'
#' @export
gcm <- function() {
  if ( is_git() ) {
    git_checkout(git_default_br())
  }
  invisible()
}

#' @describeIn zsh `git rm ...`.
#'
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

#' @describeIn zsh `git rebase --continue`.
#'
#' @export
grbc <- function() {
  if ( is_git() ) {
    invisible(git("rebase", "--continue"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git rebase --abort`.
#'
#' @export
grba <- function() {
  if ( is_git() ) {
    invisible(git("rebase", "--abort"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git rebase --skip`.
#'
#' @export
grbs <- function() {
  if ( is_git() ) {
    invisible(git("rebase", "--skip"))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git rebase git_default_br()`.
#'
#' @export
grbm <- function() {
  if ( is_git() ) {
    invisible(git("rebase", git_default_br()))
  } else {
    invisible()
  }
}

#' @describeIn zsh `git remote -v`.
#'
#' @export
grv <- function() {
  if ( is_git() ) {
    out <- git("remote", "-v")
    cat(out$stdout, sep = "\n")
    invisible(out)
  } else {
    invisible()
  }
}
