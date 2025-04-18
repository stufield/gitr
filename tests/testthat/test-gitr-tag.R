
# Setup ----
skip_if_not(is_git())

dir <- local_create_worktree()

tag_name <- "gitr-unit-tag"

# create a new tag
git("tag -a", tag_name, "-m", encodeString("Unit test tag v0.0.9000",
                                          quote = quote))

withr::defer(git("tag --delete", tag_name))


# Testing ----
test_that("`gitr_recent_tag()` gets the most recent tag", {
  expect_equal(gitr_recent_tag(), tag_name)
})

test_that("`gitr_tag_info()` unit tests (minimal)", {
  tag_df <- gitr_tag_info()
  expect_s3_class(tag_df, "data.frame")
  expect_named(tag_df, c("tag", "tag_sha", "target_sha", "message",
                          "author", "email", "user", "tagdate",
                          "size", "path"))
  expect_true(nrow(tag_df) > 0L)
  recent_tag <- tag_df[tag_name, ]
  expect_equal(recent_tag$tag, tag_name)
  expect_equal(recent_tag$message, "Unit test tag v0.0.9000")
})
