# load in the tidyverse library
library(tidyverse)

# This code asssumes that the working directory is set to the folder containing all the Orkney Show Results files and subfolders
wd = getwd()
entriesFolder = "/Data/Entries/"
baseFilePath = paste( wd , entriesFolder , sep="" )
genDataFolder = "/Data/Generated/"
DetailedNumEntriesFileName = "AggregatedEntries1.tsv"
NumEntriesByCatFileName = "AggregatedEntries2.tsv"
TotalEntriesFileName = "AggregatedEntries3.tsv"
outputFolder = "/TeX/Images/Graphs/"
TotalByShowFileName = "TotalByShow.png"
PlotWidth = 8.4
HeightRatio = 0.618
ShowList = c("County","Dounby")
YearList = c(2002:2018)
YearString = paste( min(YearList) , "-" , max(YearList) , sep="" )

# Read in the tsv file containing the entries by class
DetailedNumEntries = read_tsv( paste( wd , genDataFolder , DetailedNumEntriesFileName , sep="" ) )
NumEntriesByCat = read_tsv( paste( wd , genDataFolder , NumEntriesByCatFileName , sep="" ) )
TotalEntries = read_tsv( paste( wd , genDataFolder , TotalEntriesFileName , sep="" ) )

# For each show create a graph showing for each Catrgory the number of entries by year
# There will e a graph for each show
# Year will be the horizontal axis
# NumEntries will be the vertical axis
# There will be a line for each Category

# Create and save plot of total entries by show for the County and Dounby shows
TotalEntries <- TotalEntries %>% filter(Show %in% ShowList,Year %in% YearList)
PlotTitle = paste( "Total entries by show " , YearString , sep="" )
TotalPlot <- ggplot(data=TotalEntries , aes(Year,NumEntries)) + 
  geom_line(aes(colour=Show)) +
  geom_point(aes(colour=Show)) +
  expand_limits(y=0) +
  labs( title = PlotTitle , y="Entries" )
print("Saving total by show plot" )
ggsave( plot = TotalPlot , paste( wd , outputFolder , TotalByShowFileName , sep="" ) , width = PlotWidth , heigh = PlotWidth * HeightRatio )

# Create and save plot of entries by category for each show in ShowList
for (ShowName in ShowList){
  ShowEntries <- NumEntriesByCat %>% filter(Show==ShowName,Year %in% YearList,!is.na(Category))
  PlotTitle = paste( ShowName , " Show entries by category " , YearString , sep="" )
  ShowPlot <- ggplot(data=ShowEntries , aes(Year,NumEntries)) + 
    geom_line(aes(colour=Category)) +
    geom_point(aes(colour=Category)) +
    expand_limits(y=0) +
    labs( title = PlotTitle , y="Entries" )
  PlotFileName = paste( ShowName , "ByCategory.png", sep="" )
  print(paste( "Saving " , ShowName , " by category plot" , sep="" ) )
  ggsave( plot = ShowPlot , paste( wd , outputFolder , PlotFileName , sep="" ) , width = PlotWidth , heigh = PlotWidth * HeightRatio )
}

# Create detailed graphs for sections within each category
for(ShowName in ShowList){
  ShowNumEntries = DetailedNumEntries %>% filter(Show==ShowName,Year %in% YearList)
  ShowCategories = ShowNumEntries %>% select(Category) %>% unique()
  for(CatName in ShowCategories){
    CatNumEntries = ShowNumEntries %>% filter(Category==CatName)
    PlotTitle = paste( ShowName , " Show " , CatName , " entries by section " , YearString , sep="" )
    CatPlot <- ggplot(data=CatNumEntries , aes(Year,NumEntries)) + 
      geom_line(aes(colour=Section)) +
      geom_point(aes(colour=Section)) +
      expand_limits(y=0) +
      labs( title = PlotTitle , y="Entries" )
    PlotFileName = paste( ShowName , CatName , "BySection.png", sep="" )
    print(paste( "Saving " , ShowName , " " , CatName , " by section plot" , sep="" ) )
    ggsave( plot = CatPlot , paste( wd , outputFolder , PlotFileName , sep="" ) , width = PlotWidth , heigh = PlotWidth * HeightRatio )
  }
}
