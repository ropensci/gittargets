if_any <- function(condition, x, y) {
  if (any(condition)) {
    x
  } else {
    y
  }
}
