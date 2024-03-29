% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/copycat_code.R
\name{copycat}
\alias{copycat}
\title{Copy code from CopyCat.}
\usage{
copycat(x, data = CopyCatCode, run = FALSE)
}
\arguments{
\item{x}{A search string}

\item{data}{Data}

\item{run}{TRUE or FALSE}
}
\value{
A string
}
\description{
`copycat()` uses a text string to search and copy
a code snippet to your clipboard.
It expects a data frame with three columns. A column
with the package name (package), a function (fun), and one with
the code (code) to copy. If data = NULL, the package search in the
the internal data `CopyCatCode`.
}
