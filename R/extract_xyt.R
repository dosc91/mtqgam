#' Extract x, y, and t coordinates of time-normalized mouse-tracking data
#'
#' @description \code{extract_xyt} extracts the x, y, and t coordinates, i.e. time values, from a time-normalized \code{mousetrap} object. It basically is a wrap of the
#' \code{extract_x}, \code{extract_y}, and \code{extract_t} functions.
#'
#' @usage extract_xyt(
#'   tn_data,
#'   ID_column,
#'   timestamps,
#'   verbose = TRUE)
#'
#' @param mousetrap A \code{mousetrap} object containing time-normalized data (commonly achieved using mousetrap::mt_time_normalize).
#' @param tn_data *obsolete*: Specify \code{mousetrap} instead. For now, \code{tn_data} remains useable. It will be depricated in due time. \code{tn_data} is the time-normalized mouse-tracking data. Can be extracted from the \code{mousetrap} object via \code{df$tn_trajectories}.
#' @param ID_column To maintain identification of individual trials, specify your ID variable. In older versions, this had to be part of \code{tn_data}.
#' @param timestamps Specify the number of timestamps you have used for time-normalizing.
#' @param verbose If \code{TRUE} (which is the default), a progress bar is displayed.
#'
#' @return A data frame.
#' \itemize{
#'   \item \code{x_key} - Numbered x values per mouse-track ID.
#'   \item \code{x_value} - The x coordinate value.
#'   \item \code{y_key} - Numbered y values per mouse-track ID.
#'   \item \code{y_value} - The y coordinate value.
#'   \item \code{t_key} - Numbered t values per mouse-track ID.
#'   \item \code{t_value} - The time value.
#'   \item \code{ID} - Mouse-track IDs.
#' }
#'
#' @author D. Schmitz
#'
#' @references Kieslich, P. J., Henninger, F., Wulff, D. U., Haslbeck, J. M. B., & Schulte-Mecklenbeck, M. (2019). Mouse-tracking: A practical guide to
#' implementation and analysis. In M. Schulte-Mecklenbeck, A. Kühberger, & J. G. Johnson (Eds.), A Handbook of Process Tracing
#' Methods (pp. 111-130). New York, NY: Routledge.
#'
#' @examples
#' xyt_data <- extract_xyt(mousetrap = mtqgam_mousetrap,
#'   ID_column = "ID",
#'   timestamps = 100,
#'   verbose = FALSE)
#'
#' head(xyt_data)
#'
#' @export

extract_xyt <- function(mousetrap = NULL, tn_data = NULL, ID_column, timestamps, verbose = TRUE){

  x_coords <- extract_x(mousetrap = mousetrap, tn_data = tn_data, ID_column = ID_column, timestamps = timestamps, verbose = verbose)
  y_coords <- extract_y(mousetrap = mousetrap, tn_data = tn_data, ID_column = ID_column, timestamps = timestamps, verbose = verbose)
  t_coords <- extract_t(mousetrap = mousetrap, tn_data = tn_data, ID_column = ID_column, timestamps = timestamps, verbose = verbose)

  xyt <- cbind(x_coords, y_coords, t_coords)

  xyt <- xyt[ -c(3, 6) ]

  names(xyt)[1] <- "x_key"
  names(xyt)[2] <- "x_value"
  names(xyt)[3] <- "y_key"
  names(xyt)[4] <- "y_value"
  names(xyt)[5] <- "t_key"
  names(xyt)[6] <- "t_value"

  return(xyt)
}
