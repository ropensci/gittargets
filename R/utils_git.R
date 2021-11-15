tar_git_add <- function(files, repo, verbose = TRUE) {
  processx::run(
    command = "git",
    args = c("add", files),
    wd = repo,
    echo = verbose,
    spinner = verbose
  )
}

tar_git_commit <- function(message, repo, verbose = TRUE) {
  
}

tar_git_repo_exists <- function(repo) {
  file.exists(file.path(repo, ".git"))
}

tar_git_stash_gitignore <- function(repo) {
  path <- file.path(repo, ".gitignore")
  if (!file.exists(path)) {
    return(NULL)
  }
  dir <- tools::R_user_dir(package = "gittargets", which = "cache")
  uuid <- uuid::UUIDgenerate(use.time = NA, n = 1L)
  stash <- file.path(dir, paste0("gitignore_", uuid))
  fs::dir_create(dirname(stash))
  fs::file_move(path = path, new_path = stash)
  stash
}

tar_git_unstash_gitignore <- function(repo, stash) {
  if (is.null(stash)) {
    return()
  }
  new_path <- file.path(repo, ".gitignore")
  fs::file_move(path = stash, new_path = new_path)
}

tar_git_stub_path <- function(repo) {
  file.path(repo, ".gittargets")
}

tar_git_stub_write <- function(repo) {
  path <- tar_git_stub_path(repo)
  uuid <- uuid::UUIDgenerate(use.time = NA, n = 1L)
  writeLines(uuid, path)
}
