#' Extract t coordinates of time-normalized mouse-tracking data
#'
#' @description \code{extract_t} extracts the t coordinates, i.e. time values, from a time-normalized \code{mousetrap} object.
#'
#' @usage extract_t(
#'   tn_data,
#'   ID_column,
#'   timestamps,
#'   verbose = TRUE)
#'
#' @param tn_data The time-normalized mouse-tracking data. Can be extracted from the \code{mousetrap} object via \code{df$tn_trajectories}.
#' @param ID_column To maintain identification of individual trials, specify your ID variable. It must be part of \code{tn_data}. This can be achieved via \code{tn_data$ID <- df$data$ID}.
#' @param timestamps Specify the number of timestamps you have used for time-normalizing.
#' @param verbose If \code{true} (which is the default), a progress bar is displayed.
#'
#' @return A data frame.
#' \itemize{
#'   \item \code{key} - Numbered values per mouse-track ID.
#'   \item \code{value} - The time value.
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
#' # extract time-normalized data
#' tn_tracks <- as.data.frame(mt_data$tn_trajectories)
#'
#' # add ID columns
#' tn_tracks$ID <- mt_data$data$ID
#'
#' # use function
#' extract_t(tn_data = tn_tracks,
#' ID_column = tn_tracks$ID,
#' timestamps = 140)
#'
#' @export

extract_t <- function(tn_data, ID_column, timestamps, verbose = TRUE)
{

  if(verbose == TRUE){
    pb <- txtProgressBar(min = 0, max = length(rownames(tn_data)), style = 3)
  }

  t_coords <- data.frame(matrix(ncol = timestamps, nrow = 0))

  for(i in 1:length(rownames(tn_data))){

    if(verbose == TRUE){
      setTxtProgressBar(pb, i)
    }

    t_coords[i,1:timestamps] <- tn_data[i, (1):(timestamps)]

  }

  t_coords <- tidyr::gather(t_coords)

  id_collection <- data.frame(matrix(ncol = 1, nrow = 0))

  for(k in 1:length(rownames(tn_data))){

    id_collection[k, 1] <- ID_column[k]

  }

  IDs <- id_collection[,1]

  t_coords$ID <- IDs

  if(verbose == TRUE){
    close(pb)
  }

  return(t_coords)

}
