#' targets: Dynamic Function-Oriented Make-Like Declarative Pipelines for R
#' @docType package
#' @description Version control systems such as Git help researchers
#'   track changes and history in data science projects,
#'   and the `targets` package minimizes the computational cost of
#'   keeping the latest results reproducible and up to date.
#'   The `gittargets` package combines these two capabilities.
#'   The `targets` data store becomes a version control repository
#'   and stays synchronized with the Git repository of the source code.
#'   Users can switch commits and branches without
#'   invalidating the `targets` pipeline.
#' @name gittargets-package
#' @family help
#' @importFrom cli cli_alert_danger cli_alert_info cli_alert_success cli_h1
#' @importFrom gert git_add git_commit git_init git_status
#' @importFrom targets tar_assert_file tar_config_get tar_config_set tar_dir
#'   tar_outdated
#' @importFrom tibble as_tibble
NULL
