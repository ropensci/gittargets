targets::tar_test("tar_git_status_targets() up-to-date targets", {
  skip_os_git()
  git_setup_init()
  expect_equal(nrow(tar_git_status_targets(callr_function = NULL)), 0L)
})

targets::tar_test("tar_git_status_targets() outdated targets", {
  skip_os_git()
  git_setup_init()
  targets::tar_invalidate(everything())
  expect_gt(nrow(tar_git_status_targets(callr_function = NULL)), 0L)
})
