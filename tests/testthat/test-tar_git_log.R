targets::tar_test("tar_git_log()", {
  skip_os_git()
  git_setup_init()
  tar_git_snapshot(status = FALSE, verbose = FALSE, message = "First snapshot")
  out <- tar_git_log()
  cols <- c(
    "message_code",
    "message_data",
    "time_code",
    "time_data",
    "commit_code",
    "commit_data"
  )
  expect_equal(sort(colnames(out)), sort(cols))
  expect_equal(nrow(out), 1L)
  expect_false(any(is.na(out)))
  expect_equal(out$message_code, "First commit")
  expect_equal(out$message_data, "First snapshot")
  for (field in c("time_code", "time_data")) {
    expect_s3_class(out[[field]], "POSIXct")
  }
  for (field in c("commit_code", "commit_data")) {
    expect_true(is.character(out[[field]]))
    expect_true(nzchar(out[[field]]))
  }
})
