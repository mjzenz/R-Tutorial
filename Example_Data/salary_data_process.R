### This simple script reads in UW Madison public salary data, 
### removes names and creates a unique employee identifier.

salary.data <- readxl::read_excel("C:/Users/zenz/Downloads/salary_data.xlsx")
unique.names <- unique(salary.data[sample(1:nrow(salary.data)),c("First Name", "Last Name")])
unique.names$`Person Num` <- 1:nrow(unique.names)
salary.data <- merge(y = salary.data, 
                     x = unique.names, 
                     by = c("First Name", "Last Name"))[,c(-1,-2)]
salary.data <- salary.data[order(salary.data$`Person Num`),]

openxlsx::write.xlsx(salary.data, "Example_Data/salary_data.xlsx", rowNames = FALSE)
