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
      

