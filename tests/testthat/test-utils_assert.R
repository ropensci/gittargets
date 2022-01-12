# TODO: remove when it is safe to import
# tar_assert_file() from `targets`.
targets::tar_test("tar_assert_file()", {
  expect_error(tar_assert_file(0), class = "tar_condition_validate")
  expect_error(tar_assert_file("x"), class = "tar_condition_validate")
  file.create("x")
  expect_error(tar_assert_file(c("x", "y")), class = "tar_condition_validate")
  expect_silent(tar_assert_file("x"))
})

targets::tar_test("tar_git_assert_commits_code()", {
  skip_os_git()
  gert::git_init()
  expect_error(
    tar_git_assert_commits_code(getwd()),
    class = "tar_condition_validate"
  )
  git_setup_init()
  expect_silent(tar_git_assert_commits_code(getwd()))
})

targets::tar_test("tar_git_assert_commits_data()", {
  skip_os_git()
  gert::git_init()
  expect_error(
    tar_git_assert_commits_data(getwd()),
    class = "tar_condition_validate"
  )
  git_setup_init()
  expect_silent(tar_git_assert_commits_data(getwd()))
})

targets::tar_test("tar_git_assert_repo_code()", {
  skip_os_git()
  expect_error(
    tar_git_assert_repo_code(getwd()),
    class = "tar_condition_validate"
  )
  gert::git_init()
  expect_silent(tar_git_assert_repo_code(getwd()))
})

targets::tar_test("tar_git_assert_repo_data()", {
  skip_os_git()
  expect_error(
    tar_git_assert_repo_data(getwd()),
    class = "tar_condition_validate"
  )
  gert::git_init()
  expect_silent(tar_git_assert_repo_data(getwd()))
})

targets::tar_test("tar_git_assert_repo_data() no branch", {
  skip_os_git()
  git_setup_init()
  store <- targets::tar_config_get("store")
  expect_error(
    tar_git_assert_snapshot(branch = "nope", store = store),
    class = "tar_condition_validate"
  )
  tar_git_snapshot(status = FALSE, verbose = FALSE)
  branch <- tar_git_branch_snapshot(tar_git_log()$commit_code)
  expect_silent(tar_git_assert_snapshot(branch = branch, store = store))
})

targets::tar_test("tar_assert_finite", {
  expect_silent(tar_assert_finite(1))
  expect_silent(tar_assert_finite(c(1, 2)))
  expect_error(tar_assert_finite(c(1, Inf)), class = "tar_condition_validate")
})
