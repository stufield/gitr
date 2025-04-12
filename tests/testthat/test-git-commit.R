
# Setup ----
skip_if_not(is_git())
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
    # override commit author for test below
    "--author='Saruman <whitewizard@isengard.com>'",
    "-m", encodeString(title, quote = "'"),
    "-m", encodeString(msg, quote = "'")
  )

  cmt <- get_commit_msgs(n = 1L)
  expect_type(cmt, "list")
  expect_length(cmt, 1L)

  atts <- attributes(cmt[[1L]])
  expect_true(is_sha(atts$sha))
  expect_equal(atts$sha, git_current_sha())
  expect_equal("whitewizard@isengard.com", atts$author)
  expect_equal(unlist(cmt), c(title, "", msg, ""))
})

test_that("`scrape_commits()` returns expected (must execute after above)", {
  # do this in 2 steps b/c the git-sha will fail with every snapshot
  # step 1
  expect_snapshot(commit <- scrape_commits(1L))

  # step 2
  expect_snapshot(clean_commit_sha(commit))
})

test_that("`git_uncommit()` pops the current commit off the commit stack", {
  sha0  <- git_current_sha()
  title <- "New empty commit for git_uncommit() testing"
  git("commit", "--allow-empty", "-m", encodeString(title, quote = "'"))
  sha1  <- git_current_sha()
  expect_false(sha0 == sha1) # ensure new commit was added
  capture_output(git_uncommit()) # pop stack; silence cat()
  expect_equal(sha0, sha0) # should now be the same again
})

test_that("`git_unstage()` unstages a file from the staging area", {
  writeLines("This is a unit test for `git_unstage()`", con = "DESCRIPTION")
  withr::defer(git_checkout(file = "DESCRIPTION"))   # cleanup
  git("add", "DESCRIPTION")
  staged <- git("diff", "--name-only", "--cached")$stdout
  expect_equal(staged, "DESCRIPTION")  # check staged
  capture_output(git_unstage("DESCRIPTION"))
  staged <- git("diff", "--name-only", "--cached")$stdout
  expect_true(!"DESCRIPTION" %in% staged)  # check not staged
})

test_that("`git_diffcommits()` returns correct output diffing a recent commit", {
  file <- "gitr-diffcommit-file"
  withr::defer({
    git("reset", "HEAD~1")  # cleanup
    unlink(file, force = TRUE)
  })
  writeLines(
    paste0("This is a unit test for `git_diffcommit()`.\n\n",
           "This file should be deleted following unit test cleanup."),
    con = file
  )
  git("add", file)
  git("commit", "-m", encodeString("Add temp unit test file", quote = "'"))
  expect_snapshot(git_diffcommits())
})
