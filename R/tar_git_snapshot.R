#' @title Snapshot the data repository (Git).
#' @export
#' @family git
#' @description Snapshot the Git data repository of a `targets` project.
#' @details A Git-backed `gittargets` data snapshot is a special kind of
#'   Git commit. Every data commit gets its own branch,
#'   and the branch name contains the Git SHA1 hash
#'   of the current code commit.
#'   In addition, a special `.gittargets` file gets written
#'   to the data store so you can create a new snapshot even when the
#'   data working tree is clean.
#'   That way, when you switch branches or commits in the code,
#'   `tar_git_checkout()` can revert the data to match.
#'   Ideally, your targets should stay up to date even as you
#'   transition among multiple branches.
#' @inheritSection tar_git_init Stashing .gitignore
#' @inheritParams tar_git_status
#' @param ref Character of length 1, reference
#'   (branch name, Git SHA1 hash, etc.) of the code commit
#'   that will map to the new data snapshot. Defaults to the commit
#'   checked out right now.
#' @param status Logical of length 1, whether to print the project status
#'   with [tar_git_status()] and ask whether a snapshot should be created.
#' @param verbose Logical of length 1, whether to print R console messages
#'   confirming that a snapshot was created.
#' @examples
#' if (Sys.getenv("GITTARGETS_EXAMPLES") == "true") {
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
  verbose = TRUE
) {
  targets::tar_assert_file(code)
  targets::tar_assert_file(store)
  targets::tar_assert_lgl(status)
  targets::tar_assert_scalar(status)
  tar_git_assert_repo_code(code)
  tar_git_assert_commits_code(code)
  tar_git_assert_repo_data(store)
  log <- gert::git_log(repo = code, max = 1L)
  commit <- gert::git_commit_info(repo = code, ref = ref)$id
  branch <- tar_git_branch_snapshot(commit)
  message <- gert::git_commit_info(repo = code, ref = ref)$message
  # Covered in tests/interactive/test-tar_git_snapshot.R
  # nocov start
  if (status) {
    choice <- tar_git_snapshot_menu(
      commit = commit,
      message = message,
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
      cli_info("Snapshot skipped", verbose = verbose)
      return(invisible())
    }
  }
  # nocov end
  if (gert::git_branch_exists(branch = branch, repo = store)) {
    targets::tar_throw_validate(
      "Data snapshot already exists for code commit ",
      commit,
      ". To create a new data snapshot, please create a new code commit first."
    )
  }
  if (stash_gitignore) {
    tar_git_gitignore_restore(repo = store)
    tar_git_gitignore_stash(repo = store)
    on.exit(tar_git_gitignore_unstash(repo = store))
  }
  tar_git_stub_write(repo = store)
  cli_info(sprintf("Creating data branch %s.", branch), verbose = verbose)
  tar_git_branch_create(branch = branch, repo = store)
  tar_git_branch_checkout(branch = branch, repo = store, force = FALSE)
  cli_info("Staging data files.", verbose = verbose)
  tar_git_add(files = "*", repo = store)
  staged <- gert::git_status(staged = TRUE, repo = store)
  staged$staged <- NULL
  cli_info("Staged files in the data store:", verbose = verbose)
  if (verbose) {
    message()
    print(staged)
    message()
  }
  cli_info("Committing data changes.", verbose = verbose)
  tar_git_commit_all(message = message, repo = store)
  commit <- gert::git_commit_info(repo = store)$id
  cli_success(
    sprintf("Created new data snapshot %s.", commit),
    verbose = verbose
  )
  invisible()
}

# Covered in tests/interactive/test-tar_git_snapshot.R
# nocov start
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
