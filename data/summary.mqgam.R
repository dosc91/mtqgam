#' Summary for a MQGAM fit
#'
#' @description Takes a fitted \code{mqgam} object produced by \code{qgam::mqgam} and produces various useful summaries from it, making use of
#' the \code{mgcv::summary.gam} method.
#'
#' @usage
#'
#' ## S3 method for class 'mqgam'
#' summary(mqgam)
#'
#' @param mqgam An mqgam object created with \code{qgam::mqgam}.
#'
#' @details Please see \link[mgcv]{summary.gam} for a detailed explanation of the summaries given.
#'
#' @return Please see \link[mgcv]{summary.gam} for a detailed explanation of the values given.
#'
#' @author D. Schmitz
#'
#' @references Fasiolo M., Goude Y., Nedellec R., & Wood S. N. (2017). Fast calibrated additive quantile regression. URL: https://arxiv.org/abs/1707.03307
#' @references Wood, S.N. (2011). Fast stable restricted maximum likelihood and marginal likelihood estimation of semiparametric generalized linear models. Journal of the Royal Statistical Society (B) 73(1), 3-36.
#'
#' @examples
#' # general usage
#' summary(mqgam = mtqgam_mqgam)
#'
#' # printing just one quantile summary
#' summary(mqgam = mtqgam_mqgam)[[3]]
#'
#' @export

summary.mqgam <- function(mqgam){

  quantile <- names(mqgam$fit)

  summary_list <- vector(mode = "list")

  for(i in 1:length(mqgam$fit)){

    summary_list[[i]] <- qgam::qdo(mqgam, qu = quantile[i], fun = summary)

  }

  names <- paste(paste("=========================", (paste("quantile", quantile))), "=========================")

  names(summary_list) <- names

  return(summary_list)

}
