\name{MapToInterval}
\alias{MapToInterval}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Map numbers to interval
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Maps a range of numbers to a given interval
}
\usage{
MapToInterval(nums, start = 1, stop = 10)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{nums}{
%%     ~~Describe \code{nums} here~~
The vector of numbers to be mapped
}
  \item{start}{
%%     ~~Describe \code{start} here~~
The start of the interval
}
  \item{stop}{
%%     ~~Describe \code{stop} here~~
The end of the interval
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
Follows this formula: a + (x - min(x)) * (b - a) / (max(x) - min(x))
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
The original numbers mapped to the given interval
}
\references{
%% ~put references to the literature/web site here ~
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
}
\examples{
%##---- Should be DIRECTLY executable !! ----
%##-- ==>  Define data, use random,
%##--	or do  help(data=index)  for the standard data sets.

MapToInterval(1:10, start=0, stop=1)

## The function is currently defined as
function(nums, start=1, stop=10)
{
    #do the mapping: a + (x - min(x)) * (b - a) / (max(x) - min(x))
    mapped <- start + (nums - min(nums)) * (stop - start) / diff(range(nums))
    return(mapped)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ numbers }
\keyword{ mapping }
\keyword{ interval }% __ONLY ONE__ keyword per line
