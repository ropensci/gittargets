targets::tar_test("tar_git_ok()", {
  skip_os_git()
  expect_true(tar_git_ok())
  expect_message(tar_git_ok(verbose = TRUE))
  expect_silent(tar_git_ok(verbose = FALSE))
})

targets::tar_test("tar_git_ok()", {
  skip_os_git()
  old <- Sys.getenv("TAR_GIT", unset = Sys.which("git"))
  on.exit(Sys.setenv(TAR_GIT = old))
  tmp <- tempfile()
  file.create(tmp)
  Sys.setenv(TAR_GIT = tmp)
  expect_false(tar_git_ok())
  expect_message(tar_git_ok(verbose = TRUE))
  expect_silent(tar_git_ok(verbose = FALSE))
})
