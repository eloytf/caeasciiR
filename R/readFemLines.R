#' A Function for reading Optistruct Files
#'
#' This function allows you to read the first characters (nchars) of a file, returning a character vector of optistruct cards
#' @param file file to read
#' @param nchars number of characters
#' @return a character vector with Optistruct cards
#' @export
#' @examples
#' 
#' 
readFemLines <- function(file,nchars) {
	
	test<-readChar(file, nchars)
	test<-gsub(pattern = "\\r\\n",replacement = "\r",test)
	subbed<-gsub(pattern = "\\r(\\+| )",replacement = " ",test)
	return(subbed)

}
