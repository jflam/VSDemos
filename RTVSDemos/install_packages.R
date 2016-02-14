
# Run this file the first time you use this project to ensure
# that all required R packages are installed on your machine.

# TODO: deprecate these packages

install.packages("ggmap")
install.packages("plyr")
install.packages("googleVis")
install.packages("sp")

install.packages("dplyr")
install.packages("knitr")
install.packages("rmarkdown")
install.packages("leaflet")
install.packages("DT")
install.packages("shiny")
install.packages("plotly")

suppressPackageStartupMessages(library(googleVis))
suppressPackageStartupMessages(library(ggmap))
suppressPackageStartupMessages(library(dplyr))

install.packages(c('rzmq', 'repr', 'IRkernel', 'IRdisplay'),
                 repos = c('http://irkernel.github.io/', getOption('repos')))