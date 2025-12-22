typedef union
{
  int number;
  char *string;
  treenode *node;
} YYSTYPE;
#define	FLUSH	258
#define	INCLUDE	259
#define	LOADPTR	260
#define	CHUNK	261
#define	SWITCH	262
#define	CASE	263
#define	DEFAULT	264
#define	ALIAS	265
#define	ASSIGN	266
#define	ADDASSIGN	267
#define	SUBASSIGN	268
#define	MULASSIGN	269
#define	DIVASSIGN	270
#define	MODASSIGN	271
#define	ANDASSIGN	272
#define	ORASSIGN	273
#define	EORASSIGN	274
#define	SHIFTLASSIGN	275
#define	SHIFTRASSIGN	276
#define	EQ	277
#define	NE	278
#define	GTE	279
#define	LTE	280
#define	GT	281
#define	LT	282
#define	INC	283
#define	DEC	284
#define	ADD	285
#define	SUB	286
#define	MUL	287
#define	DIV	288
#define	MOD	289
#define	AND	290
#define	OR	291
#define	BOOLAND	292
#define	BOOLOR	293
#define	BOOLNOT	294
#define	EOR	295
#define	LEFT	296
#define	RIGHT	297
#define	LEFTBR	298
#define	RIGHTBR	299
#define	LEFTCOMP	300
#define	RIGHTCOMP	301
#define	SHIFTL	302
#define	SHIFTR	303
#define	COMMA	304
#define	DBLCOLON	305
#define	CONSTANT	306
#define	VAR	307
#define	EXTERN	308
#define	ENDSTAT	309
#define	IF	310
#define	ELSE	311
#define	WHILE	312
#define	DO	313
#define	FOR	314
#define	GOTO	315
#define	DATA	316
#define	STOP	317
#define	BREAK	318
#define	RETURN	319
#define	NUMBER	320
#define	NAME	321
#define	STRING	322


extern YYSTYPE yylval;
