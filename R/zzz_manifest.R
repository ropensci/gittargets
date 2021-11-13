#' @title Write a manifest file.
#' @export
#' @description Not a user-side function.
#' @details Writes a `manifest.json` file so the `pkgdown` site
#'   can be deployed to RStudio Connect as Git-backed content.
#' @return `NULL` (invisibly).
#' @examples
#' zzz_write_manifest()
zzz_write_manifest <- function() {
  # nocov start
  pkgdown <- requireNamespace("pkgdown", quietly = TRUE) &&
    eval(parse(text = "pkgdown::in_pkgdown()"))
  if (pkgdown) {
    eval(parse(text = "withr::with_dir"))(
      "..",
      eval(parse(text = "rsconnect::writeManifest"))(
        appPrimaryDoc = "index.html",
        contentCategory = "site"
      )
    )
  }
  # nocov end
}
