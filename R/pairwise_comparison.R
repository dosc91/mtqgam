#' Pairwise Tukey Comparisons
#'
#' @description \code{pairwise_comparison} computes pairwise Tukey comparisons for any combination of variables in a given QGAM using
#' the \code{emmeans} package. Pairwise Tukey comparisons are most sensible to check differences between levels of a
#' categorical predictor.
#'
#' @usage pairwise_comparison(
#'   qgam,
#'   quantile = NULL,
#'   factor, by = NULL,
#'   ...)
#'
#' @param qgam A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.
#' @param quantile If \code{qgam} is a collection of qgam models, specify the quantile you are interested in. Not meaningful for single qgam objects.
#' @param factor The categorical variable you wish to compute Tukey comparisons for. Must be one of the predictor or smooth terms given in the qgam formula.
#'
#' @author D. Schmitz
#'
#' @references Russell V. Lenth (2021). emmeans: Estimated Marginal Means, aka Least-Squares Means. R package version 1.5.4. https://CRAN.R-project.org/package=emmeans
#'
#' @examples
#'
#' pairwise_comparison(qgam = mtqgam_mqgam, quantile = 0.5, "factor_1")
#'
#' @export

pairwise_comparison <- function(qgam, quantile = NULL, factor){

  if(length(factor) == 0){
    stop("Please specify a categorical variable which is part of your QGAM model.")
  }

  # quantile argument not needed for single qgams
  if(length(qgam) >= 10 & !is.null(quantile)){
    cli::cli_alert_warning(glue::glue("The quantile argument is not meaningful for single QGAM objects. Computing anyway."))
  }

  # collection but no quantile specified
  if(length(qgam) <= 10 & is.null(quantile)){
    stop("It appears your qgam argument is a collection of QGAMs created with qgam::mqgam, not a single QGAM. Please specify the quantile you are interested in.")
  }

  # collection given & quantile specified
  if(length(qgam) <= 10 & !is.null(quantile)){

    # collection with specified quantile but quantile not part of collection
    test <- which(names(qgam$fit) == quantile)

    if(length(test) == 0){

      stop("Please specify a quantile for which a QGAM model was fitted.")

    } else {

      # extract qgam
      wanted_qgam <- qgam::qdo(qgam, quantile)

    }

  }

  # create formula
  formula <- as.formula(paste("~", factor))

  # get estimated marginal means
  emm <- emmeans::emmeans(wanted_qgam, formula, type = "response")

  # get pairwise comparisons
  pairwise <- pairs(emm)

  print(pairwise)

}
