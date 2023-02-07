
test_that("the basic functionality of git() works as expected", {
  skip_if(isTRUE(Sys.which("git") == ""))
  skip_if_not(is_git())
  expect_invisible(out <- git("status", echo_cmd = FALSE))
  expect_equal(out$status, 0L)
  expect_equal(out$stderr, "")
})
