EXPORT  {/* EXPORT */
         #include "StringMem.h"   /* For 'PutString' */
         #include "Idents.h"      /* For 'MakeIdent' */
         #include "Positions.h"

         typedef struct { tPosition Position;
                          tStringRef lexstring;
                          tIdent lexid;        } tScanAttribute;
         extern void ErrorAttribute ARGS((int Token, tScanAttribute * Attribute));
         /* EXPORT */}
GLOBAL  {/* GLOBAL */
         /* #include "Memory.h" */
         void ErrorAttribute ARGS((int Token, tScanAttribute * Attribute))
         {}
         int clevel=0;
         /* GLOBAL */}
LOCAL   {/* LOCAL */
         char       Word [256];
         int        length;
         /* LOCAL */}
BEGIN   {/* BEGIN */}
CLOSE   {/* CLOSE */}
DEFAULT {/* DEFAULT */
         printf("REX-ERR:\n");
         (void) putchar ((int) yyChBufferIndexReg [-1]);
         /* DEFAULT */}
EOF     {/* EOF */
         if (clevel>0) printf("\n\n%d comment(s) to close\n",clevel);
         /* EOF */}


DEFINE

digi   = {0-9}.
letter = {a-z A-Z}.


START comment


RULES

/* (verschachtelte) Comments ueberlesen */

          "(*"             : {printf("\ncomment level%d:\n",clevel++);
                              if (yyStartState!=comment) yyStart (comment);}
#comment# "*)"             : {printf("\nend of comment level %d\n",--clevel); if (clevel==0) yyPrevious;}
#comment# ANY              : {yyEcho;}

/* String erkennen und uebergeben */

#STD#     \" - {\n"} * \"  : {length = GetWord (Word);
                              Attribute.lexstring = PutString (Word,length);
                              return 1;}

#STD#     \' - {\n'} * \'  : {length = GetWord (Word);
                              Attribute.lexstring = PutString (Word,length);
                              return 1;}

/* Zahlen erkennen und uebergeben */

#STD#     digi+            : {length = GetWord(Word);
                               Attribute.lexstring = PutString (Word,length);
                              return 2;}

/* Befehle */

#STD#     "BEGIN"          : {return 3;}
#STD#     "END"            : {return 4;}
#STD#     "CONST"          : {return 5;}
#STD#     "VAR"            : {return 6;}
#STD#     "PROCEDURE"      : {return 7;}
#STD#     "TYPE"           : {return 8;}
#STD#     "ARRAY"          : {return 9;}
#STD#     "OF"             : {return 10;}
#STD#     "IF"             : {return 11;}
#STD#     "THEN"           : {return 12;}
#STD#     "ELSIF"          : {return 13;}
#STD#     "ELSE"           : {return 14;}
#STD#     "WHILE"          : {return 15;}
#STD#     "DO"             : {return 16;}
#STD#     "OR"             : {return 17;}
#STD#     "AND"            : {return 18;}
#STD#     "NOT"            : {return 19;}
#STD#     "ODD"            : {return 20;}
#STD#     "?"              : {return 21;}
#STD#     "!"              : {return 22;}

/* Operatoren */

#STD#     "="              : {return 23;}
#STD#     "#"              : {return 24;}
#STD#     "<"              : {return 25;}
#STD#     ">"              : {return 26;}
#STD#     "<="             : {return 27;}
#STD#     ">="             : {return 28;}
#STD#     "+"              : {return 29;}
#STD#     "-"              : {return 30;}
#STD#     "*"              : {return 31;}
#STD#     "/"              : {return 32;}
#STD#     ":="             : {return 33;}

/* Delimiter */

#STD#     ","              : {return 34;}
#STD#     ";"              : {return 35;}
#STD#     "."              : {return 36;}
#STD#     "("              : {return 37;}
#STD#     ")"              : {return 38;}
#STD#     "["              : {return 39;}
#STD#     "]"              : {return 40;}
#STD#     ":"              : {return 41;}

/* Identifier */

#STD#     letter {a-z A-Z 0-9} * : {Attribute.lexid = MakeIdent (TokenPtr, TokenLength);
                                       return 42;}

/* Ueberlesen */

/* #STD#     \n               : {} */
/* #STD#     {\t " "} *       : {} */
