# caeasciiR

The aim of this package is to read, edit and write CAE input decks into/with R. Currently, the package focus lies in Optistruct and Nastran decks, but the ultimate goal is to cover some more.

## Installation

    devtools::install_github("eloytf/caeasciiR")
    
## Features

For non-R users, the main use today is to manage big text files, since it allows to isolate cards by type into include files.
R users may find other features useful, like the possibility to group cards with continuation lines into single lines, for easier regex.
These are main functions/features

* femtoCaseBulk: reads fem files
* bulk2expandedlines: reads bulk string into expanded lines
* removeComments: Removes commented lines
* linesToDF: reads lines vector into data frame
* dfTolines: prints data frame into vector of lines
* expandedlines2bulk: collapses lines vector into bulk string.

* writeInclude: moves cards of certain types into an include and writes a master.
* splitIntoIncludes: splits merged fem into a file with include structure, one include file per card. Can be used to test the processing functions.

## Imports

This package uses readr functions.
