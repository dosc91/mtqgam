# mtqgam <img src='https://dominicschmitz.com/packages/mtqgam_logo2.png' align="right" height="138" />

<!-- badges: start -->
![](https://img.shields.io/badge/version-0.2.1-FFA70B.svg)
![](https://img.shields.io/github/last-commit/dosc91/mtqgam)
<!-- badges: end -->

`mtqgam` offers functions

- to extract x and y coordinates of time-normalized mouse-tracking data
- to conveniently plot parametric and smooth terms of QGAMs

Check out the [vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) for more detailed information.

# How to Install

The preferred way to install this package is through devtools:

```r
# if devtools has not been installed yet, please install it first
# install.packages("devtools")

# then, install the mtqgam package
devtools::install_github("dosc91/mtqgam", upgrade_dependencies = FALSE)
```

You will be asked to update dependencies during installation; usually, updates can be skipped. Once installation was successfull, there will be a warning message on the usage of `...`; this can be ignored.

Please note that in order to use the plot functions of `mtqgam` you must load `ggplot2` via `library(ggplot2)` first.

# Overview

This is a full list of all functions currently contained in `mtqgam`

- better_parametric_plot - Create parametric term plots using ggplot2
- better_smooth_plot - Create smooth term plots using ggplot2
- extract_x - Extract x coordinates
- extract_y - Extract y coordinates

# References

Please see the references section of the [vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) for a list of references.

Please cite the package as follows:

Schmitz, Dominic. (2021). mtqgam: Mouse-Tracking Data in QGAMs. R package version 0.1. URL: https://github.com/dosc91/mtqgam
