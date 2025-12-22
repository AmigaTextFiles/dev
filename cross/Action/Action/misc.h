#ifndef MISC__H
#define MISC__H

#ifdef __cplusplus
extern "C" {
#endif

#include "symtab.h"

typedef struct {
	int Nparams;
	int NBytes;
	char Psize[16];
}PARAMS;

typedef char* CHARP;

typedef struct _clist{
	int v;		//elecment in list
	struct _clist *next;	//pointer to next element
}CLIST;

typedef CLIST* CLISTP;

typedef struct {
	char *data;
	int size;
}DATABLOCK;

extern CLIST* newCLIST(int v);
extern CLIST* CLISTchain(CLIST *cl1, CLIST *cl2);
extern int CLISTsize(CLIST *pCL);
extern void ClistToDataBlock(DATABLOCK *pD, CLIST *pCL);
extern void yyerror(char *fmt,...);
extern char *bin_to_ascii(int c,int use_hex );
extern unsigned long stoul(char **instr);
extern long stol(char **instr);
extern int	esc(char **s);
extern void assort(void **base, int nel,int(*cmp)(void **,void **) );
extern char *NewString(char *s);
extern symbol *AddSymbolToSymTab(int flag,symbol *pSym);
extern void yyparse(void);
extern void RemoveLocalsFromSymtab(HASH_TAB *pTab);
extern void MarkSymbolsAsLocal(symbol *s);

#ifdef __cplusplus
}
#endif

#endif
