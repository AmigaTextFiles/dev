/*
 *      Small C+ Compiler
 *
 *      Lexical routines - string matching etc
 *
 *      $Id: lex.c 1.5 1999/03/22 21:27:18 djm8 Exp $
 */

#include "ccdefs.h"

extern char line[];

int streq(str1,str2)
char str1[],str2[];
{
        int k;
        k=0;
        while (*str2) {
                if ((*str1++)!=(*str2++)) return 0;
                ++k;
        }
        return k;
}


/*
 * compare strings
 * match only if we reach end of both strings or if, at end of one of the
 * strings, the other one has reached a non-alphanumeric character
 * (so that, for example, astreq("if", "ifline") is not a match)
 */
int astreq(str1, str2)
char *str1, *str2 ;
{
        int k;

        k=0;
        while ( *str1 && *str2 ) {
                if ( *str1 != *str2 ) break ;
                ++str1 ;
                ++str2 ;
                ++k ;
        }
        if ( an(*str1) || an(*str2) ) return 0;
        return k;
}

int match(lit)
char *lit;
{
        int k;

        blanks();
        if ( (k=streq(line+lptr,lit)) ) {
                lptr += k;
                return 1;
        }
        return 0;
}

int cmatch(lit)
char lit ;
{
        blanks() ;
        if (eof) iseof();
        if ( line[lptr] == lit ) {
                ++lptr ;
                return 1 ;
        }
        return 0 ;
}




/* djm, reversible match thing, used to scan for ascii fn defs.. 
 * this doesn't affect the line permanently! 
 */


int rmatch(lit)
char *lit;
{
        int k;
        blanks();
        if ( (k=astreq(line+lptr,lit)) ) return 1;
        return 0;
}

/*
 * djm, reversible character match, used to scan for local statics
 */

int rcmatch(lit)
char lit ;
{
        blanks() ;
        if (eof) iseof();
        if ( line[lptr] == lit ) {
                return 1 ;
        }
        return 0 ;
}


int amatch(lit)
char *lit;
{
        int k;

        blanks();
        if ( (k=astreq(line+lptr,lit)) ) {
                lptr += k;
                return 1;
        }
        return 0;
}

/*
 *      Consume unecessary identifiers (if present)
 */


int swallow(lit)
char *lit;
{
        return (amatch(lit));
}
