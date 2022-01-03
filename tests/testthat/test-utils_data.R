targets::tar_test("inner_merge()", {
  x <- tibble::tibble(by = letters[c(1, 1, 2, 2, 3, 3, 4)], x = seq_len(7))
  y <- tibble::tibble(by = letters[c(1, 2, 3, 5)], y = LETTERS[c(1, 2, 3, 5)])
  out <- inner_merge(x = x, y = y, by = "by")
  expect_equal(sort(colnames(out)), sort(c("by", "x", "y")))
  out <- tibble::tibble(by = out$by, x = out$x, y = out$y)
  exp <- tibble::tibble(
    by = letters[c(1, 1, 2, 2, 3, 3)],
    x = seq_len(6),
    y = LETTERS[c(1, 1, 2, 2, 3, 3)]
  )
  expect_equal(out, exp)
})

targets::tar_test("write_new_lines()", {
  write_new_lines(lines = c("a", "b", "c"), path = "file.txt")
  expect_equal(readLines("file.txt"), c("a", "b", "c"))
  write_new_lines(lines = c("b", "d", "e"), path = "file.txt")
  expect_equal(
    sort(readLines("file.txt")),
    sort(c("a", "b", "c", "d", "e"))
  )
  write_new_lines(lines = c("b", "d", "e"), path = "file.txt")
  expect_equal(
    sort(readLines("file.txt")),
    sort(c("a", "b", "c", "d", "e"))
  )
})
