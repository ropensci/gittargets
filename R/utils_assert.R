tar_git_assert_commits_code <- function(code) {
  no_commits <- is.null(gert::git_branch(repo = code)) ||
    !nrow(gert::git_log(max = 1, repo = code))
  if (no_commits) {
    msg <- paste(
      "The code repository has no commits.",
      "Create one with gert::git_add() and gert::git_commit()."
    )
    targets::tar_throw_validate(msg)
  }
}

tar_git_assert_commits_data <- function(store) {
  no_commits <- is.null(gert::git_branch(repo = store)) ||
    !nrow(gert::git_log(max = 1, repo = store))
  if (no_commits) {
    msg <- paste(
      "The data repository has no commits.",
      "Create one with gittargets::tar_git_snapshot()."
    )
    targets::tar_throw_validate(msg)
  }
}

tar_git_assert_repo_code <- function(code) {
  if (!git_repo_exists(code)) {
    msg <- paste(
      "No Git repository for the code.",
      "Create one with gert::git_init()."
    )
    targets::tar_throw_validate(msg)
  }
}

tar_git_assert_repo_data <- function(store) {
  if (!git_repo_exists(store)) {
    msg <- paste(
      "No Git repository for the data store.",
      "Create one with gittargets::tar_git_init()."
    )
    targets::tar_throw_validate(msg)
  }
}

tar_git_assert_snapshot <- function(branch, store) {
  if (!gert::git_branch_exists(branch = branch, repo = store, local = TRUE)) {
    msg <- paste0(
      "No data snapshot for code commit ",
      branch,
      ". Create one with gittargets::tar_git_snapshot()."
    )
    targets::tar_throw_validate(msg)
  }
}
