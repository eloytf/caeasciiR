% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{splitIntoIncludes}
\alias{splitIntoIncludes}
\title{A Function for writing a master and include files from a merged fem}
\usage{
splitIntoIncludes(file, mastername, sorted = F, asdf = F)
}
\arguments{
\item{file}{fem file}

\item{mastername}{name of the master to write}

\item{sorted}{if the cards need to be sorted in the include files (to diff, mostly)}
}
\value{
Nothing
}
\description{
This function allows you to split a merged fem into includes for each of the card types present in the bulk data section of the file. It removes comments.
}
\examples{


}
