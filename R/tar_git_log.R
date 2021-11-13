#' @title Data snapshot log (Git)
#' @export
#' @family git
#' @description Show all the data snapshots of the current code branch.
#' @return A data frame of all the data snapshots of the current code branch.
#' @inheritParams tar_git_status_code
#' @inheritParams tar_git_status_data
#' @inheritParams tar_git_status_targets
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' targets::tar_script()
#' targets::tar_make()
#' tar_git_init()
#' gert::git_init()
#' gert::git_add("_targets.R")
#' gert::git_commit("First commit")
#' tar_git_snapshot()
#' tar_git_log()
#' })
#' }
tar_git_status <- function(
  code = getwd(),
  store = targets::tar_config_get("store")
) {
  
}
