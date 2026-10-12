
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

test_that("silencing the echo is possible via `gitr_echo_cmd=` global option", {
  # use `git("--version")` for testing b/c does not
  # require a git repository

  # default; NULL (unset); TRUE
  withr::with_options(
    list(gitr_echo_cmd = NULL),
    expect_snapshot(ver <- git("--version"))
  )

  # passed param; FALSE
  withr::with_options(
    list(gitr_echo_cmd = NULL),
    expect_snapshot(ver <- git("--version", echo_cmd = FALSE))
  )

  # over-ride passed param; TRUE
  withr::with_options(
    list(gitr_echo_cmd = TRUE),
    expect_snapshot(ver <- git("--version", echo_cmd = FALSE))
  )

  # over-ride default; FALSE
  withr::with_options(
    list(gitr_echo_cmd = FALSE),
    expect_snapshot(ver <- git("--version", echo_cmd = FALSE))
  )
})

test_that("`git()` echoes failure only when the command has output", {
  # neither command needs a repo; no snapshot b/c stderr text
  #   varies by git version
  withr::local_options(list(gitr_echo_cmd = FALSE))

  # quiet: `config --get` of an unset key (empty config file)
  #   exits 1 with no output; an answer, not a failure
  expect_silent(res <- git("config --file", nullfile(), "--get gitr.nope"))
  expect_equal(res$status, 1L)

  # real error: unknown flag exits 129 with usage text
  expect_output(res <- git("--gitr-bogus-flag"), "System command 'git' failed")
  expect_true(res$status != 0L)
})

test_that("`git_version()` returns the correct expected value", {
  ver <- system2("git", "--version", stdout = TRUE)
  ver <- gsub(".*([1-3]\\.[0-9]{1,3}\\.[0-9]{1,3}).*", "\\1", ver)
  expect_equal(git_version(), ver)
})
