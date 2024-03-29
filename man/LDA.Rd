% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LDA.R
\name{LDA}
\alias{LDA}
\alias{as.LDA}
\alias{is.LDA}
\title{LDA Object}
\usage{
LDA(
  x,
  param,
  assignments,
  topics,
  document_sums,
  document_expects,
  log.likelihoods
)

as.LDA(
  x,
  param,
  assignments,
  topics,
  document_sums,
  document_expects,
  log.likelihoods
)

is.LDA(obj, verbose = FALSE)
}
\arguments{
\item{x}{[\code{named list}]\cr
Output from \code{\link[lda]{lda.collapsed.gibbs.sampler}}. Alternatively each
element can be passed for individual results. Individually set elements
overwrite elements from \code{x}.}

\item{param}{[\code{named list}]\cr
Parameters of the function call \code{\link[lda]{lda.collapsed.gibbs.sampler}}.
List always should contain names "K", "alpha", "eta" and "num.iterations".}

\item{assignments}{Individual element for LDA object.}

\item{topics}{Individual element for LDA object.}

\item{document_sums}{Individual element for LDA object.}

\item{document_expects}{Individual element for LDA object.}

\item{log.likelihoods}{Individual element for LDA object.}

\item{obj}{[\code{R} object]\cr
Object to test.}

\item{verbose}{[\code{logical(1)}]\cr
Should test information be given in the console?}
}
\value{
[\code{named list}] LDA object.
}
\description{
Constructor for LDA objects used in this package.
}
\details{
The functions \code{LDA} and \code{as.LDA} do exactly the same. If you call
\code{LDA} on an object \code{x} which already is of the structure of an
\code{LDA} object (in particular a \code{LDA} object itself),
the additional arguments \code{param, assignments, ...}
may be used to override the specific elements.
}
\examples{
res = LDARep(docs = reuters_docs, vocab = reuters_vocab, n = 1, K = 10)
lda = getLDA(res)

LDA(lda)
# does not change anything

LDA(lda, assignments = NULL)
# creates a new LDA object without the assignments element

LDA(param = getParam(lda), topics = getTopics(lda))
# creates a new LDA object with elements param and topics

}
\seealso{
Other constructor functions: 
\code{\link{as.LDABatch}()},
\code{\link{as.LDARep}()}

Other LDA functions: 
\code{\link{LDABatch}()},
\code{\link{LDARep}()},
\code{\link{getTopics}()}
}
\concept{LDA functions}
\concept{constructor functions}
