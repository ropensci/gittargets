
# gittargets <img src='man/figures/logo-readme.png' align="right" height="139"/>

[![ropensci](https://badges.ropensci.org/486_status.svg)](https://github.com/ropensci/software-review/issues/486)
[![CRAN](https://www.r-pkg.org/badges/version/gittargets)](https://CRAN.R-project.org/package=gittargets)
[![status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check](https://github.com/ropensci/gittargets/workflows/check/badge.svg)](https://github.com/ropensci/gittargets/actions?query=workflow%3Acheck)
[![codecov](https://codecov.io/gh/ropensci/gittargets/branch/main/graph/badge.svg?token=3T5DlLwUVl)](https://app.codecov.io/gh/ropensci/gittargets)
[![lint](https://github.com/ropensci/gittargets/workflows/lint/badge.svg)](https://github.com/ropensci/gittargets/actions?query=workflow%3Alint)

In computationally demanding data analysis pipelines, the
[`targets`](https://docs.ropensci.org/targets/) R package maintains an
up-to-date set of results while skipping tasks that do not need to
rerun. This process increases speed and increases trust in the final end
product. However, it also overwrites old output with new output, and
past results disappear by default. To preserve historical output, the
`gittargets` package captures version-controlled snapshots of the data
store, and each snapshot links to the underlying commit of the source
code. That way, when the user rolls back the code to a previous branch
or commit, `gittargets` can recover the data contemporaneous with that
commit so that all targets remain up to date.

## Prerequisites

1.  Familiarity with the [R programming
    language](https://www.r-project.org/), covered in [R for Data
    Science](https://r4ds.had.co.nz/).
2.  [Data science workflow management best
    practices](https://rstats.wtf/index.html).
3.  [Git](https://git-scm.com), covered in [Happy Git and GitHub for the
    useR](https://happygitwithr.com).
4.  [`targets`](https://docs.ropensci.org/targets/), which has resources
    on the [documentation
    website](https://docs.ropensci.org/targets/#how-to-get-started).
5.  Familiarity with the [`targets` data
    store](https://books.ropensci.org/targets/data.html).

## Installation

The package is available to install from any of the following sources.

| Type        | Source   | Command                                                                     |
|-------------|----------|-----------------------------------------------------------------------------|
| Release     | CRAN     | `install.packages("gittargets")`                                            |
| Development | GitHub   | `remotes::install_github("ropensci/gittargets")`                            |
| Development | rOpenSci | `install.packages("gittargets", repos = "https://ropensci.r-universe.dev")` |

You will also need command line Git, available at
<https://git-scm.com/downloads>.[^1] Please make sure Git is reachable
from your system path environment variables. To control which Git
executable `gittargets` uses, you may set the `TAR_GIT` environment
variable with `usethis::edit_r_environ()` or `Sys.setenv()`. You will
also need to configure your user name and user email at the global level
using the instructions at
<https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup>
(or `gert::git_config_global_set()`). Run `tar_git_ok()` to check
installation and configuration.

``` r
tar_git_ok()
#> ✓ Git binary: /path/to/git
#> ✓ Git config global user name: your_user_name
#> ✓ Git config global user email: your_email@example.com
#> [1] TRUE
```

There are also backend-specific installation requirements and
recommendations in the [package
vignettes](https://docs.ropensci.org/gittargets/articles/index.html).

## Motivation

Consider an example pipeline with source code in `_targets.R` and output
in the [data store](https://books.ropensci.org/targets/data.html).

``` r
# _targets.R
library(targets)
list(
  tar_target(data, airquality),
  tar_target(model, lm(Ozone ~ Wind, data = data)) # Regress on wind speed.
)
```

Suppose you run the pipeline and confirm that all targets are up to
date.

``` r
tar_make()
#> • start target data
#> • built target data
#> • start target model
#> • built target model
#> • end pipeline
```

``` r
tar_outdated()
#> character(0)
```

It is good practice to track the source code in a [version control
repository](https://git-scm.com) so you can revert to previous commits
or branches. However, the [data
store](https://books.ropensci.org/targets/data.html) is usually too
large to keep in the same repository as the code, which typically lives
in a cloud platform like [GitHub](https://github.com) where space and
bandwidth are pricey. So when you check out an old commit or branch, you
revert the code, but not the data. In other words, your targets are out
of sync and out of date.

``` r
gert::git_branch_checkout(branch = "other-model")
```

``` r
# _targets.R
library(targets)
list(
  tar_target(data, airquality),
  tar_target(model, lm(Ozone ~ Temp, data = data)) # Regress on temperature.
)
```

``` r
tar_outdated()
#> [1] "model"
```

## Usage

With `gittargets`, you can keep your targets up to date even as you
check out code from different commits or branches. The specific steps
depend on the data backend you choose, and each supported backend has a
[package
vignette](https://docs.ropensci.org/gittargets/articles/index.html) with
a walkthrough. For example, the most important steps of the [Git data
backend](https://docs.ropensci.org/gittargets/articles/git.html) are as
follows.

1.  Create the source code and run the pipeline at least once so the
    [data store](https://books.ropensci.org/targets/data.html) exists.
2.  `tar_git_init()`: initialize a [Git](https://git-scm.com)/[Git
    LFS](https://git-lfs.github.com) repository for the [data
    store](https://books.ropensci.org/targets/data.html).
3.  Bring the pipeline up to date (e.g. with
    [`tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html))
    and commit any changes to the source code.
4.  `tar_git_snapshot()`: create a data snapshot for the current code
    commit.
5.  Develop the pipeline. Creating new code commits and code branches
    early and often, and create data snapshots at key strategic
    milestones.
6.  `tar_git_checkout()`: revert the data to the appropriate prior
    snapshot.

## Performance

`targets` generates a large amount of data in `_targets/objects/`, and
data snapshots and checkouts may take a long time. To work around
performance limitations, you may wish to only snapshot the data at the
most important milestones of your project. Please refer to the [package
vignettes](https://docs.ropensci.org/gittargets/articles/index.html) for
specific recommendations on optimizing performance.

## Future directions

The first data versioning system in `gittargets` uses
[Git](https://git-scm.com), which is designed for source code and may
not scale to enormous amounts of compressed data. Future releases of
`gittargets` may explore alternative data backends more powerful than
[Git LFS](https://git-lfs.github.com).

## Alternatives

Newer versions of the `targets` package (\>= 0.9.0) support continuous
data versioning through cloud storage, e.g. [Amazon Web
Services](https://aws.amazon.com) for [S3
buckets](https://aws.amazon.com/s3/) with [versioning
enabled](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html).
In this approach, `targets` tracks the version ID of each [cloud-backed
target](https://books.ropensci.org/targets/data.html#cloud-storage).
That way, when the metadata file reverts to a prior version, the
pipeline automatically uses prior versions of targets that were up to
date at the time the metadata was written. This approach has two
distinct advantages over `gittargets`:

1.  Cloud storage reduces the burden of local storage for large data
    pipelines.
2.  Target data is uploaded and tracked continuously, which means the
    user does not need to proactively take data snapshots.

However, not all users have access to cloud services like
[AWS](https://aws.amazon.com), not everyone is able or willing to pay
the monetary costs of cloud storage for every single version of every
single target, and uploads and downloads to and from the cloud may
bottleneck some pipelines. `gittargets` fills this niche with a data
versioning system that is

1.  Entirely local, and
2.  Entirely opt-in: users pick and choose when to register data
    snapshots, which consumes less storage than continuous snapshots or
    continuous cloud uploads to a versioned S3 bucket.

## Code of Conduct

Please note that the `gittargets` project is released with a
[Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.

## Citation

``` r
citation("gittargets")
#> 
#> To cite gittargets in publications use:
#> 
#>   William Michael Landau (2021). gittargets: Version Control for the
#>   targets Package. https://docs.ropensci.org/gittargets/,
#>   https://github.com/ropensci/gittargets.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {gittargets: Version Control for the Targets Package},
#>     author = {William Michael Landau},
#>     note = {https://docs.ropensci.org/gittargets/, https://github.com/ropensci/gittargets},
#>     year = {2021},
#>   }
```

[^1]: `gert` does not have these requirements, but `gittargets` does not
    exclusively rely on `gert` because `libgit2` does not automatically
    work with [Git LFS](https://git-lfs.github.com).
