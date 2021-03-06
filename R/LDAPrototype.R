#' @title Determine the Prototype LDA
#'
#' @description Performs multiple runs of LDA and computes the Prototype LDA of
#' this set of LDAs.
#'
#' @details While \code{LDAPrototype} marks the overall shortcut for performing
#' multiple LDA runs and choosing the Prototype of them, \code{\link{getPrototype}}
#' just hooks up at determining the Prototype. The generation of multiple LDAs
#' has to be done before use of \code{getPrototype}.
#'
#' To save memory a lot of interim calculations are discarded by default.
#'
#' If you use parallel computation, no progress bar is shown.
#'
#' For details see the details sections of the workflow functions at \code{\link{getPrototype}}.
#'
#' @family shortcut functions
#' @family PrototypeLDA functions
#' @family replication functions
#'
#' @inheritParams LDARep
#' @param vocabLDA [\code{character}]\cr
#' Vocabularies passed to \code{\link[lda]{lda.collapsed.gibbs.sampler}}.
#' For additional (and necessary) arguments passed, see ellipsis (three-dot argument).
#' @param vocabMerge [\code{character}]\cr
#' Vocabularies taken into consideration for merging topic matrices.
#' @param limit.rel [0,1]\cr
#' See \code{\link{jaccardTopics}}. Default is \code{1/500}.
#' @param limit.abs [\code{integer(1)}]\cr
#' See \code{\link{jaccardTopics}}. Default is \code{10}.
#' @param atLeast [\code{integer(1)}]\cr
#' See \code{\link{jaccardTopics}}. Default is \code{0}.
#' @param progress [\code{logical(1)}]\cr
#' Should a nice progress bar be shown for the steps of \code{\link{mergeTopics}}
#' and \code{\link{jaccardTopics}}? Turning it off, could lead to significantly
#' faster calculation. Default ist \code{TRUE}.
#' @param keepTopics [\code{logical(1)}]\cr
#' Should the merged topic matrix from \code{\link{mergeTopics}} be kept?
#' @param keepSims [\code{logical(1)}]\cr
#' Should the calculated topic similarities matrix from \code{\link{jaccardTopics}} be kept?
#' @param keepLDAs [\code{logical(1)}]\cr
#' Should the considered LDAs be kept?
#'
#' @inherit getPrototype return
#'
#' @examples
#' res = LDAPrototype(docs = reuters_docs, vocabLDA = reuters_vocab,
#'    n = 4, K = 10, num.iterations = 30)
#' res
#' getPrototype(res) # = getLDA(res)
#' getSCLOP(res)
#'
#' res = LDAPrototype(docs = reuters_docs, vocabLDA = reuters_vocab,
#'    n = 4, K = 10, num.iterations = 30, keepLDAs = TRUE)
#' res
#' getLDA(res, all = TRUE)
#' getPrototypeID(res)
#' getParam(res)
#'
#' @export LDAPrototype

LDAPrototype = function(docs, vocabLDA, vocabMerge = vocabLDA, n = 100, seeds,
  id = "LDARep", pm.backend, ncpus, limit.rel, limit.abs, atLeast, progress = TRUE,
  keepTopics = FALSE, keepSims = FALSE, keepLDAs = FALSE, ...){

  if (missing(seeds)) seeds = NULL
  if (missing(pm.backend)) pm.backend = NULL
  if (missing(ncpus)) ncpus = NULL
  if (missing(limit.rel)) limit.rel = .defaultLimit.rel()
  if (missing(limit.abs)) limit.abs = .defaultLimit.abs()
  if (missing(atLeast)) atLeast = .defaultAtLeast()

  x = LDARep(docs = docs, vocab = vocabLDA, n = n, seeds = seeds, id = id,
    pm.backend = pm.backend, ncpus = ncpus, ...)
  getPrototype(x = x, vocab = vocabMerge, limit.rel = limit.rel,
    limit.abs = limit.abs, atLeast = atLeast,
    progress = progress, pm.backend = pm.backend, ncpus = ncpus,
    keepTopics = keepTopics, keepSims = keepSims, keepLDAs = keepLDAs)
}
