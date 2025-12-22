/* Driver template for the LEMON parser generator.
** The author disclaims copyright to this source code.
*/
/* First off, code is include which follows the "include" declaration
** in the input file. */
#include <stdio.h>
#line 28 "parse.y"

#include "sqliteInt.h"
#include "parse.h"

#line 13 "parse.c"
/* Next is all token values, in a form suitable for use by makeheaders.
** This section will be null unless lemon is run with the -m switch.
*/
/* 
** These constants (all generated automatically by the parser generator)
** specify the various kinds of tokens (terminals) that the parser
** understands. 
**
** Each symbol here is a terminal symbol in the grammar.
*/
/* Make sure the INTERFACE macro is defined.
*/
#ifndef INTERFACE
# define INTERFACE 1
#endif
/* The next thing included is series of defines which control
** various aspects of the generated parser.
**    YYCODETYPE         is the data type used for storing terminal
**                       and nonterminal numbers.  "unsigned char" is
**                       used if there are fewer than 250 terminals
**                       and nonterminals.  "int" is used otherwise.
**    YYNOCODE           is a number of type YYCODETYPE which corresponds
**                       to no legal terminal or nonterminal number.  This
**                       number is used to fill in empty slots of the hash 
**                       table.
**    YYACTIONTYPE       is the data type used for storing terminal
**                       and nonterminal numbers.  "unsigned char" is
**                       used if there are fewer than 250 rules and
**                       states combined.  "int" is used otherwise.
**    sqliteParserTOKENTYPE     is the data type used for minor tokens given 
**                       directly to the parser from the tokenizer.
**    YYMINORTYPE        is the data type used for all minor tokens.
**                       This is typically a union of many types, one of
**                       which is sqliteParserTOKENTYPE.  The entry in the union
**                       for base tokens is called "yy0".
**    YYSTACKDEPTH       is the maximum depth of the parser's stack.
**    sqliteParserARGDECL       is a declaration of a 3rd argument to the
**                       parser, or null if there is no extra argument.
**    sqliteParserKRARGDECL     A version of sqliteParserARGDECL for K&R C.
**    sqliteParserANSIARGDECL   A version of sqliteParserARGDECL for ANSI C.
**    YYNSTATE           the combined number of states.
**    YYNRULE            the number of rules in the grammar
**    YYERRORSYMBOL      is the code number of the error symbol.  If not
**                       defined, then do no error processing.
*/
/*  */
#define YYCODETYPE unsigned char
#define YYNOCODE 149
#define YYACTIONTYPE int
#define sqliteParserTOKENTYPE Token
typedef union {
  sqliteParserTOKENTYPE yy0;
  Expr* yy18;
  ExprList* yy32;
  Token yy90;
  IdList* yy114;
  Select* yy155;
  int yy156;
  int yy297;
} YYMINORTYPE;
#define YYSTACKDEPTH 100
#define sqliteParserARGDECL ,pParse
#define sqliteParserXARGDECL Parse *pParse;
#define sqliteParserANSIARGDECL ,Parse *pParse
#define YYNSTATE 350
#define YYNRULE 202
#define YYERRORSYMBOL 107
#define YYERRSYMDT yy297
#define YY_NO_ACTION      (YYNSTATE+YYNRULE+2)
#define YY_ACCEPT_ACTION  (YYNSTATE+YYNRULE+1)
#define YY_ERROR_ACTION   (YYNSTATE+YYNRULE)
/* Next is the action table.  Each entry in this table contains
**
**  +  An integer which is the number representing the look-ahead
**     token
**
**  +  An integer indicating what action to take.  Number (N) between
**     0 and YYNSTATE-1 mean shift the look-ahead and go to state N.
**     Numbers between YYNSTATE and YYNSTATE+YYNRULE-1 mean reduce by
**     rule N-YYNSTATE.  Number YYNSTATE+YYNRULE means that a syntax
**     error has occurred.  Number YYNSTATE+YYNRULE+1 means the parser
**     accepts its input.
**
**  +  A pointer to the next entry with the same hash value.
**
** The action table is really a series of hash tables.  Each hash
** table contains a number of entries which is a power of two.  The
** "state" table (which follows) contains information about the starting
** point and size of each hash table.
*/
struct yyActionEntry {
  YYCODETYPE   lookahead;   /* The value of the look-ahead token */
  YYACTIONTYPE action;      /* Action to take for this look-ahead */
  struct yyActionEntry *next; /* Next look-ahead with the same hash, or NULL */
};
static struct yyActionEntry yyActionTable[] = {
/* State 0 */
  {  96, 347, 0                    }, /*                    cmd shift  347 */
  {  97,   1, &yyActionTable[   2] }, /*                cmdlist shift  1 */
  {  33, 348, 0                    }, /*                EXPLAIN shift  348 */
  {  67, 330, 0                    }, /*                 PRAGMA shift  330 */
  {   6,   6, 0                    }, /*                  BEGIN shift  6 */
  { 133, 276, 0                    }, /*                 select shift  276 */
  {  70,  27, &yyActionTable[   4] }, /*               ROLLBACK shift  27 */
  { 103,  29, 0                    }, /*           create_table shift  29 */
  {  87, 281, &yyActionTable[  11] }, /*                 UPDATE shift  281 */
  {  73,  63, 0                    }, /*                 SELECT shift  63 */
  { 106, 349, 0                    }, /*                   ecmd shift  349 */
  {  23, 277, 0                    }, /*                 DELETE shift  277 */
  { 108,   4, 0                    }, /*                explain shift  4 */
  {YYNOCODE,0,0}, /* Unused */
  {  46, 293, 0                    }, /*                 INSERT shift  293 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  17,  23, 0                    }, /*                 COMMIT shift  23 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  20, 321, 0                    }, /*                   COPY shift  321 */
  {  21, 257, 0                    }, /*                 CREATE shift  257 */
  {YYNOCODE,0,0}, /* Unused */
  { 119, 553, &yyActionTable[   8] }, /*                  input accept */
  {YYNOCODE,0,0}, /* Unused */
  {  89, 328, 0                    }, /*                 VACUUM shift  328 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  28, 271, 0                    }, /*                   DROP shift  271 */
  {  29,  25, 0                    }, /*                    END shift  25 */
  {YYNOCODE,0,0}, /* Unused */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 1 */
  {  74,   2, &yyActionTable[  33] }, /*                   SEMI shift  2 */
  {   0, 350, 0                    }, /*                      $ reduce 0 */
/* State 2 */
  {  96, 347, 0                    }, /*                    cmd shift  347 */
  {  33, 348, 0                    }, /*                EXPLAIN shift  348 */
  {   6,   6, 0                    }, /*                  BEGIN shift  6 */
  {  67, 330, 0                    }, /*                 PRAGMA shift  330 */
  {  23, 277, 0                    }, /*                 DELETE shift  277 */
  { 133, 276, 0                    }, /*                 select shift  276 */
  {  70,  27, &yyActionTable[  36] }, /*               ROLLBACK shift  27 */
  { 103,  29, 0                    }, /*           create_table shift  29 */
  {YYNOCODE,0,0}, /* Unused */
  {  73,  63, 0                    }, /*                 SELECT shift  63 */
  { 106,   3, 0                    }, /*                   ecmd shift  3 */
  {YYNOCODE,0,0}, /* Unused */
  { 108,   4, 0                    }, /*                explain shift  4 */
  {YYNOCODE,0,0}, /* Unused */
  {  46, 293, 0                    }, /*                 INSERT shift  293 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  17,  23, 0                    }, /*                 COMMIT shift  23 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  20, 321, 0                    }, /*                   COPY shift  321 */
  {  21, 257, 0                    }, /*                 CREATE shift  257 */
  {YYNOCODE,0,0}, /* Unused */
  {  87, 281, &yyActionTable[  38] }, /*                 UPDATE shift  281 */
  {YYNOCODE,0,0}, /* Unused */
  {  89, 328, 0                    }, /*                 VACUUM shift  328 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  28, 271, 0                    }, /*                   DROP shift  271 */
  {  29,  25, 0                    }, /*                    END shift  25 */
  {YYNOCODE,0,0}, /* Unused */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 3 */
  {YYNOCODE,0,0}, /* Unused */
/* State 4 */
  {  96,   5, 0                    }, /*                    cmd shift  5 */
  {   6,   6, 0                    }, /*                  BEGIN shift  6 */
  {  23, 277, 0                    }, /*                 DELETE shift  277 */
  {  67, 330, 0                    }, /*                 PRAGMA shift  330 */
  {YYNOCODE,0,0}, /* Unused */
  { 133, 276, 0                    }, /*                 select shift  276 */
  {  70,  27, &yyActionTable[  68] }, /*               ROLLBACK shift  27 */
  { 103,  29, 0                    }, /*           create_table shift  29 */
  {YYNOCODE,0,0}, /* Unused */
  {  73,  63, 0                    }, /*                 SELECT shift  63 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  46, 293, 0                    }, /*                 INSERT shift  293 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  17,  23, 0                    }, /*                 COMMIT shift  23 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  20, 321, 0                    }, /*                   COPY shift  321 */
  {  21, 257, 0                    }, /*                 CREATE shift  257 */
  {YYNOCODE,0,0}, /* Unused */
  {  87, 281, &yyActionTable[  69] }, /*                 UPDATE shift  281 */
  {YYNOCODE,0,0}, /* Unused */
  {  89, 328, 0                    }, /*                 VACUUM shift  328 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  28, 271, 0                    }, /*                   DROP shift  271 */
  {  29,  25, 0                    }, /*                    END shift  25 */
  {YYNOCODE,0,0}, /* Unused */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 5 */
  {YYNOCODE,0,0}, /* Unused */
/* State 6 */
  {  82,   8, 0                    }, /*            TRANSACTION shift  8 */
  { 143,   7, 0                    }, /*              trans_opt shift  7 */
/* State 7 */
  {YYNOCODE,0,0}, /* Unused */
/* State 8 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[ 103] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[ 105] }, /*                     id shift  21 */
  { 116,   9, 0                    }, /*                    ids shift  9 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 110] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[ 114] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 9 */
  {YYNOCODE,0,0}, /* Unused */
/* State 10 */
  {YYNOCODE,0,0}, /* Unused */
/* State 11 */
  {YYNOCODE,0,0}, /* Unused */
/* State 12 */
  {YYNOCODE,0,0}, /* Unused */
/* State 13 */
  {YYNOCODE,0,0}, /* Unused */
/* State 14 */
  {YYNOCODE,0,0}, /* Unused */
/* State 15 */
  {YYNOCODE,0,0}, /* Unused */
/* State 16 */
  {YYNOCODE,0,0}, /* Unused */
/* State 17 */
  {YYNOCODE,0,0}, /* Unused */
/* State 18 */
  {YYNOCODE,0,0}, /* Unused */
/* State 19 */
  {YYNOCODE,0,0}, /* Unused */
/* State 20 */
  {YYNOCODE,0,0}, /* Unused */
/* State 21 */
  {YYNOCODE,0,0}, /* Unused */
/* State 22 */
  {YYNOCODE,0,0}, /* Unused */
/* State 23 */
  {  82,   8, 0                    }, /*            TRANSACTION shift  8 */
  { 143,  24, 0                    }, /*              trans_opt shift  24 */
/* State 24 */
  {YYNOCODE,0,0}, /* Unused */
/* State 25 */
  {  82,   8, 0                    }, /*            TRANSACTION shift  8 */
  { 143,  26, 0                    }, /*              trans_opt shift  26 */
/* State 26 */
  {YYNOCODE,0,0}, /* Unused */
/* State 27 */
  {  82,   8, 0                    }, /*            TRANSACTION shift  8 */
  { 143,  28, 0                    }, /*              trans_opt shift  28 */
/* State 28 */
  {YYNOCODE,0,0}, /* Unused */
/* State 29 */
  { 104,  30, 0                    }, /*      create_table_args shift  30 */
  {  55,  31, 0                    }, /*                     LP shift  31 */
/* State 30 */
  {YYNOCODE,0,0}, /* Unused */
/* State 31 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  98, 256, 0                    }, /*                 column shift  256 */
  {  99,  37, &yyActionTable[ 145] }, /*               columnid shift  37 */
  { 100,  32, 0                    }, /*             columnlist shift  32 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  21, 0                    }, /*                     id shift  21 */
  { 116, 233, 0                    }, /*                    ids shift  233 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 152] }, /*                 VACUUM shift  14 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 32 */
  {  15,  35, 0                    }, /*                  COMMA shift  35 */
  {YYNOCODE,0,0}, /* Unused */
  { 102,  33, 0                    }, /*           conslist_opt shift  33 */
  {  71, 412, &yyActionTable[ 177] }, /*                     RP reduce 62 */
/* State 33 */
  {  71,  34, 0                    }, /*                     RP shift  34 */
/* State 34 */
  {YYNOCODE,0,0}, /* Unused */
/* State 35 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  98,  36, 0                    }, /*                 column shift  36 */
  {  99,  37, &yyActionTable[ 183] }, /*               columnid shift  37 */
  {  68, 239, 0                    }, /*                PRIMARY shift  239 */
  { 101, 234, &yyActionTable[ 190] }, /*               conslist shift  234 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  19, 237, 0                    }, /*             CONSTRAINT shift  237 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  12, 252, 0                    }, /*                  CHECK shift  252 */
  { 141, 255, &yyActionTable[ 191] }, /*                  tcons shift  255 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  21, &yyActionTable[ 192] }, /*                     id shift  21 */
  { 116, 233, 0                    }, /*                    ids shift  233 */
  {YYNOCODE,0,0}, /* Unused */
  {  86, 248, 0                    }, /*                 UNIQUE shift  248 */
  {YYNOCODE,0,0}, /* Unused */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 194] }, /*                 VACUUM shift  14 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 36 */
  {YYNOCODE,0,0}, /* Unused */
/* State 37 */
  { 144,  38, 0                    }, /*                   type shift  38 */
  { 145, 219, &yyActionTable[ 218] }, /*               typename shift  219 */
  {  81,  20, &yyActionTable[ 223] }, /*                   TEMP shift  20 */
  { 115,  21, &yyActionTable[ 227] }, /*                     id shift  21 */
  { 116, 232, 0                    }, /*                    ids shift  232 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 228] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  29,  16, &yyActionTable[ 230] }, /*                    END shift  16 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 38 */
  {  94,  39, 0                    }, /*               carglist shift  39 */
/* State 39 */
  {  60,  44, &yyActionTable[ 234] }, /*                    NOT shift  44 */
  {  12,  52, 0                    }, /*                  CHECK shift  52 */
  {  22, 207, 0                    }, /*                DEFAULT shift  207 */
  {  19,  41, 0                    }, /*             CONSTRAINT shift  41 */
  {  68,  46, &yyActionTable[ 233] }, /*                PRIMARY shift  46 */
  {  93,  40, 0                    }, /*                   carg shift  40 */
  {  86,  51, &yyActionTable[ 235] }, /*                 UNIQUE shift  51 */
  {  95, 206, 0                    }, /*                  ccons shift  206 */
/* State 40 */
  {YYNOCODE,0,0}, /* Unused */
/* State 41 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[ 242] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[ 244] }, /*                     id shift  21 */
  { 116,  42, 0                    }, /*                    ids shift  42 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 249] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[ 253] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 42 */
  {  60,  44, &yyActionTable[ 259] }, /*                    NOT shift  44 */
  {  12,  52, 0                    }, /*                  CHECK shift  52 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  68,  46, &yyActionTable[ 258] }, /*                PRIMARY shift  46 */
  {YYNOCODE,0,0}, /* Unused */
  {  86,  51, 0                    }, /*                 UNIQUE shift  51 */
  {  95,  43, 0                    }, /*                  ccons shift  43 */
/* State 43 */
  {YYNOCODE,0,0}, /* Unused */
/* State 44 */
  {  62,  45, 0                    }, /*                   NULL shift  45 */
/* State 45 */
  {YYNOCODE,0,0}, /* Unused */
/* State 46 */
  {  52,  47, 0                    }, /*                    KEY shift  47 */
/* State 47 */
  {   5,  49, 0                    }, /*                    ASC shift  49 */
  {  25,  50, &yyActionTable[ 270] }, /*                   DESC shift  50 */
  {YYNOCODE,0,0}, /* Unused */
  { 139,  48, 0                    }, /*              sortorder shift  48 */
/* State 48 */
  {YYNOCODE,0,0}, /* Unused */
/* State 49 */
  {YYNOCODE,0,0}, /* Unused */
/* State 50 */
  {YYNOCODE,0,0}, /* Unused */
/* State 51 */
  {YYNOCODE,0,0}, /* Unused */
/* State 52 */
  {  55,  53, 0                    }, /*                     LP shift  53 */
/* State 53 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 279] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 204, &yyActionTable[ 283] }, /*                   expr shift  204 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 286] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 287] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 54 */
  {  55,  55, 0                    }, /*                     LP shift  55 */
/* State 55 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 312] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  78, 202, 0                    }, /*                   STAR shift  202 */
  {  79,  57, &yyActionTable[ 323] }, /*                 STRING shift  57 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  { 109, 145, &yyActionTable[ 316] }, /*                   expr shift  145 */
  { 110, 158, &yyActionTable[ 319] }, /*               expritem shift  158 */
  { 111, 200, &yyActionTable[ 320] }, /*               exprlist shift  200 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 324] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 56 */
  {  64, 481, &yyActionTable[ 353] }, /*                     OR reduce 131 */
  {  65, 481, 0                    }, /*                  ORDER reduce 131 */
  {  66, 481, 0                    }, /*                   PLUS reduce 131 */
  {  67, 481, &yyActionTable[ 355] }, /*                 PRAGMA reduce 131 */
  {  68, 481, &yyActionTable[ 360] }, /*                PRIMARY reduce 131 */
  {  69, 481, &yyActionTable[ 364] }, /*                    REM reduce 131 */
  {   6, 481, 0                    }, /*                  BEGIN reduce 131 */
  {  71, 481, &yyActionTable[ 367] }, /*                     RP reduce 131 */
  {  72, 481, &yyActionTable[ 370] }, /*                 RSHIFT reduce 131 */
  {   0, 481, 0                    }, /*                      $ reduce 131 */
  {  74, 481, &yyActionTable[ 372] }, /*                   SEMI reduce 131 */
  {   3, 481, 0                    }, /*                    AND reduce 131 */
  {  76, 481, &yyActionTable[ 374] }, /*                  SLASH reduce 131 */
  {  13, 481, 0                    }, /*                CLUSTER reduce 131 */
  {  78, 481, 0                    }, /*                   STAR reduce 131 */
  {  79, 481, &yyActionTable[ 378] }, /*                 STRING reduce 131 */
  {   4, 481, 0                    }, /*                     AS reduce 131 */
  {  81, 481, 0                    }, /*                   TEMP reduce 131 */
  {  18, 481, 0                    }, /*                 CONCAT reduce 131 */
  {  19, 481, 0                    }, /*             CONSTRAINT reduce 131 */
  {   5, 481, 0                    }, /*                    ASC reduce 131 */
  {  85, 481, 0                    }, /*                  UNION reduce 131 */
  {  86, 481, 0                    }, /*                 UNIQUE reduce 131 */
  {   7, 481, 0                    }, /*                BETWEEN reduce 131 */
  {  24, 481, 0                    }, /*             DELIMITERS reduce 131 */
  {  89, 481, &yyActionTable[ 380] }, /*                 VACUUM reduce 131 */
  {   8, 481, 0                    }, /*                 BITAND reduce 131 */
  {  91, 481, &yyActionTable[ 387] }, /*                  WHERE reduce 131 */
  {  10, 481, 0                    }, /*                  BITOR reduce 131 */
  {  29, 481, 0                    }, /*                    END reduce 131 */
  {  12, 481, 0                    }, /*                  CHECK reduce 131 */
  {  31, 481, 0                    }, /*                     EQ reduce 131 */
  {  32, 481, 0                    }, /*                 EXCEPT reduce 131 */
  {  33, 481, 0                    }, /*                EXPLAIN reduce 131 */
  {  15, 481, 0                    }, /*                  COMMA reduce 131 */
  {  35, 481, 0                    }, /*                   FROM reduce 131 */
  {  25, 481, 0                    }, /*                   DESC reduce 131 */
  {  37, 481, 0                    }, /*                     GE reduce 131 */
  {  38, 481, 0                    }, /*                   GLOB reduce 131 */
  {  39, 481, 0                    }, /*                  GROUP reduce 131 */
  {  40, 481, 0                    }, /*                     GT reduce 131 */
  {  41, 481, 0                    }, /*                 HAVING reduce 131 */
  {  42, 481, 0                    }, /*                     ID reduce 131 */
  {  27, 384, 0                    }, /*                    DOT reduce 34 */
  {  44, 481, 0                    }, /*                     IN reduce 131 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  48, 481, 0                    }, /*              INTERSECT reduce 131 */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 481, 0                    }, /*                     IS reduce 131 */
  {  51, 481, 0                    }, /*                 ISNULL reduce 131 */
  {YYNOCODE,0,0}, /* Unused */
  {  53, 481, 0                    }, /*                     LE reduce 131 */
  {  54, 481, 0                    }, /*                   LIKE reduce 131 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 481, 0                    }, /*                 LSHIFT reduce 131 */
  {  57, 481, 0                    }, /*                     LT reduce 131 */
  {  58, 481, 0                    }, /*                  MINUS reduce 131 */
  {  59, 481, 0                    }, /*                     NE reduce 131 */
  {  60, 481, 0                    }, /*                    NOT reduce 131 */
  {  61, 481, 0                    }, /*                NOTNULL reduce 131 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 57 */
  {  64, 485, &yyActionTable[ 417] }, /*                     OR reduce 135 */
  {  65, 485, 0                    }, /*                  ORDER reduce 135 */
  {  66, 485, 0                    }, /*                   PLUS reduce 135 */
  {  67, 485, &yyActionTable[ 419] }, /*                 PRAGMA reduce 135 */
  {  68, 485, &yyActionTable[ 424] }, /*                PRIMARY reduce 135 */
  {  69, 485, &yyActionTable[ 428] }, /*                    REM reduce 135 */
  {   6, 485, 0                    }, /*                  BEGIN reduce 135 */
  {  71, 485, &yyActionTable[ 431] }, /*                     RP reduce 135 */
  {  72, 485, &yyActionTable[ 434] }, /*                 RSHIFT reduce 135 */
  {   0, 485, 0                    }, /*                      $ reduce 135 */
  {  74, 485, &yyActionTable[ 436] }, /*                   SEMI reduce 135 */
  {   3, 485, 0                    }, /*                    AND reduce 135 */
  {  76, 485, &yyActionTable[ 438] }, /*                  SLASH reduce 135 */
  {  13, 485, 0                    }, /*                CLUSTER reduce 135 */
  {  78, 485, 0                    }, /*                   STAR reduce 135 */
  {  79, 485, &yyActionTable[ 442] }, /*                 STRING reduce 135 */
  {   4, 485, 0                    }, /*                     AS reduce 135 */
  {  81, 485, 0                    }, /*                   TEMP reduce 135 */
  {  18, 485, 0                    }, /*                 CONCAT reduce 135 */
  {  19, 485, 0                    }, /*             CONSTRAINT reduce 135 */
  {   5, 485, 0                    }, /*                    ASC reduce 135 */
  {  85, 485, 0                    }, /*                  UNION reduce 135 */
  {  86, 485, 0                    }, /*                 UNIQUE reduce 135 */
  {   7, 485, 0                    }, /*                BETWEEN reduce 135 */
  {  24, 485, 0                    }, /*             DELIMITERS reduce 135 */
  {  89, 485, &yyActionTable[ 444] }, /*                 VACUUM reduce 135 */
  {   8, 485, 0                    }, /*                 BITAND reduce 135 */
  {  91, 485, &yyActionTable[ 451] }, /*                  WHERE reduce 135 */
  {  10, 485, 0                    }, /*                  BITOR reduce 135 */
  {  29, 485, 0                    }, /*                    END reduce 135 */
  {  12, 485, 0                    }, /*                  CHECK reduce 135 */
  {  31, 485, 0                    }, /*                     EQ reduce 135 */
  {  32, 485, 0                    }, /*                 EXCEPT reduce 135 */
  {  33, 485, 0                    }, /*                EXPLAIN reduce 135 */
  {  15, 485, 0                    }, /*                  COMMA reduce 135 */
  {  35, 485, 0                    }, /*                   FROM reduce 135 */
  {  25, 485, 0                    }, /*                   DESC reduce 135 */
  {  37, 485, 0                    }, /*                     GE reduce 135 */
  {  38, 485, 0                    }, /*                   GLOB reduce 135 */
  {  39, 485, 0                    }, /*                  GROUP reduce 135 */
  {  40, 485, 0                    }, /*                     GT reduce 135 */
  {  41, 485, 0                    }, /*                 HAVING reduce 135 */
  {  42, 485, 0                    }, /*                     ID reduce 135 */
  {  27, 385, 0                    }, /*                    DOT reduce 35 */
  {  44, 485, 0                    }, /*                     IN reduce 135 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  48, 485, 0                    }, /*              INTERSECT reduce 135 */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 485, 0                    }, /*                     IS reduce 135 */
  {  51, 485, 0                    }, /*                 ISNULL reduce 135 */
  {YYNOCODE,0,0}, /* Unused */
  {  53, 485, 0                    }, /*                     LE reduce 135 */
  {  54, 485, 0                    }, /*                   LIKE reduce 135 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 485, 0                    }, /*                 LSHIFT reduce 135 */
  {  57, 485, 0                    }, /*                     LT reduce 135 */
  {  58, 485, 0                    }, /*                  MINUS reduce 135 */
  {  59, 485, 0                    }, /*                     NE reduce 135 */
  {  60, 485, 0                    }, /*                    NOT reduce 135 */
  {  61, 485, 0                    }, /*                NOTNULL reduce 135 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 58 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 472] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  { 133,  60, &yyActionTable[ 476] }, /*                 select shift  60 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  73,  63, &yyActionTable[ 479] }, /*                 SELECT shift  63 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  { 109, 198, &yyActionTable[ 480] }, /*                   expr shift  198 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 483] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 484] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 59 */
  {YYNOCODE,0,0}, /* Unused */
/* State 60 */
  {  48, 142, &yyActionTable[ 506] }, /*              INTERSECT shift  142 */
  {  32, 143, 0                    }, /*                 EXCEPT shift  143 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 124,  61, 0                    }, /*                 joinop shift  61 */
  {  85, 140, 0                    }, /*                  UNION shift  140 */
  {YYNOCODE,0,0}, /* Unused */
  {  71, 197, 0                    }, /*                     RP shift  197 */
/* State 61 */
  {  73,  63, 0                    }, /*                 SELECT shift  63 */
  { 127,  62, &yyActionTable[ 513] }, /*              oneselect shift  62 */
/* State 62 */
  {YYNOCODE,0,0}, /* Unused */
/* State 63 */
  {   2, 196, 0                    }, /*                    ALL shift  196 */
  { 105,  64, 0                    }, /*               distinct shift  64 */
  {  26, 195, &yyActionTable[ 516] }, /*               DISTINCT shift  195 */
  {YYNOCODE,0,0}, /* Unused */
/* State 64 */
  { 132,  65, 0                    }, /*             selcollist shift  65 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 190, 0                    }, /*                   STAR shift  190 */
  { 131, 191, 0                    }, /*                   sclp shift  191 */
/* State 65 */
  { 112,  66, 0                    }, /*                   from shift  66 */
  {  15, 181, 0                    }, /*                  COMMA shift  181 */
  {YYNOCODE,0,0}, /* Unused */
  {  35, 182, &yyActionTable[ 525] }, /*                   FROM shift  182 */
/* State 66 */
  {  91, 179, 0                    }, /*                  WHERE shift  179 */
  { 147,  67, &yyActionTable[ 528] }, /*              where_opt shift  67 */
/* State 67 */
  {  39, 176, 0                    }, /*                  GROUP shift  176 */
  { 113,  68, &yyActionTable[ 530] }, /*            groupby_opt shift  68 */
/* State 68 */
  { 114,  69, 0                    }, /*             having_opt shift  69 */
  {  41, 174, 0                    }, /*                 HAVING shift  174 */
/* State 69 */
  { 128,  70, 0                    }, /*            orderby_opt shift  70 */
  {  65,  71, 0                    }, /*                  ORDER shift  71 */
/* State 70 */
  {YYNOCODE,0,0}, /* Unused */
/* State 71 */
  {  11,  72, 0                    }, /*                     BY shift  72 */
/* State 72 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 538] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  { 137, 172, &yyActionTable[ 542] }, /*               sortitem shift  172 */
  { 138,  73, &yyActionTable[ 545] }, /*               sortlist shift  73 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  { 109,  77, &yyActionTable[ 546] }, /*                   expr shift  77 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 549] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 550] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 73 */
  {  15,  74, 0                    }, /*                  COMMA shift  74 */
/* State 74 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 571] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  { 137,  75, &yyActionTable[ 575] }, /*               sortitem shift  75 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  77, &yyActionTable[ 578] }, /*                   expr shift  77 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 579] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 582] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 75 */
  {   5,  49, 0                    }, /*                    ASC shift  49 */
  {  25,  50, &yyActionTable[ 603] }, /*                   DESC shift  50 */
  {YYNOCODE,0,0}, /* Unused */
  { 139,  76, 0                    }, /*              sortorder shift  76 */
/* State 76 */
  {YYNOCODE,0,0}, /* Unused */
/* State 77 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[ 617] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[ 609] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[ 612] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[ 619] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[ 621] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 78 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 640] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  85, &yyActionTable[ 644] }, /*                   expr shift  85 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 647] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 648] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 80 */
  {  27,  81, 0                    }, /*                    DOT shift  81 */
/* State 81 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[ 674] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[ 676] }, /*                     id shift  21 */
  { 116,  82, 0                    }, /*                    ids shift  82 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 681] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[ 685] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 82 */
  {YYNOCODE,0,0}, /* Unused */
/* State 83 */
  {YYNOCODE,0,0}, /* Unused */
/* State 84 */
  {YYNOCODE,0,0}, /* Unused */
/* State 85 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  40,  90, &yyActionTable[ 696] }, /*                     GT shift  90 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  69, 123, &yyActionTable[ 693] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[ 694] }, /*                 RSHIFT shift  106 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, &yyActionTable[ 697] }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[ 702] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 86 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 725] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  87, &yyActionTable[ 729] }, /*                   expr shift  87 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 732] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 733] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 87 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  40,  90, &yyActionTable[ 761] }, /*                     GT shift  90 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  69, 123, &yyActionTable[ 757] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[ 758] }, /*                 RSHIFT shift  106 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  76, 121, &yyActionTable[ 766] }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[ 768] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 88 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 789] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  89, &yyActionTable[ 793] }, /*                   expr shift  89 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 796] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 797] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 89 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  56, 104, &yyActionTable[ 824] }, /*                 LSHIFT shift  104 */
  {  66, 115, &yyActionTable[ 821] }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  72, 106, &yyActionTable[ 822] }, /*                 RSHIFT shift  106 */
  {YYNOCODE,0,0}, /* Unused */
  {  58, 117, &yyActionTable[ 825] }, /*                  MINUS shift  117 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 90 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 837] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  91, &yyActionTable[ 841] }, /*                   expr shift  91 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 844] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 845] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 91 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  56, 104, &yyActionTable[ 872] }, /*                 LSHIFT shift  104 */
  {  66, 115, &yyActionTable[ 869] }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  72, 106, &yyActionTable[ 870] }, /*                 RSHIFT shift  106 */
  {YYNOCODE,0,0}, /* Unused */
  {  58, 117, &yyActionTable[ 873] }, /*                  MINUS shift  117 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 92 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 885] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  93, &yyActionTable[ 889] }, /*                   expr shift  93 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 892] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 893] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 93 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  56, 104, &yyActionTable[ 920] }, /*                 LSHIFT shift  104 */
  {  66, 115, &yyActionTable[ 917] }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  72, 106, &yyActionTable[ 918] }, /*                 RSHIFT shift  106 */
  {YYNOCODE,0,0}, /* Unused */
  {  58, 117, &yyActionTable[ 921] }, /*                  MINUS shift  117 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 94 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 933] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  95, &yyActionTable[ 937] }, /*                   expr shift  95 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 940] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 941] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 95 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  56, 104, &yyActionTable[ 968] }, /*                 LSHIFT shift  104 */
  {  66, 115, &yyActionTable[ 965] }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  72, 106, &yyActionTable[ 966] }, /*                 RSHIFT shift  106 */
  {YYNOCODE,0,0}, /* Unused */
  {  58, 117, &yyActionTable[ 969] }, /*                  MINUS shift  117 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 96 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[ 981] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  97, &yyActionTable[ 985] }, /*                   expr shift  97 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[ 988] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[ 989] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 97 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  53,  92, &yyActionTable[1016] }, /*                     LE shift  92 */
  {  66, 115, &yyActionTable[1013] }, /*                   PLUS shift  115 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  56, 104, &yyActionTable[1019] }, /*                 LSHIFT shift  104 */
  {  69, 123, &yyActionTable[1014] }, /*                    REM shift  123 */
  {  40,  90, &yyActionTable[1020] }, /*                     GT shift  90 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  72, 106, &yyActionTable[1017] }, /*                 RSHIFT shift  106 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, &yyActionTable[1024] }, /*                  MINUS shift  117 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 98 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1029] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109,  99, &yyActionTable[1033] }, /*                   expr shift  99 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1036] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1037] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 99 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  53,  92, &yyActionTable[1064] }, /*                     LE shift  92 */
  {  66, 115, &yyActionTable[1061] }, /*                   PLUS shift  115 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  56, 104, &yyActionTable[1067] }, /*                 LSHIFT shift  104 */
  {  69, 123, &yyActionTable[1062] }, /*                    REM shift  123 */
  {  40,  90, &yyActionTable[1068] }, /*                     GT shift  90 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  72, 106, &yyActionTable[1065] }, /*                 RSHIFT shift  106 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, &yyActionTable[1072] }, /*                  MINUS shift  117 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 100 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1077] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 101, &yyActionTable[1081] }, /*                   expr shift  101 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1084] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1085] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 101 */
  {  58, 117, &yyActionTable[1110] }, /*                  MINUS shift  117 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  66, 115, &yyActionTable[1109] }, /*                   PLUS shift  115 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 102 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1117] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 103, &yyActionTable[1121] }, /*                   expr shift  103 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1124] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1125] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 103 */
  {  58, 117, &yyActionTable[1150] }, /*                  MINUS shift  117 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  66, 115, &yyActionTable[1149] }, /*                   PLUS shift  115 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 104 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1157] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 105, &yyActionTable[1161] }, /*                   expr shift  105 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1164] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1165] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 105 */
  {  58, 117, &yyActionTable[1190] }, /*                  MINUS shift  117 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  66, 115, &yyActionTable[1189] }, /*                   PLUS shift  115 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 106 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1197] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 107, &yyActionTable[1201] }, /*                   expr shift  107 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1204] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1205] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 107 */
  {  58, 117, &yyActionTable[1230] }, /*                  MINUS shift  117 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  66, 115, &yyActionTable[1229] }, /*                   PLUS shift  115 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 108 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1237] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 109, &yyActionTable[1241] }, /*                   expr shift  109 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1244] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1245] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 109 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  53,  92, &yyActionTable[1272] }, /*                     LE shift  92 */
  {  66, 115, &yyActionTable[1269] }, /*                   PLUS shift  115 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  56, 104, &yyActionTable[1275] }, /*                 LSHIFT shift  104 */
  {  69, 123, &yyActionTable[1270] }, /*                    REM shift  123 */
  {  40,  90, &yyActionTable[1276] }, /*                     GT shift  90 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  72, 106, &yyActionTable[1273] }, /*                 RSHIFT shift  106 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, &yyActionTable[1280] }, /*                  MINUS shift  117 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 110 */
  {  54, 111, &yyActionTable[1286] }, /*                   LIKE shift  111 */
  {  38, 159, 0                    }, /*                   GLOB shift  159 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  44, 166, 0                    }, /*                     IN shift  166 */
  {YYNOCODE,0,0}, /* Unused */
  {  62, 161, &yyActionTable[1285] }, /*                   NULL shift  161 */
  {   7, 162, 0                    }, /*                BETWEEN shift  162 */
/* State 111 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1293] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 112, &yyActionTable[1297] }, /*                   expr shift  112 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1300] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1301] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 112 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  40,  90, &yyActionTable[1328] }, /*                     GT shift  90 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  69, 123, &yyActionTable[1325] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[1326] }, /*                 RSHIFT shift  106 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, &yyActionTable[1329] }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[1334] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 113 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1357] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 114, &yyActionTable[1361] }, /*                   expr shift  114 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1364] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1365] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 114 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  53,  92, &yyActionTable[1392] }, /*                     LE shift  92 */
  {  66, 115, &yyActionTable[1389] }, /*                   PLUS shift  115 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  56, 104, &yyActionTable[1395] }, /*                 LSHIFT shift  104 */
  {  69, 123, &yyActionTable[1390] }, /*                    REM shift  123 */
  {  40,  90, &yyActionTable[1396] }, /*                     GT shift  90 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  72, 106, &yyActionTable[1393] }, /*                 RSHIFT shift  106 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, &yyActionTable[1400] }, /*                  MINUS shift  117 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
/* State 115 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1405] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 116, &yyActionTable[1409] }, /*                   expr shift  116 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1412] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1413] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 116 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {  78, 119, &yyActionTable[1440] }, /*                   STAR shift  119 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
/* State 117 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1441] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 118, &yyActionTable[1445] }, /*                   expr shift  118 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1448] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1449] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 118 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  69, 123, 0                    }, /*                    REM shift  123 */
  {  78, 119, &yyActionTable[1476] }, /*                   STAR shift  119 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
/* State 119 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1477] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 120, &yyActionTable[1481] }, /*                   expr shift  120 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1484] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1485] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 120 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
/* State 121 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1510] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 122, &yyActionTable[1514] }, /*                   expr shift  122 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1517] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1518] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 122 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
/* State 123 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1543] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 124, &yyActionTable[1547] }, /*                   expr shift  124 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1550] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1551] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 124 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
/* State 125 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1576] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 126, &yyActionTable[1580] }, /*                   expr shift  126 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1583] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1584] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 126 */
  {YYNOCODE,0,0}, /* Unused */
/* State 127 */
  {YYNOCODE,0,0}, /* Unused */
/* State 128 */
  {  62, 129, &yyActionTable[1611] }, /*                   NULL shift  129 */
  {  60, 130, 0                    }, /*                    NOT shift  130 */
/* State 129 */
  {YYNOCODE,0,0}, /* Unused */
/* State 130 */
  {  62, 131, 0                    }, /*                   NULL shift  131 */
/* State 131 */
  {YYNOCODE,0,0}, /* Unused */
/* State 132 */
  {YYNOCODE,0,0}, /* Unused */
/* State 133 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1616] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 134, &yyActionTable[1620] }, /*                   expr shift  134 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1623] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1624] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 134 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3, 135, 0                    }, /*                    AND shift  135 */
  {  40,  90, &yyActionTable[1657] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[1649] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[1652] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[1659] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[1661] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 135 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1680] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 136, &yyActionTable[1684] }, /*                   expr shift  136 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1687] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1688] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 136 */
  {  64, 520, &yyActionTable[1721] }, /*                     OR reduce 170 */
  {  65, 520, 0                    }, /*                  ORDER reduce 170 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {  67, 520, &yyActionTable[1723] }, /*                 PRAGMA reduce 170 */
  {  68, 520, &yyActionTable[1728] }, /*                PRIMARY reduce 170 */
  {  69, 123, &yyActionTable[1732] }, /*                    REM shift  123 */
  {   6, 520, 0                    }, /*                  BEGIN reduce 170 */
  {  71, 520, &yyActionTable[1735] }, /*                     RP reduce 170 */
  {  72, 106, &yyActionTable[1738] }, /*                 RSHIFT shift  106 */
  {  64, 488, &yyActionTable[1740] }, /*                     OR reduce 138 */
  {  74, 520, &yyActionTable[1742] }, /*                   SEMI reduce 170 */
  {   3, 520, &yyActionTable[1746] }, /*                    AND reduce 170 */
  {  76, 121, &yyActionTable[1748] }, /*                  SLASH shift  121 */
  {  13, 520, 0                    }, /*                CLUSTER reduce 170 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {  79, 520, &yyActionTable[1755] }, /*                 STRING reduce 170 */
  {   4, 520, 0                    }, /*                     AS reduce 170 */
  {  81, 520, 0                    }, /*                   TEMP reduce 170 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  19, 520, 0                    }, /*             CONSTRAINT reduce 170 */
  {   5, 520, 0                    }, /*                    ASC reduce 170 */
  {  85, 520, 0                    }, /*                  UNION reduce 170 */
  {  86, 520, 0                    }, /*                 UNIQUE reduce 170 */
  {   7, 520, 0                    }, /*                BETWEEN reduce 170 */
  {  24, 520, 0                    }, /*             DELIMITERS reduce 170 */
  {  89, 520, &yyActionTable[1757] }, /*                 VACUUM reduce 170 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  91, 520, 0                    }, /*                  WHERE reduce 170 */
  {   0, 520, 0                    }, /*                      $ reduce 170 */
  {  29, 520, 0                    }, /*                    END reduce 170 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  31, 520, 0                    }, /*                     EQ reduce 170 */
  {  32, 520, 0                    }, /*                 EXCEPT reduce 170 */
  {  33, 520, 0                    }, /*                EXPLAIN reduce 170 */
  {   3, 488, 0                    }, /*                    AND reduce 138 */
  {  35, 520, 0                    }, /*                   FROM reduce 170 */
  {  12, 520, 0                    }, /*                  CHECK reduce 170 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  38, 520, 0                    }, /*                   GLOB reduce 170 */
  {  39, 520, 0                    }, /*                  GROUP reduce 170 */
  {  40,  90, 0                    }, /*                     GT shift  90 */
  {  41, 520, 0                    }, /*                 HAVING reduce 170 */
  {  42, 520, 0                    }, /*                     ID reduce 170 */
  {  15, 520, 0                    }, /*                  COMMA reduce 170 */
  {  44, 520, 0                    }, /*                     IN reduce 170 */
  {  25, 520, 0                    }, /*                   DESC reduce 170 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  48, 520, 0                    }, /*              INTERSECT reduce 170 */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 520, 0                    }, /*                     IS reduce 170 */
  {  51, 520, 0                    }, /*                 ISNULL reduce 170 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 520, 0                    }, /*                   LIKE reduce 170 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59, 520, 0                    }, /*                     NE reduce 170 */
  {  60, 520, 0                    }, /*                    NOT reduce 170 */
  {  61, 520, 0                    }, /*                NOTNULL reduce 170 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 137 */
  {  55, 138, 0                    }, /*                     LP shift  138 */
/* State 138 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1777] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  { 133, 139, &yyActionTable[1781] }, /*                 select shift  139 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  73,  63, &yyActionTable[1784] }, /*                 SELECT shift  63 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  79,  57, &yyActionTable[1789] }, /*                 STRING shift  57 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  { 109, 145, &yyActionTable[1785] }, /*                   expr shift  145 */
  { 110, 158, 0                    }, /*               expritem shift  158 */
  { 111, 154, &yyActionTable[1788] }, /*               exprlist shift  154 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1793] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 139 */
  {  48, 142, &yyActionTable[1810] }, /*              INTERSECT shift  142 */
  {  32, 143, 0                    }, /*                 EXCEPT shift  143 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 124,  61, 0                    }, /*                 joinop shift  61 */
  {  85, 140, 0                    }, /*                  UNION shift  140 */
  {YYNOCODE,0,0}, /* Unused */
  {  71, 144, 0                    }, /*                     RP shift  144 */
/* State 140 */
  {   2, 141, 0                    }, /*                    ALL shift  141 */
  {  73, 425, 0                    }, /*                 SELECT reduce 75 */
/* State 141 */
  {  73, 426, 0                    }, /*                 SELECT reduce 76 */
/* State 142 */
  {  73, 427, 0                    }, /*                 SELECT reduce 77 */
/* State 143 */
  {  73, 428, 0                    }, /*                 SELECT reduce 78 */
/* State 144 */
  {YYNOCODE,0,0}, /* Unused */
/* State 145 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[1832] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[1824] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[1827] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[1834] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[1836] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 146 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1855] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 147, &yyActionTable[1859] }, /*                   expr shift  147 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1862] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1863] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 147 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  40,  90, &yyActionTable[1890] }, /*                     GT shift  90 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  69, 123, &yyActionTable[1887] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[1888] }, /*                 RSHIFT shift  106 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, &yyActionTable[1891] }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[1896] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 148 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1919] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 149, &yyActionTable[1923] }, /*                   expr shift  149 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1926] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1927] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 149 */
  {YYNOCODE,0,0}, /* Unused */
/* State 150 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1952] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 151, &yyActionTable[1956] }, /*                   expr shift  151 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1959] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1960] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 151 */
  {YYNOCODE,0,0}, /* Unused */
/* State 152 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[1985] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 153, &yyActionTable[1989] }, /*                   expr shift  153 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[1992] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[1993] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 153 */
  {YYNOCODE,0,0}, /* Unused */
/* State 154 */
  {  15, 156, 0                    }, /*                  COMMA shift  156 */
  {  71, 155, &yyActionTable[2018] }, /*                     RP shift  155 */
/* State 155 */
  {YYNOCODE,0,0}, /* Unused */
/* State 156 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2021] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 145, &yyActionTable[2025] }, /*                   expr shift  145 */
  { 110, 157, 0                    }, /*               expritem shift  157 */
  {  79,  57, &yyActionTable[2028] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2029] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 157 */
  {YYNOCODE,0,0}, /* Unused */
/* State 158 */
  {YYNOCODE,0,0}, /* Unused */
/* State 159 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2055] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 160, &yyActionTable[2059] }, /*                   expr shift  160 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2062] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2063] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 160 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  40,  90, &yyActionTable[2090] }, /*                     GT shift  90 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  69, 123, &yyActionTable[2087] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[2088] }, /*                 RSHIFT shift  106 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {YYNOCODE,0,0}, /* Unused */
  {  76, 121, &yyActionTable[2091] }, /*                  SLASH shift  121 */
  {YYNOCODE,0,0}, /* Unused */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2096] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 161 */
  {YYNOCODE,0,0}, /* Unused */
/* State 162 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2120] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 163, &yyActionTable[2124] }, /*                   expr shift  163 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2127] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2128] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 163 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3, 164, 0                    }, /*                    AND shift  164 */
  {  40,  90, &yyActionTable[2161] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[2153] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[2156] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[2163] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2165] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 164 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2184] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 165, &yyActionTable[2188] }, /*                   expr shift  165 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2191] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2192] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 165 */
  {  64, 521, &yyActionTable[2225] }, /*                     OR reduce 171 */
  {  65, 521, 0                    }, /*                  ORDER reduce 171 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {  67, 521, &yyActionTable[2227] }, /*                 PRAGMA reduce 171 */
  {  68, 521, &yyActionTable[2232] }, /*                PRIMARY reduce 171 */
  {  69, 123, &yyActionTable[2236] }, /*                    REM shift  123 */
  {   6, 521, 0                    }, /*                  BEGIN reduce 171 */
  {  71, 521, &yyActionTable[2239] }, /*                     RP reduce 171 */
  {  72, 106, &yyActionTable[2242] }, /*                 RSHIFT shift  106 */
  {  64, 488, &yyActionTable[2244] }, /*                     OR reduce 138 */
  {  74, 521, &yyActionTable[2246] }, /*                   SEMI reduce 171 */
  {   3, 521, &yyActionTable[2250] }, /*                    AND reduce 171 */
  {  76, 121, &yyActionTable[2252] }, /*                  SLASH shift  121 */
  {  13, 521, 0                    }, /*                CLUSTER reduce 171 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {  79, 521, &yyActionTable[2259] }, /*                 STRING reduce 171 */
  {   4, 521, 0                    }, /*                     AS reduce 171 */
  {  81, 521, 0                    }, /*                   TEMP reduce 171 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  19, 521, 0                    }, /*             CONSTRAINT reduce 171 */
  {   5, 521, 0                    }, /*                    ASC reduce 171 */
  {  85, 521, 0                    }, /*                  UNION reduce 171 */
  {  86, 521, 0                    }, /*                 UNIQUE reduce 171 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  24, 521, 0                    }, /*             DELIMITERS reduce 171 */
  {  89, 521, &yyActionTable[2261] }, /*                 VACUUM reduce 171 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  91, 521, 0                    }, /*                  WHERE reduce 171 */
  {   0, 521, 0                    }, /*                      $ reduce 171 */
  {  29, 521, 0                    }, /*                    END reduce 171 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
  {  32, 521, 0                    }, /*                 EXCEPT reduce 171 */
  {  33, 521, 0                    }, /*                EXPLAIN reduce 171 */
  {   3, 488, 0                    }, /*                    AND reduce 138 */
  {  35, 521, 0                    }, /*                   FROM reduce 171 */
  {  12, 521, 0                    }, /*                  CHECK reduce 171 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {  39, 521, 0                    }, /*                  GROUP reduce 171 */
  {  40,  90, 0                    }, /*                     GT shift  90 */
  {  41, 521, 0                    }, /*                 HAVING reduce 171 */
  {  42, 521, 0                    }, /*                     ID reduce 171 */
  {  15, 521, 0                    }, /*                  COMMA reduce 171 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  25, 521, 0                    }, /*                   DESC reduce 171 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  48, 521, 0                    }, /*              INTERSECT reduce 171 */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, 0                    }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 166 */
  {  55, 167, 0                    }, /*                     LP shift  167 */
/* State 167 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2281] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  { 133, 168, &yyActionTable[2285] }, /*                 select shift  168 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  73,  63, &yyActionTable[2288] }, /*                 SELECT shift  63 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  79,  57, &yyActionTable[2293] }, /*                 STRING shift  57 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  { 109, 145, &yyActionTable[2289] }, /*                   expr shift  145 */
  { 110, 158, 0                    }, /*               expritem shift  158 */
  { 111, 170, &yyActionTable[2292] }, /*               exprlist shift  170 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2297] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 168 */
  {  48, 142, &yyActionTable[2314] }, /*              INTERSECT shift  142 */
  {  32, 143, 0                    }, /*                 EXCEPT shift  143 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 124,  61, 0                    }, /*                 joinop shift  61 */
  {  85, 140, 0                    }, /*                  UNION shift  140 */
  {YYNOCODE,0,0}, /* Unused */
  {  71, 169, 0                    }, /*                     RP shift  169 */
/* State 169 */
  {YYNOCODE,0,0}, /* Unused */
/* State 170 */
  {  15, 156, 0                    }, /*                  COMMA shift  156 */
  {  71, 171, &yyActionTable[2322] }, /*                     RP shift  171 */
/* State 171 */
  {YYNOCODE,0,0}, /* Unused */
/* State 172 */
  {   5,  49, 0                    }, /*                    ASC shift  49 */
  {  25,  50, &yyActionTable[2325] }, /*                   DESC shift  50 */
  {YYNOCODE,0,0}, /* Unused */
  { 139, 173, 0                    }, /*              sortorder shift  173 */
/* State 173 */
  {YYNOCODE,0,0}, /* Unused */
/* State 174 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2330] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 175, &yyActionTable[2334] }, /*                   expr shift  175 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2337] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2338] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 175 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[2371] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[2363] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[2366] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[2373] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2375] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 176 */
  {  11, 177, 0                    }, /*                     BY shift  177 */
/* State 177 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2395] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  79,  57, &yyActionTable[2403] }, /*                 STRING shift  57 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 145, &yyActionTable[2399] }, /*                   expr shift  145 */
  { 110, 158, 0                    }, /*               expritem shift  158 */
  { 111, 178, &yyActionTable[2402] }, /*               exprlist shift  178 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2406] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 178 */
  {  15, 156, 0                    }, /*                  COMMA shift  156 */
/* State 179 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2428] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 180, &yyActionTable[2432] }, /*                   expr shift  180 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2435] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2436] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 180 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[2469] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[2461] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[2464] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[2471] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2473] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 181 */
  {YYNOCODE,0,0}, /* Unused */
/* State 182 */
  { 140, 185, &yyActionTable[2494] }, /*             stl_prefix shift  185 */
  { 134, 183, 0                    }, /*             seltablist shift  183 */
/* State 183 */
  {  15, 184, 0                    }, /*                  COMMA shift  184 */
/* State 184 */
  {YYNOCODE,0,0}, /* Unused */
/* State 185 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2497] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2499] }, /*                     id shift  21 */
  { 116, 186, 0                    }, /*                    ids shift  186 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2504] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[2508] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 186 */
  {  32, 443, &yyActionTable[2515] }, /*                 EXCEPT reduce 93 */
  {  65, 443, &yyActionTable[2521] }, /*                  ORDER reduce 93 */
  {   0, 443, 0                    }, /*                      $ reduce 93 */
  {  67, 438, 0                    }, /*                 PRAGMA reduce 88 */
  {   4, 187, 0                    }, /*                     AS shift  187 */
  {   5, 438, 0                    }, /*                    ASC reduce 88 */
  {   6, 438, 0                    }, /*                  BEGIN reduce 88 */
  {  71, 443, &yyActionTable[2524] }, /*                     RP reduce 93 */
  {  33, 438, 0                    }, /*                EXPLAIN reduce 88 */
  {  41, 443, 0                    }, /*                 HAVING reduce 93 */
  {  74, 443, &yyActionTable[2525] }, /*                   SEMI reduce 93 */
  {  39, 443, 0                    }, /*                  GROUP reduce 93 */
  {  42, 438, 0                    }, /*                     ID reduce 88 */
  {  13, 438, 0                    }, /*                CLUSTER reduce 88 */
  {  15, 443, 0                    }, /*                  COMMA reduce 93 */
  {  79, 438, &yyActionTable[2527] }, /*                 STRING reduce 88 */
  {  48, 443, 0                    }, /*              INTERSECT reduce 93 */
  {  81, 438, 0                    }, /*                   TEMP reduce 88 */
  {  25, 438, 0                    }, /*                   DESC reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  85, 443, 0                    }, /*                  UNION reduce 93 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  24, 438, 0                    }, /*             DELIMITERS reduce 88 */
  {  89, 438, &yyActionTable[2531] }, /*                 VACUUM reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {  91, 443, 0                    }, /*                  WHERE reduce 93 */
  {  92, 188, 0                    }, /*                     as shift  188 */
  {  29, 438, 0                    }, /*                    END reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 187 */
  {YYNOCODE,0,0}, /* Unused */
/* State 188 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2546] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2548] }, /*                     id shift  21 */
  { 116, 189, 0                    }, /*                    ids shift  189 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2553] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[2557] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 189 */
  {YYNOCODE,0,0}, /* Unused */
/* State 190 */
  {YYNOCODE,0,0}, /* Unused */
/* State 191 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2564] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 192, &yyActionTable[2568] }, /*                   expr shift  192 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2571] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2572] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 192 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {  67, 438, &yyActionTable[2597] }, /*                 PRAGMA reduce 88 */
  {   4, 187, 0                    }, /*                     AS shift  187 */
  {  69, 123, &yyActionTable[2605] }, /*                    REM shift  123 */
  {   6, 438, 0                    }, /*                  BEGIN reduce 88 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[2607] }, /*                 RSHIFT shift  106 */
  {   5, 438, 0                    }, /*                    ASC reduce 88 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  76, 121, 0                    }, /*                  SLASH shift  121 */
  {  13, 438, 0                    }, /*                CLUSTER reduce 88 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {  79, 438, &yyActionTable[2612] }, /*                 STRING reduce 88 */
  {  15, 436, 0                    }, /*                  COMMA reduce 86 */
  {  81, 438, 0                    }, /*                   TEMP reduce 88 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  25, 438, 0                    }, /*                   DESC reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  24, 438, 0                    }, /*             DELIMITERS reduce 88 */
  {  89, 438, &yyActionTable[2615] }, /*                 VACUUM reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  92, 193, 0                    }, /*                     as shift  193 */
  {  29, 438, 0                    }, /*                    END reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
  {YYNOCODE,0,0}, /* Unused */
  {  33, 438, 0                    }, /*                EXPLAIN reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {  35, 436, 0                    }, /*                   FROM reduce 86 */
  {YYNOCODE,0,0}, /* Unused */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {YYNOCODE,0,0}, /* Unused */
  {  40,  90, 0                    }, /*                     GT shift  90 */
  {YYNOCODE,0,0}, /* Unused */
  {  42, 438, 0                    }, /*                     ID reduce 88 */
  {YYNOCODE,0,0}, /* Unused */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, 0                    }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
/* State 193 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2660] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2662] }, /*                     id shift  21 */
  { 116, 194, 0                    }, /*                    ids shift  194 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2667] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[2671] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 194 */
  {YYNOCODE,0,0}, /* Unused */
/* State 195 */
  {YYNOCODE,0,0}, /* Unused */
/* State 196 */
  {YYNOCODE,0,0}, /* Unused */
/* State 197 */
  {YYNOCODE,0,0}, /* Unused */
/* State 198 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  69, 123, &yyActionTable[2681] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {  71, 199, &yyActionTable[2684] }, /*                     RP shift  199 */
  {  72, 106, &yyActionTable[2689] }, /*                 RSHIFT shift  106 */
  {  40,  90, &yyActionTable[2691] }, /*                     GT shift  90 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  76, 121, &yyActionTable[2693] }, /*                  SLASH shift  121 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2695] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 199 */
  {YYNOCODE,0,0}, /* Unused */
/* State 200 */
  {  15, 156, 0                    }, /*                  COMMA shift  156 */
  {  71, 201, &yyActionTable[2713] }, /*                     RP shift  201 */
/* State 201 */
  {YYNOCODE,0,0}, /* Unused */
/* State 202 */
  {  71, 203, 0                    }, /*                     RP shift  203 */
/* State 203 */
  {YYNOCODE,0,0}, /* Unused */
/* State 204 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  69, 123, &yyActionTable[2719] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {  71, 205, &yyActionTable[2722] }, /*                     RP shift  205 */
  {  72, 106, &yyActionTable[2727] }, /*                 RSHIFT shift  106 */
  {  40,  90, &yyActionTable[2729] }, /*                     GT shift  90 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  76, 121, &yyActionTable[2731] }, /*                  SLASH shift  121 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2733] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 205 */
  {YYNOCODE,0,0}, /* Unused */
/* State 206 */
  {YYNOCODE,0,0}, /* Unused */
/* State 207 */
  {  58, 214, &yyActionTable[2753] }, /*                  MINUS shift  214 */
  {  42, 209, &yyActionTable[2755] }, /*                     ID shift  209 */
  {  66, 211, &yyActionTable[2752] }, /*                   PLUS shift  211 */
  {  34, 217, 0                    }, /*                  FLOAT shift  217 */
  {  47, 210, 0                    }, /*                INTEGER shift  210 */
  {YYNOCODE,0,0}, /* Unused */
  {  62, 218, 0                    }, /*                   NULL shift  218 */
  {  79, 208, &yyActionTable[2756] }, /*                 STRING shift  208 */
/* State 208 */
  {YYNOCODE,0,0}, /* Unused */
/* State 209 */
  {YYNOCODE,0,0}, /* Unused */
/* State 210 */
  {YYNOCODE,0,0}, /* Unused */
/* State 211 */
  {  34, 213, 0                    }, /*                  FLOAT shift  213 */
  {  47, 212, 0                    }, /*                INTEGER shift  212 */
/* State 212 */
  {YYNOCODE,0,0}, /* Unused */
/* State 213 */
  {YYNOCODE,0,0}, /* Unused */
/* State 214 */
  {  34, 216, 0                    }, /*                  FLOAT shift  216 */
  {  47, 215, 0                    }, /*                INTEGER shift  215 */
/* State 215 */
  {YYNOCODE,0,0}, /* Unused */
/* State 216 */
  {YYNOCODE,0,0}, /* Unused */
/* State 217 */
  {YYNOCODE,0,0}, /* Unused */
/* State 218 */
  {YYNOCODE,0,0}, /* Unused */
/* State 219 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2773] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2775] }, /*                     id shift  21 */
  { 116, 231, 0                    }, /*                    ids shift  231 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  55, 220, 0                    }, /*                     LP shift  220 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2784] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  29,  16, &yyActionTable[2785] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 220 */
  { 136, 221, 0                    }, /*                 signed shift  221 */
  {  58, 229, 0                    }, /*                  MINUS shift  229 */
  {  66, 227, &yyActionTable[2790] }, /*                   PLUS shift  227 */
  {  47, 226, 0                    }, /*                INTEGER shift  226 */
/* State 221 */
  {  15, 223, 0                    }, /*                  COMMA shift  223 */
  {  71, 222, &yyActionTable[2793] }, /*                     RP shift  222 */
/* State 222 */
  {YYNOCODE,0,0}, /* Unused */
/* State 223 */
  { 136, 224, 0                    }, /*                 signed shift  224 */
  {  58, 229, 0                    }, /*                  MINUS shift  229 */
  {  66, 227, &yyActionTable[2797] }, /*                   PLUS shift  227 */
  {  47, 226, 0                    }, /*                INTEGER shift  226 */
/* State 224 */
  {  71, 225, 0                    }, /*                     RP shift  225 */
/* State 225 */
  {YYNOCODE,0,0}, /* Unused */
/* State 226 */
  {YYNOCODE,0,0}, /* Unused */
/* State 227 */
  {  47, 228, 0                    }, /*                INTEGER shift  228 */
/* State 228 */
  {YYNOCODE,0,0}, /* Unused */
/* State 229 */
  {  47, 230, 0                    }, /*                INTEGER shift  230 */
/* State 230 */
  {YYNOCODE,0,0}, /* Unused */
/* State 231 */
  {YYNOCODE,0,0}, /* Unused */
/* State 232 */
  {YYNOCODE,0,0}, /* Unused */
/* State 233 */
  {YYNOCODE,0,0}, /* Unused */
/* State 234 */
  {  12, 252, 0                    }, /*                  CHECK shift  252 */
  {  15, 235, 0                    }, /*                  COMMA shift  235 */
  {YYNOCODE,0,0}, /* Unused */
  {  19, 237, 0                    }, /*             CONSTRAINT shift  237 */
  {  68, 239, &yyActionTable[2810] }, /*                PRIMARY shift  239 */
  { 141, 254, 0                    }, /*                  tcons shift  254 */
  {  86, 248, 0                    }, /*                 UNIQUE shift  248 */
  {  71, 413, &yyActionTable[2811] }, /*                     RP reduce 63 */
/* State 235 */
  {  12, 252, 0                    }, /*                  CHECK shift  252 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  19, 237, 0                    }, /*             CONSTRAINT shift  237 */
  {  68, 239, &yyActionTable[2818] }, /*                PRIMARY shift  239 */
  { 141, 236, 0                    }, /*                  tcons shift  236 */
  {  86, 248, 0                    }, /*                 UNIQUE shift  248 */
  {YYNOCODE,0,0}, /* Unused */
/* State 236 */
  {YYNOCODE,0,0}, /* Unused */
/* State 237 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2827] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2829] }, /*                     id shift  21 */
  { 116, 238, 0                    }, /*                    ids shift  238 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2834] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[2838] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 238 */
  {YYNOCODE,0,0}, /* Unused */
/* State 239 */
  {  52, 240, 0                    }, /*                    KEY shift  240 */
/* State 240 */
  {  55, 241, 0                    }, /*                     LP shift  241 */
/* State 241 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2846] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2848] }, /*                     id shift  21 */
  { 116, 246, 0                    }, /*                    ids shift  246 */
  { 117, 247, &yyActionTable[2853] }, /*                idxitem shift  247 */
  { 118, 242, &yyActionTable[2857] }, /*                idxlist shift  242 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2858] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  29,  16, &yyActionTable[2860] }, /*                    END shift  16 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 242 */
  {  15, 244, 0                    }, /*                  COMMA shift  244 */
  {  71, 243, &yyActionTable[2862] }, /*                     RP shift  243 */
/* State 243 */
  {YYNOCODE,0,0}, /* Unused */
/* State 244 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2865] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2867] }, /*                     id shift  21 */
  { 116, 246, 0                    }, /*                    ids shift  246 */
  { 117, 245, &yyActionTable[2872] }, /*                idxitem shift  245 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2876] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  29,  16, &yyActionTable[2877] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 245 */
  {YYNOCODE,0,0}, /* Unused */
/* State 246 */
  {YYNOCODE,0,0}, /* Unused */
/* State 247 */
  {YYNOCODE,0,0}, /* Unused */
/* State 248 */
  {  55, 249, 0                    }, /*                     LP shift  249 */
/* State 249 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2885] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2887] }, /*                     id shift  21 */
  { 116, 246, 0                    }, /*                    ids shift  246 */
  { 117, 247, &yyActionTable[2892] }, /*                idxitem shift  247 */
  { 118, 250, &yyActionTable[2896] }, /*                idxlist shift  250 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2897] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  29,  16, &yyActionTable[2899] }, /*                    END shift  16 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 250 */
  {  15, 244, 0                    }, /*                  COMMA shift  244 */
  {  71, 251, &yyActionTable[2901] }, /*                     RP shift  251 */
/* State 251 */
  {YYNOCODE,0,0}, /* Unused */
/* State 252 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[2904] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 253, &yyActionTable[2908] }, /*                   expr shift  253 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[2911] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2912] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 253 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[2945] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[2937] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[2940] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[2947] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[2949] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 254 */
  {YYNOCODE,0,0}, /* Unused */
/* State 255 */
  {YYNOCODE,0,0}, /* Unused */
/* State 256 */
  {YYNOCODE,0,0}, /* Unused */
/* State 257 */
  {  80, 367, 0                    }, /*                  TABLE reduce 17 */
  {  81, 261, 0                    }, /*                   TEMP shift  261 */
  { 146, 262, 0                    }, /*             uniqueflag shift  262 */
  {  86, 270, 0                    }, /*                 UNIQUE shift  270 */
  {YYNOCODE,0,0}, /* Unused */
  {  45, 532, 0                    }, /*                  INDEX reduce 182 */
  { 142, 258, &yyActionTable[2974] }, /*                   temp shift  258 */
  {YYNOCODE,0,0}, /* Unused */
/* State 258 */
  {  80, 259, 0                    }, /*                  TABLE shift  259 */
/* State 259 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2980] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[2982] }, /*                     id shift  21 */
  { 116, 260, 0                    }, /*                    ids shift  260 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[2987] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[2991] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 260 */
  {  55, 365, 0                    }, /*                     LP reduce 15 */
/* State 261 */
  {  80, 366, 0                    }, /*                  TABLE reduce 16 */
/* State 262 */
  {  45, 263, 0                    }, /*                  INDEX shift  263 */
/* State 263 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[2999] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3001] }, /*                     id shift  21 */
  { 116, 264, 0                    }, /*                    ids shift  264 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3006] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3010] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 264 */
  {  63, 265, 0                    }, /*                     ON shift  265 */
/* State 265 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3016] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3018] }, /*                     id shift  21 */
  { 116, 266, 0                    }, /*                    ids shift  266 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3023] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3027] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 266 */
  {  55, 267, 0                    }, /*                     LP shift  267 */
/* State 267 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3033] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3035] }, /*                     id shift  21 */
  { 116, 246, 0                    }, /*                    ids shift  246 */
  { 117, 247, &yyActionTable[3040] }, /*                idxitem shift  247 */
  { 118, 268, &yyActionTable[3044] }, /*                idxlist shift  268 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3045] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  29,  16, &yyActionTable[3047] }, /*                    END shift  16 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 268 */
  {  15, 244, 0                    }, /*                  COMMA shift  244 */
  {  71, 269, &yyActionTable[3049] }, /*                     RP shift  269 */
/* State 269 */
  {YYNOCODE,0,0}, /* Unused */
/* State 270 */
  {  45, 531, 0                    }, /*                  INDEX reduce 181 */
/* State 271 */
  {  80, 272, 0                    }, /*                  TABLE shift  272 */
  {  45, 274, 0                    }, /*                  INDEX shift  274 */
/* State 272 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3055] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3057] }, /*                     id shift  21 */
  { 116, 273, 0                    }, /*                    ids shift  273 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3062] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3066] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 273 */
  {YYNOCODE,0,0}, /* Unused */
/* State 274 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3072] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3074] }, /*                     id shift  21 */
  { 116, 275, 0                    }, /*                    ids shift  275 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3079] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3083] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 275 */
  {YYNOCODE,0,0}, /* Unused */
/* State 276 */
  { 124,  61, &yyActionTable[3091] }, /*                 joinop shift  61 */
  {  85, 140, 0                    }, /*                  UNION shift  140 */
  {  48, 142, &yyActionTable[3092] }, /*              INTERSECT shift  142 */
  {  32, 143, 0                    }, /*                 EXCEPT shift  143 */
/* State 277 */
  {  35, 278, 0                    }, /*                   FROM shift  278 */
/* State 278 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3094] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3096] }, /*                     id shift  21 */
  { 116, 279, 0                    }, /*                    ids shift  279 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3101] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3105] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 279 */
  {  91, 179, 0                    }, /*                  WHERE shift  179 */
  { 147, 280, &yyActionTable[3110] }, /*              where_opt shift  280 */
/* State 280 */
  {YYNOCODE,0,0}, /* Unused */
/* State 281 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3113] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3115] }, /*                     id shift  21 */
  { 116, 282, 0                    }, /*                    ids shift  282 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3120] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3124] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 282 */
  {  75, 283, 0                    }, /*                    SET shift  283 */
/* State 283 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3130] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3132] }, /*                     id shift  21 */
  { 116, 290, 0                    }, /*                    ids shift  290 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  { 135, 284, 0                    }, /*                setlist shift  284 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3141] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  29,  16, &yyActionTable[3142] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 284 */
  {  91, 179, &yyActionTable[3147] }, /*                  WHERE shift  179 */
  {  15, 286, 0                    }, /*                  COMMA shift  286 */
  {YYNOCODE,0,0}, /* Unused */
  { 147, 285, &yyActionTable[3146] }, /*              where_opt shift  285 */
/* State 285 */
  {YYNOCODE,0,0}, /* Unused */
/* State 286 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3151] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3153] }, /*                     id shift  21 */
  { 116, 287, 0                    }, /*                    ids shift  287 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3158] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3162] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 287 */
  {  31, 288, 0                    }, /*                     EQ shift  288 */
/* State 288 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[3168] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 289, &yyActionTable[3172] }, /*                   expr shift  289 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[3175] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3176] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 289 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[3209] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[3201] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[3204] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[3211] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[3213] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 290 */
  {  31, 291, 0                    }, /*                     EQ shift  291 */
/* State 291 */
  {  34,  84, 0                    }, /*                  FLOAT shift  84 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  66, 152, &yyActionTable[3233] }, /*                   PLUS shift  152 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  47,  83, 0                    }, /*                INTEGER shift  83 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {   9, 148, 0                    }, /*                 BITNOT shift  148 */
  {  42,  54, 0                    }, /*                     ID shift  54 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 109, 292, &yyActionTable[3237] }, /*                   expr shift  292 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  57, &yyActionTable[3240] }, /*                 STRING shift  57 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  56, 0                    }, /*                     id shift  56 */
  { 116,  80, 0                    }, /*                    ids shift  80 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  55,  58, 0                    }, /*                     LP shift  58 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3241] }, /*                 VACUUM shift  14 */
  {  58, 150, 0                    }, /*                  MINUS shift  150 */
  {YYNOCODE,0,0}, /* Unused */
  {  60, 146, 0                    }, /*                    NOT shift  146 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {  62,  79, 0                    }, /*                   NULL shift  79 */
  {YYNOCODE,0,0}, /* Unused */
/* State 292 */
  {  64,  86, 0                    }, /*                     OR shift  86 */
  {  37,  94, 0                    }, /*                     GE shift  94 */
  {  66, 115, 0                    }, /*                   PLUS shift  115 */
  {   3,  78, 0                    }, /*                    AND shift  78 */
  {  40,  90, &yyActionTable[3274] }, /*                     GT shift  90 */
  {  69, 123, &yyActionTable[3266] }, /*                    REM shift  123 */
  {  38, 113, 0                    }, /*                   GLOB shift  113 */
  {   7, 133, 0                    }, /*                BETWEEN shift  133 */
  {  72, 106, &yyActionTable[3269] }, /*                 RSHIFT shift  106 */
  {   8, 100, 0                    }, /*                 BITAND shift  100 */
  {  10, 102, 0                    }, /*                  BITOR shift  102 */
  {  44, 137, 0                    }, /*                     IN shift  137 */
  {  76, 121, &yyActionTable[3276] }, /*                  SLASH shift  121 */
  {  18, 125, 0                    }, /*                 CONCAT shift  125 */
  {  78, 119, 0                    }, /*                   STAR shift  119 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  50, 128, &yyActionTable[3278] }, /*                     IS shift  128 */
  {  51, 127, 0                    }, /*                 ISNULL shift  127 */
  {YYNOCODE,0,0}, /* Unused */
  {  53,  92, 0                    }, /*                     LE shift  92 */
  {  54, 108, 0                    }, /*                   LIKE shift  108 */
  {YYNOCODE,0,0}, /* Unused */
  {  56, 104, 0                    }, /*                 LSHIFT shift  104 */
  {  57,  88, 0                    }, /*                     LT shift  88 */
  {  58, 117, 0                    }, /*                  MINUS shift  117 */
  {  59,  96, 0                    }, /*                     NE shift  96 */
  {  60, 110, 0                    }, /*                    NOT shift  110 */
  {  61, 132, 0                    }, /*                NOTNULL shift  132 */
  {YYNOCODE,0,0}, /* Unused */
  {  31,  98, 0                    }, /*                     EQ shift  98 */
/* State 293 */
  {  49, 294, 0                    }, /*                   INTO shift  294 */
/* State 294 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3298] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3300] }, /*                     id shift  21 */
  { 116, 295, 0                    }, /*                    ids shift  295 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3305] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3309] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 295 */
  {  55, 315, 0                    }, /*                     LP shift  315 */
  { 121, 296, &yyActionTable[3314] }, /*         inscollist_opt shift  296 */
/* State 296 */
  {  73,  63, 0                    }, /*                 SELECT shift  63 */
  { 133, 297, &yyActionTable[3316] }, /*                 select shift  297 */
  {  90, 298, 0                    }, /*                 VALUES shift  298 */
  { 127,  59, 0                    }, /*              oneselect shift  59 */
/* State 297 */
  { 124,  61, &yyActionTable[3322] }, /*                 joinop shift  61 */
  {  85, 140, 0                    }, /*                  UNION shift  140 */
  {  48, 142, &yyActionTable[3323] }, /*              INTERSECT shift  142 */
  {  32, 143, 0                    }, /*                 EXCEPT shift  143 */
/* State 298 */
  {  55, 299, 0                    }, /*                     LP shift  299 */
/* State 299 */
  {  66, 305, &yyActionTable[3326] }, /*                   PLUS shift  305 */
  {  58, 308, &yyActionTable[3329] }, /*                  MINUS shift  308 */
  { 122, 314, &yyActionTable[3325] }, /*                   item shift  314 */
  { 123, 300, 0                    }, /*               itemlist shift  300 */
  {  34, 311, 0                    }, /*                  FLOAT shift  311 */
  {  47, 304, 0                    }, /*                INTEGER shift  304 */
  {  62, 313, 0                    }, /*                   NULL shift  313 */
  {  79, 312, &yyActionTable[3330] }, /*                 STRING shift  312 */
/* State 300 */
  {  15, 302, 0                    }, /*                  COMMA shift  302 */
  {  71, 301, &yyActionTable[3333] }, /*                     RP shift  301 */
/* State 301 */
  {YYNOCODE,0,0}, /* Unused */
/* State 302 */
  {  66, 305, &yyActionTable[3337] }, /*                   PLUS shift  305 */
  {  58, 308, &yyActionTable[3339] }, /*                  MINUS shift  308 */
  { 122, 303, &yyActionTable[3336] }, /*                   item shift  303 */
  {  34, 311, 0                    }, /*                  FLOAT shift  311 */
  {  47, 304, 0                    }, /*                INTEGER shift  304 */
  {YYNOCODE,0,0}, /* Unused */
  {  62, 313, 0                    }, /*                   NULL shift  313 */
  {  79, 312, &yyActionTable[3340] }, /*                 STRING shift  312 */
/* State 303 */
  {YYNOCODE,0,0}, /* Unused */
/* State 304 */
  {YYNOCODE,0,0}, /* Unused */
/* State 305 */
  {  34, 307, 0                    }, /*                  FLOAT shift  307 */
  {  47, 306, 0                    }, /*                INTEGER shift  306 */
/* State 306 */
  {YYNOCODE,0,0}, /* Unused */
/* State 307 */
  {YYNOCODE,0,0}, /* Unused */
/* State 308 */
  {  34, 310, 0                    }, /*                  FLOAT shift  310 */
  {  47, 309, 0                    }, /*                INTEGER shift  309 */
/* State 309 */
  {YYNOCODE,0,0}, /* Unused */
/* State 310 */
  {YYNOCODE,0,0}, /* Unused */
/* State 311 */
  {YYNOCODE,0,0}, /* Unused */
/* State 312 */
  {YYNOCODE,0,0}, /* Unused */
/* State 313 */
  {YYNOCODE,0,0}, /* Unused */
/* State 314 */
  {YYNOCODE,0,0}, /* Unused */
/* State 315 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3358] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3360] }, /*                     id shift  21 */
  { 116, 320, 0                    }, /*                    ids shift  320 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  { 120, 316, &yyActionTable[3365] }, /*             inscollist shift  316 */
  {  89,  14, &yyActionTable[3369] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {  29,  16, &yyActionTable[3370] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 316 */
  {  15, 318, 0                    }, /*                  COMMA shift  318 */
  {  71, 317, &yyActionTable[3374] }, /*                     RP shift  317 */
/* State 317 */
  {YYNOCODE,0,0}, /* Unused */
/* State 318 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3377] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3379] }, /*                     id shift  21 */
  { 116, 319, 0                    }, /*                    ids shift  319 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3384] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3388] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 319 */
  {YYNOCODE,0,0}, /* Unused */
/* State 320 */
  {YYNOCODE,0,0}, /* Unused */
/* State 321 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3395] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3397] }, /*                     id shift  21 */
  { 116, 322, 0                    }, /*                    ids shift  322 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3402] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3406] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 322 */
  {  35, 323, 0                    }, /*                   FROM shift  323 */
/* State 323 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3412] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3414] }, /*                     id shift  21 */
  { 116, 324, 0                    }, /*                    ids shift  324 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3419] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3423] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 324 */
  {  88, 325, 0                    }, /*                  USING shift  325 */
/* State 325 */
  {  24, 326, 0                    }, /*             DELIMITERS shift  326 */
/* State 326 */
  {  79, 327, 0                    }, /*                 STRING shift  327 */
/* State 327 */
  {YYNOCODE,0,0}, /* Unused */
/* State 328 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3432] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3434] }, /*                     id shift  21 */
  { 116, 329, 0                    }, /*                    ids shift  329 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3439] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3443] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 329 */
  {YYNOCODE,0,0}, /* Unused */
/* State 330 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3449] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3451] }, /*                     id shift  21 */
  { 116, 331, 0                    }, /*                    ids shift  331 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3456] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3460] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 331 */
  {  31, 332, 0                    }, /*                     EQ shift  332 */
  {  55, 344, &yyActionTable[3465] }, /*                     LP shift  344 */
/* State 332 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  { 129, 335, &yyActionTable[3467] }, /*               plus_num shift  335 */
  { 130, 337, &yyActionTable[3471] }, /*               plus_opt shift  337 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  {  66, 343, 0                    }, /*                   PLUS shift  343 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  29,  16, 0                    }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
  {YYNOCODE,0,0}, /* Unused */
  {  81,  20, 0                    }, /*                   TEMP shift  20 */
  {YYNOCODE,0,0}, /* Unused */
  { 115,  21, 0                    }, /*                     id shift  21 */
  { 116, 333, 0                    }, /*                    ids shift  333 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3474] }, /*                 VACUUM shift  14 */
  {  58, 341, 0                    }, /*                  MINUS shift  341 */
  {YYNOCODE,0,0}, /* Unused */
  {YYNOCODE,0,0}, /* Unused */
  { 125, 336, &yyActionTable[3475] }, /*              minus_num shift  336 */
  {YYNOCODE,0,0}, /* Unused */
  {  63, 334, 0                    }, /*                     ON shift  334 */
/* State 333 */
  {YYNOCODE,0,0}, /* Unused */
/* State 334 */
  {YYNOCODE,0,0}, /* Unused */
/* State 335 */
  {YYNOCODE,0,0}, /* Unused */
/* State 336 */
  {YYNOCODE,0,0}, /* Unused */
/* State 337 */
  {  34, 340, 0                    }, /*                  FLOAT shift  340 */
  {YYNOCODE,0,0}, /* Unused */
  { 126, 338, &yyActionTable[3503] }, /*                 number shift  338 */
  {  47, 339, 0                    }, /*                INTEGER shift  339 */
/* State 338 */
  {YYNOCODE,0,0}, /* Unused */
/* State 339 */
  {YYNOCODE,0,0}, /* Unused */
/* State 340 */
  {YYNOCODE,0,0}, /* Unused */
/* State 341 */
  {  34, 340, 0                    }, /*                  FLOAT shift  340 */
  {YYNOCODE,0,0}, /* Unused */
  { 126, 342, &yyActionTable[3510] }, /*                 number shift  342 */
  {  47, 339, 0                    }, /*                INTEGER shift  339 */
/* State 342 */
  {YYNOCODE,0,0}, /* Unused */
/* State 343 */
  {YYNOCODE,0,0}, /* Unused */
/* State 344 */
  {  33,  13, 0                    }, /*                EXPLAIN shift  13 */
  {  81,  20, &yyActionTable[3516] }, /*                   TEMP shift  20 */
  {  67,  17, 0                    }, /*                 PRAGMA shift  17 */
  { 115,  21, &yyActionTable[3518] }, /*                     id shift  21 */
  { 116, 345, 0                    }, /*                    ids shift  345 */
  {   5,  11, 0                    }, /*                    ASC shift  11 */
  {   6,  15, 0                    }, /*                  BEGIN shift  15 */
  {  25,  10, 0                    }, /*                   DESC shift  10 */
  {  24,  12, 0                    }, /*             DELIMITERS shift  12 */
  {  89,  14, &yyActionTable[3523] }, /*                 VACUUM shift  14 */
  {  42,  19, 0                    }, /*                     ID shift  19 */
  {  13,  18, 0                    }, /*                CLUSTER shift  18 */
  {YYNOCODE,0,0}, /* Unused */
  {  29,  16, &yyActionTable[3527] }, /*                    END shift  16 */
  {YYNOCODE,0,0}, /* Unused */
  {  79,  22, 0                    }, /*                 STRING shift  22 */
/* State 345 */
  {  71, 346, 0                    }, /*                     RP shift  346 */
/* State 346 */
  {YYNOCODE,0,0}, /* Unused */
/* State 347 */
  {YYNOCODE,0,0}, /* Unused */
/* State 348 */
  {YYNOCODE,0,0}, /* Unused */
/* State 349 */
  {YYNOCODE,0,0}, /* Unused */
};

/* The state table contains information needed to look up the correct
** action in the action table, given the current state of the parser.
** Information needed includes:
**
**  +  A pointer to the start of the action hash table in yyActionTable.
**
**  +  A mask used to hash the look-ahead token.  The mask is an integer
**     which is one less than the size of the hash table.  
**
**  +  The default action.  This is the action to take if no entry for
**     the given look-ahead is found in the action hash table.
*/
struct yyStateEntry {
  struct yyActionEntry *hashtbl; /* Start of the hash table in yyActionTable */
  int mask;                      /* Mask used for hashing the look-ahead */
  YYACTIONTYPE actionDefault;    /* Default action if look-ahead not found */
};
static struct yyStateEntry yyStateTable[] = {
  { &yyActionTable[0], 31, 355},
  { &yyActionTable[32], 1, 552},
  { &yyActionTable[34], 31, 355},
  { &yyActionTable[66], 0, 352},
  { &yyActionTable[67], 31, 552},
  { &yyActionTable[99], 0, 353},
  { &yyActionTable[100], 1, 358},
  { &yyActionTable[102], 0, 357},
  { &yyActionTable[103], 15, 359},
  { &yyActionTable[119], 0, 360},
  { &yyActionTable[120], 0, 373},
  { &yyActionTable[121], 0, 374},
  { &yyActionTable[122], 0, 375},
  { &yyActionTable[123], 0, 376},
  { &yyActionTable[124], 0, 377},
  { &yyActionTable[125], 0, 378},
  { &yyActionTable[126], 0, 379},
  { &yyActionTable[127], 0, 380},
  { &yyActionTable[128], 0, 381},
  { &yyActionTable[129], 0, 382},
  { &yyActionTable[130], 0, 383},
  { &yyActionTable[131], 0, 384},
  { &yyActionTable[132], 0, 385},
  { &yyActionTable[133], 1, 358},
  { &yyActionTable[135], 0, 361},
  { &yyActionTable[136], 1, 358},
  { &yyActionTable[138], 0, 362},
  { &yyActionTable[139], 1, 358},
  { &yyActionTable[141], 0, 363},
  { &yyActionTable[142], 1, 552},
  { &yyActionTable[144], 0, 364},
  { &yyActionTable[145], 31, 552},
  { &yyActionTable[177], 3, 552},
  { &yyActionTable[181], 0, 552},
  { &yyActionTable[182], 0, 368},
  { &yyActionTable[183], 31, 552},
  { &yyActionTable[215], 0, 369},
  { &yyActionTable[216], 15, 386},
  { &yyActionTable[232], 0, 396},
  { &yyActionTable[233], 7, 371},
  { &yyActionTable[241], 0, 395},
  { &yyActionTable[242], 15, 552},
  { &yyActionTable[258], 7, 552},
  { &yyActionTable[266], 0, 397},
  { &yyActionTable[267], 0, 552},
  { &yyActionTable[268], 0, 408},
  { &yyActionTable[269], 0, 552},
  { &yyActionTable[270], 3, 452},
  { &yyActionTable[274], 0, 409},
  { &yyActionTable[275], 0, 450},
  { &yyActionTable[276], 0, 451},
  { &yyActionTable[277], 0, 410},
  { &yyActionTable[278], 0, 552},
  { &yyActionTable[279], 31, 552},
  { &yyActionTable[311], 0, 382},
  { &yyActionTable[312], 31, 529},
  { &yyActionTable[344], 63, 552},
  { &yyActionTable[408], 63, 552},
  { &yyActionTable[472], 31, 552},
  { &yyActionTable[504], 0, 423},
  { &yyActionTable[505], 7, 552},
  { &yyActionTable[513], 1, 552},
  { &yyActionTable[515], 0, 424},
  { &yyActionTable[516], 3, 432},
  { &yyActionTable[520], 3, 434},
  { &yyActionTable[524], 3, 552},
  { &yyActionTable[528], 1, 458},
  { &yyActionTable[530], 1, 453},
  { &yyActionTable[532], 1, 455},
  { &yyActionTable[534], 1, 445},
  { &yyActionTable[536], 0, 429},
  { &yyActionTable[537], 0, 552},
  { &yyActionTable[538], 31, 552},
  { &yyActionTable[570], 0, 446},
  { &yyActionTable[571], 31, 552},
  { &yyActionTable[603], 3, 452},
  { &yyActionTable[607], 0, 447},
  { &yyActionTable[608], 31, 449},
  { &yyActionTable[640], 31, 552},
  { &yyActionTable[672], 0, 480},
  { &yyActionTable[673], 0, 552},
  { &yyActionTable[674], 15, 552},
  { &yyActionTable[690], 0, 482},
  { &yyActionTable[691], 0, 483},
  { &yyActionTable[692], 0, 484},
  { &yyActionTable[693], 31, 488},
  { &yyActionTable[725], 31, 552},
  { &yyActionTable[757], 31, 489},
  { &yyActionTable[789], 31, 552},
  { &yyActionTable[821], 15, 490},
  { &yyActionTable[837], 31, 552},
  { &yyActionTable[869], 15, 491},
  { &yyActionTable[885], 31, 552},
  { &yyActionTable[917], 15, 492},
  { &yyActionTable[933], 31, 552},
  { &yyActionTable[965], 15, 493},
  { &yyActionTable[981], 31, 552},
  { &yyActionTable[1013], 15, 494},
  { &yyActionTable[1029], 31, 552},
  { &yyActionTable[1061], 15, 495},
  { &yyActionTable[1077], 31, 552},
  { &yyActionTable[1109], 7, 496},
  { &yyActionTable[1117], 31, 552},
  { &yyActionTable[1149], 7, 497},
  { &yyActionTable[1157], 31, 552},
  { &yyActionTable[1189], 7, 498},
  { &yyActionTable[1197], 31, 552},
  { &yyActionTable[1229], 7, 499},
  { &yyActionTable[1237], 31, 552},
  { &yyActionTable[1269], 15, 500},
  { &yyActionTable[1285], 7, 552},
  { &yyActionTable[1293], 31, 552},
  { &yyActionTable[1325], 31, 501},
  { &yyActionTable[1357], 31, 552},
  { &yyActionTable[1389], 15, 502},
  { &yyActionTable[1405], 31, 552},
  { &yyActionTable[1437], 3, 504},
  { &yyActionTable[1441], 31, 552},
  { &yyActionTable[1473], 3, 505},
  { &yyActionTable[1477], 31, 552},
  { &yyActionTable[1509], 0, 506},
  { &yyActionTable[1510], 31, 552},
  { &yyActionTable[1542], 0, 507},
  { &yyActionTable[1543], 31, 552},
  { &yyActionTable[1575], 0, 508},
  { &yyActionTable[1576], 31, 552},
  { &yyActionTable[1608], 0, 509},
  { &yyActionTable[1609], 0, 510},
  { &yyActionTable[1610], 1, 552},
  { &yyActionTable[1612], 0, 511},
  { &yyActionTable[1613], 0, 552},
  { &yyActionTable[1614], 0, 514},
  { &yyActionTable[1615], 0, 512},
  { &yyActionTable[1616], 31, 552},
  { &yyActionTable[1648], 31, 552},
  { &yyActionTable[1680], 31, 552},
  { &yyActionTable[1712], 63, 552},
  { &yyActionTable[1776], 0, 552},
  { &yyActionTable[1777], 31, 529},
  { &yyActionTable[1809], 7, 552},
  { &yyActionTable[1817], 1, 552},
  { &yyActionTable[1819], 0, 552},
  { &yyActionTable[1820], 0, 552},
  { &yyActionTable[1821], 0, 552},
  { &yyActionTable[1822], 0, 523},
  { &yyActionTable[1823], 31, 528},
  { &yyActionTable[1855], 31, 552},
  { &yyActionTable[1887], 31, 515},
  { &yyActionTable[1919], 31, 552},
  { &yyActionTable[1951], 0, 516},
  { &yyActionTable[1952], 31, 552},
  { &yyActionTable[1984], 0, 517},
  { &yyActionTable[1985], 31, 552},
  { &yyActionTable[2017], 0, 518},
  { &yyActionTable[2018], 1, 552},
  { &yyActionTable[2020], 0, 522},
  { &yyActionTable[2021], 31, 529},
  { &yyActionTable[2053], 0, 526},
  { &yyActionTable[2054], 0, 527},
  { &yyActionTable[2055], 31, 552},
  { &yyActionTable[2087], 31, 503},
  { &yyActionTable[2119], 0, 513},
  { &yyActionTable[2120], 31, 552},
  { &yyActionTable[2152], 31, 552},
  { &yyActionTable[2184], 31, 552},
  { &yyActionTable[2216], 63, 552},
  { &yyActionTable[2280], 0, 552},
  { &yyActionTable[2281], 31, 529},
  { &yyActionTable[2313], 7, 552},
  { &yyActionTable[2321], 0, 525},
  { &yyActionTable[2322], 1, 552},
  { &yyActionTable[2324], 0, 524},
  { &yyActionTable[2325], 3, 452},
  { &yyActionTable[2329], 0, 448},
  { &yyActionTable[2330], 31, 552},
  { &yyActionTable[2362], 31, 456},
  { &yyActionTable[2394], 0, 552},
  { &yyActionTable[2395], 31, 529},
  { &yyActionTable[2427], 0, 454},
  { &yyActionTable[2428], 31, 552},
  { &yyActionTable[2460], 31, 459},
  { &yyActionTable[2492], 0, 433},
  { &yyActionTable[2493], 1, 442},
  { &yyActionTable[2495], 0, 440},
  { &yyActionTable[2496], 0, 441},
  { &yyActionTable[2497], 15, 552},
  { &yyActionTable[2513], 31, 552},
  { &yyActionTable[2545], 0, 439},
  { &yyActionTable[2546], 15, 552},
  { &yyActionTable[2562], 0, 444},
  { &yyActionTable[2563], 0, 435},
  { &yyActionTable[2564], 31, 552},
  { &yyActionTable[2596], 63, 552},
  { &yyActionTable[2660], 15, 552},
  { &yyActionTable[2676], 0, 437},
  { &yyActionTable[2677], 0, 430},
  { &yyActionTable[2678], 0, 431},
  { &yyActionTable[2679], 0, 519},
  { &yyActionTable[2680], 31, 552},
  { &yyActionTable[2712], 0, 479},
  { &yyActionTable[2713], 1, 552},
  { &yyActionTable[2715], 0, 486},
  { &yyActionTable[2716], 0, 552},
  { &yyActionTable[2717], 0, 487},
  { &yyActionTable[2718], 31, 552},
  { &yyActionTable[2750], 0, 411},
  { &yyActionTable[2751], 0, 398},
  { &yyActionTable[2752], 7, 552},
  { &yyActionTable[2760], 0, 399},
  { &yyActionTable[2761], 0, 400},
  { &yyActionTable[2762], 0, 401},
  { &yyActionTable[2763], 1, 552},
  { &yyActionTable[2765], 0, 402},
  { &yyActionTable[2766], 0, 405},
  { &yyActionTable[2767], 1, 552},
  { &yyActionTable[2769], 0, 403},
  { &yyActionTable[2770], 0, 406},
  { &yyActionTable[2771], 0, 404},
  { &yyActionTable[2772], 0, 407},
  { &yyActionTable[2773], 15, 387},
  { &yyActionTable[2789], 3, 552},
  { &yyActionTable[2793], 1, 552},
  { &yyActionTable[2795], 0, 388},
  { &yyActionTable[2796], 3, 552},
  { &yyActionTable[2800], 0, 552},
  { &yyActionTable[2801], 0, 389},
  { &yyActionTable[2802], 0, 392},
  { &yyActionTable[2803], 0, 552},
  { &yyActionTable[2804], 0, 393},
  { &yyActionTable[2805], 0, 552},
  { &yyActionTable[2806], 0, 394},
  { &yyActionTable[2807], 0, 391},
  { &yyActionTable[2808], 0, 390},
  { &yyActionTable[2809], 0, 372},
  { &yyActionTable[2810], 7, 552},
  { &yyActionTable[2818], 7, 552},
  { &yyActionTable[2826], 0, 414},
  { &yyActionTable[2827], 15, 552},
  { &yyActionTable[2843], 0, 417},
  { &yyActionTable[2844], 0, 552},
  { &yyActionTable[2845], 0, 552},
  { &yyActionTable[2846], 15, 552},
  { &yyActionTable[2862], 1, 552},
  { &yyActionTable[2864], 0, 418},
  { &yyActionTable[2865], 15, 552},
  { &yyActionTable[2881], 0, 533},
  { &yyActionTable[2882], 0, 535},
  { &yyActionTable[2883], 0, 534},
  { &yyActionTable[2884], 0, 552},
  { &yyActionTable[2885], 15, 552},
  { &yyActionTable[2901], 1, 552},
  { &yyActionTable[2903], 0, 419},
  { &yyActionTable[2904], 31, 552},
  { &yyActionTable[2936], 31, 420},
  { &yyActionTable[2968], 0, 415},
  { &yyActionTable[2969], 0, 416},
  { &yyActionTable[2970], 0, 370},
  { &yyActionTable[2971], 7, 552},
  { &yyActionTable[2979], 0, 552},
  { &yyActionTable[2980], 15, 552},
  { &yyActionTable[2996], 0, 552},
  { &yyActionTable[2997], 0, 552},
  { &yyActionTable[2998], 0, 552},
  { &yyActionTable[2999], 15, 552},
  { &yyActionTable[3015], 0, 552},
  { &yyActionTable[3016], 15, 552},
  { &yyActionTable[3032], 0, 552},
  { &yyActionTable[3033], 15, 552},
  { &yyActionTable[3049], 1, 552},
  { &yyActionTable[3051], 0, 530},
  { &yyActionTable[3052], 0, 552},
  { &yyActionTable[3053], 1, 552},
  { &yyActionTable[3055], 15, 552},
  { &yyActionTable[3071], 0, 421},
  { &yyActionTable[3072], 15, 552},
  { &yyActionTable[3088], 0, 536},
  { &yyActionTable[3089], 3, 422},
  { &yyActionTable[3093], 0, 552},
  { &yyActionTable[3094], 15, 552},
  { &yyActionTable[3110], 1, 458},
  { &yyActionTable[3112], 0, 457},
  { &yyActionTable[3113], 15, 552},
  { &yyActionTable[3129], 0, 552},
  { &yyActionTable[3130], 15, 552},
  { &yyActionTable[3146], 3, 458},
  { &yyActionTable[3150], 0, 460},
  { &yyActionTable[3151], 15, 552},
  { &yyActionTable[3167], 0, 552},
  { &yyActionTable[3168], 31, 552},
  { &yyActionTable[3200], 31, 461},
  { &yyActionTable[3232], 0, 552},
  { &yyActionTable[3233], 31, 552},
  { &yyActionTable[3265], 31, 462},
  { &yyActionTable[3297], 0, 552},
  { &yyActionTable[3298], 15, 552},
  { &yyActionTable[3314], 1, 475},
  { &yyActionTable[3316], 3, 552},
  { &yyActionTable[3320], 3, 464},
  { &yyActionTable[3324], 0, 552},
  { &yyActionTable[3325], 7, 552},
  { &yyActionTable[3333], 1, 552},
  { &yyActionTable[3335], 0, 463},
  { &yyActionTable[3336], 7, 552},
  { &yyActionTable[3344], 0, 465},
  { &yyActionTable[3345], 0, 467},
  { &yyActionTable[3346], 1, 552},
  { &yyActionTable[3348], 0, 468},
  { &yyActionTable[3349], 0, 471},
  { &yyActionTable[3350], 1, 552},
  { &yyActionTable[3352], 0, 469},
  { &yyActionTable[3353], 0, 472},
  { &yyActionTable[3354], 0, 470},
  { &yyActionTable[3355], 0, 473},
  { &yyActionTable[3356], 0, 474},
  { &yyActionTable[3357], 0, 466},
  { &yyActionTable[3358], 15, 552},
  { &yyActionTable[3374], 1, 552},
  { &yyActionTable[3376], 0, 476},
  { &yyActionTable[3377], 15, 552},
  { &yyActionTable[3393], 0, 477},
  { &yyActionTable[3394], 0, 478},
  { &yyActionTable[3395], 15, 552},
  { &yyActionTable[3411], 0, 552},
  { &yyActionTable[3412], 15, 552},
  { &yyActionTable[3428], 0, 538},
  { &yyActionTable[3429], 0, 552},
  { &yyActionTable[3430], 0, 552},
  { &yyActionTable[3431], 0, 537},
  { &yyActionTable[3432], 15, 539},
  { &yyActionTable[3448], 0, 540},
  { &yyActionTable[3449], 15, 552},
  { &yyActionTable[3465], 1, 552},
  { &yyActionTable[3467], 31, 551},
  { &yyActionTable[3499], 0, 541},
  { &yyActionTable[3500], 0, 542},
  { &yyActionTable[3501], 0, 543},
  { &yyActionTable[3502], 0, 544},
  { &yyActionTable[3503], 3, 552},
  { &yyActionTable[3507], 0, 546},
  { &yyActionTable[3508], 0, 548},
  { &yyActionTable[3509], 0, 549},
  { &yyActionTable[3510], 3, 552},
  { &yyActionTable[3514], 0, 547},
  { &yyActionTable[3515], 0, 550},
  { &yyActionTable[3516], 15, 552},
  { &yyActionTable[3532], 0, 552},
  { &yyActionTable[3533], 0, 545},
  { &yyActionTable[3534], 0, 354},
  { &yyActionTable[3535], 0, 356},
  { &yyActionTable[3536], 0, 351},
};

/* The following structure represents a single element of the
** parser's stack.  Information stored includes:
**
**   +  The state number for the parser at this level of the stack.
**
**   +  The value of the token stored at this level of the stack.
**      (In other words, the "major" token.)
**
**   +  The semantic value stored at this level of the stack.  This is
**      the information used by the action routines in the grammar.
**      It is sometimes called the "minor" token.
*/
struct yyStackEntry {
  int stateno;       /* The state-number */
  int major;         /* The major token value.  This is the code
                     ** number for the token at this stack level */
  YYMINORTYPE minor; /* The user-supplied minor token value.  This
                     ** is the value of the token  */
};

/* The state of the parser is completely contained in an instance of
** the following structure */
struct yyParser {
  int idx;                            /* Index of top element in stack */
  int errcnt;                         /* Shifts left before out of the error */
  struct yyStackEntry *top;           /* Pointer to the top stack element */
  struct yyStackEntry stack[YYSTACKDEPTH];  /* The parser's stack */
};
typedef struct yyParser yyParser;

#ifndef NDEBUG
#include <stdio.h>
static FILE *yyTraceFILE = 0;
static char *yyTracePrompt = 0;

/* 
** Turn parser tracing on by giving a stream to which to write the trace
** and a prompt to preface each trace message.  Tracing is turned off
** by making either argument NULL 
**
** Inputs:
** <ul>
** <li> A FILE* to which trace output should be written.
**      If NULL, then tracing is turned off.
** <li> A prefix string written at the beginning of every
**      line of trace output.  If NULL, then tracing is
**      turned off.
** </ul>
**
** Outputs:
** None.
*/
void sqliteParserTrace(FILE *TraceFILE, char *zTracePrompt){
  yyTraceFILE = TraceFILE;
  yyTracePrompt = zTracePrompt;
  if( yyTraceFILE==0 ) yyTracePrompt = 0;
  else if( yyTracePrompt==0 ) yyTraceFILE = 0;
}

/* For tracing shifts, the names of all terminals and nonterminals
** are required.  The following table supplies these names */
static char *yyTokenName[] = { 
  "$",             "AGG_FUNCTION",  "ALL",           "AND",         
  "AS",            "ASC",           "BEGIN",         "BETWEEN",     
  "BITAND",        "BITNOT",        "BITOR",         "BY",          
  "CHECK",         "CLUSTER",       "COLUMN",        "COMMA",       
  "COMMENT",       "COMMIT",        "CONCAT",        "CONSTRAINT",  
  "COPY",          "CREATE",        "DEFAULT",       "DELETE",      
  "DELIMITERS",    "DESC",          "DISTINCT",      "DOT",         
  "DROP",          "END",           "END_OF_FILE",   "EQ",          
  "EXCEPT",        "EXPLAIN",       "FLOAT",         "FROM",        
  "FUNCTION",      "GE",            "GLOB",          "GROUP",       
  "GT",            "HAVING",        "ID",            "ILLEGAL",     
  "IN",            "INDEX",         "INSERT",        "INTEGER",     
  "INTERSECT",     "INTO",          "IS",            "ISNULL",      
  "KEY",           "LE",            "LIKE",          "LP",          
  "LSHIFT",        "LT",            "MINUS",         "NE",          
  "NOT",           "NOTNULL",       "NULL",          "ON",          
  "OR",            "ORDER",         "PLUS",          "PRAGMA",      
  "PRIMARY",       "REM",           "ROLLBACK",      "RP",          
  "RSHIFT",        "SELECT",        "SEMI",          "SET",         
  "SLASH",         "SPACE",         "STAR",          "STRING",      
  "TABLE",         "TEMP",          "TRANSACTION",   "UMINUS",      
  "UNCLOSED_STRING",  "UNION",         "UNIQUE",        "UPDATE",      
  "USING",         "VACUUM",        "VALUES",        "WHERE",       
  "as",            "carg",          "carglist",      "ccons",       
  "cmd",           "cmdlist",       "column",        "columnid",    
  "columnlist",    "conslist",      "conslist_opt",  "create_table",
  "create_table_args",  "distinct",      "ecmd",          "error",       
  "explain",       "expr",          "expritem",      "exprlist",    
  "from",          "groupby_opt",   "having_opt",    "id",          
  "ids",           "idxitem",       "idxlist",       "input",       
  "inscollist",    "inscollist_opt",  "item",          "itemlist",    
  "joinop",        "minus_num",     "number",        "oneselect",   
  "orderby_opt",   "plus_num",      "plus_opt",      "sclp",        
  "selcollist",    "select",        "seltablist",    "setlist",     
  "signed",        "sortitem",      "sortlist",      "sortorder",   
  "stl_prefix",    "tcons",         "temp",          "trans_opt",   
  "type",          "typename",      "uniqueflag",    "where_opt",   
};
#define YYTRACE(X) if( yyTraceFILE ) fprintf(yyTraceFILE,"%sReduce [%s].\n",yyTracePrompt,X);
#else
#define YYTRACE(X)
#endif


/*
** This function returns the symbolic name associated with a token
** value.
*/
const char *sqliteParserTokenName(int tokenType){
#ifndef NDEBUG
  if( tokenType>0 && tokenType<(sizeof(yyTokenName)/sizeof(yyTokenName[0])) ){
    return yyTokenName[tokenType];
  }else{
    return "Unknown";
  }
#else
  return "";
#endif
}

/* 
** This function allocates a new parser.
** The only argument is a pointer to a function which works like
** malloc.
**
** Inputs:
** A pointer to the function used to allocate memory.
**
** Outputs:
** A pointer to a parser.  This pointer is used in subsequent calls
** to sqliteParser and sqliteParserFree.
*/
void *sqliteParserAlloc(void *(*mallocProc)(int)){
  yyParser *pParser;
  pParser = (yyParser*)(*mallocProc)( (int)sizeof(yyParser) );
  if( pParser ){
    pParser->idx = -1;
  }
  return pParser;
}

/* The following function deletes the value associated with a
** symbol.  The symbol can be either a terminal or nonterminal.
** "yymajor" is the symbol code, and "yypminor" is a pointer to
** the value.
*/
static void yy_destructor(YYCODETYPE yymajor, YYMINORTYPE *yypminor){
  switch( yymajor ){
    /* Here is inserted the actions which take place when a
    ** terminal or non-terminal is destroyed.  This can happen
    ** when the symbol is popped from the stack during a
    ** reduce or during error processing or when a parser is 
    ** being destroyed before it is finished parsing.
    **
    ** Note: during a reduce, the only symbols destroyed are those
    ** which appear on the RHS of the rule, but which are not used
    ** inside the C code.
    */
    case 109:
#line 339 "parse.y"
{sqliteExprDelete((yypminor->yy18));}
#line 4531 "parse.c"
      break;
    case 110:
#line 474 "parse.y"
{sqliteExprDelete((yypminor->yy18));}
#line 4536 "parse.c"
      break;
    case 111:
#line 472 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4541 "parse.c"
      break;
    case 112:
#line 216 "parse.y"
{sqliteIdListDelete((yypminor->yy114));}
#line 4546 "parse.c"
      break;
    case 113:
#line 253 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4551 "parse.c"
      break;
    case 114:
#line 258 "parse.y"
{sqliteExprDelete((yypminor->yy18));}
#line 4556 "parse.c"
      break;
    case 118:
#line 492 "parse.y"
{sqliteIdListDelete((yypminor->yy114));}
#line 4561 "parse.c"
      break;
    case 120:
#line 318 "parse.y"
{sqliteIdListDelete((yypminor->yy114));}
#line 4566 "parse.c"
      break;
    case 121:
#line 316 "parse.y"
{sqliteIdListDelete((yypminor->yy114));}
#line 4571 "parse.c"
      break;
    case 122:
#line 296 "parse.y"
{sqliteExprDelete((yypminor->yy18));}
#line 4576 "parse.c"
      break;
    case 123:
#line 294 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4581 "parse.c"
      break;
    case 127:
#line 166 "parse.y"
{sqliteSelectDelete((yypminor->yy155));}
#line 4586 "parse.c"
      break;
    case 128:
#line 228 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4591 "parse.c"
      break;
    case 131:
#line 201 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4596 "parse.c"
      break;
    case 132:
#line 199 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4601 "parse.c"
      break;
    case 133:
#line 164 "parse.y"
{sqliteSelectDelete((yypminor->yy155));}
#line 4606 "parse.c"
      break;
    case 134:
#line 212 "parse.y"
{sqliteIdListDelete((yypminor->yy114));}
#line 4611 "parse.c"
      break;
    case 135:
#line 274 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4616 "parse.c"
      break;
    case 137:
#line 232 "parse.y"
{sqliteExprDelete((yypminor->yy18));}
#line 4621 "parse.c"
      break;
    case 138:
#line 230 "parse.y"
{sqliteExprListDelete((yypminor->yy32));}
#line 4626 "parse.c"
      break;
    case 140:
#line 214 "parse.y"
{sqliteIdListDelete((yypminor->yy114));}
#line 4631 "parse.c"
      break;
    case 147:
#line 268 "parse.y"
{sqliteExprDelete((yypminor->yy18));}
#line 4636 "parse.c"
      break;
    default:  break;   /* If no destructor action specified: do nothing */
  }
}

/*
** Pop the parser's stack once.
**
** If there is a destructor routine associated with the token which
** is popped from the stack, then call it.
**
** Return the major token number for the symbol popped.
*/
static int yy_pop_parser_stack(yyParser *pParser){
  YYCODETYPE yymajor;

  if( pParser->idx<0 ) return 0;
#ifndef NDEBUG
  if( yyTraceFILE && pParser->idx>=0 ){
    fprintf(yyTraceFILE,"%sPopping %s\n",
      yyTracePrompt,
      yyTokenName[pParser->top->major]);
  }
#endif
  yymajor = pParser->top->major;
  yy_destructor( yymajor, &pParser->top->minor);
  pParser->idx--;
  pParser->top--;
  return yymajor;
}

/* 
** Deallocate and destroy a parser.  Destructors are all called for
** all stack elements before shutting the parser down.
**
** Inputs:
** <ul>
** <li>  A pointer to the parser.  This should be a pointer
**       obtained from sqliteParserAlloc.
** <li>  A pointer to a function used to reclaim memory obtained
**       from malloc.
** </ul>
*/
void sqliteParserFree(
  void *p,                    /* The parser to be deleted */
  void (*freeProc)(void*)     /* Function used to reclaim memory */
){
  yyParser *pParser = (yyParser*)p;
  if( pParser==0 ) return;
  while( pParser->idx>=0 ) yy_pop_parser_stack(pParser);
  (*freeProc)((void*)pParser);
}

/*
** Find the appropriate action for a parser given the look-ahead token.
**
** If the look-ahead token is YYNOCODE, then check to see if the action is
** independent of the look-ahead.  If it is, return the action, otherwise
** return YY_NO_ACTION.
*/
static int yy_find_parser_action(
  yyParser *pParser,        /* The parser */
  int iLookAhead             /* The look-ahead token */
){
  struct yyStateEntry *pState;   /* Appropriate entry in the state table */
  struct yyActionEntry *pAction; /* Action appropriate for the look-ahead */
 
  /* if( pParser->idx<0 ) return YY_NO_ACTION;  */
  pState = &yyStateTable[pParser->top->stateno];
  if( iLookAhead!=YYNOCODE ){
    pAction = &pState->hashtbl[iLookAhead & pState->mask];
    while( pAction ){
      if( pAction->lookahead==iLookAhead ) return pAction->action;
      pAction = pAction->next;
    }
  }else if( pState->mask!=0 || pState->hashtbl->lookahead!=YYNOCODE ){
    return YY_NO_ACTION;
  }
  return pState->actionDefault;
}

/*
** Perform a shift action.
*/
static void yy_shift(
  yyParser *yypParser,          /* The parser to be shifted */
  int yyNewState,               /* The new state to shift in */
  int yyMajor,                  /* The major token to shift in */
  YYMINORTYPE *yypMinor         /* Pointer ot the minor token to shift in */
){
  yypParser->idx++;
  yypParser->top++;
  if( yypParser->idx>=YYSTACKDEPTH ){
     yypParser->idx--;
     yypParser->top--;
#ifndef NDEBUG
     if( yyTraceFILE ){
       fprintf(yyTraceFILE,"%sStack Overflow!\n",yyTracePrompt);
     }
#endif
     while( yypParser->idx>=0 ) yy_pop_parser_stack(yypParser);
     /* Here code is inserted which will execute if the parser
     ** stack every overflows */
     return;
  }
  yypParser->top->stateno = yyNewState;
  yypParser->top->major = yyMajor;
  yypParser->top->minor = *yypMinor;
#ifndef NDEBUG
  if( yyTraceFILE && yypParser->idx>0 ){
    int i;
    fprintf(yyTraceFILE,"%sShift %d\n",yyTracePrompt,yyNewState);
    fprintf(yyTraceFILE,"%sStack:",yyTracePrompt);
    for(i=1; i<=yypParser->idx; i++)
      fprintf(yyTraceFILE," %s",yyTokenName[yypParser->stack[i].major]);
    fprintf(yyTraceFILE,"\n");
  }
#endif
}

/* The following table contains information about every rule that
** is used during the reduce.
*/
static struct {
  YYCODETYPE lhs;         /* Symbol on the left-hand side of the rule */
  unsigned char nrhs;     /* Number of right-hand side symbols in the rule */
} yyRuleInfo[] = {
  { 119, 1 },
  { 97, 1 },
  { 97, 3 },
  { 106, 2 },
  { 106, 1 },
  { 106, 0 },
  { 108, 1 },
  { 96, 2 },
  { 143, 0 },
  { 143, 1 },
  { 143, 2 },
  { 96, 2 },
  { 96, 2 },
  { 96, 2 },
  { 96, 2 },
  { 103, 4 },
  { 142, 1 },
  { 142, 0 },
  { 104, 4 },
  { 100, 3 },
  { 100, 1 },
  { 98, 3 },
  { 99, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 115, 1 },
  { 116, 1 },
  { 116, 1 },
  { 144, 0 },
  { 144, 1 },
  { 144, 4 },
  { 144, 6 },
  { 145, 1 },
  { 145, 2 },
  { 136, 1 },
  { 136, 2 },
  { 136, 2 },
  { 94, 2 },
  { 94, 0 },
  { 93, 3 },
  { 93, 1 },
  { 93, 2 },
  { 93, 2 },
  { 93, 2 },
  { 93, 3 },
  { 93, 3 },
  { 93, 2 },
  { 93, 3 },
  { 93, 3 },
  { 93, 2 },
  { 95, 2 },
  { 95, 3 },
  { 95, 1 },
  { 95, 4 },
  { 102, 0 },
  { 102, 2 },
  { 101, 3 },
  { 101, 2 },
  { 101, 1 },
  { 141, 2 },
  { 141, 5 },
  { 141, 4 },
  { 141, 2 },
  { 96, 3 },
  { 96, 1 },
  { 133, 1 },
  { 133, 3 },
  { 124, 1 },
  { 124, 2 },
  { 124, 1 },
  { 124, 1 },
  { 127, 8 },
  { 105, 1 },
  { 105, 1 },
  { 105, 0 },
  { 131, 2 },
  { 131, 0 },
  { 132, 1 },
  { 132, 2 },
  { 132, 4 },
  { 92, 0 },
  { 92, 1 },
  { 112, 2 },
  { 140, 2 },
  { 140, 0 },
  { 134, 2 },
  { 134, 4 },
  { 128, 0 },
  { 128, 3 },
  { 138, 4 },
  { 138, 2 },
  { 137, 1 },
  { 139, 1 },
  { 139, 1 },
  { 139, 0 },
  { 113, 0 },
  { 113, 3 },
  { 114, 0 },
  { 114, 2 },
  { 96, 4 },
  { 147, 0 },
  { 147, 2 },
  { 96, 5 },
  { 135, 5 },
  { 135, 3 },
  { 96, 8 },
  { 96, 5 },
  { 123, 3 },
  { 123, 1 },
  { 122, 1 },
  { 122, 2 },
  { 122, 2 },
  { 122, 1 },
  { 122, 2 },
  { 122, 2 },
  { 122, 1 },
  { 122, 1 },
  { 121, 0 },
  { 121, 3 },
  { 120, 3 },
  { 120, 1 },
  { 109, 3 },
  { 109, 1 },
  { 109, 1 },
  { 109, 3 },
  { 109, 1 },
  { 109, 1 },
  { 109, 1 },
  { 109, 4 },
  { 109, 4 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 4 },
  { 109, 3 },
  { 109, 4 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 3 },
  { 109, 2 },
  { 109, 3 },
  { 109, 2 },
  { 109, 3 },
  { 109, 4 },
  { 109, 2 },
  { 109, 2 },
  { 109, 2 },
  { 109, 2 },
  { 109, 3 },
  { 109, 5 },
  { 109, 6 },
  { 109, 5 },
  { 109, 5 },
  { 109, 6 },
  { 109, 6 },
  { 111, 3 },
  { 111, 1 },
  { 110, 1 },
  { 110, 0 },
  { 96, 9 },
  { 146, 1 },
  { 146, 0 },
  { 118, 3 },
  { 118, 1 },
  { 117, 1 },
  { 96, 3 },
  { 96, 7 },
  { 96, 4 },
  { 96, 1 },
  { 96, 2 },
  { 96, 4 },
  { 96, 4 },
  { 96, 4 },
  { 96, 4 },
  { 96, 5 },
  { 129, 2 },
  { 125, 2 },
  { 126, 1 },
  { 126, 1 },
  { 130, 1 },
  { 130, 0 },
};

static void yy_accept(yyParser *  sqliteParserANSIARGDECL);  /* Forward Declaration */

/*
** Perform a reduce action and the shift that must immediately
** follow the reduce.
*/
static void yy_reduce(
  yyParser *yypParser,         /* The parser */
  int yyruleno                 /* Number of the rule by which to reduce */
  sqliteParserANSIARGDECL
){
  int yygoto;                     /* The next state */
  int yyact;                      /* The next action */
  YYMINORTYPE yygotominor;        /* The LHS of the rule reduced */
  struct yyStackEntry *yymsp;     /* The top of the parser's stack */
  int yysize;                     /* Amount to pop the stack */
  yymsp = yypParser->top;
  switch( yyruleno ){
  /* Beginning here are the reduction cases.  A typical example
  ** follows:
  **   case 0:
  **     YYTRACE("<text of the rule>");
  **  #line <lineno> <grammarfile>
  **     { ... }           // User supplied code
  **  #line <lineno> <thisfile>
  **     break;
  */
      case 0:
        YYTRACE("input ::= cmdlist")
        /* No destructor defined for cmdlist */
        break;
      case 1:
        YYTRACE("cmdlist ::= ecmd")
        /* No destructor defined for ecmd */
        break;
      case 2:
        YYTRACE("cmdlist ::= cmdlist SEMI ecmd")
        /* No destructor defined for cmdlist */
        /* No destructor defined for SEMI */
        /* No destructor defined for ecmd */
        break;
      case 3:
        YYTRACE("ecmd ::= explain cmd")
#line 47 "parse.y"
{sqliteExec(pParse);}
#line 5013 "parse.c"
        /* No destructor defined for explain */
        /* No destructor defined for cmd */
        break;
      case 4:
        YYTRACE("ecmd ::= cmd")
#line 48 "parse.y"
{sqliteExec(pParse);}
#line 5021 "parse.c"
        /* No destructor defined for cmd */
        break;
      case 5:
        YYTRACE("ecmd ::=")
        break;
      case 6:
        YYTRACE("explain ::= EXPLAIN")
#line 50 "parse.y"
{pParse->explain = 1;}
#line 5031 "parse.c"
        /* No destructor defined for EXPLAIN */
        break;
      case 7:
        YYTRACE("cmd ::= BEGIN trans_opt")
#line 54 "parse.y"
{sqliteBeginTransaction(pParse);}
#line 5038 "parse.c"
        /* No destructor defined for BEGIN */
        /* No destructor defined for trans_opt */
        break;
      case 8:
        YYTRACE("trans_opt ::=")
        break;
      case 9:
        YYTRACE("trans_opt ::= TRANSACTION")
        /* No destructor defined for TRANSACTION */
        break;
      case 10:
        YYTRACE("trans_opt ::= TRANSACTION ids")
        /* No destructor defined for TRANSACTION */
        /* No destructor defined for ids */
        break;
      case 11:
        YYTRACE("cmd ::= COMMIT trans_opt")
#line 58 "parse.y"
{sqliteCommitTransaction(pParse);}
#line 5058 "parse.c"
        /* No destructor defined for COMMIT */
        /* No destructor defined for trans_opt */
        break;
      case 12:
        YYTRACE("cmd ::= END trans_opt")
#line 59 "parse.y"
{sqliteCommitTransaction(pParse);}
#line 5066 "parse.c"
        /* No destructor defined for END */
        /* No destructor defined for trans_opt */
        break;
      case 13:
        YYTRACE("cmd ::= ROLLBACK trans_opt")
#line 60 "parse.y"
{sqliteRollbackTransaction(pParse);}
#line 5074 "parse.c"
        /* No destructor defined for ROLLBACK */
        /* No destructor defined for trans_opt */
        break;
      case 14:
        YYTRACE("cmd ::= create_table create_table_args")
        /* No destructor defined for create_table */
        /* No destructor defined for create_table_args */
        break;
      case 15:
        YYTRACE("create_table ::= CREATE temp TABLE ids")
#line 66 "parse.y"
{sqliteStartTable(pParse,&yymsp[-3].minor.yy0,&yymsp[0].minor.yy90,yymsp[-2].minor.yy156);}
#line 5087 "parse.c"
        /* No destructor defined for TABLE */
        break;
      case 16:
        YYTRACE("temp ::= TEMP")
#line 68 "parse.y"
{yygotominor.yy156 = 1;}
#line 5094 "parse.c"
        /* No destructor defined for TEMP */
        break;
      case 17:
        YYTRACE("temp ::=")
#line 69 "parse.y"
{yygotominor.yy156 = 0;}
#line 5101 "parse.c"
        break;
      case 18:
        YYTRACE("create_table_args ::= LP columnlist conslist_opt RP")
#line 71 "parse.y"
{sqliteEndTable(pParse,&yymsp[0].minor.yy0);}
#line 5107 "parse.c"
        /* No destructor defined for LP */
        /* No destructor defined for columnlist */
        /* No destructor defined for conslist_opt */
        break;
      case 19:
        YYTRACE("columnlist ::= columnlist COMMA column")
        /* No destructor defined for columnlist */
        /* No destructor defined for COMMA */
        /* No destructor defined for column */
        break;
      case 20:
        YYTRACE("columnlist ::= column")
        /* No destructor defined for column */
        break;
      case 21:
        YYTRACE("column ::= columnid type carglist")
        /* No destructor defined for columnid */
        /* No destructor defined for type */
        /* No destructor defined for carglist */
        break;
      case 22:
        YYTRACE("columnid ::= ids")
#line 80 "parse.y"
{sqliteAddColumn(pParse,&yymsp[0].minor.yy90);}
#line 5132 "parse.c"
        break;
      case 23:
        YYTRACE("id ::= DESC")
#line 88 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5138 "parse.c"
        break;
      case 24:
        YYTRACE("id ::= ASC")
#line 89 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5144 "parse.c"
        break;
      case 25:
        YYTRACE("id ::= DELIMITERS")
#line 90 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5150 "parse.c"
        break;
      case 26:
        YYTRACE("id ::= EXPLAIN")
#line 91 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5156 "parse.c"
        break;
      case 27:
        YYTRACE("id ::= VACUUM")
#line 92 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5162 "parse.c"
        break;
      case 28:
        YYTRACE("id ::= BEGIN")
#line 93 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5168 "parse.c"
        break;
      case 29:
        YYTRACE("id ::= END")
#line 94 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5174 "parse.c"
        break;
      case 30:
        YYTRACE("id ::= PRAGMA")
#line 95 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5180 "parse.c"
        break;
      case 31:
        YYTRACE("id ::= CLUSTER")
#line 96 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5186 "parse.c"
        break;
      case 32:
        YYTRACE("id ::= ID")
#line 97 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5192 "parse.c"
        break;
      case 33:
        YYTRACE("id ::= TEMP")
#line 98 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5198 "parse.c"
        break;
      case 34:
        YYTRACE("ids ::= id")
#line 103 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy90;}
#line 5204 "parse.c"
        break;
      case 35:
        YYTRACE("ids ::= STRING")
#line 104 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 5210 "parse.c"
        break;
      case 36:
        YYTRACE("type ::=")
        break;
      case 37:
        YYTRACE("type ::= typename")
#line 107 "parse.y"
{sqliteAddColumnType(pParse,&yymsp[0].minor.yy90,&yymsp[0].minor.yy90);}
#line 5219 "parse.c"
        break;
      case 38:
        YYTRACE("type ::= typename LP signed RP")
#line 108 "parse.y"
{sqliteAddColumnType(pParse,&yymsp[-3].minor.yy90,&yymsp[0].minor.yy0);}
#line 5225 "parse.c"
        /* No destructor defined for LP */
        /* No destructor defined for signed */
        break;
      case 39:
        YYTRACE("type ::= typename LP signed COMMA signed RP")
#line 110 "parse.y"
{sqliteAddColumnType(pParse,&yymsp[-5].minor.yy90,&yymsp[0].minor.yy0);}
#line 5233 "parse.c"
        /* No destructor defined for LP */
        /* No destructor defined for signed */
        /* No destructor defined for COMMA */
        /* No destructor defined for signed */
        break;
      case 40:
        YYTRACE("typename ::= ids")
#line 112 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy90;}
#line 5243 "parse.c"
        break;
      case 41:
        YYTRACE("typename ::= typename ids")
#line 113 "parse.y"
{yygotominor.yy90 = yymsp[-1].minor.yy90;}
#line 5249 "parse.c"
        /* No destructor defined for ids */
        break;
      case 42:
        YYTRACE("signed ::= INTEGER")
        /* No destructor defined for INTEGER */
        break;
      case 43:
        YYTRACE("signed ::= PLUS INTEGER")
        /* No destructor defined for PLUS */
        /* No destructor defined for INTEGER */
        break;
      case 44:
        YYTRACE("signed ::= MINUS INTEGER")
        /* No destructor defined for MINUS */
        /* No destructor defined for INTEGER */
        break;
      case 45:
        YYTRACE("carglist ::= carglist carg")
        /* No destructor defined for carglist */
        /* No destructor defined for carg */
        break;
      case 46:
        YYTRACE("carglist ::=")
        break;
      case 47:
        YYTRACE("carg ::= CONSTRAINT ids ccons")
        /* No destructor defined for CONSTRAINT */
        /* No destructor defined for ids */
        /* No destructor defined for ccons */
        break;
      case 48:
        YYTRACE("carg ::= ccons")
        /* No destructor defined for ccons */
        break;
      case 49:
        YYTRACE("carg ::= DEFAULT STRING")
#line 121 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,0);}
#line 5288 "parse.c"
        /* No destructor defined for DEFAULT */
        break;
      case 50:
        YYTRACE("carg ::= DEFAULT ID")
#line 122 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,0);}
#line 5295 "parse.c"
        /* No destructor defined for DEFAULT */
        break;
      case 51:
        YYTRACE("carg ::= DEFAULT INTEGER")
#line 123 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,0);}
#line 5302 "parse.c"
        /* No destructor defined for DEFAULT */
        break;
      case 52:
        YYTRACE("carg ::= DEFAULT PLUS INTEGER")
#line 124 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,0);}
#line 5309 "parse.c"
        /* No destructor defined for DEFAULT */
        /* No destructor defined for PLUS */
        break;
      case 53:
        YYTRACE("carg ::= DEFAULT MINUS INTEGER")
#line 125 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,1);}
#line 5317 "parse.c"
        /* No destructor defined for DEFAULT */
        /* No destructor defined for MINUS */
        break;
      case 54:
        YYTRACE("carg ::= DEFAULT FLOAT")
#line 126 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,0);}
#line 5325 "parse.c"
        /* No destructor defined for DEFAULT */
        break;
      case 55:
        YYTRACE("carg ::= DEFAULT PLUS FLOAT")
#line 127 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,0);}
#line 5332 "parse.c"
        /* No destructor defined for DEFAULT */
        /* No destructor defined for PLUS */
        break;
      case 56:
        YYTRACE("carg ::= DEFAULT MINUS FLOAT")
#line 128 "parse.y"
{sqliteAddDefaultValue(pParse,&yymsp[0].minor.yy0,1);}
#line 5340 "parse.c"
        /* No destructor defined for DEFAULT */
        /* No destructor defined for MINUS */
        break;
      case 57:
        YYTRACE("carg ::= DEFAULT NULL")
        /* No destructor defined for DEFAULT */
        /* No destructor defined for NULL */
        break;
      case 58:
        YYTRACE("ccons ::= NOT NULL")
#line 134 "parse.y"
{sqliteAddNotNull(pParse);}
#line 5353 "parse.c"
        /* No destructor defined for NOT */
        /* No destructor defined for NULL */
        break;
      case 59:
        YYTRACE("ccons ::= PRIMARY KEY sortorder")
#line 135 "parse.y"
{sqliteCreateIndex(pParse,0,0,0,1,0,0);}
#line 5361 "parse.c"
        /* No destructor defined for PRIMARY */
        /* No destructor defined for KEY */
        /* No destructor defined for sortorder */
        break;
      case 60:
        YYTRACE("ccons ::= UNIQUE")
#line 136 "parse.y"
{sqliteCreateIndex(pParse,0,0,0,1,0,0);}
#line 5370 "parse.c"
        /* No destructor defined for UNIQUE */
        break;
      case 61:
        YYTRACE("ccons ::= CHECK LP expr RP")
        /* No destructor defined for CHECK */
        /* No destructor defined for LP */
  yy_destructor(109,&yymsp[-1].minor);
        /* No destructor defined for RP */
        break;
      case 62:
        YYTRACE("conslist_opt ::=")
        break;
      case 63:
        YYTRACE("conslist_opt ::= COMMA conslist")
        /* No destructor defined for COMMA */
        /* No destructor defined for conslist */
        break;
      case 64:
        YYTRACE("conslist ::= conslist COMMA tcons")
        /* No destructor defined for conslist */
        /* No destructor defined for COMMA */
        /* No destructor defined for tcons */
        break;
      case 65:
        YYTRACE("conslist ::= conslist tcons")
        /* No destructor defined for conslist */
        /* No destructor defined for tcons */
        break;
      case 66:
        YYTRACE("conslist ::= tcons")
        /* No destructor defined for tcons */
        break;
      case 67:
        YYTRACE("tcons ::= CONSTRAINT ids")
        /* No destructor defined for CONSTRAINT */
        /* No destructor defined for ids */
        break;
      case 68:
        YYTRACE("tcons ::= PRIMARY KEY LP idxlist RP")
#line 148 "parse.y"
{sqliteCreateIndex(pParse,0,0,yymsp[-1].minor.yy114,1,0,0);}
#line 5412 "parse.c"
        /* No destructor defined for PRIMARY */
        /* No destructor defined for KEY */
        /* No destructor defined for LP */
        /* No destructor defined for RP */
        break;
      case 69:
        YYTRACE("tcons ::= UNIQUE LP idxlist RP")
#line 149 "parse.y"
{sqliteCreateIndex(pParse,0,0,yymsp[-1].minor.yy114,1,0,0);}
#line 5422 "parse.c"
        /* No destructor defined for UNIQUE */
        /* No destructor defined for LP */
        /* No destructor defined for RP */
        break;
      case 70:
        YYTRACE("tcons ::= CHECK expr")
        /* No destructor defined for CHECK */
  yy_destructor(109,&yymsp[0].minor);
        break;
      case 71:
        YYTRACE("cmd ::= DROP TABLE ids")
#line 154 "parse.y"
{sqliteDropTable(pParse,&yymsp[0].minor.yy90);}
#line 5436 "parse.c"
        /* No destructor defined for DROP */
        /* No destructor defined for TABLE */
        break;
      case 72:
        YYTRACE("cmd ::= select")
#line 158 "parse.y"
{
  sqliteSelect(pParse, yymsp[0].minor.yy155, SRT_Callback, 0);
  sqliteSelectDelete(yymsp[0].minor.yy155);
}
#line 5447 "parse.c"
        break;
      case 73:
        YYTRACE("select ::= oneselect")
#line 168 "parse.y"
{yygotominor.yy155 = yymsp[0].minor.yy155;}
#line 5453 "parse.c"
        break;
      case 74:
        YYTRACE("select ::= select joinop oneselect")
#line 169 "parse.y"
{
  if( yymsp[0].minor.yy155 ){
    yymsp[0].minor.yy155->op = yymsp[-1].minor.yy156;
    yymsp[0].minor.yy155->pPrior = yymsp[-2].minor.yy155;
  }
  yygotominor.yy155 = yymsp[0].minor.yy155;
}
#line 5465 "parse.c"
        break;
      case 75:
        YYTRACE("joinop ::= UNION")
#line 177 "parse.y"
{yygotominor.yy156 = TK_UNION;}
#line 5471 "parse.c"
        /* No destructor defined for UNION */
        break;
      case 76:
        YYTRACE("joinop ::= UNION ALL")
#line 178 "parse.y"
{yygotominor.yy156 = TK_ALL;}
#line 5478 "parse.c"
        /* No destructor defined for UNION */
        /* No destructor defined for ALL */
        break;
      case 77:
        YYTRACE("joinop ::= INTERSECT")
#line 179 "parse.y"
{yygotominor.yy156 = TK_INTERSECT;}
#line 5486 "parse.c"
        /* No destructor defined for INTERSECT */
        break;
      case 78:
        YYTRACE("joinop ::= EXCEPT")
#line 180 "parse.y"
{yygotominor.yy156 = TK_EXCEPT;}
#line 5493 "parse.c"
        /* No destructor defined for EXCEPT */
        break;
      case 79:
        YYTRACE("oneselect ::= SELECT distinct selcollist from where_opt groupby_opt having_opt orderby_opt")
#line 182 "parse.y"
{
  yygotominor.yy155 = sqliteSelectNew(yymsp[-5].minor.yy32,yymsp[-4].minor.yy114,yymsp[-3].minor.yy18,yymsp[-2].minor.yy32,yymsp[-1].minor.yy18,yymsp[0].minor.yy32,yymsp[-6].minor.yy156);
}
#line 5502 "parse.c"
        /* No destructor defined for SELECT */
        break;
      case 80:
        YYTRACE("distinct ::= DISTINCT")
#line 190 "parse.y"
{yygotominor.yy156 = 1;}
#line 5509 "parse.c"
        /* No destructor defined for DISTINCT */
        break;
      case 81:
        YYTRACE("distinct ::= ALL")
#line 191 "parse.y"
{yygotominor.yy156 = 0;}
#line 5516 "parse.c"
        /* No destructor defined for ALL */
        break;
      case 82:
        YYTRACE("distinct ::=")
#line 192 "parse.y"
{yygotominor.yy156 = 0;}
#line 5523 "parse.c"
        break;
      case 83:
        YYTRACE("sclp ::= selcollist COMMA")
#line 202 "parse.y"
{yygotominor.yy32 = yymsp[-1].minor.yy32;}
#line 5529 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 84:
        YYTRACE("sclp ::=")
#line 203 "parse.y"
{yygotominor.yy32 = 0;}
#line 5536 "parse.c"
        break;
      case 85:
        YYTRACE("selcollist ::= STAR")
#line 204 "parse.y"
{yygotominor.yy32 = 0;}
#line 5542 "parse.c"
        /* No destructor defined for STAR */
        break;
      case 86:
        YYTRACE("selcollist ::= sclp expr")
#line 205 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(yymsp[-1].minor.yy32,yymsp[0].minor.yy18,0);}
#line 5549 "parse.c"
        break;
      case 87:
        YYTRACE("selcollist ::= sclp expr as ids")
#line 206 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(yymsp[-3].minor.yy32,yymsp[-2].minor.yy18,&yymsp[0].minor.yy90);}
#line 5555 "parse.c"
        /* No destructor defined for as */
        break;
      case 88:
        YYTRACE("as ::=")
        break;
      case 89:
        YYTRACE("as ::= AS")
        /* No destructor defined for AS */
        break;
      case 90:
        YYTRACE("from ::= FROM seltablist")
#line 218 "parse.y"
{yygotominor.yy114 = yymsp[0].minor.yy114;}
#line 5569 "parse.c"
        /* No destructor defined for FROM */
        break;
      case 91:
        YYTRACE("stl_prefix ::= seltablist COMMA")
#line 219 "parse.y"
{yygotominor.yy114 = yymsp[-1].minor.yy114;}
#line 5576 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 92:
        YYTRACE("stl_prefix ::=")
#line 220 "parse.y"
{yygotominor.yy114 = 0;}
#line 5583 "parse.c"
        break;
      case 93:
        YYTRACE("seltablist ::= stl_prefix ids")
#line 221 "parse.y"
{yygotominor.yy114 = sqliteIdListAppend(yymsp[-1].minor.yy114,&yymsp[0].minor.yy90);}
#line 5589 "parse.c"
        break;
      case 94:
        YYTRACE("seltablist ::= stl_prefix ids as ids")
#line 222 "parse.y"
{
  yygotominor.yy114 = sqliteIdListAppend(yymsp[-3].minor.yy114,&yymsp[-2].minor.yy90);
  sqliteIdListAddAlias(yygotominor.yy114,&yymsp[0].minor.yy90);
}
#line 5598 "parse.c"
        /* No destructor defined for as */
        break;
      case 95:
        YYTRACE("orderby_opt ::=")
#line 234 "parse.y"
{yygotominor.yy32 = 0;}
#line 5605 "parse.c"
        break;
      case 96:
        YYTRACE("orderby_opt ::= ORDER BY sortlist")
#line 235 "parse.y"
{yygotominor.yy32 = yymsp[0].minor.yy32;}
#line 5611 "parse.c"
        /* No destructor defined for ORDER */
        /* No destructor defined for BY */
        break;
      case 97:
        YYTRACE("sortlist ::= sortlist COMMA sortitem sortorder")
#line 236 "parse.y"
{
  yygotominor.yy32 = sqliteExprListAppend(yymsp[-3].minor.yy32,yymsp[-1].minor.yy18,0);
  if( yygotominor.yy32 ) yygotominor.yy32->a[yygotominor.yy32->nExpr-1].sortOrder = yymsp[0].minor.yy156;  /* 0=ascending, 1=decending */
}
#line 5622 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 98:
        YYTRACE("sortlist ::= sortitem sortorder")
#line 240 "parse.y"
{
  yygotominor.yy32 = sqliteExprListAppend(0,yymsp[-1].minor.yy18,0);
  if( yygotominor.yy32 ) yygotominor.yy32->a[0].sortOrder = yymsp[0].minor.yy156;
}
#line 5632 "parse.c"
        break;
      case 99:
        YYTRACE("sortitem ::= expr")
#line 244 "parse.y"
{yygotominor.yy18 = yymsp[0].minor.yy18;}
#line 5638 "parse.c"
        break;
      case 100:
        YYTRACE("sortorder ::= ASC")
#line 248 "parse.y"
{yygotominor.yy156 = 0;}
#line 5644 "parse.c"
        /* No destructor defined for ASC */
        break;
      case 101:
        YYTRACE("sortorder ::= DESC")
#line 249 "parse.y"
{yygotominor.yy156 = 1;}
#line 5651 "parse.c"
        /* No destructor defined for DESC */
        break;
      case 102:
        YYTRACE("sortorder ::=")
#line 250 "parse.y"
{yygotominor.yy156 = 0;}
#line 5658 "parse.c"
        break;
      case 103:
        YYTRACE("groupby_opt ::=")
#line 254 "parse.y"
{yygotominor.yy32 = 0;}
#line 5664 "parse.c"
        break;
      case 104:
        YYTRACE("groupby_opt ::= GROUP BY exprlist")
#line 255 "parse.y"
{yygotominor.yy32 = yymsp[0].minor.yy32;}
#line 5670 "parse.c"
        /* No destructor defined for GROUP */
        /* No destructor defined for BY */
        break;
      case 105:
        YYTRACE("having_opt ::=")
#line 259 "parse.y"
{yygotominor.yy18 = 0;}
#line 5678 "parse.c"
        break;
      case 106:
        YYTRACE("having_opt ::= HAVING expr")
#line 260 "parse.y"
{yygotominor.yy18 = yymsp[0].minor.yy18;}
#line 5684 "parse.c"
        /* No destructor defined for HAVING */
        break;
      case 107:
        YYTRACE("cmd ::= DELETE FROM ids where_opt")
#line 265 "parse.y"
{sqliteDeleteFrom(pParse, &yymsp[-1].minor.yy90, yymsp[0].minor.yy18);}
#line 5691 "parse.c"
        /* No destructor defined for DELETE */
        /* No destructor defined for FROM */
        break;
      case 108:
        YYTRACE("where_opt ::=")
#line 270 "parse.y"
{yygotominor.yy18 = 0;}
#line 5699 "parse.c"
        break;
      case 109:
        YYTRACE("where_opt ::= WHERE expr")
#line 271 "parse.y"
{yygotominor.yy18 = yymsp[0].minor.yy18;}
#line 5705 "parse.c"
        /* No destructor defined for WHERE */
        break;
      case 110:
        YYTRACE("cmd ::= UPDATE ids SET setlist where_opt")
#line 279 "parse.y"
{sqliteUpdate(pParse,&yymsp[-3].minor.yy90,yymsp[-1].minor.yy32,yymsp[0].minor.yy18);}
#line 5712 "parse.c"
        /* No destructor defined for UPDATE */
        /* No destructor defined for SET */
        break;
      case 111:
        YYTRACE("setlist ::= setlist COMMA ids EQ expr")
#line 282 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(yymsp[-4].minor.yy32,yymsp[0].minor.yy18,&yymsp[-2].minor.yy90);}
#line 5720 "parse.c"
        /* No destructor defined for COMMA */
        /* No destructor defined for EQ */
        break;
      case 112:
        YYTRACE("setlist ::= ids EQ expr")
#line 283 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(0,yymsp[0].minor.yy18,&yymsp[-2].minor.yy90);}
#line 5728 "parse.c"
        /* No destructor defined for EQ */
        break;
      case 113:
        YYTRACE("cmd ::= INSERT INTO ids inscollist_opt VALUES LP itemlist RP")
#line 288 "parse.y"
{sqliteInsert(pParse, &yymsp[-5].minor.yy90, yymsp[-1].minor.yy32, 0, yymsp[-4].minor.yy114);}
#line 5735 "parse.c"
        /* No destructor defined for INSERT */
        /* No destructor defined for INTO */
        /* No destructor defined for VALUES */
        /* No destructor defined for LP */
        /* No destructor defined for RP */
        break;
      case 114:
        YYTRACE("cmd ::= INSERT INTO ids inscollist_opt select")
#line 290 "parse.y"
{sqliteInsert(pParse, &yymsp[-2].minor.yy90, 0, yymsp[0].minor.yy155, yymsp[-1].minor.yy114);}
#line 5746 "parse.c"
        /* No destructor defined for INSERT */
        /* No destructor defined for INTO */
        break;
      case 115:
        YYTRACE("itemlist ::= itemlist COMMA item")
#line 298 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(yymsp[-2].minor.yy32,yymsp[0].minor.yy18,0);}
#line 5754 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 116:
        YYTRACE("itemlist ::= item")
#line 299 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(0,yymsp[0].minor.yy18,0);}
#line 5761 "parse.c"
        break;
      case 117:
        YYTRACE("item ::= INTEGER")
#line 300 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_INTEGER, 0, 0, &yymsp[0].minor.yy0);}
#line 5767 "parse.c"
        break;
      case 118:
        YYTRACE("item ::= PLUS INTEGER")
#line 301 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_INTEGER, 0, 0, &yymsp[0].minor.yy0);}
#line 5773 "parse.c"
        /* No destructor defined for PLUS */
        break;
      case 119:
        YYTRACE("item ::= MINUS INTEGER")
#line 302 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_UMINUS, 0, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pLeft = sqliteExpr(TK_INTEGER, 0, 0, &yymsp[0].minor.yy0);
}
#line 5783 "parse.c"
        /* No destructor defined for MINUS */
        break;
      case 120:
        YYTRACE("item ::= FLOAT")
#line 306 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_FLOAT, 0, 0, &yymsp[0].minor.yy0);}
#line 5790 "parse.c"
        break;
      case 121:
        YYTRACE("item ::= PLUS FLOAT")
#line 307 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_FLOAT, 0, 0, &yymsp[0].minor.yy0);}
#line 5796 "parse.c"
        /* No destructor defined for PLUS */
        break;
      case 122:
        YYTRACE("item ::= MINUS FLOAT")
#line 308 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_UMINUS, 0, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pLeft = sqliteExpr(TK_FLOAT, 0, 0, &yymsp[0].minor.yy0);
}
#line 5806 "parse.c"
        /* No destructor defined for MINUS */
        break;
      case 123:
        YYTRACE("item ::= STRING")
#line 312 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_STRING, 0, 0, &yymsp[0].minor.yy0);}
#line 5813 "parse.c"
        break;
      case 124:
        YYTRACE("item ::= NULL")
#line 313 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_NULL, 0, 0, 0);}
#line 5819 "parse.c"
        /* No destructor defined for NULL */
        break;
      case 125:
        YYTRACE("inscollist_opt ::=")
#line 320 "parse.y"
{yygotominor.yy114 = 0;}
#line 5826 "parse.c"
        break;
      case 126:
        YYTRACE("inscollist_opt ::= LP inscollist RP")
#line 321 "parse.y"
{yygotominor.yy114 = yymsp[-1].minor.yy114;}
#line 5832 "parse.c"
        /* No destructor defined for LP */
        /* No destructor defined for RP */
        break;
      case 127:
        YYTRACE("inscollist ::= inscollist COMMA ids")
#line 322 "parse.y"
{yygotominor.yy114 = sqliteIdListAppend(yymsp[-2].minor.yy114,&yymsp[0].minor.yy90);}
#line 5840 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 128:
        YYTRACE("inscollist ::= ids")
#line 323 "parse.y"
{yygotominor.yy114 = sqliteIdListAppend(0,&yymsp[0].minor.yy90);}
#line 5847 "parse.c"
        break;
      case 129:
        YYTRACE("expr ::= LP expr RP")
#line 341 "parse.y"
{yygotominor.yy18 = yymsp[-1].minor.yy18; sqliteExprSpan(yygotominor.yy18,&yymsp[-2].minor.yy0,&yymsp[0].minor.yy0);}
#line 5853 "parse.c"
        break;
      case 130:
        YYTRACE("expr ::= NULL")
#line 342 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_NULL, 0, 0, &yymsp[0].minor.yy0);}
#line 5859 "parse.c"
        break;
      case 131:
        YYTRACE("expr ::= id")
#line 343 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_ID, 0, 0, &yymsp[0].minor.yy90);}
#line 5865 "parse.c"
        break;
      case 132:
        YYTRACE("expr ::= ids DOT ids")
#line 344 "parse.y"
{
  Expr *temp1 = sqliteExpr(TK_ID, 0, 0, &yymsp[-2].minor.yy90);
  Expr *temp2 = sqliteExpr(TK_ID, 0, 0, &yymsp[0].minor.yy90);
  yygotominor.yy18 = sqliteExpr(TK_DOT, temp1, temp2, 0);
}
#line 5875 "parse.c"
        /* No destructor defined for DOT */
        break;
      case 133:
        YYTRACE("expr ::= INTEGER")
#line 349 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_INTEGER, 0, 0, &yymsp[0].minor.yy0);}
#line 5882 "parse.c"
        break;
      case 134:
        YYTRACE("expr ::= FLOAT")
#line 350 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_FLOAT, 0, 0, &yymsp[0].minor.yy0);}
#line 5888 "parse.c"
        break;
      case 135:
        YYTRACE("expr ::= STRING")
#line 351 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_STRING, 0, 0, &yymsp[0].minor.yy0);}
#line 5894 "parse.c"
        break;
      case 136:
        YYTRACE("expr ::= ID LP exprlist RP")
#line 352 "parse.y"
{
  yygotominor.yy18 = sqliteExprFunction(yymsp[-1].minor.yy32, &yymsp[-3].minor.yy0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-3].minor.yy0,&yymsp[0].minor.yy0);
}
#line 5903 "parse.c"
        /* No destructor defined for LP */
        break;
      case 137:
        YYTRACE("expr ::= ID LP STAR RP")
#line 356 "parse.y"
{
  yygotominor.yy18 = sqliteExprFunction(0, &yymsp[-3].minor.yy0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-3].minor.yy0,&yymsp[0].minor.yy0);
}
#line 5913 "parse.c"
        /* No destructor defined for LP */
        /* No destructor defined for STAR */
        break;
      case 138:
        YYTRACE("expr ::= expr AND expr")
#line 360 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_AND, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5921 "parse.c"
        /* No destructor defined for AND */
        break;
      case 139:
        YYTRACE("expr ::= expr OR expr")
#line 361 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_OR, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5928 "parse.c"
        /* No destructor defined for OR */
        break;
      case 140:
        YYTRACE("expr ::= expr LT expr")
#line 362 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_LT, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5935 "parse.c"
        /* No destructor defined for LT */
        break;
      case 141:
        YYTRACE("expr ::= expr GT expr")
#line 363 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_GT, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5942 "parse.c"
        /* No destructor defined for GT */
        break;
      case 142:
        YYTRACE("expr ::= expr LE expr")
#line 364 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_LE, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5949 "parse.c"
        /* No destructor defined for LE */
        break;
      case 143:
        YYTRACE("expr ::= expr GE expr")
#line 365 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_GE, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5956 "parse.c"
        /* No destructor defined for GE */
        break;
      case 144:
        YYTRACE("expr ::= expr NE expr")
#line 366 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_NE, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5963 "parse.c"
        /* No destructor defined for NE */
        break;
      case 145:
        YYTRACE("expr ::= expr EQ expr")
#line 367 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_EQ, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5970 "parse.c"
        /* No destructor defined for EQ */
        break;
      case 146:
        YYTRACE("expr ::= expr BITAND expr")
#line 368 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_BITAND, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5977 "parse.c"
        /* No destructor defined for BITAND */
        break;
      case 147:
        YYTRACE("expr ::= expr BITOR expr")
#line 369 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_BITOR, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5984 "parse.c"
        /* No destructor defined for BITOR */
        break;
      case 148:
        YYTRACE("expr ::= expr LSHIFT expr")
#line 370 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_LSHIFT, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5991 "parse.c"
        /* No destructor defined for LSHIFT */
        break;
      case 149:
        YYTRACE("expr ::= expr RSHIFT expr")
#line 371 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_RSHIFT, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 5998 "parse.c"
        /* No destructor defined for RSHIFT */
        break;
      case 150:
        YYTRACE("expr ::= expr LIKE expr")
#line 372 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_LIKE, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6005 "parse.c"
        /* No destructor defined for LIKE */
        break;
      case 151:
        YYTRACE("expr ::= expr NOT LIKE expr")
#line 373 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_LIKE, yymsp[-3].minor.yy18, yymsp[0].minor.yy18, 0);
  yygotominor.yy18 = sqliteExpr(TK_NOT, yygotominor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-3].minor.yy18->span,&yymsp[0].minor.yy18->span);
}
#line 6016 "parse.c"
        /* No destructor defined for NOT */
        /* No destructor defined for LIKE */
        break;
      case 152:
        YYTRACE("expr ::= expr GLOB expr")
#line 378 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_GLOB,yymsp[-2].minor.yy18,yymsp[0].minor.yy18,0);}
#line 6024 "parse.c"
        /* No destructor defined for GLOB */
        break;
      case 153:
        YYTRACE("expr ::= expr NOT GLOB expr")
#line 379 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_GLOB, yymsp[-3].minor.yy18, yymsp[0].minor.yy18, 0);
  yygotominor.yy18 = sqliteExpr(TK_NOT, yygotominor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-3].minor.yy18->span,&yymsp[0].minor.yy18->span);
}
#line 6035 "parse.c"
        /* No destructor defined for NOT */
        /* No destructor defined for GLOB */
        break;
      case 154:
        YYTRACE("expr ::= expr PLUS expr")
#line 384 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_PLUS, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6043 "parse.c"
        /* No destructor defined for PLUS */
        break;
      case 155:
        YYTRACE("expr ::= expr MINUS expr")
#line 385 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_MINUS, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6050 "parse.c"
        /* No destructor defined for MINUS */
        break;
      case 156:
        YYTRACE("expr ::= expr STAR expr")
#line 386 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_STAR, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6057 "parse.c"
        /* No destructor defined for STAR */
        break;
      case 157:
        YYTRACE("expr ::= expr SLASH expr")
#line 387 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_SLASH, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6064 "parse.c"
        /* No destructor defined for SLASH */
        break;
      case 158:
        YYTRACE("expr ::= expr REM expr")
#line 388 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_REM, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6071 "parse.c"
        /* No destructor defined for REM */
        break;
      case 159:
        YYTRACE("expr ::= expr CONCAT expr")
#line 389 "parse.y"
{yygotominor.yy18 = sqliteExpr(TK_CONCAT, yymsp[-2].minor.yy18, yymsp[0].minor.yy18, 0);}
#line 6078 "parse.c"
        /* No destructor defined for CONCAT */
        break;
      case 160:
        YYTRACE("expr ::= expr ISNULL")
#line 390 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_ISNULL, yymsp[-1].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-1].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6088 "parse.c"
        break;
      case 161:
        YYTRACE("expr ::= expr IS NULL")
#line 394 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_ISNULL, yymsp[-2].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-2].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6097 "parse.c"
        /* No destructor defined for IS */
        break;
      case 162:
        YYTRACE("expr ::= expr NOTNULL")
#line 398 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_NOTNULL, yymsp[-1].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-1].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6107 "parse.c"
        break;
      case 163:
        YYTRACE("expr ::= expr NOT NULL")
#line 402 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_NOTNULL, yymsp[-2].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-2].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6116 "parse.c"
        /* No destructor defined for NOT */
        break;
      case 164:
        YYTRACE("expr ::= expr IS NOT NULL")
#line 406 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_NOTNULL, yymsp[-3].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-3].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6126 "parse.c"
        /* No destructor defined for IS */
        /* No destructor defined for NOT */
        break;
      case 165:
        YYTRACE("expr ::= NOT expr")
#line 410 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_NOT, yymsp[0].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-1].minor.yy0,&yymsp[0].minor.yy18->span);
}
#line 6137 "parse.c"
        break;
      case 166:
        YYTRACE("expr ::= BITNOT expr")
#line 414 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_BITNOT, yymsp[0].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-1].minor.yy0,&yymsp[0].minor.yy18->span);
}
#line 6146 "parse.c"
        break;
      case 167:
        YYTRACE("expr ::= MINUS expr")
#line 418 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_UMINUS, yymsp[0].minor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-1].minor.yy0,&yymsp[0].minor.yy18->span);
}
#line 6155 "parse.c"
        break;
      case 168:
        YYTRACE("expr ::= PLUS expr")
#line 422 "parse.y"
{
  yygotominor.yy18 = yymsp[0].minor.yy18;
  sqliteExprSpan(yygotominor.yy18,&yymsp[-1].minor.yy0,&yymsp[0].minor.yy18->span);
}
#line 6164 "parse.c"
        break;
      case 169:
        YYTRACE("expr ::= LP select RP")
#line 426 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_SELECT, 0, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pSelect = yymsp[-1].minor.yy155;
  sqliteExprSpan(yygotominor.yy18,&yymsp[-2].minor.yy0,&yymsp[0].minor.yy0);
}
#line 6174 "parse.c"
        break;
      case 170:
        YYTRACE("expr ::= expr BETWEEN expr AND expr")
#line 431 "parse.y"
{
  ExprList *pList = sqliteExprListAppend(0, yymsp[-2].minor.yy18, 0);
  pList = sqliteExprListAppend(pList, yymsp[0].minor.yy18, 0);
  yygotominor.yy18 = sqliteExpr(TK_BETWEEN, yymsp[-4].minor.yy18, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pList = pList;
  sqliteExprSpan(yygotominor.yy18,&yymsp[-4].minor.yy18->span,&yymsp[0].minor.yy18->span);
}
#line 6186 "parse.c"
        /* No destructor defined for BETWEEN */
        /* No destructor defined for AND */
        break;
      case 171:
        YYTRACE("expr ::= expr NOT BETWEEN expr AND expr")
#line 438 "parse.y"
{
  ExprList *pList = sqliteExprListAppend(0, yymsp[-2].minor.yy18, 0);
  pList = sqliteExprListAppend(pList, yymsp[0].minor.yy18, 0);
  yygotominor.yy18 = sqliteExpr(TK_BETWEEN, yymsp[-5].minor.yy18, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pList = pList;
  yygotominor.yy18 = sqliteExpr(TK_NOT, yygotominor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-5].minor.yy18->span,&yymsp[0].minor.yy18->span);
}
#line 6201 "parse.c"
        /* No destructor defined for NOT */
        /* No destructor defined for BETWEEN */
        /* No destructor defined for AND */
        break;
      case 172:
        YYTRACE("expr ::= expr IN LP exprlist RP")
#line 446 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_IN, yymsp[-4].minor.yy18, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pList = yymsp[-1].minor.yy32;
  sqliteExprSpan(yygotominor.yy18,&yymsp[-4].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6214 "parse.c"
        /* No destructor defined for IN */
        /* No destructor defined for LP */
        break;
      case 173:
        YYTRACE("expr ::= expr IN LP select RP")
#line 451 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_IN, yymsp[-4].minor.yy18, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pSelect = yymsp[-1].minor.yy155;
  sqliteExprSpan(yygotominor.yy18,&yymsp[-4].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6226 "parse.c"
        /* No destructor defined for IN */
        /* No destructor defined for LP */
        break;
      case 174:
        YYTRACE("expr ::= expr NOT IN LP exprlist RP")
#line 456 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_IN, yymsp[-5].minor.yy18, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pList = yymsp[-1].minor.yy32;
  yygotominor.yy18 = sqliteExpr(TK_NOT, yygotominor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-5].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6239 "parse.c"
        /* No destructor defined for NOT */
        /* No destructor defined for IN */
        /* No destructor defined for LP */
        break;
      case 175:
        YYTRACE("expr ::= expr NOT IN LP select RP")
#line 462 "parse.y"
{
  yygotominor.yy18 = sqliteExpr(TK_IN, yymsp[-5].minor.yy18, 0, 0);
  if( yygotominor.yy18 ) yygotominor.yy18->pSelect = yymsp[-1].minor.yy155;
  yygotominor.yy18 = sqliteExpr(TK_NOT, yygotominor.yy18, 0, 0);
  sqliteExprSpan(yygotominor.yy18,&yymsp[-5].minor.yy18->span,&yymsp[0].minor.yy0);
}
#line 6253 "parse.c"
        /* No destructor defined for NOT */
        /* No destructor defined for IN */
        /* No destructor defined for LP */
        break;
      case 176:
        YYTRACE("exprlist ::= exprlist COMMA expritem")
#line 477 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(yymsp[-2].minor.yy32,yymsp[0].minor.yy18,0);}
#line 6262 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 177:
        YYTRACE("exprlist ::= expritem")
#line 478 "parse.y"
{yygotominor.yy32 = sqliteExprListAppend(0,yymsp[0].minor.yy18,0);}
#line 6269 "parse.c"
        break;
      case 178:
        YYTRACE("expritem ::= expr")
#line 479 "parse.y"
{yygotominor.yy18 = yymsp[0].minor.yy18;}
#line 6275 "parse.c"
        break;
      case 179:
        YYTRACE("expritem ::=")
#line 480 "parse.y"
{yygotominor.yy18 = 0;}
#line 6281 "parse.c"
        break;
      case 180:
        YYTRACE("cmd ::= CREATE uniqueflag INDEX ids ON ids LP idxlist RP")
#line 485 "parse.y"
{sqliteCreateIndex(pParse, &yymsp[-5].minor.yy90, &yymsp[-3].minor.yy90, yymsp[-1].minor.yy114, yymsp[-7].minor.yy156, &yymsp[-8].minor.yy0, &yymsp[0].minor.yy0);}
#line 6287 "parse.c"
        /* No destructor defined for INDEX */
        /* No destructor defined for ON */
        /* No destructor defined for LP */
        break;
      case 181:
        YYTRACE("uniqueflag ::= UNIQUE")
#line 488 "parse.y"
{ yygotominor.yy156 = 1; }
#line 6296 "parse.c"
        /* No destructor defined for UNIQUE */
        break;
      case 182:
        YYTRACE("uniqueflag ::=")
#line 489 "parse.y"
{ yygotominor.yy156 = 0; }
#line 6303 "parse.c"
        break;
      case 183:
        YYTRACE("idxlist ::= idxlist COMMA idxitem")
#line 496 "parse.y"
{yygotominor.yy114 = sqliteIdListAppend(yymsp[-2].minor.yy114,&yymsp[0].minor.yy90);}
#line 6309 "parse.c"
        /* No destructor defined for COMMA */
        break;
      case 184:
        YYTRACE("idxlist ::= idxitem")
#line 498 "parse.y"
{yygotominor.yy114 = sqliteIdListAppend(0,&yymsp[0].minor.yy90);}
#line 6316 "parse.c"
        break;
      case 185:
        YYTRACE("idxitem ::= ids")
#line 499 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy90;}
#line 6322 "parse.c"
        break;
      case 186:
        YYTRACE("cmd ::= DROP INDEX ids")
#line 504 "parse.y"
{sqliteDropIndex(pParse, &yymsp[0].minor.yy90);}
#line 6328 "parse.c"
        /* No destructor defined for DROP */
        /* No destructor defined for INDEX */
        break;
      case 187:
        YYTRACE("cmd ::= COPY ids FROM ids USING DELIMITERS STRING")
#line 510 "parse.y"
{sqliteCopy(pParse,&yymsp[-5].minor.yy90,&yymsp[-3].minor.yy90,&yymsp[0].minor.yy0);}
#line 6336 "parse.c"
        /* No destructor defined for COPY */
        /* No destructor defined for FROM */
        /* No destructor defined for USING */
        /* No destructor defined for DELIMITERS */
        break;
      case 188:
        YYTRACE("cmd ::= COPY ids FROM ids")
#line 512 "parse.y"
{sqliteCopy(pParse,&yymsp[-2].minor.yy90,&yymsp[0].minor.yy90,0);}
#line 6346 "parse.c"
        /* No destructor defined for COPY */
        /* No destructor defined for FROM */
        break;
      case 189:
        YYTRACE("cmd ::= VACUUM")
#line 516 "parse.y"
{sqliteVacuum(pParse,0);}
#line 6354 "parse.c"
        /* No destructor defined for VACUUM */
        break;
      case 190:
        YYTRACE("cmd ::= VACUUM ids")
#line 517 "parse.y"
{sqliteVacuum(pParse,&yymsp[0].minor.yy90);}
#line 6361 "parse.c"
        /* No destructor defined for VACUUM */
        break;
      case 191:
        YYTRACE("cmd ::= PRAGMA ids EQ ids")
#line 521 "parse.y"
{sqlitePragma(pParse,&yymsp[-2].minor.yy90,&yymsp[0].minor.yy90,0);}
#line 6368 "parse.c"
        /* No destructor defined for PRAGMA */
        /* No destructor defined for EQ */
        break;
      case 192:
        YYTRACE("cmd ::= PRAGMA ids EQ ON")
#line 522 "parse.y"
{sqlitePragma(pParse,&yymsp[-2].minor.yy90,&yymsp[0].minor.yy0,0);}
#line 6376 "parse.c"
        /* No destructor defined for PRAGMA */
        /* No destructor defined for EQ */
        break;
      case 193:
        YYTRACE("cmd ::= PRAGMA ids EQ plus_num")
#line 523 "parse.y"
{sqlitePragma(pParse,&yymsp[-2].minor.yy90,&yymsp[0].minor.yy90,0);}
#line 6384 "parse.c"
        /* No destructor defined for PRAGMA */
        /* No destructor defined for EQ */
        break;
      case 194:
        YYTRACE("cmd ::= PRAGMA ids EQ minus_num")
#line 524 "parse.y"
{sqlitePragma(pParse,&yymsp[-2].minor.yy90,&yymsp[0].minor.yy90,1);}
#line 6392 "parse.c"
        /* No destructor defined for PRAGMA */
        /* No destructor defined for EQ */
        break;
      case 195:
        YYTRACE("cmd ::= PRAGMA ids LP ids RP")
#line 525 "parse.y"
{sqlitePragma(pParse,&yymsp[-3].minor.yy90,&yymsp[-1].minor.yy90,0);}
#line 6400 "parse.c"
        /* No destructor defined for PRAGMA */
        /* No destructor defined for LP */
        /* No destructor defined for RP */
        break;
      case 196:
        YYTRACE("plus_num ::= plus_opt number")
#line 526 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy90;}
#line 6409 "parse.c"
        /* No destructor defined for plus_opt */
        break;
      case 197:
        YYTRACE("minus_num ::= MINUS number")
#line 527 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy90;}
#line 6416 "parse.c"
        /* No destructor defined for MINUS */
        break;
      case 198:
        YYTRACE("number ::= INTEGER")
#line 528 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 6423 "parse.c"
        break;
      case 199:
        YYTRACE("number ::= FLOAT")
#line 529 "parse.y"
{yygotominor.yy90 = yymsp[0].minor.yy0;}
#line 6429 "parse.c"
        break;
      case 200:
        YYTRACE("plus_opt ::= PLUS")
        /* No destructor defined for PLUS */
        break;
      case 201:
        YYTRACE("plus_opt ::=")
        break;
  };
  yygoto = yyRuleInfo[yyruleno].lhs;
  yysize = yyRuleInfo[yyruleno].nrhs;
  yypParser->idx -= yysize;
  yypParser->top -= yysize;
  yyact = yy_find_parser_action(yypParser,yygoto);
  if( yyact < YYNSTATE ){
    yy_shift(yypParser,yyact,yygoto,&yygotominor);
  }else if( yyact == YYNSTATE + YYNRULE + 1 ){
    yy_accept(yypParser sqliteParserARGDECL);
  }
}

/*
** The following code executes when the parse fails
*/
static void yy_parse_failed(
  yyParser *yypParser           /* The parser */
  sqliteParserANSIARGDECL              /* Extra arguments (if any) */
){
#ifndef NDEBUG
  if( yyTraceFILE ){
    fprintf(yyTraceFILE,"%sFail!\n",yyTracePrompt);
  }
#endif
  while( yypParser->idx>=0 ) yy_pop_parser_stack(yypParser);
  /* Here code is inserted which will be executed whenever the
  ** parser fails */
}

/*
** The following code executes when a syntax error first occurs.
*/
static void yy_syntax_error(
  yyParser *yypParser,           /* The parser */
  int yymajor,                   /* The major type of the error token */
  YYMINORTYPE yyminor            /* The minor type of the error token */
  sqliteParserANSIARGDECL               /* Extra arguments (if any) */
){
#define TOKEN (yyminor.yy0)
#line 23 "parse.y"

  sqliteSetString(&pParse->zErrMsg,"syntax error",0);
  pParse->sErrToken = TOKEN;

#line 6483 "parse.c"
}

/*
** The following is executed when the parser accepts
*/
static void yy_accept(
  yyParser *yypParser           /* The parser */
  sqliteParserANSIARGDECL              /* Extra arguments (if any) */
){
#ifndef NDEBUG
  if( yyTraceFILE ){
    fprintf(yyTraceFILE,"%sAccept!\n",yyTracePrompt);
  }
#endif
  while( yypParser->idx>=0 ) yy_pop_parser_stack(yypParser);
  /* Here code is inserted which will be executed whenever the
  ** parser accepts */
}

/* The main parser program.
** The first argument is a pointer to a structure obtained from
** "sqliteParserAlloc" which describes the current state of the parser.
** The second argument is the major token number.  The third is
** the minor token.  The fourth optional argument is whatever the
** user wants (and specified in the grammar) and is available for
** use by the action routines.
**
** Inputs:
** <ul>
** <li> A pointer to the parser (an opaque structure.)
** <li> The major token number.
** <li> The minor token number.
** <li> An option argument of a grammar-specified type.
** </ul>
**
** Outputs:
** None.
*/
void sqliteParser(
  void *yyp,                   /* The parser */
  int yymajor,                 /* The major token code number */
  sqliteParserTOKENTYPE yyminor       /* The value for the token */
  sqliteParserANSIARGDECL
){
  YYMINORTYPE yyminorunion;
  int yyact;            /* The parser action. */
  int yyendofinput;     /* True if we are at the end of input */
  int yyerrorhit = 0;   /* True if yymajor has invoked an error */
  yyParser *yypParser;  /* The parser */

  /* (re)initialize the parser, if necessary */
  yypParser = (yyParser*)yyp;
  if( yypParser->idx<0 ){
    if( yymajor==0 ) return;
    yypParser->idx = 0;
    yypParser->errcnt = -1;
    yypParser->top = &yypParser->stack[0];
    yypParser->top->stateno = 0;
    yypParser->top->major = 0;
  }
  yyminorunion.yy0 = yyminor;
  yyendofinput = (yymajor==0);

#ifndef NDEBUG
  if( yyTraceFILE ){
    fprintf(yyTraceFILE,"%sInput %s\n",yyTracePrompt,yyTokenName[yymajor]);
  }
#endif

  do{
    yyact = yy_find_parser_action(yypParser,yymajor);
    if( yyact<YYNSTATE ){
      yy_shift(yypParser,yyact,yymajor,&yyminorunion);
      yypParser->errcnt--;
      if( yyendofinput && yypParser->idx>=0 ){
        yymajor = 0;
      }else{
        yymajor = YYNOCODE;
      }
    }else if( yyact < YYNSTATE + YYNRULE ){
      yy_reduce(yypParser,yyact-YYNSTATE sqliteParserARGDECL);
    }else if( yyact == YY_ERROR_ACTION ){
#ifndef NDEBUG
      if( yyTraceFILE ){
        fprintf(yyTraceFILE,"%sSyntax Error!\n",yyTracePrompt);
      }
#endif
#ifdef YYERRORSYMBOL
      /* A syntax error has occurred.
      ** The response to an error depends upon whether or not the
      ** grammar defines an error token "ERROR".  
      **
      ** This is what we do if the grammar does define ERROR:
      **
      **  * Call the %syntax_error function.
      **
      **  * Begin popping the stack until we enter a state where
      **    it is legal to shift the error symbol, then shift
      **    the error symbol.
      **
      **  * Set the error count to three.
      **
      **  * Begin accepting and shifting new tokens.  No new error
      **    processing will occur until three tokens have been
      **    shifted successfully.
      **
      */
      if( yypParser->errcnt<0 ){
        yy_syntax_error(yypParser,yymajor,yyminorunion sqliteParserARGDECL);
      }
      if( yypParser->top->major==YYERRORSYMBOL || yyerrorhit ){
#ifndef NDEBUG
        if( yyTraceFILE ){
          fprintf(yyTraceFILE,"%sDiscard input token %s\n",
             yyTracePrompt,yyTokenName[yymajor]);
        }
#endif
        yy_destructor(yymajor,&yyminorunion);
        yymajor = YYNOCODE;
      }else{
         while(
          yypParser->idx >= 0 &&
          yypParser->top->major != YYERRORSYMBOL &&
          (yyact = yy_find_parser_action(yypParser,YYERRORSYMBOL)) >= YYNSTATE
        ){
          yy_pop_parser_stack(yypParser);
        }
        if( yypParser->idx < 0 || yymajor==0 ){
          yy_destructor(yymajor,&yyminorunion);
          yy_parse_failed(yypParser sqliteParserARGDECL);
          yymajor = YYNOCODE;
        }else if( yypParser->top->major!=YYERRORSYMBOL ){
          YYMINORTYPE u2;
          u2.YYERRSYMDT = 0;
          yy_shift(yypParser,yyact,YYERRORSYMBOL,&u2);
        }
      }
      yypParser->errcnt = 3;
      yyerrorhit = 1;
#else  /* YYERRORSYMBOL is not defined */
      /* This is what we do if the grammar does not define ERROR:
      **
      **  * Report an error message, and throw away the input token.
      **
      **  * If the input token is $, then fail the parse.
      **
      ** As before, subsequent error messages are suppressed until
      ** three input tokens have been successfully shifted.
      */
      if( yypParser->errcnt<=0 ){
        yy_syntax_error(yypParser,yymajor,yyminorunion sqliteParserARGDECL);
      }
      yypParser->errcnt = 3;
      yy_destructor(yymajor,&yyminorunion);
      if( yyendofinput ){
        yy_parse_failed(yypParser sqliteParserARGDECL);
      }
      yymajor = YYNOCODE;
#endif
    }else{
      yy_accept(yypParser sqliteParserARGDECL);
      yymajor = YYNOCODE;
    }
  }while( yymajor!=YYNOCODE && yypParser->idx>=0 );
  return;
}
