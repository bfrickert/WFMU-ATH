list.of.packages <- c("dplyr", "plotly")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(dplyr)
library(plotly)
library(shiny)

aggr <- read.csv('data/spark.aggregate.csv', sep=',', stringsAsFactors = F, header=T)
names(aggr) <- c('yr', 'mnth', 'channel', 'sum.ath', 'count.ath')
aggr <- filter(aggr, !(is.na(yr)) & !grepl('.xsl', channel) & 
                 !grepl('.aac', channel) & !grepl('admin/', channel) & 
                 !grepl('.png', channel) & !grepl('.jpg', channel) &
                 !grepl('.css', channel) & !grepl('.html', channel) &
                 !grepl('.php', channel) & !grepl('.txt', channel) & 
                 !grepl('.aspx', channel) & !grepl('.smi', channel) & 
                 !grepl('.htm', channel) & !grepl('.ico', channel) & 
                 !grepl('.xml', channel) & sum.ath > 100)
aggr <- group_by(aggr, yr, mnth, channel) %>% 
  summarise(sum.ath = sum(as.numeric(sum.ath)), count.ath = sum(as.numeric(count.ath))) %>% 
  data.frame()
aggr$sum.ath <- as.numeric(aggr$sum.ath)/60/60
aggr$dt <- paste(aggr$yr, ' - ', aggr$mnth, sep='')

choices <- unique(paste(aggr$yr, ' - ', aggr$mnth, sep=''))
choices <- sort(choices, decreasing=T)

counts.by.channel <- read.csv('data/counts.by.channel.aws.csv', stringsAsFactors = F, header=F)
names(counts.by.channel) <- c('dt', 'hr', 'channel', 'cnt')
counts.by.channel <- group_by(counts.by.channel, dt, hr, channel) %>% 
  summarise(cnt = sum(cnt)) %>% 
  data.frame()
counts.by.channel$yr.mnth <- paste(substr(counts.by.channel$dt, 1,4), as.integer(substr(counts.by.channel$dt, 6,7)), sep=' - ')

unique(aggr$channel)
