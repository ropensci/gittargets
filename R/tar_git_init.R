#' @title Initialize a data repository (Git).
#' @export
#' @family git
#' @description Initialize a Git repository for a `targets` data store.
#' @inheritParams targets::tar_config_set
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script()
#' targets::tar_make()
#' tar_git_init()
#' })
#' }
tar_git_init <- function(
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  verbose = TRUE
) {
  tar_assert_file(store)
  if (git_repo_exists(store)) {
    cli_info("Data store Git repository already exists.")
    cli_info("Remove ", store, " to start over.")
    return(invisible())
  }
  if (stash_gitignore) {
    gitignore <- git_stash_gitignore(repo = store)
    on.exit(git_unstash_gitignore(repo = store, stash = gitignore))
  }
  gert::git_init(path = store)
  cli_success("Created data store Git repository", verbose = verbose)
  git_stub_write(repo = store, lines = "")
  gert::git_add(files = basename(git_stub_path(store)), force = TRUE, repo = store)
  gert::git_commit(message = "Stub commit", repo = store)
  cli_success("Created stub commit.", verbose = verbose)
  cli_info(
    "Run tar_git_snapshot() to put the data files under version control.",
    verbose = verbose
  )
  invisible()
}
