#' @title Check Git
#' @export
#' @family git
#' @description Check if Git is installed and if `user.name` and `user.email`
#'   are configured globally.
#' @details You can install Git from <https://git-scm.com/downloads/>
#'   and configure your identity using the instructions at
#'   <https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup>.
#'   You may find it convenient to run `gert::git_config_global()`
#'   with `name` equal to `user.name` and `user.email`.
#' @return Logical of length 1, whether Git is installed and configured
#'   correctly.
#' @param verbose Whether to print messages to the console.
#' @examples
#' tar_git_ok()
tar_git_ok <- function(verbose = TRUE) {
  binary <- tar_git_binary()
  if_any(
    nzchar(binary),
    cli_success(
      "Git binary: {.file ",
      binary,
      "}",
      verbose = verbose
    ),
    cli_danger(
      "No Git binary found. ",
      "Install from {.url https://git-scm.com/downloads/}.",
      verbose = verbose
    )
  )
  # Cannot test without uninstalling Git.
  # nocov start
  if (!nzchar(binary)) {
    cli_danger("No Git installation found.", verbose = verbose)
    return(FALSE)
  }
  # nocov end
  user_name <- suppressWarnings(
    system2("git", c("config", "--global", "user.name"), stdout = TRUE)
  )
  user_name <- trimws(user_name)
  if_any(
    nzchar(user_name),
    cli_success(
      "Git config global user name: {.field ",
      user_name,
      "}",
      verbose = verbose
    ),
    cli_danger(
      "No Git config global user email. See details in ?tar_git_ok().",
      verbose = verbose
    )
  )
  user_email <- suppressWarnings(
    system2("git", c("config", "--global", "user.email"), stdout = TRUE)
  )
  user_email <- trimws(user_email)
  if_any(
    nzchar(user_email),
    cli_success(
      "Git config global user email: {.email ",
      user_email,
      "}",
      verbose = verbose
    ),
    cli_danger(
      "No Git config global user email. See details in ?tar_git_ok().",
      verbose = verbose
    )
  )
  length(user_name) &&
    nzchar(user_name) &&
    length(user_email) &&
    nzchar(user_email)
}
