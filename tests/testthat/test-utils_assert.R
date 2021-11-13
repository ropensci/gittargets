targets::tar_test("tar_git_assert_commits_code()", {
  gert::git_init()
  expect_error(
    tar_git_assert_commits_code(getwd()),
    class = "tar_condition_validate"
  )
  git_setup_init()
  expect_silent(tar_git_assert_commits_code(getwd()))
})

targets::tar_test("tar_git_assert_commits_data()", {
  gert::git_init()
  expect_error(
    tar_git_assert_commits_data(getwd()),
    class = "tar_condition_validate"
  )
  git_setup_init()
  expect_silent(tar_git_assert_commits_data(getwd()))
})

targets::tar_test("tar_git_assert_repo_code()", {
  expect_error(
    tar_git_assert_repo_code(getwd()),
    class = "tar_condition_validate"
  )
  gert::git_init()
  expect_silent(tar_git_assert_repo_code(getwd()))
})

targets::tar_test("tar_git_assert_repo_data()", {
  expect_error(
    tar_git_assert_repo_data(getwd()),
    class = "tar_condition_validate"
  )
  gert::git_init()
  expect_silent(tar_git_assert_repo_data(getwd()))
})
