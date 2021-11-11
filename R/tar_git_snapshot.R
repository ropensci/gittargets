#' @title Snapshot the data repository (Git). 
#' @export
#' @family git
#' @description Snapshot the Git data repository of a `targets` project.
#' @inheritParams targets::tar_config_set
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' targets::tar_script()
#' targets::tar_make()
#' list.files("_targets", all.files = TRUE)
#' tar_git_init()
#' list.files("_targets", all.files = TRUE)
#' })
#' }
tar_git_snapshot <- function(
  store = targets::tar_config_get("store"),
  
  prompt = interactive(),
  verbose = TRUE
) {
  targets::tar_assert_file(store)
  gert::git_init(path = store)
  cli_success("Git repo created at ", store, ".", verbose = verbose)
  cli_info("Run tar_git_commit() to snapshot the data.", verbose = verbose)
}
