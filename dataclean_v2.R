#Nicole E Soltis
#05/29/2020

#dataclean_v1.R
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

#----------------------------------------------------------
#now, shorten main data entry for data cleaning
#aggregate olddat so that only one row per permit
#remove business info and summarize the rest- remove duplicate rows
shortdat <- olddat[,c(1:27)]
library(dplyr)
shortdat1 <- distinct(shortdat)
#only 53 lines yay!

#now, get a tidy NAICS/ business types list
#need to fix this: get a list of NAICS codes all tidy. And a list of business names, maybe.
aggdat <- olddat[,c(14,28,29,30)] #will use column 14 to merge with shortdat1
#turn everything into characters
aggdat$naicscode <- as.character(aggdat$naicscode)
aggdat$name <- as.character(noquote(aggdat$name.1))
#try removing quotes before aggregating
aggdat.w1 <- aggregate(name ~ Www, data=aggdat, c)
aggdat.w2 <- aggregate(naicscode ~ Www, data=aggdat, c)
aggdat.test <- merge(aggdat.w1, aggdat.w2, by="Www")
#turn lists to characters
aggdat.test$name <- paste(aggdat.test$name)
aggdat.test$naicscode <- paste(aggdat.test$naicscode)
#write.csv(aggdat.test, "data/aggdat_set1_test.csv") #this mostly works if you remove quotes and slashes and fix commas after. and remove NULLs. BUT some NAICS data entry seems wrong
#fixed NAICS data entry in ---...-ed.csv file: some NAICS had reformatted to scientific notation

#------------------------------------------------------------------------------------------------------
#sub out c(, ), ", \, space
# aggdat.w3$naics <- gsub('c(','', aggdat.w3$naics)
# aggdat.w3$naics <- gsub(')','', aggdat.w3$naics)
# aggdat.w3$naics <- gsub('"','', aggdat.w3$naics)
# aggdat.w3$naics <- gsub('"\"','', aggdat.w3$naics)
# do this in excel for now

shortdat.full <- merge(shortdat1, aggdat.test, by="Www")
#shortdat.final <- shortdat.full
#shortdat.final$naics <- as.character(shortdat.final)
#testdat <- as.character(shortdat.full)

#fix up testdat column orders for template
cleandat <- shortdat.full[,c(4,5,15,18,9,7,8,11,12,13,26,29)]

write.csv(cleandat, "data/cleandata_set001_draft3.csv")

#---------------------------------------------------------------------------------------------------------
#now combine zip data with DF ... do this later

myzip.w <- aggregate(zip ~ primary_city, data=myzip.mt, c)
myzip.w$CACITY <- toupper(myzip.w$primary_city)
myzip.w <- myzip.w[,c(3,2)]
#this will need slight reformatting in excel but otherwise okay
mydist.zip <- merge(mydist,myzip.w, by="CACITY")
#convert list to characters
mydist.zip$zip <- paste(mydist.zip$zip)
