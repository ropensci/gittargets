#' @title Check out a snapshot of the data (Git)
#' @export
#' @family git
#' @description Check out a snapshot of the data associated with
#'   a particular code commit (default: `HEAD`).
#' @return Nothing (invisibly).
#' @param ref Character of length 1. SHA1 hash, branch name,
#'   or other reference in the code repository
#'   that points to a code commit. (You can also identify the code
#'   commit by supplying a data branch of the form `code=<SHA1>`.)
#'   Defaults to `"HEAD"`, which points to the currently
#'   checked out code commit.
#'
#'   Once the desired code commit is identified,
#'   `tar_git_snapshot()` checks out the latest corresponding data snapshot.
#'   There may be earlier data snapshots corresponding to this code commit,
#'   but `tar_git_snapshot()` only checks out the latest one.
#'   To check out an earlier superseded data snapshot,
#'   you will need to manually use command line Git in the data repository.
#'
#'   If `tar_git_snapshot()` cannot find a data snapshot for the
#'   desired code commit, then it will throw an error.
#'   For a list of commits in the current code branch
#'   that have available data snapshots, see the `commit_code`
#'   column of the output of [tar_git_log()].
#' @inheritParams gert::git_branch_checkout
#' @inheritParams tar_git_snapshot
#' @examples
#' if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' # Work on an initial branch.
#' targets::tar_script(tar_target(data, "old_data"))
#' targets::tar_make()
#' targets::tar_read(data) # "old_data"
#' gert::git_init()
#' gert::git_add("_targets.R")
#' gert::git_commit("First commit")
#' gert::git_branch_create("old_branch")
#' tar_git_init()
#' # Work on a new branch.
#' tar_git_snapshot(status = FALSE, verbose = FALSE)
#' targets::tar_script(tar_target(data, "new_data"))
#' targets::tar_make()
#' targets::tar_read(data) # "new_data"
#' gert::git_branch_create("new_branch")
#' gert::git_add("_targets.R")
#' gert::git_commit("Second commit")
#' tar_git_snapshot(status = FALSE, verbose = FALSE)
#' # Go back to the old branch.
#' gert::git_branch_checkout("old_branch")
#' # The target is out of date because we only reverted the code.
#' targets::tar_outdated()
#' # But tar_git_checkout() lets us restore the old version of the data!
#' tar_git_checkout()
#' targets::tar_read(data) # "old_data"
#' # Now, the target is up to date! And we did not even have to rerun it!
#' targets::tar_outdated()
#' })
#' }
tar_git_checkout <- function(
  ref = "HEAD",
  code = getwd(),
  store = targets::tar_config_get("store"),
  force = FALSE,
  verbose = TRUE
) {
  tar_assert_file(code)
  tar_assert_file(store)
  targets::tar_assert_chr(ref)
  targets::tar_assert_scalar(ref)
  tar_git_assert_repo_code(code)
  tar_git_assert_commits_code(code)
  tar_git_assert_repo_data(store)
  tar_git_assert_commits_data(store)
  ref <- tar_git_commit_code(ref)
  commit <- gert::git_commit_info(repo = code, ref = ref)$id
  branch <- tar_git_branch_snapshot(commit)
  tar_git_assert_snapshot(branch = branch, store = store)
  tar_git_branch_checkout(branch = branch, repo = store, force = force)
  commit <- gert::git_commit_info(repo = store)$id
  message <- gert::git_commit_info(repo = store, ref = commit)$message
  message <- first_line(message)
  cli_success("Checked out data snapshot ", commit, ".", verbose = verbose)
  cli_info("Code commit: ", branch, verbose = verbose)
  cli_info("Message: ", first_line(message), verbose = verbose)
  invisible()
}
