#' @title Snapshot the data repository (Git).
#' @export
#' @family git
#' @description Snapshot the Git data repository of a `targets` project.
#' @description A Git-backed `gittargets` data snapshot is a special kind of
#'   Git commit. Every data commit gets its own branch,
#'   and the branch name is equal to the Git SHA1 hash
#'   of the current code commit.
#'   In addition, a special `.gittargets` file gets written
#'   to the data store so you can create a new snapshot even when the
#'   data working tree is clean.
#'   That way, when you switch branches or commits in the code,
#'   `tar_git_checkout()` can revert the data to match.
#'   Ideally, your targets should stay up to date even as you
#'   transition among multiple branches.
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
  message <- gert::git_commit_info(repo = code, ref = ref)$message
  # Covered in tests/interactive/test-tar_git_snapshot.R
  # nocov start
  if (status) {
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
    choice <- utils::menu(c("yes", "no"))
    if (!identical(as.integer(choice), 1L)) {
      cli_info("Snapshot skipped", verbose = verbose)
      return(invisible())
    }
  }
  # nocov end
  if (gert::git_branch_exists(branch = commit, repo = store)) {
    targets::tar_throw_validate(
      "Data snapshot already exists for code commit ",
      commit,
      ". To create a new data snapshot, please create a new code commit first."
    )
  }
  if (stash_gitignore) {
    gitignore <- git_stash_gitignore(repo = store)
    on.exit(git_unstash_gitignore(repo = store, stash = gitignore))
  }
  git_stub_write(repo = store)
  cli_info(sprintf("Creating data branch %s.", commit), verbose = verbose)
  gert::git_branch_create(branch = commit, checkout = TRUE, repo = store)
  cli_info("Staging data files.", verbose = verbose)
  gert::git_add(files = "*", repo = store)
  staged <- gert::git_status(staged = TRUE, repo = store)
  staged$staged <- NULL
  cli_info("Staged files in the data store:", verbose = verbose)
  if (verbose) {
    message()
    print(staged)
    message()
  }
  cli_info("Committing data changes.", verbose = verbose)
  commit <- gert::git_commit_all(message = message, repo = store)
  cli_success(
    sprintf("Created new data snapshot %s.", commit),
    verbose = verbose
  )
  invisible()
}
