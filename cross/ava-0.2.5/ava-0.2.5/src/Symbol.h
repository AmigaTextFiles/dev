/* Symbol.h, Uros Platise */

#ifndef __Symbol
#define __Symbol

#include "Lexer.h"
#include "Segment.h"
#include <string>
#include <map>

#define SYM_MAX_PARAM	32

struct TSymbolRec{
  enum TAttr{Internal=0,Extern=1,Public=2,Virtual=4};
  TAttr attr;			/* attributes */
  int tbl_offset;		/* attribute error chk. */
  string macro;			/* macro string */
  int noArgs;			/* number of parameters */
  int segNo;			/* symbol belongs to segment */
  string ref;			/* file reference and */
  int refCnt;			/* reference count */
  bool label;			/* if symbol is label */
  bool internal;		/* protected symbols, for internal use */
  PSegTable segP;		/* link to translation table: segP is
                                   also used to declare owner - since each file
				   has its own translation table */  
  TSymbolRec():attr(0),noArgs(0),segNo(SEGNUMBER_UNDEFINED),
               refCnt(0),label(false),internal(false){}
};

class TSymbol{
  enum TOperation{Define=1,OK=2,Common=3,Error1,Error2};
  typedef map< string, TSymbolRec, less<string> >::const_iterator TsymCI;
  typedef map< string, TSymbolRec, less<string> >::iterator TsymI;
  
  map< string, TSymbolRec, less<string> > sym;
  static TOperation ErrorTable[16];
  
  bool HaltOnMacro;
  bool undefEqZero;

  /* Parameter Stack Operations */
  char param_stack[SYM_MAX_PARAM][LX_LINEBUF];
  int psi;	/* Parameter's Stack Index */
  
  void clearps(){psi=0;}
  void addps(char *s);
  void replace(char *s);
  void replaceParameters(char* s);  
  
private:
  void GiveUndefinedSymVal(bool zero=false){undefEqZero=zero;}
  int  Replace2Zero();
  void storeSym(TSymbolRec* tmpRec, const string& macroName);
  void parseFlags(TSymbolRec* pRec, int terminator_type);
  void parseMacro(TSymbolRec* pRec);
  void reparseMacro(TSymbolRec* pRec);
  void parseReference(TSymbolRec* pRec);
  TOperation test(TSymbolRec* pRec, const string& macroName);
  
public:
  TSymbol():HaltOnMacro(false),undefEqZero(false){}
  ~TSymbol(){}  
  
  bool addMacro();	/* returns true, if symbol is written as "__XXX" */
  void addMacro(const char* macroName, const char* label=NULL,
                TSymbolRec::TAttr macro_attr=TSymbolRec::Internal);                       
  int addLabel();	/* return 1, if label was added ... otherwise 0 */
  bool ifexpr();	/* return true if expression is true */
  bool ifdef();		/* return true if symbol is already in database */
  string* findMacro(const string& macroName);
  void undefine();
  void undefine(const string& macroName);
  
  long noRefs(int segNo); /* number of references for segment segNo */
  
  void addInternalLabel(const char* macroName, const char* label=NULL);
  void modifyValue(const char* macroName, const char* macroString);  
  int replaceWithMacro(); /* test if str is macro -> replace it and return 1 
  			     otherwise 0 */
  void haltOnMacro(bool confirm=true){HaltOnMacro=confirm;}
  
  void saveSymbols();
  void loadSymbols(); 
  void loadNonPublicSymbols();
  void updatePublic();
};

extern TSymbol symbol;

#endif

