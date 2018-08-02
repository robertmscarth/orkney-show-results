# load in the tidyverse library
library(tidyverse)

wd = getwd()
dataFolder = "/Data/"
baseFilePath = paste( wd , dataFolder , sep="" )
indexFileName = "Index"

index = read_tsv( paste( baseFilePath , indexFileName , sep="" ) )

prizeWinners = filter( tibble(Year=0,Exhibitor="",Champion="",Name="",Notes="",Show="",SectionA="",SectionB="",Prize="") , FALSE )
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
