library(readr)

cards<-read_lines("./data/cards.txt")
ffcards<-read_lines("./data/FFcards.txt")
# fixedentities<-fem[getCardName(fem) %in% ffcards]
# unsupported<-fem[!getCardName(fem) %in% ffcards]
# readFemLines <- function(file,nchars) {
# 	test<-readChar(file, nchars)
# 	test<-gsub(pattern = "\\r\\n",replacement = "\r",test,perl = T)
# 	subbed<-gsub(pattern = "\\r(\\+| )",replacement = " ",test, perl=T)
# 	unlisted<-unlist(strsplit(subbed,split = "\\r"))
# 	return(unlisted)
# }
# readrFemLines <- function(file) {
#   test<-readr::read_file(file)
#   test<-gsub(pattern = "\\r\\n",replacement = "\r",test,perl = T)
#   subbed<-gsub(pattern = "\\r(\\+| )",replacement = " ",test, perl=T)
#   unlisted<-unlist(strsplit(subbed,split = "\\r"))
#   return(unlisted)
# }
#' A Function for reading fem files
#'
#' This function allows you to read fem files, returning a character vector of size 3: case, bulk and comments after ENDDATA.
#' @param file file to read
#' @return a character vector of case, bulk, and comments after enddata. Size <=3
#' @export
#' @examples
#'
#'
femtoCaseBulk <- function (file) {
  input<-readr::read_file(file)
  input<-unlist(strsplit(input,split="(BEGIN BULK)"))
  if (length(input)==1) {
    case<-""
    bulk<-input[1]
    # this function cannot read only subcases
  } else {
    case<-input[1]
    bulk<-input[2]
  }
  bulk<-unlist(strsplit(bulk,split="(ENDDATA)"))
  if (length(bulk)==2) {

    bulk<-bulk[1]
    endcomments<-bulk[2]
    
    
  } else {
    endcomments<-""
  }
  return(c(case,bulk,endcomments))
}
#' A Function for reading bulk data strings into expanded lines
#'
#' This function allows you to read bulk data cards, returning a character vector with the expanded lines (no 72 char limit or continuation cards). All resulting continuation cards will start with "+". 
#' @param string string with the bulk data.
#' @return a character vector of expanded bulk lines.
#' @export
#' @examples
#'
#'
bulk2expandedlines<-function(string) {
  # test<-gsub(pattern = "\\r\\n",replacement = "\r",string,perl = T)
  subbed<-gsub(pattern = "\\r\\n(\\+| )",replacement = "+",string, perl=T)
  unlisted<-unlist(strsplit(subbed,split = "\\r\\n"))
  return(unlisted)
}
#' A Function for removing commented lines from a character vector of expanded bulk lines.
#'
#' This function allows you remove commented lines, returning a character vector of the non-commented lines
#' @param lines character vector with the bulk lines
#' @return a character vector of non-commented bulk lines.
#' @export
#' @examples
#'
#'
removeComments<-function(lines) {
  return(lines[grep("(^$)|(^\\$)",lines,invert=T,perl=T)])
}
#' A Function for extracting card images from lines
#'
#' This function allows you remove commented lines, returning a character vector of the non-commented lines
#' @param lines character vector with expanded bulk lines 
#' @return a character vector card images/names
#' @export
#' @examples
#'
#'
getCardName<-function(lines) {
  return(gsub("^(\\w{1,8}?\\b).*?$","\\1",substring(lines,first = 1,last = 8),perl = T))
}
#' A Function for extracting unique card images from bulk lines
#'
#' This function extracts the unique cards from a character vector of expanded lines
#' @param lines character vector with expanded bulk lines 
#' @return a character vector with the unique card images/names
#' @export
#' @examples
#'
#'
getUniqueCards <-function(lines) {
  uncommented<-lines[grep("(^$)|(^\\$)",lines,invert=T,perl=T)]
  return(gsub("^(\\w{1,8}?\\b).*?$","\\1",unique(substring(uncommented,first = 1,last = 8))))
}

getShortCards<-function(lines) {
  shCards<-lines[getCardName(lines)%in%ffcards]
  return(shCards)
}
getUnsupportedCards<-function(lines) {
  shCards<-lines[!getCardName(lines)%in%ffcards]
  return(shCards)
}

#' A Function for writing bulk data strings from expanded lines
#'
#' This function allows you to use expanded lines and rerturn bulk data strings. Continuation cards must start with "+" for this function to work.
#' @param lines expanded lines.
#' @return a string in bulk data format.
#' @export
#' @examples
#'
#'
expandedlines2bulk<-function(lines) {
  test<-gsub("\\+","\r\n+",lines,perl = T)
  test<-paste(test,collapse = "\r\n")
  return(test)
}

#' A Function for writing a master and include files from a merged fem and a vector of card names
#'
#' This function allows you split a merged fem into a master plus a include file with the selected type of cards
#' @param ocards cards to be moved
#' @param includename includename
#' @param mastername mastername
#' @return Nothing
#' @export
#' @examples
#'
#'
# ocards<-c("CHEXA","GRID")
# includename<-"gridhexa.dat"
# file<-"./tests/v287_nocomm_abq_RBE2_3_nC2_cntstb.fem"
writeInclude<-function (file,ocards,includename,mastername){

  fem<-femtoCaseBulk(file)
  
  bulklines<-bulk2expandedlines(fem[2])
  bulk<-expandedlines2bulk(bulklines[!getCardName(bulklines)%in%ocards])
  write_file(paste0(fem[1],"BEGIN BULK","\rINCLUDE ",includename,bulk,"\rENDDATA"),"test.fem")
  write_lines(expandedlines2bulk(bulklines[getCardName(bulklines)%in%ocards]),includename)  
  
}
#' A Function for writing a master and include files from a merged fem
#'
#' This function allows you to split a merged fem into includedes for each of the card types present in the bulk data section of the file. It removes comments.
#' @param file fem file
#' @param mastername name of the master to write
#' @param sorted if the cards need to be sorted in the include files (to diff, mostly)
#' @return Nothing
#' @export
#' @examples
#'
#'
splitIntoIncludes<-function(file,mastername,sorted=F) {
  
  fem<-femtoCaseBulk(file)
  bulklines<-bulk2expandedlines(fem[2])
  ocards<-getUniqueCards(bulklines)
  bulklines<-removeComments(bulklines)
  if (sorted) { 
    bulklines<-bulklines[order(bulklines)]
  }
  for (cards in ocards) {
    
    includename<-paste0(cards,".dat")
    write_lines(expandedlines2bulk(bulklines[getCardName(bulklines)%in%cards]),includename) 
      
  }
  bulk<-expandedlines2bulk(bulklines[!getCardName(bulklines)%in%ocards])
  write_file(paste0(fem[1],"BEGIN BULK\r\n",paste0(paste0("INCLUDE ","'",ocards,".dat","'"),collapse = "\r\n"),bulk,"\r\nENDDATA"),mastername)
  # write_lines(ocards,mastername)
  
}

#' A Function for 
#'
#' This function allows you 
#' @param file fem file
#' @param mastername name of the master to write
#' @param sorted if the cards need to be sorted in the include files (to diff, mostly)
#' @return Nothing
#' @export
#' @examples
#'
#'
linesToDF<-function(lines,numberOfFields) {
  
  df<-paste0(lines,collapse = "\n")
  df<-read_fwf(df,fwf_widths(rep(8,numberOfFields)))
  return(df)  
  
}
