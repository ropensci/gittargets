#' @title Joint log of code and data (Git)
#' @export
#' @family git
#' @description Show data snapshots together with their code commits.
#' @return A data frame of data snapshots and code commits.
#' @inheritParams gert::git_log
#' @inheritParams tar_git_status
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
#' tar_git_log()
#' })
#' }
tar_git_log <- function(
  code = getwd(),
  store = targets::tar_config_get("store"),
  ref = "HEAD",
  max = 100
) {
  targets::tar_assert_file(code)
  targets::tar_assert_file(store)
  targets::tar_assert_chr(ref)
  targets::tar_assert_scalar(ref)
  targets::tar_assert_dbl(max)
  targets::tar_assert_positive(max)
  targets::tar_assert_scalar(max)
  tar_git_assert_repo_code(code)
  tar_git_assert_commits_code(code)
  tar_git_assert_repo_data(store)
  tar_git_assert_commits_data(store)
  raw_code <- gert::git_log(ref = ref, max = as.integer(max), repo = code)
  raw_data <- gert::git_branch_list(local = TRUE, repo = store)
  log_code <- tibble::tibble(
    commit_code = raw_code$commit,
    time_code = raw_code$time,
    message = trimws(raw_code$message)
  )
  log_data <- tibble::tibble(
    commit_code = raw_data$name,
    commit_data = raw_data$commit,
    time_data = raw_data$updated
  )
  log <- left_merge(x = log_code, y = log_data, by = "commit_code")
  log <- log[complete.cases(log),, drop = FALSE] # nolint
  log[, c("message", "time_code", "time_data", "commit_code", "commit_data")]
}
