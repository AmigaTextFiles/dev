OPT MODULE

OPT PREPROCESS

OPT EXPORT

->helvete !! trodde det gick att göra nlines..

#define SHL(var, steps)\
   MOVE.L var, D0 ;\
   MOVE.L steps, D1 ;\
   SHL.L D1, D0 ;\
   MOVE.L D0, var

#define SHR(var, steps)\
   MOVE.L var, D0;\
   MOVE.L steps, D1;\
   SHR.L D1, D0;\
   MOVE.L D0, var

/* len gets trashed!*/
#define COPYMEM(frommem, tomem, len)\
   MOVE.L frommem, A0;\
   MOVE.L tomem, A1;\
   WHILE (len);\
      MOVE.B (A0)+, (A1)+;\
      SUBQ.L #1, len;\
   ENDWHILE

#define SETBIT(var, bit)\
   MOVE.L var, D0;\
   MOVE.L bit, D1;\
   BSET.L D1, D0;\
   MOVE.L D0, var

#define CLRBIT(var, bit)\
   MOVE.L var, D0;\
   MOVE.L bit, D1;\
   BCLR.L D1, D0;\
   MOVE.L D0, var

#define MAX(x, y) IF x>y THEN x ELSE y

#define MIN(x, y) IF x<y THEN x ELSE y

#define GETCHAR(ptr, char)\
   CLR.L char;\
   MOVE.L ptr, A0;\
   MOVE.B (A0), char

#define GETINT(ptr, int)\
   CLR.L int;\
   MOVE.L ptr, A0;\
   MOVE.W (A0), int

#define GETLONG(ptr, long)\
   MOVE.L ptr, A0;\
   MOVE.L (A0), long

#define PUTCHAR(ptr, char)\
   MOVE.L ptr, A0;\
   MOVE.B char, (A0)

#define PUTINT(ptr, int)\
   MOVE.L ptr, A0;\
   MOVE.W int, (A0)

#define PUTLONG(ptr, long)\
   MOVE.L ptr, A0;\
   MOVE.L long, (A0)

#define INCMEMBER(var)\
   var := ( var ) + 1

#define DECMEMBER(var)\
   var := ( var ) - 1



