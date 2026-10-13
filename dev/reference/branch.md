# Git Branch Utilities

Git Branch Utilities

## Usage

``` r
gitr_default_br()

gitr_current_br()

gitr_local_br()
```

## Value

`character(1)`. The name of the respective branch if found, otherwise
`NULL`.

## Functions

- `gitr_default_br()`: gets the default "main" branch, typically either
  `master`, `main`, or `trunk`.

- `gitr_current_br()`: gets the *current* branch.

- `gitr_local_br()`: gets all the *local* branches.
