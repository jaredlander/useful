\name{PlotHartigan}
\alias{PlotHartigan}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Plot a series of Hartigan's Numbers
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
After fitting a series of Hartigan's Numbers (see \code{\link{FitKMeans}}) this will plot the results so it is easy to visualize
}
\usage{
PlotHartigan(hartigan, title = "Hartigan's Rule", smooth = FALSE, linecolor = "grey", linetype = 2L, linesize = 1L, minor = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{hartigan}{
%%     ~~Describe \code{hartigan} here~~
The results from \code{\link{FitKMeans}}
}
  \item{title}{
%%     ~~Describe \code{title} here~~
Title to be used in the plot
}
  \item{smooth}{
%%     ~~Describe \code{smooth} here~~
logical; if true a smoothed line will be fit to the points, otherwise it will be a piecewise line
}
  \item{linecolor}{
%%     ~~Describe \code{linecolor} here~~
Color of the horizontal line denoting 10
}
  \item{linetype}{
%%     ~~Describe \code{linetype} here~~
Type of the horizontal line denoting 10
}
  \item{linesize}{
%%     ~~Describe \code{linesize} here~~
Size of the horizontal line denoting 10
}
  \item{minor}{
%%     ~~Describe \code{minor} here~~
logical; if true minor grid lines will be plotted
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
Displays a graphical representation of the results of \code{\link{FitKMeans}}
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
a ggplot object
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
\code{\link{FitKMeans}}
}
\examples{
%##---- Should be DIRECTLY executable !! ----
%##-- ==>  Define data, use random,
%##--    or do  help(data=index)  for the standard data sets.

data(iris)
hartiganResults <- FitKMeans(iris[, -ncol(iris)])
PlotHartigan(hartiganResults)

## The function is currently defined as
function(hartigan, title="Hartigan's Rule", smooth=FALSE, linecolor="grey", linetype=2L, linesize=1L, minor=TRUE)
{
    thePlot <- ggplot(data=hartigan, aes(x=Clusters, y=Hartigan)) + 
        geom_hline(aes(yintercept=10), linetype=linetype, colour=linecolor, size=linesize) + 
        #geom_line() +
        geom_point(aes(colour=AddCluster)) +
        scale_colour_discrete(name="Add Cluster") +
        opts(title=title) + if(minor) scale_x_continuous(minor_breaks=(1:(max(hartigan$Clusters)+1)))
    
    if(smooth)
    {
        thePlot <- thePlot + geom_smooth(method="lm", formula=y~log(x))
    }else
    {
        thePlot <- thePlot + geom_line()
    }
    
    return(thePlot)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ cluster }
\keyword{ kmeans }
\keyword{ hartigan }
\keyword{ clustering }% __ONLY ONE__ keyword per line
