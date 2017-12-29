# caeasciiR

The aim of this package is to read, edit and write CAE input decks into/with R. Currently, the package focus lies in Optistruct and Nastran decks, but the ultimate goal is to cover some more.

## Installation

    devtools::install_github("eloytf/caeasciiR")
    
## Features

For non-R users, the main use today is to manage big text files, since it allows to isolate cards by type into include files.
R users may find other features useful, like the possibility to group cards with continuation lines into single lines, for easier regex.

## Imports

This package uses readr functions.
