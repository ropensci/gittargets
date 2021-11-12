#' @title Status of the targets (Git)
#' @export
#' @family git
#' @description Show which targets are outdated.
#' @details This function has prettier output than `targets::tar_outdated()`,
#'   and it mainly serves [tar_git_status()].
#' @return A `tibble` with the names of outdated targets.
#' @inheritParams targets::tar_outdated
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script()
#' targets::tar_make()
#' list.files("_targets", all.files = TRUE)
#' gert::git_init()
#' tar_git_init()
#' tar_git_status_outdated()
#' })
#' }
tar_git_status_targets <- function(
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store"),
  reporter = targets::tar_config_get("reporter_outdated"),
  envir = parent.frame(),
  callr_function = callr::r,
  callr_arguments = targets::callr_args_default(callr_function, reporter)
) {
  outdated <- targets::tar_outdated(
    reporter = reporter,
    envir = envir,
    script = script,
    store = store,
    callr_function = callr_function,
    callr_arguments = callr_arguments
  )
  tibble::as_tibble(list(outdated = outdated))
}