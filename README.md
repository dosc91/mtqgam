# mtqgam <img src='https://dominicschmitz.com/packages/mtqgam_logo2.png' align="right" height="138" />

<!-- badges: start -->
![](https://img.shields.io/badge/version-0.3-FFA70B.svg)
![](https://img.shields.io/github/last-commit/dosc91/mtqgam)
<!-- badges: end -->

`mtqgam` offers functions

- to extract t, x and y coordinates of time-normalized mouse-tracking data
- to conveniently plot parametric and smooth terms of QGAMs
- to create multi-panel plots of parametric and smooth terms of QGAMs

Check out the [vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) for more detailed information.

# What's New

In version 0.3, two functions have been added:

- extract_t - Extract t coordinates (time values) from time-normalized mouse-tracking data
- facet_parametric_plot - Create multi-panel parametric plots using ggplot2
- facet_smooth_plot - Create multi-panel smooth term plots using ggplot2

Additionally, qualitify of life improving modifications to the following functions were made:

- better_parametric_plot - Create parametric term plots using ggplot2
- better_smooth_plot - Create smooth term plots using ggplot2
- extract_x - Extract x coordinates
- extract_y - Extract y coordinates

That is, both plotting functions now take a much more simple `pred` argument. Before, this had to be a named list of factor levels; now, this is just the predictor variable itself. Other modifications include the addition of more meaningful error messages and streamlining the argument structure overall. 

The `extract_` functions now display a prograss bar when run. This can be toggled off specifying the newly introduced `verbose` argument as `false`.

Code created with prior versions of the package continues to function. Please have a look at the functions [vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) and the documentation of the pertinent functions for more detailed information.

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

# Overview

This is a full list of all functions currently contained in `mtqgam`

- better_parametric_plot - Create parametric term plots using ggplot2
- better_smooth_plot - Create smooth term plots using ggplot2
- extract_x - Extract x coordinates
- extract_y - Extract y coordinates
- facet_parametric_plot - Create multi-panel parametric plots using ggplot2
- facet_smooth_plot - Create multi-panel smooth term plots using ggplot2

# References

Please see the references section of the [vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) for a list of references.

Please cite the package as follows:

Schmitz, Dominic. (2021). mtqgam: Mouse-Tracking Data in QGAMs. R package version 0.3. URL: https://github.com/dosc91/mtqgam
