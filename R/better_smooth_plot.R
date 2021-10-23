#' Plot better plots of smooth predictors in QGAMs
#'
#' @description \code{better_smooth_plot} creates a smooth plot with confidence intervals using \code{ggplot2}. It basically is a wrapper for the base \code{plot} function.
#'
#' @usage better_parametric_plot(
#'   qgam,
#'   smooth_term,
#'   size,
#'   fill,
#'   alpha,
#'   color)
#'
#' @param qgam A qgam object, created with \code{qgam} or extracted from a \code{mqgam} object.
#' @param smooth_term The smooth term you wish to plot. Must be one of the smooth terms given in the qgam formula.
#' @param size Size argument for the ggplot object; specifies the size of the line.
#' @param fill Color argument for the ggplot object; specifies the color of the confidence interval.
#' @param alpha Alpha argument for the ggplot object; specifies the transparency of the confidence interval.
#' @param color Color argument for the ggplot object; specifies the color of the line.
#'
#' @return A ggplot object.
#'
#' @author D. Schmitz
#'
#' @references Fasiolo M., Goude Y., Nedellec R., & Wood S. N. (2017). Fast calibrated additive quantile regression. URL: https://arxiv.org/abs/1707.03307
#' @references Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.
#'
#' @examples
#' better_smooth_plot(qgam = tmp.x.3,
#' smooth_term = "Age")
#'
#' better_smooth_plot(qgam = tmp.x.3,
#' smooth_term = "Age",
#' size = 1,
#' fill = "purple",
#' alpha = 0.5,
#' color = "darkgreen") +
#' labs(subtitle = "You can basically add all ggplot functions and arguments you are familiar with.")
#'
#' @export

better_smooth_plot <- function(qgam, smooth_term, size = 0.5, fill = "steelblue2", alpha = 1, color = "black"){

  bad_plot <- plot(qgam,
                   select=1)

  smooth_terms <- data.frame(matrix(ncol = 1, nrow = 1))

  for(i in 1:length(bad_plot)){

    smooth_terms[i,1] <- bad_plot[[i]][["xlab"]]

  }

  number <- which(smooth_terms == smooth_term, arr.ind=TRUE)[1]

  if(is.na(number)){
    cli::cli_alert_danger(glue::glue("Unknown smooth_term specified. Please specify a smooth_term used in your qgam."))
  }

  x <- bad_plot[[number]][["x"]]
  fit <- bad_plot[[number]][["fit"]]
  se <- bad_plot[[number]][["se"]]

  data <- as.data.frame(cbind(x, fit, se))

  data$se_top <- data$se + data$V2
  data$se_bot <- data$V2 - data$se

  xlabname <- bad_plot[[number]][["xlab"]]
  ylabname <- bad_plot[[number]][["ylab"]]

  newplot <- ggplot2::ggplot(data = data) +
    geom_ribbon(aes(x = x, y = fit, ymin = se_bot, ymax = se_top), fill = fill, alpha = alpha) +
    geom_line(aes(x = x, y = fit), size = size, color = color) +
    geom_hline(yintercept = 0, color = "gray") +
    xlab(xlabname) +
    ylab(ylabname) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = "none")

  cli::cli_alert_info(glue::glue(paste("Plotting smooth term", paste(smooth_term, ".", sep = ""))))

  return(newplot)

}
