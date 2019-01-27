# load in the tidyverse library
library(tidyverse)

# This code asssumes that the working directory is set to the folder containing all the Orkney Show Results files and subfolders
wd = getwd()
entriesFolder = "/Data/Entries/"
baseFilePath = paste( wd , entriesFolder , sep="" )
genDataFolder = "/Data/Generated/"
NumEntriesByCatFileName = "AggregatedEntries2.tsv"
TotalEntriesFileName = "AggregatedEntries3.tsv"
outputFolder = "/TeX/Images/Graphs/"
CountyEntriesFileName = "CountyByCategory.png"
DounbyEntriesFileName = "DounbyByCategory.png"
TotalByShowFileName = "TotalByShow.png"

# Read in the tsv file containing the entries by class
NumEntriesByCat = read_tsv( paste( wd , genDataFolder , NumEntriesByCatFileName , sep="" ) )
TotalEntries = read_tsv( paste( wd , genDataFolder , TotalEntriesFileName , sep="" ) )

# For each show create a graph showing for each Catrgory the number of entries by year
# There will e a graph for each show
# Year will be the horizontal axis
# NumEntries will be the vertical axis
# There will be a line for each Category

# Create and save plot of County show entries by category
CountyEntries <- NumEntriesByCat %>% filter(Show=="County",Year>=2002,!is.na(Category))
CountyPlot <- ggplot(data=CountyEntries , aes(Year,NumEntries)) + 
  geom_line(aes(colour=Category)) +
  geom_point(aes(colour=Category)) +
  expand_limits(y=0) +
  labs( title = "County Show entries by Category 2002-2018" , y="Entries" )
ggsave( plot = CountyPlot , paste( wd , outputFolder , CountyEntriesFileName , sep="" ) , width = 6 , heigh = 6 * 0.618 )

# Create and save plot of Dounby show entries by category
DounbyEntries <- NumEntriesByCat %>% filter(Show=="Dounby",Year>=2002,!is.na(Category))
DounbyPlot <- ggplot(data=DounbyEntries , aes(Year,NumEntries)) + 
  geom_line(aes(colour=Category)) +
  geom_point(aes(colour=Category)) +
  expand_limits(y=0) +
  labs( title = "Dounby Show entries by Category 2002-2018" , y="Entries" )
ggsave( plot = DounbyPlot , paste( wd , outputFolder , DounbyEntriesFileName , sep="" ) , width = 6 , heigh = 6 * 0.618 )

# Create and save plot of total entries by show for the County and Dounby shows
TotalEntries <- TotalEntries %>% filter(Show=="County"|Show=="Dounby",Year>=2002)
TotalPlot <- ggplot(data=TotalEntries , aes(Year,NumEntries)) + 
  geom_line(aes(colour=Show)) +
  geom_point(aes(colour=Show)) +
  expand_limits(y=0) +
  labs( title = "Total entries by show 2002-2018" , y="Entries" )
ggsave( plot = TotalPlot , paste( wd , outputFolder , TotalByShowFileName , sep="" ) , width = 6 , heigh = 6 * 0.618 )
