
# gittargets <img src='man/figures/logo.png' align="right" height="139"/>

[![CRAN](https://www.r-pkg.org/badges/version/gittargets)](https://CRAN.R-project.org/package=gittargets)
[![status](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![check](https://github.com/wlandau/gittargets/workflows/check/badge.svg)](https://github.com/wlandau/gittargets/actions?query=workflow%3Acheck)
[![codecov](https://codecov.io/gh/wlandau/gittargets/branch/main/graph/badge.svg?token=3T5DlLwUVl)](https://codecov.io/gh/wlandau/gittargets)
[![lint](https://github.com/wlandau/gittargets/workflows/lint/badge.svg)](https://github.com/wlandau/gittargets/actions?query=workflow%3Alint)

Version control systems such as Git help researchers track changes and
history in data science projects, and the
[`targets`](https://docs.ropensci.org/targets/) package minimizes the
computational cost of keeping the latest results reproducible and up to
date. The `gittargets` package combines these two capabilities. The
[`targets`](https://docs.ropensci.org/targets/) data store becomes a
version control repository and stays synchronized with the Git
repository of the source code. Users can switch commits and branches
without invalidating the [`targets`](https://docs.ropensci.org/targets/)
pipeline.

## Installation

| Type        | Source | Command                                         |
|-------------|--------|-------------------------------------------------|
| Development | GitHub | `remotes::install_github("wlandau/gittargets")` |

## Code of Conduct

Please note that the `gittargets` project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Citation

``` r
citation("gittargets")
#> 
#> To cite package 'gittargets' in publications use:
#> 
#>   William Michael Landau (NA). gittargets: Version Control for the
#>   Targets Package. https://wlandau.github.io/gittargets/,
#>   https://github.com/wlandau/gittargets.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {gittargets: Version Control for the Targets Package},
#>     author = {William Michael Landau},
#>     note = {https://wlandau.github.io/gittargets/, https://github.com/wlandau/gittargets},
#>   }
```
