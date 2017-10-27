
library(dplyr)

# split original file into 10 waves 
full <- read.csv("T1-10-active-clean.csv")
for (i in 1:10){
  write.csv(full[,(1+25*(i-1)):(25*i)],paste("wave",i,"ori.csv",sep=""),row.names = F)
}

# prepare 
head <- paste("item",c(1:6,8:20,22:24,"7r","21r","25r"),sep="")
rowName <- c() # abnormal matrix
length(rowName) <- 20
rowName[seq(1,19,2)] <- paste("wave",1:10,"-original",sep="")
rowName[seq(2,20,2)] <- paste("wave",1:10,"-alternative",sep="")
abnormals <- matrix(NA,nrow=20,ncol=3)
row.names(abnormals) <- rowName
colnames(abnormals) <- c("conduct","hyper","prosocial")
changingRate<-matrix(NA,nrow=10,ncol=3) # change rate matrix
row.names(changingRate) <-paste("wave",1:10,sep="")
colnames(changingRate) <- c("conduct","hyper","prosocial")


# Hughes original file reverse coded 7 21 25, upon that now reverse code 11 14
for (i in 1:10){
  nam <- paste("wave",i,"ori.csv",sep="") # with missing data
  nam.r <- paste("wave",i,"r.csv",sep="") # reverse code two more variables 11 and 14
  dat <- read.csv(nam,header=T)
  colnames(dat) <-head 
  dat %>% mutate(item11r=2-item11) %>% mutate(item14r=2-item14) %>% write.csv(nam.r,row.names=F)
  dats <- read.csv(nam.r)
  # clean up to SDQ official R syntax colnames
  dats <- rename(dats, 
                 tconsid=item1,
                 trestles=item2,
                 tsomatic=item3,
                 tshares=item4,
                 ttantrum=item5,
                 tloner=item6,
                 uobeys=item7r,
                 tworries=item8,
                 tcaring=item9,
                 tfidgety=item10,
                 ufriend=item11r,
                 tfights=item12,
                 tunhappy=item13,
                 upopular=item14r,
                 tdistrac=item15,
                 tclingy=item16,
                 tkind=item17,
                 tlies=item18,
                 tbullied=item19,
                 thelpout=item20,
                 ureflect=item21r,
                 tsteals=item22,
                 toldbest=item23,
                 tafraid=item24,
                 uattends=item25r
                )
  dats <- select(dats,-c(item11,item14))
  datAlts <- dats
  
  # scoring 
  df.temotion <- select(dats, c(tsomatic, tworries, tunhappy, tclingy, tafraid))
  tnemotion <- apply(df.temotion, 1, function(x) sum(is.na(x)))
  temotion <- ifelse(tnemotion<3, rowMeans(df.temotion, na.rm=TRUE), NA)
  temotion <- as.numeric(temotion) * 5
  temotion <- floor(0.5 + temotion)
  
  df.tconduct <- select(dats, c(ttantrum, uobeys, tfights, tlies, tsteals))
  tnconduct <- apply(df.tconduct, 1, function(x) sum(is.na(x)))
  tconduct <- ifelse(tnconduct<3, rowMeans(df.tconduct, na.rm=TRUE), NA)
  tconduct <- as.numeric(tconduct) * 5
  tconduct <- floor(0.5 + tconduct)
  
  df.thyper <- select(dats,c(trestles, tfidgety, tdistrac, ureflect, uattends))
  tnhyper <- apply(df.thyper, 1, function(x) sum(is.na(x)))
  thyper <- ifelse(tnhyper<3, rowMeans(df.thyper, na.rm=TRUE), NA)
  thyper <- as.numeric(thyper) * 5
  thyper <- floor(0.5 + thyper)
  
  df.tpeer <- select(dats,c(tloner, ufriend, upopular, tbullied, toldbest))
  tnpeer <- apply(df.tpeer, 1, function(x) sum(is.na(x)))
  tpeer <- ifelse(tnpeer<3, rowMeans(df.tpeer, na.rm=TRUE), NA)
  tpeer <- as.numeric(tpeer) * 5
  tpeer <- floor(0.5 + tpeer)
  
  df.tprosoc <- select(dats,c(tconsid, tshares, tcaring, tkind, thelpout))
  tnprosoc <- apply(df.tprosoc, 1, function(x) sum(is.na(x)))
  tprosoc <- ifelse(tnprosoc<3, rowMeans(df.tprosoc, na.rm=TRUE), NA)
  tprosoc <- as.numeric(tprosoc) * 5
  tprosoc <- floor(0.5 + tprosoc)
  
  
  dats$emotion <- temotion
  dats$conduct <- tconduct
  dats$hyper<- thyper
  dats$peer <-tpeer
  dats$prosocial <- tprosoc
  
  # recode to normal borderline abnormal
  attach(dats)
  dats$pred.emotion[emotion>=6] <- "abnormal"
  dats$pred.emotion[emotion==5] <- "borderline"
  dats$pred.emotion[emotion<=4] <- "normal"
  
  dats$pred.conduct[conduct>=4] <- "abnormal"
  dats$pred.conduct[conduct==3] <- "borderline"
  dats$pred.conduct[conduct<=2] <- "normal"
  
  dats$pred.hyper[hyper>=7] <- "abnormal"
  dats$pred.hyper[hyper==6] <- "borderline"
  dats$pred.hyper[hyper<=5] <- "normal"
  
  dats$pred.peer[peer>=5] <- "abnormal"
  dats$pred.peer[peer==4] <- "borderline"
  dats$pred.peer[peer<=3] <- "normal"
  
  dats$pred.prosocial[prosocial<=4] <- "abnormal"
  dats$pred.prosocial[prosocial==5] <- "borderline"
  dats$pred.prosocial[prosocial>=6] <- "normal"
  detach(dats)
  
  write.csv(dats,paste("wave",i,"score.csv",sep=""),row.names = F)
  
  
  # alternative scoring 
  df.tconduct <- select(datAlts, c(ttantrum, uobeys, tfights, tlies, tsteals, tconsid)) # item 1
  tnconduct <- apply(df.tconduct, 1, function(x) sum(is.na(x)))
  tconduct <- ifelse(tnconduct<3, rowMeans(df.tconduct, na.rm=TRUE), NA)
  tconduct <- as.numeric(tconduct) * 5
  tconduct <- floor(0.5 + tconduct)
  
  df.thyper <- select(datAlts,c(trestles, tfidgety, tdistrac, ureflect, uattends, tconsid, uobeys)) # item 1 & 7
  tnhyper <- apply(df.thyper, 1, function(x) sum(is.na(x)))
  thyper <- ifelse(tnhyper<3, rowMeans(df.thyper, na.rm=TRUE), NA)
  thyper <- as.numeric(thyper) * 5
  thyper <- floor(0.5 + thyper)
  
  df.tprosoc <- select(datAlts,c(tconsid, tshares, tcaring, tkind, thelpout, uobeys, ureflect, upopular)) # item 7 14 21
  tnprosoc <- apply(df.tprosoc, 1, function(x) sum(is.na(x)))
  tprosoc <- ifelse(tnprosoc<3, rowMeans(df.tprosoc, na.rm=TRUE), NA)
  tprosoc <- as.numeric(tprosoc) * 5
  tprosoc <- floor(0.5 + tprosoc)
  
  datAlts$conduct <- tconduct
  datAlts$hyper<- thyper
  datAlts$prosocial <- tprosoc
  
  attach(datAlts)
  datAlts$pred.conduct[conduct>=4] <- "abnormal"
  datAlts$pred.conduct[conduct==3] <- "borderline"
  datAlts$pred.conduct[conduct<=2] <- "normal"
  
  datAlts$pred.hyper[hyper>=7] <- "abnormal"
  datAlts$pred.hyper[hyper==6] <- "borderline"
  datAlts$pred.hyper[hyper<=5] <- "normal"
  
  datAlts$pred.prosocial[prosocial<=4] <- "abnormal"
  datAlts$pred.prosocial[prosocial==5] <- "borderline"
  datAlts$pred.prosocial[prosocial>=6] <- "normal"
  
  detach(datAlts)
  
  write.csv(datAlts,paste("wave",i,"Altscore.csv",sep=""),row.names = F)
  
  # save the number of abnormal students
  abnormals[(2*i-1), "conduct"] <- sum(dats$pred.conduct=="abnormal",na.rm=T)
  abnormals[(2*i), "conduct"] <-sum(datAlts$pred.conduct=="abnormal",na.rm=T)
  changingRate[i,"conduct"] <- (sum(dats$pred.conduct=="abnormal",na.rm=T)-sum(datAlts$pred.conduct=="abnormal",na.rm=T))/sum(dats$pred.conduct=="abnormal",na.rm=T)
  abnormals[(2*i-1), "hyper"] <- sum(dats$pred.hyper=="abnormal",na.rm=T)
  abnormals[(2*i), "hyper"] <-sum(datAlts$pred.hyper=="abnormal",na.rm=T)
  changingRate[i,"hyper"] <- (sum(dats$pred.hyper=="abnormal",na.rm=T)-sum(datAlts$pred.hyper=="abnormal",na.rm=T))/sum(dats$pred.hyper=="abnormal",na.rm=T)
  abnormals[(2*i-1), "prosocial"] <- sum(dats$pred.prosocial=="abnormal",na.rm=T)
  abnormals[(2*i), "prosocial"] <-sum(datAlts$pred.prosocial=="abnormal",na.rm=T)
  changingRate[i,"prosocial"] <- (sum(dats$pred.prosocial=="abnormal",na.rm=T)-sum(datAlts$pred.prosocial=="abnormal",na.rm=T))/sum(dats$pred.prosocial=="abnormal",na.rm=T)
  }

write.table(abnormals,"alernativeScoring.csv",sep=",")
write.table(changingRate,"changingRate.csv",sep=",")






