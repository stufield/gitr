
# This is a new release to CRAN

* This is a re-submission that addresses the `value{}` entry
  for exported functions.

* There was a second comment about adding the API address in the DESCRIPTION's
  description was *not* addressed because I use the word API in a general
  sense, i.e. how the user interfaces with the program. It does
  not refer to a web API with an actual URI you can hit.


## R CMD check results

```
0 errors | 0 warnings | 0 notes
```

```
Possibly misspelled words in DESCRIPTION:
  workflows (9:42)
```

* I believe the spelling of `workflow` is now generally accepted 
  as one word. So this represents a false positive.
