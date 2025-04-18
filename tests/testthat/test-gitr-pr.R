
# Setup ----
skip_if_not(is_git())
dir <- local_create_worktree()   # creates a test br
title <- "Added new empty commit to repo"
msg <- "- and here are some details"


# Testing ----
test_that("`gitr_pr_sha()` errors when not passing a local branch", {
  sha <- gitr_current_sha()
  expect_error(
    gitr_pr_sha(sha),   # passing a SHA is bad
    "branch` must be a local branch. See `gitr_local_br()`",
    fixed = TRUE
  )
  expect_error(
    gitr_pr_sha("foo-br"), # passing non-existing br is bad
    "branch` must be a local branch. See `gitr_local_br()`",
    fixed = TRUE
  )
  expect_error(
    gitr_pr_sha(NA_character_), # passing NA is bad
    "branch` must be a local branch. See `gitr_local_br()`",
    fixed = TRUE
  )
  expect_no_error(gitr_pr_sha(NULL)) # passing NULL is ok
})

test_that("`gitr_pr_sha()` returns proper default", {
  cur_br <- gitr_current_br()
  expect_equal(cur_br, "gitr-test-br")

  git("commit", "--allow-empty -m", encodeString(title, quote = quote),
      "-m", encodeString(msg, quote = quote))

  # here simply take the first sha in case
  # there are local commits that also differ
  # from origin/main we can't rely to be constant
  pr_sha <- gitr_pr_sha(cur_br) |> gitr_trim_sha() |> head(1L)
  expect_true(is_sha(pr_sha))
  expect_equal(pr_sha, gitr_current_sha())
})

test_that("`gitr_pr_msgs()` returns proper default", {
  # here simply take the first sha in case
  # there are local commits that also differ
  # from origin/main we can't rely to be constant
  pr_msg <- gitr_pr_msgs() |> head(1L)

  # test just as in `gitr_commit_msgs()`
  expect_type(pr_msg, "list")
  atts <- attributes(pr_msg[[1L]])
  expect_true(is_sha(atts$sha))
  expect_equal(atts$sha, gitr_current_sha())
  expect_equal(atts$author, "whitewizard@middleearth.com")
  expect_equal(unlist(pr_msg), c(title, "", msg, ""))
})
