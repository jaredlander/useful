## Functions for determining ideal number of clusters for kmeans

## Plots the results from the Hartigan's Rule run
## prints and returns the ggplot object
## @hartigan (data.frame) the results from fitting Hartigan's Rule
## @title (character) the title of the plot
## @linecolor (numeric) the color of the line indicating 10
## @linetype (numeric) the style of the line indicating 10
## @linesize (numeric) the size of the line indicating 10
## @minor (logical) whether the minor grid lines should be displayed
PlotHartigan <- function(hartigan, title="Hartigan's Rule", linecolor="grey", linetype=2L, linesize=1L, minor=TRUE)
{
    ggplot(data=hartigan, aes(x=Clusters, y=Hartigan)) + 
        geom_hline(aes(yintercept=10), linetype=linetype, colour=linecolor, size=linesize) + 
        geom_line() +
        geom_point(aes(colour=AddCluster)) +
        scale_colour_discrete(name="Add Cluster") +
        opts(title=title) + if(minor) scale_x_continuous(minor_breaks=(1:(max(hartigan$Clusters)+1)))
}

## Compute Hartigan's Rule given a kmeans cluster WSS and a k+1means cluster WSS and the number of rows in the data
## returns the number
ComputeHartigan <- function(FitActualWSS, FitPlus1WSS, nrow)
{
    return(sum(FitActualWSS) / sum(FitPlus1WSS) - 1) * (nrow - length(FitActualWSS) - 1))
}

## this function fits a series of kmeans and returns a data.frame listing the number of clusters and the result of applying Hartigan's Rule
## returns the data.frame of Hartigan results
## @x (data.frame or matrix) the data to fit kmeans on
## @max.clusters (numeric) the number of clusters to try
## @spectral (logical) whether it is fitting using spectral methods
## @nstart (numeric) the number of random starts for kmeans to use
@@ iter.max (numeric) the maximum number of iterations for kmeans before giving up on convergence
FitKMeans <- function(x, max.clusters=12L, spectral=FALSE, nstart=1L, iter.max=10L)
{
	# data.frame for keeping track of Hartigan number
	hartigan <- data.frame(Clusters=2:(max.clusters), Hartigan=NA, AddCluster=NA)
 
 	# compute the number of rows and columns just once
 	nRowX <- nrow(x)
 	nColX <- ncol(x)
 	
 	# compute kmeans repeatedly
    for(i in 2:(max.clusters))
    {
        # for k
        FitActual <- kmeans(x[, 1:(nColX - (nColX-(i-1))*spectral)], centers=i-1, nstart=nstart, iter.max=iter.max)
        
        # for k+1
        FitPlus1 <- kmeans(x[, 1:(nColX - (nColX-(i+0))*spectral)], centers=i, nstart=nstart, iter.max=iter.max)
        
        # calculate Hartigan
        hartigan[i-1, "Hartigan"] <- ComputeHartigan(FitActualWSS=FitActual$withinss, FitPlus1WSS=FitPlus1$withinss, nrow=nRowX)
    }
 
    # if Hartigan is greater than 10 then the cluster should be added
    hartigan$AddNext <- ifelse(hartigan$Hartigan > 10, TRUE, FALSE)
 
    return(hartigan)
}