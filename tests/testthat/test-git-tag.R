
# Setup ----
skip_if_not(is_git())
withr::local_options(list(gitr_echo_cmd = FALSE))
tagname <- "gitr-unit-tag"
withr::defer(git("tag", "--delete", tagname))


# Testing ----
test_that("`gitr_recent_tag()` gets the most recent tag", {
  # create a new tag
  git("tag", "-a", tagname, "-m",
      encodeString("Unit test tag v0.0.9000", quote = "'"))
  expect_equal(git_recent_tag(), tagname)
})

test_that("`gitr_tag_info()` unit tests (minimal)", {
  tag_df <- git_tag_info()
  expect_s3_class(tag_df, "data.frame")
  expect_named(tag_df, c("tag", "tag_sha", "target_sha", "message",
                          "author", "email", "user", "tagdate",
                          "size", "path"))
  expect_true(nrow(tag_df) > 0L)
  recent_tag <- tag_df[tagname, ]
  expect_equal(recent_tag$tag, tagname)
  expect_equal(recent_tag$message, "Unit test tag v0.0.9000")
})
