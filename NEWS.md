# Version 1.2.7
Using `autoplot` to plot `acf` objects.

# Version 1.2.4
Complete unit test coverage.
Added point size option in `plot.kmeans`.
Added function for computing a single time difference with an informative message.

# Version 1.2.3
Added support for sparse matrices in `build.x`

# Version 1.2.2
Adjusted `build.x` so that it works appropriately when only one categorical variable is specified.
Added tests for building matrices.
Changed code to accommodate new changes in `dplyr`.

# Version 1.2.1
Added function, `uniqueBidirection` to return unique rows of a `data.frame` regardless of their order.
Fixed test failures due to new version of `testthat`.

# Version 1.2.0
Explicitly calling functions from grid and scales rather than importing the entire packages.
The function subVector now returns the original text x if toSub is not supplied.

# Version 1.1.9
New function for checking the class of each column in a data.frame.
New functions for simple imputation of missing data.
New functions for check the case of strings.
New function to add a new class to an object in addition to existing classes.
New functions for mapping polar coordinates to cartesian and back.
New functions for mapping matrix index to position and position to index.
New functions for regex substitution of multiple items.

# Version 1.1.8
Added functionality to build.x to control contrasts.
Fixed bug in build.x where it never returned the intercept.

# Version 1.1.7
Scale formatters for ggplot2.
Functions to build x and y matrices based on a formula.
Functions to build x and y matrices based on a formula.
Function to ensure data in build.x and build.y is not a matrix or array.
Function to check interval membership.

# Version 1.1.6
Updated to reflect ggplot2_0.9.2 changes.

# Version 1.1.5
New function to flip 0's to 1's and 1's to 0's.
New function to shift columns up or down in a data.frame.
New function to knit Rnw files to TeX only if the TeX doesn't exist or is older than the Rnw.
New functions for plotting the results of a kmeans fit.
New functions for plotting ts and acf objects.

# Version 1.1.4
New function for building formulas from vectors of characters.

# Version 1.1.3
Added function for comparing two lists element by element.

# Version 1.1.2
FitKMeans uses match.arg for determining algorithm choice.
The loop in FitKMeans now fits each partitioning once and reuses it rather than calculating twice.

# Version 1.1.1
Fixed corner so that it handles showing the bottom of data correctly.

# Version 1.0
First Build.
A collection of handy functions.
subOut, subSpecials, MapToInterval, corner, FitKMeans, PlotHartigan.