/*
	Preproc.C
	
	Preprocessor
	Uros Platise, July 1998
*/

#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include "Lexer.h"
#include "Syntax.h"
#include "Preproc.h"
#include "Error.h"

TFile::TFile():temporary(false),fd(NULL),bufferCh(false),ch(0){}

TFile::TFile(const char* _fullName, const char* _mode="rt", 
             bool _temporary=false):
  temporary(false),fd(NULL),bufferCh(false),ch(0){
  reopen(_fullName, _mode, _temporary);
}

TFile::~TFile(){
  if (fd!=NULL){fclose(fd);if (temporary==true){unlink(name);}}
}

void TFile::reopen(const char* _fullName, const char* _mode="rt", 
                   bool _temporary=false){
  assert(fd==NULL);
  strcpy (name, _fullName); temporary=_temporary;

  if (strcmp(name,"stdin")==0){
    if (strchr(_mode,'r')==NULL){
      throw generic_error("Cannot write to the standard input.");
    }
    fd=stdin; 
  }
  else if (strcmp(name,"stdout")==0){
    if (strchr(_mode,'w')==NULL){
      throw generic_error("Cannot read from the standard output."); 
    }
    fd=stdout;
  }
  else if ((fd=fopen(name, _mode))==NULL){throw file_error(name);}
}

char TFile::getch(){
  assert(fd!=NULL);
  int ich; if(bufferCh==false || ch==0){
    ich=fgetc(fd);ch=(ich>=0)?(char)ich:0;
    if (ch!=0){currPos++;}
    if (ch=='\n'){lineNumber++;currPos=0;}
  }
  bufferCh=false;   
  return ch;
}

char* TMemBlock::getstr(char* s, int size){
  char* p=s; size--; /* make place for 0 terminator */
  if (idx>=len){return NULL;}
  do{
    if (size--<=0){*s=0;return p;}
    if (idx>=len){*s=0;return p;}
    *s++=mem[idx++];
  }while(mem[idx]!='\n');  
  *s=0;
  return p;
}

char TMemBlock::getch(){
  if (bufferCh==false || ch==0){
    ch=(idx==len)?0:mem[idx++];    
    if (ch!=0){currPos++;}
    if (ch=='\n'){lineNumber++;currPos=0;}
  }
  bufferCh=false;
  return ch;
}

void TMemBlock::append(const char* s){
  len+=strlen(s); if (len>=MEMBLOCK_LEN){
    throw generic_error("Macro too big. Try increasing"
                  " the MEMBLOCK_LEN in the Preproc.h.");}
  strcat(mem,s);
}

void TPreproc::insert(char* fullName){
  lexer.flush();
  PSource newItem(new TFile(fullName));
  srcList.push (newItem); csrc=srcList.top();
}

void TPreproc::insert(PSource srcP, bool copyParentInfo=true){
  if (srcList.full()){throw generic_error("Recursive symbols ...");}
  lexer.flush();
  /* These memory blocks are usually used for macro replacements
     or for anykind of internal string converters;
     example algebraical parser.      
     For that reason, these memory block should report
     error in the current line of the file which was the last
     being read.
  */
  if (copyParentInfo==true){
    srcP->lineNumber=preproc.line();
    srcP->currPos=preproc.curpos();
    strcpy(srcP->name,preproc.name());
  }
  srcList.push (srcP); csrc=srcList.top();
}

bool TPreproc::next(){
  lexer.flush();
  /* rotate stack */
  if (fileN==0){fileN=srcList.capacity();}
  if (fileN==0){throw generic_error("There is no open file.");}
  srcList.rotateUp(); csrc=srcList.top();  
  /* list stack */  
  if (--fileN==0){return false;}else{return true;}
}

char* TPreproc::getstr(char* s, int size){
  char* returnString;
  if (csrc()==NULL){return NULL;}
  while( (returnString=csrc->getstr(s, size))==NULL){
    srcList.pop();if (srcList.empty()){csrc=NULL;return NULL;}
    csrc = srcList.top();
  }
  return returnString;
}

char TPreproc::getch(){
  char ch;
  if (csrc()==NULL){return 0;}
  while((ch=csrc->getch())==0){
    strcpy(oldSourceName,csrc->name);
    srcList.pop(); if (srcList.empty()){csrc=NULL;return 0;}
    csrc=srcList.top();
  }
  return ch;
}

void TPreproc::AddDir(){
  char buf [LX_LINEBUF];
  AddDir(syntax.Parse_FileName(buf));
}

void TPreproc::AddDir(const char* directory){
  dirList.push_back(directory);
}

/* returns full pathname in filename_buf */
char* TPreproc::FindFullPathName(char* filename_buf){
  char buf [LX_LINEBUF]; strcpy(buf, filename_buf);
  struct stat inpStat;
  TstrCI dirCI = dirList.begin();
  while (stat(buf, &inpStat)!=0){
    if (dirCI==dirList.end()){throw file_error(filename_buf);}
    strcpy(buf,(*dirCI).c_str()); strcat(buf,"/"); strcat(buf, filename_buf);
    dirCI++;
  }
  strcpy(filename_buf, buf);	/* update filename string */
  return filename_buf;
}

