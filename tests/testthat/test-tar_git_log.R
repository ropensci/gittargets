targets::tar_test("tar_git_log()", {
  git_setup_init()
  tar_git_snapshot(status = FALSE, verbose = FALSE)
  out <- tar_git_log()
  expect_equal(dim(out), c(1L, 5L))
  expect_false(any(is.na(out)))
  expect_equal(out$message, "First commit")
  for (field in c("time_code", "time_data")) {
    expect_s3_class(out[[field]], "POSIXct")
  }
  for (field in c("commit_code", "commit_data")) {
    expect_true(is.character(out[[field]]))
    expect_true(nzchar(out[[field]]))
  }
})
