`%|||%` <- function(x, y) {
  if (is.null(x)) {
    y
  }
  else {
    x
  }
}

if_any <- function(condition, x, y) {
  if (any(condition)) {
    x
  } else {
    y
  }
}
