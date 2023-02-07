
test_that("the basic functionality of git() works as expected", {
  expect_invisible(out <- git("status", echo_cmd = FALSE))
  expect_equal(out$status, 0)
  expect_equal(out$stderr, "")
})
