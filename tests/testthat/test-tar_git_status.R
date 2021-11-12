targets::tar_test("tar_git_status() git set up and targets up to date", {
  git_setup_init()
  capture.output(expect_message(tar_git_status(callr_function = NULL)))
})

targets::tar_test("tar_git_status() git not set up and targets outdated", {
  git_setup_init()
  store <- tar_config_get("store")
  unlink(".git", recursive = TRUE)
  unlink(file.path(store, ".git"), recursive = TRUE)
  targets::tar_invalidate(everything())
  expect_false(git_repo_exists(store))
  capture.output(expect_message(tar_git_status(callr_function = NULL)))
})
