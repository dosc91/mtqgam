# mtqgam <img src='https://dominicschmitz.com/wp-content/uploads/2021/11/mtqgam_logo2.png' align="right" height="138" />

<!-- badges: start -->
![](https://img.shields.io/badge/version-0.5.1-FFA70B.svg)
![](https://img.shields.io/github/last-commit/dosc91/mtqgam)
<!-- badges: end -->

`mtqgam` offers functions

- to extract t values, and x and y coordinates of time-normalized mouse-tracking data
- to conveniently plot parametric terms, smooth terms, and their interactions in QGAMs
- to create multi-panel plots of parametric and smooth terms of QGAMs
- to summarize mqgam objects

Check out the [references](https://dosc91.github.io/mtqgam/reference/index.html) for more detailed information.

# What's New

Please check the [changelog](https://dosc91.github.io/mtqgam/news/index.html) for information on version history and function updates.

# How to Install

The preferred way to install this package is through devtools:

```r
# if devtools has not been installed yet, please install it first
# install.packages("devtools")

# then, install the mtqgam package
devtools::install_github("dosc91/mtqgam", upgrade_dependencies = FALSE)
```

You will be asked to update dependencies during installation; usually, updates can be skipped. Once installation was successfull, there will be a warning message on the usage of `...`; this can be ignored.

Please note that in order to use the plot functions of `mtqgam`, `ggplot2` is loaded automatically. Prior version 0.3, `ggplot2` had to be loaded via `library(ggplot2)` first.


# References

Please cite the package as follows:

Schmitz, Dominic. (2021). mtqgam: Mouse-Tracking Data in QGAMs. R package version 0.4. URL: https://github.com/dosc91/mtqgam

The following packages are made use of in the `mtqgam` package:

Csárdi, G. (2021). cli: Helpers for Developing Command Line Interfaces. R package version 3.0.0. URL: https://CRAN.R-project.org/package=cli

Fasiolo M., Goude Y., Nedellec R., & Wood S. N. (2017). Fast calibrated additive quantile regression. URL: https://arxiv.org/abs/1707.03307

Hester, J. (2020). glue: Interpreted String Literals. R package version 1.4.1. https://CRAN.R-project.org/package=glue

Kieslich, P. J., Henninger, F., Wulff, D. U., Haslbeck, J. M. B., & Schulte-Mecklenbeck, M. (2019). Mouse-tracking: A practical guide to implementation and analysis. In M. Schulte-Mecklenbeck, A. Kühberger, & J. G. Johnson (Eds.), A Handbook of Process Tracing Methods (pp. 111-130). New York, NY: Routledge.

van Rij J, Wieling M, Baayen R, & van Rijn H (2020). itsadug: Interpreting Time Series and Autocorrelated Data Using GAMMs. R package version 2.4.

Wickham, H. (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York.

Wickham, H. (2020). tidyr: Tidy Messy Data. R package version 1.1.2. https://CRAN.R-project.org/package=tidyr
