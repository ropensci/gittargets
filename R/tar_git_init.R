#' @title Initialize a data repository (Git).
#' @export
#' @family git
#' @description Initialize a Git repository for a `targets` data store.
#' @details `tar_git_init()` also writes a `.gitattributes` file to the
#'   store to automatically track target output date with `git-lfs`
#'   if it is installed on your system.
#' @section Stashing .gitignore:
#'   The `targets` package writes a `.gitignore` file to new data stores
#'   in order to prevent accidental commits to the code Git repository.
#'   Unfortunately, for `gittargets`, this automatic `.gitignore` file
#'   interferes with proper data versioning. So by default, `gittargets`
#'   temporarily stashes it to a file called `gitignore_stash`
#'   inside the data store. If your R program crashes while the stash
#'   is active, you can simply move it manually back to `.gitignore`
#'   or run `tar_git_status_data()` to restore the stash automatically
#'   if no `.gitignore` already exists.
#' @inheritParams targets::tar_config_set
#' @return `NULL` (invisibly).
#' @param stash_gitignore Logical of length 1, whether to temporarily
#'   stash the `.gitignore` file of the data store. See the
#'   "Stashing .gitignore" section for details.
#' @param verbose Logical of length 1, whether to print messages to the
#'   R console.
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script(tar_target(data, 1))
#' targets::tar_make()
#' tar_git_init()
#' })
#' }
tar_git_init <- function(
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  verbose = TRUE
) {
  tar_assert_file(store)
  targets::tar_assert_lgl(verbose)
  targets::tar_assert_scalar(verbose)
  if (tar_git_repo_exists(store)) {
    cli_info("Data store Git repository already exists.")
    cli_info("Remove ", store, " to start over.")
    return(invisible())
  }
  if (stash_gitignore) {
    tar_git_gitignore_unstash(repo = store)
    tar_git_gitignore_stash(repo = store)
    on.exit(tar_git_gitignore_unstash(repo = store))
  }
  tar_git_init_repo(path = store)
  cli_success("Created data store Git repository", verbose = verbose)
  tar_git_init_stub_commit(repo = store, verbose = verbose)
  cli_success("Created stub commit without data.", verbose = verbose)
  cli_info(
    "Run tar_git_snapshot() to put the data files under version control.",
    verbose = verbose
  )
  invisible()
}

tar_git_init_stub_commit <- function(repo, verbose) {
  gitattributes <- file.path(repo, ".gitattributes")
  lines <- c(
    "objects filter=lfs diff=lfs merge=lfs -text",
    "objects/* filter=lfs diff=lfs merge=lfs -text",
    "objects/** filter=lfs diff=lfs merge=lfs -text",
    "objects/**/* filter=lfs diff=lfs merge=lfs -text"
  )
  usethis::write_union(path = gitattributes, lines = lines, quiet = TRUE)
  cli_success(
    "Wrote to ",
    gitattributes,
    " for git-lfs: {.url https://git-lfs.github.com}.",
    verbose = verbose
  )
  tar_git_stub_write(repo = repo)
  tar_git_add(
    files = basename(c(tar_git_stub_path(repo), gitattributes)),
    repo = repo,
    echo = verbose,
    spinner = FALSE
  )
  tar_git_commit(
    message = "Stub commit",
    repo = repo,
    echo = verbose,
    spinner = FALSE
  )
}
