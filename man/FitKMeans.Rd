\name{FitKMeans}
\alias{FitKMeans}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Fit a series of kmeans clusterings and compute Hartigan's Number
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Given a numeric dataset this function fits a series of kmeans clusterings with increasing number of centers.  k-means is compared to k+1-means using Hartigan's Number to determine if the k+1st cluster should be added.
}
\usage{
FitKMeans(x, max.clusters = 12L, spectral = FALSE, nstart = 1L, iter.max = 10L, algorithm="Hartigan-Wong", seed = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
The data, numeric, either a matrix or data.frame
}
  \item{max.clusters}{
%%     ~~Describe \code{max.clusters} here~~
The maximum number of clusters that should be tried
}
  \item{spectral}{
%%     ~~Describe \code{spectral} here~~
logical; If the data being fit are eigenvectors for spectral clustering
}
  \item{nstart}{
%%     ~~Describe \code{nstart} here~~
The number of random starts for the kmeans algorithm to use
}
  \item{iter.max}{
%%     ~~Describe \code{iter.max} here~~
Maximum number of tries before the kmeans algorithm gives up on conversion
}
  \item{algorithm}{
%%     ~~Describe \code{seed} here~~
The desired algorithm to be used for kmeans.  Options are c("Hartigan-Wong", "Lloyd", "Forgy",
                     "MacQueen").  See \code{\link{kmeans}}
}
    \item{seed}{
%%     ~~Describe \code{seed} here~~
If not null, the random seed will be reset before each application of the kmeans algorithm
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
A consecutive series of kmeans is computed with increasing k (number of centers).  Each result for k and k+1 are compared using Hartigan's Number.  If the number is greater than 10, it is noted that having k+1 clusters is of value.
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
A data.frame consisting of columns, for the number of clusters, the Hartigan Number and whether that cluster should be added, based on Hartigan's Number.
}
\references{
%% ~put references to the literature/web site here ~
http://www.stat.columbia.edu/~madigan/DM08/descriptive.ppt.pdf
}
\author{
%%  ~~who you are~~
Jared P. Lander
www.jaredlander.com
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
\code{\link{kmeans}}
\code{\link{PlotHartigan}}
}
\examples{
%##---- Should be DIRECTLY executable !! ----
%##-- ==>  Define data, use random,
%##--	or do  help(data=index)  for the standard data sets.

data(iris)
hartiganResults <- FitKMeans(iris[, -ncol(iris)])
PlotHartigan(hartiganResults)

## The function is currently defined as
function(x, max.clusters=12L, spectral=FALSE, nstart=1L, iter.max=10L, algorithm="Hartigan-Wong", seed=NULL)
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
        if(!is.null(seed))
        {
            set.seed(seed=seed)
        }
        FitActual <- kmeans(x[, 1:(nColX - (nColX-(i-1))*spectral)], centers=i-1, nstart=nstart, iter.max=iter.max, algorithm=algorithm)
        
        # for k+1
        if(!is.null(seed))
        {
            set.seed(seed=seed)
        }
        FitPlus1 <- kmeans(x[, 1:(nColX - (nColX-(i+0))*spectral)], centers=i, nstart=nstart, iter.max=iter.max, algorithm=algorithm)
        
        # calculate Hartigan
        hartigan[i-1, "Hartigan"] <- ComputeHartigan(FitActualWSS=FitActual$withinss, FitPlus1WSS=FitPlus1$withinss, nrow=nRowX)
    }
 
    # if Hartigan is greater than 10 then the cluster should be added
    hartigan$AddCluster <- ifelse(hartigan$Hartigan > 10, TRUE, FALSE)
 
    return(hartigan)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ cluster }
\keyword{ kmeans }
\keyword{ hartigan }
\keyword{ clustering }% __ONLY ONE__ keyword per line
