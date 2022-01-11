#' @title Snapshot the data repository (Git).
#' @export
#' @family git
#' @description Snapshot the Git data repository of a `targets` project.
#' @details A Git-backed `gittargets` data snapshot is a special kind of
#'   Git commit. Every data commit is part of a branch specific to
#'   the current code commit.
#'   That way, when you switch branches or commits in the code,
#'   `tar_git_checkout()` checks out the latest data snapshot
#'   that matches the code in your workspace.
#'   That way, your targets can stay up to date even as you
#'   transition among multiple branches.
#' @inheritSection tar_git_init Stashing .gitignore
#' @inheritParams tar_git_status
#' @param message Optional Git commit message of the data snapshot.
#'   If `NULL`, then the message is the Git commit message of the
#'   matching code commit.
#' @param ref Character of length 1, reference
#'   (branch name, Git SHA1 hash, etc.) of the code commit
#'   that will map to the new data snapshot. Defaults to the commit
#'   checked out right now.
#' @param status Logical of length 1, whether to print the project status
#'   with [tar_git_status()] and ask whether a snapshot should be created.
#' @param verbose Logical of length 1, whether to print R console messages
#'   confirming that a snapshot was created.
#' @param force Logical of length 1. Force checkout the data branch
#'   of an existing data snapshot of the current code commit?
#' @param pack_refs Logical of length 1, whether to run `git pack-refs --all`
#'   in the data store after taking the snapshot. Packing references
#'   improves efficiency when the number of snapshots is large.
#'   Learn more at <https://git-scm.com/docs/git-pack-refs>.
#' @examples
#' if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
#' targets::tar_dir({ # Containing code does not modify the user's filespace.
#' targets::tar_script(tar_target(data, 1))
#' targets::tar_make()
#' gert::git_init()
#' gert::git_add("_targets.R")
#' gert::git_commit("First commit")
#' tar_git_init()
#' tar_git_snapshot(status = FALSE)
#' })
#' }
tar_git_snapshot <- function(
  message = NULL,
  ref = "HEAD",
  code = getwd(),
  script = targets::tar_config_get("script"),
  store = targets::tar_config_get("store"),
  stash_gitignore = TRUE,
  reporter = targets::tar_config_get("reporter_outdated"),
  envir = parent.frame(),
  callr_function = callr::r,
  callr_arguments = targets::callr_args_default(callr_function, reporter),
  status = interactive(),
  force = FALSE,
  pack_refs = TRUE,
  verbose = TRUE
) {
  tar_assert_file(code)
  tar_assert_file(store)
  targets::tar_assert_lgl(status)
  targets::tar_assert_scalar(status)
  targets::tar_assert_lgl(force)
  targets::tar_assert_scalar(force)
  targets::tar_assert_lgl(pack_refs)
  targets::tar_assert_scalar(pack_refs)
  targets::tar_assert_lgl(verbose)
  targets::tar_assert_scalar(verbose)
  tar_git_assert_repo_code(code)
  tar_git_assert_commits_code(code)
  tar_git_assert_repo_data(store)
  log <- gert::git_log(repo = code, max = 1L)
  commit <- gert::git_commit_info(repo = code, ref = ref)$id
  branch <- tar_git_branch_snapshot(commit)
  code_message <- gert::git_commit_info(repo = code, ref = ref)$message
  # Covered in tests/interactive/test-tar_git_snapshot.R
  # nocov start
  if (status) {
    choice <- tar_git_snapshot_menu(
      commit = commit,
      message = code_message,
      code = code,
      script = script,
      store = store,
      stash_gitignore = stash_gitignore,
      reporter = reporter,
      envir = envir,
      callr_function = callr_function,
      callr_arguments = callr_arguments
    )
    if (!identical(as.integer(choice), 1L)) {
      cli_info("Snapshot skipped.", verbose = verbose)
      return(invisible())
    }
  }
  # nocov end
  if (stash_gitignore) {
    tar_git_gitignore_restore(repo = store)
    tar_git_gitignore_stash(repo = store)
    on.exit(tar_git_gitignore_unstash(repo = store))
  }
  tar_git_stub_write(repo = store)
  if_any(
    gert::git_branch_exists(branch = branch, repo = store),
    tar_git_snapshot_branch_exists(branch = branch, verbose = verbose),
    tar_git_snapshot_branch_create(
      branch = branch,
      repo = store,
      verbose = verbose
    )
  )
  tar_git_branch_checkout(branch = branch, repo = store, force = force)
  cli_info("Staging data files.", verbose = verbose)
  tar_git_add(files = "*", repo = store)
  staged <- gert::git_status(staged = TRUE, repo = store)
  staged$staged <- NULL
  cli_success(
    sprintf("Staged %s files in the data store.", nrow(staged)),
    verbose = verbose
  )
  cli_info("Committing data changes.", verbose = verbose)
  tar_git_commit_all(message = message %|||% code_message, repo = store)
  commit <- gert::git_commit_info(repo = store)$id
  cli_success(
    sprintf("Created new data snapshot %s.", commit),
    verbose = verbose
  )
  if (pack_refs) {
    cli_info("Packing references.", verbose = verbose)
    tar_git_pack_refs(repo = store, spinner = verbose)
  }
  invisible()
}

tar_git_snapshot_branch_create <- function(branch, repo, verbose) {
  cli_info(sprintf("Creating data branch %s.", branch), verbose = verbose)
  tar_git_branch_create(branch = branch, repo = repo)
}

tar_git_snapshot_branch_exists <- function(branch, verbose) {
  cli_info(
    "Data snapshot already exists for the current code commit.",
    verbose = verbose
  )
  cli_info(
    "The new data snapshot will supersede the old one in data branch:",
    verbose = verbose
  )
  cli_indent("{.field ", branch, "}", verbose = verbose)
}

# Covered in tests/interactive/test-tar_git_snapshot.R
# nocov start
#' @title Data snapshot menu (Git)
#' @keywords internal
#' @description Check the project status and show an interactive menu
#'   for [tar_git_snapshot()].
#' @return Integer of length 1: `2L` if the user agrees to snapshot,
#'   `1L` if the user declines.
#' @inheritParams tar_git_snapshot
#' @param commit Character of length 1, Git SHA1 hash of the code commit
#'   that will correspond to the data snapshot (if created).
#' @examples
#' # See the examples of tar_git_snapshot().
tar_git_snapshot_menu <- function(
  commit,
  message,
  code,
  script,
  store,
  stash_gitignore,
  reporter,
  envir,
  callr_function,
  callr_arguments
) {
  tar_git_status(
    code = code,
    script = script,
    store = store,
    stash_gitignore = stash_gitignore,
    reporter = reporter,
    envir = envir,
    callr_function = callr_function,
    callr_arguments = callr_arguments
  )
  cli::cli_h1("Snapshot the data?")
  line <- paste(
    "The new snapshot will be a data commit",
    "that maps to the following code commit:"
  )
  cli_info(line)
  cli_indent(commit)
  cli_indent(first_line(message))
  line <- paste(
    "Please make sure the code repo and",
    "{.pkg targets} pipeline are clean and up to date."
  )
  cli_info(line)
  utils::menu(c("yes", "no"))
}
# nocov end
