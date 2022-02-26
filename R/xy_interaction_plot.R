#' Plot XY plots of parametric predictor interactions in QGAMs
#'
#' @description \code{xy_interaction_plot} creates a point plot with confidence interval ranges using \code{ggplot2}. It combines the model estimates for the same predictor
#' in two (sets of) QGAMs, i.e. it displays estimates of X and Y coordinates simultaneously in a combined plot.
#' It makes use of \code{mtqgam}'s \code{better_parametric_plot} and thus outputs the same information in your console.
#'
#' @usage xy_interaction_plot(
#'   qgam_x,
#'   qgam_y,
#'   quantile = NULL,
#'   pred,
#'   cond = NULL,
#'   print.summary = FALSE,
#'   order = NULL,
#'   ncol = 2,
#'   xlab = "X coordinates",
#'   ylab = "Y coordinates",
#'   scales = "free",
#'   size = 3,
#'   color = NULL,
#'   alpha = 1)
#'
#' @param qgam_x The estimates plotted on the X axis. A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.
#' @param qgam_y The estimates plotted on the Y axis. A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.
#' @param quantile If \code{qgam} is a collection of qgam models, specify the quantile you are interested in. Not meaningful for single qgam objects.
#' @param pred The predictor term to plot. Note: This is no longer identical to the \code{pred} argument specified for \code{itsadug::plot_parametric}.
#' @param cond A named list of the values to use for the other predictor terms (not in view). Used for choosing between smooths that share the same view predictors.
#' @param print.summary Logical: whether or not to print summary.
#' @param order Specify the order with which the levels given in \code{pred} should be plotted.
#' @param ncol The number of columns of the multi-panel plot.
#' @param xlab The x-axis label.
#' @param ylab The y-axis label.
#' @param scales Should scales be free (\code{"free"}, the default) or fixed (\code{"fixed"})?
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
#' xy_interaction_plot(qgam_x = mtqgam_qgam,
#' qgam_y = mtqgam_qgam,
#' pred = "factor_2",
#' cond = "factor_3")
#'
#' # using a qgam that is part of an mqgam object
#' xy_interaction_plot(qgam_x = mtqgam_mqgam,
#' qgam_y = mtqgam_mqgam,
#' pred = "factor_2",
#' cond = "factor_3")
#'
#' # specifying color
#' xy_interaction_plot(qgam_x = mtqgam_mqgam,
#' qgam_y = mtqgam_mqgam,
#' pred = "factor_2",
#' cond = "factor_3",
#' color = c("blue", "purple", "green", "yellow", "pink"))
#'
#' # combining better_interaction_plot with ggplot2
#' xy_interaction_plot(qgam_x = mtqgam_mqgam,
#' qgam_y = mtqgam_mqgam,
#' pred = "factor_2",
#' cond = "factor_3") +
#' theme_void() +
#' labs(subtitle = "This is a subtitle")
#'
#' @export

xy_interaction_plot <- function(qgam_x, qgam_y, quantile = NULL, pred, cond = NULL, print.summary = F, order = NULL, ncol = 2, xlab = "X coordinates", ylab = "Y coordinates", scales = "free", size = 3, color = NULL, alpha = 1){

  require(ggplot2)

  # check QGAM objects

  # mqgams do not match in length
  if(length(qgam_x) != length(qgam_y)){
    cli::cli_alert_warning(glue::glue("qgam_x and qgam_y do not match in their length. Please use objects of identical length."))
  }

  # quantile argument not needed for single qgams
  if(length(qgam_x) >= 10 & !is.null(quantile)){
    cli::cli_alert_warning(glue::glue("The quantile argument is not meaningful for single QGAM objects. Plotting anyway."))
  }

  # collection but no quantile specified
  if(length(qgam_x) <= 10 & is.null(quantile)){
    cli::cli_alert_warning(glue::glue("Plotting all quantiles."))
  }

  # collection given & quantile specified
  if(length(qgam_x) <= 10 & !is.null(quantile)){

    # collection with specified quantile but quantile not part of collection
    test <- which(names(qgam_x$fit) == quantile)

    if(length(test) == 0){

      stop("Please specify a quantile for which a QGAM model was fitted.")

    } else {

      # collection with correctly specified quantile
      qgam_x <- qgam::qdo(qgam_x, quantile)
      qgam_y <- qgam::qdo(qgam_y, quantile)

      cli::cli_alert_warning(glue::glue("Plotting specified quantile."))

    }

  }

  # data

  # if mqgam
  if(length(qgam_x) <= 10){

    quantiles <- names(qgam_x[["fit"]])

    # X
    data_list_x <- vector(mode = "list")

    for (i in 1:length(quantiles)) {

      R.devices::suppressGraphics({

        datax <- better_interaction_plot(qgam_x, pred = pred, cond = cond, quantile = quantiles[i])$data

      })

      datax$quantile <- quantiles[i]

      data_list_x[[i]] <- datax

    }

    xdata <- do.call(rbind, data_list_x)

    # Y
    data_list_y <- vector(mode = "list")

    for (i in 1:length(quantiles)) {

      R.devices::suppressGraphics({

        datay <- better_interaction_plot(qgam_y, pred = pred, cond = cond, quantile = quantiles[i])$data

      })

      datay$quantile <- quantiles[i]

      data_list_y[[i]] <- datay

    }

    ydata <- do.call(rbind, data_list_y)

    names(xdata)[names(xdata) == "fit"] <- "fit_x"
    names(ydata)[names(ydata) == "fit"] <- "fit_y"

    names(xdata)[names(xdata) == "CI"] <- "CI_x"
    names(ydata)[names(ydata) == "CI"] <- "CI_y"

    data <- cbind(xdata, ydata)

    data <- data[,1:7]

  } else {

    xdata <- better_interaction_plot(qgam_x, pred = pred, cond = cond, quantile = quantile, order = order)$data
    ydata <- better_interaction_plot(qgam_y, pred = pred, cond = cond, quantile = quantile, order = order)$data

    names(xdata)[names(xdata) == "fit"] <- "fit_x"
    names(ydata)[names(ydata) == "fit"] <- "fit_y"

    names(xdata)[names(xdata) == "CI"] <- "CI_x"
    names(ydata)[names(ydata) == "CI"] <- "CI_y"

    data <- cbind(xdata, ydata)

    data <- data[,1:7]

  }

  # plot

  if(is.null(color)){
    color <- c(rep("black", length(levels(data$levels))))
  }

  if(length(qgam_x) <= 10){

    plot <- ggplot(data = data) +
      geom_errorbar(aes(x=fit_x, ymin=fit_y-CI_y, ymax=fit_y+CI_y, linetype = condition), width = 0) +
      geom_errorbarh(aes(y=fit_y, xmin=fit_x-CI_x, xmax=fit_x+CI_x, linetype = condition), height = 0) +
      geom_point(aes(x = fit_x, y = fit_y, color = levels, shape = condition), size = size, alpha = alpha) +
      scale_color_manual(values = color) +
      facet_wrap(. ~ quantile, ncol = ncol, scales = scales) +
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "top",
            strip.background = element_rect(fill="white")) +
      guides(color = guide_legend(title=pred), shape = guide_legend(title=cond), linetype = guide_legend(title=cond)) +
      xlab(xlab) +
      ylab(ylab)

  } else {

    plot <- ggplot(data = data) +
      geom_errorbar(aes(x=fit_x, ymin=fit_y-CI_y, ymax=fit_y+CI_y, linetype = condition), width = 0) +
      geom_errorbarh(aes(y=fit_y, xmin=fit_x-CI_x, xmax=fit_x+CI_x, linetype = condition), height = 0) +
      geom_point(aes(x = fit_x, y = fit_y, color = levels, shape = condition), size = size, alpha = alpha) +
      scale_color_manual(values = color) +
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "top",
            strip.background = element_rect(fill="white")) +
      guides(color = guide_legend(title=pred)) +
      xlab(xlab) +
      ylab(ylab)

  }

  return(plot)

}
