#' Plot better interaction plots for QGAMs
#'
#' @description \code{better_interaction_plot} creates either a smooth plot with confidence intervals (for numeric:factor interactions) or
#' a point plot with confidence interval ranges (for factor:factor interactions) using \code{ggplot2}.
#' The underlying functions are similar to \code{better_parametric_plot} and \code{better_smooth_plot}.
#'
#' @usage better_interaction_plot(
#'   qgam,
#'   quantile = NULL,
#'   pred,
#'   cond,
#'   order,
#'   ncol,
#'   type,
#'   xlab = NULL,
#'   ylab = NULL,
#'   scales = NULL,
#'   size = 0.5,
#'   fill = NULL,
#'   color = NULL,
#'   alpha = 1)
#'
#' @param qgam A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.
#' @param quantile If \code{qgam} is a collection of qgam models, specify the quantile you are interested in. Not meaningful for single qgam objects.
#' @param pred The predictor you wish to plot. Must be one of the predictor or smooth terms given in the qgam formula.
#' @param cond The predictor \code{pred} is in interaction with.
#' @param order Specify the order with which the levels given in \code{pred} should be plotted. This is only meaningful for interaction plots of factors.
#' @param ncol The number of columns of the multi-panel plot. This is not meaningful for \code{type = "no_facet"} plots.
#' @param type For interaction plots of two numeric variables, choose either \code{"facet"} (the default) or \code{"no_facet"}. This is only meaningful for interaction plots of numeric variables.
#' @param xlab The x-axis label.
#' @param ylab The y-axis label.
#' @param scales Should scales be fixed (\code{"fixed"}, the default) or free (\code{"free"})? This is not meaningful for \code{type = "no_facet"} plots.
#' @param size Size argument for the ggplot object; specifies the size of the line / the size of the point and whiskers.
#' @param fill Color argument for the ggplot object; specifies the color of the confidence interval. This is only meaningful for interaction plots of numeric variables.
#' @param color Color argument for the ggplot object; specifies the color of the lines and dots. For interaction plots of factors, this must be a vector of colors with a length equal to the combinations of factor levels. For interaction plots of numeric variables and factors, this is a single color.
#' @param alpha Alpha argument for the ggplot object; specifies the transparency of the confidence interval for interaction plots of numeric variables, and specifies the transparency of point and whiskers for interaction plots of interaction plots for factors. The value of \code{alpha} is changed to \code{0.5} by default for \code{no_facet} plots.
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
#' ### examples for factor:factor interactions
#'
#' # using a single qgam extracted from an mqgam object OR fitted with qgam::qgam
#' better_interaction_plot(qgam = qgam,
#'   pred = "correct",
#'   cond = "Condition")
#'
#' # using a qgam that is part of an mqgam object
#' better_interaction_plot(qgam = x.qgams,
#'   quantile = 0.5,
#'   pred = "correct",
#'   cond = "Condition")
#'
#' # specifying color
#' better_interaction_plot(qgam = qgam,
#'   pred = "correct",
#'   cond = "Condition",
#'   color = c("blue", "purple"))
#'
#' # combining better_interaction_plot with ggplot2
#' better_interaction_plot(qgam = qgam,
#'   pred = "correct",
#'   cond = "Condition") +
#'   theme_void() +
#'   labs(subtitle = "This is a subtitle")
#'
#' ### examples for numeric:factor interactions
#'
#' # using a single qgam extracted from an mqgam object OR fitted with qgam::qgam
#' better_interaction_plot(qgam = qgam,
#'   pred = "PIT",
#'   cond = "Condition")
#'
#' better_interaction_plot(qgam = qgam,
#'   pred = "PIT",
#'   cond = "Condition",
#'   type = "no_facet")
#'
#' # specifying color
#' better_interaction_plot(qgam = qgam,
#'   pred = "PIT",
#'   cond = "Condition",
#'   color = "blue", "purple")
#'
#' # using a qgam that is part of an mqgam object
#' better_interaction_plot(qgam = x.qgams,
#'   quantile = 0.5,
#'   pred = "PIT",
#'   cond = "Condition")
#'
#' # combining better_interaction_plot with ggplot2
#' better_interaction_plot(qgam = qgam,
#'   pred = "correct",
#'   cond = "Condition") +
#'   theme_void() +
#'   labs(subtitle = "This is a subtitle")
#'
#' @export

better_interaction_plot <- function(qgam, quantile = NULL, pred, cond = NULL, order = NULL, ncol = NULL, type = NULL, xlab = NULL, ylab = NULL, scales = NULL, size = 0.5, fill = NULL, color = NULL, alpha = 1){

  if(length(pred) == 0){
    stop("Please specify a predictor which is part of your QGAM model.")
  }

  # cond
  if(length(cond) == 0){
    stop("Please specify the variable your predictor is in interaction with. Use better_parametric_plot or better_smooth_plot if you are not interested in interactions.")
  }

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
      qgam <- qdo(qgam, quantile)

    }

  }

  data_list <- vector(mode = "list")

  # pred_list
  number <- which(names(qgam$var.summary) == pred)

  if(is.factor(qgam$var.summary[number][[1]]) == TRUE){

    pred_list <- c(qgam$var.summary[number])

    if(!is.null(type)){
      cli::cli_alert_warning(glue::glue("The type argument is not meaningful for interactions of factor variables. Plotting anyway."))
    }

    if(!is.null(fill)){
      cli::cli_alert_warning(glue::glue("The fill argument is not meaningful for interactions of factor variables; specify color instead. Plotting anyway."))
    }

    factor <- pred_list[[1]]

    character <- as.character(levels(factor))

    pred_list[[1]] <- character

    names(pred_list) <- paste(pred)

    # cond_lists
    number2 <- which(names(qgam$var.summary) == cond)

    cond_list <- c(qgam$var.summary[number2])

    for (m in 1:length(levels(cond_list[[1]]))) {

      cond_list_run <- list(levels(cond_list[[1]])[m])

      names(cond_list_run) <- paste(cond)

      R.devices::suppressGraphics({
        parametric_plot <- itsadug::plot_parametric(qgam, pred=pred_list, cond=cond_list_run, print.summary=F)
      })

      fit <- parametric_plot$fv$fit

      CI <- parametric_plot$fv$CI

      levels <- unlist(pred_list)

      condition <- rep(levels(cond_list[[1]])[m], length(CI))

      data <- as.data.frame(cbind(fit, CI, levels, condition))

      data$fit <- as.numeric(data$fit)
      data$CI <- as.numeric(data$CI)
      data$levels <- as.factor(data$levels)
      data$condition <- as.factor(data$condition)

      data_list[[m]] <- data

    }

    data <- do.call(rbind, data_list)

    if(is.null(order)){
      data <- data
    } else if (!is.null(order)){
      data$levels <- factor(data$levels, levels = order)
    }

    if(is.null(ncol)){
      ncol <- length(levels(data$condition))
    }

    name <- names(pred_list)

    facet_names <- vector(mode = "list")

    for (a in 1:length(levels(data$condition))) {

      label <- paste(paste(cond, "=="), levels(data$condition)[a])

      facet_names[[a]] <- label

    }

    facet_names <- do.call(c, facet_names)

    names(facet_names) <- c(levels(data$condition))

    if(is.null(color)){
      color <- c(rep("black", length(data$condition)))
    } else if (!is.null(color)){
      color <- rep(color, 2)
    }

    if(is.null(xlab)){
      xlab = "fit"
    }

    plot <- ggplot(data = data) +
      geom_pointrange(aes(x = fit, y = levels, xmin = fit - CI, xmax = fit + CI), size = size, color = color, alpha = alpha) +
      facet_wrap(. ~ condition, ncol = ncol, scales = scales, labeller = labeller(condition = facet_names)) +
      labs(title = name) +
      xlab(xlab) +
      ylab(ylab) +
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "none",
            strip.background = element_rect(fill="white"))

  }else{

    if(!is.null(order)){
      cli::cli_alert_warning(glue::glue("The order argument is not meaningful for interactions of smooth terms. Plotting anyway."))
    }

    pred <- pred

    # cond_lists
    number2 <- which(names(qgam$var.summary) == cond)

    cond_list <- c(qgam$var.summary[number2])

    for (m in 1:length(levels(cond_list[[1]]))) {

      cond_list_run <- list(levels(cond_list[[1]])[m])

      names(cond_list_run) <- paste(cond)

      R.devices::suppressGraphics({
        smooth_plot <- itsadug::plot_smooth(x = qgam, view = pred, cond = cond_list_run, print.summary = F)
      })

      data_list[[m]] <- smooth_plot[[1]]

    }

    data <- do.call(rbind, data_list)

    x <- data[colnames(data) == pred]
    fit <- data[colnames(data) == "fit"]
    se <- data[colnames(data) == "CI"]
    contrast <- data[colnames(data) == cond]

    data <- as.data.frame(cbind(x, fit, se, contrast))

    data$se_top <- data$CI + data$fit
    data$se_bot <- data$fit - data$CI

    names(data)[1] <- "x"
    names(data)[2] <- "fit"
    names(data)[3] <- "se"
    names(data)[4] <- "contrast"

    if(is.null(color)){
      color <- "black"
    }

    if(is.null(fill)){
      fill <- "steelblue2"
    }

    if(is.null(type)){
      type <- "facet"
    }else if(type == "facet"){
      type <- "facet"
    }else if(type == "no_facet"){
      type == "no_facet"
    } else {
      stop("Please specify facet or no_facet as argument to type.")
    }

    if(type == "facet"){

      facet_names <- vector(mode = "list")

      for (a in 1:length(levels(data$contrast))) {

        label <- paste(paste(cond, "=="), levels(data$contrast)[a])

        facet_names[[a]] <- label

      }

      facet_names <- do.call(c, facet_names)

      names(facet_names) <- c(levels(data$contrast))

      if(is.null(scales)){
        ylab = "fixed"
      }

      xlab = xlab

      if(is.null(ylab)){
        ylab = "fit"
      }

      plot <- ggplot2::ggplot(data = data) +
        geom_ribbon(aes(x = x, y = fit, ymin = se_bot, ymax = se_top), fill = fill, alpha = alpha) +
        geom_line(aes(x = x, y = fit), size = size, color = color) +
        facet_wrap(. ~ contrast, ncol = ncol, scales = scales, labeller = labeller(contrast = facet_names)) +
        labs(title = pred) +
        xlab(xlab) +
        ylab(ylab) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5),
              legend.position = "none",
              strip.background = element_rect(fill="white"))

    }else if(type == "no_facet"){

      if(!is.null(ncol)){
        cli::cli_alert_warning(glue::glue("The ncol argument is not meaningful for no_facet interaction plots of smooth terms. Plotting anyway."))
      }

      if(!is.null(scales)){
        cli::cli_alert_warning(glue::glue("The scales argument is not meaningful for no_facet interaction plots of smooth terms. Plotting anyway."))
      }

      xlab = xlab

      if(is.null(ylab)){
        ylab = "fit"
      }

      if(alpha == 1){
        cli::cli_alert_warning(glue::glue("Changing alpha to 0.5 for better legibility."))
        alpha = 0.5
      }

      plot <- ggplot2::ggplot(data = data) +
        geom_ribbon(aes(x = x, y = fit, ymin = se_bot, ymax = se_top, group = contrast), fill = fill, alpha = alpha) +
        geom_line(aes(x = x, y = fit, linetype = contrast), size = size, color = color) +
        labs(title = pred,
             linetype = cond) +
        xlab(xlab) +
        ylab(ylab) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5),
              legend.position = "bottom",
              strip.background = element_rect(fill="white"))
    }

  }

  return(plot)
}
