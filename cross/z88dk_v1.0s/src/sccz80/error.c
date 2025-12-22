/*
 *      Small C Compiler
 *
 *      Errors and other such misfitting routines
 *
 *      $Id: error.c 1.5 1999/03/18 01:14:26 djm8 Exp $
 */

#include "ccdefs.h"


int endst(void)
{
        blanks();
        return ( ch() == ';' || ch() == 0 );
}

void illname(void)
{
        error("Illegal symbol name");junk();
}

void multidef(void)
{
        error("Already defined");
}

char missing[] = "Missing token expecting " ;


/* Needtoken only checks for max of three characters..so okay to have
 * token[40]
 */

void needtoken(str)
char *str;
{
        char token[40];
        if ( match(str) == 0 ) {
                sprintf(token,"%s%s",missing,str);
                error(token);
        }
}

void needchar(c)
char c ;
{
        char token[40];
        if ( cmatch(c) == 0 ) {
                sprintf(token,"%s%c got %c",missing,c,( line[lptr]>=32 && line[lptr]<127 ? line[lptr] : '?'));
                error(token);
        }
}

void needlval(void)
{
        error("Must be lvalue");
}

void warningprelim(ptr)
char ptr[];
{
        char buffer[80];
        sprintf(buffer,"In function: %s() line #%d",currfn->name,lineno-fnstart);
        warning(buffer);
        warning(ptr);
}

void warning(ptr)
char ptr[];
{
        if (dowarnings) {
                toconsole();
                outstr("sccz80:"); outstr(Filename); outstr(" L:");outdec(lineno);
                outstr(" Warning: "); outstr(ptr); nl();
                tofile();
        }
}

void error(ptr)
char ptr[];
{
        toconsole();
        outstr("sccz80:"); outstr(Filename); outstr(" L:");outdec(lineno);
        outstr(" Error: "); outstr(ptr); nl();
        ++errcnt;
        if ( errstop ) {
                pl("Continue (Y/N) ? ");
                if ( raise(getchar()) == 'N' )
                        ccabort() ;
        }
        tofile();
        if (errcnt >= MAXERRORS ) {
                fprintf(stderr,"\nMaximum (%d) number of errors reached, aborting!\n",MAXERRORS);
                ccabort();
        }
}
