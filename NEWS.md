# Version 0.5.4

A new function has been added:

- [pairwise_comparison](../reference/pairwise_comparison.html) - Pairwise Tukey Comparisons

This function computes pairwise Tukey comparisons for any combination of variables in a given QGAM.

# Version 0.5.3

A new function has been added. The function is currently in its alpha phase:

- [xy_interaction_plot](../reference/xy_interaction_plot.html) - XY plots of parametric predictor interactions in QGAMs

With this variant of the `xy_plot` function one can visualise interactions between two parametric predictors in the compact style of `xy_plot`. The function can be used and should work in most if not all cases, but keep in mind that it is still in an early phase of development.

The following function is no longer in its alpha phase:

- [xy_plot](../reference/xy_plot.html) - XY plots of parametric predictors in QGAMs

Additionally, a qualitify of life improving modification to the following function was made:

- [better_interaction_plot](../reference/better_interaction_plot.html) - Create interaction plots using ggplot2

Facet labels now can be set manually using the newly introduced `names` argument. See the reference for details.


# Version 0.5.2

A new function has been added. The function is currently in its alpha phase:

- [xy_plot](../reference/xy_plot.html) - XY plots of parametric predictors in QGAMs

This function creates a point plot with confidence interval ranges using `ggplot2`. It combines the model estimates for the same predictor in two (sets of) QGAMs, i.e. it displays estimates of X and Y coordinates. It basically is a combination of two parametric plots, with estimates for X coordinates plotted on the X axis, and estimates for Y coordinates plotted on the Y axis. The function can be used and should work in most if not all cases, but keep in mind that it is still in an early phase of development.

# Version 0.5.1

One minor change has been added to:

- [summary.mqgam](../reference/summary.mqgam.html) - Summary for a MQGAM fit

The individual summaries are now separated more clearly.

# Version 0.5
Two functions have been added:

- [extract_xyt](../reference/extract_xyt.html) - Extract x, y, and t coordinates of time-normalized mouse-tracking data
- [summary.mqgam](../reference/summary.mqgam.html) - Summary for a MQGAM fit

The `extract_xyt` function is a wrapper of the three already included extraction functions. With the new S3 method for the object class `mqgam`, mqgam objects now can be summarized.

Four data objects have been added:

- [mtqgam_raw_data](../reference/mtqgam_raw_data.html) - Example data to create QGAMs with
- [mtqgam_mqgam](../reference/mtqgam_mqgam.html) - Example MQGAM object
- [mtqgam_qgam](../reference/mtqgam_qgam.html) - Example QGAM object
- [mtqgam_mousetrap](../reference/mtqgam_mousetrap.html) - Example mousetrap object

The data objects are used to run examples. They are 'lazy loaded' when loading the `mtqgam` package, and can be used by users to test functions.

Additionally, qualitify of life improving modifications to the following functions were made:

- [better_parametric_plot](../reference/better_parametric_plot.html) - Create parametric term plots using ggplot2
- [facet_parametric_plot](../reference/facet_parametric_plot.html) - Create multi-panel parametric plots using ggplot2
- [extract_x](../reference/extract_x.html) - Extract x coordinates
- [extract_y](../reference/extract_y.html) - Extract y coordinates
- [extract_t](../reference/extract_t.html) - Extract t coordinates

Both plot functions now correctly work with predictors of more than two levels. Previously, a coding error made specifying colours necessary. The extract functions now take mousetrap objects as data source. Previously, 
data extracted from mousetrap objects had to be specified. While this is still possible, I advise to use the newly created argument usage. Please see the examples in the pertinent references for further details.

# Version 0.4
A new function has been added:

- [better_interaction_plot](../reference/better_interaction_plot.html) - Create interaction plots using ggplot2

The function creates plots for factor:factor and numeric:factor interactions in QGAMs. For factor:factor interactions, two facets of dot plots with confidence interval ranges 
are plotted. For numeric:factor interactions, a smooth plot with confidence intervals is plotted. The smooth plot is either given in two facets (default) or as one plot (see 
the `type` argument in the documentation/[reference](../reference/better_interaction_plot.html) for further information).

# Version 0.3
Three functions have been added:

- [extract_t](../reference/extract_t.html) - Extract t coordinates (time values) from time-normalized mouse-tracking data
- [facet_parametric_plot](../reference/facet_parametric_plot.html) - Create multi-panel parametric plots using ggplot2
- [facet_smooth_plot](../reference/facet_smooth_plot.html) - Create multi-panel smooth term plots using ggplot2

Additionally, qualitify of life improving modifications to the following functions were made:

- [better_parametric_plot](../reference/better_parametric_plot.html) - Create parametric term plots using ggplot2
- [better_smooth_plot](../reference/better_smooth_plot.html) - Create smooth term plots using ggplot2
- [extract_x](../reference/extract_x.html) - Extract x coordinates
- [extract_y](../reference/extract_y.html) - Extract y coordinates

That is, both plotting functions now take a much more simple `pred` argument. Before, this had to be a named list of factor levels; now, this is just the predictor 
variable itself. Other modifications include the addition of more meaningful error messages and streamlining the argument structure overall. 

The `extract_` functions now display a progress bar when run. This can be toggled off specifying the newly introduced `verbose` argument as `false`.

Code created with prior versions of the package continues to function. Please have a look at the [references](../reference/index.html) and the documentation of the 
pertinent functions for more detailed information.

# Version 0.2
One major change to the following function is part of this version:

- [better_parametric_plot](../reference/better_parametric_plot.html) - Create parametric term plots using ggplot2

The function now recognises the `cond` argument for choosing between interacting terms to display.

# Version 0.1
This is the initial version of the `mtqgam` package. The following functions are included:

- [better_parametric_plot](../reference/better_parametric_plot.html) - Create parametric term plots using ggplot2
- [better_smooth_plot](../reference/better_smooth_plot.html) - Create smooth term plots using ggplot2
- [extract_x](../reference/extract_x.html) - Extract x coordinates
- [extract_y](../reference/extract_y.html) - Extract y coordinates
