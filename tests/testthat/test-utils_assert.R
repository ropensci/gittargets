targets::tar_test("tar_git_assert_commits_code()", {
  skip_no_git()
  gert::git_init()
  expect_error(
    tar_git_assert_commits_code(getwd()),
    class = "tar_condition_validate"
  )
  utils::capture.output(git_setup_init())
  expect_silent(tar_git_assert_commits_code(getwd()))
})

targets::tar_test("tar_git_assert_commits_data()", {
  skip_no_git()
  gert::git_init()
  expect_error(
    tar_git_assert_commits_data(getwd()),
    class = "tar_condition_validate"
  )
  utils::capture.output(git_setup_init())
  expect_silent(tar_git_assert_commits_data(getwd()))
})

targets::tar_test("tar_git_assert_repo_code()", {
  skip_no_git()
  expect_error(
    tar_git_assert_repo_code(getwd()),
    class = "tar_condition_validate"
  )
  gert::git_init()
  expect_silent(tar_git_assert_repo_code(getwd()))
})

targets::tar_test("tar_git_assert_repo_data()", {
  skip_no_git()
  expect_error(
    tar_git_assert_repo_data(getwd()),
    class = "tar_condition_validate"
  )
  gert::git_init()
  expect_silent(tar_git_assert_repo_data(getwd()))
})

targets::tar_test("tar_git_assert_repo_data() no branch", {
  skip_no_git()
  utils::capture.output(git_setup_init())
  store <- targets::tar_config_get("store")
  expect_error(
    tar_git_assert_snapshot(branch = "nope", store = store),
    class = "tar_condition_validate"
  )
  utils::capture.output(tar_git_snapshot(status = FALSE, verbose = FALSE))
  branch <- tar_git_branch_snapshot(tar_git_log()$commit_code)
  expect_silent(tar_git_assert_snapshot(branch = branch, store = store))
})
