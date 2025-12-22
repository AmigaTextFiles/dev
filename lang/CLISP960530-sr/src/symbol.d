# Funktionen betr. Symbole für CLISP
# Bruno Haible 22.4.1995

#include "lispbibl.c"


#if 0 # unbenutzt
# UP: Liefert die globale Funktionsdefinition eines Symbols,
# mit Test, ob das Symbol eine globale Funktion darstellt.
# Symbol_function_checked(symbol)
# > symbol: Symbol
# < ergebnis: seine globale Funktionsdefinition
  global object Symbol_function_checked (object symbol);
  global object Symbol_function_checked(symbol)
    var reg1 object symbol;
    { var reg2 object fun = Symbol_function(symbol);
      if (eq(fun,unbound))
        { pushSTACK(symbol); # Wert für Slot NAME von CELL-ERROR
          pushSTACK(symbol);
          pushSTACK(S(symbol_function));
          //: DEUTSCH "~: ~ hat keine globale Funktionsdefinition."
          //: ENGLISH "~: ~ has no global function definition"
          //: FRANCAIS "~ : ~ n'a pas de définition globale de fonction."
          fehler(undefined_function, GETTEXT("~: ~ has no global function definition"));
        }
      if (consp(fun))
        { pushSTACK(symbol);
          pushSTACK(S(function));
          //: DEUTSCH "~: ~ ist ein Macro und keine Funktion."
          //: ENGLISH "~: ~ is a macro, not a function"
          //: FRANCAIS "~ : ~ est une macro et non une fonction."
          fehler(error, GETTEXT("~: ~ is a macro, not a function"));
        }
      return fun;
    }
#endif

# Fehlermeldung, wenn ein Symbol eine Property-Liste ungerader Länge hat.
# fehler_plist_odd(symbol);
# > symbol: Symbol
  nonreturning_function(local, fehler_plist_odd, (object symbol));
  local void fehler_plist_odd(symbol)
    var reg1 object symbol;
    { pushSTACK(symbol);
      pushSTACK(S(get));
      //: DEUTSCH "~: Die Property-Liste von ~ hat ungerade Länge."
      //: ENGLISH "~: the property list of ~ has an odd length"
      //: FRANCAIS "~ : La liste de propriétés attachée à ~ est de longueur impaire."
      fehler(error, GETTEXT("~: the property list of ~ has an odd length"));
    }

# UP: Holt eine Property aus der Property-Liste eines Symbols.
# get(symbol,key)
# > symbol: ein Symbol
# > key: ein mit EQ zu vergleichender Key
# < value: dazugehöriger Wert aus der Property-Liste von symbol, oder unbound.
  global object get (object symbol, object key);
  global object get(symbol,key)
    var reg3 object symbol;
    var reg2 object key;
    { var reg1 object plistr = Symbol_plist(symbol);
      loop
        { if (atomp(plistr)) goto notfound;
          if (eq(Car(plistr),key)) goto found;
          plistr = Cdr(plistr);
          if (atomp(plistr)) goto odd;
          plistr = Cdr(plistr);
        }
      found: # key gefunden
        plistr = Cdr(plistr);
        if (atomp(plistr)) goto odd;
        return Car(plistr);
      odd: # Property-Liste hat ungerade Länge
        fehler_plist_odd(symbol);
      notfound: # key nicht gefunden
        return unbound;
    }

LISPFUNN(putd,2)
# (SYS::%PUTD symbol function)
  { var reg2 object symbol = STACK_1;
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
   {var reg1 object fun = STACK_0;
    # fun muß SUBR, FSUBR, Closure oder (SYS::MACRO . Closure) sein,
    # Lambda-Ausdruck wird sofort in eine Closure umgewandelt:
    if (subrp(fun) || closurep(fun) || fsubrp(fun)) goto ok;
    elif (consp(fun)) # ein Cons?
      { if (eq(Car(fun),S(macro)))
          { if (mclosurep(Cdr(fun))) goto ok; } # (SYS::MACRO . Closure) ist ok
        elif (eq(Car(fun),S(lambda)))
          { var reg3 object lambdabody = Cdr(fun); # (lambda-list {decl|doc} . body)
            # leeres Environment für get_closure:
            pushSTACK(NIL); pushSTACK(NIL); pushSTACK(NIL); pushSTACK(NIL); pushSTACK(NIL);
           {var reg4 environment* env = &STACKblock_(environment,0);
            fun = get_closure(lambdabody,symbol,env); # Closure erzeugen
            skipSTACK(5);
            goto ok;
      }   }}
    elif (ffunctionp(fun)) goto ok; # Foreign-Function ist auch ok.
    pushSTACK(fun);
    //: DEUTSCH "SETF SYMBOL-FUNCTION: ~ ist keine Funktion."
    //: ENGLISH "SETF SYMBOL-FUNCTION: ~ is not a function"
    //: FRANCAIS "SETF SYMBOL-FUNCTION : ~ n'est pas une fonction."
    fehler(error, GETTEXT("SETF SYMBOL-FUNCTION: ~ is not a function"));
    ok: # fun korrekt, in die Funktionszelle stecken:
    value1 = popSTACK(); # function-Argument als Wert
    Symbol_function(popSTACK()) = fun;
    mv_count=1;
  }}

LISPFUNN(proclaim_constant,2)
# (SYS::%PROCLAIM-CONSTANT symbol value) erklärt ein Symbol zu einer Konstanten
# und ihm einen Wert zu.
  { var reg2 object val = popSTACK();
    var reg1 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
    set_const_flag(TheSymbol(symbol)); # symbol zu einer Konstanten machen
    set_Symbol_value(symbol,val); # ihren Wert setzen
    value1 = symbol; mv_count=1; # symbol als Wert
  }

LISPFUN(get,2,1,norest,nokey,0,NIL)
# (GET symbol key [not-found]), CLTL S. 164
  { var reg2 object symbol = STACK_2;
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
   {var reg1 object result = get(symbol,STACK_1); # suchen
    if (eq(result,unbound)) # nicht gefunden?
      { result = STACK_0; # Defaultwert ist not-found
        if (eq(result,unbound)) # Ist der nicht angegeben,
          { result = NIL; } # dann NIL.
      }
    value1 = result; mv_count=1;
    skipSTACK(3);
  }}

LISPFUN(getf,2,1,norest,nokey,0,NIL)
# (GETF place key [not-found]), CLTL S. 166
  { var reg1 object plistr = STACK_2;
    var reg2 object key = STACK_1;
    loop
      { if (atomp(plistr)) goto notfound;
        if (eq(Car(plistr),key)) goto found;
        plistr = Cdr(plistr);
        if (atomp(plistr)) goto odd;
        plistr = Cdr(plistr);
      }
    found: # key gefunden
      plistr = Cdr(plistr);
      if (atomp(plistr)) goto odd;
      value1 = Car(plistr); mv_count=1; skipSTACK(3); return;
    odd: # Property-Liste hat ungerade Länge
    { pushSTACK(STACK_2);
      pushSTACK(S(getf));
      //: DEUTSCH "~: Die Property-Liste ~ hat ungerade Länge."
      //: ENGLISH "~: the property list ~ has an odd length"
      //: FRANCAIS "~ : La liste de propriétés ~ est de longueur impaire."
      fehler(error, GETTEXT("~: the property list ~ has an odd length"));
    }
    notfound: # key nicht gefunden
      if (eq( value1 = STACK_0, unbound)) # Defaultwert ist not-found
        { value1 = NIL; } # Ist der nicht angegeben, dann NIL.
      mv_count=1; skipSTACK(3); return;
  }

LISPFUNN(get_properties,2)
# (GET-PROPERTIES place keylist), CLTL S. 167
  { var reg4 object keylist = popSTACK();
    var reg5 object plist = popSTACK();
    var reg3 object plistr = plist;
    loop
      { if (atomp(plistr)) goto notfound;
       {var reg2 object item = Car(plistr);
        var reg1 object keylistr = keylist;
        while (consp(keylistr))
          { if (eq(item,Car(keylistr))) goto found;
            keylistr = Cdr(keylistr);
          }
        plistr = Cdr(plistr);
        if (atomp(plistr)) goto odd;
        plistr = Cdr(plistr);
      }}
    found: # key gefunden
      value3 = plistr; # Dritter Wert = Listenrest
      value1 = Car(plistr); # Erster Wert = gefundener Key
      plistr = Cdr(plistr);
      if (atomp(plistr)) goto odd;
      value2 = Car(plistr); # Zweiter Wert = Wert zum Key
      mv_count=3; return; # Drei Werte
    odd: # Property-Liste hat ungerade Länge
    { pushSTACK(plist);
      pushSTACK(S(get_properties));
      //: DEUTSCH "~: Die Property-Liste ~ hat ungerade Länge."
      //: ENGLISH "~: the property list ~ has an odd length"
      //: FRANCAIS "~ : La liste de propriétés ~ est de longueur impaire."
      fehler(error, GETTEXT("~: the property list ~ has an odd length"));
    }
    notfound: # key nicht gefunden
      value1 = value2 = value3 = NIL; mv_count=3; return; # alle 3 Werte NIL
  }

LISPFUNN(putplist,2)
# (SYS::%PUTPLIST symbol list) == (SETF (SYMBOL-PLIST symbol) list)
  { var reg2 object list = popSTACK();
    var reg1 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
    value1 = Symbol_plist(symbol) = list; mv_count=1;
  }

LISPFUNN(put,3)
# (SYS::%PUT symbol key value) == (SETF (GET symbol key) value)
  { { var reg3 object symbol = STACK_2;
      if (!symbolp(symbol)) { fehler_symbol(symbol); }
     {var reg2 object key = STACK_1;
      var reg1 object plistr = Symbol_plist(symbol);
      loop
        { if (atomp(plistr)) goto notfound;
          if (eq(Car(plistr),key)) goto found;
          plistr = Cdr(plistr);
          if (atomp(plistr)) goto odd;
          plistr = Cdr(plistr);
        }
      found: # key gefunden
        plistr = Cdr(plistr);
        if (atomp(plistr)) goto odd;
        value1 = Car(plistr) = STACK_0; mv_count=1; # neues value eintragen
        skipSTACK(3); return;
      odd: # Property-Liste hat ungerade Länge
        fehler_plist_odd(symbol);
    }}
    notfound: # key nicht gefunden
    # Property-Liste um 2 Conses erweitern:
    pushSTACK(allocate_cons());
    { var reg2 object cons1 = allocate_cons();
      var reg1 object cons2 = popSTACK();
      value1 = Car(cons2) = popSTACK(); # value
      Car(cons1) = popSTACK(); # key
     {var reg3 object symbol = popSTACK();
      Cdr(cons2) = Symbol_plist(symbol);
      Cdr(cons1) = cons2;
      Symbol_plist(symbol) = cons1;
      mv_count=1; return;
    }}
  }

LISPFUNN(remprop,2)
# (REMPROP symbol indicator), CLTL S. 166
  { var reg3 object key = popSTACK();
    var reg4 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
   {var reg2 object* plistr_ = &Symbol_plist(symbol);
    var reg1 object plistr;
    loop
      { plistr = *plistr_;
        if (atomp(plistr)) goto notfound;
        if (eq(Car(plistr),key)) goto found;
        plistr = Cdr(plistr);
        if (atomp(plistr)) goto odd;
        plistr_ = &Cdr(plistr);
      }
    found: # key gefunden
      plistr = Cdr(plistr);
      if (atomp(plistr)) goto odd;
      *plistr_ = Cdr(plistr); # Property-Liste um 2 Elemente verkürzen
      value1 = T; mv_count=1; return; # Wert T
    odd: # Property-Liste hat ungerade Länge
      fehler_plist_odd(symbol);
    notfound: # key nicht gefunden
      value1 = NIL; mv_count=1; return; # Wert NIL
  }}

LISPFUNN(symbol_package,1)
# (SYMBOL-PACKAGE symbol), CLTL S. 170
  { var reg1 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
    value1 = Symbol_package(symbol); mv_count=1;
  }

LISPFUNN(symbol_plist,1)
# (SYMBOL-PLIST symbol), CLTL S. 166
  { var reg1 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
    value1 = Symbol_plist(symbol); mv_count=1;
  }

LISPFUNN(symbol_name,1)
# (SYMBOL-NAME symbol), CLTL S. 168
  { var reg1 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
    value1 = Symbol_name(symbol); mv_count=1;
  }

LISPFUNN(keywordp,1)
# (KEYWORDP object), CLTL S. 170
  { var reg1 object obj = popSTACK();
    if (symbolp(obj) && keywordp(obj))
      { value1 = T; }
      else
      { value1 = NIL; }
    mv_count=1;
  }

LISPFUNN(special_variable_p,1)
# (SYS::SPECIAL-VARIABLE-P symbol) stellt fest, ob das Symbol eine
# Special-Variable (oder eine Konstante) darstellt.
# (Bei Konstanten ist ja das Special-Bit bedeutungslos.)
  { var reg1 object symbol = popSTACK();
    if (!symbolp(symbol)) { fehler_symbol(symbol); }
    value1 = (constantp(TheSymbol(symbol)) || special_var_p(TheSymbol(symbol))
              ? T : NIL
             );
    mv_count=1;
  }

LISPFUN(gensym,0,1,norest,nokey,0,NIL)
# (GENSYM x), CLTL S. 169, CLtL2 S. 245-246
# (defun gensym (&optional (x nil s))
#   (let ((prefix "G") ; ein String
#         (counter *gensym-counter*)) ; ein Integer >=0
#     (when s
#       (cond ((stringp x) (setq prefix x))
#             ((integerp x)
#              (if (minusp x)
#                (error-of-type 'type-error
#                       :datum x :expected-type '(INTEGER 0 *)
#                       #+DEUTSCH "~S: Index ~S ist negativ."
#                       #+ENGLISH "~S: index ~S is negative"
#                       #+FRANCAIS "~S: L'index ~S est négatif."
#                       'gensym x
#                )
#                (setq counter x)
#             ))
#             (t (error-of-type 'type-error
#                       :datum x :expected-type '(OR STRING INTEGER)
#                       #+DEUTSCH "~S: Argument ~S hat falschen Typ"
#                       #+ENGLISH "~S: invalid argument ~S"
#                       #+FRANCAIS "~S: L'argument ~S n'est pas du bon type."
#                       'gensym x
#             )  )
#     ) )
#     (prog1
#       (make-symbol
#         (string-concat
#           prefix
#           #-CLISP (write-to-string counter :base 10 :radix nil)
#           #+CLISP (sys::decimal-string counter)
#       ) )
#       (unless (integerp x) (setq *gensym-counter* (1+ counter)))
# ) ) )
  { var reg3 object prefix = O(gensym_prefix); # "G"
    var reg2 object counter = Symbol_value(S(gensym_counter)); # *GENSYM-COUNTER*
    var reg1 object x = popSTACK(); # Argument
    if (!eq(x,unbound))
      # x angegeben
      { if (stringp(x))
          { prefix = x; } # prefix setzen
        elif (integerp(x))
          { if (R_minusp(x))
              { pushSTACK(x); # Wert für Slot DATUM von TYPE-ERROR
                pushSTACK(O(type_posinteger)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
                pushSTACK(x);
                pushSTACK(S(gensym));
                //: DEUTSCH "~: Index ~ ist negativ."
                //: ENGLISH "~: index ~ is negative"
                //: FRANCAIS "~ : L'index ~ est négatif."
                fehler(type_error, GETTEXT("~: index ~ is negative"));
              }
            # x ist ein Integer >=0
            counter = x; # counter setzen
          }
        else
          { pushSTACK(x); # Wert für Slot DATUM von TYPE-ERROR
            pushSTACK(O(type_gensym_arg)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
            pushSTACK(x);
            pushSTACK(S(gensym));
            //: DEUTSCH "~: Argument ~ hat falschen Typ."
            //: ENGLISH "~: invalid argument ~"
            //: FRANCAIS "~ : L'argument ~ n'est pas du bon type."
            fehler(type_error, GETTEXT("~: invalid argument ~"));
      }   }
    # String zusammenbauen:
    pushSTACK(prefix); # 1. Teilstring
    pushSTACK(counter); # counter
    if (!integerp(x))
      { if (!(integerp(counter) && !R_minusp(counter))) # sollte Integer >= 0 sein
          { var reg4 object new_value = Fixnum_0; # *GENSYM-COUNTER* zurücksetzen
            set_Symbol_value(S(gensym_counter),new_value);
            pushSTACK(counter); # Wert für Slot DATUM von TYPE-ERROR
            pushSTACK(O(type_posinteger)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
            pushSTACK(new_value); pushSTACK(counter);
            //: DEUTSCH "Der Wert von *GENSYM-COUNTER* war kein Integer >= 0. Alter Wert: ~. Neuer Wert: ~."
            //: ENGLISH "The value of *GENSYM-COUNTER* was not a nonnegative integer. Old value ~. New value ~."
            //: FRANCAIS "La valeur de *GENSYM-COUNTER* n'était pas un entier >= 0. Ancienne valeur : ~. Nouvelle valeur : ~."
            fehler(type_error, GETTEXT("The value of *GENSYM-COUNTER* was not a nonnegative integer. Old value ~. New value ~."));
          }
        set_Symbol_value(S(gensym_counter),I_1_plus_I(counter)); # (incf *GENSYM-COUNTER*)
      }
    funcall(L(decimal_string),1); # (sys::decimal-string counter)
    pushSTACK(value1); # 2. String
    value1 = make_symbol(string_concat(2)); # zusammenhängen, Symbol bilden
    mv_count=1; # als Wert
  }

#ifdef DYNBIND_LIST

#if 0
local int _find_symbol_in_frame (object sym,object *stackptr);
local int _find_symbol_in_frame (sym,stackptr)
  var object sym;
  var object *stackptr;
  { var reg4 object frameinfo = *stackptr;
    var reg3 object* new_STACK = topofframe(frameinfo);
    var reg2 object* frame_end = STACKpointable(new_STACK);
    var reg1 object* bindingptr = stackptr STACKop 1;
   
    if (!(typecode(frameinfo) == DYNBIND_frame_info)) abort();
    until (bindingptr == frame_end)
      { if (eq(*(bindingptr STACKop 0),sym))
          { value1 = *(bindingptr STACKop 1);
            return TRUE;
          }
        bindingptr skipSTACKop 2;
      }
    return FALSE;
  }

local int _find_binding (object sym);
local int _find_binding (sym)
  var object sym;
  { 
    { var reg1 object obj = Symbol_symvalue(S(dynamic_bindings));
      var reg2 object item;
      loop 
        {
          if (!consp(obj)) break;
          item = Car(obj);
          # if (systemp(item))
            { if (_find_symbol_in_frame(sym,uTheFramepointer(item))) 
                return TRUE;
            }
        }
    }
    { var reg1 object obj = Symbol_symvalue(S(special_bindings));
      var reg2 object item;
      loop 
        {
          if (!consp(obj)) break;
          item = Car(obj);
          # if (consp(item))
            { if (eq(Car(item),sym))
                { value1 = Cdr(item);
                  return TRUE;
                }
            }
          obj = Cdr(obj);
        }
    }
    return FALSE;
  }

#endif


local object add_frame_to_frame_list (object *stackptr);
local object add_frame_to_frame_list (stackptr)
  var object *stackptr;
  {
    pushSTACK(allocate_cons());
    Car(STACK_0)=make_framepointer(stackptr);
    Cdr(STACK_0)=Symbol_symvalue(S(dynamic_and_special_frames));
    set_Symbol_symvalue(S(dynamic_and_special_frames),STACK_0);
    return popSTACK();
  }

global void add_frame_to_binding_list (object *stackptr);
global void add_frame_to_binding_list(stackptr)
  var object *stackptr;
  { 
    pushSTACK(allocate_cons());
    Car(STACK_0)=add_frame_to_frame_list(stackptr);
    Cdr(STACK_0)=Symbol_symvalue(S(dynamic_bindings));
    set_Symbol_symvalue(S(dynamic_bindings),STACK_0);
    if (!eq(Symbol_symvalue(S(last_binding_type)),S(Kdynamic)))
      { pushSTACK(allocate_cons());
        Car(STACK_0)=STACK_1;
        Cdr(STACK_0)=Symbol_symvalue(S(transitions_to_dynamic_bindings));
        set_Symbol_symvalue(S(transitions_to_dynamic_bindings),STACK_0);
        skipSTACK(1);
      }
    set_Symbol_symvalue(S(last_binding_type),S(Kdynamic));
    skipSTACK(1);
  }

global void delete_frame_from_binding_list (object *stackptr);
global void delete_frame_from_binding_list(stackptr)
  var reg9 object *stackptr;
  {
    var reg8 object dynamic_bindings = Symbol_symvalue(S(dynamic_bindings));
    var reg7 object special_transition_list = Symbol_symvalue(S(transitions_to_special_bindings));
    var reg6 object dynamic_transition_list = Symbol_symvalue(S(transitions_to_dynamic_bindings));
    var reg5 object special_list = Car(special_transition_list);
    var reg4 object dynamic_list = Car(dynamic_transition_list);
    var reg3 object last_special_frame_cons = Car(special_list);
    var reg2 object last_dynamic_frame_cons = Car(dynamic_list);
    var reg1 object frame_cons = Car(dynamic_bindings);
    if (eq(Cdr(last_special_frame_cons),frame_cons))
      { Cdr(last_special_frame_cons) = Cdr(frame_cons);
        set_Symbol_symvalue(S(transitions_to_special_bindings),Cdr(special_transition_list));
      }
    else set_Symbol_symvalue(S(dynamic_and_special_frames),Cdr(Symbol_symvalue(S(dynamic_and_special_frames))));
    if (eq(last_dynamic_frame_cons,frame_cons))
      { Cdr(last_dynamic_frame_cons) = Cdr(frame_cons);
        set_Symbol_symvalue(S(transitions_to_dynamic_bindings),Cdr(dynamic_transition_list));
      }
    set_Symbol_symvalue(S(dynamic_bindings),Cdr(dynamic_bindings));
  }

global void set_Symbolflagged_value_on (object sym,object val,object *frame_ptr);
global void set_Symbolflagged_value_on (sym,val,frame_ptr)
  var reg5 object sym;
  var reg4 object val;
  var reg3 object *frame_ptr;
  {
     set_Symbolflagged_symvalue(sym,val);
     pushSTACK(allocate_cons());
     Car(STACK_0) = add_frame_to_frame_list(frame_ptr);
     Cdr(STACK_0) = Symbol_symvalue(S(special_bindings));
     set_Symbol_symvalue(S(special_bindings),STACK_0);
     if (!eq(Symbol_symvalue(S(last_binding_type)),S(Kspecial)))
      { pushSTACK(allocate_cons());
        Car(STACK_0)=STACK_1;
        Cdr(STACK_0)=Symbol_symvalue(S(transitions_to_special_bindings));
        set_Symbol_symvalue(S(transitions_to_special_bindings),STACK_0);
        skipSTACK(1);
      }
     set_Symbol_symvalue(S(last_binding_type),S(Kspecial));
     skipSTACK(1);
  }

global void set_Symbolflagged_value_off (object sym,object val);
global void set_Symbolflagged_value_off (sym,val)
  var reg10 object sym;
  var reg9 object val;
  {
    var reg8 object special_bindings = Symbol_symvalue(S(special_bindings));
    var reg7 object special_transition_list = Symbol_symvalue(S(transitions_to_special_bindings));
    var reg6 object dynamic_transition_list = Symbol_symvalue(S(transitions_to_dynamic_bindings));
    var reg5 object dynamic_list = Car(dynamic_transition_list);
    var reg4 object special_list = Car(special_transition_list);
    var reg3 object last_dynamic_frame_cons = Car(dynamic_list);
    var reg2 object last_special_frame_cons = Car(special_list);
    var reg1 object frame_cons = Car(special_bindings);
    if (eq(Cdr(last_dynamic_frame_cons),frame_cons))
      { Cdr(last_dynamic_frame_cons) = Cdr(frame_cons);
        set_Symbol_symvalue(S(transitions_to_dynamic_bindings),Cdr(dynamic_transition_list));
      }
    else set_Symbol_symvalue(S(dynamic_and_special_frames),Cdr(Symbol_symvalue(S(dynamic_and_special_frames))));
    if (eq(last_special_frame_cons,frame_cons))
      { Cdr(last_special_frame_cons) = Cdr(frame_cons);
        set_Symbol_symvalue(S(transitions_to_special_bindings),Cdr(special_transition_list));
      }
    set_Symbol_symvalue(S(special_bindings),Cdr(special_bindings));
    set_Symbolflagged_symvalue(sym,val);
  }

#endif
