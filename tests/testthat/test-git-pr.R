
# Setup ----
skip_if_not(is_git())
dir <- local_create_worktree()   # creates a test br
title <- "Added new empty commit to repo"
msg <- "- and here are some details"


# Testing ----
test_that("`get_pr_sha()` errors when not passing a local branch", {
  sha <- git_current_sha()
  expect_error(
    get_pr_sha(sha),   # passing a SHA is bad
    "branch` must be a local branch. See `git_local_br()`",
    fixed = TRUE
  )
  expect_error(
    get_pr_sha("foo-br"), # passing non-existing br is bad
    "branch` must be a local branch. See `git_local_br()`",
    fixed = TRUE
  )
  expect_error(
    get_pr_sha(NA_character_), # passing NA is bad
    "branch` must be a local branch. See `git_local_br()`",
    fixed = TRUE
  )
  expect_no_error(get_pr_sha(NULL)) # passing NULL is ok
})

test_that("`get_pr_sha()` returns proper default", {
  cur_br <- git_current_br()
  expect_equal("gitr-test-br", cur_br)

  git("commit", "--allow-empty",
    # override commit author for test below
    "--author='Saruman <whitewizard@isengard.com>'",
    "-m", encodeString(title, quote = "'"),
    "-m", encodeString(msg, quote = "'")
  )

  # here simply take the first sha in case
  # there are local commits that also differ
  # from origin/main we can't rely to be constant
  pr_sha <- get_pr_sha(cur_br) |> trim_sha() |> head(1L)
  expect_true(is_sha(pr_sha))
  expect_equal(pr_sha, git_current_sha())
})

test_that("`get_pr_msgs()` returns proper default", {
  # here simply take the first sha in case
  # there are local commits that also differ
  # from origin/main we can't rely to be constant
  pr_msg <- get_pr_msgs() |> head(1L)

  # test just as in `get_commit_msgs()`
  expect_type(pr_msg, "list")
  atts <- attributes(pr_msg[[1L]])
  expect_true(is_sha(atts$sha))
  expect_equal(atts$sha, git_current_sha())
  expect_equal("whitewizard@isengard.com", atts$author)
  expect_equal(unlist(pr_msg), c(title, "", msg, ""))
})
