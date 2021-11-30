#' Plot better plots of smooth predictors in QGAMs
#'
#' @description \code{better_smooth_plot} creates a smooth plot with confidence intervals using \code{ggplot2}. It basically is a wrapper for the base \code{plot} function.
#'
#' @usage better_smooth_plot(
#'   qgam,
#'   quantile = NULL,
#'   pred,
#'   plot.old = FALSE,
#'   xlab = NULL,
#'   ylab = "fit",
#'   size = 0.5,
#'   fill = "steelblue2",
#'   color = "black",
#'   alpha = 1)
#'
#' @param qgam A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.
#' @param quantile If \code{qgam} is a collection of qgam models, specify the quantile you are interested in. Not meaningful for single qgam objects.
#' @param pred The smooth term you wish to plot. Must be one of the smooth terms given in the qgam formula.
#' @param smooth_term *obsolete*: Use \code{pred} instead.
#' @param plot.old Plot the original \code{plot} as well.
#' @param xlab The x-axis label.
#' @param ylab The y-axis label.
#' @param size Size argument for the ggplot object; specifies the size of the line.
#' @param fill Color argument for the ggplot object; specifies the color of the confidence interval.
#' @param color Color argument for the ggplot object; specifies the color of the line.
#' @param alpha Alpha argument for the ggplot object; specifies the transparency of the confidence interval.
#'
#' @return A ggplot object.
#'
#' @author D. Schmitz
#'
#' @references Fasiolo M., Goude Y., Nedellec R., & Wood S. N. (2017). Fast calibrated additive quantile regression. URL: https://arxiv.org/abs/1707.03307
#' @references Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.
#'
#' @examples
#'
#' # using a single qgam extracted from an mqgam object OR fitted with qgam::qgam
#' better_smooth_plot(qgam = mtqgam_qgam,
#'   pred = "numeric_2")
#'
#' # using a qgam that is part of an mqgam object
#' library(qgam)
#'
#' better_smooth_plot(qgam = mtqgam_mqgam,
#'   quantile = 0.5,
#'   pred = "numeric_2")
#'
#' # combining better_smooth_plot with ggplot2
#' better_smooth_plot(qgam = mtqgam_qgam,
#'   pred = "numeric_2") +
#'   theme_void() +
#'   labs(subtitle = "This is a subtitle")
#'
#' @export

better_smooth_plot <- function(qgam, quantile = NULL, pred, smooth_term = NULL, plot.old = F, xlab = NULL, ylab = "fit", size = 0.5, fill = "steelblue2", alpha = 1, color = "black"){

  require(ggplot2)

  # quantile argument not needed for single qgams
  if(length(qgam) >= 10 & !is.null(quantile)){
    cli::cli_alert_warning(glue::glue("The quantile argument is not meaningful for single QGAM objects. Plotting anyway."))
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

      # collection with correctly specified quantile
      qgam <- qgam::qdo(qgam, quantile)

    }

  }

  if(!is.null(smooth_term)){
    pred <- smooth_term
  }

  R.devices::suppressGraphics({
    bad_plot <- plot(qgam,
                     select=1)
  })

  smooth_terms <- data.frame(matrix(ncol = 1, nrow = 1))

  for(i in 1:length(bad_plot)){

    smooth_terms[i,1] <- bad_plot[[i]][["xlab"]]

  }

  number <- which(smooth_terms == pred, arr.ind=TRUE)[1]

  if(plot.old == T){
    bad_plot <- plot(qgam,
                     select=number)
  }

  if(is.na(number)){
    stop("Please specify a smooth which is part of your QGAM model.")
  }

  x <- bad_plot[[number]][["x"]]
  fit <- bad_plot[[number]][["fit"]]
  se <- bad_plot[[number]][["se"]]

  data <- as.data.frame(cbind(x, fit, se))

  data$se_top <- data$se + data$V2
  data$se_bot <- data$V2 - data$se

  xlabname <- pred
  ylabname <- ylab

  newplot <- ggplot2::ggplot(data = data) +
    geom_ribbon(aes(x = x, y = fit, ymin = se_bot, ymax = se_top), fill = fill, alpha = alpha) +
    geom_line(aes(x = x, y = fit), size = size, color = color) +
    geom_hline(yintercept = 0, color = "gray") +
    xlab(xlabname) +
    ylab(ylabname) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = "none")

  cli::cli_alert_info(glue::glue(paste("Plotting smooth term", paste(pred, ".", sep = ""))))

  return(newplot)

}
