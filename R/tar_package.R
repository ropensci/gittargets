#' targets: Dynamic Function-Oriented Make-Like Declarative Pipelines for R
#' @docType package
#' @description Version control systems such as Git help researchers
#'   track changes and history in data science projects,
#'   and the `targets` package minimizes the computational cost of
#'   keeping the latest results reproducible and up to date.
#'   The `targit` package combines these two capabilities.
#'   The `targets` data store becomes a version control repository
#'   and stays synchronized with the Git repository of the source code.
#'   Users can switch commits and branches without
#'   invalidating the `targets` pipeline.
#' @name targit-package
#' @family help
#' @importFrom gert git_add git_init
#' @importFrom targets tar_assert_chr tar_assert_path tar_assert_scalar
#'   tar_config_get tar_config_set tar_dir
NULL
