% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/better_smooth_plot.R
\name{better_smooth_plot}
\alias{better_smooth_plot}
\title{Plot better plots of smooth predictors in QGAMs}
\usage{
better_smooth_plot(
  qgam,
  quantile = NULL,
  pred,
  plot.old = FALSE,
  xlab = NULL,
  ylab = "fit",
  size = 0.5,
  fill = "steelblue2",
  color = "black",
  alpha = 1)
}
\arguments{
\item{qgam}{A qgam object created with \code{qgam::qgam} or extracted from a \code{qgam::mqgam} object, or a collection of qgams created with \code{qgam::mqgam}.}

\item{quantile}{If \code{qgam} is a collection of qgam models, specify the quantile you are interested in. Not meaningful for single qgam objects.}

\item{pred}{The smooth term you wish to plot. Must be one of the smooth terms given in the qgam formula.}

\item{smooth_term}{\emph{obsolete}: Use \code{pred} instead.}

\item{plot.old}{Plot the original \code{plot} as well.}

\item{xlab}{The x-axis label.}

\item{ylab}{The y-axis label.}

\item{size}{Size argument for the ggplot object; specifies the size of the line.}

\item{fill}{Color argument for the ggplot object; specifies the color of the confidence interval.}

\item{alpha}{Alpha argument for the ggplot object; specifies the transparency of the confidence interval.}

\item{color}{Color argument for the ggplot object; specifies the color of the line.}
}
\value{
A ggplot object.
}
\description{
\code{better_smooth_plot} creates a smooth plot with confidence intervals using \code{ggplot2}. It basically is a wrapper for the base \code{plot} function.
}
\examples{

# using a single qgam extracted from an mqgam object OR fitted with qgam::qgam
better_smooth_plot(qgam = mtqgam_qgam,
  pred = "numeric_2")

# using a qgam that is part of an mqgam object
library(qgam)

better_smooth_plot(qgam = mtqgam_mqgam,
  quantile = 0.5,
  pred = "numeric_2")

# combining better_smooth_plot with ggplot2
better_smooth_plot(qgam = mtqgam_qgam,
  pred = "numeric_2") +
  theme_void() +
  labs(subtitle = "This is a subtitle")

}
\references{
Fasiolo M., Goude Y., Nedellec R., & Wood S. N. (2017). Fast calibrated additive quantile regression. URL: https://arxiv.org/abs/1707.03307

Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.
}
\author{
D. Schmitz
}
