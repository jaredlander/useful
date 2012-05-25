\name{knitVector}
\alias{knitVector}
\title{do.knit}
\usage{
  knitVector(input, output = NULL, tangle = FALSE,
    text = NULL)
}
\arguments{
  \item{input}{Character vector of filenames (with path) to
  be knited.}

  \item{output}{Character vector of filenames (with path)
  for the output TeX.}

  \item{tangle}{Whether to tangle the R code from the input
  file (like Stangle)}

  \item{text}{A character vector as an alternative way to
  provide the input file}
}
\value{
  The compiled documents are written into the output files,
  and the paths of the output files are returned.
}
\description{
  Wrapper for knitr::knit
}
\details{
  This function is merely a vectorized wrapper for
  knitr::knit.  It knits Rnw files into tex files.
}
\examples{
# none here
}
\author{
  Jared P. Lander
}

