targets::tar_test("tar_git_status_code() with no repo", {
  skip_os_git()
  expect_null(tar_git_status_code())
})

targets::tar_test("tar_git_status_code() with clean worktree", {
  skip_os_git()
  git_setup_init()
  store <- targets::tar_config_get("store")
  writeLines("*", file.path(store, ".gitignore"))
  out <- tar_git_status_code()
  expect_equal(nrow(out), 0L)
})

targets::tar_test("tar_git_status_code() with unclean worktree", {
  skip_os_git()
  git_setup_init()
  unlink("_targets.R")
  out <- tar_git_status_code()
  expect_true(nrow(out) > 0L)
})
