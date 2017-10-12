#' A Function for writing Optistruct Files from character vectors
#'
#' This function allows you to write an OptiStruct file from a character vector of the kind returned from readFemLines.R
#' @param file file to write
#' @param x character vector
#' @return nothing
#' @export
#' @examples
#'
#'
readFemLines <- function(file,nchars) {

	test<-readChar(file, nchars)
	test<-gsub(pattern = "\\r\\n",replacement = "\r",test)
	subbed<-gsub(pattern = "\\r(\\+| )",replacement = " ",test)
	unlisted<-unlist(strsplit(subbed,split = "\\r"))
	return(unlisted)

}

writeFemLines <- function(file, x) {



}
