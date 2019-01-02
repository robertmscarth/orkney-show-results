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
outputFileName3 = "AggregatedEntries3.tsv"

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
  filter( `Aggregation 1` != "NA" ) %>%
  group_by(Year,`Aggregation 3`,`Aggregation 2`,`Aggregation 1`) %>% 
  summarise(NumEntries=sum(NumEntries))
AggNumEntries2 <- AggNumEntries1 %>%
  filter( `Aggregation 2` != "NA" ) %>%
  group_by(Year,`Aggregation 3`,`Aggregation 2`) %>% 
  summarise(NumEntries=sum(NumEntries))
AggNumEntries3 <- AggNumEntries2 %>%
  filter( `Aggregation 3` != "NA" ) %>%
  group_by(Year,`Aggregation 3`) %>%
  summarise(NumEntries=sum(NumEntries))

# Re-name the columns "Aggreation 1", "Aggregation 2", and "Aggregation 3" to something more meaningful
AggNumEntries1 <- AggNumEntries1 %>% rename("Show"="Aggregation 3","Section"="Aggregation 1","Category"="Aggregation 2")
AggNumEntries2 <- AggNumEntries2 %>% rename("Show"="Aggregation 3","Category"="Aggregation 2")
AggNumEntries3 <- AggNumEntries3 %>% rename("Show"="Aggregation 3")

# add columns for the sort order
AggNumEntries1 <- AggNumEntries1 %>%
  inner_join( sortOrderShow , "Show" = "Show" ) %>%
  inner_join( sortOrderCategory , "Category" = "Category" )
AggNumEntries2 <- AggNumEntries2 %>%
  inner_join( sortOrderShow , "Show" = "Show" ) %>%
  inner_join( sortOrderCategory , "Category" = "Category" )
AggNumEntries3 <- AggNumEntries3 %>%
  inner_join( sortOrderShow , "Show" = "Show" )

# Sort the data and remove the columns containing the sort order
AggNumEntries1 <- AggNumEntries1 %>%
  arrange( desc( -1*ShowOrder ) , desc( -1*Year ) , desc( -1*CatOrder ) ) %>%
  select( -ShowOrder , -CatOrder )
AggNumEntries2 <- AggNumEntries2 %>%
  arrange( desc( -1*ShowOrder ) , desc( -1*Year ) , desc( -1*CatOrder ) ) %>%
  select( -ShowOrder , -CatOrder )
AggNumEntries3 <- AggNumEntries3 %>%
  arrange( desc( -1*ShowOrder ) , desc( -1*Year ) ) %>%
  select( -ShowOrder )

# Write out the aggregations to .tsv files
outputFilePath1 = paste( wd , outputFolder , outputFileName1 , sep="" )
outputFilePath2 = paste( wd , outputFolder , outputFileName2 , sep="" )
outputFilePath3 = paste( wd , outputFolder , outputFileName3 , sep="" )
write_tsv( AggNumEntries1 , outputFilePath1 )
write_tsv( AggNumEntries2 , outputFilePath2 )
write_tsv( AggNumEntries3 , outputFilePath3 )
