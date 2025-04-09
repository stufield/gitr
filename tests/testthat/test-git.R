
test_that("the basic functionality of `git()` works as expected", {
  skip_if(isTRUE(Sys.which("git") == ""))
  skip_if_not(is_git())
  expect_invisible(out <- git("status", echo_cmd = FALSE))
  expect_equal(out$status, 0L)
  expect_equal(out$stderr, "")
})

test_that("silencing the git echo is possible via the `gitr.echo_cmd` global option", {
  # use `git("--version")` for testing b/c doesn't require a git repository
  # default; TRUE
  true <- system2("git", "--version", stdout = TRUE)
  expect_equal(git("--version", echo_cmd = FALSE)$stdout, true)

  # over-ride default; FALSE
  withr::with_options(
    list(gitr.echo_cmd = FALSE),
    ver <- git("--version")$stdout
  )
  expect_equal(ver, true)

  # over-ride passed param; TRUE
  withr::with_options(
    list(gitr.echo_cmd = TRUE),
    expect_snapshot(ver <- git("--version", echo_cmd = FALSE)$stdout)
  )
  expect_equal(ver, true)
})
