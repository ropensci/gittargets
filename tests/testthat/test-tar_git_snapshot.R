targets::tar_test("tar_git_snapshot()", {
  skip_os_git()
  git_setup_init()
  expect_gt(nrow(tar_git_status_data()), 0L)
  store <- targets::tar_config_get("store")
  gitignore <- file.path(store, ".gitignore")
  writeLines("*", gitignore)
  tar_git_snapshot(status = FALSE)
  expect_equal(readLines(gitignore), "*")
  expect_equal(nrow(tar_git_status_data()), 0L)
  commit_code <- gert::git_commit_info(repo = getwd())$id
  commit_store <- gert::git_commit_info(repo = store)$id
  branch <- gert::git_branch(repo = store)
  expect_equal(tar_git_branch_snapshot(commit_code), branch)
  message_code <- gert::git_commit_info(repo = getwd())$message
  message_data <- gert::git_commit_info(repo = store)$message
  expect_equal(message_code, message_data)
  log <- gert::git_log(repo = store)
  expect_equal(nrow(log), 2L)
  expect_true(commit_store %in% log$commit)
  # second data snapshot for the same code commit
  commit_store_old <- commit_store
  tar_git_snapshot(status = FALSE)
  commit_store <- gert::git_commit_info(repo = store)$id
  commit_code <- gert::git_commit_info(repo = getwd())$id
  expect_false(identical(commit_store, commit_store_old))
  branch <- gert::git_branch(repo = store)
  expect_equal(tar_git_branch_snapshot(commit_code), branch)
  message_code <- gert::git_commit_info(repo = getwd())$message
  message_data <- gert::git_commit_info(repo = store)$message
  expect_equal(message_code, message_data)
  log <- gert::git_log(repo = store)
  expect_true(commit_store %in% log$commit)
  log <- gert::git_log(repo = store)
  expect_equal(nrow(log), 3L)
  expect_true(commit_store %in% log$commit)
  expect_true(commit_store_old %in% log$commit)
})

targets::tar_test("tar_git_snapshot() custom message", {
  skip_os_git()
  git_setup_init()
  expect_gt(nrow(tar_git_status_data()), 0L)
  store <- targets::tar_config_get("store")
  gitignore <- file.path(store, ".gitignore")
  writeLines("*", gitignore)
  tar_git_snapshot(message = "custom message", status = FALSE)
  message_code <- gert::git_commit_info(repo = getwd())$message
  message_data <- gert::git_commit_info(repo = store)$message
  expect_false(identical(message_code, message_data))
  expect_equal(trimws(message_data), "custom message")
})
