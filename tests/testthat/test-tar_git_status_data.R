targets::tar_test("tar_git_status_data() with no repo", {
  skip_os_git()
  targets::tar_script(targets::tar_target(x, 1))
  targets::tar_make(callr_function = NULL)
  expect_null(tar_git_status_data())
})

targets::tar_test("tar_git_status_data() with clean worktree", {
  skip_os_git()
  git_setup_init()
  out <- tar_git_status_data()
  store <- tar_config_get("store")
  unlink(file.path(store, out$file), recursive = TRUE)
  out <- tar_git_status_data()
  expect_equal(nrow(out), 0L)
})

targets::tar_test("tar_git_status_data() with unclean worktree", {
  skip_os_git()
  git_setup_init()
  out <- tar_git_status_data()
  expect_true(nrow(out) > 0L)
})

targets::tar_test("tar_git_status_data() without stashing .gitignore", {
  skip_os_git()
  git_setup_init()
  store <- tar_config_get("store")
  writeLines("*", file.path(store, ".gitignore"))
  out <- tar_git_status_data(stash_gitignore = FALSE)
  expect_equal(nrow(out), 0L)
})
