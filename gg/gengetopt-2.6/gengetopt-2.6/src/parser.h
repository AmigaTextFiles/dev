typedef union {
char * str;
char chr;
int argtype;
int bool;
} YYSTYPE;
#define	TOK_PACKAGE	257
#define	TOK_VERSION	258
#define	TOK_OPTION	259
#define	TOK_YES	260
#define	TOK_NO	261
#define	TOK_FLAG	262
#define	TOK_PURPOSE	263
#define	TOK_ONOFF	264
#define	TOK_STRING	265
#define	TOK_DEFAULT	266
#define	TOK_MLSTRING	267
#define	TOK_CHAR	268
#define	TOK_ARGTYPE	269


extern YYSTYPE yylval;
