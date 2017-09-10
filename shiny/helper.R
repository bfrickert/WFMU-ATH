list.of.packages <- c("dplyr", "plotly", "RPostgreSQL")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(plotly)
library(shiny)
library(RPostgreSQL)
library(dplyr)


dbname <-""
user <- ""
password <- scan(".pgpass", what="")
host <- "127.0.0.1"
con <- dbConnect(dbDriver("PostgreSQL"), user=user,
                 password=password, dbname=dbname, host=host, port=5432)

sql <- "select extract(month from logdate) mth, extract(year from logdate) yr, stream, sum(seconds) seconds, count(8) from (
select logdate, 
case when stream like ('do-or-diy%') then 'do-or-diy' when stream like 'freeform%' then 'freeform' when stream like 'drummer%' then 'drummer' when stream like 'ubu%' then 'ubu' when stream like 'ichiban%' then 'ichiban' end stream,
seconds
from wfmu.access_logs 
where seconds > 0) access_logs
where stream like ('do-or-diy%') or
stream like ('drummer%') or
stream like ('freeform%') or
stream like ('ichiban%') or
stream like ('ubu%')
group by mth,yr,stream
order by 2, 1, 3;"

aggr <- dbGetQuery(con, sql)

names(aggr) <- c('yr', 'mnth', 'channel', 'sum.ath', 'count.ath')
aggr$sum.ath <- as.numeric(aggr$sum.ath)/60/60
aggr$dt <- paste(aggr$yr, ' - ', aggr$mnth, sep='')

choices <- unique(paste(aggr$yr, ' - ', aggr$mnth, sep=''))
choices <- sort(choices, decreasing=T)

dbDisconnect(con)
