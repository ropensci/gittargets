left_merge <- function(x, y, by) {
  out <- merge(
    x = data.table::as.data.table(x),
    y = data.table::as.data.table(y),
    by = by,
    all.x = TRUE
  )
  out <- as.list(out)
  names <- names(out)
  attributes(out) <- NULL
  names(out) <- names
  tibble::as_tibble(out)
}
