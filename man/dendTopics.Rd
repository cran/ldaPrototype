% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dendTopics.R
\name{dendTopics}
\alias{dendTopics}
\alias{plot.TopicDendrogram}
\title{Topic Dendrogram}
\usage{
dendTopics(sims, ind, method = "complete")

\method{plot}{TopicDendrogram}(x, pruning, pruning.par, ...)
}
\arguments{
\item{sims}{[\code{\link[=jaccardTopics]{TopicSimilarity}} object
or \code{lower triangular named matrix}]\cr
\code{\link[=jaccardTopics]{TopicSimilarity}} object or
pairwise jaccard similarities of underlying topics as the \code{sims} element
from \code{\link[=jaccardTopics]{TopicSimilarity}} objects. The topic names should be
formatted as <\emph{Run X}>.<\emph{Topic Y}>, so that the name before the
first dot identifies the LDA run.}

\item{ind}{[\code{integer}, \code{logical} or \code{character}]\cr
An integerish vector (or logical of the same length as the number of rows and columns)
for specifying the topics taken into account. Alternatively
a character vector can be passed. Then, all topics are taken for which the name
contain at least one of the phrases in \code{ind} (see \code{\link[=grep]{grepl}}).
By default all topics are considered.}

\item{method}{[\code{character(1)}]\cr
The agglomeration method. See \code{\link[stats]{hclust}}.}

\item{x}{an R object.}

\item{pruning}{[\code{list of \link[stats]{dendrogram}s}]\cr
\code{\link[=pruneSCLOP]{PruningSCLOP}} object specifying the best possible
local pruning state.}

\item{pruning.par}{[\code{list}]\cr
List of parameters to mark the pruning. See section "Details" at \code{\link{dendTopics}}
for default parameters. Types for marking the pruning state are \code{"abline"},
\code{"color"} and \code{"both"}.}

\item{...}{additional arguments.}
}
\value{
[\code{\link[stats]{dendrogram}}] \code{\link[=dendTopics]{TopicDendrogram}} object
(and \code{\link[stats]{dendrogram}} object) of all considered topics.
}
\description{
Builds a dendrogram for topics based on their pairwise similarities using the
cluster algorithm \code{\link[stats]{hclust}}.
}
\details{
The label´s colors are determined based on their Run belonging using
\code{\link[colorspace]{rainbow_hcl}} by default. Colors can be manipulated
using \code{\link[dendextend]{labels_colors}}. Analogously, the labels
themself can be  manipulated using \code{\link[dendextend:labels.hclust]{labels}}.
For both the function \code{\link[stats]{order.dendrogram}} is useful.

The resulting \code{\link[stats]{dendrogram}} can be plotted. In addition,
it is possible to mark a pruning state in the plot, either by color or by
separator lines (or both) setting \code{pruning.par}. For the default values
of \code{pruning.par} call the corresponding function on any
\code{\link[=pruneSCLOP]{PruningSCLOP}} object.
}
\examples{
res = LDARep(docs = reuters_docs, vocab = reuters_vocab, n = 4, K = 10, num.iterations = 30)
topics = mergeTopics(res, vocab = reuters_vocab)
jacc = jaccardTopics(topics, atLeast = 2)
sim = getSimilarity(jacc)

dend = dendTopics(jacc)
dend2 = dendTopics(sim)

\donttest{
plot(dend)
plot(dendTopics(jacc, ind = c("Rep2", "Rep3")))
}

pruned = pruneSCLOP(dend)
\donttest{
plot(dend, pruning = pruned)
plot(dend, pruning = pruned, pruning.par = list(type = "color"))
plot(dend, pruning = pruned, pruning.par = list(type = "both", lty = 1, lwd = 2, col = "red"))

dend2 = dendTopics(jacc, ind = c("Rep2", "Rep3"))
plot(dend2, pruning = pruneSCLOP(dend2), pruning.par = list(lwd = 2, col = "darkgrey"))
}

}
\seealso{
Other plot functions: 
\code{\link{pruneSCLOP}()}

Other TopicSimilarity functions: 
\code{\link{cosineTopics}()},
\code{\link{getSimilarity}()},
\code{\link{jaccardTopics}()},
\code{\link{jsTopics}()},
\code{\link{rboTopics}()}

Other workflow functions: 
\code{\link{LDARep}()},
\code{\link{SCLOP}()},
\code{\link{getPrototype}()},
\code{\link{jaccardTopics}()},
\code{\link{mergeTopics}()}
}
\concept{TopicSimilarity functions}
\concept{plot functions}
\concept{workflow functions}
