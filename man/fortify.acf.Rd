\name{fortify.acf}
\alias{fortify.acf}
\title{fortify.acf}
\usage{
  \method{fortify}{acf} (x, ...)
}
\arguments{
  \item{x}{An \code{\link{acf}} object.}

  \item{\dots}{Other arguments}
}
\value{
  \code{\link{data.frame}} for plotting with ggplot.
}
\description{
  Fortify an acf/pacf object
}
\details{
  Prepares acf (and pacf) objects for plotting with ggplot.
}
\examples{
fortify(acf(sunspot.year, plot=FALSE))
fortify(pacf(sunspot.year, plot=FALSE))
}
\author{
  Jared P. Lander
}

