data=read.table("input")
colnames(data)=pheno[,1]
for (i in 2:length(data[1,])) data[,i]=as.numeric(data[,i])

if (length(data[,1]) > length(unique(data[,1]))) {
  colname=colnames(data)
  colname[1]='sample'
  b=aggregate(data[,-1],list(data[,1]),mean,na.rm = TRUE)
  colnames(b)=paste(colname)
  b$sample=factor(b$sample,levels = as.character(unique(data[,1])))
  b=b[order(b$sample),]
  b=t(b)
  write.table(b,paste(input,".uniq",sep=""),quote=F,sep="\t",col.names=F,row.name=T)

  trait=unique(data[,1])
  for(i in 1:length(trait)) {
    if (length(data[data[,1]==trait[i],1])==1) data=data[data[,1]!=trait[i],]
  }
  m=aggregate(data[,-1],list(data[,c(1)]),mean,na.rm = TRUE)
  colnames(m)=colname
  sd=aggregate(data[,-1],list(data[,c(1)]),sd,na.rm = TRUE)
  colnames(sd)=colname
  cv=round(sd[,-1]/m[,-1],4)
  cv=data.frame(sample=sd$sample,cv)
  m[,1]=paste(m[,1],'_mean',sep='')
  sd[,1]=paste(sd[,1],'_sd',sep='')
  cv[,1]=paste(cv[,1],'_cv',sep='')
  colnames(data)=colname
  mydat=rbind(data,m,sd,cv)
  mydat=mydat[order(mydat$sample),]
  mydat=t(mydat)
  write.table(mydat,paste(input,".cv.xls",sep=""),quote=F,sep="\t",col.names=F,row.name=T)
} 