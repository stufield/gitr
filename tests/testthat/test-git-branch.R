
withr::local_options(list(gitr_echo_cmd = FALSE))
skip_if_not(is_git())

# Testing ----
# tests `git_checkout()` and current and default branch functions

test_that("`git_default_br()` returns proper default", {
  expect_equal(git_default_br(), "main")
})

test_that("`git_current_br()` returns proper default", {
  cur <- git_current_br()
  withr::defer(git_checkout(cur))
  withr::defer(git("branch", "-D", "wip-foo"), priority = "last")
  git_checkout("wip-foo")
  expect_equal(git_current_br(), "wip-foo")
})
