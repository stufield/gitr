
local_create_worktree <- function(dir    = tempfile("gitr-"),
                                  branch = "gitr-test-br",
                                  env    = parent.frame()) {
  withr::local_options(
    list(gitr_echo_cmd = FALSE),
    .local_envir = env
  )

  # get current directory
  pwd <- getwd()

  # create new directory
  dir.create(dir)

  # initialize testing git worktree repo
  git("worktree", "add", "--track", "-B", branch, dir)

  # rm local branch (last)
  # local branch created automatically as worktree added
  # remove local branch connected to worktree
  withr::defer(git("branch", "-D", branch), envir = env)

  # delete git worktree and delete directory when done
  withr::defer(git("worktree", "remove", "--force", dir), envir = env)

  # change working directory to worktree
  setwd(dir)

  # return to original pwd when done
  withr::defer(setwd(pwd), envir = env)

  invisible(dir)
}


clean_commit_sha <- function(x, fake_sha = "abc1234") {
  stopifnot(length(x) == 1L)
  attr(x[[1L]], "sha") <- fake_sha  # clean attr of 1L
  setNames(x, fake_sha)             # rename
}
