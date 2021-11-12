#' @title Status of the code repository (Git)
#' @export
#' @family git
#' @description Show the Git status of the code repository.
#' @return If the code repository exists, the return value is the data frame
#'   produced by `gert::git_status(repo = code)`. If the code has no Git
#'   repository, then the return value is `NULL`.
#' @param code Character of length 1, directory path to the code repository,
#'   usually the root of the `targets` project.
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