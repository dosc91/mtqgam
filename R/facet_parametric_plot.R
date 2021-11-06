#' Plot a multi-panel plot of a parametric predictor across multiple QGAMs in a MQGAM
#'
#' @description \code{facet_parametric_plot} creates a multi-panel plot of point plots with confidence interval ranges using \code{ggplot2}.
#'
#' @usage better_parametric_plot(
#'   qgam,
#'   pred,
#'   cond = NULL,
#'   print.summary = FALSE,
#'   order = NULL,
#'   ncol = 1,
#'   xlab = "fit",
#'   ylab = NULL,
#'   scales = "free",
#'   size = 0.5,
#'   color = c("red", "blue"),
#'   alpha = 1)
#'
#' @param qgam An mqgam object created with \code{qgam::mqgam}.
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
#' # basic example
#' facet_parametric_plot(qgam = mqgams_x,
#'   pred = "Condition")
#'
#' # combining facet_parametric_plot with ggplot2
#' facet_parametric_plot(qgam = mqgams_x,
#'   pred = "Condition") +
#'   theme_void() +
#'   labs(subtitle = "This is a subtitle")
#'
#' @export

facet_parametric_plot <- function(qgam, pred, cond = NULL, print.summary = F, order = NULL, ncol = 1, xlab = "fit", ylab = NULL, scales = "free", size = 0.5, color = c("red", "blue"), alpha = 1){

  require(ggplot2)

  quantiles <- as.data.frame(names(qgam[["fit"]]))

  data_list <- vector(mode = "list")

  number <- which(names(qgam$model) == pred)
  pred_list <- list(pred = c(levels(qgam$model[,number])))
  names(pred_list) <- paste(pred)

  if(length(number) == 0){
    stop("Please specify a parametric predictor which is part of your QGAM model.")
  }

  for (q in 1:length(names(qgam[["fit"]]))) {

    tmp.qgam <- qgam::qdo(qgam, quantiles[q,1])

    R.devices::suppressGraphics({
      parametric_plot <- itsadug::plot_parametric(tmp.qgam, pred=pred_list, cond=cond, print.summary=print.summary)
    })

    fit <- parametric_plot$fv$fit

    CI <- parametric_plot$fv$CI

    levels <- unlist(pred_list)

    data <- as.data.frame(cbind(fit, CI, levels))

    data$fit <- as.numeric(data$fit)
    data$CI <- as.numeric(data$CI)
    data$levels <- as.factor(data$levels)
    data$quantile <- quantiles[q,1]

    data_list[[q]] <- data

  }

  data <- do.call(rbind, data_list)

  rownames(data) <- c()

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

  name <- names(pred_list)

  color <- c(rep(color, length(names(qgam[["fit"]]))))

  plot <- ggplot(data = data) +
    geom_pointrange(aes(x = fit, y = levels, xmin = fit - CI, xmax = fit + CI), size = size, color = color, alpha = alpha) +
    facet_wrap(. ~ quantile, ncol = ncol, scales = scales) +
    labs(title = name) +
    xlab(xlab) +
    ylab(ylab) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "none",
          strip.background = element_rect(fill="white"))

  if(is.null(order)){
    cli::cli_alert_info(glue::glue("Plotting with default order of predictor levels."))
  } else if (!is.null(order)){
    cli::cli_alert_info(glue::glue("Plotting with specified order of predictor levels."))
  }

  return(plot)

}
