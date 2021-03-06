.makeProgressBar = function(progress, ...) {
  if (progress && getOption("width") >= 20L){
    progress_bar$new(...)
  }else{
    list(tick = function(len = 1, tokens = list()) NULL, update = function(ratio, tokens) NULL)
  }
}

.paramList = function(n, ...){
  moreArgs = list(...)
  if(anyDuplicated(names(moreArgs))){
    tmp = duplicated(names(moreArgs), fromLast = TRUE)
    warning("Parameter(s) ", paste0(names(moreArgs)[tmp], collapse = ", "), " are duplicated. Take last one(s).")
    moreArgs = moreArgs[!tmp]
  }
  if ("K" %in% names(moreArgs)){
    default = .getDefaultParameters(K = moreArgs$K)
  }else{
    default = .getDefaultParameters()
  }
  moreArgs = c(moreArgs, default[!names(default) %in% names(moreArgs)])
  moreArgs[lengths(moreArgs) != n] = lapply(moreArgs[lengths(moreArgs) != n], rep_len, length.out = n)
  return(moreArgs)
}
