#' @title Initialize data store Git repository.
#' @export
#' @family git
#' @description Initialize a Git repository for a `targets` data store.
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
tar_git_init <- function(store = targets::tar_config_get("store")) {
  targets::tar_assert_chr(store)
  targets::tar_assert_scalar(store)
  targets::tar_assert_path(store)
  gert::git_init(path = store)
}
