cli_danger <- function(..., verbose = TRUE) {
  if (verbose) {
    cli::cli_alert_danger(paste0(...))
  }
}

cli_df <- function(x, verbose = TRUE) {
  if (verbose) {
    lines <- utils::capture.output(x, type = "output")
    message(cli::col_br_white(paste0(lines, "\n")))
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
