#' @title Status of the data repository (Git)
#' @export
#' @family git
#' @description Show the Git status of the data repository.
#' @return If the data repository exists, the return value is the data frame
#'   produced by `gert::git_status(repo = store)`. If the data store has no Git
#'   repository, then the return value is `NULL`.
#' @inheritParams tar_git_init
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
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
  targets::tar_assert_file(store)
  if (stash_gitignore) {
    gitignore <- git_stash_gitignore(repo = store)
    on.exit(git_unstash_gitignore(repo = store, stash = gitignore))
  }
  if_any(
    git_repo_exists(repo = store),
    gert::git_status(repo = store),
    NULL
  )
}
