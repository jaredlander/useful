\name{do.knit}
\alias{do.knit}
\title{do.knit}
\usage{
  do.knit(files)
}
\arguments{
  \item{files}{Name of files to be knitted, without
  extensions.}
}
\value{
  The compiled documents are written into the output files,
  and the path of the output files are returned.
}
\description{
  Wrapper for knitr::knit
}
\details{
  This function is merely an advanced wrapper wrapper for
  knitr::knit.  It knits the Rnw files into tex only if the
  Rnw files are newer than the tex files.  Like LaTex, file
  names should not be provided with extensions as it will
  added them automatically.
}
\examples{
# none here
}
\author{
  Jared P. Lander
}

