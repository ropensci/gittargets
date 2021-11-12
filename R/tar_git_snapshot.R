#' @title Snapshot the data repository (Git).
#' @export
#' @family git
#' @description Snapshot the Git data repository of a `targets` project.
#' @description A Git-backed `gittargets` data snapshot is a special kind of
#'   Git commit. Every data commit gets its own branch,
#'   and the branch name is equal to the Git SHA1 hash
#'   of the code commit that was checked out at the time.
#'   That way, when you switch branches or commits in the code,
#'   [tar_git_checkout()] can revert the data to match.
#'   Ideally, your targets should stay up to date even as you
#'   transition among multiple branches.
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
#' gert::git_init()
#' gert::git_add("_targets.R")
#' gert::git_commit("First commit")
#' tar_git_snapshot()
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
  tar_git_assert_repo_code(code)
  tar_git_assert_commits_code(code)
  tar_git_assert_repo_data(store)
  
}
