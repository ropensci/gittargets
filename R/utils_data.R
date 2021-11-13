left_merge <- function(x, y, by) {
  out <- merge(
    x = data.table::as.data.table(x),
    y = data.table::as.data.table(y), 
    by = by,
    all.x = TRUE
  )
  tibble::as_tibble(out)
}
