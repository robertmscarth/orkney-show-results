#load in the tidyverse library
library(tidyverse)

# This code asssumes that the working directory is set to the folder containing all the Orkney Show Results files and subfolders
wd = getwd()
entriesFolder = "/Data/Entries/"
baseFilePath = paste( wd , entriesFolder , sep="" )
genDataFolder = "/Data/Generated/"
DetailedNumEntriesFileName = "AggregatedEntries1.tsv"
NumEntriesByCatFileName = "AggregatedEntries2.tsv"
TotalEntriesFileName = "AggregatedEntries3.tsv"
outputFolder = "/Data/Generated/EntryTables/"
TotalByShowFileName = "TotalByShow.txt"

# Read in the tsv file containing the entries by class
DetailedNumEntries = read_tsv( paste( wd , genDataFolder , DetailedNumEntriesFileName , sep="" ) )
NumEntriesByCat = read_tsv( paste( wd , genDataFolder , NumEntriesByCatFileName , sep="" ) )
TotalEntries = read_tsv( paste( wd , genDataFolder , TotalEntriesFileName , sep="" ) )

# We create the following tables:
# (1) a table of total entries at each show for each year
# (2) a table for each show of total entries for each category and year
# (3) a table for each category at each show of total entries for each section within the category and year

# Create a table of total entries at each show for each year
# Get a list of all the shows and years
ShowList = TotalEntries %>% select(Show) %>% unique()
YearList = TotalEntries %>% select(Year) %>% unique() %>% arrange(desc(-1 * Year))

