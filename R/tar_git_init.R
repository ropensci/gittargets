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
#'   temporarily stashes it to a hidden file called `.gittargets_gitignore`
#'   inside the data store. If your R program crashes while the stash
#'   is active, you can simply move it manually back to `.gitignore`
#'   or run `tar_git_status_data()` to restore the stash automatically
#'   if no `.gitignore` already exists.
#' @inheritParams targets::tar_config_set
#' @return `NULL` (invisibly).
#' @param stash_gitignore Logical of length 1, whether to temporarily
#'   stash the `.gitignore` file of the data store. See the
#'   "Stashing .gitignore" section for details.
#' @param git_lfs Logical, whether to automatically opt into Git LFS to track
#'   large files in `_targets/objects` more efficiently. If `TRUE`
#'   and Git LFS is installed, it should work automatically. If `FALSE`,
#'   you can always opt in later by running `git lfs track objects`
#'   inside the data store.
#' @param verbose Logical of length 1, whether to print messages to the
#'   R console.
#' @examples
#' if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
#' targets::tar_dir({ # Containing code does not modify the user's file space.
#' targets::tar_script(tar_target(data, 1))
#' targets::tar_make()
#' tar_git_init()
#' })
#' }
tar_git_init <- function(
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  git_lfs = TRUE,
  verbose = TRUE
) {
  tar_assert_file(store)
  targets::tar_assert_lgl(verbose)
  targets::tar_assert_scalar(verbose)
  if (tar_git_repo_exists(store)) {
    cli_info("Data store Git repository already exists.")
    cli_info("Remove ", file.path(store, ".git"), " to start over.")
    return(invisible())
  }
  if (stash_gitignore) {
    tar_git_gitignore_restore(repo = store)
    tar_git_gitignore_stash(repo = store)
    on.exit(tar_git_gitignore_unstash(repo = store))
  }
  tar_git_init_repo(path = store)
  cli_success("Created data store Git repository", verbose = verbose)
  if (git_lfs) {
    tar_git_init_lfs(repo = store, verbose = verbose)
  }
  tar_git_init_stub(repo = store, verbose = verbose)
  tar_git_commit(message = "Stub commit", repo = store, spinner = FALSE)
  cli_success("Created stub commit without data.", verbose = verbose)
  cli_info(
    "Run tar_git_snapshot() to put the data files under version control.",
    verbose = verbose
  )
  invisible()
}

tar_git_init_lfs <- function(repo, verbose) {
  gitattributes <- file.path(repo, ".gitattributes")
  lines <- c(
    "objects filter=lfs diff=lfs merge=lfs -text",
    "objects/* filter=lfs diff=lfs merge=lfs -text",
    "objects/** filter=lfs diff=lfs merge=lfs -text",
    "objects/**/* filter=lfs diff=lfs merge=lfs -text"
  )
  write_new_lines(path = gitattributes, lines = lines)
  cli_success(
    "Wrote to ",
    gitattributes,
    " for git-lfs: {.url https://git-lfs.com}.",
    verbose = verbose
  )
  tar_git_add(files = basename(gitattributes), repo = repo, spinner = FALSE)
}

tar_git_init_stub <- function(repo, verbose) {
  tar_git_stub_write(repo = repo)
  tar_git_add(
    files = basename(tar_git_stub_path(repo)),
    repo = repo,
    spinner = FALSE
  )
}
