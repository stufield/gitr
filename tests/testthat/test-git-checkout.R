
# Setup ----
skip_if_not(is_git())
dir <- local_create_worktree()


# Testing ----
test_that("`git_checkout()` errors when params are bad", {
  expect_error(
    git_checkout(),
    "You must pass a either `branch` or a `file` to checkout."
  )
  expect_error(
    git_checkout("DESCRIPTION"),  # common error; param order
    "`branch` cannot have the same name as a tracked file."
  )
  expect_error(
    git_checkout("foo", "bar"),
    "You cannot pass *both* a `branch` and a `file` to checkout.",
    fixed = TRUE
  )
})

test_that("`git_checkout()` checks out a branch when asked", {
  new_br <- "feature-wip"
  withr::defer(git("branch", "-D", new_br)) # delete the 'new_br' branch
  git_checkout(new_br)
  expect_true(new_br %in% git_local_br())   # new br is created
  expect_equal(git_current_br(), new_br)    # switched to new br
  git_checkout("gitr-test-br")          # go back to default br
  expect_equal(git_current_br(), "gitr-test-br")
})

test_that("`git_checkout()` checks out a file when asked", {
  withr::local_options(list(gitr_echo_cmd = TRUE)) # turn on for snapshot
  # no changes; 0 paths updated from index
  expect_snapshot(git_checkout(file = "DESCRIPTION"))

  files <- c("NAMESPACE", "DESCRIPTION", "NEWS.md", "README.Rmd")
  unlink(files, force = TRUE)  # delete 4 files
  # 4 deletions; 4 paths updated from index
  expect_snapshot(git_checkout(file = files))
})
