#' @title Snapshot a data store Git repository. 
#' @export
#' @family git
#' @description Snapshot a Git repository for a `targets` data store.
#' @details `tar_git_snapshot()` does the following:
#'   1. 
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
