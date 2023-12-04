targets_1.3.2.9004 <- function() {
  utils::compareVersion(
    a = as.character(packageVersion("targets")),
    b = "1.3.2.9004"
  ) > -1L
}

status_completed <- function() {
  if (targets_1.3.2.9004()) {
    "completed"
  } else {
    "built"
  }
}

status_dispatched <- function() {
  if (targets_1.3.2.9004()) {
    "dispatched"
  } else {
    "started"
  }
}
