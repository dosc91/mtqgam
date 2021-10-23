#' Extract y coordinates of time-normalized mouse-tracking data
#'
#' @description \code{extract_y} extracts the y coordinates from a time-normalized \code{mousetrap} object.
#'
#' @usage extract_x(
#'   tn_data,
#'   ID_column,
#'   timestamps)
#'
#' @param tn_data The time-normalized mouse-tracking data. Can be extracted from the \code{mousetrap} object via \code{df$tn_trajectories}.
#' @param ID_column To maintain identification of individual trials, specify your ID variable. It must be part of \code{tn_data}. This can be achieved via \code{tn_data$ID <- df$data$ID}.
#' @param timestamps Specify the number of timestamps you have used for time-normalizing.
#'
#' @return A data frame.
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
#' extract_y(tn_data = tn_tracks,
#' ID_column = tn_tracks$ID,
#' timestamps = 138)
#'
#' @export

extract_y <- function(tn_data, ID_column, timestamps)
{

  y_coords <- data.frame(matrix(ncol = timestamps, nrow = 0))

  for(i in 1:length(rownames(tn_data))){

    y_coords[i,1:timestamps] <- tn_tracks[i, (2*timestamps+1):(timestamps*3)]

  }

  y_coords <- tidyr::gather(y_coords)

  test <- data.frame(matrix(ncol = 1, nrow = 0))

  for(k in 1:length(rownames(tn_data))){

    test[k, 1] <- ID_column[k]

  }

  IDs <- test[,1]

  y_coords$ID <- IDs

  y_coords$key <- gsub("X", "Y", y_coords$key)

  return(y_coords)

}