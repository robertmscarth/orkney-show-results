# load in the tidyverse library
library(tidyverse)

# This code asssumes that the working directory is set to the folder containing all the Orkney Show Results files and subfolders
wd = getwd()
dataFolder = "/Data/"
baseFilePath = paste( wd , dataFolder , sep="" )
indexFileName = "Index"
outputFolder = "/Data/Generated/"
outputFileName = "AllPrizeWinners.txt"

# Read in the index file which lists the text files containing the results
index = read_tsv( paste( baseFilePath , indexFileName , sep="" ) )

# Create an empty tibble with the required columns
prizeWinners = filter( tibble(Year=0,Exhibitor="",Champion="",Name="",Notes="",Show="",SectionA="",SectionB="",Prize="") , FALSE )
# Loop through the files listed in the index, read them in, and add them to the tibble just created
for(i in c(1:nrow(index))){
  relativeFilePath = paste( index$Show[[i]] , index$SectionA[[i]] , index$SectionB[[i]] , index$Prize[[i]] , sep="/" )
  pW = read_tsv( paste( baseFilePath , relativeFilePath , ".txt" , sep="" ) )
  pW = pW %>% mutate(
      Show = index$Show[[i]],
      SectionA = index$SectionA[[i]],
      SectionB = index$SectionB[[i]],
      Prize = index$Prize[[i]]
  )
  prizeWinners = union(prizeWinners,pW)
}

# Write out the full set of prize winners to a text file, with variables separated by tabs
outputFilePath = paste( wd , outputFolder , outputFileName , sep="" )
write_tsv( prizeWinners , outputFilePath )

# Get list of exhibitors
ExhibitorList = as_tibble(sort(unique(prizeWinners$Exhibitor)))
SplitExhibitorList = separate(ExhibitorList,value,sep=",",c("Name","Farm","Parish"))
