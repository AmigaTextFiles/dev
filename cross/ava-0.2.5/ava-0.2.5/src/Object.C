/*
  Object.C
  
  Object/Executable Code Generator and Parser
  Uros Platise, dec. 1998
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "Lexer.h"
#include "Global.h"
#include "Preproc.h"
#include "Syntax.h"
#include "Symbol.h"
#include "Segment.h"
#include "Keywords.h"
#include "Object.h"
#include "Reports.h"

/*
  AVA Object Version; Major=1, Minor=1 
  Two objects are compatabile as long as major numbers are the
  same.
  
  Changes: 1.1 -> 1.2
  ===================
   Obj: 1.1/1.2     * added: listing enabled option for individual 
                      file (as specified durring assemble time)

   Obj: 2.x/3.x     * header index was moved to the near end of the file
                      and CRC32 error detection is included.
*/

#define OBJ_VERSION_MAJOR	3
#define OBJ_VERSION_MINOR	0

char* obj_magic = "avaobj";
char* exe_magic = "avaexe";

/* Besides instruction, reference to source code is given - with
   line number. If this number equals zero, current file
   was included by the original source. For include files,
   lists are never generated.
*/
#define LST_NOSRC	0

/* DEFAULT executable output filename, if extra switch -o filename
   is not given, is defined by the following macro. */
   
#define DEFAULT_EXE	"a.out"   
#define TMP_DIR		"/tmp"


/*
  The 32 bit CRC table.
*/
const long int TCRC::crc32_table[] = {
  0x000000000, 0x077073096, 0x0ee0e612c, 0x0990951ba,
  0x0076dc419, 0x0706af48f, 0x0e963a535, 0x09e6495a3,
  0x00edb8832, 0x079dcb8a4, 0x0e0d5e91e, 0x097d2d988,
  0x009b64c2b, 0x07eb17cbd, 0x0e7b82d07, 0x090bf1d91,

  0x01db71064, 0x06ab020f2, 0x0f3b97148, 0x084be41de,
  0x01adad47d, 0x06ddde4eb, 0x0f4d4b551, 0x083d385c7,
  0x0136c9856, 0x0646ba8c0, 0x0fd62f97a, 0x08a65c9ec,
  0x014015c4f, 0x063066cd9, 0x0fa0f3d63, 0x08d080df5,

  0x03b6e20c8, 0x04c69105e, 0x0d56041e4, 0x0a2677172,
  0x03c03e4d1, 0x04b04d447, 0x0d20d85fd, 0x0a50ab56b,
  0x035b5a8fa, 0x042b2986c, 0x0dbbbc9d6, 0x0acbcf940,
  0x032d86ce3, 0x045df5c75, 0x0dcd60dcf, 0x0abd13d59,

  0x026d930ac, 0x051de003a, 0x0c8d75180, 0x0bfd06116,
  0x021b4f4b5, 0x056b3c423, 0x0cfba9599, 0x0b8bda50f,
  0x02802b89e, 0x05f058808, 0x0c60cd9b2, 0x0b10be924,
  0x02f6f7c87, 0x058684c11, 0x0c1611dab, 0x0b6662d3d,

  0x076dc4190, 0x001db7106, 0x098d220bc, 0x0efd5102a,
  0x071b18589, 0x006b6b51f, 0x09fbfe4a5, 0x0e8b8d433,
  0x07807c9a2, 0x00f00f934, 0x09609a88e, 0x0e10e9818,
  0x07f6a0dbb, 0x0086d3d2d, 0x091646c97, 0x0e6635c01,

  0x06b6b51f4, 0x01c6c6162, 0x0856530d8, 0x0f262004e,
  0x06c0695ed, 0x01b01a57b, 0x08208f4c1, 0x0f50fc457,
  0x065b0d9c6, 0x012b7e950, 0x08bbeb8ea, 0x0fcb9887c,
  0x062dd1ddf, 0x015da2d49, 0x08cd37cf3, 0x0fbd44c65,

  0x04db26158, 0x03ab551ce, 0x0a3bc0074, 0x0d4bb30e2,
  0x04adfa541, 0x03dd895d7, 0x0a4d1c46d, 0x0d3d6f4fb,
  0x04369e96a, 0x0346ed9fc, 0x0ad678846, 0x0da60b8d0,
  0x044042d73, 0x033031de5, 0x0aa0a4c5f, 0x0dd0d7cc9,

  0x05005713c, 0x0270241aa, 0x0be0b1010, 0x0c90c2086,
  0x05768b525, 0x0206f85b3, 0x0b966d409, 0x0ce61e49f,
  0x05edef90e, 0x029d9c998, 0x0b0d09822, 0x0c7d7a8b4,
  0x059b33d17, 0x02eb40d81, 0x0b7bd5c3b, 0x0c0ba6cad,

  0x0edb88320, 0x09abfb3b6, 0x003b6e20c, 0x074b1d29a,
  0x0ead54739, 0x09dd277af, 0x004db2615, 0x073dc1683,
  0x0e3630b12, 0x094643b84, 0x00d6d6a3e, 0x07a6a5aa8,
  0x0e40ecf0b, 0x09309ff9d, 0x00a00ae27, 0x07d079eb1,

  0x0f00f9344, 0x08708a3d2, 0x01e01f268, 0x06906c2fe,
  0x0f762575d, 0x0806567cb, 0x0196c3671, 0x06e6b06e7,
  0x0fed41b76, 0x089d32be0, 0x010da7a5a, 0x067dd4acc,
  0x0f9b9df6f, 0x08ebeeff9, 0x017b7be43, 0x060b08ed5,

  0x0d6d6a3e8, 0x0a1d1937e, 0x038d8c2c4, 0x04fdff252,
  0x0d1bb67f1, 0x0a6bc5767, 0x03fb506dd, 0x048b2364b,
  0x0d80d2bda, 0x0af0a1b4c, 0x036034af6, 0x041047a60,
  0x0df60efc3, 0x0a867df55, 0x0316e8eef, 0x04669be79,

  0x0cb61b38c, 0x0bc66831a, 0x0256fd2a0, 0x05268e236,
  0x0cc0c7795, 0x0bb0b4703, 0x0220216b9, 0x05505262f,
  0x0c5ba3bbe, 0x0b2bd0b28, 0x02bb45a92, 0x05cb36a04,
  0x0c2d7ffa7, 0x0b5d0cf31, 0x02cd99e8b, 0x05bdeae1d,

  0x09b64c2b0, 0x0ec63f226, 0x0756aa39c, 0x0026d930a,
  0x09c0906a9, 0x0eb0e363f, 0x072076785, 0x005005713,
  0x095bf4a82, 0x0e2b87a14, 0x07bb12bae, 0x00cb61b38,
  0x092d28e9b, 0x0e5d5be0d, 0x07cdcefb7, 0x00bdbdf21,

  0x086d3d2d4, 0x0f1d4e242, 0x068ddb3f8, 0x01fda836e,
  0x081be16cd, 0x0f6b9265b, 0x06fb077e1, 0x018b74777,
  0x088085ae6, 0x0ff0f6a70, 0x066063bca, 0x011010b5c,
  0x08f659eff, 0x0f862ae69, 0x0616bffd3, 0x0166ccf45,

  0x0a00ae278, 0x0d70dd2ee, 0x04e048354, 0x03903b3c2,
  0x0a7672661, 0x0d06016f7, 0x04969474d, 0x03e6e77db,
  0x0aed16a4a, 0x0d9d65adc, 0x040df0b66, 0x037d83bf0,
  0x0a9bcae53, 0x0debb9ec5, 0x047b2cf7f, 0x030b5ffe9,

  0x0bdbdf21c, 0x0cabac28a, 0x053b39330, 0x024b4a3a6,
  0x0bad03605, 0x0cdd70693, 0x054de5729, 0x023d967bf,
  0x0b3667a2e, 0x0c4614ab8, 0x05d681b02, 0x02a6f2b94,
  0x0b40bbe37, 0x0c30c8ea1, 0x05a05df1b, 0x02d02ef8d
};

void TCRC::Update(unsigned char byte){
  crc32 = crc32_table[ (unsigned char)(crc32^((unsigned long)byte)) ] ^ 
                         ((crc32>>8) & 0x00FFFFFF);
}


/*
  PASS1/2 functions for intermediate OBJ-EXE language.
*/

/* GENERAL OPERAND, QOPERAND IMPLEMENTATION */

void TObject::outOperand(const char* operand, 
                         char operandType=OBJ_OPERAND_CODE){
  CRCprintf(outfd,"%c{%s}\n",operandType, operand);
}
void TObject::outOperand(long lval, char operandType=OBJ_OPERAND_CODE){
  CRCprintf(outfd,"%c{$%lx}\n",operandType, lval);
}
void TObject::outStringOperand(const char *s){CRCprintf(outfd,"q{\"%s\"}\n",s);}

void TObject::outCode(unsigned char byteC){
  char buf[8]; sprintf(buf,"%2.2x",byteC); 
  if (seg_output()!=NULL){seg_output->Push(buf);}
  if (!uAsm_exe){CRCprintf(outfd,"\"%s\"\n",buf);}
  reports.listing.Codecat(buf);
}
void TObject::outCode(unsigned  int wordC){
  char pbuf[10]; sprintf(pbuf,"%8.8lx",(long)wordC);
  char* buf = &pbuf[4];
  if (seg_output()!=NULL){seg_output->Push(buf);}
  if (!uAsm_exe){CRCprintf(outfd,"\"%s\"\n",buf);}
  reports.listing.Codecat(buf);
}
void TObject::outCode(unsigned long longC){
  char buf[14]; sprintf(buf,"%8.8lx",longC);
  if (seg_output()!=NULL){seg_output->Push(buf);}  
  if (!uAsm_exe){CRCprintf(outfd,"\"%s\"\n",buf);}
  reports.listing.Codecat(buf);
}
void TObject::outCompiled(const char* compiled_code){
  CRCprintf(outfd,"\"%s\"\n",compiled_code);
}

/* INSTRUCTIONs and KEYWORDs */

void TObject::outInstruction(int instNo, bool insertRef=true){
  if (insertRef==true){outSrcLine();}
  CRCprintf(outfd,"i{$%x}\n", instNo);
}
void TObject::outKeyword(int keyNo, bool insertRef=true){
  if (insertRef==true){outSrcLine();}
  CRCprintf(outfd,"k{$%x}\n", keyNo);
}      


/* OBJECT AND EXE STRUCTURE */

void TObject::createObjHeader(){
  char buf [LX_LINEBUF];
  CRCprintf(outfd, "%s %d %d\n%s",
    obj_magic,OBJ_VERSION_MAJOR,OBJ_VERSION_MINOR,
    archp->Device(buf));
    
  
}
void TObject::outHeaderIndex(){
  CRCprintf(outfd, "%c{0x%8.8lx}\n", OBJ_HEADERIDX, obj_header_seek);
}
void TObject::createExeHeader(){
  if (uAsm_exe){
    CRCprintf(outfd,"[code]\n");
  }else{CRCprintf(outfd, "%s %d %d\n",
                exe_magic, OBJ_VERSION_MAJOR, OBJ_VERSION_MINOR);}
}
void TObject::outTerminator(){if(!uAsm_exe){CRCprintf(outfd,"T\n");}}
void TObject::outEndofFile(){
  if(uAsm_exe){
    CRCprintf(outfd,"[end]\n");
  }else{
    CRCprintf(outfd, "%c{0x%8.8lx}\n", OBJ_ENDOFFILE, crc.Val());
  }
}


/* SYMBOLs */

void TObject::outSymbolData(){CRCprintf(outfd,"Y\n");}


/* SEGMENTs */

void TObject::outSegmentData(int segInfoNo){
  CRCprintf(outfd,"S{$%x}\n",segInfoNo);}
void TObject::outSegment(int segNo){
  if(!uAsm_exe)CRCprintf(outfd,"s{$%x}\n",segNo);
}

void TObject::outPCMarker(const char* marker){
  if (uAsm_exe){throw generic_error("outPCMarker: Internal Error.");}
  else{outOperand(marker, OBJ_OPERAND_PCMARKER);}
}
void TObject::outPCMarker(long marker, int segNo=0){  
  assert(segNo!=0);
  if (seg_output()!=NULL){seg_output->SetAddress(marker);}
  if (!uAsm_exe){outOperand(marker, OBJ_OPERAND_PCMARKER);}
}


/* SOURCE CODE REFERENCES */

void TObject::outCRef(long ref){
  if(!uAsm_exe)outOperand(ref, OBJ_CREF);
}
void TObject::outListing(){
  if(!uAsm_exe && reports.listing.IsEnabled()){
    CRCprintf(outfd,"%c\n", OBJ_LISTING_ENABLED);}
}

/* outSrcLine(): PASS1 output */
void TObject::outSrcLine(){
  if (oldSrcLine!=preproc.line() && reports.listing.IsEnabled()){
    oldSrcLine=preproc.line();
    if (preproc.firstSource()==false){oldSrcLine=LST_NOSRC;}   
    CRCprintf(outfd,"l{$%lx}\n",oldSrcLine);
  }
}
void TObject::outAsmSource(const char* src){
  if (!uAsm_exe && reports.listing.IsEnabled()){
    CRCprintf(outfd, "R{\"%s\"}\n", src);}
}  
/* outSrcLine(): obji2objii and obj2exe output */
void TObject::outSrcLine(long srcLine){
  if (!uAsm_exe)CRCprintf(outfd,"l{$%lx}\n",srcLine);}


/*
  The cprintf 
  Print and calculate CRC32
*/
void TObject::CRCprintf(FILE* fd, const char* fmt, ...){
  char buf [LX_STRLEN], *p=buf;
  va_list ap;
  va_start(ap,fmt); 
  vsprintf(buf,fmt,ap);
  fputs(buf,fd);
  while(*p!=0){crc.Update(*p++);}
  va_end(ap); 
}


/*
  Segment Output Functions
*/

TSegmentOutput::TSegmentOutput(int _segNo, long _size, long _offset):
  CRef(0), segNo(_segNo), size(_size), used(0), addr(0), offset(_offset), 
  bp(NULL) {
  buf = new char[2*size];
}

void TSegmentOutput::Push(const char* code){
  if (copySeg()!=NULL){copySeg->Push(code);}
  assert(addr>=0 && addr<size);
  assert(bp!=NULL);
  while(*code!=0){*bp++ = *code++; used++;}
}

#define MAX_BPL	0x10	/* max bytes per line */

void TSegmentOutput::Flush(FILE* outfd){
  /* skip abstract segments */
  if (segment.isAbstract(segNo)){return;}

  /* calc. alignment for the uIsp compatibility only! */
  int alignBytes=segment.TellAlign(segNo)-(size%segment.TellAlign(segNo));
  alignBytes%=segment.TellAlign(segNo);
 
  /* calculate CRC (and count align. bytes also) */
  TCRC crc;
  for (long i=0; i<(2*size); i++){crc.Update(buf[i]);} /* out size bytes */
  for (int  i=0; i<(2*alignBytes); i++){crc.Update('0');}  

  /* Output Segment Header */  
  fprintf(outfd, "@%s,%lx %8.8lx", 
    segment.TellBaseSegment(segNo), offset, crc.Val());
          
  if (used!=(size<<1)){
    reports.Warnning("Bad segment output buffer for the `%s'\n"
      "Status: (used=$%lx, size=$%lx) nibbles",
      segment.TellSegmentName(segNo), used, size<<1);
    throw generic_error("FATAL INTERNAL ERROR.\n");
  }  
  char* p = buf;
  for (long i=0; i<size; i++){    
    if ((i%MAX_BPL)==0){fputc('\n', outfd);}
    fputc(*p++, outfd); fputc(*p++, outfd);
  }
  if (((size-1)%MAX_BPL) || (size-1)==0){fputc('\n', outfd);}
  
  /* Due to the uIsp compatibility, output align. characters */
  if (alignBytes > 0){
    for (int i=0; i<alignBytes; i++){fprintf(outfd, "00");}
    fputc('\n',outfd);
  }
}

void TObject::CreateOutputBuffers(){
  /* create output pipes for base segments only */
  int idx;
  long default_size;
  for (idx=1; idx < segment.TellNoSegments(); idx++){
    if (!segment.isEnabled(idx)){
      default_size=0;
    } else {
      default_size=segment.TellSize(idx);
    }     
    seg_output_table [idx] = new TSegmentOutput(idx, default_size,
      segment.TellAbsolute(idx));    
  }  
  /* because all pipes are open, we can set mirrors */
  int mirrorSegNo;
  for (idx=1; idx < segment.TellNoSegments(); idx++){
    mirrorSegNo = segment.TellMirror(idx);
    if (mirrorSegNo!=-1){
      if (segment.isEnabled(mirrorSegNo)){
        seg_output_table[idx]->SetMirror(seg_output_table[mirrorSegNo]);
      }
    }
  }
}

/*
  PARSER and GENERATOR for PASS1 to PASS2
*/
void TObject::obji2objii(const char* src){
  int opCount=0;
  int segNo, instr, key, i, cpylen = strlen(OBJ_COPY_OPERANDS);
  long operand=0, currentLine=1;
  static char* copy_op = OBJ_COPY_OPERANDS;
  bool enableSegment=true;
  
  /* halt on macros and non-external macros */
  symbol.haltOnMacro();
  syntax.haltOnInvalidMacros();
  
  while(lexer._gettoken()){
    if (lxP->type==TlxData::NEWLINE){continue;}
    if (lxP->type==TlxData::STRING && lxP->string[1]==0){

      switch(lxP->string[0]){
      
      /* operand: increment operand count per instruction */
      case OBJ_OPERAND_CODE: 
        if (enableSegment==false){skipOperand();break;}
        loadOperand(opCount==operand_stack.capacity());
	opCount++; 
        break;

      case OBJ_INSTRUCTION: /* instruction */
        instr=(int)loadArgument();
	if (enableSegment==false){break;}
	preproc.mark(currentLine,src);
        if (opCount!=operand_stack.capacity()){outInstruction(instr,false);}
	else{archp->Translate(instr);}          
	if (operandStacksEmpty()==false){
	  throw syntax_error("obj2exe: Operand stack is not empty.");}
	opCount=0;
        break;

      case OBJ_KEYWORD:
        key=(int)loadArgument();
	if (enableSegment==false){break;}
	preproc.mark(currentLine,src);
        if (opCount!=operand_stack.capacity()){outKeyword(key,false);}
	else{keywords.Translate(key);}
	if (operandStacksEmpty()==false){
	  throw syntax_error("obj2exe: Operand stack is not empty.");}
	opCount=0;
        break;

      case OBJ_SEGMENT: /* segment */        
        segNo = (int)loadArgument();
	enableSegment = segment.isEnabled(segNo);
	if (enableSegment==true){outSegment(segNo);}
        break;

      case OBJ_OPERAND_PCMARKER: /* PC marker */
        loadOperand(false, 'M');
	break;

      case OBJ_ASMREF: /* assembler listing */
        currentLine=loadArgument();
	if (enableSegment==true){outSrcLine(currentLine);}
	break;
				
      default:
        for (i=0;i<cpylen;i++){
	  if (lxP->string[0]==copy_op[i]){
	    operand=loadArgument();
	    if (enableSegment==true){outOperand(operand,copy_op[i]);break;}}
	}
	if (i==cpylen){
          throw syntax_error("Unsupported object directive: ",lxP->string);}
	break;
      }
    }
    else if (lxP->type==TlxData::QSTRING){
      outCompiled(lxP->string);
    }
    else{throw syntax_error("obji2objii: Object file is corrupted.");}
  }
}

/*
  Load operand on stack - if operand is a not of lval type, 
  push all the previously stacked operands to the output.
  
  Return true, if operand was pushed on stack, oterhwise false
*/
bool TObject::loadOperand(bool onStack, char operandType=OBJ_OPERAND_CODE){
  bool retVal=false;
  /* expect { */
  GET_TOKEN; if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='{'){
    throw syntax_error("loadOperand(): Object file is corrupted.");}
  GET_TOKEN;
  syntax.Parse_GAS(1);
  if (gas.status==TGAS::Solved && onStack==true){ /* push operand on stack */
    operand_stack.push(gas.result()); retVal=true;
  }else{				/* unroll stack */
    int items = operand_stack.capacity();
    for (int i=0; i<items; i++){outOperand(operand_stack[i],operandType);}
    operand_stack.clear();
    outOperand(gas.eqstr,operandType);
  }
  if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='}'){
    throw syntax_error("loadOperand(): Object file is corrupted.");}
  return retVal;
}

void TObject::loadStringOperand(){
  /* expect { */
  GET_TOKEN; if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='{'){
    throw syntax_error("loadStringOperand():1: Object file is corrupted.");}
  GET_TOKEN;
  if (lxP->type!=TlxData::QSTRING){
    throw syntax_error("loadStringOperand():2: Object file is corrupted.");}
  pushStringOperand(lxP->string);
  GET_TOKEN; if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='}'){
    throw syntax_error("loadStringOperand():3: Object file is corrupted.");}  
}

void TObject::skipOperand(){
  WHILE_TOKEN{
    if (lxP->type==TlxData::CONTROL && lxP->string[0]=='}'){break;}}
}

long TObject::loadArgument(){
  /* expect { */
  GET_TOKEN; if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='{'){
    throw syntax_error("loadArgument():1: Object file is corrupted.");}
  GET_TOKEN;
  syntax.Parse_GAS();
  if (gas.status != TGAS::Solved){
    throw syntax_error("loadArgument():2: Object file is corrupted.");}
  if (lxP->type!=TlxData::CONTROL||lxP->string[0]!='}'){
    throw syntax_error("loadArgument():3: Object file is corrupted.");}
  return gas.result();
}

void TObject::assemble(const char* outfile, const char* asm_source){
  char sourceFile[PPC_MAXFILELEN];
  char tmpFileName[PPC_MAXFILELEN];
  char objectFileName[PPC_MAXFILELEN];
  
  uAsm_exe = false;
  assert(asm_source!=NULL);

  reports.Info(TReports::VL_ASM1, "Starting assembler on %s", reports.Today());
  reports.Info(TReports::VL_ASM1, "Assembling: %s\n\n", asm_source);
  
  PSource tmpP, objP;
  strcpy(sourceFile,asm_source);
  sprintf(tmpFileName,"%s/ava.%d",TMP_DIR, getpid());
  char* fullstop = strrchr(sourceFile,'.');
  if (outfile==NULL){
    if (fullstop!=NULL){
      strncpy(objectFileName,sourceFile,fullstop-sourceFile);
      strcpy(&objectFileName[fullstop-sourceFile],".o");
    }else{strcpy(objectFileName,sourceFile);strcat(objectFileName,".o");}
  }else{strcpy(objectFileName, outfile);}
    
  /* do pass 1 to tmp file */
  tmpP = new TFile(tmpFileName,"w+",true);
  outfd=tmpP->stream();
  syntax.Run();
  if (reports.ErrorCount()>0){return;}
    
  /* do pass 2; rewind tmp and insert it to lexical analyzer */
  tmpP->rew(); preproc.insert(tmpP,false);
  objP = new TFile(objectFileName,"w"); outfd=objP->stream();
  crc.Init();
  
  /* Primary Part of the Header */
  createObjHeader();
    
  /* Partially Compiled Data */
  outListing();
  outAsmSource(sourceFile);
    
  /* PASS2 */
   obji2objii(sourceFile);
    
  /* Secondary Part of the Header */
  outTerminator();
  obj_header_seek = ftell(outfd);
  segment.saveSegments();
  symbol.saveSymbols(); /* adds terminator between public/internal syms */
  outHeaderIndex();
  outEndofFile();
    
  segment.Report();
  reports.Info(TReports::VL_ASM1, "Completed.\n\n");    
}

/* Linker PASS1: Read header and segments of current file */
void TObject::loadHeader(){
  /* Check CRC and load header index */
  char line_buf [LX_STRLEN], *reterr, *p;
  long header_index=0;
  crc.Init();
  while((reterr=fgets(line_buf, LX_STRLEN-1, preproc.csrc->stream()))){
    if (line_buf[0]==OBJ_HEADERIDX && line_buf[1]=='{'){
      header_index = strtol(&line_buf[2], (char **)NULL, 16);
    }
    if (line_buf[0]==OBJ_ENDOFFILE && line_buf[1]=='{'){
      unsigned long file_crc = strtoul(&line_buf[2], (char **)NULL, 16);
      if (file_crc!=crc.Val()){
        fprintf(stderr, "%s: CRC Error (0x%lx,0x%lx)\n" 
 	  "Do you want to continue (enter y for yes, n for no):",
	  preproc.name(), file_crc, crc.Val());
	scanf("%s", line_buf);
	if (strcmp(line_buf,"y")!=0){throw generic_error("CRC Error.");}
      }
      break;
    }
    p = line_buf;
    while(*p!=0){crc.Update(*p++);}
  }
  if (reterr==NULL){
    throw syntax_error("File has no ending header?");
  }
  preproc.csrc->rew();

  /* Get AVA object info */
  GET_TOKEN;
  if (lxP->type!=TlxData::STRING || strcmp(lxP->string,obj_magic)){
    throw syntax_error("This is not ava object file.");}
  /* compare major numbers */
  GET_TOKEN;
  if (lxP->type!=TlxData::LVAL || lxP->lval!=OBJ_VERSION_MAJOR){
    throw syntax_error("Object file is not compatabile with major version.");}
  /* compare minor numbers - object file should have it lower or equal */
  GET_TOKEN;
  if (lxP->type!=TlxData::LVAL || lxP->lval>OBJ_VERSION_MINOR){
    throw syntax_error("Object file is not compatabile with minor version.");}
  GET_TOKEN;  	/* new line, I assume */

  /* load device info */
  keywords.Device();  

  /* remember current data and jump to header */
  long tmpLineNumber = preproc.line();
  long tmpOffset = ftell(preproc.csrc->stream());
  preproc.seek(header_index,1);
  
  /* create segment translation table */
  preproc.csrc->segP = new TSegTable();    
      
  /* load segments */  
  while(lexer._gettoken()){
    if (lxP->type==TlxData::NEWLINE){continue;}
    if (lxP->string[0]==OBJ_TERMINATOR){break;}
    if (lxP->type==TlxData::STRING && lxP->string[1]==0){

    switch(lxP->string[0]){
      
      /* operand: increment operand count per instruction */
      case OBJ_OPERAND_CODE: 
        loadOperand(true); break;

      case OBJ_OPERAND_QSTRING:	
        loadStringOperand(); break;

      case OBJ_SEGMENT_INFO: /* segment */
	segment.loadSegments((int)loadArgument()); 
	if (operandStacksEmpty()==false){
 	  throw syntax_error("Segment purely read its data:"
 	    " stack is not empty.");
 	}
	break;

      case OBJ_SYMBOL_INFO:
        symbol.loadSymbols();
	if (operandStacksEmpty()==false){
	  throw syntax_error("Symbol purely read its data: stack is not "
	    "empty.");
	}
	break;

      default:
        throw syntax_error("Unsupported object directive: ",lxP->string);
      }
    }
    else{
      throw syntax_error("Load Header and Segments:"
        " Object file is corrupted.");
    }
  }
  /* restore initial condition */  
  preproc.seek(tmpOffset, tmpLineNumber);
}

/*
  PARSER and GENERATOR from OBJ to EXECUTABLE FORMAT
*/
void TObject::obj2exe(){
  int segNo=SEGNUMBER_UNDEFINED;
  int instr, key, i, cpylen = strlen(OBJ_COPY_OPERANDS);
  long operand=0, currentLine=1, addr;
  static char* copy_op = OBJ_COPY_OPERANDS;
  char src [PPC_MAXFILELEN] = "";
  bool enableSegment=true;
  
  /* halt on macros and non-external macros */
  symbol.haltOnMacro();
  syntax.haltOnInvalidMacros();
  
  /* disable listings by default */
  reports.listing.Disable();  
 
  /* first call to lexer._gettoken removes #
     from previously declared mem blocks
  */ 
  while(lexer._gettoken()){
    if (lxP->type==TlxData::NEWLINE){continue;}
    if (lxP->type==TlxData::STRING && lxP->string[1]==0){

      switch(lxP->string[0]){
      
      /* operand: increment operand count per instruction */
      case OBJ_OPERAND_CODE: 
        if (enableSegment==false){skipOperand();break;}
        if (loadOperand(true)==false){
	  throw syntax_error("Undefined reference: ", gas.eqstr);}
        break;

      case OBJ_OPERAND_QSTRING:	
        if (enableSegment==false){skipOperand();break;}
        loadStringOperand();
	break;

      case OBJ_INSTRUCTION: /* instruction */
        instr=(int)loadArgument();
	if (enableSegment==false){break;}
	preproc.mark(currentLine,src);
	archp->Translate(instr);
	if (operandStacksEmpty()==false){
	  throw syntax_error("obj2exe:instruction:"
	    " Operand stack is not empty.");
	}
        break;

      case OBJ_KEYWORD:
        key=(int)loadArgument();
	if (enableSegment==false){break;}
	preproc.mark(currentLine,src);
	keywords.Translate(key);
	if (operandStacksEmpty()==false){
	  throw syntax_error("obj2exe:keyword: Operand stack is not empty.");}
        break;

      case OBJ_SEGMENT: /* segment */
        segNo = preproc.csrc->segP->seg[(int)loadArgument()].newNo;
	enableSegment = segment.isEnabled(segNo);
	seg_output = seg_output_table[segNo];
	if (seg_output()==NULL){
	  throw generic_error("Internal Error: seg_output()==NULL");}
	if (enableSegment==true){outSegment(segNo);}
        break;

      case OBJ_OPERAND_PCMARKER: /* PC marker */
        if (enableSegment==false){skipOperand();break;}
        if (loadOperand(true)==false){
	  throw syntax_error("Undefined reference: ", gas.eqstr);}
	outPCMarker(addr=popOperand(),segNo);
	reports.listing.Address(addr);
	break;

      case OBJ_SYMBOL_INFO: 
        symbol.loadNonPublicSymbols();
        break;

      case OBJ_ASMSOURCE:
        loadStringOperand();
	strcpy(src, popStringOperand());
	outAsmSource(src);
	reports.listing.Create(src);
	break;

      case OBJ_ASMREF: /* assembler listing */
        currentLine=loadArgument();
	if (enableSegment){
	  reports.listing.GotoLine(currentLine);
	  outSrcLine(currentLine);
	}
	break;

      case OBJ_LISTING_ENABLED: reports.listing.Enable();break;
      
      case OBJ_TERMINATOR:
      case OBJ_ENDOFFILE:
        if (operandStacksEmpty()==false){
	  throw generic_error("OBJ_EOF: Operand stack is not empty.");}
        return;

      default:
        for (i=0;i<cpylen;i++){
	  if (lxP->string[0]==copy_op[i]){
	    operand=loadArgument();
	    if (uAsm_exe){break;}
	    if (enableSegment){outOperand(operand,copy_op[i]);break;}}
	}
	if (i==cpylen){
          throw syntax_error("Unsupported object directive: ",lxP->string);}
	break;
      }
    }
    else if (lxP->type==TlxData::QSTRING){
      if (enableSegment){
        reports.listing.Codecat(lxP->string);
	seg_output->Push(lxP->string);
//	if (!uAsm_exe){CRCprintf(outfd,"\"%s\"\n",lxP->string);}
      }
    }
    else{throw syntax_error("obj2exe: Object file is corrupted.");}
  }
}

void TObject::link(const char* outfile){
  char exeFileName[PPC_MAXFILELEN];
  {
    reports.Info(TReports::VL_LINK1, "Starting linker on %s", reports.Today());
        
    if (reports.listing.IsEnabled()){
      reports.Warnning("To generate listing files add -L switch to the "
                       "assembler only.");}
  
    /* rotate files while loading header, segment and symbol info. */
    do{loadHeader();}while(preproc.next());
    reports.Info(TReports::VL_LINK1, "\n");
    segment.fitter();
    
    /* update public for every file separately and report files */
    reports.Info(TReports::VL_LINK1, "Linking:\n");
    do{
      reports.Info(TReports::VL_LINK1, " * %s\n",preproc.name());
      segment.adjustSegments(); symbol.updatePublic();
    }while(preproc.next());
    reports.Info(TReports::VL_LINK1, "\n");
    
    /* Now we are ready to link the stuff. Prepeare files and go ... */
    if (outfile==NULL){strcpy(exeFileName,DEFAULT_EXE);}
    else{strcpy(exeFileName,outfile);}
    
    PSource exeP = new TFile(exeFileName, "w"); outfd=exeP->stream(); 
    
    createExeHeader();
    CreateOutputBuffers();
    do{
      segment.adjustSegments();
      obj2exe();
      outTerminator();
    }while(preproc.next()==true);
    
    /* FLUSH buffers */
    for (int segcnt=0; segcnt<MAX_SEGMENTS; segcnt++){
      if (seg_output_table[segcnt]()==NULL){continue;}
      if (seg_output_table[segcnt]->Empty()){continue;}
      seg_output_table[segcnt]->Flush(outfd);
    }

// for non uAsm outputs ...    
//    segment.saveSegments();
//    symbol.saveSymbols();
    outEndofFile();
    reports.Info(TReports::VL_LINK1, "Completed.\n\n");
  }  
}

