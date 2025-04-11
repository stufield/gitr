
test_that("`is_git()` can detect whether it is in a Git repo", {
  dir <- tempfile("gitr-is_git-")
  dir.create(dir)
  # not git
  withr::with_dir(dir, expect_false(suppressMessages(is_git())))
  # now git
  withr::with_dir(dir, {
    git("init", echo_cmd = FALSE)
    expect_true(is_git())
  })
})

test_that("the basic functionality of `git()` works as expected", {
  skip_if(isTRUE(Sys.which("git") == ""))
  skip_if_not(is_git())
  expect_invisible(out <- git("status", echo_cmd = FALSE))
  expect_equal(out$status, 0L)
  expect_equal(out$stderr, "")
})

test_that("silencing the git echo is possible via the `gitr_echo_cmd` global option", {
  # use `git("--version")` for testing b/c doesn't require a git repository
  # default; TRUE
  true <- system2("git", "--version", stdout = TRUE)
  expect_equal(git("--version", echo_cmd = FALSE)$stdout, true)

  # over-ride default; FALSE
  withr::with_options(
    list(gitr_echo_cmd = FALSE),
    ver <- git("--version")$stdout
  )
  expect_equal(ver, true)

  # over-ride passed param; TRUE
  withr::with_options(
    list(gitr_echo_cmd = TRUE),
    expect_snapshot(ver <- git("--version", echo_cmd = FALSE)$stdout)
  )
  expect_equal(ver, true)
})

test_that("git_version() returns the correct expected value", {
  true <- system2("git", "--version", stdout = TRUE)
  true <- gsub("git version *([^ ]*)", "\\1", true)
  expect_equal(git_version(), true)
})
