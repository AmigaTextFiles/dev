#include "lispbibl.c"

#undef S
#undef local
#include <vcode.h>

typedef enum 
  {
    #define BYTECODE(code)  code,
    #include "bytecode.c"
    #undef BYTECODE
    cod_for_broken_compilers_that_dont_like_trailing_commas
  } bytecode_enum;


#define CASE(cod) \
 case cod: \
 asciz_out(STRINGIFY(cod)); \
 asciz_out("("); \
 dez_out(cod); \
 asciz_out(")\n");

static unsigned ibuffer;

struct v_reg reg_value1;
struct v_reg reg_mv_count;
struct v_reg reg_STACK;

struct v_reg reg_temp;
struct v_reg reg_temp2;

#define LABEL_MAX 1024
struct v_label label_vec[LABEL_MAX];

local setup_vcode()
  {
    reg_value1 = v_sym_to_phys(value1_register);
    reg_STACK = v_sym_to_phys(STACK_register);
    reg_mv_count = v_sym_to_phys(mv_count_register);
    reg_SP = v_sum_to_phys(SP_register);
    v_chg_rclass(V_UNAVAIL, V_P, V_R(reg_value1));
    v_chg_rclass(V_UNAVAIL, V_P, V_R(reg_STACK));
    v_chg_rclass(V_UNAVAIL, V_P, V_R(reg_SP));
    v_chg_rclass(V_UNAVAIL, V_I, V_R(reg_mv_count));
    v_getreg(&reg_temp, V_P, V_TEMP);
    v_getreg(&reg_temp2, V_P, V_TEMP);
  }

#ifdef STACK_DOWN
  #define ST_off(n) (((sintP)(n))*sizeof(object*))
  #define V_skipSTACK(offset) addpi(reg_STACK,reg_STACK,(sintP)(offset)*sizeof(object*))
#else
  #define ST_off(n) ((-1-(sintP)(n))*sizeof(object*))
  #define V_skipSTACK(offset) subpi(reg_STACK,reg_STACK,(sintP)(offset)*sizeof(object*))
#endif
#define V_STACK(reg,offset) v_ldpi(reg,reg_STACK,SToff(offset))
#define FR_off(n) SToff(n)

#ifdef SP_DOWN
  #define SP_off(n) (((uintP)(n))*sizeof(object*))
  #define V_skipSP(offset) addpi(reg_SP,reg_SP,(uintP)(offset)*sizeof(SPint))
#else
  #define SP_off(n) ((-1-(uintP)(n))*sizeof(object*))
  #define V_skipSP(offset) subpi(reg_SP,reg_SP,(uintP)(offset)*sizeof(SPint))
#endif
#define V_SP_PTR(reg,offset) v_addpi(reg,reg_SP,SP_off(offset))
#define P_off(x) ((x)*sizeof(object*))

#define operand_0() (posfixnum_to_L(Car(Cdr(code))))
#define operand_1() (posfixnum_to_L(Car(Cdr(Cdr(code)))))
#define operand_2() (posfixnum_to_L(Car(Cdr(Cdr(Cdr(code))))))

#define MV_COUNT_1()  v_setp(reg_mv_count,1)

local void V_reg_const (object closure,struct v_reg reg,uintL n);
local void V_reg_const(closure,reg,n)
  var object closure;
  var struct v_reg reg;
  var uintL n;
  { v_setp(reg,TheCclosure(closure)->clos_consts[n]); }

local void V_reg_pushSP(struct v_reg reg);
local void V_reg_pushSP(reg)
  var struct v_reg reg;
  {
    V_SP_PTR(reg_sp,-1);
    v_stpi(reg_sp,reg,0);
  }

local void V_reg_popSP(struct v_reg reg);
local void V_reg_popSP(reg)
  var struct v_reg reg;
  {
    V_SP_PTR(reg,sp,0);
    v_ldpi(reg,reg_sp,0);
  }

local void V_reg_pushSTACK (struct v_reg reg);
local void V_reg_pushSTACK(reg)
  var struct v_reg reg;
  {
    v_addpi(reg_temp2,reg_STACK,SToff(-1));
    v_stpi(reg_temp2,reg,0);
  }

local void V_reg_popSTACK (struct v_reg reg);
local void V_reg_popSTACK(reg)
  var struct v_reg reg;
  {
    V_STACK(reg,0);
    V_skipSTACK(1);
  }

local void V_setSTACK (int offset,object val);
local void V_setSTACK(offset,val)
  var int offset;
  var object val;
  {
    v_addpi(reg_temp2,reg_STACK,SToff(offset));
    v_setp(reg_temp,val);
    v_stpi(reg_temp2,reg_temp,0);
  }

local void V_pushSTACK (object val);
local void V_pushSTACK(val)
  var object val;
  {
    V_setSTACK(-1,val);
    V_skipSTACK(-1);
  }

local void V_push_Symbol_value (object symbol);
local void V_push_Symbol_value(symbol)
  var object symbol;
  {
    v_setp(reg_temp,symbol);
    v_ldpi(reg_temp,reg_temp,offsetof(Symbol,symvalue));
    v_addpi(reg_temp2,reg_STACK,SToff(-1));
    v_stpi(reg_temp2,reg_temp,0);
    V_skipSTACK(-1);
  }

local void set_value1 (object val);
local void set_value1(val)
  var object val;
  {
    v_setp(reg_value1,val);
    MV_COUNT_1();
  }


local dynamic_frame (object STACKptr);
local dynamic_frame(STACKptr)
  {
    return framebottomword(DYNBIND_frame_info,STACKptr);
  }

local V_push_dynamic_frame (struct v_reg top_of_frame)
local V_push_dynamic_frame(top_of_frame)
  var struct v_reg top_of_frame;
  { 
    struct v_reg reg_ret;
    reg_ret = v_scallv((v_vptr)dynamic_frame,"%p",top_of_frame);
    v_addpi(reg_temp2,reg_STACK,SToff(-1));
    v_stpi(reg_temp2,reg_temp,0);
    V_skipSTACK(-1);
  }

local fehler_STACK_putt (object closure);
local fehler_STACK_putt(closure)
  var object closure;
  {
    pushSTACK(closure);
    //: DEUTSCH "Stack kaputt in ~"
    //: ENGLISH "Corrupted STACK in ~"
    //: FRANCAIS "Pile STACK corrompue dans ~"
    fehler(serious_condition, GETTEXT("Corrupted STACK in ~"));
  }

local unbind1 (void);
local unbind1()
  {
    #if STACKCHECKC
    if (!(mtypecode(STACK_0) == DYNBIND_frame_info))
      fehler_STACK_putt();
    #endif
    # Variablenbindungsframe auflösen:
    { # Pointer übern Frame
      var reg7 object* new_STACK = topofframe(STACK_0);
      var reg4 object* frame_end = STACKpointable(new_STACK);
      var reg2 object* bindingptr = &STACK_1; # Beginn der Bindungen
      # bindingptr läuft durch die Bindungen hoch
      until (bindingptr == frame_end)
        { # alten Wert zurückschreiben:
          set_Symbol_value(*(bindingptr STACKop 0),*(bindingptr STACKop 1));
          bindingptr skipSTACKop 2; # nächste Bindung
        }
      # STACK neu setzen, dadurch Frame auflösen:
      setSTACK(STACK = new_STACK);
    }
  }

local void unbind (void);
local void unbind()
  { var reg8 uintC n;
    U_operand(n); # n>0
      {var reg2 object* FRAME = STACK;
       do {
         #if STACKCHECKC
         if (!(mtypecode(FRAME_(0)) == DYNBIND_frame_info))
           goto fehler_STACK_putt;
         #endif
         # Variablenbindungsframe auflösen:
         { var reg7 object* new_FRAME = topofframe(FRAME_(0)); # Pointer übern Frame
             var reg4 object* frame_end = STACKpointable(new_FRAME);
           var reg2 object* bindingptr = &FRAME_(1); # Beginn der Bindungen
           # bindingptr läuft durch die Bindungen hoch
           until (bindingptr == frame_end)
             { # alten Wert zurückschreiben:
               set_Symbol_value(*(bindingptr STACKop 0),*(bindingptr STACKop 1));
               bindingptr skipSTACKop 2; # nächste Bindung
             }
           FRAME = new_FRAME;
        }}
       until (--n == 0);
       # STACK neu setzen
       setSTACK(STACK = FRAME);
     }
  }

local boolean _atomp (object obj);
local boolean _atomp(obj)
  var object obj;
  { return atomp(obj); }

local boolean _consp (object obj);
local boolean _consp(obj)
  var object obj;
  { return consp(obj); }

local boolean _eq (object obj1,object obj2);
local boolean _eq (obj1,obj2)
  { return eq(obj1,obj2); }

local object loadv (object closure,uintC k,uintL m);
local object loadv(closure,k,m)
  var object closure;
  var uintC k;
  var uintL m;
  { var reg3 uintC k = operand_0();
    var reg2 uintL m = operand_1;
    { var reg1 object venv = TheCclosure(closure)->clos_venv;
      dotimesC(k,k, { venv = TheSvector(venv)->data[0]; });
      return TheSVector(venv)->data[m];
    }
  }

local void *storev_adr (object closure,uintC k,uintL m);
local void *storev_adr(closure,k,m)
  var object closure;
  var uintC k;
  var uintL m;
  { var reg3 object venv = TheCclosure(closure)->clos_venv;
    dotimesC(k,k, { venv = TheSvector(venv)->data[0]; } );
    return &TheSvector(venv)->data[m];
  }

local void *const_symbol_value_adr (uintL k);
local void *const_symbol_value_adr(k)
  var uintL k;
  { var reg3 object symbol = const_0();
    return &Symbol_value(symbol);
  }

local void *assign_const_symbol_value_adr (uintL k);
local void *assign_const_symbol_value_adr(k)
  var uintL k;
  { var reg3 object symbol = const_0();
    if (constantp(TheSymbol(symbol)) && noassign)
      { pushSTACK(symbol);
        //: DEUTSCH "Zuweisung nicht möglich auf das konstante Symbol ~"
        //: ENGLISH "assignment to constant symbol ~ is impossible"
        //: FRANCAIS "Une assignation du symbôle constant ~ n'est pas possible."
        fehler(error, GETTEXT("assignment to constant symbol ~ is impossible"));
      }
    return &Symbol_value(symbol);
  }

local uintL lookup_label_index (object code_vector,object label_sym);
local uintL lookup_label_index(code_data_vector,label_sym)
  var object code_vector;     
  var object label_sym;
  {
    var reg1 object *code_data_vector;
    var reg2 uintL label_index;
    var reg3 uintL i;
    var reg4 uintL code_count;

    code_count = TheSvector(code_vector)->length;
    code_data_vector = &TheSvector(code_vector)->data[0];
    label_index=0;
    for (i=0;i<code_count;i++)
      { if (eq(label_sym,code_data_vector[i])) return label_index;
        if (symbolp(code_data_vector[i])) label_index++;
      }
    pushSTACK(label_sym);
    //: DEUTSCH "Label ~ not found"
    //: ENGLISH "Label ~ not found"
    //: FRANCAIS "Label ~ not found"
    fehler(error,GETTEXT("Label ~ not found"));
  }

local v_label lookup_label (object code_vector,object labelsym);
local v_label lookup_label(code_vector,labelsym)
  var object labelsym;
  { return label_vec[lookup_label_index(code_vector,labelsym)]; }


v_label label_for_jmphash (object closure,object code_vector,uintL code_pos,uintL const_n,object key)
v_label label_for_jmphash (closure,code_data_vector,code_pos,const_n,key)
  var object closure;
  var object code_vector;
  var uintL code_pos;
  var uintL const_n;
  var object key;
  { 
    var reg1 object hashvalue = gethash(key,TheCclosure(closure)->clos_consts[const_n]);
    var reg2 object *code_data_vector = &TheSvector(code_vector)->data[0];
    var reg3 object code = code_data_vector[code_pos];
    var reg4 object nohash_sym = Cdr(Cdr(code));
    
    if (eq(hashvalue,nullobj))
      return lookup_label(nohash_sym);
    code_pos += fixnum_to_L(hashvalue);
    code = code_data_vector[code_pos];
    return lookup_code_data_vector[code];
  }

v_label label_for_jmphashv (object closure,object code_vector,uintL code_pos,uintL vec_n,object key);
v_label label_for_jmphashv(closure,code_data_vector,code_pos,vec_n,key)
  var object closure;
  var object code_vector;
  var uintL code_pos;
  var uintL vec_n;
  var object key;
  { 
    var reg1 object hashvalue = gethash(key,TheCclosure(closure)->clos_consts[0]->data[n]);
    var reg2 object *code_data_vector = &TheSvector(code_vector)->data[0];
    var reg3 object code = code_data_vector[code_pos];
    var reg4 object nohash_sym = Car(Cdr(Cdr(code)));
    
    if (eq(hashvalue,nullobj))
      return lookup_label(nohash_sym);
    code_pos += fixnum_to_L(hashvalue);
    code = code_data_vector[code_pos];
    return lookup_code_data_vector[code];
  }

local v_label jmptail (object code,uintL m,uintL n);
local v_label jmptail(labelsym,m,n)
  var object labelsym;
  var uintL m;
  var uintL n;
  {
    # Es gilt n>=m. m Stackeinträge um n-m nach oben kopieren:
    var reg4 object* ptr1 = STACK STACKop m;
    var reg2 object* ptr2 = STACK STACKop n;
    var reg6 uintC count;
    dotimesC(count,m, { NEXT(ptr2) = NEXT(ptr1); } );
    # Nun ist ptr1 = STACK und ptr2 = STACK STACKop (n-m).
    # *(closureptr = &NEXT(ptr2)) = closure; # Closure im Stack ablegen
    setSTACK(STACK = ptr2); # STACK verkürzen
    return lookup_label(labelsym);
  }

local void make_vector1_push (uintL n,object val);
local void make_vector1_push(n,val)
  var uintL n;
  var object val;
  {
    var object vec;
    pushSTACK(val);
    vec = allocate_vector(n+1);
    TheSvector(vec)->data[0]=STACK_0;
    STACK_0 = vec;
  }

local void copy_closure (object closure,uintL m,uintL n);
local void copy_closure(closure,m,n)
  var object closure;
  var uintL m;
  var uintL n;
  { var reg9 object old;
    # zu kopierende Closure holen:
    old = TheCclosure(closure)->clos_consts[m];
    # Closure gleicher Länge allozieren:
    {var reg8 object new;
     pushSTACK(old);
     new = allocate_srecord(0,Rectype_Closure,TheCclosure(old)->reclength,closure_type);
     old = popSTACK();
     # Inhalt der alten in die neue Closure kopieren:
     { var reg2 object* newptr = &((Srecord)TheCclosure(new))->recdata[0];
       var reg4 object* oldptr = &((Srecord)TheCclosure(old))->recdata[0];
       var reg6 uintC count;
       dotimespC(count,((Srecord)TheCclosure(old))->reclength,
                 { *newptr++ = *oldptr++; }
                 );
     }
     # Stackinhalt in die neue Closure kopieren:
     {var reg2 object* newptr = &TheCclosure(new)->clos_consts[n];
      dotimespL(n,n, { *--newptr = popSTACK(); } );
     }
     return new;
   }}

local void callfunc (object closure,uintL k,uintL n);
local void callfunc(k,n)
  var object closure;
  var uintL k;
  var uintL n;
  {  
    funcall(TheCclosure(closure)->clos_consts[n],k);
  }

extern Subr FUNTAB[];

local void callfunc_tab1 (uintL n);
local void callfunc_tab1(n)
  var uintL n;
  { 
    #define FUNTAB1  (&FUNTAB[0])
    var Subr fun = FUNTAB1[n];
    subr_self = subr_tab_ptr_as_object(fun);
    (*(subr_norest_function*)(fun->function))();
  }

local void callfunc_tab2 (uintL n);
local void callfunc_tab2(n)
  var uintL n;
  { 
    #define FUNTAB2  (&FUNTAB[256])
    var Subr fun = FUNTAB2[n];
    subr_self = subr_tab_ptr_as_object(fun);
    (*(subr_norest_function*)(fun->function))();
  }

local void callfunc_tabr (uintL m,uintL n);
local void callfunc_tabr(m,n)
  var uintL m;
  var uintL n;
  { 
    var Subr fun = FUNTABR[n];
    subr_self = subr_tab_ptr_as_object(fun);
    (*(subr_norest_function*)(fun->function))(m,args_end_pointer STACKop m);
  }

local void do_funcall (uintL n);
local void do_funcall(n)
  var uintL n;
  {
    funcall(STACK_(n),n);
    skipSTACK(1);
  }

local void do_apply (uintL n);
local void do_apply(n)
  var uintL n;
  {
    funcall(STACK_(n),n,value1);
    skipSTACK(1);
  }

local void push_unbound (uintC n);
local void push_unbound(n)
  var uintC n;
  { dotimesC(n,n, { pushSTACK(unbound); } ); }

local void unlist (uintC n,uintC m,object l);
local void unlist(n,m,val)
  var uintC n;
  var uintC m;
  var object l;
  {
    if (n > 0)
      do { if (atomp(l)) goto unlist_unbound;
           pushSTACK(Car(l)); l = Cdr(l);
         }
    until (--n == 0);
    if (atomp(l))
      goto next_byte;
    else
      fehler_apply_zuviel(S(lambda));
  unlist_unbound:
    if (n > m) fehler_apply_zuwenig(S(lambda));
    do { pushSTACK(unbound); } until (--n == 0);
  }

local void unlistern (uintC n,uintC m,object l);
local void unlistern(n,m,l)
  var uintC n;
  var uintC m;
  var object l;
  {
    do { if (atomp(l)) goto unliststern_unbound;
         pushSTACK(Car(l)); l = Cdr(l);
       }
    until (--n == 0);
    pushSTACK(l);
    goto next_byte;
  unliststern_unbound:
    if (n > m) fehler_apply_zuwenig(S(lambda));
    do { pushSTACK(unbound); } until (--n == 0);
    pushSTACK(NIL);
  }

local void fehler_zuviele_werte (void);
local void fehler_zuviele_werte()
  {
    //: DEUTSCH "Zu viele Werte erzeugt."
    //: ENGLISH "too many return values"
    //: FRANCAIS "Trop de valeurs VALUES."
    fehler(error, GETTEXT("too many return values"));
  }

local void _STACK_to_mv (uintL n);
local void _STACK_to_mv(n)
  { 
    if (n >= mv_limit) fehler_zuviele_werte();
    STACK_to_mv(n);
  }

local void nv_to_STACK (uintL n);
local void nv_to_STACK(n)
  var uintL n;
  {
    # Test auf Stacküberlauf:
    get_space_on_STACK(n*sizeof(object));
    # n Werte in den Stack schieben:
    {var reg7 uintC count = mv_count;
     if (n==0) goto nv_to_stack_end; # kein Wert gewünscht -> fertig
     # mindestens 1 Wert gewünscht
     pushSTACK(value1);
     n--; if (n==0) goto nv_to_stack_end; # nur 1 Wert gewünscht -> fertig
     if (count<=1) goto nv_to_stack_fill; # nur 1 Wert vorhanden -> mit NILs auffüllen
     count--;
     # mindestens 2 Werte gewünscht und vorhanden
     { var reg2 object* mvp = &mv_space[1];
       loop
         { pushSTACK(*mvp++);
           n--; if (n==0) goto nv_to_stack_end; # kein Wert mehr gewünscht -> fertig
           count--; if (count==0) goto nv_to_stack_fill; # kein Wert mehr vorhanden -> mit NILs auffüllen
     }   }
     nv_to_stack_fill: # Auffüllen mit n>0 NILs als zusätzlichen Werten:
     dotimespL(n,n, { pushSTACK(NIL); } );
     nv_to_stack_end: ;
   }}

local void _mv_to_list (void);
local void _mv_to_list()
  { mv_to_list(); 
    value1 = popSTACK();
    mv_count=1;
  }

local void _list_to_mv ();
local void _list_to_mv()
  { list_to_mv(value1, { fehler_zuviele_werte(); }); }

local void mvcall (void);
local void mvcall()
  { var reg2 object* FRAME; popSP( FRAME = (object*) ); # Pointer über Argumente und Funktion
    var reg7 object fun = NEXT(FRAME); # Funktion
    var reg4 uintL argcount = # Anzahl der Argumente auf dem Stack
    STACK_item_count(STACK,FRAME);
    if (((uintL)~(uintL)0 > ca_limit_1) && (argcount > ca_limit_1))
      { pushSTACK(fun);
        pushSTACK(S(multiple_value_call));
        //: DEUTSCH "~: Zu viele Argumente für ~"
        //: ENGLISH "~: too many arguments given to ~"
        //: FRANCAIS "~: Trop d'arguments pour ~"
        fehler(error, GETTEXT("~: too many arguments given to ~"));
      }
    # Funktion anwenden, Stack anheben bis unter die Funktion:
    funcall(fun,argcount);
    skipSTACK(1); # Funktion aus dem STACK streichen
  }

local block_open (uintL n,sintL label_dist,uintL index);
local block_open(n,label_dist)
  var uintL n;
  var sintL label_dist;
  var uintL index;
  {
    # belegt 3 STACK-Einträge und 1 SP-jmp_buf-Eintrag und 2 SP-Einträge
    # Block_Cons erzeugen:
    {var reg2 object block_cons;
     with_saved_context(
                        block_cons = allocate_cons();
                        label_dist += index; # CODEPTR+label_dist ist das Sprungziel
                        );
     # Block-Cons füllen: (CONST n) als CAR
     Car(block_cons) = TheCclosure(closure)->clos_consts[n];
     # Sprungziel in den SP:
     pushSP(label_dist); pushSP((aint)closureptr);
     # CBLOCK-Frame aufbauen:
     { var reg7 object* top_of_frame = STACK; # Pointer übern Frame
       pushSTACK(block_cons); # Cons ( (CONST n) . ...)
       {var reg4 JMPBUF_on_SP(returner); # Rücksprungpunkt merken
        finish_entry_frame_1(CBLOCK,returner, goto block_return; );
     } }
     # Framepointer im Block-Cons ablegen:
     Cdr(block_cons) = make_framepointer(STACK);
   }
   return;
   block_return: # Hierher wird gesprungen, wenn der oben aufgebaute
   # CBLOCK-Frame ein RETURN-FROM gefangen hat.
   { FREE_JMPBUF_on_SP();
     skipSTACK(2); # CBLOCK-Frame auflösen, dabei
     Cdr(popSTACK()) = disabled; # Block-Cons als Disabled markieren
     {var reg2 uintL index;
      # closure zurück, byteptr:=label_byteptr :
      popSP(closureptr = (object*) ); popSP(index = );
      closure = *closureptr; # Closure aus dem Stack holen
      codeptr = TheSbvector(TheCclosure(closure)->clos_codevec);
      byteptr = CODEPTR + index;
   } }
  }

local void block_close (void);
local void block_close()
  {
    # CBLOCK-Frame auflösen:
    #if STACKCHECKC
    if (!(mtypecode(STACK_0) == CBLOCK_frame_info))
      goto fehler_STACK_putt;
    #endif
    { FREE_JMPBUF_on_SP();
      skipSTACK(2); # CBLOCK-Frame auflösen, dabei
      Cdr(popSTACK()) = disabled; # Block-Cons als Disabled markieren
      skipSP(2); # Ziel-Closureptr und Ziel-Label kennen wir
    }
  }

local void return_from (uintL n);
local void return_from(n)
  var uintL n;
  {var reg2 object block_cons = TheCclosure(closure)->clos_consts[n];
   if (eq(Cdr(block_cons),disabled))
     { fehler_block_left(Car(block_cons)); }
   # Bis zum Block-Frame unwinden, dann seine Routine zum Auflösen anspringen:
   #ifndef FAST_SP
   FREE_DYNAMIC_ARRAY(private_SP_space);
   #endif
   unwind_upto(uTheFramepointer(Cdr(block_cons)));
  }

local void return_from_i (uintL k,uintL n);
local void return_from_i(k,n)
  {var reg2 object* FRAME = (object*) SP_(k);
   var reg2 object block_cons = FRAME_(n);
   if (eq(Cdr(block_cons),disabled))
     { fehler_block_left(Car(block_cons)); }
   # Bis zum Block-Frame unwinden, dann seine Routine zum Auflösen anspringen:
   #ifndef FAST_SP
   FREE_DYNAMIC_ARRAY(private_SP_space);
   #endif
   unwind_upto(uTheFramepointer(Cdr(block_cons)));
  }

local void tagbody_open (object closure,uintL n);
local void tagbody_open(closure,n)
  var object closure;
  var uintL n;
  {
    # belegt 3+m STACK-Einträge und 1 SP-jmp_buf-Eintrag und 1 SP-Eintrag
    # Tagbody-Cons erzeugen:
    {var reg2 object tagbody_cons;
     with_saved_context(
                        tagbody_cons = allocate_cons();
                        );
     # Tagbody-Cons füllen: Tag-Vektor (CONST n) als CAR
     {var reg6 object tag_vector = TheCclosure(closure)->clos_consts[n];
      var reg7 uintL m = TheSvector(tag_vector)->length;
      Car(tagbody_cons) = tag_vector;
      get_space_on_STACK(m*sizeof(object)); # Platz reservieren
      # alle labeli als Fixnums auf den STACK legen:
      {var reg4 uintL count;
       var object list = Cdr(Cdr(code));
       dotimespL(count,m, { pushSTACK(Car(list)); list=Cdr(list); } );
     }}
     # Sprungziel in den SP:
     pushSP((aint)closureptr);
     # CTAGBODY-Frame aufbauen:
     { var reg9 object* top_of_frame = STACK; # Pointer übern Frame
       pushSTACK(tagbody_cons); # Cons ( (CONST n) . ...)
       {var reg4 JMPBUF_on_SP(returner); # Rücksprungpunkt merken
        finish_entry_frame_1(CTAGBODY,returner, goto tagbody_go; );
     } }
     # Framepointer im Tagbody-Cons ablegen:
     Cdr(tagbody_cons) = make_framepointer(STACK);
    }
    return;
  tagbody_go: # Hierher wird gesprungen, wenn der oben aufgebaute
    # CTAGBODY-Frame ein GO zum Label Nummer i gefangen hat.
    { var reg7 uintL m = TheSvector(Car(STACK_2))->length; # Anzahl der Labels
      # (Könnte auch das obige m als 'auto' deklarieren und hier benutzen.)
      var reg4 uintL i = posfixnum_to_L(value1); # Nummer des Labels
      var reg2 uintL index = posfixnum_to_L(STACK_((m-i)+3)); # labeli
      # closure zurück, byteptr:=labeli_byteptr :
      closureptr = (object*) SP_(jmpbufsize+0);
      closure = *closureptr; # Closure aus dem Stack holen
      codeptr = TheSbvector(TheCclosure(closure)->clos_codevec);
      byteptr = CODEPTR + index;
    }
    return; # am Label i weiterinterpretieren
 }

LISPFUNN(vcode_compile,1)
  { 
    var reg3 uintL code_pos;
    var reg4 object closure = STACK_1;
    var reg5 object code_vector = STACK_0;
    var reg6 object *code_data_vector;
    var reg7 uintL code_count;

    if (!simple_vector_p(code_vector))
      fehler_vector(STACK_1);

    code_count = TheSvector(code_vec)->length;
    code_data_vector = &TheSvector(code_vec)->data[0];

    for (code_pos=0;code_pos<code_count;code_pos++)
      {
        if (symbolp(code_data_vector[code_pos]))
          { label_vec[label_index++]=v_genlabel(); }
      }
    
    v_lambda("","", NULL, V_NLEAF, ibuffer);
    for (code_pos=0;code_pos<code_count;code_pos++)
      {
        if (consp(code_data_vector[code_pos]))
          { var reg1 object code = code_data_vector[code_pos];
            var reg2 uint8 code = (uint8)posfixnum_to_L(Car(code));
            switch (code)
              { # (1) Konstanten                            
                case cod_nil:
                set_value1(NIL);
                break;                                          
              case cod_push_nil:
                V_pushSTACK(NIL);
                break;                                          
              case cod_t:
                set_value1(T);
                break;                                          
              case cod_const:
                set_value1(const_0());
                break;
              # (2) statische Variablen                         
              case cod_load:
                V_STACK(reg_value1,operand_0());
                MV_COUNT_1();
                break;                                          
              case cod_loadi:
                V_SP_PTR(reg_tmp,operand_0());
                v_ldpi(reg_value1,reg_tmp,FR_off(operand_1()));
                MV_COUNT_1();
                break;                                          
              case cod_loadc:
                V_STACK(reg_temp,operand_0());
                v_ldpi(reg_temp,reg_temp,offsetof(Svector,data));
                v_ldpi(reg_value1,reg_temp,P_off(1+operand_1()));
                MV_COUNT_1();
                break;       
              case cod_loadv:
                { var v_reg reg_ret;
                  reg_ret = v_scallv((v_vptr)loadv,"%i%i",operand_0(),operand_1());
                  v_movp(reg_value1,reg_ret);
                }
                MV_COUNT_1();
                break;                                          
              case cod_loadic:
                V_STACK(reg_temp,operand_0());
                v_ldpi(reg_temp,reg_temp,offsetof(Svector,data));
                v_ldpi(reg_temp,reg_temp,P_off(1+operand_1()));
                v_ldpi(reg_value1,reg_temp,P_off(1+operand_2()));
                MV_COUNT_1();
                break;                                    
              case cod_store:
                v_mov(reg_temp,reg_STACK);
                v_addpi(reg_temp,reg_temp,ST_off(operand_0()));
                v_stpi(reg_temp,reg_value1,0);
                MV_COUNT_1();
                break;                                          
              case cod_storei:
                V_SP_PTR(reg_temp,operand_0());
                v_addpi(reg_temp,reg_temp,FR_off(operand_1()));
                v_stpi(reg_temp,reg_value1,0);
                MV_COUNT_1();
                break;                                          
              case cod_storec:
                v_mov(reg_temp,reg_STACK);
                v_ldpi(reg_temp,reg_temp,ST_off(operand_0()));
                v_ldpi(reg_temp,reg_temp,offsetof(Svector,data));
                v_addpi(reg_temp,reg_temp,P_off(1+operand_1()));
                v_stpi(reg_temp,reg_value1);
                MV_COUNT_1();
                break;                                          
              case cod_storev:
                { struct v_reg reg_ret;
                  reg_ret=v_scallv((v_vptr)storev_adr,"%I%I",operand_0(),operand_1());
                  v_stpi(reg_ret,reg_value1);
                }
                MV_COUNT_1();
                break;                                          
              case cod_storeic:
                V_SP_PTR(reg_temp,operand_0());
                v_ldpi(reg_temp,reg_temp,FR_off(operand_1()));
                v_ldpi(reg_temp,reg_temp,offsetof(Svector,data));
                v_addpi(reg_temp,reg_temp,P_off(1+operand_2()));
                v_stpi(reg_temp,reg_value1,0);
                MV_COUNT_1();
                break;
              # (3) dynamische Variablen                        
              case cod_getvalue:
                { struct v_reg reg_ret;
                  reg_ret=v_scallv((v_vptr)const_symbol_value_adr,"%I",operand_0());
                  v_ldpi(reg_temp,reg_ret,0);
                  MV_COUNT_1();
                }
                break;                                          
              case cod_setvalue:
                { struct v_reg reg_ret;
                  reg_ret=v_scallv((v_vptr)assign_const_symbol_value_adr,"%I",operand_0());
                  v_stpi(reg_ret,reg_value1,0);
                }
                MV_COUNT_1();
                break;
              case cod_bind:
                { var reg3 object sym_to_bind = const_0();
                  var reg4 struct v_reg reg_top_of_frame;
                  v_getreg(&reg_top_of_frame, V_P, V_TEMP);
                  v_movp(reg_top_of_frame,reg_STACK);
                  V_push_Symbol_value(sym_to_bind);
                  V_pushSTACK(sym_to_bind);
                  V_push_dynamic_frame(reg_top_of_frame);
                  v_setp(reg_temp,&Symbol_value(sym_to_bind));
                  v_stpi(reg_temp,reg_value1,0);
                }
                break;                                          
              case cod_unbind1:
                v_scallv((v_vptr)unbind1,"");
                break;                                          
              case cod_unbind:
                v_scallv((v_vptr)unbind,"");
                break;
              case cod_progv:
                V_reg_popSTACK(reg_temp);
                V_reg_pushSP(reg_STACK);
                v_scallv((v_vptr)progv,"%p%p",reg_temp,reg_value1);
                break;                                          
                
              # (4) Stackoperationen                            
              case cod_push:
                V_pushSTACK(reg_value1);
                break;                                          
              case cod_pop:
                V_popSTACK(reg_value1);
                MV_COUNT_1();
                break;                                          
              case cod_skip:
                V_skipSTACK(operand_0());
                break;
              case cod_skipi:
                V_skipSP(operand_0());
                V_reg_popSP(reg_STACK);
                V_skipSTACK(operand_1());
                break;
              case cod_skipsp:
                V_skipSP(operand_0());
                break;                                          
                
              # (5) Programmfluß und Sprünge                    
              case cod_skip_ret:
                V_skipSTACK(operand_0());
                break;                                          
              case cod_jmp:
                v_jl(lookup_label(operand_0()));
                break;
              case cod_jmpif:
                v_bnepi(reg_value1,NIL,lookup_label(operand_0()));
                break;                                          
              case cod_jmpifnot:
                v_beqpi(reg_value1,NIL,lookup_label(operand_0()));
                break;                                          
              case cod_jmpif1:
                v_bnepi(reg_value1,NIL,lookup_label(operand_0()));
                MV_COUNT_1();
                break;                                          
              case cod_jmpifnot1:
                v_beqpi(reg_value1,NIL,lookup_label(operand_0()));
                MV_COUNT_1();
                break;                                          
              case cod_jmpifatom:
                { var struct v_reg reg_ret;
                  reg_ret=v_scallv((v_vptr)_atomp,"%p",reg_value1);
                  v_beqii(reg_ret,0,lookup_label(operand_0()));
                }
                break;
              case cod_jmpifconsp:
                { var struct v_reg reg_ret;
                  reg_ret=v_scallv((v_vptr)_consp,"%p",reg_value1);
                  v_beqii(reg_ret,0,lookup_label(operand_0()));
                }
                break;
              case cod_jmpifeq:
                { var struct v_reg reg_ret;
                  V_reg_popSTACK(reg_temp);
                  reg_ret=v_scallv((v_vptr)_eq,"%p%p",reg_value1,reg_temp);
                  v_bneii(reg_ret,0,lookup_label(operand_0()));
                }
                break;                                 
              case cod_jmpifnoteq:
                { var struct v_reg reg_ret;
                  V_reg_popSTACK(reg_temp);
                  reg_ret=v_scallv((v_vptr)_eq,"%p%p",reg_value1,reg_temp);
                  v_beqii(reg_ret,0,lookup_label(operand_0()));
                }
                break;                                          
              case cod_jmpifeqto:
                { var struct v_reg reg_ret;
                  V_reg_popSTACK(reg_temp);
                  V_reg_const(closure,reg_temp2,operand_0());
                  reg_ret=v_scallv((v_vptr)_eq,"%p%p",reg_temp,reg_temp2);
                  v_bneii(reg_ret,0,lookup_label(operand_1()));
                }
                break;
              case cod_jmpifnoteqto:
                { var struct v_reg reg_ret;
                  V_reg_popSTACK(reg_temp);
                  V_reg_const(closure,reg_temp2,operand_0());
                  reg_ret=v_scallv((v_vptr)_eq,"%p%p",reg_temp,reg_temp2);
                  v_beqii(reg_ret,0,lookup_label(operand_1()));
                }
                break;                            
              case cod_jmphash:
                v_jl(label_for_jmphash(code_vector,code_pos,operand_0(),value1));
                break;                                          
              case cod_jmphashv:
                v_jl(label_for_jmphash(code_vector,code_pos,operand_0(),value1));
                break;                                          
              case cod_jsr:
                v_jal(lookup_label(operand_0()));
                break;                                          
              case cod_jmptail:
                v_jl(jmptail(operand_2(),operand_0(),operand_1()));
                break;                                          
                
              # (6) Environments und Closures                   
              case cod_venv:
                V_reg_const(closure,reg_value1,0);
                MV_COUNT_1();
                break;                                          
              case cod_make_vector1_push:
                v_scallv((v_vptr)make_vector1_push,"%I%P",operand_0(),value1);
                break;
              case cod_copy_closure:
                { struct v_reg reg_ret;
                  reg_ret=v_scallv((v_vptr)copy_closure,"%P%I%I",closure,operand_0(),operand_1());
                  v_movp(reg_value1,reg_ret);
                }
                MV_COUNT_1();
                break;                                        
              # (7) Funktionsaufrufe                            
              case cod_call:
                v_scallv((v_vptr)callfunc,"%P%I%I",closure,operand_0(),operand_1());
                break; 
              case cod_call0:
                v_scallv((v_vptr)callfunc,"%P%I%I",closure,operand_0(),0);
                break;                                          
              case cod_call1:                                   
                v_scallv((v_vptr)callfunc,"%P%I%I",closure,operand_0(),1);
                break;                                          
              case cod_call2:                                   
                v_scallv((v_vptr)callfunc,"%P%I%I",closure,operand_0(),2);
                break;                                          
              case cod_calls1:
                v_scallv((v_vptr)callfunc_tab1,"%I",operand_0());
                break;                                          
              case cod_calls2:
                v_scallv((v_vptr)callfunc_tab2,"%I",operand_0());
                break;                                    
              case cod_callsr:
                v_scallv((v_vptr)callfunc_tabr,"%I%I",operand_0(),operand_1());
                break;
              case cod_callc:
                v_scallv((v_vptr)interpret_bytecode,"%P%P%I",value1,TheCclosure(value1)->clos_codevec,CCHD+6);
                  break;
              case cod_callckey:
                v_scallv((v_vptr)interpret_bytecode,"%P%P%I",value1,TheCclosure(value1)->clos_codevec,CCHD+10);
                break;                                          
              case cod_funcall:
                v_scallv((v_vptr)do_funcall,"%I",operand_0());
                break;
              case cod_apply:
                v_scallv((v_vptr)do_scallv,"%I",operand_0());
                break; 
                
              # (8) optionale und Keyword-Argumente             
              case cod_push_unbound:
                v_scallv((v_vptr)push_unbound,"%I",operand_0());
                break;
              case cod_unlist:
                v_scallv((v_vptr)unlist,"%I%I%P",operand_0(),operand_1(),value1);
                break;
              case cod_unliststern:
                v_scallv((v_vptr)unlistern,"%I%I%P",operand_0(),operand_1(),value1);
                break;                                          
              case cod_jmpifboundp:
                V_STACK(reg_temp,operand_0());
                v_beqpi(reg_temp,unbound,lookup_label(operand_1()));
                break;
              case cod_boundp:
                V_STACK(reg_temp,operand_0());
                v_setp(reg_value1,T)
                v_cmveqpii(reg_value1,NIL,reg_value1,unbound);
                MV_COUNT_1();
                break;                                    
              case cod_unbound_nil:
                { uintL n = operand_0();
                  V_STACK(reg_temp,n);
                  v_cmveqpii(reg_temp,NIL,reg_temp,unbound);
                  V_setSTACK(n,reg_temp);
                }
                break;                
                
              # (9) Behandlung mehrerer Werte                   
              case cod_values0:
                v_setp(reg_value1,NIL);
                v_seti(reg_mv_count,0);
                break;                                          
              case cod_values1:
                MV_COUNT_1();
                break;                                          
              case cod_stack_to_mv:
                v_scallv((v_vptr)_STACK_to_mv,"%I",operand_0());
                break;                                          
              case cod_mv_to_stack:
                v_scallv((v_vptr)_mv_to_STACK,"");
                break;
              case cod_nv_to_stack:
                v_scallv((v_vptr)_nv_to_STACK,"%I",operand_0());
                break;                         
              case cod_mv_to_list:
                v_scallv((v_vptr)_mv_to_list,"");
                break;
              case cod_list_to_mv:
                v_scallv((v_vptr)_list_to_mv,"");
                break;                                
              case cod_mvcallp:
                V_reg_pushSP(reg_STACK);
                V_reg_pushSTACK(reg_value1);
                break;                                          
              case cod_mvcall:
                v_scallv((v_vptr)mvcall,"");
                break;                 
              # (10) BLOCK                            
              case cod_block_open:
                v_scallv((v_vptr)block_open,"%I%I%I",operand_0(),operand_1(),code_pos);
                break;                                          
              case cod_block_close:
                v_scallv((v_vptr)block_close,"");
                break;                                          
              case cod_return_from:
                v_scallv((v_vptr)return_from,"%I",operand_0());
                break;
              case cod_return_from_i:
                v_scallv((v_vptr)return_from_i,"%I%I",operand_0(),operand_1());
                  break;                                          
              # (11) TAGBODY                                    
              case cod_tagbody_open:
                v_scallv((v_vptr)tagbody_open,
                  break;                                          
                CASE(cod_tagbody_close_nil)                       
                  break;                                          
                CASE(cod_tagbody_close)                           
                  break;                                          
                CASE(cod_go)                                      
                  break;                                          
                CASE(cod_go_i)                                    
                  break;                                          
                
# (12) CATCH und THROW                            
                CASE(cod_catch_open)                              
                  break;                                          
                CASE(cod_catch_close)                             
                  break;                                          
                CASE(cod_throw)                                   
                  break;                                          
                
# (13) UNWIND-PROTECT                             
                CASE(cod_uwp_open)                                
                  break;                                          
                CASE(cod_uwp_normal_exit)                         
                  break;                                          
                CASE(cod_uwp_close)                               
                  break;                                          
                CASE(cod_uwp_cleanup)                             
                  break;                                          
                
# (14) HANDLER-BIND                               
                CASE(cod_handler_open)                            
                  break;                                          
                CASE(cod_handler_begin_push)                      
                  break;                                          
                
# (15) einige Funktionen                          
                CASE(cod_not)                                     
                  break;                                          
                CASE(cod_eq)                                      
                  break;                                          
                CASE(cod_car)                                     
                  break;                                          
                CASE(cod_cdr)                                     
                  break;                                          
                CASE(cod_cons)                                    
                  break;                                          
                CASE(cod_symbol_function)                         
                  break;                                          
                CASE(cod_svref)                                   
                  break;                                          
                CASE(cod_svset)                                   
                  break;                                          
                CASE(cod_list)                                    
                  break;                                          
                CASE(cod_liststern)                               
                  break;                                          
                
# (16) kombinierte Operationen                    
                CASE(cod_nil_push)                                
                  break;                                          
                CASE(cod_t_push)                                  
                  break;                                          
                CASE(cod_const_push)                              
                  break;                                          
                CASE(cod_load_push)                               
                  break;                                          
                CASE(cod_loadi_push)                              
                  break;                                          
                CASE(cod_loadc_push)                              
                  break;                                          
                CASE(cod_loadv_push)                              
                  break;                                          
                CASE(cod_pop_store)                               
                  break;                                          
                CASE(cod_getvalue_push)                           
                  break;                                          
                CASE(cod_jsr_push)                                
                  break;                                          
                CASE(cod_copy_closure_push)                       
                  break;                                          
                CASE(cod_call_push)                               
                  break;                                          
                CASE(cod_call1_push)                              
                  break;                                          
                CASE(cod_call2_push)                              
                  break;                                          
                CASE(cod_calls1_push)                             
                  break;                                          
                CASE(cod_calls2_push)                             
                  break;                                          
                CASE(cod_callsr_push)                             
                  break;                                          
                CASE(cod_callc_push)                              
                  break;                                          
                CASE(cod_callckey_push)                           
                  break;                                          
                CASE(cod_funcall_push)                            
                  break;                                          
                CASE(cod_apply_push)                              
                  break;                                          
                CASE(cod_car_push)                                
                  break;                                          
                CASE(cod_cdr_push)                                
                  break;                                          
                CASE(cod_cons_push)                               
                  break;                                          
                CASE(cod_list_push)                               
                  break;                                          
                CASE(cod_liststern_push)                          
                  break;                                          
                CASE(cod_nil_store)                               
                  break;                                          
                CASE(cod_t_store)                                 
                  break;                                          
                CASE(cod_load_storec)                             
                  break;                                          
                CASE(cod_calls1_store)                            
                  break;                                          
                CASE(cod_calls2_store)                            
                  break;                                          
                CASE(cod_callsr_store)                            
                  break;                                          
                CASE(cod_load_cdr_store)                          
                  break;                                          
                CASE(cod_load_cons_store)                         
                  break;                                          
                CASE(cod_load_inc_store)                          
                  break;                                          
                CASE(cod_load_dec_store)                          
                  break;                                          
                CASE(cod_load_car_store)                          
                  break;                                          
                CASE(cod_call1_jmpif)                             
                  break;                                          
                CASE(cod_call1_jmpifnot)                          
                  break;                                          
                CASE(cod_call2_jmpif)                             
                  break;                                          
                CASE(cod_call2_jmpifnot)                          
                  break;                                          
                CASE(cod_calls1_jmpif)                            
                  break;                                          
                CASE(cod_calls1_jmpifnot)                         
                  break;                                          
                CASE(cod_calls2_jmpif)                            
                  break;                                          
                CASE(cod_calls2_jmpifnot)                         
                  break;                                          
                CASE(cod_callsr_jmpif)                            
                  break;                                          
                CASE(cod_callsr_jmpifnot)                         
                  break;                                          
                CASE(cod_load_jmpif)                              
                  break;                                          
                CASE(cod_load_jmpifnot)                           
                  break;                                          
                CASE(cod_load_car_push)                           
                  break;                                          
                CASE(cod_load_cdr_push)                           
                  break;                                          
                CASE(cod_load_inc_push)                           
                  break;                                          
                CASE(cod_load_dec_push)                           
                  break;                                          
                CASE(cod_const_symbol_function)                   
                  break;                                          
                CASE(cod_const_symbol_function_push)              
                  break;                                          
                CASE(cod_const_symbol_function_store)             
                  break;                                          
                CASE(cod_apply_skip_ret)                          
                  break;                                          
                
# (17) Kurzcodes                                  
                CASE(cod_load0)                                   
                  break;                                          
                CASE(cod_load1)                                   
                  break;                                          
                CASE(cod_load2)                                   
                  break;                                          
                CASE(cod_load3)                                   
                  break;                                          
                CASE(cod_load4)                                   
                  break;                                          
                CASE(cod_load5)                                   
                  break;                                          
                CASE(cod_load6)                                   
                  break;                                          
                CASE(cod_load7)                                   
                  break;                                          
                CASE(cod_load8)                                   
                  break;                                          
                CASE(cod_load9)                                   
                  break;                                          
                CASE(cod_load10)                                  
                  break;                                          
                CASE(cod_load11)                                  
                  break;                                          
                CASE(cod_load12)                                  
                  break;                                          
                CASE(cod_load13)                                  
                  break;                                          
                CASE(cod_load14)                                  
                  break;                                          
                CASE(cod_load_push0)                              
                  break;                                          
                CASE(cod_load_push1)                              
                  break;                                          
                CASE(cod_load_push2)                              
                  break;                                          
                CASE(cod_load_push3)                              
                  break;                                          
                CASE(cod_load_push4)                              
                  break;                                          
                CASE(cod_load_push5)                              
                  break;                                          
                CASE(cod_load_push6)                              
                  break;                                          
                CASE(cod_load_push7)                              
                  break;                                          
                CASE(cod_load_push8)                              
                  break;                                          
                CASE(cod_load_push9)                              
                  break;                                          
                CASE(cod_load_push10)                             
                  break;                                          
                CASE(cod_load_push11)                             
                  break;                                          
                CASE(cod_load_push12)                             
                  break;                                          
                CASE(cod_load_push13)                             
                  break;                                          
                CASE(cod_load_push14)                             
                  break;                                          
                CASE(cod_load_push15)                             
                  break;                                          
                CASE(cod_load_push16)                             
                  break;                                          
                CASE(cod_load_push17)                             
                  break;                                          
                CASE(cod_load_push18)                             
                  break;                                          
                CASE(cod_load_push19)                             
                  break;                                          
                CASE(cod_load_push20)                             
                  break;                                          
                CASE(cod_load_push21)                             
                  break;                                          
                CASE(cod_load_push22)                             
                  break;                                          
                CASE(cod_load_push23)                             
                  break;                                          
                CASE(cod_load_push24)                             
                  break;                                          
                CASE(cod_const0)                                  
                  break;                                          
                CASE(cod_const1)                                  
                  break;                                          
                CASE(cod_const2)                                  
                  break;                                          
                CASE(cod_const3)                                  
                  break;                                          
                CASE(cod_const4)                                  
                  break;                                          
                CASE(cod_const5)                                  
                  break;                                          
                CASE(cod_const6)                                  
                  break;                                          
                CASE(cod_const7)                                  
                  break;                                          
                CASE(cod_const8)                                  
                  break;                                          
                CASE(cod_const9)                                  
                  break;                                          
                CASE(cod_const10)                                 
                  break;                                          
                CASE(cod_const11)                                 
                  break;                                          
                CASE(cod_const12)                                 
                  break;                                          
                CASE(cod_const13)                                 
                  break;                                          
                CASE(cod_const14)                                 
                  break;                                          
                CASE(cod_const15)                                 
                  break;                                          
                CASE(cod_const16)                                 
                  break;                                          
                CASE(cod_const17)                                 
                  break;                                          
                CASE(cod_const18)                                 
                  break;                                          
                CASE(cod_const19)                                 
                  break;                                          
                CASE(cod_const20)                                 
                  break;                                          
                CASE(cod_const_push0)                             
                  break;                                          
                CASE(cod_const_push1)                             
                  break;                                          
                CASE(cod_const_push2)                             
                  break;                                          
                CASE(cod_const_push3)                             
                  break;                                          
                CASE(cod_const_push4)                             
                  break;                                          
                CASE(cod_const_push5)                             
                  break;                                          
                CASE(cod_const_push6)                             
                  break;                                          
                CASE(cod_const_push7)                             
                  break;                                          
                CASE(cod_const_push8)                             
                  break;                                          
                CASE(cod_const_push9)                             
                  break;                                          
                CASE(cod_const_push10)                            
                  break;                                          
                CASE(cod_const_push11)                            
                  break;                                          
                CASE(cod_const_push12)                            
                  break;                                          
                CASE(cod_const_push13)                            
                  break;                                          
                CASE(cod_const_push14)                            
                  break;                                          
                CASE(cod_const_push15)                            
                  break;                                          
                CASE(cod_const_push16)                            
                  break;                                          
                CASE(cod_const_push17)                            
                  break;                                          
                CASE(cod_const_push18)                            
                  break;                                          
                CASE(cod_const_push19)                            
                  break;                                          
                CASE(cod_const_push20)                            
                  break;                                          
                CASE(cod_const_push21)                            
                  break;                                          
                CASE(cod_const_push22)                            
                  break;                                          
                CASE(cod_const_push23)                            
                  break;                                          
                CASE(cod_const_push24)                            
                  break;                                          
                CASE(cod_const_push25)                            
                  break;                                          
                CASE(cod_const_push26)                            
                  break;                                          
                CASE(cod_const_push27)                            
                  break;                                          
                CASE(cod_const_push28)                            
                  break;                                          
                CASE(cod_const_push29)                            
                  break;                                          
                CASE(cod_store0)                                  
                  break;                                          
                CASE(cod_store1)                                  
                  break;                                          
                CASE(cod_store2)                                  
                  break;                                          
                CASE(cod_store3)                                  
                  break;                                          
                CASE(cod_store4)                                  
                  break;                                          
                CASE(cod_store5)                                  
                  break;                                          
                CASE(cod_store6)                                  
                  break;                                          
                CASE(cod_store7)                                  
                  break;                                          
                CASE(cod_store8)                                  
                  break;                                          
                CASE(cod_store9)                                  
                  break;                                          
              default:                                            
                asciz_out("unknown code:");                       
                dez_out(code);                                    
                asciz_out("\n");                                  
                abort();                                          
              }                                                  
          }
        else
          {
            v_label(lookup_label(code_data_vector[code_pos]));
          }
      }
    skipSTACK(1);
    mv_count = 0;
  }


