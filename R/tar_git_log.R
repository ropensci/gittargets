#' @title Data snapshots of a code branch (Git)
#' @export
#' @family git
#' @description Show all the data snapshots of a code branch.
#' @details By design, `tar_git_log()` only queries a single
#'   code branch at a time. This allows `tar_git_log()`
#'   to report more detailed information about the snapshots
#'   of the given code branch.
#'   To query all data snapshots over all branches, simply run
#'   `gert::git_branch_list(local = TRUE, repo = "_targets")`.
#'   The valid snapshots show `"code=<SHA1>"` in the `name` column,
#'   where `<SHA1>` is the Git commit hash of the code commit
#'   corresponding to the data snapshot.
#' @return A data frame of information about
#'   data snapshots and code commits.
#' @inheritParams gert::git_log
#' @inheritParams tar_git_status
#' @param branch Character of length 1, name of the code repository branch
#'   to query. Defaults to the currently checked-out code branch.
#' @param max Positive numeric of length 1, maximum number of code commits
#'   to inspect for the given branch.
#' @examples
#' if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' targets::tar_script(tar_target(data, 1))
#' targets::tar_make()
#' gert::git_init()
#' gert::git_add("_targets.R")
#' gert::git_commit("First commit")
#' tar_git_init()
#' tar_git_snapshot(status = FALSE, verbose = FALSE)
#' tar_git_log()
#' })
#' }
tar_git_log <- function(
  code = getwd(),
  store = targets::tar_config_get("store"),
  branch = gert::git_branch(repo = code),
  max = 100
) {
  tar_assert_file(code)
  tar_assert_file(store)
  targets::tar_assert_chr(branch)
  targets::tar_assert_scalar(branch)
  targets::tar_assert_dbl(max)
  targets::tar_assert_positive(max)
  targets::tar_assert_scalar(max)
  tar_assert_finite(max, msg = "max must be finite.")
  tar_git_assert_repo_code(code)
  tar_git_assert_commits_code(code)
  tar_git_assert_repo_data(store)
  tar_git_assert_commits_data(store)
  raw_code <- gert::git_log(ref = branch, max = as.integer(max), repo = code)
  raw_data <- gert::git_branch_list(local = TRUE, repo = store)
  log_code <- tibble::tibble(
    commit_code = raw_code$commit,
    time_code = raw_code$time,
    message_code = trimws(raw_code$message)
  )
  log_data <- tibble::tibble(
    commit_code = tar_git_commit_code(raw_data$name),
    commit_data = raw_data$commit,
    time_data = raw_data$updated
  )
  log <- inner_merge(x = log_data, y = log_code, by = "commit_code")
  log$message_data <- vapply(
    X = log$commit_data,
    FUN = tar_git_log_data_message,
    store = store,
    FUN.VALUE = character(1),
    USE.NAMES = FALSE
  )
  cols <- c(
    "message_code",
    "message_data",
    "time_code",
    "time_data",
    "commit_code",
    "commit_data"
  )
  log[, cols]
}

tar_git_log_data_message <- function(commit, store) {
  trimws(gert::git_commit_info(ref = commit, repo = store)$message)
}
