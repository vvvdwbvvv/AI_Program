library(tidyverse)
library(ggplot2)
library(magrittr)
library(fastDummies)

getwd()
setwd("/Users/eddietsai/Documents/GitHub/Entropy/Entropy")
data <- read.csv("recodedata23.csv")

#build dataframe for each agegp
df_list <- list()
df_list <- lapply(1:5,function(age_group){
  df_subset <- data %>%
    subset(GenHlth == 5 & Agegp == age_group) %>%
    unite("y", HeartDiseaseorAttack, Stroke) %>%
    select(-c(GenHlth, Agegp)) %>%
    select(y, everything())

  df_subset <- cbind(df_subset[, -1], df_subset[, 1])
  colnames(df_subset)[20]<-'y'
  df_subset <- df_subset[,-1]
  df_list[[as.character(age_group)]] <- df_subset
  return(df_subset)
})

##establish contingency table
combined_tables_list <- list()
proportion_tables_list <- list()
for (j in 1:5){
  column_name <- data.frame(combn(colnames(df_list[[j]][, -19]),1))
  varlist <- list()
  combined_table_rowname <- c()
  contingency_tables <- list()

  for (i in 1:ncol(column_name)) {
    varname <- paste(column_name[[i]])
    varlist[[i]] <- df_list[[j]] %>%
      select((!!varname), y)

    if (nrow(varlist[[i]]) == 0) next    ##if dataframe has no data, the program will continue

    x <- data.frame(varlist[[i]][, 1])
    colnames(x) <- colnames(varlist[[i]])[1]
    d <- dummy_cols(x)
    d <- d[, -1]
    contingency_tables[[i]] <- table(varlist[[i]][, 1], varlist[[i]][, 2])
    combined_table_rowname <- c(combined_table_rowname, colnames(d))
  }
  if (length(contingency_tables) == 0) next    ##if contingency tables has no data, the program will continue

  combined_table <- do.call(rbind, contingency_tables)
  rownames(combined_table) <- combined_table_rowname
  combined_table %<>% as.data.frame()

  combined_tables_list[[paste("Combined_Table_", j, sep = "")]] <- combined_table
  output_file <- paste("Gen5EveryAge_table_", j, ".csv", sep = "")
  write.csv(combined_table, file = output_file, row.names = TRUE)
  ##export valid contingency table for each Agegp
  ##store the united tables in a list
}

##calculating proportions and add it to contingency tabless
for (j in 1:4){
  proportion_table <- c()
  for (k in 1:4) {
    prop <- vector()
    colname <- colnames(combined_tables_list[[j]])[k]
    for (i in 1:(nrow(combined_tables_list[[j]]))) {
      row <- combined_tables_list[[j]][i,1:4]
      cell <- combined_tables_list[[j]][i, k]
      proportions <- cell / sum(row)
      prop <- c(prop, proportions)
    }
    combined_tables_list[[j]][, paste0("proportion_",colname)] <- prop
  }
}

proportion_tables_list <- list()
for (j in 1:4) {
  proportion_table <- combined_tables_list[[j]][, (ncol(combined_tables_list[[j]]) - 3):ncol(combined_tables_list[[j]])]
  proportion_tables_list[[paste("Proportion_Table_", j, sep = "")]] <- proportion_table
}

for (i in 1:4){
  output_file <- paste("Gen5Proportional_table_", i, ".csv", sep = "")
  write.csv(proportion_tables_list[[i]], file = output_file, row.names = TRUE)
}

final_proportion_table <- do.call(rbind, proportion_tables_list)
output_file <- paste("Gen5_final_proportion_table",".csv", sep = "")
write.csv(final_proportion_table, file = output_file, row.names = TRUE)


##simulation
impData <- do.call(cbind, varlist)
impData <- impData[, -seq(4, ncol(impData), 2)]
head(colnames(impData))
############################## null sim_ent##################################

varone_null <- function(impData) {
  siment <- vector()
  for (var in colnames(impData %>% select(-y))) {
    ent <- go_alter(impData, var)
    siment <- c(siment, ent)
  }
  return(siment)
}

obs_null <- replicate(1000, varone_null(impData))
dim(obs_null)
rownames(obs_null) <- combined_table_rowname
write.csv(obs_null, "Gen5Age3_1f_Null_sim_ent.csv")

############################## alt sim_ent##################################

varone_alter <- function(impData) {
  siment <- vector()
  for (var in colnames(impData %>% select(-y))) {
    ent <- go(impData, var)
    siment <- c(siment, ent)
  }
  return(siment)
}

obs_alter <- replicate(1000, varone_alter(impData))
dim(obs_alter)
rownames(obs_alter) <- combined_table_rowname
write.csv(obs_alter, "Gen5Age3_1f_Alter_sim_ent.csv")