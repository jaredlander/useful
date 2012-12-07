\name{build.x}
\alias{build.x}
\title{build.x}
\usage{
  build.x(formula, data)
}
\arguments{
  \item{formula}{A formula}

  \item{data}{A data.frame}
}
\value{
  A matrix of the predictor variables specified in the
  formula
}
\description{
  Build the x matrix for a glmnet model
}
\details{
  Given a formula and a data.frame build the predictor
  matrix
}
\examples{
require(ggplot2)
head(mpg)
head(build.x(hwy ~ class + cyl + year, data=mpg))
}
\author{
  Jared P. Lander
}

