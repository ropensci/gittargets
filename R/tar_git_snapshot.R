#' @title Snapshot the data repository (Git).
#' @export
#' @family git
#' @description Snapshot the Git data repository of a `targets` project.
#' @inheritParams tar_git_status
#' @param prompt Logical of length 1, whether to prompt the user before
#'   creating a snapshot.
#' @param status Logical of length 1, whether to print the project status
#'   with [tar_git_status()] before asking whether a snapshot should be
#'   created.
#' @param verbose Logical of length 1, whether to print R console messages
#'   confirming that a snapshot was created.
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' targets::tar_script()
#' targets::tar_make()
#' tar_git_init()
#' })
#' }
tar_git_snapshot <- function(
  code = getwd(),
  store = targets::tar_config_get("store"),
  prompt = interactive(),
  status = prompt,
  verbose = TRUE
) {
  targets::tar_assert_file(store)
  targets::tar_assert_lgl(prompt)
  targets::tar_assert_scalar(prompt)
  targets::tar_assert_lgl(status)
  targets::tar_assert_scalar(status)
  if (!git_repo_exists(store)) {
    cli_danger("No Git repository for the data store.")
    cli_danger("Create one with tar_git_init().")
    return(invisible())
  }
}
