targets::tar_test("tar_git_status() git set up and targets up to date", {
  skip_os_git()
  git_setup_init()
  expect_message(tar_git_status(callr_function = NULL))
})

targets::tar_test("tar_git_status() git not set up and targets outdated", {
  skip_os_git()
  targets::tar_script(targets::tar_target(x, 1))
  targets::tar_make(callr_function = NULL)
  targets::tar_invalidate(everything())
  expect_message(tar_git_status(callr_function = NULL))
})
