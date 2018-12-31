# load in the tidyverse library
library(tidyverse)

# This code asssumes that the working directory is set to the folder containing all the Orkney Show Results files and subfolders
wd = getwd()
entriesFolder = "/Data/Entries/"
baseFilePath = paste( wd , entriesFolder , sep="" )
fileName = "ShowEntries"
mapFileName = "AggregationMaps.tsv"
sortOrderShowFileName = "SortOrder_Show"
sortOrderCategoryFileName = "SortOrder_Category"
outputFolder = "/Data/Generated/"
outputFileName1 = "AggregatedEntries1.tsv"
outputFileName2 = "AggregatedEntries2.tsv"

# Read in the tsv file containing the entries by class
entriesByClass = read_tsv( paste( baseFilePath , fileName , sep="" ) )

# Read in the aggregation maps
aggregationMaps = read_tsv( paste( baseFilePath , mapFileName , sep="" ) )

# Read in the sort orders for the outputs
sortOrderShow = read_tsv( paste( baseFilePath , sortOrderShowFileName , sep="" ) )
sortOrderCategory = read_tsv( paste( baseFilePath , sortOrderCategoryFileName , sep="" ) )

# Calculate the number of entries for each row of data
NumEntries <- entriesByClass %>% 
  mutate(NumEntries = `Last Entry` - `First Entry` + 1 + `Additional`)

# Add columns for aggregation classes
NumEntries <- NumEntries %>% 
  inner_join( aggregationMaps , by = c( "Show"="Show" , "Category"="Category" , "Section Name"="Section" ) )

# Group by Year, Show, "Aggregation 2", and "Aggregation 1" and then sum to get the totals
AggNumEntries1 <- NumEntries %>% 
  group_by(Year,Show,`Aggregation 2`,`Aggregation 1`) %>% 
  summarise(NumEntries=sum(NumEntries))
AggNumEntries2 <- AggNumEntries1 %>% 
  group_by(Year,Show,`Aggregation 2`) %>% 
  summarise(NumEntries=sum(NumEntries))

# Re-name the columns "Aggreation 1" and "Aggregation 2" to something more meaningful
AggNumEntries1 <- AggNumEntries1 %>% rename("Section"="Aggregation 1","Category"="Aggregation 2")
AggNumEntries2 <- AggNumEntries2 %>% rename("Category"="Aggregation 2")

# Sort the data
AggNumEntries1 <- AggNumEntries1 %>%
  arrange(desc(-1*Year))
AggNumEntries2 <- AggNumEntries2 %>%
  arrange(desc(-1*Year))

# Write out the aggregations to .tsv files
outputFilePath1 = paste( wd , outputFolder , outputFileName1 , sep="" )
outputFilePath2 = paste( wd , outputFolder , outputFileName2 , sep="" )
write_tsv( AggNumEntries1 , outputFilePath1 )
write_tsv( AggNumEntries2 , outputFilePath2 )

# For each show, create a graph showing the entries by year for each aggregation class
### do this in a separate script
