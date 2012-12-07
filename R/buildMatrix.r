#' build.x
#' 
#' Build the x matrix for a glmnet model
#' 
#' Given a formula and a data.frame build the predictor matrix
#' @author Jared P. Lander
#' @aliases build.x
#' @export build.x
#' @param formula A formula
#' @param data A data.frame
#' @return A matrix of the predictor variables specified in the formula
#' @examples
#' require(ggplot2)
#' head(mpg)
#' head(build.x(hwy ~ class + cyl + year, data=mpg))
#' 
build.x <- function(formula, data)
{
    model.matrix(formula, data=data)[, -1]
}

#' build.y
#' 
#' Build the y survival object for a glmnet model
#' 
#' Given a formula and a data.frame build the y survival object
#' @author Jared P. Lander
#' @aliases build.y
#' @export build.y
#' @param formula A formula
#' @param data A data.frame
#' @return A surival object for the portion of the formula in Surv
#' @examples
#' require(ggplot2)
#' head(mpg)
#' head(build.y(hwy ~ class + cyl + year, data=mpg))
#' 
build.y <- function(formula, data)
{
    eval(formula[[2]], envir=data)
}