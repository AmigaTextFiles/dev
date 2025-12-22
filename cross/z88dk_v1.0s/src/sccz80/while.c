/*
 *      Small C+ Compiler
 *
 *      Couple of routines for while statements
 *
 *      $Id: while.c 1.3 1999/03/18 01:14:26 djm8 Exp $
 */

#include "ccdefs.h"



void addwhile(ptr)
WHILE_TAB *ptr ;
{
        wqptr->sp = ptr->sp = Zsp ;                             /* record stk ptr */
        wqptr->loop = ptr->loop = getlabel() ;  /* and looping label */
        wqptr->exit = ptr->exit = getlabel() ;  /* and exit label */
        if ( wqptr >= WQMAX ) {
                error("Too many active whiles");
                return;
        }
        ++wqptr ;
}

void delwhile()
{
        if ( wqptr > wqueue ) --wqptr ;
}

#ifndef SMALL_C
WHILE_TAB *
#endif

readwhile(ptr)
WHILE_TAB *ptr ;
{
        if ( ptr <= wqueue ) {
                error("Out of context");
                return 0;
        }
        else return (ptr-1) ;
}
