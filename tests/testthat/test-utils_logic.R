tar_test("if_any()", {
  expect_true(if_any(TRUE, TRUE, FALSE))
  expect_false(if_any(FALSE, TRUE, FALSE))
})
