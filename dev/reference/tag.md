# Git Tag Utilities

Git Tag Utilities

## Usage

``` r
gitr_recent_tag()

gitr_tag_info()
```

## Value

`gitr_recent_tag()`: `character(1)`. The most recent tag.

`gitr_tag_info()`: A data frame summarizing the repository tags.

## Functions

- `gitr_recent_tag()`: gets the *most* recent `git` tag.

- `gitr_tag_info()`: gets a data frame summary of the current git
  repository tags.

## Examples

``` r
if (FALSE) { # \dontrun{
  gitr_recent_tag()

  gitr_tag_info()
} # }
```
