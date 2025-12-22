/* Object.h, Uros Platise, dec. 1998 */

#ifndef __Object
#define __Object

#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include "Global.h"
#include "Segment.h"
#include "Preproc.h"
#include "Syntax.h"

/* Object Directives */
#define OBJ_OPERAND_CODE	'o'
#define OBJ_OPERAND_PCMARKER	'M'
#define OBJ_OPERAND_QSTRING	'q'
#define OBJ_INSTRUCTION		'i'
#define OBJ_KEYWORD		'k'
#define OBJ_SEGMENT		's'
#define OBJ_ASMSOURCE		'R'
#define OBJ_ASMREF		'l'	/* for listing purposes */
#define OBJ_CREF		'c'
#define OBJ_SEGMENT_INFO	'S'
#define OBJ_SYMBOL_INFO		'Y'
#define OBJ_LISTING_ENABLED	'L'

#define OBJ_TERMINATOR		'T'
#define OBJ_ENDOFFILE		'E'
#define OBJ_HEADERIDX		'H'

#define OBJ_COPY_OPERANDS	"c"	/* list of operands to be copied from 
                                           pass1 to pass2 and to exe */

#define MAX_OPERANDS	5


class TCRC{
private:
  /* The error correction functions */  
  static const long int crc32_table[];
  unsigned long crc32;

public:  
  void Init(){crc32=0xffffffff;}
  void Update(unsigned char byte);
  inline unsigned long Val() const {return ~crc32;}
  
  TCRC(){Init();}
};

/*
  Universal Segment Output Block
  Special features:
   * mirror/copy segment
*/
class TSegmentOutput{
private:
  typedef TPt<TSegmentOutput> PSOutput;
  int CRef;
  int segNo;		/* segment number */
  long size;		/* segment size */
  long used;		/* number of NIBBLES already in buffer. */
  long addr;		/* current address */
  long offset;
  PSOutput copySeg;	/* copy segment - mirror */
  char* buf;		/* buffer */
  char* bp;		/* buffer pointer */
  
public:
  friend TPt<TSegmentOutput>;
    
  TSegmentOutput(int _segNo, long _size, long _offset);
  ~TSegmentOutput(){delete[] buf;}
  
  void Push(const char* code);
  void SetAddress(long _addr){
    addr=_addr - offset;    
    if (copySeg()!=NULL){copySeg->SetZeroOffsetAddress(addr);}
    bp=&buf[2*addr];
  }
  void SetZeroOffsetAddress(long zero_offset){
    addr=zero_offset;
    bp=&buf[2*addr];
  }
  void SetMirror(PSOutput& mirror_segment){
    assert(mirror_segment()!=NULL);
    copySeg = mirror_segment;
  }
  void Flush(FILE* outfd);
  bool Empty(){return size==0;}
};

typedef TPt<TSegmentOutput> PSOutput;


class TObject{
private:  
  struct TQOperand{
    char str [MAX_EQLEN];
    TQOperand(const char *s){strcpy(str,s);}
    TQOperand(){str[0]=0;}    
    const char& operator=(const char* s){
      if (s==0){str[0]=0;}else{strcpy(str,s);} return *s;}
    bool operator<(TQOperand& qop){return strcmp(str,qop.str)<0;}
  };
  
  /* Object variables */
  FILE* outfd;			/* current output fd */
  long oldSrcLine;
  TMicroStack<long> operand_stack;
  TMicroStack<TQOperand> qoperand_stack;
  long obj_header_seek;
  bool uAsm_exe;		/* support for old uAsm output format */
  PSOutput seg_output;		/* current segment output buffer */
  PSOutput seg_output_table [MAX_SEGMENTS];
  TCRC crc;
  
private:
  void CRCprintf(FILE* fd, const char* fmt, ...);	/* print and calc crc */

  void createObjHeader();
  void outHeaderIndex();
  void createExeHeader();  
  void outAsmSource(const char *src);  
  void outEndofFile();
  
  bool loadOperand(bool onStack, char operandType=OBJ_OPERAND_CODE);
  void loadStringOperand();
  void skipOperand();
  long loadArgument();
  void loadHeader();	/* loads header, segment info and public symbols */
  void outCompiled(const char* compiled_code);
  void outListing();		/* enables listing for individual source */
  void CreateOutputBuffers();
  void obji2objii(const char* src);
  void obj2exe();
    
public:
  TObject():oldSrcLine(0),uAsm_exe(true){}
  ~TObject(){}
  
  void assemble(const char* outfile, const char* asm_source);
  void link(const char* outfile);
  
  /* Object code helper functions */
  /* Operand may be code operand 'o', marker 'M' */
  void outOperand(const char* operand, char operandType=OBJ_OPERAND_CODE);
  void outOperand(long lval, char operandType=OBJ_OPERAND_CODE);
  void outStringOperand(const char *s);
  void outInstruction(int instNo, bool insertRef=true);
  void outKeyword(int instNo, bool insertRef=true);
  void outSegment(int segNo);
  void outTerminator();
  
  void outPCMarker(const char* marker);
  void outPCMarker(long marker, int segNo=0);
  void outCRef(long ref);
  
  void outSrcLine();
  void outSrcLine(long srcLine);
  
  void outSymbolData();
  void outSegmentData(int segInfoNo);
  
  void outCode(unsigned char byteC);
  void outCode(unsigned int wordC);
  void outCode(unsigned long longC);
  
  /* Translation Facilities */
  long popOperand(){
    assert(!operand_stack.empty()); return operand_stack.pop();}
  void pushOperand(long lval){operand_stack.push(lval);}
  
  void pushStringOperand(const TQOperand& qop){qoperand_stack.push(qop);}
  const char* popStringOperand(){
    assert(!qoperand_stack.empty()); 
    const TQOperand& qop = qoperand_stack.pop();
    return qop.str;
  }  
  bool operandStacksEmpty(){
    return operand_stack.empty() & qoperand_stack.empty();
  }
};

extern TObject object;

#endif

