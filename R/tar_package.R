#' targets: Dynamic Function-Oriented Make-Like Declarative Pipelines for R
#' @docType package
#' @name gittargets-package
#' @description Pipelines with the `targets` R package skip  steps that
#'   are up to already date. Although this behavior reduces the runtime
#'   of subsequent runs, it comes at the cost of overwriting previous
#'   results. So if the pipeline source code is under version control,
#'   and if you revert to a previous commit or branch,
#'   the data will no longer be up to date with the code you
#'   just checked out. Ordinarily, you would need to rerun the
#'   pipeline in order to recover the targets you had before.
#'   However, `gittargets` preserves historical output,
#'   creating version control snapshots of data store.
#'   Each data snapshot remembers the contemporaneous Git commit
#'   of the pipeline source code, so you can recover the right
#'   data when you navigate the Git history. In other words,
#'   `gittargets` makes it possible to switch commits or branches
#'   without invalidating the pipeline. You can simply check out
#'   the up-to-date targets from the past instead of taking the
#'   time to recompute them from scratch.
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
