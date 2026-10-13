# SHA1 Utilities

SHA1 Utilities

## Usage

``` r
gitr_trim_sha(sha)

is_sha(sha)

gitr_current_sha()
```

## Arguments

- sha:

  `character(n)`. The commit secure hash algorithm (SHA-1). If `NULL`,
  typically points to the most recent commit on the current branch.

## Value

`gitr_trim_sha()`: `character(1)`. The trimmed `sha`. If `sha` is not a
`SHA1` hash, the identical string unchanged.

`is_sha()`: `logical(1)`. If `sha` matches the `SHA1` expected pattern.

`gitr_current_sha()`: `character(1)`. The `sha` of the current commit.

## Functions

- `gitr_trim_sha()`: trims the `SHA-1` hash from the default full length
  to the human-readable short version.

- `is_sha()`: determines whether strings to be tested are a `SHA1` hash
  via regular expression (`"^[a-f0-9]{5,40}$"`) match.

- `gitr_current_sha()`: gets the current (most recent commit) SHA.

## See also

[`grepl()`](https://rdrr.io/r/base/grep.html)
