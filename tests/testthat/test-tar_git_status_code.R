targets::tar_test("tar_git_status_code() with no repo", {
  git_setup_init()
  unlink(".git", recursive = TRUE)
  expect_null(tar_git_status_code())
})

targets::tar_test("tar_git_status_code() with clean worktree", {
  git_setup_init()
  out <- tar_git_status_code()
  expect_equal(nrow(out), 0L)
})

targets::tar_test("tar_git_status_code() with unclean worktree", {
  git_setup_init()
  unlink("_targets.R")
  out <- tar_git_status_code()
  expect_true(nrow(out) > 0L)
})
