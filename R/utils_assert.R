tar_git_assert_commits_code <- function(code) {
  if (is.null(gert::git_branch(repo = code))) {
    msg <- paste(
      "The code repository has no commits.",
      "Create one with gert::git_add() and gert::git_commit()."
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
      "Create one with tar_git_init()."
    )
    targets::tar_throw_validate(msg)
  }
}
