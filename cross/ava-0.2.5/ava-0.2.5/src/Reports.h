/* Reports.h, Uros Platise, dec. 1998 */

#ifndef __Reports
#define __Reports

#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include "Lexer.h"
#include "Preproc.h"
#include "Error.h"

#define MAX_ERRORS_BEFORE_HALT	16

#define MAX_CODEWIDTH		64

class TListing{
private:
  PSource srclP;	/* assembler source file */
  PSource dstlP;	/* listing (destination) file */
  long clineNo;		/* current line number */
  long addrBuf;		/* hold address of the first byte in a line in buffer */
  long addrCnt;		/* address counter */
  int codeWidth;	/* index from the left border */
  int addrWidth;	/* width of the address column */
  char codeBuf [LX_LINEBUF];	/* code buffer ... */
  bool splitStr;	/* if codeBuf exceeds MAX_CODEWIDTH, splitStr=true */
  bool listingEnabled;	/* if listings is not enabled in the command line,
                           listing files are not created */
private:
  void CopyNextLine(bool addAsmSource=true);
  void Unroll();  
public:
  TListing():listingEnabled(false){}
  ~TListing(){Unroll();}
  
  void Create(const char* asmFname);
  void Address(long addr){if (!listingEnabled){return;} addrCnt=addr;}
  void GotoLine(long ln);
  void Codecat(const char* code);  
  void Enable(){listingEnabled=true;}
  void Disable(){listingEnabled=false;}
  inline bool IsEnabled(){return listingEnabled;}
};

class TReports{
public:
  enum TGroup{None=0,Symbols=1, Segments=2,WholeGroup=3};
private:
  TGroup GroupMask;
  int ErrorCnt;
  int MaxErrors;
  int verbose_level;
  TFile* logfile;
  time_t gt;
public:
  TListing listing;
  enum TVerboseLevel {
  	VL_ALL=0, 
  	VL_ASM1=1, 
  	VL_LINK1=1, 
  	VL_SEG1=1, VL_SEG4=4,	/* more than 3 is debug level */
  	VL_SYN1=1};
public:
  TReports():
    GroupMask(WholeGroup),ErrorCnt(0),MaxErrors(MAX_ERRORS_BEFORE_HALT),
    verbose_level(0),logfile(NULL){}
    
  ~TReports();
  
  void FileStatus(int _verbose_level);
  void Info(int _verbose_level, const char* fmt, ...);
  void Warnning(const char* fmt, ...);
  void Warnning(TGroup group, const char* fmt, ...);
  void Error(global_error& error);
  
  void Config(TGroup _GroupMask){GroupMask|=_GroupMask;};
  void Config(int _MaxErrors){MaxErrors=_MaxErrors;}
  void Config(char* logFileName);
  void IncVerboseLevel(){verbose_level++;}
  
  int ErrorCount() const {return ErrorCnt;}
  inline int VerboseLevel() const {return verbose_level;}
  
  char* Today();
};

extern TReports reports;

#endif

