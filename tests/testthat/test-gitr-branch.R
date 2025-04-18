
# Setup ----
skip_if_not(is_git())
dir <- local_create_worktree()


# Testing ----
test_that("`gitr_default_br()` returns proper default", {
  expect_equal(gitr_default_br(), "main")
})

test_that("`gitr_current_br()` returns proper default", {
  expect_equal(gitr_current_br(), "gitr-test-br")  # default
  new_br <- "wip-foo"
  withr::defer({
    git("checkout gitr-test-br")  # when finished; jump back to orig br
    git("branch -D", new_br)      # and then delete the 'new_br' branch
  })
  gitr_checkout(new_br)
  expect_equal(gitr_current_br(), new_br)
})
