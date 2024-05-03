data <- read.csv("")

str(data)
head(data)
summary(data)

#na address
data_df %>%
  replace_na(list(year = 2001, sales + 0))
data_df %>%
  fill(year, .direction = 'downup') #down, up, downup, updown
data_df %>%
  drop_na(year)