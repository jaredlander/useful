\name{ComputeHartigan}
\alias{ComputeHartigan}
\title{Compute Hartigan's Number}
\usage{
  ComputeHartigan(FitActualWSS, FitPlus1WSS, nrow)
}
\arguments{
  \item{FitActualWSS}{the WSS from a kmeans fit}

  \item{FitPlus1WSS}{the WSS from a kmeans fit}

  \item{nrow}{the number of rows in the original dataset}
}
\value{
  The computed Hartigan Number
}
\description{
  Runs the computation found in
  http://www.stat.columbia.edu/~madigan/DM08/descriptive.ppt.pdf
}
\details{
  Not exported, only used by \code{\link{FitKmeans}}
}
\examples{
data(iris)
hartiganResults <- FitKMeans(iris[, -ncol(iris)])
PlotHartigan(hartiganResults)
}
\author{
  Jared P. Lander www.jaredlander.com
}
\references{
  http://www.stat.columbia.edu/~madigan/DM08/descriptive.ppt.pdf
}
\seealso{
  \code{\link{kmeans}} \code{\link{FitKMeans}}
}
\keyword{cluster}
\keyword{clustering}
\keyword{hartigan}
\keyword{kmeans}

