/*
 *      Small C+ Compiler
 *
 *      Z80 Code Generator
 *
 *      $Id: codegen.c 1.6 1999/03/22 21:27:18 djm8 Exp $
 */


#include "ccdefs.h"


/*
 * From the Small-C Handbook:
 *
 * The compiler sees the CPU as consisting of two 16-bit registers: a
 * primary register and a secondary register. The primary register is 
 * the main accumulator of expression and subexpression values. When
 * a binary operation (like addition) is performed, the left hand 
 * operand is placed into secondary register and the right-hand operand 
 * is loaded into the primary register. The operation is performed and 
 * the result goes into the primary register. As it employees the 8080
 * CPU, the compiler uses the HL register pair pair for the primary 
 * register and DE for the secondary register.
 */

/* Sadly this beautiful theory goes out the window when we use longs!
 * In this case we use the alternate register sets of the Z80 to hold
 * the two ints. Some might say that this is a massive kludge, but just
 * wait till you can access the Z88s extended memory, now that *will*
 * be a kludge! :)
 *
 * Ooops, this is so out of data, now longs are held on the stack for
 * calls to library functions (makes things easier to handle), sometimes
 * alternate registers are used to handle one of the longs in return
 * (only for l_long_div though) - djm 29/2/99
 */


/* Begin a comment line for the assembler */

void comment(void)
{
        outbyte(';');
}

/* Put out assembler info before any code is generated */

void header(void)
{
        char file2[FILENAME_MAX];
        comment();      outstr(Banner);         nl();
        comment();      outstr(Version);        nl();
        comment();                              nl();
        outstr (";\tReconstructed for the z80 Module Assembler\n");
        outstr (";\tBy Dominic Morris <djm@jb.man.ac.uk>\n");
        if (doheader) {
                outstr ("\n\tMODULE\t");
                outstr(Filename);
                strcpy(file2,Filename);
                changesuffix(file2,".hdr");
                outstr("\n\n\tINCLUDE \"");
                outstr(file2);
                clear();
                outstr("\"\n\n\tINCLUDE \"#z88_crt0.hdr\"\n");
        } else {
/* 
 *      Print header suitable for use when creating libraries
 */
        outstr("\n;\tSmall C+ Library Function\n");

                strcpy(file2,Filename);
                changesuffix(file2,"");
                outstr("\n\tXLIB\t");
                outstr(file2);
                outstr("\n\n\tINCLUDE \"#z88_crt0.hdr\"\n");
        }
}


/* With the introduction of the startup module we don't need this
 * condition assembly
 *       outstr("\"\n\nIF NEED_startup\n");
 *       outstr("\torg\t$2300\n\n");
 *       outstr ("\tINCLUDE \"#z88_crt0.asm\"\n");
 *       outstr("ENDIF\n\n");
 *       outstr("IF !NEED_startup\n");
 *       outstr("\tINCLUDE \"#z88_crt0.hdr\"\n");
 *       outstr("ENDIF\n\n");
 */

/* Print any assembler stuff needed after all code */
void trailer(void)
{
        nl();
        outstr("; --- End of Compilation ---\n");
}

/* Print out a name such that it won't annoy the assembler
 *      (by matching anything reserved, like opcodes.)
 */
void outname(sname,pref)
char *sname;
char pref;
{
        int i ;

        if (pref) outstr("smc_");
        if ( strlen(sname) > ASMLEN ) {
                i = ASMLEN;
                while ( i-- )
                        outbyte(raise(*sname++));
        }
        else
                outstr(sname);
}

/* Fetch a static memory cell into the primary register */
/* Can only have directly accessible things here...so should be
 * able to just check for far to see if we need to pick up second
 * bit of long pointer (check for type POINTER as well...
 */
void getmem(sym)
SYMBOL *sym ;
{

        
        if( sym->ident != POINTER && sym->type == CCHAR ) {
                if (!(sym->flags&UNSIGNED)) {
                        ot("ld\ta,("); outname(sym->name,dopref(sym));
                        outstr(")\n");
                        callrts("l_sxt");
                } else {
/* Unsigned char - new method - allows more optimizations! */
                        ot("ld\thl,"); outname(sym->name,dopref(sym));
                        nl();
                        ol("ld\tl,(hl)");
                        ol("ld\th,0");
                }
#ifdef OLDLOADCHAR
                ot("ld\ta,("); outname(sym->name,dopref(sym));
                outstr(")\n");
                if (!(sym->flags&UNSIGNED))
                        callrts("l_sxt");
                else {
                        ol("ld\tl,a");
                        ol("ld\th,0");
                }
                
#endif
        }
        else if( sym->ident != POINTER && sym->type == DOUBLE ) {
                address(sym);
                callrts("dload");
        }
        else if (sym->ident !=POINTER && sym->type == LONG ) {
                ot("ld\thl,(");outname(sym->name,dopref(sym)); outstr(")\n");
                ot("ld\tde,(");outname(sym->name,dopref(sym)); outstr("+2)\n");
        }
        else {
/* this is for CINT and get pointer..will need to change! */
                ot("ld\thl,("); outname(sym->name,dopref(sym)); outstr(")\n");
/* For long pointers...load de with name+2, then d,0 */
                if (sym->type==CPTR || (sym->ident==POINTER && sym->flags&FARPTR)) { ot("ld\tde,("); outname(sym->name,dopref(sym)); outstr("+2)\n\tld\td,0\n"); }
        }
}

/* Fetch the address of the specified symbol
 * into the primary register, unfortunately all stack accesses
 * become long pointer bound, so we have to compensate for it by loading
 * de with 0...
 */
void getloc(sym, off)
SYMBOL *sym;
int off ;
{
                vconst(sym->offset.i - Zsp + off);
                ol("add\thl,sp");
}

/* Store the primary register into the specified */
/*      static memory cell */
void putmem(sym)
SYMBOL *sym;
{
        if( sym->ident != POINTER && sym->type == DOUBLE ) {
                address(sym);
                callrts("dstore");
        }
        else {
                if( sym->ident != POINTER && sym->type == CCHAR ) {
                        ol("ld\ta,l");
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),a\n");
                }
                else if (sym ->ident != POINTER && sym->type == LONG ) {
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),hl\n");
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("+2),de\n");
                }
                else if (sym->ident == POINTER && sym->flags&FARPTR) {
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),hl\n");
                        ol("ld\ta,e");
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("+2),a\n");
 
                } else {
                        ot("ld\t(");
                        outname(sym->name,dopref(sym)); outstr("),hl\n");
                }
        }
}

/* Store the specified object type in the primary register */
/*      at the address on the top of the stack */
void putstk(typeobj)
char typeobj;
{
        SYMBOL *ptr;
        char flags;
/* Store via long pointer... */
        ptr=retrstk(&flags);
        if ( (ptr && ptr->storage==FAR)  || flags&FARACC ) {
/* exx pop hl, pop de, exx */
                doexx(); mainpop(); zpop(); doexx();
                switch( typeobj ) {
                case DOUBLE:
                        callrts("lp_pdoub");
                        break;
                case CPTR :
                        callrts("lp_pptr");
                        break;
                case LONG :
                        callrts("lp_plong");
                        break;
                case CCHAR :
                        callrts("lp_pchar");
                        break;
                default:
                        callrts("lp_pint");
                }
                return;
        }

        switch ( typeobj ) {
        case DOUBLE :
                mainpop();
                callrts("dstore");
                break ;
        case CPTR :
                zpopbc();
                callrts("l_putptr");
                break;
        case LONG :
                zpopbc();
                callrts("l_plong");
                break ;
        case CCHAR :
                zpop();
                ol("ld\ta,l");
                ol("ld\t(de),a");
                break ; 
        default :
                zpop(); /* Put here to prevent horrendous problems! */
                if (doinline)
                {
                ol("ld\ta,l");
                ol("ld\t(de),a");
                ol("inc\tde");
                ol("ld\ta,h");
                ol("ld\t(de),a");
                }
                else callrts("l_pint");
/*                Zsp += 2 ; */
        }
}

/* store a two byte object in the primary register at TOS */
void puttos(void)
{
        ol("pop\tbc");
        ol("push\thl");
}

/* store a two byte object in the primary register at 2nd TOS */
void put2tos(void)
{
        ol("pop\tde");
        puttos();
        ol("push\tde");
}


/*
 * loadargc - load accumulator with number of args
 *            no special treatment of n==0, as this
 *            should never arise for printf etc.
 */
void loadargc(n)
int n;
{
        ot("ld\ta," ) ;
        outdec(n >> 1) ;
        nl();
}

/* Fetch the specified object type indirect through the */
/*      primary register into the primary register */
void indirect(typeobj,flags)
char typeobj;
char flags;
{
        char     sign;

/* djm 30/9/98 Twas here that was causing the GNU crash! */

  

        sign=flags&UNSIGNED;

/* Fetch from a long pointer.. 19/10/98 */
/* Adapted 18/11/98 so that will do this when we access via a far ptr */

        if (flags&FARACC) {             /* Access via far method */
                switch(typeobj) {
                case CCHAR :
                        callrts("lp_gchar");
                        if (!sign) callrts("l_sxt");
                        else ol("ld\th,0");
                        break;
                case CPTR:
                        callrts("lp_gptr");
                        break;
                case LONG:
                        callrts("lp_glong");
                        break;
                case DOUBLE:
                        callrts("lp_gdoub");
                        break;
                default:
                        callrts("lp_gint");
                }
                return;
                
        }

        switch ( typeobj ) {
        case CCHAR :
                if (!sign)
                        {
                        ol("ld\ta,(hl)");
                        callrts("l_sxt");
                        }
                else
                        {
                        ol("ld\tl,(hl)");
                        ol("ld\th,0");
                        }
                break ;
        case CPTR :
                callrts("l_getptr");
                break;
        case LONG :
                callrts("l_glong");
                break;
        case DOUBLE :
                callrts("dload");
                break ;
        default :
                if (doinline){
                ol("ld\ta,(hl)");
                ol("inc\thl");
                ol("ld\th,(hl)");
                ol("ld\tl,a");
                }
                else  callrts("l_gint");
        }
}

/* Swap the primary and secondary registers */
void swap(void)
{
        ol("ex\tde,hl");
}

/* Print partial instruction to get an immediate value */
/*      into the primary register */
void immed(void)
{
        ot("ld\thl,");
}

/* Print partial instruction to get an immediate value */
/*      into the secondary register */
void immed2(void)
{
        ot("ld\tde,");
}

/* Partial instruction to access literal */
void immedlit(lab)
int lab;
{
        immed();
        printlabel(lab);
        outbyte('+');
}


/* Push long onto stack */

void lpush(void)
{
        zpushde();
        zpush();
}

#ifndef SMALL_C
void
#endif
lpush2(void)
{
        callrts("lpush2");
        Zsp-=4;
}


/* Push secondary register/high work of long onto the stack */

#ifndef SMALL_C
void
#endif

zpushde(void)
{
        ol("push\tde");
        Zsp -= 2;
}

/* Push the primary register onto the stack */
#ifndef SMALL_C
void
#endif

zpush(void)
{
        ol("push\thl");
        Zsp -= 2;
}

/* Push the primary floating point register onto the stack */
#ifndef SMALL_C
void
#endif

dpush(void)
{
        callrts("dpush");
        Zsp -= 6;
}

/* Push the primary floating point register, preserving
        the top value  */
#ifndef SMALL_C
void
#endif

dpush2(void)
{
        callrts("dpush2");
        Zsp -= 6;
}

/* Pop the top of the stack into the primary register */
void mainpop(void)
{
        ol("pop\thl");
        Zsp += 2;
}

/* Pop the top of the stack into the secondary register */
void zpop(void)
{
        ol("pop\tde");
        Zsp += 2;
}

/* Pop top of stack into bc */

void zpopbc(void)
{
        ol("pop\tbc");
        Zsp += 2;
}

/* Swap between the sets of registers */

void doexx(void)
{
        ol("exx");
}


/* Swap the primary register and the top of the stack */
void swapstk(void)
{
        ol("ex\t(sp),hl");
}

/* process switch statement */
void sw(char type)
{
        if (type==LONG) callrts("l_long_case");
        else callrts("l_case");
}

/* Call the specified subroutine name */
void zcall(sname)
SYMBOL *sname;
{
        ot("call\t");
        outname(sname->name,dopref(sname));
        nl();
}

/* djm (move this!) Decide whether to print a prefix or not */

#ifndef SMALL_C
char
#endif
dopref(sym)
SYMBOL *sym;
{
        if (sym->ident != FUNCTION || (sym->ident == FUNCTION && sym->size!=1)) return(1);
        return(0);
}

/* Call a run-time library routine */
void callrts(sname)
char *sname;
{
        ot("call\t");
        outstr(sname);
        nl();
}


/* Return from subroutine */
void zret(void)
{
        ol("ret");
        nl();
        nl();
}

/*
 * Perform subroutine call to value on top of stack
 * Put arg count in A in case subroutine needs it
 */
void callstk(n)
int n;
{
        loadargc(n) ;
        callrts( "l_dcal" ) ;
}

/* Jump to specified internal label number */
void jump(label)
int label;
{
        ot("jp\t");
        printlabel(label);
        nl();
}

/* Test the primary register and jump if false to label */
void testjump(label)
int label;
{
        ol("ld\ta,h");
        ol("or\tl");
        if (opertype == LONG ) { ol("or\td"); ol("or\te"); }
        ot("jp\tz,");
        printlabel(label);
        nl();
}

/* test primary register against zero and jump if false */
void zerojump(oper, label, lval)
void (*oper)(int);
int label ;
LVALUE *lval ;
{
        clearstage(lval->stage_add, 0) ;                /* purge conventional code */
        (*oper)(label) ;
}

/* Print pseudo-op to define a byte */
void defbyte(void)
{
        ot("defb\t");
}

/*Print pseudo-op to define storage */
void defstorage(void)
{
        ot("defs\t");
}

/* Print pseudo-op to define a word */
void defword(void)
{
        ot("defw\t");
}

/* Print pseudo-op to dump a long */
void deflong(void)
{
        ot("defl\t");
}


/* Point to following object */
void point(void)
{
        ol("defw\tASMPC+2");
}

/* Modify the stack pointer to the new value indicated */
int modstk(newsp,save)
int newsp;
int save ;              /* if true preserve contents of HL */
{
        int k;

        k = newsp - Zsp ;
        if ( k == 0 ) return newsp ;
        if ( k > 0 ) {
                if ( k < 7 ) {
                        if ( k & 1 ) {
                                ol("inc\tsp") ;
                                --k ;
                        }
                        while ( k ) {
                                ol("pop\tbc");
                                k -= 2 ;
                        }
                        return newsp;
                }
        }
        if ( k < 0 ) {
                if ( k > -7 ) {
                        if ( k & 1 ) {
                                ol("dec\tsp") ;
                                ++k ;
                        }
                        while ( k ) {
                                ol("push\tbc");
                                k += 2 ;
                        }
                        return newsp;
                }
        }
/*
 * These doexx() where swap() but if we return a long then we've fubarred
 * up!
 */
        if ( save ) doexx() ;
        vconst(k) ;
        ol("add\thl,sp");
        ol("ld\tsp,hl");
        if ( save ) doexx() ;
        return newsp ;
}

/* Multiply the primary register by the length of some variable */
void scale(type, tag)
int type ;
TAG_SYMBOL *tag ;
{
        switch ( type ) {
        case CINT :
                doublereg() ;
                break ;
        case CPTR :
                threereg() ;
                break ;
        case LONG :
                doublereg();
                doublereg();
                break;
        case DOUBLE :
                sixreg() ;
                break ;
        case STRUCT :
                /* try to avoid multiplying if possible */
                quikmult(tag->size);
        }
}


void quikmult(int size)
{
                switch (size) {
                case 16 :
                        doublereg() ;
                case 8 :
                        doublereg() ;
                case 4 :
                        doublereg() ;
                case 2 :
                        doublereg() ;
                        break ;
                case 12 :
                        doublereg() ;
                case 6 :
                        sixreg() ;
                        break ;
                case 9 :
                        threereg() ;
                case 3 :
                        threereg() ;
                        break ;
                case 15 :
                        threereg() ;
                case 5 :
                        fivereg() ;
                        break ;
                case 10 :
                        fivereg() ;
                        doublereg() ;
                        break ;
                case 14 :
                        doublereg() ;
                case 7 :
                        sixreg() ;
                        addbc() ;       /* BC contains original value */
                        break ;
                default :
                        ol("push\tde") ;
                        const2(size) ;
                        mult() ;
                        ol("pop\tde") ;
                        break ;
                }
}

/* add BC to the primary register */
void addbc(void)
{
        ol("add\thl,bc") ;
}

/* load BC from the primary register */
void ldbc(void)
{
        ol("ld\tb,h") ;
        ol("ld\tc,l") ;
}

/* Double the primary register */
void doublereg(void)
{
        ol("add\thl,hl");
}

/* Multiply the primary register by three */
void threereg(void)
{
        ldbc() ;
        addbc() ;
        addbc() ;
}

/* Multiply the primary register by five */
void fivereg(void)
{
        ldbc() ;
        doublereg() ;
        doublereg() ;
        addbc() ;
}
        
/* Multiply the primary register by six */
void sixreg(void)
{
        threereg() ;
        doublereg() ;
}

/* Add the primary and secondary registers (result in primary) */
void zadd(void)
{
        if (opertype == LONG) { callrts("l_long_add"); Zsp += 4; }
        else ol("add\thl,de");
}

/* Add the primary floating point register to the
  value on the stack (under the return address)
  (result in primary) */
void dadd(void)
{
        callrts("dadd") ;
        Zsp += 6 ;
}

/* Subtract the primary register from the secondary */
/*      (results in primary) */
void zsub(void)
{
        if (opertype == LONG ) { callrts("l_long_sub"); Zsp += 4; }
        else callrts("l_sub");
}

/* Subtract the primary floating point register from the
  value on the stack (under the return address)
  (result in primary) */
void dsub(void)
{
        callrts("dsub"); Zsp += 6;
}

/* Multiply the primary and secondary registers */
/*      (results in primary */
void mult(void)
{
        if (opertype == LONG ) { callrts("l_long_mult"); Zsp +=4; }
        else callrts("l_mult");
}

/* Multiply the primary floating point register by the value
  on the stack (under the return address)
  (result in primary) */
void dmul(void)
{
        callrts("dmul"); Zsp += 6;
}

/* Divide the secondary register by the primary */
/*      (quotient in primary, remainder in secondary) */
void zdiv(void)
{
        if (opertype == LONG ) { callrts("l_long_div"); Zsp +=4; }
        else callrts("l_div");
}

/* Division - unsigned... */

void zdivun(void)
{
        if (opertype == LONG ) { callrts("l_long_div_u"); Zsp +=4; }
        else callrts("l_div_u");
}


/* Divide the value on the stack (under the return address)
  by the primary floating point register (quotient in primary) */
void ddiv(void)
{
        callrts("ddiv"); Zsp += 6;
}

/* Compute remainder (mod) of secondary register divided
 *      by the primary
 *      (remainder in primary, quotient in secondary)
 */
void zmod(void)
{
        if (opertype == LONG ) { callrts("l_long_div"); doexx(); Zsp +=4; }
        else { zdiv(); swap(); }
}

/* Unsigned modulus */

void zmodun(void)
{
        if (opertype == LONG ) { callrts("l_long_div_u"); doexx(); Zsp +=4; }
        else { callrts("l_div_u"); swap(); }
}

/* Inclusive 'or' the primary and secondary */
/*      (results in primary) */
void zor(void)
{
        if (opertype == LONG) { callrts("l_long_or"); Zsp += 4; }
        else callrts("l_or");
}

/* Exclusive 'or' the primary and secondary */
/*      (results in primary) */
void zxor(void)
{
        if (opertype == LONG) { callrts("l_long_xor"); Zsp += 4; }
        else callrts("l_xor");
}

/* 'And' the primary and secondary */
/*      (results in primary) */
void zand(void)
{
        if (opertype == LONG) { callrts("l_long_and"); Zsp += 4; }
        else callrts("l_and");
}

/* Arithmetic shift right the secondary register number of */
/*      times in primary (results in primary) */
void asr(void)
{
        if (opertype == LONG) { callrts("l_long_asr"); Zsp += 4; }
        else callrts("l_asr");
}

/* Arithmetic shift right the secondary by primary - unsigned */

void asr_un(void)
{
        if (opertype == LONG) { callrts("l_long_asr_u"); Zsp += 4; }
        else callrts("l_asr_u");
}



/* Arithmetic left shift the secondary register number of */
/*      times in primary (results in primary) */
void asl(void)
{
        if (opertype == LONG) { callrts("l_long_asl"); Zsp += 4; }
        else callrts("l_asl");
}

/* Form logical negation of primary register */
void lneg(void)
{
        if (opertype == LONG) callrts("l_long_lneg");
        else callrts("l_lneg");
}

/* Form two's complement of primary register */
void neg(void)
{
        if (opertype == LONG) callrts("l_long_neg"); 
        else callrts("l_neg");
}

/* Negate the primary floating point register */
void dneg(void)
{
        callrts("minusfa");
}

/* Form one's complement of primary register */
void com(void)
{
        if (opertype == LONG) callrts("l_long_com");
        else callrts("l_com");
}

void inclong(void)
{
        callrts("l_inclong");
}

void declong(void)
{
        callrts("l_declong");
}


/* Increment the primary register by one */
void inc(void)
{
        ol("inc\thl");
}

/* Decrement the primary register by one */
void dec(void)
{
        ol("dec\thl");
}

/* Following are the conditional operators */
/* They compare the secondary register against the primary */
/* and put a literal 1 in the primary if the condition is */
/* true, otherwise they clear the primary register */

/* Test for equal */
void zeq(void)
{
        if (opertype==LONG) { callrts("l_long_eq"); Zsp += 4; opertype=CINT; }
        else callrts("l_eq");
}

/* test for equal to zero */
void eq0(label)
int label ;
{
        ol("ld\ta,h");
        ol("or\tl");
        if (opertype==LONG) { ol("or\td"); ol("or\te"); }
        ot("jp\tnz,");
        printlabel(label) ;
        nl();
}

/* Test for not equal */
void zne(void)
{
        if (opertype==LONG) { callrts("l_long_ne");  Zsp += 4; opertype=CINT; }
        else callrts("l_ne");
}

/* Test for less than (signed) */
void zlt(void)
{
        if (opertype==LONG) { callrts("l_long_lt");  Zsp += 4; opertype=CINT; }
        else callrts("l_lt");
}

/* Test for less than zero */
void lt0(label)
int label ;
{
        ol("xor\ta") ;
        if (opertype==LONG) ol("or\td");
        else ol("or\th") ;
        ot("jp\tp,") ;
        printlabel(label) ;
        nl() ;
}

/* Test for less than or equal to (signed) */
void zle(void)
{
        if (opertype==LONG) { callrts("l_long_le"); Zsp += 4; opertype=CINT; }
        else callrts("l_le");
}

/* Test for less than or equal to zero */
void le0(label)
int label ;
{
        ol("ld\ta,h") ;
        ol("or\tl");
        if (opertype==LONG) { ol("or\td"); ol("or\te"); }
        ol("jr\tz,ASMPC+7");
        lt0(label);
}

/* Test for greater than (signed) */
void zgt(void)
{
        if (opertype==LONG) { callrts("l_long_gt");  Zsp += 4; opertype=CINT; }
        else callrts("l_gt");
}

/* test for greater than zero */
void gt0(label)
int label ;
{
        ge0(label) ;
        ol("or\tl");
        ot("jp\tz,");
        printlabel(label);
        nl();
}

/* Test for greater than or equal to (signed) */
void zge(void)
{
        if (opertype==LONG) { callrts("l_long_ge");  Zsp += 4; opertype=CINT; }
        else callrts("l_ge");
}

/* test for greater than or equal to zero */
void ge0(label)
int label ;
{
        ol("xor\ta") ;
        if (opertype==LONG) ol("or\td");
        else ol("or\th");
        ot("jp\tm,");
        printlabel(label);
        nl();
}

/* Test for less than (unsigned) */
void ult(void)
{
        if (opertype==LONG) { callrts("l_long_ult");  Zsp += 4; opertype=CINT;  }
        else callrts("l_ult");
}

/* Test for less than or equal to (unsigned) */
void ule(void)
{
        if (opertype==LONG) { callrts("l_long_ule");  Zsp += 4; opertype=CINT; }
        else callrts("l_ule");
}

/* Test for greater than (unsigned) */
void ugt(void)
{
        if (opertype==LONG) { callrts("l_long_ugt");  Zsp += 4; opertype=CINT; }
        else callrts("l_ugt");
}

/* Test for greater than or equal to (unsigned) */
void uge(void)
{
        if (opertype==LONG) { callrts("l_long_uge"); Zsp += 4; opertype=CINT; }
        else callrts("l_uge");
}

/* The following conditional operations compare the
   top of the stack (TOS) against the primary floating point
   register (FA), resulting in 1 if true and 0 if false */

/* Test for floating equal */
void deq(void)
{
        callrts("deq"); Zsp += 6;
}

/* Test for floating not equal */
void dne(void)
{
        callrts("dne"); Zsp += 6;
}

/* Test for floating less than   (that is, TOS < FA)    */
void dlt(void)
{
        callrts("dlt"); Zsp += 6;
}

/* Test for floating less than or equal to */
/* djm changed to dleq to avoid clash with cntlchar.def */
void dle(void)
{
        callrts("dleq"); Zsp += 6;
}

/* Test for floating greater than */
void dgt(void)
{
        callrts("dgt"); Zsp += 6;
}

/* Test for floating greater than or equal */
void dge(void)
{
        callrts("dge"); Zsp += 6;
}

/*      <<<<<  End of Small-C/Plus compiler  >>>>>      */
