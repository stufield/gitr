% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/git-pull-request.R
\name{pr}
\alias{pr}
\alias{get_pr_msgs}
\alias{get_pr_sha}
\title{Git PR Utilities}
\usage{
get_pr_msgs(branch = NULL)

get_pr_sha(branch = NULL)
}
\arguments{
\item{branch}{\code{character(1)}. The name of a branch, typically a
feature branch.}
}
\value{
\code{\link[=get_pr_msgs]{get_pr_msgs()}}: see \code{\link[=get_commit_msgs]{get_commit_msgs()}}.

\code{\link[=get_pr_sha]{get_pr_sha()}}: character vector of \code{sha}s
corresponding to the PR (relative to the default branch).
}
\description{
Git PR Utilities
}
\section{Functions}{
\itemize{
\item \code{get_pr_msgs()}: gets the commit messages for the \emph{current} branch
relative to the \verb{origin/\{main,master\}} branch in
the remote. Typically these "new" commits
that would be merged as part of a PR to \verb{origin/\{main,master\}}.

\item \code{get_pr_sha()}: gets the commit SHA1 \emph{current} branch relative to
the \code{default} branch in the remote, usually either
\code{origin/main} or \code{origin/master}. See \code{\link[=git_default_br]{git_default_br()}}.

}}
