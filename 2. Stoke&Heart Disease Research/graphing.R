library(plotly)
library(tidyverse)
library(orca)

data <- read.csv('Gen5_final_proportion_table.csv')
rownamedata <- read.csv('Gen5Proportional_table_2.csv')
rownames <- c()
for (j in 1:4){
  for (i in 1:(nrow(rownamedata))){
    rownames <- c(rownames,data.frame(rownamedata[i,1]))
  }
}
row.names(data)<- rownames

#data <- data[,-1] #finish arrange
vector <- c(rep('Age1',43),rep('Age3',43),rep('Age4',43),rep('Age5',43))
data[,paste0('table')] <- vector
colors <- c('#ffc425', '#d11141', '#00aedb', '#00b159')

scatplt <- plot_ly(data, x = ~proportion_0_0, y = ~proportion_1_0, z = ~proportion_0_1,
                   color = ~table,colors = colors ,size = ~proportion_1_1,
                   text = ~paste("0_0:",proportion_0_0,"<br>1_0:",proportion_1_0,
                                 "<br>0_1:",proportion_0_1,"<br>1_1:",proportion_1_1,
                                 "<br>",rownames),hoverinfo = "text")

scatplt <- scatplt %>%
  layout(scene = list(xaxis = list(title = '0_0'),
                      yaxis = list(title = '1_0'),
                      zaxis = list(title = '0_1')),
         showlegend = TRUE)
scatplt
htmlwidgets::saveWidget(as_widget(scatplt), "scatplt1.html")

scatplt2 <- plot_ly(data, x = ~proportion_0_1, y = ~proportion_1_0, z = ~proportion_0_1,
                   color = ~table ,colors = colors,size = ~proportion_1_1,text = ~paste(rownames), hoverinfo = "text")
  scatplt2 <- scatplt2 %>%
  layout(scene = list(xaxis = list(title = '0_1'),
                      yaxis = list(title = '1_0'),
                      zaxis = list(title = '0_1'),))
scatplt2
htmlwidgets::saveWidget(as_widget(scatplt2), "scatplt2.html")

