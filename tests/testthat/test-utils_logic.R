targets::tar_test("%|||%", {
  expect_equal("x" %|||% "y", "x")
  expect_equal(character(0) %|||% "y", character(0))
  expect_equal(NULL %|||% "y", "y")
})

targets::tar_test("if_any()", {
  expect_true(if_any(TRUE, TRUE, FALSE))
  expect_false(if_any(FALSE, TRUE, FALSE))
})
