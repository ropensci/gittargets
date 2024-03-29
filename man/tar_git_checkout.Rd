% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tar_git_checkout.R
\name{tar_git_checkout}
\alias{tar_git_checkout}
\title{Check out a snapshot of the data (Git)}
\usage{
tar_git_checkout(
  ref = "HEAD",
  code = getwd(),
  store = targets::tar_config_get("store"),
  force = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{ref}{Character of length 1. SHA1 hash, branch name,
or other reference in the code repository
that points to a code commit. (You can also identify the code
commit by supplying a data branch of the form \verb{code=<SHA1>}.)
Defaults to \code{"HEAD"}, which points to the currently
checked out code commit.

Once the desired code commit is identified,
\code{tar_git_snapshot()} checks out the latest corresponding data snapshot.
There may be earlier data snapshots corresponding to this code commit,
but \code{tar_git_snapshot()} only checks out the latest one.
To check out an earlier superseded data snapshot,
you will need to manually use command line Git in the data repository.

If \code{tar_git_snapshot()} cannot find a data snapshot for the
desired code commit, then it will throw an error.
For a list of commits in the current code branch
that have available data snapshots, see the \code{commit_code}
column of the output of \code{\link[=tar_git_log]{tar_git_log()}}.}

\item{code}{Character of length 1, directory path to the code repository,
usually the root of the \code{targets} project.}

\item{store}{Character of length 1, path to the data store of the pipeline.
If \code{NULL}, the \code{store} setting is left unchanged in the
YAML configuration file (default: \verb{_targets.yaml}).
Usually, the data store lives at \verb{_targets}.
Set \code{store} to a custom directory
to specify a path other than \verb{_targets/}. The path need not exist
before the pipeline begins, and it need not end with "_targets",
but it must be writeable.
For optimal performance, choose a storage location
with fast read/write access.
If the argument \code{NULL}, the setting is not modified.
Use \code{\link[targets:tar_config_unset]{tar_config_unset()}} to delete a setting.}

\item{force}{ignore conflicts and overwrite modified files}

\item{verbose}{Logical of length 1, whether to print R console messages
confirming that a snapshot was created.}
}
\value{
Nothing (invisibly).
}
\description{
Check out a snapshot of the data associated with
a particular code commit (default: \code{HEAD}).
}
\examples{
if (Sys.getenv("TAR_EXAMPLES") == "true" && tar_git_ok(verbose = FALSE)) {
targets::tar_dir({ # Containing code does not modify the user's filespace.
# Work on an initial branch.
targets::tar_script(tar_target(data, "old_data"))
targets::tar_make()
targets::tar_read(data) # "old_data"
gert::git_init()
gert::git_add("_targets.R")
gert::git_commit("First commit")
gert::git_branch_create("old_branch")
tar_git_init()
# Work on a new branch.
tar_git_snapshot(status = FALSE, verbose = FALSE)
targets::tar_script(tar_target(data, "new_data"))
targets::tar_make()
targets::tar_read(data) # "new_data"
gert::git_branch_create("new_branch")
gert::git_add("_targets.R")
gert::git_commit("Second commit")
tar_git_snapshot(status = FALSE, verbose = FALSE)
# Go back to the old branch.
gert::git_branch_checkout("old_branch")
# The target is out of date because we only reverted the code.
targets::tar_outdated()
# But tar_git_checkout() lets us restore the old version of the data!
tar_git_checkout()
targets::tar_read(data) # "old_data"
# Now, the target is up to date! And we did not even have to rerun it!
targets::tar_outdated()
})
}
}
\seealso{
Other git: 
\code{\link{tar_git_init}()},
\code{\link{tar_git_log}()},
\code{\link{tar_git_ok}()},
\code{\link{tar_git_snapshot}()},
\code{\link{tar_git_status_code}()},
\code{\link{tar_git_status_data}()},
\code{\link{tar_git_status_targets}()},
\code{\link{tar_git_status}()}
}
\concept{git}
