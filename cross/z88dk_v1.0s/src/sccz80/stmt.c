/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part deals with statements
 *
 *      $Id: stmt.c 1.10 1999/03/22 21:27:18 djm8 Exp $
 */

#include "ccdefs.h"





/*
 *      Statement parser
 *
 * called whenever syntax requires a statement.
 * this routine performs that statement
 * and returns a number telling which one
 */
int statement()
{
        TAG_SYMBOL *otag ;
        int st ;
        struct varid var;
        char locstatic;  /* have we had the static keyword */


        blanks() ;
        if ( ch()==0 && eof )
                return (lastst=STEXP) ;
        else {
/* Ignore the register and auto keywords! */
                locstatic= ( (swallow("register")) | swallow("auto") );

/* Check to see if specified as static, and also for far and near */
                if (amatch("static") ) {
                        if (locstatic) {
                                warning("Static incompatible with register/auto");
                                locstatic=0;
                        } else  locstatic=YES;
                }
/*
 * Now get the identity, STATIK is for struct definitions
 */
                otag=GetVarID(&var,STATIK);

                if (var.type==STRUCT) {
                           declloc(STRUCT, otag,var.sign,locstatic,var.zfar) ;
                           return(lastst);
                } else if (var.type) {
                          declloc(var.type, NULL_TAG,var.sign,locstatic,var.zfar);
                          return (lastst) ;
                }

                /* not a definition */
                if ( declared >= 0 ) {
                        if (lstdecl) postlabel(lstlab);
                        lstdecl=0;
                        Zsp = modstk(Zsp-declared, NO) ;
                        declared = -1 ;
                }
                st = -1 ;
                switch ( ch() ) {
                case '{' :
                        inbyte() ;
                        compound() ;
                        st = lastst ;
                        break ;
                case 'i' :
                        if ( amatch("if") ) {
                                doif() ;
                                st = STIF ;
                        }
                        break ;
                case 'w' :
                        if ( amatch("while") ) {
                                dowhile() ;
                                st = STWHILE;
                        }
                        break ;
                case 'd' :
                        if ( amatch("do") ) {
                                dodo() ;
                                st = STDO ;
                        }
                        else if ( amatch("default") ) {
                                dodefault() ;
                                st = STDEF ;
                        }
                        break ;
                case 'f' :
                        if ( amatch("for") ) {
                                dofor() ;
                                st = STFOR ;
                        }
                        break ;
                case 's' :
                        if ( amatch("switch") ) {
                                doswitch() ;
                                st = STSWITCH ;
                        }
                        break ;
                case 'c' :
                        if ( amatch("case") ) {
                                docase() ;
                                st = STCASE;
                        }
                        else if ( amatch("continue") ) {
                                docont() ;
                                ns() ;
                                st = STCONT ;
                        }
                        break ;
                case 'r' :
                        if ( amatch("return") ) {
                                doreturn() ;
                                ns() ;
                                st = STRETURN ;
                        }
                        break ;
                case 'b' :
                        if ( amatch("break") ) {
                                dobreak() ;
                                ns() ;
                                st = STBREAK ;
                        }
                        break ;
                case ';' :
                        inbyte() ;
                        st = lastst ;
                        break ;
                case 'a' :
                        if ( amatch("asm") ) {
                                doasmfunc(YES);
                                st=STASM;
                        }
                        break;
                case '#' :
                        if ( match("#asm") ) {
                                doasm() ;
                                st = STASM;
                        }
                        break ;
                }
                if ( st == -1 ) {
                        /* if nothing else, assume it's an expression */
                        doexpr() ;
                        ns() ;
                        st = STEXP ;
                }
        }
        return (lastst = st) ;
}

/*
 *      Semicolon enforcer
 *
 * called whenever syntax requires a semicolon
 */
void ns()
{
        if ( cmatch(';') == 0 )
                warning("Expected semicolon");
}

/*
 *      Compound statement
 *
 * allow any number of statements to fall between "{}"
 */
void compound()
{
        SYMBOL *savloc ;
        int savcsp ;

        savcsp = Zsp ;
        savloc = locptr ;
        declared = 0 ;          /* may declare local variables */
        ++ncmp;                         /* new level open */
        while (cmatch('}')==0) statement(); /* do one */
        --ncmp;                         /* close current level */
        if ( lastst != STRETURN ) {
                modstk(savcsp,NO) ;             /* delete local variable space */
        }
        Zsp = savcsp ;
        locptr = savloc ;       /* delete local symbols */
        declared = -1 ;
}

/*
 *              "if" statement
 */
void doif()
{
        int flab1,flab2;

        flab1=getlabel();       /* get label for false branch */
        test(flab1,YES);        /* get expression, and branch false */
        statement();            /* if true, do a statement */
        if ( amatch("else") == 0 ) {
                /* no else, print false label and exit  */
                postlabel(flab1);
                return;
        }
        /* an "if...else" statement. */
        flab2 = getlabel() ;
        if ( lastst != STRETURN ) {
                /* if last statement of 'if' was 'return' we needn't skip 'else' code */
                jump(flab2);
        }
        postlabel(flab1);                               /* print false label */
        statement();                                    /* and do 'else' clause */
        postlabel(flab2);                               /* print true label */
}




/*
 * perform expression (including commas)
 */
int doexpr()
{
        char *before, *start ;
        int type, vconst, val ;

        while (1) {
                setstage(&before, &start) ;
                type = expression(&vconst, &val) ;
                clearstage( before, start ) ;
                if ( ch() != ',' ) return type ;
                inbyte() ;
        }
}

/*
 *      "while" statement
 */
void dowhile()
{
        WHILE_TAB wq ;          /* allocate local queue */

        addwhile(&wq) ;                 /* add entry to queue */
                                                        /* (for "break" statement) */
        postlabel(wq.loop) ;    /* loop label */
        test(wq.exit, YES) ;    /* see if true */
        statement() ;                   /* if so, do a statement */
        jump(wq.loop) ;                 /* loop to label */
        postlabel(wq.exit) ;    /* exit label */
        delwhile() ;                    /* delete queue entry */
}

/*
 * "do - while" statement
 */
void dodo()
{
        WHILE_TAB wq ;
        int top ;

        addwhile(&wq) ;
        postlabel(top=getlabel()) ;
        statement() ;
        needtoken("while") ;
        postlabel(wq.loop) ;
        test(wq.exit, YES) ;
        jump(top);
        postlabel(wq.exit) ;
        delwhile() ;
        ns() ;
}

/*
 * "for" statement
 */
void dofor()
{
        WHILE_TAB wq ;
        int lab1, lab2 ;

        addwhile(&wq) ;
        lab1 = getlabel() ;
        lab2 = getlabel() ;
        needchar('(') ;
        if (cmatch(';') == 0 ) {
                doexpr() ;                              /* expr 1 */
                ns() ;
        }
        postlabel(lab1) ;
        if ( cmatch(';') == 0 ) {
                test(wq.exit, NO ) ;    /* expr 2 */
                ns() ;
        }
        jump(lab2) ;
        postlabel(wq.loop) ;
        if ( cmatch(')') == 0 ) {
                doexpr() ;                              /* expr 3 */
                needchar(')') ;
        }
        jump(lab1) ;
        postlabel(lab2) ;
        statement() ;
        jump(wq.loop) ;
        postlabel(wq.exit) ;
        delwhile() ;
}

/*
 * "switch" statement
 */
void doswitch()
{
        WHILE_TAB wq ;
        int endlab, swact, swdef ;
        SW_TAB *swnex, *swptr ;
        char    swtype;   /* type of switch statement - CINT/LONG */

        swact = swactive ;
        swdef = swdefault ;
        swnex = swptr = swnext ;
        addwhile(&wq) ;
        (wqptr-1)->loop = 0 ;
        needchar('(') ;
        swtype=doexpr() ;                      /* evaluate switch expression */
        needchar(')') ;
        swdefault = 0 ;
        swactive = 1 ;
        jump(endlab=getlabel()) ;
        statement() ;           /* cases, etc. */
        jump(wq.exit) ;
        postlabel(endlab) ;
        sw(swtype) ;                          /* insert code to match cases */
        while ( swptr < swnext ) {
                defword() ;
                printlabel(swptr->label) ;              /* case label */
                if (swtype==LONG) {
                        outbyte('\n');
                        deflong();
                }else
                        outbyte(',') ;
                outdec(swptr->value) ;                  /* case value */
                nl() ;
                ++swptr ;
        }
        defword() ;
        outdec(0) ;
        nl() ;
        if (swdefault) jump(swdefault) ;
        postlabel(wq.exit) ;
        delwhile() ;
        swnext = swnex ;
        swdefault = swdef ;
        swactive = swact ;
}

/*
 * "case" statement
 */
void docase()
{
        if (swactive == 0) error("not in switch") ;
        if (swnext > swend ) {
                error("too many cases") ;
                return ;
        }
        postlabel(swnext->label = getlabel()) ;
        constexpr(&swnext->value) ;
        needchar(':') ;
        ++swnext ;
}

void dodefault()
{
        if (swactive) {
                if (swdefault) error("multiple defaults") ;
        }
        else error("not in switch") ;
        needchar(':') ;
        postlabel(swdefault=getlabel()) ;
}
        

/*
 *      "return" statement
 */
void doreturn()
{
        /* if not end of statement, get an expression */
        if ( endst() == 0 ) {
                if ( currfn->more ) {
                        /* return pointer to value */
                        force(CINT, doexpr(),YES,dosigned,0) ;
                }
                else {
                        /* return actual value */
                        force(currfn->type, doexpr(), currfn->flags&UNSIGNED, dosigned,0) ;
                }
                leave(YES);
        }
        else leave(NO) ;
}

/*
 * leave a function
 * preserve primary register if save is TRUE
 */
void leave(save)
int save ;
{
        int savesp;
        modstk(0,save); /* clean up stk */
        if (compactcode && (stackargs>2) ) {
/* 
 * We're exiting a function and we want to clean up after ourselves
 * (so calling function doesn't have to do this) (first of all we
 * have to grab the return address - easy just to exchange
 */
                savesp=Zsp;
                doexx();
                zpop();         /* Return address in de */
                Zsp-=stackargs-2;
                modstk(0,0);
                zpushde();
                doexx();
                Zsp=savesp;
        }
        zret();         /* and exit function */
}

/*
 *      "break" statement
 */
void dobreak()
{
        WHILE_TAB *ptr ;

        /* see if any "whiles" are open */
        if ((ptr=readwhile(wqptr))==0) return;  /* no */
        modstk(ptr->sp, NO);    /* else clean up stk ptr */
        jump(ptr->exit) ;               /* jump to exit label */
}

/*
 *      "continue" statement
 */
void docont()
{
        WHILE_TAB *ptr;

        /* see if any "whiles" are open */
        ptr = wqptr ;
        while (1) {
                if ((ptr=readwhile(ptr))==0) return ;
                /* try again if loop is zero (that's a switch statement) */
                if ( ptr->loop ) break ;
        }
        modstk(ptr->sp, NO) ;   /* else clean up stk ptr */
        jump(ptr->loop) ;               /* jump to loop label */
}

/*
 *      asm()   statement
 *
 *      This doesn't do any label expansions - just chucks it out to
 *      the file, it might be useful for setting a value to machine
 *      code thing
 *      
 *      If wantbr==YES then we need the opening bracket (called by
 *      itself)
 *
 *      Actually, this caution may be unneccesary because it is also
 *      dealt with as a function, we'll just have to see - i.e. maybe
 *      it doesn't have to be statement as well!
 *
 *      New: 3/3/99 djm
 */

void doasmfunc(char wantbr)
{
        char c;
        if (wantbr) needchar('(');

        outbyte('\t');
        needchar('"');
        do {
                while (!cmatch('"')) {
                        c=litchar();
                        if (c == 0)
                                break;
                        outbyte(c);
                        if ( c == 10 || c == 13 ) outstr("\n\t");
                }
        } while (cmatch ('"'));
        needchar (')');
        outbyte('\n');
        ns ();
}



/*
 *      "asm" pseudo-statement (for #asm/#endasm)
 *      enters mode where assembly language statement are
 *      passed intact through parser
 */


void doasm()
{
        char label[NAMEMAX];
        int     k;
        SYMBOL *myptr;
        endasm=cmode=0;                        /* mark mode as "asm" */

        while (1) {
                preprocess();   /* get and print lines */
                if ( endasm || match("#endasm") || eof )
                        break ;
                if ( output != NULL_FD ) {
                        if ( fputs(line, output) == -1 ) {
                                fabort() ;
                        }
                }
                else {
                        puts(line) ;
                }
                nl();
/* Added by djm to handle assembler being defined as externs...
   These will be XDEFed instead of XREFed */
                if (line[0] == '.')
                {
                        k=1;
                        while ((line[k] != ' ') && (line[k] != '\n')  && (line[k] != '\0') && (line[k] != '\t') )
                               {
                                label[k-1]=line[k];
                                k++;
                                }
                        label[k-1]='\0';
/* Got assembler label, check for smc_ prefix and remove it! */
                        if ( strncmp(label,"smc_",4)==0 ) 
                                        strcpy(label,label+4);


/* ATP Got assembler label, now check to see if defined as extern.. */
                        if ( (myptr=findglb(label)) )
                        {
/* Have matched it to an extern, so now change type... */
                                if (myptr->storage == EXTERNAL){
                                        myptr->storage = DECLEXTN;
                                }
                        }
                }
        }
        if (!endasm) clear() ;               /* invalidate line */
        if (eof) warning("Unterminated assembler code");
        cmode=1 ;               /* then back to parse level */
}

/* #pragma statement */


void dopragma()
{
        if ( amatch("proto") ) addmac() ;
        else if ( amatch("unproto") ) delmac() ;
        else if ( amatch("asm") ) doasm();
        else if ( amatch("endasm") ) endasm=1; 
        else {
               warning("Unknown #pragma statement");
               junk();
               vinline();
        }
}

