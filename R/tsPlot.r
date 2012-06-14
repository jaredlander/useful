#' vplayout
#' 
#' Viewport
#' 
#' Creates viewport for pushing ggplot objects to parts of a console.
#' 
#' @author Jared P. Lander
#' @aliases vplayout
#' @export vplayout
#' @import viewport, pushViewport
#' @return An R object of class viewport.
#' @param x The x cell of the viewport to push into.
#' @param y The y cell of the viewport to push into.
#' @examples
#' 
#' require(ggplot2)
#' require(grid)
#' 
vplayout <- function(x, y)
{
    viewport(layout.pos.row=x, layout.pos.col=y)
}



#' fortify.ts
#' 
#' Fortify a ts object.
#' 
#' Prepares a ts object for plotting with ggplot.
#' 
#' @author Jared P. Lander
#' @aliases fortify.ts
#' @export fortify.ts
#' @S3method fortify ts
#' @method fortify ts
#' @return \code{\link{data.frame}} for plotting with ggplot.
#' @param x A \code{\link{ts}} object.
#' @param time A vector of the same length of \code{x} that specifies the time component of each element of \code{x}.
#' @param name Character specifying the name of x if it is to be different that the variable being inputed.
#' @examples
#' 
#' fortify(sunspot.year)
#' 
fortify.ts <- function(x, time=NULL, name=as.character(m[[2]]))
{
    m <- match.call()
    
    # if time is provided use that as the x values
    if(!is.null(time))
    {
        theX <- time
    }else
        # otherwise use the built in attributes
    {
        theTime <- attr(x, which="tsp")
        theX <- seq(from=theTime[1], to=theTime[2], by=1/theTime[3])
        rm(theTime)
    }
    
    data <- data.frame(theX, x)
    names(data) <- c("Time", name)
    return(data)
}



#' ts.plotter
#' 
#' Plot a ts object
#' 
#' Fortifies, then plots a \code{\link{ts}} object.
#' 
#' @export ts.plotter
#' @aliases ts.plotter
#' @author Jared P. Lander
#' @import ggplot
#' @return A ggplot object
#' @param data A \code{\link{ts}} object to be plotted.
#' @param time A vector of the same length of \code{data} that specifies the time component of each element of \code{data}.
#' @param title Title of plot.
#' @param xlab X-axis label.
#' @param ylab Y-axis label.
#' @examples
#' 
#' ts.plotter(sunspot.year)
#' 
ts.plotter <- function(data, time=NULL, 
                       title="Series Plot", xlab="Time", ylab="Rate")
{
    # grab the name of the ts that was provided    
    # fortify the ts so it is usable in ggplot
    data <- fortify(data, time=time, name=as.character(match.call()[[2]]))
    
    # figure out the names returned by fortifying
    x <- names(data)[1]
    y <- names(data)[2]
    
    # build the plot
    ggplot(data, aes_string(x=x, y=y)) + geom_line(aes(group=1)) +
        opts(title=title) + labs(x=xlab, y=ylab)
}


#' fortify.acf
#'
#' Fortify an acf/pacf object
#' 
#' Prepares acf (and pacf) objects for plotting with ggplot.
#' 
#' @author Jared P. Lander
#' @aliases fortify.acf
#' @export fortify.acf
#' @S3method fortify acf
#' @method fortify acf
#' @return \code{\link{data.frame}} for plotting with ggplot. 
#' @param x An \code{\link{acf}} object.
#' @param \dots Other arguments
#' @examples
#' 
#' fortify(acf(sunspot.year, plot=FALSE))
#' 
fortify.acf <- function(x, ...)
{
    # the different tpe of acf objects
    theNames <- c(correlation="ACF", covariance="ACF", partial="Partial.ACF")
    
    # build a data.frame consisting the lag number and the acf value
    data <- data.frame(x$lag, x$acf)
    
    # name the data "Lag" and the appropriate type of acf
    names(data) <- c("Lag", theNames[x$type])
    
    return(data)
}


plot.acf <- function(x, 
                     xlab=x, ylab=sub("\\.", " ", y), 
                     title=sprintf("%s Plot", sub("\\.", " ", y))
                     )
{
    # fortify the acf object
    data <- fortify(x)
    
    # get the names we are using
    x <-names(data)[1]
    y <- names(data)[2]
    
    # build plot
    ggplot(data, aes_string(x=x)) + 
        geom_linerange(aes_string(ymin=pmin(y, 0), ymax=pmax(y, 0))) +
        labs(x=xlab, y=ylab) + opts(title=title)
}