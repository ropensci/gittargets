targets::tar_test("tar_git_checkout()", {
  skip_os_git()
  # Work on an initial branch.
  targets::tar_script(tar_target(data, "old_data"))
  targets::tar_make(callr_function = NULL)
  expect_equal(targets::tar_progress(data)$progress, status_completed())
  expect_equal(targets::tar_read(data), "old_data")
  gert::git_init()
  gert::git_add("_targets.R")
  gert::git_commit("First commit")
  gert::git_branch_create("old_branch")
  tar_git_init()
  # Work on a new branch.
  tar_git_snapshot(status = FALSE, verbose = FALSE)
  targets::tar_script(tar_target(data, "new_data"))
  targets::tar_make(callr_function = NULL)
  expect_equal(targets::tar_progress(data)$progress, status_completed())
  expect_equal(targets::tar_read(data), "new_data")
  gert::git_branch_create("new_branch")
  gert::git_add("_targets.R")
  gert::git_commit("Second commit")
  tar_git_snapshot(status = FALSE, verbose = FALSE)
  # Go back to the old branch.
  gert::git_branch_checkout("old_branch")
  # The target is out of date because we only reverted the code.
  targets::tar_outdated(callr_function = NULL)
  # But tar_git_checkout() lets us restore the old version of the data!
  tar_git_checkout()
  # Now, the target is up to date! And we did not even have to rerun it!
  expect_equal(targets::tar_outdated(callr_function = NULL), character(0))
  # Modified files get recovered on checkout.
  old <- readLines(file.path("_targets", "meta", "meta"))
  expect_equal(targets::tar_read(data), "old_data")
  writeLines("line", file.path("_targets", "meta", "meta"))
  expect_equal(readLines(file.path("_targets", "meta", "meta")), "line")
  tar_git_checkout()
  expect_equal(readLines(file.path("_targets", "meta", "meta")), old)
  expect_equal(targets::tar_outdated(callr_function = NULL), character(0))
  # Deleted files get recovered on checkout.
  unlink(file.path("_targets", "meta", "meta"))
  expect_false(file.exists(file.path("_targets", "meta", "meta")))
  tar_git_checkout()
  expect_equal(readLines(file.path("_targets", "meta", "meta")), old)
  expect_equal(targets::tar_outdated(callr_function = NULL), character(0))
})
