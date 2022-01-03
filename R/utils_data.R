first_line <- function(x) {
  trimws(utils::head(unlist(strsplit(x, split = "\n")), n = 1L))
}

inner_merge <- function(x, y, by) {
  out <- merge(
    x = data.table::as.data.table(x),
    y = data.table::as.data.table(y),
    by = by,
    all.x = FALSE,
    all.y = FALSE
  )
  out <- as.list(out)
  names <- names(out)
  attributes(out) <- NULL
  names(out) <- names
  tibble::as_tibble(out)
}

write_new_lines <- function(lines, path) {
  old_lines <- if_any(file.exists(path), readLines(path), character(0))
  all_lines <- union(x = old_lines, y = lines)
  writeLines(all_lines, path)
}
