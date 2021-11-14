# Version 0.4
A new function has been added:

- better_interaction_plot - Create interaction plots using ggplot2

The function creates plots for factor:factor and numeric:factor interactions in QGAMs. For factor:factor interactions, two facets of dot plots with confidence interval ranges 
are plotted. For numeric:factor interactions, a smooth plot with confidence intervals is plotted. The smooth plot is either given in two facets (default) or as one plot (see 
the `type` argument in the documentation/[vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) for further information).

# Version 0.3
Three functions have been added:

- extract_t - Extract t coordinates (time values) from time-normalized mouse-tracking data
- facet_parametric_plot - Create multi-panel parametric plots using ggplot2
- facet_smooth_plot - Create multi-panel smooth term plots using ggplot2

Additionally, qualitify of life improving modifications to the following functions were made:

- better_parametric_plot - Create parametric term plots using ggplot2
- better_smooth_plot - Create smooth term plots using ggplot2
- extract_x - Extract x coordinates
- extract_y - Extract y coordinates

That is, both plotting functions now take a much more simple `pred` argument. Before, this had to be a named list of factor levels; now, this is just the predictor 
variable itself. Other modifications include the addition of more meaningful error messages and streamlining the argument structure overall. 

The `extract_` functions now display a progress bar when run. This can be toggled off specifying the newly introduced `verbose` argument as `false`.

Code created with prior versions of the package continues to function. Please have a look at the functions 
[vignette](http://htmlpreview.github.io/?https://github.com/dosc91/mtqgam/blob/main/vignettes/functions.html) and the documentation of the 
pertinent functions for more detailed information.

# Version 0.2
One major change to the following function is part of this version:

- better_parametric_plot - Create parametric term plots using ggplot2

The function now recognises the `cond` argument for choosing between interacting terms to display.

# Version 0.1
This is the initial version of the mtqgam package. The following functions are included:

- better_parametric_plot - Create parametric term plots using ggplot2
- better_smooth_plot - Create smooth term plots using ggplot2
- extract_x - Extract x coordinates
- extract_y - Extract y coordinates
