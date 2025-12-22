/* Scheme In One Define.
 
The garbage collector, the name and other parts of this program are

 *                     COPYRIGHT (c) 1989 BY                              *
 *      PARADIGM ASSOCIATES INCORPORATED, CAMBRIDGE, MASSACHUSETTS.       *

Conversion  to  full scheme standard, characters, vectors, ports, complex &
rational numbers, and other major enhancments by

 *      Scaglione Ermanno, v. Pirinoli 16 IMPERIA P.M. 18100 ITALY        * 

Permission  to use, copy, modify, distribute and sell this software and its
documentation  for  any purpose and without fee is hereby granted, provided
that  the  above  copyright  notice appear in all copies and that both that
copyright   notice   and   this  permission  notice  appear  in  supporting
documentation,  and that the name of Paradigm Associates Inc not be used in
advertising or publicity pertaining to distribution of the software without
specific, written prior permission.

PARADIGM  DISCLAIMS  ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL  IMPLIED  WARRANTIES  OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
PARADIGM  BE  LIABLE  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <setjmp.h>
#include <signal.h>
#include <math.h>

#include "siod.h"

void init_storage(void)
{LISP ptr,next,end;
 long j;
 heap = (LISP) must_malloc(sizeof(struct obj)*heap_size);
 heap_org = heap;
 heap_end = heap + heap_size;
 ptr = heap_org;
 end = heap_end;
 while(1)
   {(*ptr).type = tc_free_cell;
    next = ptr + 1;
    if (next < end)
     {CDR(ptr) = next;
      ptr = next;}
    else
     {CDR(ptr) = NIL;
      break;}}
 freelist = heap_org;
 chararray = (LISP *) must_malloc(sizeof(LISP) * 256);
 for(j=0;j<256;++j)
    chararray[j] = NIL;
 fixarray = (LISP *) must_malloc(sizeof(LISP) * fixarray_dim);
 for(j=0;j<fixarray_dim;++j)
    fixarray[j] = NIL;
 obarray = (LISP *) must_malloc(sizeof(LISP) * obarray_dim);
 for(j=0;j<obarray_dim;++j)
    obarray[j] = NIL;
 gc_protect_n(obarray,obarray_dim);
 unbound_marker = cons(cintern("**unbound-marker**"),NIL);
 gc_protect(&unbound_marker);
 sym_initial_environment = envcons(NIL,NIL);
 gc_protect(&sym_initial_environment);
 sym_user_environment = cons(cintern("user-global-environment"),NIL);
 gc_protect(&sym_user_environment);
 setv(cintern("user-global-environment"),
      sym_user_environment);
 setv(cintern("user-initial-environment"),
      sym_initial_environment);
 eof_val = cons(cintern("eof"),NIL);
 gc_protect(&sym_err_string);
 sym_err_string=strcons(128);
 strcpy(SNAME(sym_err_string),"no error");
 gc_protect(&eof_val);
 gc_protect(&sym_stdin);
 sym_stdin = portcons(stdin);
 PORTFLAG(sym_stdin)=1;
 gc_protect_sym(&sym_standard_input,"standard-input");
 setv(sym_standard_input,sym_stdin);
 gc_protect(&sym_stdout);
 sym_stdout = portcons(stdout);
 PORTFLAG(sym_stdout)=-1;
 gc_protect_sym(&sym_standard_output,"standard-output");
 setv(sym_standard_output,sym_stdout);
 gc_protect_sym(&sym_scheme_top_level,"scheme-top-level");
 gc_protect_sym(&sym_input_port,"input-port");
 gc_protect_sym(&sym_output_port,"output-port");
 val_scheme_top_level=cons(sym_scheme_top_level, 
                    subrcons(tc_subr_0, "scheme-top-level", scheme_top_level));
 val_input_port=cons(sym_input_port, sym_stdin);
 val_output_port=cons(sym_output_port,sym_stdout);
 gc_protect(&sym_fluid_environment);
 gc_protect_sym(&sym_the_non_printing,"*the-non-printing-object*");
 setv(sym_the_non_printing,sym_the_non_printing);
 gc_protect(&sym_inspect);
 gc_protect_sym(&sym_on_reset,"*on-reset*");
 setv(sym_on_reset,NIL);
 sym_inspect = cintern("inspect");
 sym_err_han = cintern("*error*");
 gc_protect_sym(&truth,"#t");
 setv(truth,truth);
 gc_protect(&sym_else);
 sym_else = cintern("else");
 if(full_set == 1)
  {setv(cintern("t"),truth);
   setv(cintern("true"),truth);
   setv(cintern("f"),NIL);
   setv(cintern("false"),NIL);
   setv(cintern("nil"),NIL);
   setv(cintern("pi"),floco(PI));}
 gc_protect_sym(&sym_debug_mode,"siod-debug-mode");
 setv(sym_debug_mode,quiet?NIL:truth);
 gc_protect_sym(&sym_gc_mode,"siod-gc-mode");
 setv(sym_gc_mode,quiet?NIL:truth);
 gc_protect_sym(&sym_repl_mode,"siod-repl-mode");
 setv(sym_repl_mode,quiet?NIL:truth);
 setv(cintern("*cargs*"),NIL);
 setv(cintern("*cenv*"),NIL);
 setv(cintern("*lasterr*"),sym_err_string);
 gc_protect_sym(&sym_errobj,"errobj");
 setv(sym_errobj,NIL);
 gc_protect_sym(&sym_progn,"begin");
 gc_protect_sym(&sym_lambda,"lambda");
 gc_protect_sym(&sym_quote,"quote");
 gc_protect_sym(&sym_dot,".");}

LISP user_gc(LISP args)
{long flag;
 flag = no_interrupt(1);
 errjmp_ok = 0;
 gc_mark_and_sweep();
 errjmp_ok = 1;
 no_interrupt(flag);
 return(NIL);}
 
LISP gc_status(LISP args)
{LISP l;
 FILE *f;
 long n,j,m,max,tmp;
 f=get_cur_out();
 fput_st(f,"SYSTEM:\n");
 fput_st(f,"	Garbage collection ");
 fput_st(f,(VCELL(sym_gc_mode)==truth) ? "verbose.\n":
                                         "silent.\n");
 fput_st(f,"	Debug mode is ");
 fput_st(f,(VCELL(sym_debug_mode)==truth) ? "on.\n":
                                            "off.\n");
 fput_st(f,"	Repl mode ");
 fput_st(f,(VCELL(sym_repl_mode)==truth) ? "verbose.\n":
                                           "silent.\n");
 fput_st(f,"	Transcript mode is ");
 fput_st(f,(transfile) ? "on.\n":
                         "off.\n");
 for(n=0,l=freelist;NNULLP(l); ++n) l = CDR(l);
 sprintf(tkbuffer,"	%ld cons allocated, %ld free.\n",
	           (heap_end - heap_org) - n,n);
 n=m=max=0;
 for(j=0;j<obarray_dim;++j)
    {tmp=leng(obarray[j]);
     if(max<tmp) max=tmp;
     n+=tmp;
     if(NULLP(obarray[j]))m++;}
 fput_st(f,"MEMORY:\n");
 fput_st(f,tkbuffer);
 fput_st(f,"SYMBOLS:\n");
 sprintf(tkbuffer,"	%ld symbols interned.\n",n);
 fput_st(f,tkbuffer);
 sprintf(tkbuffer,"	%ld symtab buckets used, %ld free.\n",obarray_dim-m,m);
 fput_st(f,tkbuffer);
 sprintf(tkbuffer,"	Max collision %ld, loading density %g.\n",max,(double)n/(double)obarray_dim);
 fput_st(f,tkbuffer);
 n=m=max=0;
 for(j=0;j<fixarray_dim;++j)
    {tmp=leng(fixarray[j]);
     if(max<tmp) max=tmp;
     n+=tmp;
     if(NULLP(fixarray[j]))m++;}
 fput_st(f,"INTEGERS:\n");
 sprintf(tkbuffer,"	%ld integers interned.\n",n);
 fput_st(f,tkbuffer);
 sprintf(tkbuffer,"	%ld fixtab buckets used, %ld free.\n",fixarray_dim-m,m);
 fput_st(f,tkbuffer);
 sprintf(tkbuffer,"	Max collision %ld, loading density %g.\n",max,(double)n/(double)fixarray_dim);
 fput_st(f,tkbuffer);
 n=0;
 for(j=0;j<256;++j)
    if(NNULLP(chararray[j])) n++;
 fput_st(f,"CHARACTERS:\n");
 sprintf(tkbuffer,"	%ld characters interned.\n",n);
 fput_st(f,tkbuffer);
 return(NIL);}

LISP freesp(void)
{LISP z,l;
 int n;
 for(n=0,l=freelist;NNULLP(l); ++n) l = CDR(l);
 z=flocons((double)n*sizeof(struct obj));
 return(z);}

void gc_protect(LISP *location)
{gc_protect_n(location,1);}

void gc_protect_n(LISP *location,long n)
{struct gc_protected *reg;
 reg = (struct gc_protected *) must_malloc(sizeof(struct gc_protected));
 (*reg).location = location;
 (*reg).length = n;
 (*reg).next = protected_registers;
  protected_registers = reg;}

void gc_protect_sym(LISP *location,char *st)
{*location = cintern(st);
 gc_protect(location);}
