/*
  Reports.C
  
  Reports information on current file being compiled,
  warnnings, errors, segmantation, symbols and complete listing.
  
  Uros Platise, dec 1998
*/

#include <string.h>
#include <stdio.h>
#include <time.h>
#include "Global.h"
#include "Reports.h"

TReports::~TReports(){
  if (ErrorCnt>1){
    fprintf(stderr,"Total %d error%c ...\n",ErrorCnt,(ErrorCnt==1)?0:'s');}
  if (logfile!=NULL){delete logfile; logfile=NULL;}
}

void TReports::Config(char* logFileName){
  try{
    if (logfile!=NULL){delete logfile; logfile=NULL;}
    if (logfile==NULL){logfile = new TFile(logFileName,"a+");}
  }catch(file_error& x){Error(x);}
}

void TReports::FileStatus(int _verbose_level){
  Info(_verbose_level, "%s:%ld: ", preproc.name(), preproc.line());
}

void TReports::Info(int _verbose_level, const char* fmt, ...){
  if (_verbose_level > verbose_level){return;}
  va_list ap;
  va_start(ap,fmt); 
  if (logfile!=NULL){vfprintf(logfile->stream(),fmt,ap);}
  else{vfprintf(stderr,fmt,ap);}
  va_end(ap);  
}

char* TReports::Today(){
  gt=time(NULL); return asctime(localtime(&gt));
}

void TReports::Warnning(const char* fmt, ...){
  va_list ap;
  va_start(ap,fmt);
  fprintf(stderr,"Warning: ");
  if (logfile!=NULL){
    fprintf(logfile->stream(),"Warning: ");
    vfprintf(logfile->stream(),fmt,ap); fprintf(logfile->stream(),"\n");}  
  vfprintf(stderr,fmt,ap);
  fprintf(stderr,"\n");
  va_end(ap);    
}

void TReports::Warnning(TGroup group, const char* fmt, ...){
  va_list ap;
  va_start(ap,fmt);  
  if (logfile!=NULL){
    fprintf(logfile->stream(),"Warning: ");
    vfprintf(logfile->stream(),fmt,ap); fprintf(logfile->stream(),"\n");}  
  if (group&GroupMask){
    fprintf(stderr,"Warning: "); vfprintf(stderr,fmt,ap); fprintf(stderr,"\n");
  }  
  va_end(ap);      
}

void TReports::Error(global_error& error){
  error.print();
  if (ErrorCnt++==MAX_ERRORS_BEFORE_HALT){
    throw generic_error("Maximum numbers of errors reached - exiting.");}
}

void TListing::Create(const char* asmFname){
  if (!listingEnabled){return;}
  /* close listings and prepeare listing file name */
  Unroll();
  char* fullstop = strrchr(asmFname,'.');
  char listFileName [PPC_MAXFILELEN];
  if (fullstop!=NULL){
    strncpy(listFileName,asmFname,fullstop-asmFname);
    strcpy(&listFileName[fullstop-asmFname],".lst");
  }else{strcpy(listFileName,asmFname);strcat(listFileName,".lst");}

  srclP = new TFile(asmFname, "r");
  dstlP = new TFile(listFileName, "w");    
}

void TListing::GotoLine(long ln){
  if (!listingEnabled){return;}
  /* FLUSH buffer */
  if (strlen(codeBuf)>0 && splitStr==true){
    CopyNextLine(false); splitStr=false;}	
  
  /* copy all lines up to ln-1, and then wait at ln */  
  while((clineNo+1)<ln){CopyNextLine();}
}

void TListing::CopyNextLine(bool addAsmSource=true){
  int codeBufLen=strlen(codeBuf);
  if (codeBufLen>0){
    if (codeBufLen<=codeWidth){
      fprintf(dstlP->stream(), "%*.*lx: %*.*s ;\t",
        addrWidth, addrWidth, addrBuf,  -codeWidth, codeWidth, codeBuf);      
    }else{
      fprintf(dstlP->stream(), "%*.*lx: %*.*s\n",
        addrWidth, addrWidth, addrBuf,  -codeBufLen, codeBufLen, codeBuf);
      codeBufLen=0;
    }        
  }
  if (addAsmSource==true){
    if (srclP()!=NULL){    
      if (fgets(codeBuf, LX_LINEBUF, srclP->stream())!=NULL){
        if (codeBufLen==0){
          fprintf(dstlP->stream(), "%*.0s   ;\t", addrWidth+codeWidth, "");}
        fputs(codeBuf, dstlP->stream());
        if (feof(srclP->stream())){fputs("\n", dstlP->stream());}
      }else{srclP=0;}    
    }
    clineNo++;
  }
  codeBuf[0]=0;
  if (srclP()==NULL){fputs("\n", dstlP->stream());}  
}

void TListing::Codecat(const char* code){
  if (!listingEnabled){return;}
  if (srclP()!=NULL){
    if ((strlen(code)+strlen(codeBuf)) > MAX_CODEWIDTH){
      CopyNextLine(false);splitStr=true;}
    if (strlen(codeBuf)==0){addrBuf=addrCnt;}    
    strcat(codeBuf,code);
    addrCnt += strlen(code) >> 1;
  }
}

void TListing::Unroll(){
  while(srclP()!=NULL){CopyNextLine();}
  srclP=0; dstlP=0; clineNo=0; addrWidth=4; codeWidth=4; addrCnt=addrBuf=0; 
  splitStr=false;
}

