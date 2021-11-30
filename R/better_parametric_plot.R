#' Plot better plots of parametric predictors in QGAMs
#'
#' @description \code{better_parametric_plot} creates a point plot with confidence interval ranges using \code{ggplot2}. It basically is a wrapper for \code{itsadug}'s
#' \code{plot_parametric} function.
#'
#' @usage better_parametric_plot(
#'   qgam,
#'   quantile = NULL,
#'   pred,
#'   cond = NULL,
#'   print.summary = FALSE,
#'   plot.old = FALSE,
#'   order = NULL,
#'   xlab = "fit",
#'   ylab = NULL,
#'   size = 0.5,
#'   color = NULL,
#'   alpha = 1)
#'
#' @param qgam A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.
#' @param quantile If \code{qgam} is a collection of qgam models, specify the quantile you are interested in. Not meaningful for single qgam objects.
#' @param pred The predictor term to plot. Note: This is no longer identical to the \code{pred} argument specified for \code{itsadug::plot_parametric}.
#' @param cond A named list of the values to use for the other predictor terms (not in view). Used for choosing between smooths that share the same view predictors.
#' @param print.summary Logical: whether or not to print summary.
#' @param plot.old Plot the original \code{plot_parametric} as well.
#' @param order Specify the order with which the levels given in \code{pred} should be plotted.
#' @param xlab The x-axis label.
#' @param ylab The y-axis label.
#' @param size Size argument for the ggplot object; specifies the size of points and lines.
#' @param color Color argument for the ggplot object; specifies the color of points and lines.
#' @param alpha Alpha argument for the ggplot object; specifies the transparency of points and lines.
#'
#' @return A ggplot object.
#'
#' @author D. Schmitz
#'
#' @references Fasiolo M., Goude Y., Nedellec R., & Wood S. N. (2017). Fast calibrated additive quantile regression. URL: https://arxiv.org/abs/1707.03307
#' @references van Rij J, Wieling M, Baayen R, & van Rijn H (2020). itsadug: Interpreting Time Series and Autocorrelated Data Using GAMMs. R package version 2.4.
#' @references Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.
#'
#' @examples
#'
#' # using a single qgam extracted from an mqgam object OR fitted with qgam::qgam
#' better_parametric_plot(qgam = mtqgam_qgam,
#'   pred = "factor_3")
#'
#' # using a qgam that is part of an mqgam object
#' library(qgam)
#'
#' better_parametric_plot(qgam = mtqgam_mqgam,
#'   quantile = 0.5,
#'   pred = "factor_3")
#'
#' # combining better_parametric_plot with ggplot2
#' better_parametric_plot(qgam = mtqgam_qgam,
#'   pred = "factor_3") +
#'   theme_void() +
#'   labs(subtitle = "This is a subtitle")
#'
#' @export

better_parametric_plot <- function(qgam, quantile = NULL, pred, cond = NULL, print.summary = F, plot.old = F, order = NULL, xlab = "fit", ylab = NULL, size = 0.5, color = NULL, alpha = 1){

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

  number <- which(names(qgam$var.summary) == pred)

  pred_list <- c(qgam$var.summary[number])

  if(length(pred_list) == 0){

    stop("Please specify a parametric predictor which is part of your QGAM model.")

  }

  factor <- pred_list[[1]]

  character <- as.character(levels(factor))

  pred_list[[1]] <- character

  names(pred_list) <- paste(pred)

  if(plot.old == T){

    parametric_plot <- itsadug::plot_parametric(qgam, pred=pred_list, cond=cond, print.summary=print.summary)

  } else {

    R.devices::suppressGraphics({

      parametric_plot <- itsadug::plot_parametric(qgam, pred=pred_list, cond=cond, print.summary=print.summary)

    })}

  fit <- parametric_plot$fv$fit

  CI <- parametric_plot$fv$CI

  levels <- unlist(pred_list)

  data <- as.data.frame(cbind(fit, CI, levels))

  data$fit <- as.numeric(data$fit)

  data$CI <- as.numeric(data$CI)

  data$levels <- as.factor(data$levels)

  name <- names(pred_list)

  if(is.null(order)){

    data <- data

  } else if (!is.null(order)){

    data$levels <- factor(data$levels, levels = order)

  }

  if(is.null(color)){

    color <- c(rep("black", length(data$levels)))

  } else if (!is.null(color)){

    color <- color

  }

  newplot <- ggplot2::ggplot(data = data) +
    geom_pointrange(aes(x = fit, y = levels, xmin = fit - CI, xmax = fit + CI), size = size, color = color, alpha = alpha) +
    labs(title = name) +
    xlab(xlab) +
    ylab(ylab) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "none")

  if(is.null(order)){
    cli::cli_alert_info(glue::glue(paste("Plotting predictor", paste(pred, "with default order of predictor levels.", sep = " "))))
  } else if (!is.null(order)){
    cli::cli_alert_info(glue::glue(paste("Plotting predictor", paste(pred, "with specified order of predictor levels.", sep = " "))))
  }

  return(newplot)
}
