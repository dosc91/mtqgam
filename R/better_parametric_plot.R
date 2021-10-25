#' Plot better plots of parametric predictors in QGAMs
#'
#' @description \code{better_parametric_plot} creates a point plot with confidence interval ranges using \code{ggplot2}. It basically is a wrapper for \code{itsadug}'s
#' \code{plot_parametric} function.
#'
#' @usage better_parametric_plot(
#'   qgam,
#'   pred,
#'   print.summary,
#'   plot.old,
#'   size,
#'   color,
#'   alpha,
#'   order)
#'
#' @param qgam A qgam object, created with \code{qgam} or extracted from a \code{mqgam} object.
#' @param pred A named list of the levels to use for the predictor terms to plot (same as those specified for \code{plot_parametric}).
#' @param print.summary Logical: whether or not to print summary.
#' @param plot.old Plot the original \code{plot_parametric} as well.
#' @param size Size argument for the ggplot object; specifies the size of points and lines.
#' @param color Color argument for the ggplot object; specifies the color of points and lines.
#' @param alpha Alpha argument for the ggplot object; specifies the transparency of points and lines.
#' @param order Specify the order with which the levels given in \code{pred} should be plotted.
#'
#' @return A ggplot object.
#'
#' @author D. Schmitz
#'
#' @references van Rij J, Wieling M, Baayen R, & van Rijn H (2020). itsadug: Interpreting Time Series and Autocorrelated Data Using GAMMs. R package version 2.4.
#' @references Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.
#'
#' @examples
#' better_parametric_plot(qgam = tmp.x.1,
#'   pred = list(Condition = c("matched", "mismatched")),
#'   size = 2,
#'   color = c("red", "green"),
#'   alpha = 0.2,
#'   order = c("mismatched", "matched"))
#'
#' better_parametric_plot(qgam = tmp.x.1,
#'   pred = list(Condition = c("matched", "mismatched"))) +
#'   theme_classic() +
#'   labs(subtitle = "You can basically add all ggplot functions and arguments you are familiar with.")
#'
#' @export

better_parametric_plot <- function(qgam, pred, print.summary = F, plot.old = F, order = NULL, size = 0.5, color = NULL, alpha = 1){

  if(plot.old == T){
    parametric_plot <- plot_parametric(qgam, pred=pred, print.summary=print.summary)
  } else {
    R.devices::suppressGraphics({
      parametric_plot <- plot_parametric(qgam, pred=pred, print.summary=print.summary)
    })}

  fit <- parametric_plot$fv$fit

  CI <- parametric_plot$fv$CI

  levels <- unlist(pred)

  data <- as.data.frame(cbind(fit, CI, levels))

  data$fit <- as.numeric(data$fit)
  data$CI <- as.numeric(data$CI)
  data$levels <- as.factor(data$levels)

  name <- names(pred)

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
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = "none") +
    scale_color_manual(values=c("black", "black"))

  if(is.null(order)){
    cli::cli_alert_info(glue::glue("Plotting with default order of predictor levels."))
  } else if (!is.null(order)){
    cli::cli_alert_info(glue::glue("Plotting with specified order of predictor levels."))
  }

  return(newplot)
}
