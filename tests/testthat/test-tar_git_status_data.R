targets::tar_test("tar_git_status_data() with no repo", {
  git_setup_init()
  store <- tar_config_get("store")
  unlink(file.path(store, ".git"), recursive = TRUE)
  expect_false(git_repo_exists(store))
  expect_null(tar_git_status_data())
})

targets::tar_test("tar_git_status_data() with clean worktree", {
  git_setup_init()
  out <- tar_git_status_data()
  store <- tar_config_get("store")
  unlink(file.path(store, out$file), recursive = TRUE)
  out <- tar_git_status_data()
  expect_equal(nrow(out), 0L)
})

targets::tar_test("tar_git_status_data() with unclean worktree", {
  git_setup_init()
  out <- tar_git_status_data()
  expect_true(nrow(out) > 0L)
})

targets::tar_test("tar_git_status_data() without stashing .gitignore", {
  git_setup_init()
  store <- tar_config_get("store")
  writeLines("*", file.path(store, ".gitignore"))
  out <- tar_git_status_data(stash_gitignore = FALSE)
  expect_equal(nrow(out), 0L)
})
