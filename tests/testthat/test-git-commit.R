
# Setup ----
skip_if_not(is_git())   # skips is during R CMD check
dir <- local_create_worktree()


# Testing ----
test_that("`get_commit_msgs()` errors when passed wrong params", {
  expect_error(
    get_commit_msgs(NA),
    "`sha` cannot be NA"
  )
  expect_error(
    get_commit_msgs(character(0)),
    "`sha` must be `character(1)`",
    fixed = TRUE
  )
  expect_error(
    get_commit_msgs(""),
    "`sha` cannot be empty ''"
  )
  expect_error(
    get_commit_msgs(3),
    "`sha` must be `character(1)`",
    fixed = TRUE
  )
})

test_that("`get_commit_msgs()` gives correct commit after adding one", {
  # create an empty commit
  title <- "Added new empty commit to repo"
  msg   <- "- and here are some details"

  git("commit", "--allow-empty",
      "-m", encodeString(title, quote = "'"),
      "-m", encodeString(msg, quote = "'"))

  cmt <- get_commit_msgs(n = 1L)
  expect_type(cmt, "list")
  expect_length(cmt, 1L)

  atts <- attributes(cmt[[1L]])
  expect_true(is_sha(atts$sha))
  expect_equal(atts$sha, git_current_sha())
  expect_true(grepl("^[^ ]+[@][^ ]+[.]com$", atts$author))
  expect_equal(unlist(cmt), c(title, "", msg, ""))
})

test_that("`scrape_commits()` returns expected (must execute after above)", {
  skip("figure out changing sha")
  expect_snapshot(scrape_commits(1L))
})

test_that("`git_uncommit()` pops the current commit off the commit stack", {
  sha0  <- git_current_sha()
  title <- "New empty commit for git_uncommit() testing"
  git("commit", "--allow-empty", "-m", encodeString(title, quote = "'"))
  sha1  <- git_current_sha()
  expect_false(sha0 == sha1) # ensure new commit was added
  sink("out.txt")      # silence cat()
  on.exit(unlink("out.txt", force = TRUE))
  git_uncommit()      # pop stack
  sink(NULL)
  expect_equal(sha0, sha0) # should now be the same again
})
