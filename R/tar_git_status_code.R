#' @title Status of the code repository (Git)
#' @export
#' @family git
#' @description Show the Git status of the code repository.
#' @inheritParams targets::tar_outdated
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script()
#' targets::tar_make()
#' list.files("_targets", all.files = TRUE)
#' gert::git_init()
#' tar_git_init()
#' tar_git_status_code()
#' })
#' }
tar_git_status_code <- function(code = getwd()) {
  targets::tar_assert_file(code)
  if_any(
    git_repo_exists(code),
    gert::git_status(repo = code),
    NULL
  )
}
