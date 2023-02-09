# gittargets 0.0.6

* Import `callr::r()`.

# gittargets 0.0.5

* Use `processx::run()` instead of `system2()` in `tar_git_ok()` and set `HOME` to `USERPROFILE` on Windows (#12, @psychelzh).
* Handle errors invoking Git to get global user name and email.

# gittargets 0.0.4

* Compatibility with {targets} 0.13.0.

# gittargets 0.0.3

* Fix an example for CRAN.

# gittargets 0.0.2

* Hard reset after checkout in `tar_git_checkout()` in order to recover potentially deleted files (#11).

# gittargets 0.0.1

* Join rOpenSci.
* Rewrite README to motivate the use case.
* Remove workflow diagram.
* Simplify snapshot model diagram.
* Fix the documentation of the `ref` argument of `tar_git_checkout()`.
* Add a section to the `git.Rmd` vignette on code merges.
* Allow command line Git tests to run locally on Windows.
* First version.
