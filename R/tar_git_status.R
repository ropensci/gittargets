#' @title Status of the project 
#' @export
#' @family git
#' @description Show the Git status of the code repository and
#'   data store repository, as well as the number of outdated
#'   targets.
#' @inheritParams targets::tar_outdated
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' targets::tar_script()
#' targets::tar_make()
#' list.files("_targets", all.files = TRUE)
#' gert::git_init()
#' tar_git_init()
#' tar_git_status()
#' })
#' }
tar_git_status <- function(
  project = getwd(),
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  reporter = targets::tar_config_get("reporter_outdated"),
  envir = parent.frame()
) {
  targets::tar_assert_file(project)
  targets::tar_assert_file(store)
  targets::tar_assert_file(script)
  tar_git_status_project(project)
  tar_git_status_store(store, stash_gitignore)
  tar_git_status_outdated(
    reporter = reporter,
    envir = envir,
    script = script,
    store = store
  )
  invisible()
}

#' @export
tar_git_status_project <- function(project) {
  cli::cli_h1("Project code Git status")
  if_any(
    git_repo_exists(project),
    tar_git_status_project_print(project),
    tar_git_status_project_none()
  )
}

tar_git_status_project_print <- function(project) {
  status <- gert::git_status(repo = project)
  if_any(
    nrow(status),
    print(status),
    cli_success("Project code Git repository is clean.")
  )
}

tar_git_status_project_none <- function() {
  cli_danger("Project code has no Git repository.")
  tar_git_status_tip()
}

#' @export
tar_git_status_store <- function(store, stash_gitignore) {
  cli::cli_h1("Data store Git status")
  if (stash_gitignore) {
    gitignore <- git_stash_gitignore(repo = store)
    on.exit(git_unstash_gitignore(repo = store, stash = gitignore))
  }
  if_any(
    git_repo_exists(store),
    tar_git_status_store_print(store),
    tar_git_status_store_none()
  )
}

tar_git_status_store_print <- function(store) {
  status <- gert::git_status(repo = store)
  if_any(
    nrow(status),
    print(status),
    cli_success("Data store Git repository is clean.")
  )
}

tar_git_status_store_none <- function() {
  cli_danger("No Git repository for the data store.")
  tar_git_status_tip()
}

tar_git_status_tip <- function() {
  tip <- c(
    "The project code and the data store must both be Git repositories.",
    "Create the code repository with {.code gert::git_init()}.",
    "Create the data repository with {.code gittargets::tar_git_init()}."
  )
  lapply(tip, cli_warning)
}

#' @export
tar_git_status_outdated <- function(
  reporter = reporter,
  envir = envir,
  script = script,
  store = store
) {
  cli::cli_h1("Outdated targets")
  outdated <- targets::tar_outdated(
    reporter = reporter,
    envir = envir,
    script = script,
    store = store
  )
  if_any(
    length(outdated),
    tar_git_status_outdated_print(outdated),
    cli_success("All targets are up to date.")
  )
}

tar_git_status_outdated_print <- function(outdated) {
  print(tibble::as_tibble(list(name = outdated)))
}
