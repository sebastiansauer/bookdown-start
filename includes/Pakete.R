Pakete <- c("tidyverse", "readr", "knitr", "stringr", "car", "nycflights13", "ISLR", "pdftools", "downloader", "ggdendro", "gridExtra", "tm", "tidytext", "lsa", "SnowballC", "wordcloud", "RColorBrewer", "okcupiddata", "reshape2", "wesanderson", "GGally")

lapply(Pakete, require, character.only = TRUE)
