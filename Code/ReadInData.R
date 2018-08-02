# load in the tidyverse library
library(tidyverse)

wd = getwd()
dataFolder = "/Data/"
baseFilePath = paste( wd , dataFolder , sep="" )
indexFileName = "Index"

index = read_tsv( paste( baseFilePath , indexFileName , sep="" ) )

i = 1
relativeFilePath = paste( index$Show[[i]] , index$SectionA[[i]] , index$SectionB[[i]] , index$Prize[[i]] , sep="/" )

prizeWinners = read_tsv( paste( baseFilePath , relativeFilePath , ".txt" , sep="" ) )
