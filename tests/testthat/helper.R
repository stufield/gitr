
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
  git("worktree add --track -B", branch, dir)

  # rm local branch (last)
  # local branch created automatically as worktree added
  # remove local branch connected to worktree
  withr::defer(git("branch -D", branch), envir = env)

  # delete git worktree and delete directory when done
  withr::defer(git("worktree remove --force", dir), envir = env)

  # change working directory to worktree
  setwd(dir)

  # temp change commit authorship for worktree during fixture
  user  <- "Gandalf White"
  email <- "whitewizard@middleearth.com"
  git("config --local user.name", encodeString(user, quote = quote))
  git("config --local user.email", encodeString(email, quote = quote))

  # return to original (global) authorship
  # warning! this removes any local user configs
  # you may have in the repository; be careful running tests!
  withr::defer({
    git("config --unset user.name")
    git("config --unset user.email")
  }, envir = env)

  # return to original pwd when done
  withr::defer(setwd(pwd), envir = env)

  invisible(dir)
}

# helper for standardizing non-standard
# sha entries
clean_commit_sha <- function(x, fake_sha = "abc1234") {
  stopifnot(length(x) == 1L)
  attr(x[[1L]], "sha") <- fake_sha  # clean attr of 1L
  setNames(x, fake_sha)             # rename
}

# this is for command line quoting
# around encoded strings; see encodeString()
quote <- ifelse(.Platform$OS.type == "windows", "\"", "'")
