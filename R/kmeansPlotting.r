# k-means plotting

#' fortify.kmeans
#' 
#' Fortify a kmeans model with its data
#' 
#' Prepares a kmeans object to be plotted using \code{\link{cmdscale}} to compute the projected x/y coordinates.
#' 
#' @aliases fortify.kmeans
#' @export fortify.kmeans
#' @author Jared P. Lander
#' @seealso kmeans fortify ggplot plot.kmeans
#' @param model \code{\link{kmeans}} model
#' @param data Data used to fit the model
#' @param \dots Not Used
#' @method fortify kmeans
#' @S3method fortify kmeans
#' @return The original data with extra columns:
#'      \item{.x}{The projected x position.}
#'      \item{.y}{The projected y position.}
#'      \item{.Cluster}{The cluster that point belongs to.}
#' @examples
#' 
#' k1 <- kmeans(x=iris[, 1:4], centers=3)
#' hold <- fortify(k1)
#' head(k1)
fortify.kmeans <- function(model, data, ...)
{
    # get the names of columns used
    usedCols <- colnames(model$centers)
    
    # make a 2 dimensional scaling of the data
    points <- data.frame(cmdscale(d=dist(data[, usedCols]), k=2))
    names(points) <- c(".x", ".y")
    
    # tack centers onto the points
    points$.Cluster <- as.factor(model$cluster)
    
    data <- cbind(data, points)
    
    return(data)
}

#' plot.kmeans
#' 
#' Plot the results from a k-means object
#' 
#' Plots the results of k-means with color-coding for the cluster membership.
#' 
#' @aliases plot.kmeans
#' @export plot.kmeans
#' @author Jared P. Lander
#' @seealso kmeans fortify ggplot plot.kmeans
#' @method plot kmeans
#' @S3method plot kmeans
#' @param x A \code{\link{kmeans}} object.
#' @param data The data used to kit the \code{\link{kmeans}} object.
#' @param class Character name of the "true" classes of the data.
#' @param legend.position Character indicating where the legend should be placed.
#' @param title Title for the plot.
#' @param xlab Label for the x-axis.
#' @param ylab Label for the y-axis.
#' @param \dots Not Used.
#' @return A ggplot object
#' @examples
#' 
#' k1 <- kmeans(x=iris[, 1:4], centers=3)
#' plot(k1)
plot.kmeans <- function(x, data, class=NULL, legend.position=c("right", "bottom", "left", "top", "none"), 
                        title="K-Means Results",
                        xlab="Principal Component 1", ylab="Principal Component 2", ...)
{
    # fortify the model and data so it is convenient to plot in ggplot
    toPlot <- fortify(model=x, data=data)
    
    # get the legend position
    legend.position <- match.arg(legend.position)
    
    ggplot(toPlot, aes(x=.x, y=.y, colour=.Cluster)) + 
        geom_point(aes_string(shape=class)) + 
        scale_color_discrete("Cluster") +
        opts(legend.position=legend.position, title=title) +
        labs(x=xlab, y=ylab)
}