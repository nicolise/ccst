#Nicole E Soltis
#05/29/2020

#dataclean_zips.R
#step one in data cleaning pipeline: long to wide for files from old system. 
#===================================================================================
#set up environment
rm(list=ls())
setwd("~/Projects/ccst")
#read in files
olddat <- read.csv("data/DataExtract_05282020_ed.csv")
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
#convert list to characters
mydist.zip$zip <- paste(mydist.zip$zip)
write.csv(mydist.zip, "data/mydist_withzips.csv")
#in excel, for column zip, remove c() and replace : with , 
#can also add quotes
#and save as .xls

#---------------------------------------------------------------------------------------------------------
#now combine zip data with DF ... do this later

myzip.w <- aggregate(zip ~ primary_city, data=myzip.mt, c)
myzip.w$CACITY <- toupper(myzip.w$primary_city)
myzip.w <- myzip.w[,c(3,2)]
#this will need slight reformatting in excel but otherwise okay
mydist.zip <- merge(mydist,myzip.w, by="CACITY")
#convert list to characters
mydist.zip$zip <- paste(mydist.zip$zip)
