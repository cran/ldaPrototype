% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mergeBatchTopics.R
\name{mergeBatchTopics}
\alias{mergeBatchTopics}
\alias{mergeBatchTopics.LDABatch}
\alias{mergeBatchTopics.default}
\title{Merge LDA Topic Matrices}
\usage{
mergeBatchTopics(...)

\method{mergeBatchTopics}{LDABatch}(x, vocab, progress = TRUE, ...)

\method{mergeBatchTopics}{default}(vocab, reg, job, id, progress = TRUE, ...)
}
\arguments{
\item{...}{additional arguments}

\item{x}{[\code{named list}]\cr
\code{\link{LDABatch}} object. Alternatively \code{job}, \code{reg} and
\code{id} can be passed or their defaults are taken.}

\item{vocab}{[\code{character}]\cr
Vocabularies taken into consideration for merging topic matrices. Default is
the vocabulary of the first LDA.}

\item{progress}{[\code{logical(1)}]\cr
Should a nice progress bar be shown? Turning it off, could lead to significantly
faster calculation. Default ist \code{TRUE}.}

\item{reg}{[\code{\link[batchtools:makeRegistry]{Registry}}]\cr
Registry. See \code{\link[batchtools]{reduceResultsList}}.}

\item{job}{[\code{\link{data.frame}} or \code{integer}]\cr
A data.frame or data.table with a column named "job.id" or a vector of integerish job ids.
See \code{\link[batchtools]{reduceResultsList}}.}

\item{id}{[\code{character(1)}]\cr
A name for the registry. If not passed, the folder's name is extracted from \code{reg}.}
}
\value{
[\code{named matrix}] with the count of vocabularies (row wise) in topics (column wise).
}
\description{
Collects LDA results from a given registry and merges their topic matrices for
a given set of vocabularies.
}
\details{
For details and examples see \code{\link{mergeTopics}}.
}
\seealso{
Other merge functions: 
\code{\link{mergeRepTopics}()},
\code{\link{mergeTopics}()}

Other batch functions: 
\code{\link{LDABatch}()},
\code{\link{as.LDABatch}()},
\code{\link{getJob}()}
}
\concept{batch functions}
\concept{merge functions}
