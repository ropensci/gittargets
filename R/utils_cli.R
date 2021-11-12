cli_danger <- function(..., verbose = TRUE) {
  if (verbose) {
    cli::cli_alert_danger(paste0(...))
  }
}

cli_info <- function(..., verbose = TRUE) {
  if (verbose) {
    cli_blue_bullet(paste0(...))
  }
}

cli_success <- function(..., verbose = TRUE) {
  if (verbose) {
    cli::cli_alert_success(paste0(...))
  }
}

cli_warning <- function(..., verbose = TRUE) {
  if (verbose) {
    cli::cli_alert_warning(paste0(...))
  }
}

cli_blue_bullet <- function(msg) {
  symbol <- cli::col_blue(cli::symbol$bullet)
  msg <- paste(symbol, msg)
  cli::cli_text(msg)
}

cli_indent <- function(msg) {
  cli::cli_bullets(c(" " = msg))
}
