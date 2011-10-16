\name{subSpecials}
\alias{subSpecials}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Sub special characters out of character vectors.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Converts each of the special characters to their escaped equivalents in each element of each vector.
}
\usage{
subSpecials(..., specialChars=c("!", "(", ")", "-", "=", "*", "."))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{...}{
%%     ~~Describe \code{toAlter} here~~
Character vectors that will be altered by subbing the special characters with their escaped equivalents
}
  \item{specialChars}{
%%     ~~Describe \code{specialChars} here~~
The characters to be subbed out
}

}
\details{
%%  ~~ If necessary, more details than the description above ~~
Each element in the specialChar vector is subbed for its escaped equivalent in each of the elements of each vector passed in
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
The provided vectors are returned with any of the defined specialChars subbed out for their escaped equivalents
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
\code{\link{sub}}
\code{\link{subOut}}
}
\examples{
%##---- Should be DIRECTLY executable !! ----
%##-- ==>  Define data, use random,
%##--	or do  help(data=index)  for the standard data sets.

subSpecials(c("Hello", "(parens)", "Excited! Mark"))
subSpecials(c("Hello", "(parens)", "Excited! Mark"), c("This is a period. And this is an asterisk *"), specialChars=c("!", "("))

## The function is currently defined as
subSpecials <- function(..., specialChars=c("!", "(", ")", "-", "=", "*", "."), simplify=FALSE)
{
    return(llply(list(...), subOut, specialChars=specialChars))
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ string }
\keyword{ text }% __ONLY ONE__ keyword per line
