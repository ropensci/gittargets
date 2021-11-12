targets::tar_test("cli_danger()", {
  expect_message(cli_danger("x", verbose = TRUE))
  expect_silent(cli_danger("x", verbose = FALSE))
})

targets::tar_test("cli_info()", {
  expect_message(cli_info("x", verbose = TRUE))
  expect_silent(cli_info("x", verbose = FALSE))
})

targets::tar_test("cli_success()", {
  expect_message(cli_success("x", verbose = TRUE))
  expect_silent(cli_success("x", verbose = FALSE))
})

targets::tar_test("cli_warning()", {
  expect_message(cli_warning("x", verbose = TRUE))
  expect_silent(cli_warning("x", verbose = FALSE))
})

targets::tar_test("cli_blue_bullet()", {
  expect_message(cli_blue_bullet("x"))
})

targets::tar_test("cli_indent()", {
  expect_message(cli_indent("x"))
})
