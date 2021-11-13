cli_danger <- function(..., verbose = TRUE) {
  if (verbose) {
    cli::cli_alert_danger(paste0(...))
  }
}

cli_info <- function(..., verbose = TRUE) {
  if (verbose) {
    cli_blue_bullet(paste0(...), verbose = verbose)
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

cli_blue_bullet <- function(..., verbose = TRUE) {
  if (verbose) {
    symbol <- cli::col_blue(cli::symbol$bullet)
    cli::cli_text(paste(symbol, paste0(...)))
  }
}

cli_indent <- function(..., verbose = TRUE) {
  if (verbose) {
    cli::cli_bullets(c(" " = paste0(...)))
  }
}
