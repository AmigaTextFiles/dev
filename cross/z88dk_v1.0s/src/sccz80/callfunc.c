/*
 *      Small C+ Compiler
 *
 *      Perform a function call
 *
 *      $Id: callfunc.c 1.9 1999/03/18 01:14:26 djm8 Exp $
 */


/*
 *      Perform a function call
 *
 * called from heirb, this routine will either call
 *      the named function, or if the supplied ptr is
 *      zero, will call the contents of HL
 */

#include "ccdefs.h"





void callfunction(ptr)
SYMBOL *ptr;    /* symbol table entry (or 0) */
{
        int nargs, vconst, val,expr,argnumber ;
        unsigned char protoarg;

        nargs=0;
        argnumber=0;
        blanks();       /* already saw open paren */
/*
 * djm, another fabulous kludge!!
 * we don't check return types or anything..beautiful!!
 */

        if (ptr && (strcmp(ptr->name,"asm")==0) ) {
/* We're calling asm("code") */
                doasmfunc(NO);
                return;
        }

        while ( ch() != ')' ) {
                if(endst())break;
                argnumber++;
                if ( ptr ) {
                        /* ordinary call */
                        expr=expression(&vconst, &val);
                        if (ptr->prototyped && (ptr->prototyped >= argnumber) ) {
                                protoarg=ptr->args[ptr->prototyped-argnumber+1];
                                if (protoarg!=PELLIPSES && (protoarg != fnargvalue || ((protoarg&7)==STRUCT) ) )
                                        expr=ForceArgs(protoarg,fnargvalue,expr,ptr->tagarg[ptr->prototyped-argnumber+1]);
#ifdef DEBUG_PROTOS
                                printf("arg %d proto %d\n",argnumber,protoarg);
#endif
                        }


                        if (expr==DOUBLE) {
                                dpush();
                                nargs += 6;
                        }
/* Longs and (ahem) long pointers! */
                        else if (expr == LONG || expr == CPTR || (expr==POINTER && lpointer)) {
                                if (!(fnflags&FARPTR) && expr != LONG ) const2(0);
                                lpush();

                                nargs += 4;
                        }
                        else {
                                zpush();
                                nargs += 2;
                        }
                }
                else { /* call to address in HL */
/*
 * What do you do about longs also long pointers, need to push under
 * stack...hmmmmm: parse for LONG & CPTR push onto stk
 * then check if doubles...should work.
 */

                        zpush();        /* Push address */
                        expr=expression(&vconst, &val);
                        if (expr == LONG || expr == CPTR || (expr==POINTER && lpointer) ) {
                                lpush2();
                                nargs += 4;
                        }
                        else if (expr==DOUBLE) {
                                dpush2();
                                nargs += 6;
                        }
                        else {
                                nargs += 2;
                        }
                        swapstk();
                }
                if (cmatch(',')==0) break;
        }
        needchar(')');

#ifdef DEBUG_PROTOS
                                printf("arg %d proto %d\n",argnumber,ptr->args[1]);
#endif

        if (ptr && ( ptr->prototyped != 0 )) {
                if ( (ptr->prototyped > argnumber) && (ptr->args[1]!=PVOID) ) {
                        warning("Too few arguments in function call");
                } else if ( (ptr->prototyped < argnumber)  && (ptr->args[1]!=PELLIPSES)) {
                        warning("Too many arguments in function call");
                }
        }

        if ( ptr ) {
                if ( nospread(ptr->name) ) {
                        loadargc(nargs) ;
                }
                zcall(ptr) ;
        }
        else callstk(nargs);
/*
 *      ptr->size is set to 1 for lib functions
 */
        if ( (ptr && ptr->size == 1) || !compactcode)
                Zsp=modstk(Zsp+nargs,YES);      /* clean up arguments */
        else
                Zsp+=nargs;
}

int nospread(sym)
char *sym ;
{
        if ( strcmp(sym,"printf") == 0 ) return 1;
        if ( strcmp(sym,"fprintf") == 0 ) return 1;
        if ( strcmp(sym,"sprintf") == 0 ) return 1;
        if ( strcmp(sym,"scanf") == 0 ) return 1;
        if ( strcmp(sym,"fscanf") == 0 ) return 1;
        if ( strcmp(sym,"sscanf") == 0 ) return 1;
        return 0;
}

/*
 *      djm routine to force arguments to switch type
 */

int ForceArgs(char dest, char src,int expr, char functab)
{
        char    did, dtype, disfar, dissign;
        char    sid, stype, sisfar, sissign;
        char    buffer[80];
        char    buffer2[80];


        dtype=dest&7;           /* Lower 3 bits */
        did=(dest&56)/8;     /* Middle 3 bits */
        disfar=(dest&128);
        dissign=(dest&64);

        stype=src&7;           /* Lower 3 bits */
        sid=(src&56)/8;     /* Middle 3 bits */
        sisfar=(src&128);
        sissign=(src&64);

/*
 *      These checks need to be slightly more comprehensive me thinks
 */

        if (did == VARIABLE ) {
                force(dtype,stype,dissign,sissign,0);
                if (dtype == CCHAR ) expr=CINT;
                else expr=dtype;
        } else {
/* Dealing with pointers.. a type mismatch!*/
                if ( ( (dtype != stype) && ( dtype != VOID) ) || ( (dtype==stype) && (margtag != functab) ) ) {
                        warningprelim("Ptr/ptr type mismatch");
                        ExpandArgValue(dest,buffer2,functab);
                        sprintf(buffer,"Fn expects: %s",buffer2);
                        warning(buffer);
                        ExpandArgValue(src,buffer2,margtag);
                        sprintf(buffer,"Fn gets: %s",buffer2);
                        warning(buffer);
                } 

                if ( disfar ) {
                        if ( disfar != sisfar )  {
/* Widening a pointer - next line unneeded - done elsewhere*/
/*                                const2(0); */
                                expr=CPTR;
                        } else {
/* Narrowing a pointer */
                                warningprelim("Converting far ptr to near ptr");
                                expr=CINT;
                        }
                }
        }
        return(expr);
}
