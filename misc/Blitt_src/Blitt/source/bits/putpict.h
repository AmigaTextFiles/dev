#ifndef PUTPICT_H
#define PUTPICT_H
#ifndef COMPILER_H
#include        <iff/compiler.h>
#endif
#ifndef ILBM_H
#include        <iff/ilbm.h>
#endif
#ifdef  FDwAT
extern  IFFP    IffErr(void);
extern  BOOL    PutPict(LONG,struct BitMap *,WORD,WORD,WORD *,BYTE *,LONG);
#else
extern  IFFP    IffErr();
extern  BOOL    PutPict();
#endif  /* FDwAT */
#endif  /* PUTPICT_H */
