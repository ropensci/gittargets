#' @title Status of the data repository (Git)
#' @export
#' @family git
#' @description Show the Git status of the data repository.
#' @inheritSection tar_git_init Stashing .gitignore
#' @return If the data repository exists, the return value is the data frame
#'   produced by `gert::git_status(repo = store)`. If the data store has no Git
#'   repository, then the return value is `NULL`.
#' @inheritParams tar_git_init
#' @examples
#' if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script(tar_target(data, 1))
#' targets::tar_make()
#' list.files("_targets", all.files = TRUE)
#' gert::git_init()
#' tar_git_init()
#' tar_git_status_data()
#' })
#' }
tar_git_status_data <- function(
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE
) {
  tar_assert_file(store)
  if (stash_gitignore) {
    tar_git_gitignore_restore(repo = store)
    tar_git_gitignore_stash(repo = store)
    on.exit(tar_git_gitignore_unstash(repo = store))
  }
  if_any(
    tar_git_repo_exists(repo = store),
    gert::git_status(repo = store),
    NULL
  )
}
