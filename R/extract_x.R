#' Extract x coordinates of time-normalized mouse-tracking data
#'
#' @description \code{extract_x} extracts the x coordinates from a time-normalized \code{mousetrap} object.
#'
#' @usage extract_x(
#'   mousetrap,
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
#'   \item \code{key} - Numbered coordinates per mouse-track ID.
#'   \item \code{value} - The x coordinate value.
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
#' x_data <- extract_x(mousetrap = mtqgam_mousetrap,
#'   ID_column = "ID",
#'   timestamps = 100,
#'   verbose = FALSE)
#'
#' head(x_data)
#'
#' @export

extract_x <- function(mousetrap = NULL, tn_data = NULL, ID_column, timestamps, verbose = TRUE)
{

  # old version
  if(!is.null(tn_data)){

    if(verbose == TRUE){
      pb <- txtProgressBar(min = 0, max = length(rownames(tn_data)), style = 3)
    }

    x_coords <- data.frame(matrix(ncol = timestamps, nrow = 0))

    for(i in 1:length(rownames(tn_data))){

      if(verbose == TRUE){
        setTxtProgressBar(pb, i)
      }

      x_coords[i,1:timestamps] <- tn_data[i, (timestamps+1):(timestamps*2)]

    }

    x_coords <- tidyr::gather(x_coords)

    id_collection <- data.frame(matrix(ncol = 1, nrow = 0))

    for(k in 1:length(rownames(tn_data))){

      id_collection[k, 1] <- ID_column[k]

    }

    IDs <- id_collection[,1]

    x_coords$ID <- IDs
  }

  # new version
  if(!is.null(mousetrap)){

    tn_data <- as.data.frame(mousetrap$tn_trajectories)

    if(verbose == TRUE){
      pb <- txtProgressBar(min = 0, max = length(rownames(tn_data)), style = 3)
    }

    x_coords <- data.frame(matrix(ncol = timestamps, nrow = 0))

    for(i in 1:length(rownames(tn_data))){

      if(verbose == TRUE){
        setTxtProgressBar(pb, i)
      }

      x_coords[i,1:timestamps] <- tn_data[i, (timestamps+1):(timestamps*2)]

    }

    x_coords <- tidyr::gather(x_coords)

    id_collection <- data.frame(matrix(ncol = 1, nrow = 0))

    id_collection <- mousetrap$data[, ID_column]

    x_coords$ID <- id_collection

  }


  if(verbose == TRUE){
    close(pb)
  }

  return(x_coords)

}
