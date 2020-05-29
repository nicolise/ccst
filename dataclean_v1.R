#Nicole E Soltis
#05/29/2020

#dataclean_v1.R
#step one in data cleaning pipeline: long to wide for files from old system. 
#===================================================================================
#set up environment
rm(list=ls())
setwd("~/Projects/ccst")
#read in files
olddat <- read.csv("data/DataExtract_05282020.csv")
myzip <- read.csv("data/ziplookup_CAonly.csv")
mydist <- read.csv("data/CCDistrictOfficeList.csv")
head(mydist)
head(olddat)
head(myzip)

#match entity locations to zip codes
myzip$primary_city_match <- toupper(myzip$primary_city)
myzip.mt <- myzip[,c(1,4,13)]
names(myzip.mt)[1] <- "zip"
#make zips wide format
myzip.mt <- myzip.mt[,c(1,2)]
attach(myzip.mt)
myzip.w <- aggregate(zip ~ primary_city, data=myzip.mt, c)
myzip.w$CACITY <- toupper(myzip.w$primary_city)
myzip.w <- myzip.w[,c(3,2)]
#this will need slight reformatting in excel but otherwise okay
mydist.zip <- merge(mydist,myzip.w, by="CACITY")
#need to write this out correctly!!
write.csv(mydist.zip, "data/mydist_withzips.csv")
#in excel, for column zip, remove c() and replace : with , and add quotes

#aggregate olddat so that only one row per permit
#remove business info and summarize the rest- remove duplicate rows
shortdat <- olddat[,c(1:27)]
library(dplyr)
shortdat1 <- distinct(shortdat)
#only 53 lines yay!

#need to fix this: get a list of NAICS codes all tidy. And a list of business names, maybe.
aggdat <- olddat[,c(14,28,29,30)] #will use column 14 to merge with shortdat1
aggdat$naicscode <- as.character(aggdat$naicscode)
aggdat.w1 <- aggregate(name.1 ~ Www, data=aggdat, c)
aggdat.w2 <- aggregate(naicscode ~ Www, data=aggdat, c)
library(plyr)
aggdat.w3 <- ddply(aggdat, .(Www), summarise, naics = naicscode)
aggdat.w4 <- ddply(aggdat, .(Www), summarise, busname = list(as.character(name.1)))
#sub out c(, ), ", \, space
# aggdat.w3$naics <- gsub('c(','', aggdat.w3$naics)
# aggdat.w3$naics <- gsub(')','', aggdat.w3$naics)
# aggdat.w3$naics <- gsub('"','', aggdat.w3$naics)
# aggdat.w3$naics <- gsub('"\"','', aggdat.w3$naics)
# do this in excel for now

aggdat.all <- merge(aggdat.w3, aggdat.w4, by='Www')
shortdat.full <- merge(shortdat1, aggdat.all, by="Www")
shortdat.final <- shortdat.full
shortdat.final$naics <- as.character(shortdat.final)
write.csv(as.character(shortdat.full), "data/cleandata_set001_draft1.csv")
