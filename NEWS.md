# gitr 0.1.0 :construction:

## Breaking Changes :warning:

* Major naming convention change to package function infrastructure (#18)
  - most function names that began with `git_*()` are now `gitr_*()`
  - functions that previously were `get_*()`
    are now unified towards `gitr_*()`
  - this involves renaming prefix `*.R` files with `"gitr_*.R`"
  - renamed `'test-*.R`' suite of files
  - many BREAKING changes! Please bear with me and be aware
  - this results in a minor version increment
    to indicate that the API has changed but without
    committing to a full major version increment
    indicating an API lock.

## Bugs :bug:

* Fixed `git_version()` unit test for CRAN checks
  - edge-case for Apple/Mac systems with non-standard
    git version strings
  - `git` regex needed to be more robust and is now fixed

------------------

# gitr 0.0.2

## Features :rocket:

* Feature upgrade for `git_checkout()` (#2)
  - you can now checkout *either* a "branch"
    or a "file". File checkout is commonly
    used to revert local changes to that file
    to the most recent commit state.
  - improved edge-case catches and unit testing


## New Functions :sparkles:

* `git_current_sha()`
  - self explanatory, gets current commit sha

* `git_local_br()`
  - gets all the local branches

* `is_sha()`
  - logical, does it look like a SHA-1 hex?


## Unit tests (#5) :safety_vest:

* Set up special `gitr` unit testing fixtures
  - new: `local_create_worktree()`
  - see:
    https://testthat.r-lib.org/articles/test-fixtures.html
  - special worktree for unit testing
  - cleans up when finished each `test-*.R` file
  - does the following:
    - sets `gitr_echo_cmd = FALSE`
    - creates git worktree for testing
    - sets working directory to that worktree
    - returns to testing working directory when complete
    - deletes git worktree when complete

* New unit tests for:
  - `get_commit_msgs()`
  - `get_recent_tag()`
  - `git_checkout()`
  - `git_tag_info()`
  - `git_recent_tag()`
  - `git_checkout()`
  - `git_current_br()`
  - `git_defaults_br()`
  - `git_current_sha()`
  - `git_version()`

* Updated `git()` unit tests
  - now more meaningful
  - previously didn't return anything (very bare bones)
  - now actually tests something and uses `testthat::snapshot` framework


## Breaking changes! :warning:

* `gclean()`
  - parameter to `gclean()` is now `dry_run` (not `dry.run`)
  - note the move away from `.` dot notation;
    now underscore to better fit with package convention


## Documentation :book:

* Major documentation cleanup
  - updated syntax and spacing of roxygen docs
  - expanded examples
  - collated docs by group


## Bug Fixes :bug:

* Make `git_recent_tag()` more robust (@malcook; #16)
  - allow for asynchronous date tagging, aka
    the most "recent" tag, rather than the
    alpha-numeric sorting
  - thanks @malcook!
  - `git_recent_tag()` no longer echos command by default
    - small, possibly breaking, change depending on unit tests
    - mostly a UI change at the console

* Fixed a bug in `git_diffcommits()`
  - indexing is now correct (`x - 1`)

* Fix bug in `get_pr_sha()` (@stu.g.field; #10, #11)
  - index the `stdout` properly in the `if-else`
    so that the function returns `NULL`
    rather than `""` if there is no SHA to find
  - the presence/absence of `NULL` can then
    be tested for in downstream code


## Improvements :construction:

* New `gitr_echo_cmd` global option feature (#14)
  - the `echo_cmd` parameter is now additionally
    controlled by a global option, `gitr_echo_cmd`
  - this option defaults to `TRUE`
  - **note:** the global option is takes precedence over
    passed the `echo_cmd =` parameter inside `git()` call
  - added color (blue) to the echoed
    command when `echo_cmd = TRUE`

* No longer print full diff-commit to the console
  - much too verbose
  - more streamlined now and user friendly

* Fixed pipe `|` escapes in README
  - some ZSH aliases had '|' in the definition,
    messing up the table tabs in markdown syntax

* Upgrades to the pkgdown 'Git Started' in the navbar
  - for the `gitr` vignette introduction
  - more vignettes/articles to come

* Minor tweak to `trim_sha()` (#9)
  - returns `char(7)` if a sha
  - otherwise no trim occurs (orig string)
  - overall: `is_sha()` must be `TRUE`
    for any trimming
  - now vectorized; `character(1)` -> `character(n)`


------------------

# gitr 0.0.1 :tada:

* Now released (#7) on CRAN! :partying_face: 

* The package repository was restructured
  - now functions should be easier to find
  - new `pkgdown` website was added
  - documentation was improved
  - preparations were made for package release on CRAN

* Samples and templates
  - sample git hooks were added to package `inst/`
  - new sample templates include:
    - `_gitignore_global`
    - `_gitconfig`
    - `commit-msg-template`

# gitr 0.0.0.9000

* Initial public release on GitHub!

