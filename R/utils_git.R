tar_git_add <- function(files, repo, echo = TRUE, spinner = TRUE) {
  processx::run(
    command = "git",
    args = c("add", files),
    wd = repo,
    echo = echo,
    spinner = spinner
  )
}

tar_git_branch_checkout <- function(branch, repo, force) {
  args <- c("checkout", if_any(force, "--force", character(0)), branch)
  processx::run(command = "git", args = args, wd = repo)
}

tar_git_branch_create <- function(branch, repo) {
  processx::run(command = "git", args = c("branch", branch), wd = repo)
}

tar_git_commit <- function(message, repo, echo = TRUE, spinner = TRUE) {
  processx::run(
    command = "git",
    args = c("commit", "--message", message),
    wd = repo,
    echo = echo,
    spinner = spinner
  )
}

tar_git_commit_all <- function(message, repo, echo = TRUE, spinner = TRUE) {
  processx::run(
    command = "git",
    args = c("commit", "--all", "--message", message),
    wd = repo,
    echo = echo,
    spinner = spinner
  )
}

tar_git_init_repo <- function(path) {
  processx::run(command = "git", args = "init", wd = path)
}

tar_git_repo_exists <- function(repo) {
  file.exists(file.path(repo, ".git"))
}

tar_git_gitignore_stash <- function(repo) {
  from <- file.path(repo, ".gitignore")
  to <- file.path(repo, "gitignore_stash")
  if (file.exists(from)) {
    file.rename(from = from, to = to)
    writeLines(tar_git_gitignore_lines(), from)
  }
  invisible()
}

tar_git_gitignore_restore <- function(repo) {
  from <- file.path(repo, "gitignore_stash")
  to <- file.path(repo, ".gitignore")
  restore <- file.exists(from) &&
    !file.exists(to) &&
    identical(readLines(to), tar_git_gitignore_lines())
  if (restore) {
    file.rename(from = from, to = to)
  }
  invisible()
}

tar_git_gitignore_unstash <- function(repo) {
  from <- file.path(repo, "gitignore_stash")
  to <- file.path(repo, ".gitignore")
  if (file.exists(from)) {
    file.rename(from = from, to = to)
  }
  invisible()
}

tar_git_gitignore_lines <- function() {
  c(".gitignore", "gitignore_stash")
}

tar_git_stub_path <- function(repo) {
  file.path(repo, ".gittargets")
}

tar_git_stub_write <- function(repo) {
  path <- tar_git_stub_path(repo)
  uuid <- uuid::UUIDgenerate(use.time = NA, n = 1L)
  writeLines(uuid, path)
}
