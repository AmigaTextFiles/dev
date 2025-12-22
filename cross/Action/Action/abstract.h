//-----------------------------------
// fucntions for creating declarator
// chains
//-----------------------------------

#ifndef ABSTRACT__H
#define ABSTRACT__H

typedef struct {
	struct link *type;
	struct link *etype;
}ABSTRACT;

extern ABSTRACT *newABSTRACT(void);
extern void discardABSTRACT(ABSTRACT *pA);
extern void AbstractAddDeclarator(ABSTRACT *pA,struct link *d);
extern ABSTRACT * AbstractBuildDeclarator(ABSTRACT *pA,int dectype,int nele, struct symbol *s);

#endif
