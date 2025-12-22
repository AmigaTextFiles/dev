/*
 * Include file used by lc. 
 *
 * HISTORY:
 *      Initial coding finished June 10, 1981 by Brian Marick of DTI.
 *      Aug 16, 1983    Brian Marick of Compion         Counts '}', '{' as
 *                                                      white space.
 *      Aug 17, 1992    Brian Marick, self-employed     Improve for GCT demo
 *      Jul 12, 2004    Ray Rizzuto                     Added C++ comments parsing
*/

#define TABSIZE 8

#define FORM_FEED       '\014'
#define TAB     '\t'
#define NEWLINE '\n'
#define BLANK   ' '
#define STRING  '"'
#define QUOTE   '\''
#define BACKSLASH       '\\'
#define LCURL   '{'
#define RCURL   '}'

#define ST_COMM1        '/'                             /* First opening comment character. */
#define ST_COMM2        '*'                             /* second opening comment character. */
#define EN_COMM1        '*'                             /* first closing comment character. */
#define EN_COMM2        '/'                             /* second closing comment character. */

#define TRUE    1
#define FALSE   0

typedef int     BOOLEAN;                                /* Should contain only TRUE and FALSE */



/* The following are potential arguments to the exit function. */

#define OK              0                               /* normal exit */
#define FILE_NOT_FOUND  1                               /* command line file not found. */
#define BAD_FLAG        2                               /* bad pagesize flag */
#define PANIC           3                               /* exit after program error. */



typedef int TOKEN;                                      /* input line tokens. See below. */

#define T_START_COMMENT 1                               /* The characters that begin a comment. */
#define T_END_COMMENT   2                               /* The characters that end a comment. */
#define T_END_LINE      3                               /* EOF, FORM_FEED, or '\n' */
#define T_WHITE         4                               /* Any combination of blanks or tabs. */
#define T_TEXT          5                               /* Any other single character. */
#define T_START_CPP_COMMENT 6							/* C++ comment start */


struct tally                                            /* Used to tally lines in a file. */
{
    int     pure_code;                                  /* lines containing only code. */
    int     pure_comment;                               /* lines containing only comments. */
    int     both;                                       /* lines containing both. */
    int     blank;                                      /* blank lines. */
    int     pages;                                      /* number of pages. */
};


struct line                                             /* Used to determine the type of a line. */
{
    BOOLEAN null_line;                                  /* TRUE if this line doesn't count as a line. */
    BOOLEAN code;                                       /* TRUE if this line contains code. */
    BOOLEAN comment;                                    /* TRUE if this line contains a comment. */
    BOOLEAN blank;                                      /* TRUE if this line is blank. */
};


/* 
  PULL_OFF will get a character from the input stream. The BACKSLASH will
  be used to escape single and double quotes.
  In any other case, the backslash will be ignored.
*/

#define PULL_OFF(C, FP) C = fgetc(FP);                                  \
                        if (C == BACKSLASH)                             \
                        {                                               \
                                C = fgetc (FP);                         \
                                if ((C == STRING) || (C == QUOTE))      \
                                        C = BACKSLASH;                  \
                        }

#define PUSH_BACK(C, FP) if  ( ! (C == EOF))                            \
                                if (ungetc (C, FP) == EOF)              \
                                        panic (PANIC, "Can't push character");



extern int     page_size;                               /* Global size of a page. */
extern BOOLEAN in_comment;                              /* TRUE if we are in a comment. */
extern BOOLEAN in_cpp_comment;                          /* TRUE if we are in a C++ comment. */
extern BOOLEAN white_bracket;                           /* TRUE -- brackets count as white space. */

