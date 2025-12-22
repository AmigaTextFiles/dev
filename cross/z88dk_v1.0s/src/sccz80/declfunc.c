/*
 *      Routines to declare a function
 *      Split from decl.c 11/3/98 djm
 *
 *      $Id: declfunc.c 1.5 1999/03/22 21:27:18 djm8 Exp $
 */

#include "ccdefs.h"


/*
 *      Function parsing here, we parse for prototyping and for
 *      declarations
 */

int AddNewFunc(
char *sname,
int type,
int storage,
char zfar,
char sign,
TAG_SYMBOL *otag,
int ident,
long *addr)
{
        SYMBOL *ptr,*ptr2;
        int     more;
        int     j,k;
        char    simple;         /* Simple def () */
        more=0;

/*
 *      First of all check to see if we have a number - this is
 *      external pointer type
 */

        if (number(addr)) return (EXTERNP);

/*
 *      Now, check for simple prototyping, we can drop that
 *      back as well, we have to check for punctuation - ; or ,
 *      afterwards, so that we can know its not a function
 *      definitions
 */
        simple=NO;
        if ( cmatch(')') ) {
                if ( rcmatch(';') || rcmatch(',') ) return(storage);
                simple=YES;
        }

        ptrerror(ident) ;
        if ( ident == POINTER ) {
        /* function returning pointer needs dummy symbol */
                more = dummy_idx(type, otag) ;
//                type = (zfar ? CPTR : CINT );
                ident=FUNCTIONP;        /* func returning ptr */
        } else ident=FUNCTION;

/*
 *      Okay, we've got rid of everything that could pop up apart
 *      from:
 *      - ANSI prototypes
 *      - Functions themselves (ANSI & K&R)
 *
 *      First call AddNewFunc(), if this returns 0 then we have defined
 *      a function (including code)
 */
        ptr=AddFuncCode(sname, type, ident,sign, zfar, storage, more,NO,simple,otag);
        if (ptr==0) return(0); /* Defined a function */
        else {
/*
 *      Have spotted a prototype, so do something with it!
 *      Trace back the argument train..
 */
                j=1;
                ptr2=ptr;
                while ( (ptr2=ptr2->offset.p) ) j++; 
                if ( j > MAXARGS ) j=MAXARGS-1;
                currfn->prototyped=j;    /* Set number of arguments */
/*
 *      Now, attempt to set them!
 */
                while (j) {
                        k=j;
                        ptr2=ptr;
                        while (--k) ptr2=ptr2->offset.p; 
/*
 *      Okay, so now in ptr2 we have the SYMBOL for the argument
 */
                        currfn->args[j]=CalcArgValue(ptr2->type, ptr2->ident, ptr2->flags);
                        if (ptr2->type==STRUCT) {
                                currfn->tagarg[j]=ptr2->tag_idx;
                        }
/*
 *      Set up the tag pointer now 
 */
                        j--;
                }
/*
 *      Zero the remaining prototyped entries
 */
                for ( j = (currfn->prototyped+1) ; j <= MAXARGS-1 ; j++) {
                        currfn->args[j]=0;
                }
/*
 *      Now, scan for if we are a lib prototype and set accordingly
 */

/* djm This is a kludge to only make lib functions LIBable.. */
                if ( storage == EXTERNAL ) {
                         currfn->size=0;      /* "Normal" funcs */
                         ptr2=findglb("HDRPRTYPE");
                         if (ptr2 != NULL )
                               if (ptr2->ident == MACRO) currfn->size=1;
                 }

        }
        return(0);

}


/*
 *      Begin a function
 *
 * Called from "parse" this routine tries to make a function
 *      out of what follows.
 */
void newfunc()
{
        char n[NAMESIZE];               /* ptr => currfn */

        if ( symname(n) == 0 ) {
                error("illegal function or declaration");
                clear();        /* invalidate line */
                return;
        }
        warning("Return type defaults to int");
        AddFuncCode(n,CINT,FUNCTION,dosigned,0,STATIK,0,1,NO,0);
}

/*
 *      Add the function proper, this is called from newfunc()
 *      and also from AddNewFunc(), returns 0 if added a real
 *      function (code etc)
 */

#ifndef SMALL_C
SYMBOL *
#endif

AddFuncCode(char *n, char type, char ident, char sign,char zfar, int storage, int more, char check,char simple,TAG_SYMBOL *otag)
{
        unsigned char tvalue;           /* Used to hold protot value */
        char    typ;                    /* Temporary type */
        int     itag;

        itag=0;
        if (otag)
              itag=otag-tagtab;       /* tag number */

        lastst = 0;                     /* no last statement */
        locptr = STARTLOC ;             /* deallocate all locals */
        fnstart = lineno ;              /* remember where fn began */
/*
 * Do some elementary checking before hand..
 */
        if (zfar && ident!=FUNCTIONP) { zfar=NO; warning("Far only applicable for pointers"); }
        if ( ( currfn=findglb(n) ) ) {
                /* already in symbol table ? */
                if ( currfn->ident != FUNCTION && currfn->ident != FUNCTIONP ) {
                        /* already variable by that name */
                        multidef();
                }
                else if ( currfn->offset.i == FUNCTION && !currfn->prototyped) {
                        /* already function by that name */
                        multidef();
                }
                else {
                        /* we have what was earlier assumed to be a function */
                        if (currfn->storage != EXTERNAL && currfn->size != 1 ) {
        /* We're overwriting a lib function, is this what you intended? 
         * comes in very handy for compiling the library though!
         */
                                currfn->size = 0;
                        }
                        currfn->offset.i = FUNCTION ;
                        currfn->storage = STATIK;
                }
        }
        /* if not in table, define as a function now */
        else {  
                typ=type;
                if (ident == FUNCTIONP) typ=(zfar ? CPTR : CINT );

                currfn = addglb(n, FUNCTION,  typ, FUNCTION, storage, more, 0);
                currfn->size=0;
                currfn->prototyped=0;
                currfn->flags= (sign&UNSIGNED) | (zfar&FARPTR);
                if (type == STRUCT) currfn->tagarg[0]=itag;
/*
 *      Set our function prototype - what we are!
 *      args[0] is free for use
 */
                currfn->args[0]=CalcArgValue(type, ident, currfn->flags);

         }
        tvalue=CalcArgValue(type,ident,((sign&UNSIGNED) | (zfar&FARPTR)) );
        if ( currfn->args[0] != tvalue || (type==STRUCT && currfn->tagarg[0] != itag  )  ){
                char buffer[120],buffer2[120];
                warning("Function returns different type to prototyped");
                sprintf(buffer,"Prototype is: %s", ExpandArgValue(currfn->args[0],buffer2,currfn->tagarg[0]) );
                warning(buffer);
                sprintf(buffer,"Function is:  %s", ExpandArgValue(tvalue,buffer2,itag) );
                warning(buffer);

        }

        /* we had better see open paren for args... */
        if ( check && (cmatch('(') == 0) )
                error("missing open paren");


        locptr = STARTLOC ;             /* "clear" local symbol table */
        undeclared = 0 ;                /* init arg count */


/* Check to see if we are doing ANSI fn defs - must be a better way of
 * doing this! (Have an array and check by that?)           
 */
        if (CheckANSI()) {
                return( dofnansi(currfn) ); /* So we can pass back result */
        }
        DoFnKR(currfn,simple);
        return(0);
}


/*
 * This is where we do K&R function definitions, make this into
 * a separate function and then it makes life a lot easier!!
 */


void DoFnKR(currfn,simple)
SYMBOL *currfn;
char   simple;
{
        char n[NAMESIZE];
        SYMBOL *prevarg;       /* ptr to symbol table entry of most recent argument */
        SYMBOL *cptr;
        TAG_SYMBOL *otag ;     /* structure tag for structure argument */
        struct varid var;

        prevarg=0;
        Zsp=0;                  /* Reset stack pointer */
        undeclared=0;
        infunc=1;



        while ( !simple && cmatch(')') == 0 ) {    /* then count args */
                /* any legal name bumps arg count */
                if ( symname(n) ) {
                        /* add link to argument chain */
                        if ( (cptr=addloc(n,0,CINT,0,0)) )
                                cptr->offset.p = prevarg ;
                        prevarg = cptr ;
                    ++undeclared ;
                }
                else {
                        error("illegal argument name");
                        junk();
                }
                blanks();
                /* if not closing paren, should be comma */
                if ( ch() != ')' && cmatch(',') == 0 ) {
                        warning("Expected comma");
                }
                if ( endst() ) break ;
        }

        Zsp = 0 ;                       /* preset stack ptr */

        while ( undeclared ) {

                otag=GetVarID(&var,STATIK);

                if (var.type==STRUCT) {
                        getarg(STRUCT, otag,NO,0,0, var.zfar,NO) ;
                } else if (var.type) {
                        getarg(var.type,NULL_TAG,NO,0,var.sign,var.zfar,NO);
                } else {
                        error("Incorrect number of arguments") ;
                        break ;
                }
        }
/* Have finished K&R parsing */
        setlocvar(prevarg,currfn);
}


/* Set the argument offsets for a function, and compile the function
 * taken out of newfunc by djm
 */

void setlocvar(prevarg,currfn)
SYMBOL *prevarg;
SYMBOL *currfn;
{
        int lgh,where;
        int *iptr;
        int argnumber;
        char buffer[120];
        char buffer2[120];
        char tester;

        argnumber=currfn->prototyped;
/*
 *      If we have filled up our number of arguments, then pretend
 *      we don't have any..nasty, nasty
 */
        if (argnumber==(MAXARGS-1)) argnumber=0;
        else   if (argnumber) argnumber=1;
/*
 *      Dump some info about defining the function etc
 */
        if (verbose){
        toconsole();
        outstr("Defining function: "); outstr(currfn->name); nl();
        tofile();
        }

        nl();prefix();outname(currfn->name,dopref(currfn));col();nl();  /* print function name */

        infunc=1;       /* In a function for sure! */

        where = 2 ;
        while ( prevarg ) {
                lgh = 2 ;       /* all arguments except DOUBLE have length 2 bytes (even char) */
                /* This is strange, previously double check for ->type */
                if ( prevarg->type == LONG && prevarg->ident != POINTER )
                        lgh=4;
                if ( prevarg->type == DOUBLE && prevarg->ident != POINTER )
                        lgh=6;
/* All pointers are pushed onto the stack for functions as 4 bytes, if
 * needed, near pointers are padded out to compensate for this by dummy
 * loading with zero, this allows us to have one set of routines to
 * cope with this and hence solve a lot of duplication
 */
                if (prevarg->ident == POINTER && lpointer) lgh=4;
                prevarg->size=lgh;
/*
 * Check the definition against prototypes here...
 */
                if (argnumber) {
                        tester=CalcArgValue(prevarg->type,prevarg->ident,prevarg->flags);
                        if (currfn->args[argnumber] != tester ) {
                            if (currfn->args[argnumber] != PELLIPSES ) {
                                if (currfn->args[argnumber] == 0 ) {
                                        warning("Too many arguments in declaration");
                                } else {
                                        sprintf(buffer,"Argument mismatch %s() Arg #%d: %s",currfn->name,argnumber, ExpandArgValue(tester,buffer2,prevarg->tag_idx) );
                                        error(buffer);
                                        sprintf(buffer,"Doesn't match original decl type: %s", ExpandArgValue(currfn->args[argnumber],buffer2, currfn->tagarg[argnumber]) );
                                        warning(buffer);
                                }
                            }
                        }
                        argnumber++;
                }
                iptr = &prevarg->offset.i ;
                prevarg = prevarg->offset.p ;           /* follow ptr to prev. arg */
                *iptr = where ;                                         /* insert offset */
                where += lgh ;                                          /* calculate next offset */
        }
        stackargs=where;
        lstdecl=0;       /* Set number of local statics to zero */
        if ( statement() != STRETURN ) {
                if (lstdecl) postlabel(lstlab);
                lstdecl=0;
                /* do a statement, but if it's a return, skip */
                /* cleaning up the stack */
                leave(NO) ;
        }

        infunc = 0 ;                    /* not in fn. any more */
}

/* djm Declare a function in the ansi style! */
#ifndef SMALL_C
SYMBOL *
#endif
dofnansi(currfn)
SYMBOL *currfn;
{
        SYMBOL *prevarg;       /* ptr to symbol table entry of most recent argument */
        SYMBOL *argptr;        /* Temporary holder.. */
        TAG_SYMBOL *otag ;     /* structure tag for structure argument */
        struct  varid var;
        char    proto;

        locptr=STARTLOC;
        prevarg=0;
        Zsp=0;                  /* Reset stack pointer */
        undeclared=1;
        proto=YES;

/* Master loop, checking for end of function */

        while ( cmatch(')') == 0 ) {  
                if (amatch("...") ) {
/*
 * Found some ellipses, so, add it to the local symbol table and
 * then return..(after breaking, and checking for ; & , )
 */
                        needchar(')');
                        argptr=addloc("ellp",0,ELLIPSES,0,0);
                        argptr->offset.p = prevarg;
                        prevarg=argptr;
                        break;
                }
                otag=GetVarID(&var,STATIK);

                if (var.type==STRUCT) {
                        prevarg=getarg(STRUCT, otag,YES,prevarg,0, var.zfar,proto) ;
                } else if (var.type) {
                        prevarg=getarg(var.type,NULL_TAG,YES,prevarg,var.sign,var.zfar,proto);

                } else {
                        warning("Expected argument");
                        break;
                }
                proto++;
/* Now check for comma */
                if (ch() !=')' && cmatch(',') == 0) {
                        warning("Expected comma");
                        break;
                }
        }
/*
 *      Check for semicolon - I think this should be enough, just
 *      have to have prototypes on separate lines - good practice
 *      in anycase!!
 */
        if (cmatch(';') ) return (prevarg);
        setlocvar(prevarg,currfn);
        return (0);
}

/*
 *      Check to see if could be doing any ANSI style function definitions
 *
 *      Returns: YES - we are, NO - we're not
 */

int CheckANSI()
{
        if (rmatch("unsigned") || rmatch("signed") || rmatch("int") || rmatch("char") || rmatch("double") || rmatch("long") || rmatch("struct") || rmatch("union") || rmatch("void") || rmatch("far") || rmatch("near") ) return (YES);
        return (NO);
}




/*
 *      Declare argument types
 *
 * called from "newfunc" this routine adds an entry in the
 *      local symbol table for each named argument
 */
#ifndef SMALL_C
SYMBOL *
#endif
getarg(
int typ ,               /* typ = CCHAR, CINT, DOUBLE or STRUCT */
TAG_SYMBOL *otag ,      /* structure tag for STRUCT type objects */
int deftype,            /* YES=ANSI -> addloc NO=K&R -> findloc */
SYMBOL *prevarg,        /* ptr to previous argument, only of use to ANSI */
char issigned,          /* YES=unsigned NO=signed */
char zfar,              /* FARPTR=far NO=near */
char proto)              /* YES=prototyping -> names not needed */
{
        char n[NAMESIZE] ;
        SYMBOL *argptr ;
        int legalname, ident ;
        int brkflag;            /* Needed to correctly break out for K&R*/
/*
 * This is of dubious need since prototyping came about, we could
 * inadvertently include fp packages if the user includes <math.h> but
 * didn't actually use them, we'll save the incfloat business for
 * static doubles and definitions of local doubles
 *
 *      if (typ == DOUBLE)
 *              incfloat=1;
 */

/* Only need while loop if K&R defs */

        while ( undeclared) {
                ident = get_ident() ;
                if ( (legalname=symname(n)) == 0 ) {
                        if (!proto) { illname(); }
                        else { 
/*
 * Obligatory silly fake name
 */
                                sprintf(n,"sg6p_%d",proto);
                                legalname=1; 
                        }
                }
                if ( ident == PTR_TO_FN ) {
                        needtoken(")()") ;
                        ident = FUNCTIONP ;
                }
                if ( cmatch('[') ) {    /* pointer ? */
                        ptrerror(ident) ;
                        /* it is a pointer, so skip all */
                        /* stuff between "[]" */
                        while ( inbyte() != ']' )
                                if ( endst() ) break;
                        /* add entry as pointer */
                        ident = (ident == POINTER) ? PTR_TO_PTR : POINTER ;
                }
                if ( legalname ) {
/*
 * For ANSI we need to add symbol name to local table - this CINT is  
 * temporary
 */
                        if (deftype) {
                                argptr=addloc(n,0,CINT,0,0);
                                argptr->offset.p = prevarg;
                        }
/*
 * If prototyping, then we can't find the name, but if we're prototyping
 * we have been defined as ANSI, therefore argptr already holds
 * the correct pointer - kinda neat!
 */
                        if ( proto || (argptr=findloc(n)) ) {
                                argptr->flags=(zfar&FARPTR)|(issigned&UNSIGNED);
                                /* add in details of the type of the name */
                                if ( ident == PTR_TO_PTR ) {
/* djm mods will be here for long pointer */
                                        argptr->flags = UNSIGNED ; /*unsigned*/
                                        argptr->ident = POINTER ;
                                        argptr->type = CINT ;
                                        argptr->more = dummy_idx(typ, otag) ;
                                }
                                else {
                                        argptr->ident = ident ;
                                        argptr->type = typ ;
                                }
                        }
                        else error("expected argument");
                        if ( otag ) {
                                argptr->tag_idx = otag - tagtab ;
                                argptr->ident = POINTER ;
                                argptr->type = STRUCT ;
                        }
                }
                brkflag=0;
                if (!deftype) {
                        --undeclared;   /* cnt down */
                        if ( endst() )
                                { brkflag=1; break; }
                       if ( cmatch(',') == 0 )
                                warning("Expected comma") ;
                }
                if (brkflag || deftype) break;
        }
        if (deftype) return(argptr);
        ns();
        return(0);
}

