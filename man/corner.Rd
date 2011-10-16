\name{corner}
\alias{corner}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Grabs a corner of a data set
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Display a corner section of a rectangular data set
}
\usage{
corner(x, ...)
corner.data.frame(x, r=5L, c=5L, corner="topleft", ...)
corner.matrix(x, r=5L, c=5L, corner="topleft", ...)
corner.default(x, r=5L, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
The data
}
  \item{r}{
%%     ~~Describe \code{x} here~~
Number of rows to display
}
  \item{c}{
%%     ~~Describe \code{x} here~~
Number of columns to show
}
  \item{corner}{
%%     ~~Describe \code{x} here~~
Which corner to grab.  Posibble values are c("topleft", "bottomleft", "topright", "bottomright")
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
Arguments passed on to other functions
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
Displays a corner of a retangular data set such as a data.frame or martrix.  If showing the right side or bottom, the order of the data is preserved.

The default method reverts to simply calling \code{\link{head}}
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
The part of the data set that was requested.  The size depends on r and c and the position depends on corner.
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
\code{\link{head}}
\code{\link{tail}}
}
\alias{corner.default}
\alias{corner.data.frame}
\alias{corner.matrix}
\examples{
%##---- Should be DIRECTLY executable !! ----
%##-- ==>  Define data, use random,
%##--	or do  help(data=index)  for the standard data sets.
data(diamonds)
head(diamonds)      # displays all columns
corner(diamonds)    # displays first 5 rows and only the first 5 columns
corner(diamonds, corner="bottomleft")       # displays the last 5 rows and the first 5 columns
corner(diamonds, corner="topright")       # displays the first 5 rows and the last 5 columns


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ corner }
\keyword{ head }% __ONLY ONE__ keyword per line
\keyword{ tail }
\keyword{ display }
\keyword{ subsection }
\keyword{ view }
