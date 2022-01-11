#' @title Status of the project (Git)
#' @export
#' @family git
#' @description Print the status of the code repository,
#'   the data repository, and the targets.
#' @inheritSection tar_git_init Stashing .gitignore
#' @return `NULL` (invisibly). Status information is printed
#'   to the R console.
#' @inheritParams tar_git_status_code
#' @inheritParams tar_git_status_data
#' @inheritParams tar_git_status_targets
#' @examples
#' if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
#' targets::tar_dir({ # Containing code does not modify the user's files pace.
#' targets::tar_script(tar_target(data, 1))
#' targets::tar_make()
#' list.files("_targets", all.files = TRUE)
#' gert::git_init()
#' tar_git_init()
#' tar_git_status()
#' })
#' }
tar_git_status <- function(
  code = getwd(),
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  reporter = targets::tar_config_get("reporter_outdated"),
  envir = parent.frame(),
  callr_function = callr::r,
  callr_arguments = targets::callr_args_default(callr_function, reporter)
) {
  cli::cli_h1("Data Git status")
  status <- tar_git_status_data(store, stash_gitignore)
  if_any(
    is.null(status),
    tar_git_status_data_none(),
    tar_git_status_data_message(status)
  )
  cli::cli_h1("Code Git status")
  status <- tar_git_status_code(code)
  if_any(
    is.null(status),
    tar_git_status_code_none(),
    tar_git_status_code_message(status)
  )
  cli::cli_h1("Outdated targets")
  status <- tar_git_status_targets(
    script = script,
    store = store,
    reporter = reporter,
    envir = envir,
    callr_function = callr_function,
    callr_arguments = callr_arguments
  )
  if_any(
    nrow(status),
    cli_df(status),
    cli_success("All targets are up to date.")
  )
  invisible()
}

tar_git_status_code_message <- function(status) {
  if_any(
    nrow(status),
    cli_df(status),
    cli_success("Code repository is clean.")
  )
}

tar_git_status_code_none <- function() {
  cli_danger("Code has no Git repository.")
  cli_warning("Create one with {.code gert::git_init()}).")
}

tar_git_status_data_message <- function(status) {
  if_any(
    nrow(status),
    cli_df(status),
    cli_success("Data repository is clean.")
  )
}

tar_git_status_data_none <- function() {
  cli_danger("No Git repository for the data store.")
  cli_warning("Create one with {.code gittargets::tar_git_init()}.")
}
