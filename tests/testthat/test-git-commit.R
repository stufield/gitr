
withr::local_options(list(gitr_echo_cmd = FALSE))
skip_if_not(is_git())


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

test_that("`get_commit_msgs()` gives correct values on return", {
  # only basic testing here because difficult to test programmatically
  cmt <- get_commit_msgs(n = 1L)
  expect_length(cmt, 1L)
  cmt <- cmt[[1L]]
  expect_true(is_sha(attr(cmt, "sha")))
  expect_true(
    grepl("^[^ ]+[@][^ ]+[.]com$", attr(cmt, "author"))
  )
  expect_true(all(vapply(cmt, is.character, NA)))
  expect_equal(cmt[2L], "")  # empty 2nd row
})
