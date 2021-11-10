targets::tar_test("tar_git_init()", {
  store <- targets::tar_config_get("store")
  dir.create(store)
  expect_false(file.exists(file.path(store, ".git")))
  dir <- getwd()
  tar_git_init(store = store)
  expect_equal(getwd(), dir)
  expect_true(file.exists(file.path(store, ".git")))
})
