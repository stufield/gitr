# `scrape_commits()` returns expected (must execute after above)

    Code
      commit <- scrape_commits(1L)
    Message
      • Scraping 1 commit messages
      ✓ Found 1 NEWS-worthy entries

---

    Code
      clean_commit_sha(commit)
    Output
      $abc1234
      [1] "Added new empty commit to repo" ""                              
      [3] "- and here are some details"    ""                              
      attr(,"sha")
      [1] "abc1234"
      attr(,"author")
      [1] "whitewizard@isengard.com"
      

# `git_diffcommits()` returns correct output diffing a recent commit

    Code
      git_diffcommits()
    Output
      diff --git a/gitr-diffcommit-file b/gitr-diffcommit-file
      new file mode 100644
      index 0000000..9990b67
      --- /dev/null
      +++ b/gitr-diffcommit-file
      @@ -0,0 +1,3 @@
      +This is a unit test for `git_diffcommit()`.
      +
      +This file should be deleted following unit test cleanup.

