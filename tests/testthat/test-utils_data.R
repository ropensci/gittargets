targets::tar_test("left_merge()", {
  x <- tibble::tibble(by = letters[c(1, 1, 2, 2, 3, 3)], x = seq_len(6))
  y <- tibble::tibble(by = letters[c(1, 2, 3)], y = LETTERS[c(1, 2, 3)])
  out <- left_merge(x = x, y = y, by = "by")
  expect_equal(sort(colnames(out)), sort(c("by", "x", "y")))
  out <- tibble::tibble(by = out$by, x = out$x, y = out$y)
  exp <- tibble::tibble(
    by = letters[c(1, 1, 2, 2, 3, 3)],
    x = seq_len(6),
    y = LETTERS[c(1, 1, 2, 2, 3, 3)]
  )
  expect_equal(out, exp)
})
