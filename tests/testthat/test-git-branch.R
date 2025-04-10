
# Setup ----
skip_if_not(is_git())   # skips is during R CMD check
dir <- local_create_worktree()


# Testing ----
test_that("`git_default_br()` returns proper default", {
  expect_equal(git_default_br(), "main")
})

test_that("`git_current_br()` returns proper default", {
  expect_equal(git_current_br(), "gitr-test-br")  # default
  new_br <- "wip-foo"
  git_checkout(new_br)
  expect_equal(git_current_br(), new_br)
})
