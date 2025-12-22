#ifndef ACTIONLEXER__H
#define ACTIONLEXER__H

extern FILE *in;

extern int yylex(void);
extern void LexDebugMode(int mode);
extern char *GetLexBuff(void);
extern void InitLexer(int ungetbuffSIZE);
extern void LexDebugMode(int mode);

#endif
