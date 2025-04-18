
test_that("`gitr_trim_sha()` works as expected", {
  expect_equal(gitr_trim_sha("854ec87"), "854ec87")
  expect_equal(gitr_trim_sha("854ec871fbb8f2593275b077d596987cede73261"), "854ec87")
  expect_true(is_sha("854ec871fbb8f2593275b"), "854ec87")
  expect_equal(gitr_trim_sha("hello"), "hello")
  expect_equal(gitr_trim_sha(c("foo", "bar")), c("foo", "bar"))
  expect_equal(gitr_trim_sha(c("foo",
                               "854ec871fbb8f2593275b077d596987cede73261",
                               "bar")),
                        c("foo", "854ec87", "bar")
  )
  expect_equal(gitr_trim_sha(""), "")
  expect_null(gitr_trim_sha(NULL))
  expect_equal(gitr_trim_sha(NA_character_), NA_character_)
  expect_equal(gitr_trim_sha(5), "5")
  expect_equal(gitr_trim_sha(LETTERS), LETTERS)
})

test_that("`is_sha()` works as expected", {
  expect_true(is_sha("854ec87"))
  expect_true(is_sha("854ec871fbb8f2593275b"))
  expect_false(is_sha("854ec871fbb8f2593275b077d596987cede73261a"))  # too long
  expect_false(is_sha("foo"))
  expect_false(is_sha("a3c4u395230"))  # 'u' is not 'abcdef'
  expect_false(is_sha("854e"))         # too short
  expect_equal(is_sha(c("foo", "854ec87")), c(FALSE, TRUE))  # vector
})
