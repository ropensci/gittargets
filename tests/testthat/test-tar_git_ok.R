targets::tar_test("tar_git_ok()", {
  skip_os_git()
  expect_true(tar_git_ok())
  expect_message(tar_git_ok(verbose = TRUE))
  expect_silent(tar_git_ok(verbose = FALSE))
})
