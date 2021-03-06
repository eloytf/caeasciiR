% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{bulk2expandedlines}
\alias{bulk2expandedlines}
\title{A Function for reading bulk data strings into expanded lines}
\usage{
bulk2expandedlines(string)
}
\arguments{
\item{string}{string with the bulk data.}
}
\value{
a character vector of expanded bulk lines.
}
\description{
This function allows you to read bulk data cards, returning a character vector with the expanded lines (no 72 char limit or continuation cards). All resulting continuation cards will start with "+".
}
\examples{


}
