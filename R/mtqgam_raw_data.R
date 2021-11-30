#' Example data to create QGAMs with
#'
#' A dataset containing simulated data to create \code{qgam::qgam} and \code{qgam::mqgam} objects with.
#'
#' @format A data frame with 5000 rows and 6 variables:
#' \describe{
#'   \item{dependent}{a numeric variable of random values; used as dependent variable}
#'   \item{numeric_1}{a numeric variable of random values}
#'   \item{numeric_2}{a numeric variable of random values}
#'   \item{factor_1}{a factor variable with 4 levels}
#'   \item{factor_2}{a factor variable with 5 levels}
#'   \item{factor_3}{a factor variable with 2 levels}
#' }
#' @source Schmitz, Dominic (2021). mtqgam: Mouse-Tracking Data in QGAMs. \url{https://github.com/dosc91/mtqgam}
"mtqgam_raw_data"
