git_setup_init <- function() {
  stopifnot(identical(Sys.getenv("TAR_TEST"), "true"))
  targets::tar_script(targets::tar_target(x, 1))
  targets::tar_make(callr_function = NULL)
  gert::git_init()
  gert::git_add("_targets.R")
  gert::git_commit("First commit")
  tar_git_init()
}
