/* 
  Preproc.h
  Uros Platise, July 1998
*/

#ifndef __Preproc
#define __Preproc

#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include "Global.h"
#include "Segment.h"
#include "string.h"

#define PPC_MAXFILELEN	256
#define PPC_TMPDIR	"/tmp/"

class TSource{
private:
  int CRef;		/* Smart Pointer Support */
public:  
  char name [PPC_MAXFILELEN];
  long currPos;
  long lineNumber;
  PSegTable segP;
  
public:
  virtual char *getstr(char *s, int size)=0;
  virtual int putstr(const char *s)=0;
  
  virtual char getch()=0;	/* return zero on end-of-file */
  virtual void putbackch()=0;	/* 1 character deep stack must be provided! */
  
  virtual void rew()=0;
  virtual FILE* stream()=0;
  virtual void seek(long offset, long new_ln)=0;
  virtual ~TSource(){}
  TSource():CRef(0),currPos(0),lineNumber(1){}
  friend TPt<TSource>;
};
typedef TPt<TSource> PSource;

class TPreproc {
private:
  TMicroStack<PSource> srcList;
  vector<string> dirList;
  typedef vector<string>::const_iterator TstrCI;

  long markPos;		/* mark cursor position for error reporting */
  long markLine;
  char oldSourceName[PPC_MAXFILELEN];
  char extSourceName[PPC_MAXFILELEN];
  bool extMarker;
  int fileN;		/* number of open files -> linker, skipping files */
  
public:
  PSource csrc;		/* current source */
  
public:
  TPreproc():markPos(1),markLine(1),extMarker(false),fileN(0){
    oldSourceName[0]=0;}
  ~TPreproc(){}

  void insert(PSource srcP, bool copyParentInfo=true);
  void insert(char* fullName);
  
  void AddDir();	/* Adds directory list */
  void AddDir(const char* directory);
  char* FindFullPathName(char* filename_buf);	/* returns to filename_buf */
  
  bool next();		/* is true, when next file is found, otherwise false.
                           If next file is not found, first one is set again */
  void seek(long offset, long new_nl){if(csrc()!=NULL){
    csrc->seek(offset,new_nl);}}
			   			   
  /* character retrive funcs. */
			   
  char* getstr(char *s, int size);
  char getch();
  void putbackch(){if(csrc()!=NULL){csrc->putbackch();}}
  
  /* report functions */
  
  void mark(){
    extMarker=false; 
    if (csrc()!=NULL){markPos=csrc->currPos;markLine=csrc->lineNumber;}
  }
  void mark(int lineNo, const char* s){
    extMarker=true; markLine=lineNo; strcpy(extSourceName,s);}
  const char* name(){
    if (extMarker==true){return extSourceName;}
    return (csrc()!=NULL)?csrc->name:oldSourceName;
  }
  long line(){return markLine;}
  long curpos(){return markPos;}
  long lxline(){return (csrc()!=NULL)?csrc->lineNumber:markLine;}
  long lxcur(){return (csrc()!=NULL)?csrc->currPos:markPos;}  
  
  bool firstSource(){return srcList.size()<2;}  
};

extern TPreproc preproc;

/* FILE I/O Interface Support */
class TFile: public TSource{
private:
  bool temporary;
  FILE *fd;
  bool bufferCh;
  char ch;	/* set ch=0 to avoid buffering before first ch is read */
public:
  TFile();
  TFile(const char* _fullName, const char* _mode="rt", bool temporary=false);
  void reopen(const char* _fullName, const char* _mode="rt",
              bool temporary=false);
  ~TFile();

  char* getstr(char *s, int size){return fgets (s,size,fd);}
  int putstr(const char *s) {return fputs (s,fd);}
  
  char getch();
  void putbackch(){bufferCh=true;}
  
  void rew(){rewind(fd);}
  void seek(long offset, long new_ln){
    currPos=0; lineNumber=new_ln; fseek(fd, offset, SEEK_SET);}
  inline FILE* stream(){return fd;}
};

/* Memory Block I/O Interface Support */
#define MEMBLOCK_LEN	4096

class TMemBlock: public TSource{
private:
  char mem[MEMBLOCK_LEN];
  char ch;	/* set ch=0 to avoid buffering before first ch is read */
  int idx,len;
  bool bufferCh;
public:
  TMemBlock():ch(0),idx(0),len(0),bufferCh(false){mem[0]=0;}
  ~TMemBlock(){}

  char* getstr (char *s, int size);
  int putstr (const char *s){fprintf(stderr,"putstr(%s)\n",s);assert(0);}
  
  char getch();
  void putbackch(){bufferCh=true;}
  
  void rew(){assert(0);}
  void seek(long offset, long new_ln){
    printf("TMemBlock: Cannot seek to: %ld @ %ld",offset,new_ln);assert(0);}
  FILE* stream(){assert(0);}  
  
  void append (const char* s);
};

#endif

