#This is an R script

library(tidyverse)
library(readxl)
library(openxlsx)

setwd("~/R-Tutorial")

#Bring in salary data.
salary.data <- read_excel("Example_Data/salary_data.xlsx")

#This creates a table of job titles as rows, divisions as columns, 
##with median salary (counts) in cells

#Note that variable (column) names with spaces and special characters are surrounded with ``.
##Variable names without spaces or special characters don't need ``.
salary.fs.as.by.title.div <- salary.data %>%
              #Only include Academic Staff appointments that are full-time  
              filter(`Employee Category` == "AS" & `Full-time Equivalent` == 1) %>%
              #Only include Colleges with UGRD programs
              filter(Division %in% c("College of Ag & Life Science", 
                                     "School of Pharmacy",
                                     "College of Engineering",
                                     "School of Human Ecology",
                                     "School of Education",
                                     "College of Letters & Science",
                                     "School of Nursing",
                                     "Wisconsin School of Business")) %>%
              #Group by Title and Division
              group_by(Division, Title) %>%   
              #Use Summarize to find salary median (remove NAs) and counts
              summarize(median = median(`Annual Full Salary`, na.rm = TRUE), 
                        n = n()) %>% #Counts the number of rows
              #Create a new variable Combining salary (rounded to the dollar) 
              #and counts to in one cell. 
              mutate(median_n = paste(round(median, digits = 0), 
                                      " (", n, ")", sep = "")) %>%
              #Keeps only the Division, Title, and median_n columns
              select(Division, Title, median_n) %>%
              #pivots the data so that Divisions become the columns.
              pivot_wider(data = ., names_from = Division, values_from = median_n)