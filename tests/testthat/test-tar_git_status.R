targets::tar_test("tar_git_status() git set up and targets up to date", {
  skip_no_git()
  utils::capture.output(git_setup_init())
  capture.output(expect_message(tar_git_status(callr_function = NULL)))
})

targets::tar_test("tar_git_status() git not set up and targets outdated", {
  skip_no_git()
  targets::tar_script(targets::tar_target(x, 1))
  targets::tar_make(callr_function = NULL)
  targets::tar_invalidate(everything())
  capture.output(expect_message(tar_git_status(callr_function = NULL)))
})
