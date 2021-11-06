#' Plot a multi-panel plot of a smooth predictor across multiple QGAMs in a MQGAM
#'
#' @description \code{facet_smooth_plot} creates a multi-panel plot of smooth term plots with confidence intervals using \code{ggplot2}.
#'
#' @usage better_smooth_plot(
#'   qgam,
#'   pred,
#'   ncol = 1,
#'   xlab = NULL,
#'   ylab = "fit",
#'   scales = "free",
#'   size = 0.5,
#'   fill = "steelblue2",
#'   color = "black",
#'   alpha = 1)
#'
#' @param qgam An mqgam object created with \code{qgam::mqgam}.
#' @param pred The predictor term to plot. Note: This is no longer identical to the \code{pred} argument specified for \code{itsadug::plot_parametric}.
#' @param ncol The number of columns of the multi-panel plot.
#' @param xlab The x-axis label.
#' @param ylab The y-axis label.
#' @param scales Should scales be free (\code{"free"}, the default) or fixed (\code{"fixed"})?
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
#' @references van Rij J, Wieling M, Baayen R, & van Rijn H (2020). itsadug: Interpreting Time Series and Autocorrelated Data Using GAMMs. R package version 2.4.
#' @references Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.
#'
#' @examples
#'
#' # basic example
#' facet_smooth_plot(qgam = mqgams_x,
#'   pred = "order")
#'
#' # combining facet_smooth_plot with ggplot2
#' facet_smooth_plot(qgam = mqgams_x,
#'   pred = "order") +
#'   theme_void() +
#'   labs(subtitle = "This is a subtitle")
#'
#' @export

facet_smooth_plot <- function(qgam, pred, ncol = 1, xlab = NULL, ylab = "fit", scales = "free", size = 0.5, fill = "steelblue2", color = "black", alpha = 1){

  require(ggplot2)

  quantiles <- as.data.frame(names(qgam[["fit"]]))

  data_list <- vector(mode = "list")

  for (q in 1:length(names(qgam[["fit"]]))) {

    tmp.qgam <- qgam::qdo(qgam, quantiles[q,1])

    R.devices::suppressGraphics({
      bad_plot <- plot(tmp.qgam,
                       select=1)
    })

    smooth_terms <- data.frame(matrix(ncol = 1, nrow = 1))

    for(i in 1:length(bad_plot)){

      smooth_terms[i,1] <- bad_plot[[i]][["xlab"]]

    }

    if(is.na(which(smooth_terms == pred, arr.ind=TRUE)[1]) == TRUE){
      stop("Please specify a smooth predictor which is part of your QGAM model.")
    }

    number <- which(smooth_terms == pred, arr.ind=TRUE)[1]

    x <- bad_plot[[number]][["x"]]
    fit <- bad_plot[[number]][["fit"]]
    se <- bad_plot[[number]][["se"]]

    data <- as.data.frame(cbind(x, fit, se))

    data$se_top <- data$se + data$V2
    data$se_bot <- data$V2 - data$se

    data$quantile <- quantiles[q,1]

    data_list[[q]] <- data

  }

  data <- do.call(rbind, data_list)

  xlabname <- bad_plot[[number]][["xlab"]]
  ylabname <- ylab

  plot <- ggplot2::ggplot(data = data) +
    geom_ribbon(aes(x = x, y = V2, ymin = se_bot, ymax = se_top), fill = fill, alpha = alpha) +
    geom_line(aes(x = x, y = V2), size = size, color = color) +
    geom_hline(yintercept = 0, color = "gray") +
    facet_wrap(. ~ quantile, ncol = ncol, scales = scales) +
    xlab(xlabname) +
    ylab(ylabname) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "none",
          strip.background = element_rect(fill="white"))

  cli::cli_alert_info(glue::glue(paste("Plotting multi-panel plot for smooth term", paste(pred, ".", sep = ""))))

  return(plot)

}
