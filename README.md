
# targit

[![CRAN](https://www.r-pkg.org/badges/version/targit)](https://CRAN.R-project.org/package=targit)
[![status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check](https://github.com/wlandau/targit/workflows/check/badge.svg)](https://github.com/wlandau/targit/actions?query=workflow%3Acheck)
[![codecov](https://codecov.io/gh/wlandau/targit/branch/main/graph/badge.svg?token=3T5DlLwUVl)](https://codecov.io/gh/wlandau/targit)
[![lint](https://github.com/wlandau/targit/workflows/lint/badge.svg)](https://github.com/wlandau/targit/actions?query=workflow%3Alint)

Version control systems such as Git help researchers track changes and
history in data science projects, and the
[`targets`](https://docs.ropensci.org/targets/) package minimizes the
computational cost of keeping the latest results reproducible and up to
date. The `targit` package combines these two capabilities. The
[`targets`](https://docs.ropensci.org/targets/) data store becomes a
version control repository and stays synchronized with the Git
repository of the source code. Users can switch commits and branches
without invalidating the [`targets`](https://docs.ropensci.org/targets/)
pipeline.

## Installation

| Type        | Source | Command                                     |
|-------------|--------|---------------------------------------------|
| Release     | CRAN   | `install.packages("targit")`                |
| Development | GitHub | `remotes::install_github("wlandau/targit")` |

## Code of Conduct

Please note that the `targit` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Citation

``` r
citation("targit")
#> 
#> To cite package 'targit' in publications use:
#> 
#>   William Michael Landau (NA). targit: Version Control for the Targets
#>   Package. https://wlandau.github.io/targit/,
#>   https://github.com/wlandau/targit.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {targit: Version Control for the Targets Package},
#>     author = {William Michael Landau},
#>     note = {https://wlandau.github.io/targit/, https://github.com/wlandau/targit},
#>   }
```
