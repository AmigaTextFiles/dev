typedef union {
  int tok ; /* command */
  char * string ; /* string : id, ... */
  int flag ;
  Tag *tag ;
  Tags *tags ; 
} YYSTYPE;
#define	BOLD	257
#define	ITALICS	258
#define	UNDERLINE	259
#define	KEY	260
#define	COLOR	261


extern YYSTYPE opsc_lval;
