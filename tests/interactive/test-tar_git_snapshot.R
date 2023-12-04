targets::tar_test("tar_git_snapshot()", {
  git_setup_init()
  expect_gt(nrow(tar_git_status_data()), 0L)
  store <- targets::tar_config_get("store")
  gitignore <- file.path(store, ".gitignore")
  writeLines("*", gitignore)
  capture.output(tar_git_snapshot(status = TRUE)) # choose 2
  expect_equal(readLines(gitignore), "*")
  expect_gt(nrow(tar_git_status_data()), 0L)
  capture.output(tar_git_snapshot(status = TRUE)) # choose 1
  expect_equal(readLines(gitignore), "*")
  expect_equal(nrow(tar_git_status_data()), 0L)
  commit <- paste0("code=", gert::git_commit_info(repo = getwd())$id)
  branch <- gert::git_branch(repo = store)
  expect_equal(commit, branch)
  message_code <- gert::git_commit_info(repo = getwd())$message
  message_data <- gert::git_commit_info(repo = store)$message
  expect_equal(message_code, message_data)
})
