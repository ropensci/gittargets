git_repo_exists <- function(repo) {
  file.exists(file.path(repo, ".git"))
}

git_stash_gitignore <- function(repo) {
  path <- file.path(repo, ".gitignore")
  if (!file.exists(path)) {
    return(NULL)
  }
  dir <- tools::R_user_dir("gittargets", "cache")
  stash <- file.path(dir, paste0("gitignore_", basename(tempfile())))
  fs::dir_create(dirname(stash))
  fs::file_move(path = path, new_path = stash)
  stash
}

git_unstash_gitignore <- function(repo, stash) {
  if (is.null(stash)) {
    return()
  }
  new_path <- file.path(repo, ".gitignore")
  fs::file_move(path = stash, new_path = new_path)
}

git_stub_path <- function(repo) {
  file.path(repo, ".gittargets")
}

git_stub_write <- function(repo, lines) {
  path <- git_stub_path(repo)
  writeLines(lines, path)
}
