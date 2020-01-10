#' @title LDA Replications
#'
#' @description
#' Performs multiple runs of Latent Dirichlet Allocation.
#'
#' @details The function generates multiple LDA runs with the possability of
#' using parallelization. The integration is done by the
#' \code{\link[parallelMap:parallelMap]{parallelMap-package}}.
#'
#' The function returns a \code{LDARep} object. You can receive results and
#' all other elements of this object with getter functions (see \code{\link{getJob}}).
#'
#' @family replication functions
#' @family LDA functions
#' @family workflow functions
#'
#' @param docs [\code{list}]\cr
#' Documents as received from \code{\link[tosca]{LDAprep}}.
#' @param vocab [\code{character}]\cr
#' Vocabularies passed to \code{\link[lda]{lda.collapsed.gibbs.sampler}}.
#' @param n [\code{integer(1)}]\cr
#' Number of Replications.
#' @param seeds [\code{integer(n)}]\cr
#' Random Seeds for each Replication.
#' @param id [\code{character(1)}]\cr
#' Name for the computation.
#' @param pm.backend [\code{character(1)}]\cr
#' One of "multicore", "socket" or "mpi".
#' If \code{pm.backend} is set, \code{\link[parallelMap]{parallelStart}} is
#' called before computation is started and \code{\link[parallelMap]{parallelStop}}
#' is called after.
#' @param ncpus [\code{integer(1)}]\cr
#' Number of (physical) CPUs to use. If \code{pm.backend} is passes,
#' default is determined by \code{\link[future]{availableCores}}.
#' @param ... additional arguments passed to \code{\link[lda]{lda.collapsed.gibbs.sampler}}.
#' Arguments will be coerced to a vector of length \code{n}.
#' @return [\code{named list}] with entries \code{id} for computation's name,
#' \code{jobs} for the parameter settings and \code{lda} for the results itself.
#'
#' @examples
#' res = LDARep(docs = reuters_docs, vocab = reuters_vocab, n = 4, seeds = 1:4,
#'    id = "myComputation", K = 7:10, alpha = 1, eta = 0.01, num.iterations = 20)
#' res
#' getJob(res)
#' getID(res)
#' getLDA(res, 4)
#'
#' \donttest{
#' LDARep(docs = reuters_docs, vocab = reuters_vocab,
#'    K = 10, num.iterations = 100, pm.backend = "socket")
#' }
#'
#' @export LDARep

LDARep = function(docs, vocab, n = 100, seeds, id = "LDARep", pm.backend, ncpus, ...){

  args = .paramList(n = n, ...)
  if (missing(seeds) || length(seeds) != n){
    message("No seeds given or length of given seeds differs from number of replications: sample seeds")
    if (!exists(".Random.seed", envir = globalenv())){
      runif(1)
    }
    oldseed = .Random.seed
    seeds = sample(9999999, n)
    .Random.seed <<- oldseed
  }
  if (anyDuplicated(seeds)){
    message(sum(duplicated(seeds)), " duplicated seeds.")
  }
  args$seed = seeds
  args$fun = function(seed, ...){
    set.seed(seed)
    LDA(lda.collapsed.gibbs.sampler(documents = docs, vocab = vocab, ...),
      param = list(...))
  }

  if (!missing(pm.backend) && !is.null(pm.backend)){
    if (missing(ncpus) || is.null(ncpus)) ncpus = future::availableCores()
    parallelMap::parallelStart(mode = pm.backend, cpus = ncpus)
  }

  parallelMap::parallelExport("docs", "vocab")
  ldas = do.call(parallelMap::parallelMap, args = args)
  if (!missing(pm.backend) && !is.null(pm.backend)) parallelMap::parallelStop()
  job.id = seq_len(n)
  args = data.table(job.id = job.id,
    do.call(cbind, args[names(args) != "fun"]))
  names(ldas) = job.id

  res = list(id = id, lda = ldas, jobs = args)
  class(res) = "LDARep"
  res
}

#' @export
print.LDARep = function(x, ...){
  jobs = getJob(x)
  parameters = unique(jobs[, !colnames(jobs) %in% c("job.id", "seed"), with = FALSE])
  if (nrow(parameters) == 1){
    parameters = paste0("parameters ",
      paste0(paste0(colnames(parameters), ": ", as.character(round(parameters, 4))), collapse = ", "))
  }else{
    parameters = paste0(nrow(parameters), " different parameter sets.")
  }
  cat(
    "LDARep Object \"", getID(x), "\"\n ",
    nrow(jobs), " LDA Runs", "\n ",
    "with ", parameters, "\n\n",
    sep = ""
  )
}