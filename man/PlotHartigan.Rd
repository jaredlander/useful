\name{PlotHartigan}
\alias{PlotHartigan}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
PlotHartigan(hartigan, title = "Hartigan's Rule", smooth = FALSE, linecolor = "grey", linetype = 2L, linesize = 1L, minor = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{hartigan}{
%%     ~~Describe \code{hartigan} here~~
}
  \item{title}{
%%     ~~Describe \code{title} here~~
}
  \item{smooth}{
%%     ~~Describe \code{smooth} here~~
}
  \item{linecolor}{
%%     ~~Describe \code{linecolor} here~~
}
  \item{linetype}{
%%     ~~Describe \code{linetype} here~~
}
  \item{linesize}{
%%     ~~Describe \code{linesize} here~~
}
  \item{minor}{
%%     ~~Describe \code{minor} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

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
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
