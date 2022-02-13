#' targets: Dynamic Function-Oriented Make-Like Declarative Pipelines for R
#' @docType package
#' @name gittargets-package
#' @description In computationally demanding data analysis pipelines,
#'   the `targets` R package maintains an up-to-date set of results
#'   while skipping tasks that do not need to rerun. This process
#'   increases speed and increases trust in the final end product.
#'   However, it also overwrites old output with new output,
#'   and past results disappear by default. To preserve historical output,
#'   the `gittargets` package captures version-controlled snapshots
#'   of the data store, and each snapshot links to the underlying
#'   commit of the source code. That way, when the user rolls back
#'   the code to a previous branch or commit, `gittargets` can recover
#'   the data contemporaneous with that commit so that all targets
#'   remain up to date.
#' @family help
#' @importFrom cli cli_alert_danger cli_alert_info cli_alert_success cli_h1
#'   col_br_white
#' @importFrom data.table as.data.table
#' @importFrom gert git_branch git_branch_exists git_branch_list
#'   git_commit_info git_log git_status
#' @importFrom processx run
#' @importFrom stats complete.cases
#' @importFrom targets tar_config_get tar_config_set tar_dir
#'   tar_outdated tar_throw_validate
#' @importFrom tibble as_tibble tibble
#' @importFrom utils capture.output head menu
#' @importFrom uuid UUIDgenerate
NULL
