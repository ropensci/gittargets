#' @title Initialize a data repository (Git).
#' @export
#' @family git
#' @description Initialize a Git repository for a `targets` data store.
#' @inheritParams targets::tar_config_set
#' @return `NULL` (invisibly).
#' @param stash_gitignore Logical of length 1, whether to temporarily
#'   stash the `.gitignore` file of the data store.
#'   The `targets` package writes a `.gitignore` file to new data stores
#'   in order to prevent accidental commits to the code Git repository.
#'   Unfortunately, for `gittargets`, this automatic `.gitignore` file
#'   interferes with proper data versioning. So by default, `gittargets`
#'   temporarily stashes it in
#'   `tools::R_user_dir(package = "gittargets", which = "cache")`
#'   while querying and modifying the data store. As long as the R
#'   session does not crash unexpectedly, the `.gitignore` file
#'   is returned to its proper location when `gittargets` is finished
#'   working with the data store.
#' @param verbose Logical of length 1, whether to print messages to the
#'   R console.
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script(tar_target(data, 1))
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
  targets::tar_assert_lgl(verbose)
  targets::tar_assert_scalar(verbose)
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
  git_stub_write(repo = store)
  gert::git_add(
    files = basename(git_stub_path(store)),
    force = TRUE,
    repo = store
  )
  gert::git_commit(message = "Stub commit", repo = store)
  cli_success("Created stub commit.", verbose = verbose)
  cli_info(
    "Run tar_git_snapshot() to put the data files under version control.",
    verbose = verbose
  )
  invisible()
}
