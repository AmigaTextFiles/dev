# Foreign language interface for CLISP
# Marcus Daniels 8.4.1994
# Bruno Haible 21.1.1995, 23.6.1995

#include "lispbibl.c"
#include "arilev0.c" # für mulu32_unchecked
#undef valid

#ifdef DYNAMIC_FFI

#include "avcall.h"      # Low level support for call-out

#include "vacall.h"      # Low level support for call-in
#include "trampoline.h"  # Low level support for call-in

#ifdef AMIGAOS
#include "amiga2.c"      # declares OpenLibrary(), CloseLibrary()
#endif

# Complain about an invalid foreign pointer.
# fehler_fpointer_invalid(obj);
# > obj: invalid Fpointer
  nonreturning_function(local, fehler_fpointer_invalid, (object obj));
  local void fehler_fpointer_invalid(obj)
    var reg1 object obj;
    { pushSTACK(obj);
      //: DEUTSCH "~ stammt aus einer früheren Lisp-Sitzung und ist jetzt ungültig."
      //: ENGLISH "~ comes from a previous Lisp session and is invalid"
      //: FRANCAIS "~ provient d'une séance Lisp passée et est inadmissible"
      fehler(error, GETTEXT("~ comes from a previous Lisp session and is invalid"));
    }

# (FFI::VALIDP foreign-entity) tests whether a foreign entity is still valid
# or refers to an invalid foreign pointer.
LISPFUNN(validp,1)
  { var reg1 object obj = popSTACK();
    var reg2 boolean valid = TRUE; # default: non-foreign objects are valid
    if (orecordp(obj))
      { switch (TheRecord(obj)->rectype)
          { case Rectype_Fpointer:
              valid = fp_validp(TheFpointer(obj));
              break;
            case Rectype_Faddress:
              obj = TheFaddress(obj)->fa_base;
              valid = fp_validp(TheFpointer(obj));
              break;
            case Rectype_Fvariable:
              obj = TheFvariable(obj)->fv_address;
              obj = TheFaddress(obj)->fa_base;
              valid = fp_validp(TheFpointer(obj));
              break;
            case Rectype_Ffunction:
              obj = TheFfunction(obj)->ff_address;
              obj = TheFaddress(obj)->fa_base;
              valid = fp_validp(TheFpointer(obj));
              break;
      }   }
    value1 = (valid ? T : NIL); mv_count=1;
  }

# Allocate a foreign address.
# make_faddress(base,offset)
# > base: base address
# > offset: offset relative to the base address
# < result: Lisp object
  local object make_faddress (object base, uintP offset);
  local object make_faddress(base,offset)
    var reg2 object base;
    var reg2 uintP offset;
    { pushSTACK(base);
     {var reg1 object result = allocate_faddress();
      TheFaddress(result)->fa_base = popSTACK(); # base
      TheFaddress(result)->fa_offset = offset;
      return result;
    }}

# Registers a foreign variable.
# register_foreign_variable(address,name,flags,size);
# > address: address of a variable in memory
# > name: its name
# > flags: fv_readonly for read-only variables
# > size: its size in bytes
# kann GC auslösen
  global void register_foreign_variable (void* address, const char * name, uintBWL flags, uintL size);
  global void register_foreign_variable(address,name_asciz,flags,size)
    var reg3 void* address;
    var reg4 const char * name_asciz;
    var reg5 uintBWL flags;
    var reg6 uintL size;
    { var reg2 object name = asciz_to_string(name_asciz);
      var reg1 object obj = gethash(name,O(foreign_variable_table));
      if (!eq(obj,nullobj))
        { obj = TheFvariable(obj)->fv_address;
          obj = TheFaddress(obj)->fa_base;
          if (fp_validp(TheFpointer(obj)))
            { pushSTACK(name);
              //: DEUTSCH "Eine Foreign-Variable ~ gibt es schon."
              //: ENGLISH "A foreign variable ~ already exists"
              //: FRANCAIS "Il y a déjà une variable étrangère ~."
              fehler(error, GETTEXT("A foreign variable ~ already exists"));
            }
            else
            # Variable already existed in a previous Lisp session.
            # Update the address, and make it and any of its subvariables valid.
            { TheFpointer(obj)->fp_pointer = address;
              mark_fp_valid(TheFpointer(obj));
        }   }
        else
        { pushSTACK(name);
          pushSTACK(make_faddress(allocate_fpointer(address),0));
          obj = allocate_fvariable();
          TheFvariable(obj)->fv_address = popSTACK();
          TheFvariable(obj)->fv_name = name = popSTACK();
          TheFvariable(obj)->fv_size = fixnum(size);
          TheFvariable(obj)->recflags = flags;
          shifthash(O(foreign_variable_table),name,obj);
    }   }

# Registers a foreign function.
# register_foreign_function(address,name,flags);
# > address: address of the function in memory
# > name: its name
# > flags: its language and parameter passing convention
# kann GC auslösen
  global void register_foreign_function (void* address, const char * name, uintWL flags);
  global void register_foreign_function(address,name_asciz,flags)
    var reg3 void* address;
    var reg4 const char * name_asciz;
    var reg5 uintWL flags;
    { var reg2 object name = asciz_to_string(name_asciz);
      var reg1 object obj = gethash(name,O(foreign_function_table));
      if (!eq(obj,nullobj))
        { obj = TheFfunction(obj)->ff_address;
          obj = TheFaddress(obj)->fa_base;
          if (fp_validp(TheFpointer(obj)))
            { pushSTACK(name);
              //: DEUTSCH "Eine Foreign-Funktion ~ gibt es schon."
              //: ENGLISH "A foreign function ~ already exists"
              //: FRANCAIS "Il y a déjà une fonction étrangère ~."
              fehler(error, GETTEXT("A foreign function ~ already exists"));
            }
            else
            # Function already existed in a previous Lisp session.
            # Update the address, and make it valid.
            { TheFpointer(obj)->fp_pointer = address;
              mark_fp_valid(TheFpointer(obj));
        }   }
        else
        { pushSTACK(name);
          pushSTACK(make_faddress(allocate_fpointer(address),0));
          obj = allocate_ffunction();
          TheFfunction(obj)->ff_address = popSTACK();
          TheFfunction(obj)->ff_name = name = popSTACK();
          TheFfunction(obj)->ff_flags = fixnum(flags);
          shifthash(O(foreign_function_table),name,obj);
    }   }


# A foreign value descriptor describes an item of foreign data.
# <c-type> ::=
#   <simple-c-type>   as described in foreign.txt
#   c-pointer
#   c-string
#   #(c-struct slots constructor <c-type>*)
#   #(c-union alternatives <c-type>*)
#   #(c-array <c-type> number*)
#   #(c-array-max <c-type> number)
#   #(c-function <c-type> #({<c-type> flags}*) flags)
#   #(c-ptr <c-type>)
#   #(c-ptr-null <c-type>)
#   #(c-array-ptr <c-type>)

# Error message.
nonreturning_function(local, fehler_foreign_type, (object fvd));
local void fehler_foreign_type(fvd)
  var reg1 object fvd;
  { var reg2 object *fvd_ptr;
    pushSTACK(fvd); fvd_ptr=&STACK_0;
    dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
    pushSTACK(*fvd_ptr);
    //: DEUTSCH "ungültiger Typ für externe Daten: ~"
    //: ENGLISH "illegal foreign data type ~"
    //: FRANCAIS "type invalide de données externes : ~"
    fehler(error, GETTEXT("illegal foreign data type ~"));
  }

# Error message.
nonreturning_function(local, fehler_convert, (object fvd, object obj));
local void fehler_convert(fvd,obj)
  var reg1 object fvd;
  var reg2 object obj;
  { var reg3 object *fvd_ptr;
    var reg4 object *obj_ptr;
    pushSTACK(fvd); fvd_ptr = &STACK_0;
    pushSTACK(obj); obj_ptr = &STACK_0;
    dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
    pushSTACK(*fvd_ptr);
    pushSTACK(*obj_ptr);
    //: DEUTSCH "~ kann nicht in den Foreign-Typ ~ umgewandelt werden."
    //: ENGLISH "~ cannot be converted to the foreign type ~"
    //: FRANCAIS "~ ne peut être transformé en type étranger ~."
    fehler(error, GETTEXT("~ cannot be converted to the foreign type ~"));
  }

#if !defined(HAVE_LONGLONG)
# Error message.
nonreturning_function(local, fehler_64bit, (object fvd));
local void fehler_64bit(fvd)
  var reg1 object fvd;
  { var reg2 object *fvd_ptr; 
    pushSTACK(fvd); fvd_ptr=&STACK_0;
    dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
    pushSTACK(*fvd_ptr);
    //: DEUTSCH "64-Bit-Ganzzahlen werden auf dieser Plattform und mit diesem C-Compiler nicht unterstützt: ~"
    //: ENGLISH "64 bit integers are not supported on this platform and with this C compiler: ~"
    //: FRANCAIS "Des nombres à 64 bits ne sont pas supportés sur cette machine et avec ce compilateur C : ~"
    fehler(error, GETTEXT("64 bit integers are not supported on this platform and with this C compiler: ~"));
  }
#endif

# Comparison of two fvd's.
# According to the ANSI C rules, two "c-struct"s are only equivalent if they
# come from the same declaration. Same for "c-union"s.
# "c-array"s, "c-ptr", "c-ptr-null" are compared recursively. Same for "c-function".
  local boolean equal_fvd (object fvd1, object fvd2);
# As an exception to strict type and prototype checking,
# C-POINTER matches any C-PTR, C-PTR-NULL, C-ARRAY-PTR and C-FUNCTION type.
  local boolean equalp_fvd (object fvd1, object fvd2);
# Comparison of two argument type vectors.
  local boolean equal_argfvds (object argfvds1, object argfvds2);

  local boolean equal_fvd(fvd1,fvd2)
    var reg1 object fvd1;
    var reg2 object fvd2;
    { check_SP();
      recurse:
      if (eq(fvd1,fvd2))
        { return TRUE; }
      if (simple_vector_p(fvd1) && simple_vector_p(fvd2))
        if (TheSvector(fvd1)->length == TheSvector(fvd2)->length)
          { var reg4 uintL len = TheSvector(fvd1)->length;
            if (len > 0)
              { if (eq(TheSvector(fvd1)->data[0],TheSvector(fvd2)->data[0]))
                  { var reg5 object obj;
                    obj = TheSvector(fvd1)->data[0];
                    if ((len >= 2) && 
                        (eq(obj,S(c_array)) || eq(obj,S(c_array_max))
                         || eq(obj,S(c_ptr)) || eq(obj,S(c_ptr_null)) || eq(obj,S(c_array_ptr))))
                      { var reg3 uintL i;
                        for (i = 2; i < len; i++)
                          { if (!eql(TheSvector(fvd1)->data[i],TheSvector(fvd2)->data[i]))
                              goto no;
                          }
                        fvd1 = TheSvector(fvd1)->data[1];
                        fvd2 = TheSvector(fvd2)->data[1];
                        goto recurse;
                      }
                    elif ((len == 4) && eq(obj,S(c_function)))
                      { if (!equal_fvd(TheSvector(fvd1)->data[1],TheSvector(fvd2)->data[1]))
                          goto no;
                        if (!equal_argfvds(TheSvector(fvd1)->data[2],TheSvector(fvd2)->data[2]))
                          goto no;
                        if (!eql(TheSvector(fvd1)->data[3],TheSvector(fvd2)->data[3]))
                          goto no;
                        return TRUE;
                      }
          }   }   }
      no:
      return FALSE;
    }

  local boolean equal_argfvds(argfvds1,argfvds2)
    var reg1 object argfvds1;
    var reg2 object argfvds2;
    { ASSERT(simple_vector_p(argfvds1) && simple_vector_p(argfvds2));
     {var reg3 uintL len = TheSvector(argfvds1)->length;
      if (!(len == TheSvector(argfvds2)->length)) return FALSE;
      while (len > 0)
        { len--;
          if (!equal_fvd(TheSvector(argfvds1)->data[len],TheSvector(argfvds2)->data[len]))
            return FALSE;
        }
      return TRUE;
    }}

  local boolean equalp_fvd(fvd1,fvd2)
    var reg1 object fvd1;
    var reg2 object fvd2;
    { if (eq(fvd1,fvd2))
        { return TRUE; }
      if (eq(fvd1,S(c_pointer))
          && simple_vector_p(fvd2) && (TheSvector(fvd2)->length > 0)
         )
        { var reg3 object fvd2type = TheSvector(fvd2)->data[0];
          if (eq(fvd2type,S(c_ptr)) || eq(fvd2type,S(c_ptr_null))
              || eq(fvd2type,S(c_array_ptr)) || eq(fvd2type,S(c_function)))
            return TRUE;
        }
      if (eq(fvd2,S(c_pointer))
          && simple_vector_p(fvd1) && (TheSvector(fvd1)->length > 0)
         )
        { var reg3 object fvd1type = TheSvector(fvd1)->data[0];
          if (eq(fvd1type,S(c_ptr)) || eq(fvd1type,S(c_ptr_null))
              || eq(fvd1type,S(c_array_ptr)) || eq(fvd1type,S(c_function)))
            return TRUE;
        }
      return equal_fvd(fvd1,fvd2);
    }


# When a Lisp function is converted to a C function, it has to be stored in
# a table of call-back functions. (Because we can't give away pointers to
# Lisp objects for GC reasons.)
# There is a two-way correspondence:
#
#                   hash table, alist
#    Lisp function ------------------> index       array
#    Lisp function <------------------ index -----------------> trampoline
#                        array               <-----------------
#                                             trampoline_data()
#
# The index also has a reference count attached, in order to not generate
# several trampolines for different conversions of the same Lisp function.

# O(foreign_callin_table) is a hash table.
# O(foreign_callin_vector) is an extendable vector of size 3*n+1, of triples
# #(... lisp-function foreign-function reference-count ...).
#       3*index-2     3*index-1        3*index
# (The foreign-function itself contains the trampoline address.)
# Free triples are linked together to a free list like this:
# #(... nil           nil              next-index      ...)
#       3*index-2     3*index-1        3*index

# This variable is used to pass information from the trampoline to us.
  local void* trampvar;
  local void callback ();

# Convert a Lisp function to a C function.
# convert_function_to_foreign(address,resulttype,argtypes,flags)
# The real C function address is Faddress_value(TheFfunction(result)->ff_address).
# kann GC auslösen
  local object convert_function_to_foreign (object fun, object resulttype, object argtypes, object flags);
  local object convert_function_to_foreign(fun,resulttype,argtypes,flags)
    var reg5 object fun;
    var reg6 object resulttype;
    var reg7 object argtypes;
    var reg8 object flags;
    { # Convert to a function:
      subr_self = L(coerce); fun = coerce_function(fun);
      # If it is already a foreign function, return it immediately:
      if (ffunctionp(fun))
        { if (equal_fvd(resulttype,TheFfunction(fun)->ff_resulttype)
              && equal_argfvds(argtypes,TheFfunction(fun)->ff_argtypes)
              && eq(flags,TheFfunction(fun)->ff_flags)
             )
            { return fun; }
            else
            { pushSTACK(fun);
              //: DEUTSCH "~ kann nicht in eine Foreign-Funktion mit anderer Aufrufkonvention umgewandelt werden."
              //: ENGLISH "~ cannot be converted to a foreign function with another calling convention."
              //: FRANCAIS "~ ne peut être converti en une fonction étrangère avec une autre convention d'appel."
              fehler(error, GETTEXT("~ cannot be converted to a foreign function with another calling convention."));
        }   }
      # Look it up in the hash table, alist:
      { var reg2 object alist = gethash(fun,O(foreign_callin_table));
        if (!eq(alist,nullobj))
          { while (consp(alist))
              { var reg1 object acons = Car(alist);
                alist = Cdr(alist);
                if (equal_fvd(resulttype,Car(acons))
                    && equal_argfvds(argtypes,Car(Cdr(acons)))
                    && eq(flags,Car(Cdr(Cdr(acons))))
                   )
                  { var reg4 object index = Cdr(Cdr(Cdr(acons)));
                    var reg3 object* triple = &TheSvector(TheArray(O(foreign_callin_vector))->data)->data[3*posfixnum_to_L(index)-2];
                    triple[2] = fixnum_inc(triple[2],1); # increment reference count
                   {var reg2 object ffun = triple[1];
                    ASSERT(equal_fvd(resulttype,TheFfunction(ffun)->ff_resulttype));
                    ASSERT(equal_argfvds(argtypes,TheFfunction(ffun)->ff_argtypes));
                    ASSERT(eq(flags,TheFfunction(ffun)->ff_flags));
                    return ffun;
      }   }   }   }}
      # Not already in the hash table -> allocate new:
      pushSTACK(fun);
      pushSTACK(NIL);
      pushSTACK(resulttype);
      pushSTACK(argtypes);
      pushSTACK(flags);
      # First grab an index.
     {var reg2 uintL index = posfixnum_to_L(TheSvector(TheArray(O(foreign_callin_vector))->data)->data[0]);
      if (!(index == 0))
        # remove first index from the free list
        { var reg1 object dv = TheArray(O(foreign_callin_vector))->data;
          TheSvector(dv)->data[0] = TheSvector(dv)->data[3*index];
        }
        else
        # free list exhausted
        { var reg1 uintC i;
          dotimesC(i,3,
            { pushSTACK(NIL); pushSTACK(O(foreign_callin_vector));
              funcall(L(vector_push_extend),2);
            });
          index = floor(vector_length(O(foreign_callin_vector)),3);
        }
      # Next allocate the trampoline.
      {var reg3 void* trampoline = alloc_trampoline((__TR_function)&vacall,&trampvar,(void*)index);
       pushSTACK(make_faddress(O(fp_zero),(uintP)trampoline));
       # Now allocate the foreign-function.
       {var reg1 object obj = allocate_ffunction();
        TheFfunction(obj)->ff_name = NIL;
        TheFfunction(obj)->ff_address = popSTACK();
        TheFfunction(obj)->ff_resulttype = STACK_2;
        TheFfunction(obj)->ff_argtypes = STACK_1;
        TheFfunction(obj)->ff_flags = STACK_0;
        STACK_3 = obj;
      }}
      pushSTACK(fixnum(index)); funcall(L(liststern),4); pushSTACK(value1);
      # Stack layout: fun, obj, acons.
      # Put it into the hash table.
      { var reg1 object new_cons = allocate_cons();
        Car(new_cons) = popSTACK();
       {var reg2 object alist = gethash(STACK_1,O(foreign_callin_table));
        if (eq(alist,nullobj)) { alist = NIL; }
        Cdr(new_cons) = alist;
        shifthash(O(foreign_callin_table),STACK_1,new_cons);
      }}
      # Put it into the vector.
      {var reg1 object* triple = &TheSvector(TheArray(O(foreign_callin_vector))->data)->data[3*index-2];
       triple[1] = popSTACK(); # obj
       triple[0] = popSTACK(); # fun
       triple[2] = Fixnum_1; # refcount := 1
       return triple[1];
    }}}

# Undoes the allocation effect of convert_function_to_foreign().
  local void free_foreign_callin (void* address);
  local void free_foreign_callin(address)
    var reg7 void* address;
    { if (is_trampoline(address) # safety check
          && (trampoline_address(address) == (__TR_function)&vacall)
          && (trampoline_variable(address) == &trampvar)
         )
        { var reg9 uintL index = (uintL)trampoline_data(address);
          var reg3 object dv = TheArray(O(foreign_callin_vector))->data;
          var reg4 object* triple = &TheSvector(dv)->data[3*index-2];
          if (!nullp(triple[1])) # safety check
            { triple[2] = fixnum_inc(triple[2],-1); # decrement reference count
              if (eq(triple[2],Fixnum_0))
                { var reg8 object fun = triple[0];
                  var reg6 object ffun = triple[1];
                  # clear vector entry, put index onto free list:
                  triple[0] = NIL; triple[1] = NIL;
                  triple[2] = TheSvector(dv)->data[0];
                  TheSvector(dv)->data[0] = fixnum(index);
                  # remove from hash table entry:
                  { var reg5 object alist = gethash(fun,O(foreign_callin_table));
                    if (!eq(alist,nullobj)) # safety check
                      { # vgl. list.d:deleteq()
                        var reg2 object alist1 = alist;
                        var reg1 object alist2 = alist;
                        loop
                          { if (atomp(alist2)) break;
                            if (eq(Cdr(Cdr(Cdr(Car(alist2)))),fixnum(index)))
                              if (eq(alist2,alist))
                                { alist2 = alist1 = Cdr(alist2);
                                  shifthash(O(foreign_callin_table),fun,alist2);
                                }
                                else
                                { Cdr(alist1) = alist2 = Cdr(alist2); }
                              else
                                { alist1 = alist2; alist2 = Cdr(alist2); }
                  }   }   }
                  # free the trampoline:
                  free_trampoline(Faddress_value(TheFfunction(ffun)->ff_address));
    }   }   }   }


# Convert a C function to a Lisp foreign function.
# convert_function_from_foreign(address,resulttype,argtypes,flags)
  local object convert_function_from_foreign (void* address, object resulttype, object argtypes, object flags);
  local object convert_function_from_foreign(address,resulttype,argtypes,flags)
    var reg2 void* address;
    var reg6 object resulttype;
    var reg7 object argtypes;
    var reg5 object flags;
    { if (is_trampoline(address)
          && (trampoline_address(address) == (__TR_function)&vacall)
          && (trampoline_variable(address) == &trampvar)
         )
        { var reg4 uintL index = (uintL)trampoline_data(address);
          var reg3 object* triple = &TheSvector(TheArray(O(foreign_callin_vector))->data)->data[3*index-2];
          var reg1 object ffun = triple[1];
          if (equal_fvd(resulttype,TheFfunction(ffun)->ff_resulttype)
              && equal_argfvds(argtypes,TheFfunction(ffun)->ff_argtypes)
              && eq(flags,TheFfunction(ffun)->ff_flags)
             )
            { return ffun; }
            else
            { pushSTACK(ffun);
              //: DEUTSCH "~ kann nicht in eine Foreign-Funktion mit anderer Aufrufkonvention umgewandelt werden."
              //: ENGLISH "~ cannot be converted to a foreign function with another calling convention."
              //: FRANCAIS "~ ne peut être converti en une fonction étrangère avec une autre convention d'appel."
              fehler(error, GETTEXT("~ cannot be converted to a foreign function with another calling convention."));
            }
        }
      pushSTACK(argtypes);
      pushSTACK(resulttype);
      pushSTACK(make_faddress(O(fp_zero),(uintP)address));
     {var reg1 object obj = allocate_ffunction();
      TheFfunction(obj)->ff_name = NIL;
      TheFfunction(obj)->ff_address = popSTACK();
      TheFfunction(obj)->ff_resulttype = popSTACK();
      TheFfunction(obj)->ff_argtypes = popSTACK();
      TheFfunction(obj)->ff_flags = flags;
      return obj;
    }}


#if (long_bitsize<64)
  # 64-bit integers are passed as structs.
  #if BIG_ENDIAN_P
    typedef struct { uint32 hi; uint32 lo; } struct_uint64;
    typedef struct { sint32 hi; uint32 lo; } struct_sint64;
  #else
    typedef struct { uint32 lo; uint32 hi; } struct_uint64;
    typedef struct { uint32 lo; sint32 hi; } struct_sint64;
  #endif
#else
  #define struct_uint64  uint64
  #define struct_sint64  sint64
#endif

# malloc() with error check.
local void* xmalloc (uintL size);
#if !defined(AMIGAOS)
local void* xmalloc(size)
  var reg2 uintL size;
  { var reg1 void* ptr = malloc(size);
    if (ptr) return ptr;
    //: DEUTSCH "Speicherplatz reicht nicht für die Fremdsprachen-Schnittstelle."
    //: ENGLISH "No more room for foreign language interface"
    //: FRANCAIS "Il n'y a pas assez de place pour l'interface aux langages étrangers."
    fehler(storage_condition, GETTEXT("No more room for foreign language interface"));
  }
#else # defined(AMIGAOS)
# No malloc() is available. Disable malloc() and free() altogether.
nonreturning_function(global, fehler_malloc_free, (void));
global void fehler_malloc_free()
  { 
    //: DEUTSCH ":MALLOC-FREE ist unter AMIGAOS nicht verfügbar."
    //: ENGLISH ":MALLOC-FREE is not available under AMIGAOS."
    //: FRANCAIS ":MALLOC-FREE n'est pas applicable sous AMIGAOS."
    fehler(error, GETTEXT(":MALLOC-FREE is not available under AMIGAOS."));
  }
#define malloc(amount)  (fehler_malloc_free(), NULL)
#define free(pointer)  fehler_malloc_free()
#define xmalloc(size)  malloc(size)
#endif

# Compute the size and alignment of foreign data.
# foreign_layout(fvd);
# > fvd: foreign value descriptor
# < data_size, data_alignment: size and alignment (in bytes) of the type
# < data_splittable: splittable flag of the type, if a struct/union/array type
local void foreign_layout (object fvd);
local uintL data_size;
local uintL data_alignment;
local boolean data_splittable;
#define alignof(type)  offsetof(struct { char slot1; type slot2; }, slot2)
# `struct_alignment' is what gcc calls STRUCTURE_SIZE_BOUNDARY/8.
# It is = 1 on most machines, but = 2 on MC680X0 and = 4 on ARM.
#define struct_alignment  sizeof(struct { char slot1; })
local void foreign_layout(fvd)
  var reg1 object fvd;
  { check_SP();
    if (symbolp(fvd))
      { if (eq(fvd,S(nil)))
          { data_size = 0; data_alignment = 1;
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(boolean)))
          { data_size = sizeof(int); data_alignment = alignof(int);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(character)))
          { data_size = sizeof(unsigned char); data_alignment = alignof(unsigned char);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(char)) || eq(fvd,S(sint8)))
          { data_size = sizeof(sint8); data_alignment = alignof(sint8);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(uchar)) || eq(fvd,S(uint8)))
          { data_size = sizeof(uint8); data_alignment = alignof(uint8);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(short)) || eq(fvd,S(sint16)))
          { data_size = sizeof(sint16); data_alignment = alignof(sint16);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(ushort)) || eq(fvd,S(uint16)))
          { data_size = sizeof(uint16); data_alignment = alignof(uint16);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(sint32)))
          { data_size = sizeof(sint32); data_alignment = alignof(sint32);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(uint32)))
          { data_size = sizeof(uint32); data_alignment = alignof(uint32);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(sint64)))
          {
            #ifdef HAVE_LONGLONG
            data_size = sizeof(sint64); data_alignment = alignof(sint64);
            data_splittable = (long_bitsize<64 ? av_word_splittable_2(uint32,uint32) : av_word_splittable_1(uint64)); # always TRUE
            #else
            data_size = sizeof(struct_sint64); data_alignment = alignof(struct_sint64);
            data_splittable = av_word_splittable_2(uint32,uint32); # always TRUE
            #endif
            return;
          }
        elif (eq(fvd,S(uint64)))
          {
            #ifdef HAVE_LONGLONG
            data_size = sizeof(uint64); data_alignment = alignof(uint64);
            data_splittable = (long_bitsize<64 ? av_word_splittable_2(uint32,uint32) : av_word_splittable_1(uint64)); # always TRUE
            #else
            data_size = sizeof(struct_uint64); data_alignment = alignof(struct_uint64);
            data_splittable = av_word_splittable_2(uint32,uint32); # always TRUE
            #endif
            return;
          }
        elif (eq(fvd,S(int)))
          { data_size = sizeof(int); data_alignment = alignof(int);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(uint)))
          { data_size = sizeof(unsigned int); data_alignment = alignof(unsigned int);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(long)))
          { data_size = sizeof(long); data_alignment = alignof(long);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(ulong)))
          { data_size = sizeof(unsigned long); data_alignment = alignof(unsigned long);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(single_float)))
          { data_size = sizeof(float); data_alignment = alignof(float);
            data_splittable = (sizeof(float) <= sizeof(long)); return;
          }
        elif (eq(fvd,S(double_float)))
          { data_size = sizeof(double); data_alignment = alignof(double);
            data_splittable = (sizeof(double) <= sizeof(long)); return;
          }
        elif (eq(fvd,S(c_pointer)))
          { data_size = sizeof(void*); data_alignment = alignof(void*);
            data_splittable = TRUE; return;
          }
        elif (eq(fvd,S(c_string)))
          { data_size = sizeof(char*); data_alignment = alignof(char*);
            data_splittable = TRUE; return;
          }
      }
    elif (simple_vector_p(fvd))
      { var reg9 uintL fvdlen = TheSvector(fvd)->length;
        if (fvdlen > 0)
          { var reg2 object fvdtype = TheSvector(fvd)->data[0];
            if (eq(fvdtype,S(c_struct)) && (fvdlen > 2))
              { var reg3 uintL cumul_size = 0;
                var reg4 uintL cumul_alignment = struct_alignment;
                var reg6 boolean cumul_splittable = TRUE;
                var reg5 uintL i;
                for (i = 3; i < fvdlen; i++)
                  { foreign_layout(TheSvector(fvd)->data[i]);
                    # We assume all alignments are of the form 2^k.
                    cumul_size += (-cumul_size) & (data_alignment-1);
                    # cumul_splittable = cumul_splittable AND
                    #       (cumul_size..cumul_size+data_size-1) fits in a word;
                    if (floor(cumul_size,sizeof(long)) < floor(cumul_size+data_size-1,sizeof(long)))
                      cumul_splittable = FALSE;
                    cumul_size += data_size;
                    # cumul_alignment = lcm(cumul_alignment,data_alignment);
                    if (data_alignment > cumul_alignment)
                      cumul_alignment = data_alignment;
                  }
                cumul_size += (-cumul_size) & (cumul_alignment-1);
                data_size = cumul_size; data_alignment = cumul_alignment;
                data_splittable = cumul_splittable;
                return;
              }
            elif (eq(fvdtype,S(c_union)) && (fvdlen > 1))
              { var reg3 uintL cumul_size = 0;
                var reg4 uintL cumul_alignment = struct_alignment;
                var reg6 boolean cumul_splittable = FALSE;
                var reg5 uintL i;
                for (i = 2; i < fvdlen; i++)
                  { foreign_layout(TheSvector(fvd)->data[i]);
                    # We assume all alignments are of the form 2^k.
                    # cumul_size = max(cumul_size,data_size);
                    if (data_size > cumul_size)
                      cumul_size = data_size;
                    # cumul_alignment = lcm(cumul_alignment,data_alignment);
                    if (data_alignment > cumul_alignment)
                      cumul_alignment = data_alignment;
                    # cumul_splittable = cumul_splittable OR data_splittable;
                    if (data_splittable)
                      cumul_splittable = TRUE;
                  }
                data_size = cumul_size; data_alignment = cumul_alignment;
                data_splittable = cumul_splittable;
                return;
              }
            elif ((eq(fvdtype,S(c_array)) && (fvdlen > 1)) || (eq(fvdtype,S(c_array_max)) && (fvdlen == 3)))
              { var reg4 uintL i;
                foreign_layout(TheSvector(fvd)->data[1]);
                for (i = 2; i < fvdlen; i++)
                  { var reg3 object dim = TheSvector(fvd)->data[i];
                    if (!uint32_p(dim)) { fehler_foreign_type(fvd); }
                    data_size = data_size * I_to_uint32(dim);
                  }
                data_splittable = (data_size <= sizeof(long));
                return;
              }
            elif (eq(fvdtype,S(c_function)) && (fvdlen == 4))
              { data_size = sizeof(void*); data_alignment = alignof(void*);
                data_splittable = TRUE; return;
              }
            elif ((eq(fvdtype,S(c_ptr)) || eq(fvdtype,S(c_ptr_null)) || eq(fvdtype,S(c_array_ptr)))
                  && (fvdlen == 2))
              { data_size = sizeof(void*); data_alignment = alignof(void*);
                data_splittable = TRUE; return;
              }
      }   }
    fehler_foreign_type(fvd);
  }

# (FFI::%SIZEOF c-type) returns the size and alignment of a C type,
# measured in bytes.
LISPFUNN(sizeof,1)
  { var reg1 object fvd = popSTACK();
    foreign_layout(fvd);
    value1 = UL_to_I(data_size); value2 = fixnum(data_alignment); mv_count=2;
  }

# (FFI::%BITSIZEOF c-type) returns the size and alignment of a C type,
# measured in bits.
LISPFUNN(bitsizeof,1)
  { var reg1 object fvd = popSTACK();
    foreign_layout(fvd);
    value1 = UL_to_I(8*data_size); value2 = fixnum(8*data_alignment); mv_count=2;
  }

# Zero a block of memory.
local void blockzero (void* ptr, unsigned long size);
local void blockzero(ptr,size)
  var reg3 void* ptr;
  var reg2 unsigned long size;
  { if (size > 0)
      { if ((size % sizeof(long)) || ((uintP)ptr % sizeof(long)))
          { var reg1 char* p = (char*)ptr;
            do { *p++ = 0; } while (--size > 0);
          }
          else
          { var reg1 long* p = (long*)ptr;
            do { *p++ = 0; } while ((size -= sizeof(long)) > 0);
          }
  }   }

# Test a block of memory for zero.
local boolean blockzerop (void* ptr, unsigned long size);
local boolean blockzerop(ptr,size)
  var reg3 void* ptr;
  var reg2 unsigned long size;
  { if ((size % sizeof(long)) || ((uintP)ptr % sizeof(long)))
      { var reg1 char* p = (char*)ptr;
        do { if (!(*p++ == 0)) return FALSE; } while (--size > 0);
        return TRUE;
      }
      else
      { var reg1 long* p = (long*)ptr;
        do { if (!(*p++ == 0)) return FALSE; } while ((size -= sizeof(long)) > 0);
        return TRUE;
      }
  }

# Convert foreign data to Lisp data.
# kann GC auslösen
global object convert_from_foreign (object fvd, void* data);
  # Allocate an array corresponding to a foreign array.
  # kann GC auslösen
  local object convert_from_foreign_array_alloc (object dims, object eltype);
  local object convert_from_foreign_array_alloc(dims,eltype)
    var reg3 object dims;
    var reg1 object eltype;
    { var reg2 uintL argcount = 1;
      pushSTACK(dims);
      if (symbolp(eltype))
        { if (eq(eltype,S(character)))
            { pushSTACK(S(Kelement_type)); pushSTACK(S(string_char));
              argcount += 2;
            }
          elif (eq(eltype,S(uint8)))
            { pushSTACK(S(Kelement_type)); pushSTACK(O(type_uint8));
              argcount += 2;
            }
          #if 0
          elif (eq(eltype,S(sint8)))
            { pushSTACK(S(Kelement_type)); pushSTACK(O(type_sint8));
              argcount += 2;
            }
          #endif
          elif (eq(eltype,S(uint16)))
            { pushSTACK(S(Kelement_type)); pushSTACK(O(type_uint16));
              argcount += 2;
            }
          #if 0
          elif (eq(eltype,S(sint16)))
            { pushSTACK(S(Kelement_type)); pushSTACK(O(type_sint16));
              argcount += 2;
            }
          #endif
          elif (eq(eltype,S(uint32)))
            { pushSTACK(S(Kelement_type)); pushSTACK(O(type_uint32));
              argcount += 2;
            }
          #if 0
          elif (eq(eltype,S(sint32)))
            { pushSTACK(S(Kelement_type)); pushSTACK(O(type_sint32));
              argcount += 2;
            }
          #endif
        }
      funcall(L(make_array),argcount);
      return value1;
    }
  # Fill a specialized Lisp array with foreign data.
  local void convert_from_foreign_array_fill (object eltype, uintL size, object array, void* data);
  local void convert_from_foreign_array_fill(eltype,size,array,data)
    var reg1 object eltype;
    var reg1 uintL size;
    var reg1 object array;
    var reg1 void* data;
    { if (eq(eltype,S(character)))
        { var reg5 uintB* ptr1 = (uintB*)data;
          var reg4 uintB* ptr2 = &TheSstring(array)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      elif (eq(eltype,S(uint8)))
        { var reg5 uint8* ptr1 = (uint8*)data;
          var reg4 uint8* ptr2 = (uint8*)&TheSbvector(TheArray(array)->data)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      #if 0
      elif (eq(eltype,S(sint8)))
        { var reg5 sint8* ptr1 = (sint8*)data;
          var reg4 sint8* ptr2 = (sint8*)&TheSbvector(TheArray(array)->data)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      #endif
      elif (eq(eltype,S(uint16)))
        { var reg5 uint16* ptr1 = (uint16*)data;
          var reg4 uint16* ptr2 = (uint16*)&TheSbvector(TheArray(array)->data)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      #if 0
      elif (eq(eltype,S(sint16)))
        { var reg5 sint16* ptr1 = (sint16*)data;
          var reg4 sint16* ptr2 = (sint16*)&TheSbvector(TheArray(array)->data)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      #endif
      elif (eq(eltype,S(uint32)))
        { var reg5 uint32* ptr1 = (uint32*)data;
          var reg4 uint32* ptr2 = (uint32*)&TheSbvector(TheArray(array)->data)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      #if 0
      elif (eq(eltype,S(sint32)))
        { var reg5 sint32* ptr1 = (sint32*)data;
          var reg4 sint32* ptr2 = (sint32*)&TheSbvector(TheArray(array)->data)->data[0];
          dotimesL(size,size, { *ptr2++ = *ptr1++; } );
        }
      #endif
      else
        { NOTREACHED }
    }
global object convert_from_foreign(fvd,data)
  var reg1 object fvd;
  var reg3 void* data;
  { check_SP();
    check_STACK();
    if (symbolp(fvd))
      { if (eq(fvd,S(nil)))
          # If we are presented the empty type, we take it as "ignore"
          # and return NIL.
          { return NIL; }
        elif (eq(fvd,S(boolean)))
          { var reg2 int* pdata = (int*)data;
            return (*pdata ? T : NIL);
          }
        elif (eq(fvd,S(character)))
          { var reg2 uintB* pdata = (unsigned char *)data;
            return code_char(*pdata);
          }
        elif (eq(fvd,S(char)) || eq(fvd,S(sint8)))
          { var reg2 sint8* pdata = (sint8*)data;
            return sint8_to_I(*pdata);
          }
        elif (eq(fvd,S(uchar)) || eq(fvd,S(uint8)))
          { var reg2 uint8* pdata = (uint8*)data;
            return uint8_to_I(*pdata);
          }
        elif (eq(fvd,S(short)) || eq(fvd,S(sint16)))
          { var reg2 sint16* pdata = (sint16*)data;
            return sint16_to_I(*pdata);
          }
        elif (eq(fvd,S(ushort)) || eq(fvd,S(uint16)))
          { var reg2 uint16* pdata = (uint16*)data;
            return uint16_to_I(*pdata);
          }
        elif (eq(fvd,S(sint32)))
          { var reg2 sint32* pdata = (sint32*)data;
            return sint32_to_I(*pdata);
          }
        elif (eq(fvd,S(uint32)))
          { var reg2 uint32* pdata = (uint32*)data;
            return uint32_to_I(*pdata);
          }
        elif (eq(fvd,S(sint64)))
          { var reg2 struct_sint64* pdata = (struct_sint64*)data;
            #ifdef HAVE_LONGLONG
            var reg5 sint64 val;
            #if (long_bitsize<64)
            val = ((sint64)(pdata->hi)<<32) | (sint64)(pdata->lo);
            #else
            val = *pdata;
            #endif
            return sint64_to_I(val);
            #else
            return L2_to_I(pdata->hi,pdata->lo);
            #endif
          }
        elif (eq(fvd,S(uint64)))
          { var reg2 struct_uint64* pdata = (struct_uint64*)data;
            #ifdef HAVE_LONGLONG
            var reg5 uint64 val;
            #if (long_bitsize<64)
            val = ((uint64)(pdata->hi)<<32) | (uint64)(pdata->lo);
            #else
            val = *pdata;
            #endif
            return uint64_to_I(val);
            #else
            return UL2_to_I(pdata->hi,pdata->lo);
            #endif
          }
        elif (eq(fvd,S(int)))
          { var reg2 int* pdata = (int*)data;
            return sint_to_I(*pdata);
          }
        elif (eq(fvd,S(uint)))
          { var reg2 unsigned int * pdata = (unsigned int *)data;
            return uint_to_I(*pdata);
          }
        elif (eq(fvd,S(long)))
          { var reg2 long* pdata = (long*)data;
            return slong_to_I(*pdata);
          }
        elif (eq(fvd,S(ulong)))
          { var reg2 unsigned long * pdata = (unsigned long *)data;
            return ulong_to_I(*pdata);
          }
        elif (eq(fvd,S(single_float)))
          { var reg2 ffloatjanus* pdata = (ffloatjanus*) data;
            return c_float_to_FF(pdata);
          }
        elif (eq(fvd,S(double_float)))
          { var reg2 dfloatjanus* pdata = (dfloatjanus*) data;
            return c_double_to_DF(pdata);
          }
        elif (eq(fvd,S(c_pointer)))
          { return make_faddress(O(fp_zero),(uintP)(*(void* *) data)); }
        elif (eq(fvd,S(c_string)))
          { var reg2 const char * asciz = *(const char * *) data;
            if (asciz == NULL)
              { return NIL; }
              else
              { return asciz_to_string(asciz); }
          }
      }
    elif (simple_vector_p(fvd))
      { var reg8 uintL fvdlen = TheSvector(fvd)->length;
        if (fvdlen > 0)
          { var reg2 object fvdtype = TheSvector(fvd)->data[0];
            if (eq(fvdtype,S(c_struct)) && (fvdlen > 2))
              { pushSTACK(fvd);
                { var reg8 object* fvd_ = &STACK_0;
                  var reg5 uintL cumul_size = 0;
                  var reg6 uintL cumul_alignment = struct_alignment;
                  var reg7 uintL i;
                  for (i = 3; i < fvdlen; i++)
                    { var reg4 object fvdi = TheSvector(*fvd_)->data[i];
                      foreign_layout(fvdi);
                      # We assume all alignments are of the form 2^k.
                      cumul_size += (-cumul_size) & (data_alignment-1);
                     {var reg9 void* pdata = (char*)data + cumul_size;
                      cumul_size += data_size;
                      # cumul_alignment = lcm(cumul_alignment,data_alignment);
                      if (data_alignment > cumul_alignment)
                        cumul_alignment = data_alignment;
                      # Now we are finished with data_size and data_alignment.
                      # Convert the structure slot:
                      fvdi = convert_from_foreign(fvdi,pdata);
                      pushSTACK(fvdi);
                    }}
                  # Call the constructor.
                  funcall(TheSvector(*fvd_)->data[2],fvdlen-3);
                }
                skipSTACK(1);
                return value1;
              }
            elif (eq(fvdtype,S(c_union)) && (fvdlen > 1))
              { 
                # Use the union's first component.
                return convert_from_foreign(fvdlen > 2 ? TheSvector(fvd)->data[2] : NIL, data);
              }
            elif (eq(fvdtype,S(c_array)) && (fvdlen > 1))
              { pushSTACK(fvd);
                # Allocate the resulting array: (MAKE-ARRAY dims :element-type ...)
               {var reg10 object dims = Cdr(Cdr((coerce_sequence(fvd,S(list)),value1)));
                var reg10 object array = convert_from_foreign_array_alloc(dims,TheSvector(STACK_0)->data[1]);
                # Fill the resulting array.
                # Only a single loop is needed since C and Lisp both store the
                # elements in row-major order.
                { var reg7 object eltype = TheSvector(STACK_0)->data[1];
                  var reg9 uintL eltype_size = (foreign_layout(eltype), data_size);
                  STACK_0 = eltype;
                 {var reg6 uintL size = array_total_size(array);
                  pushSTACK(array);
                  if (!vectorp(array))
                    { array = TheArray(array)->data; } # fetch the data vector
                  if (!simple_vector_p(array))
                    # Fill specialized array.
                    { convert_from_foreign_array_fill(eltype,size,array,data); }
                    else
                    # Fill general array.
                    # SYS::ROW-MAJOR-STORE is equivalent to SETF SVREF here.
                    { pushSTACK(array);
                     {var reg4 char* pdata = (char*)data;
                      var reg5 uintL i;
                      for (i = 0; i < size; i++, pdata += eltype_size)
                        { # pdata = (char*)data + i*eltype_size
                          var reg1 object el = convert_from_foreign(STACK_2,(void*)pdata);
                          TheSvector(STACK_0)->data[i] = el;
                        }
                      skipSTACK(1);
                    }}
                  array = popSTACK();
                }}
                skipSTACK(1);
                return array;
              }}
            elif (eq(fvdtype,S(c_array_max)) && (fvdlen == 3))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg7 uintL eltype_size = (foreign_layout(eltype), data_size);
                if (eltype_size == 0)
                  { pushSTACK(fvd);
                    //: DEUTSCH "Elementtyp hat Größe 0: ~"
                    //: ENGLISH "element type has size 0: ~"
                    //: FRANCAIS "Le type des éléments est de grandeur 0 : ~"
                    fehler(error, GETTEXT("element type has size 0: ~"));
                  }
                # Determine length of array:
               {var reg5 uintL len = 0;
                { var reg4 uintL maxdim = I_to_UL(TheSvector(fvd)->data[2]);
                  var reg2 void* ptr = data;
                  until ((len == maxdim) || blockzerop(ptr,eltype_size))
                    { ptr = (void*)((uintP)ptr + eltype_size); len++; }
                }
                pushSTACK(eltype);
                # Allocate the resulting array:
                { var reg7 object array = convert_from_foreign_array_alloc(UL_to_I(len),eltype);
                  # Fill the resulting array.
                  if (!simple_vector_p(array))
                    # Fill specialized array.
                    { convert_from_foreign_array_fill(STACK_0,len,array,data); }
                    else
                    # Fill general array, using SYS::SVSTORE.
                    { pushSTACK(array);
                     {var reg4 char* pdata = (char*)data;
                      var reg5 uintL i;
                      for (i = 0; i < len; i++, pdata += eltype_size)
                        { # pdata = (char*)data + i*eltype_size
                          pushSTACK(STACK_0); # array
                          pushSTACK(fixnum(i));
                          pushSTACK(convert_from_foreign(STACK_(1+2),(void*)pdata));
                          funcall(L(svstore),3);
                        }
                      array = popSTACK();
                    }}
                  skipSTACK(1);
                  return array;
              }}}
            elif (eq(fvdtype,S(c_function)) && (fvdlen == 4))
              { if (*(void**)data == NULL)
                  return NIL;
                else
                  return convert_function_from_foreign(*(void**)data,
                                                       TheSvector(fvd)->data[1],
                                                       TheSvector(fvd)->data[2],
                                                       TheSvector(fvd)->data[3]
                                                      );
              }
            elif ((eq(fvdtype,S(c_ptr)) || eq(fvdtype,S(c_ptr_null))) && (fvdlen == 2))
              { if (*(void**)data == NULL)
                  return NIL;
                else
                  return convert_from_foreign(TheSvector(fvd)->data[1], *(void**)data);
              }
            elif (eq(fvdtype,S(c_array_ptr)) && (fvdlen == 2))
              { if (*(void**)data == NULL)
                  return NIL;
                else
                  { var reg9 object eltype = TheSvector(fvd)->data[1];
                    var reg7 uintL eltype_size = (foreign_layout(eltype), data_size);
                    if (eltype_size == 0)
                      { pushSTACK(fvd);
                        //: DEUTSCH "Elementtyp hat Größe 0: ~"
                        //: ENGLISH "element type has size 0: ~"
                        //: FRANCAIS "Le type des éléments est de grandeur 0 : ~"
                        fehler(error, GETTEXT("element type has size 0: ~"));
                      }
                    # Determine length of array:
                   {var reg5 uintL len = 0;
                    { var reg4 void* ptr = *(void**)data;
                      until (blockzerop(ptr,eltype_size))
                        { ptr = (void*)((uintP)ptr + eltype_size); len++; }
                    }
                    pushSTACK(eltype);
                    # Allocate Lisp array:
                    pushSTACK(allocate_vector(len));
                    # Fill Lisp array:
                    { var reg4 void* ptr = *(void**)data;
                      var reg6 uintL i;
                      for (i = 0; i < len; i++)
                        { var reg5 object obj = convert_from_foreign(STACK_1,ptr);
                          TheSvector(STACK_0)->data[i] = obj;
                          ptr = (void*)((uintP)ptr + eltype_size);
                    }   }
                    { var reg4 object result = STACK_0;
                      skipSTACK(2);
                      return result;
              }   }}}
      }   }
    fehler_foreign_type(fvd);
  }

# Test whether a foreign type contained C-PTRs (recursively).
local boolean foreign_with_pointers_p (object fvd);
local boolean foreign_with_pointers_p(fvd)
  var reg1 object fvd;
  { check_SP();
    if (symbolp(fvd))
      { if (eq(fvd,S(c_string))) return TRUE;
        return FALSE;
      }
    elif (simple_vector_p(fvd))
      { var reg4 uintL fvdlen = TheSvector(fvd)->length;
        if (fvdlen > 0)
          { var reg2 object fvdtype = TheSvector(fvd)->data[0];
            if (eq(fvdtype,S(c_struct)) && (fvdlen > 2))
              { var reg3 uintL i;
                for (i = 3; i < fvdlen; i++)
                  if (foreign_with_pointers_p(TheSvector(fvd)->data[i]))
                    return TRUE;
                return FALSE;
              }
            elif (eq(fvdtype,S(c_union)) && (fvdlen > 1))
              { # Use the union's first component.
                return foreign_with_pointers_p(fvdlen > 2 ? TheSvector(fvd)->data[2] : NIL);
              }
            elif ((eq(fvdtype,S(c_array)) && (fvdlen > 1)) || (eq(fvdtype,S(c_array_max)) && (fvdlen == 3)))
              { var reg3 uintL i;
                for (i = 2; i < fvdlen; i++)
                  if (eq(TheSvector(fvd)->data[i],Fixnum_0))
                    return FALSE;
                return foreign_with_pointers_p(TheSvector(fvd)->data[1]);
              }
            elif (eq(fvdtype,S(c_function)) && (fvdlen == 4))
              { return TRUE; }
            elif ((eq(fvdtype,S(c_ptr)) || eq(fvdtype,S(c_ptr_null)) || eq(fvdtype,S(c_array_ptr)))
                  && (fvdlen == 2))
              { return TRUE; }
      }   }
    fehler_foreign_type(fvd);
  }

# Walk foreign data, giving special attention to the pointers.
local void walk_foreign_pointers (object fvd, void* data);
# Some flags and hooks that direct the walk:
local boolean walk_foreign_null_terminates;
local void (*walk_foreign_pre_hook) (object fvd, void** pdata); # what's the meaning of fvd here??
local void (*walk_foreign_post_hook) (object fvd, void** pdata); # what's the meaning of fvd here??
local void (*walk_foreign_function_hook) (object fvd, void** pdata);
local void walk_foreign_pointers(fvd,data)
  var reg1 object fvd;
  var reg3 void* data;
  { if (!foreign_with_pointers_p(fvd))
      return;
    check_SP();
    if (symbolp(fvd))
      { if (eq(fvd,S(c_string)))
          { if (walk_foreign_null_terminates)
              # NULL pointers stop the recursion
              { if (*(void**)data == NULL) return; }
            (*walk_foreign_pre_hook)(fvd,(void**)data);
            (*walk_foreign_post_hook)(fvd,(void**)data);
            return;
      }   }
    elif (simple_vector_p(fvd))
      { var reg8 uintL fvdlen = TheSvector(fvd)->length;
        if (fvdlen > 0)
          { var reg2 object fvdtype = TheSvector(fvd)->data[0];
            if (eq(fvdtype,S(c_struct)) && (fvdlen > 2))
              { var reg4 uintL cumul_size = 0;
                var reg5 uintL cumul_alignment = struct_alignment;
                var reg6 uintL i;
                for (i = 3; i < fvdlen; i++)
                  { var reg7 object fvdi = TheSvector(fvd)->data[i];
                    foreign_layout(fvdi);
                    # We assume all alignments are of the form 2^k.
                    cumul_size += (-cumul_size) & (data_alignment-1);
                   {var reg9 void* pdata = (char*)data + cumul_size;
                    cumul_size += data_size;
                    # cumul_alignment = lcm(cumul_alignment,data_alignment);
                    if (data_alignment > cumul_alignment)
                      cumul_alignment = data_alignment;
                    # Now we are finished with data_size and data_alignment.
                    # Descend into the structure slot:
                    walk_foreign_pointers(fvdi,pdata);
                  }}
                return;
              }
            elif (eq(fvdtype,S(c_union)) && (fvdlen > 1))
              { # Use the union's first component.
                if (fvdlen > 2)
                  walk_foreign_pointers(TheSvector(fvd)->data[2],data);
                return;
              }
            elif (eq(fvdtype,S(c_array)) && (fvdlen > 1))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg7 uintL eltype_size = (foreign_layout(eltype), data_size);
                var reg6 uintL size = 1;
                { var reg5 uintL i;
                  for (i = 2; i < fvdlen; i++)
                    { var reg4 object dim = TheSvector(fvd)->data[i];
                      if (!uint32_p(dim)) { fehler_foreign_type(fvd); }
                      size = size * I_to_uint32(dim);
                }   }
                { var reg4 uintL i;
                  var reg5 char* pdata = (char*)data;
                  for (i = 0; i < size; i++, pdata += eltype_size)
                    { # pdata = (char*)data + i*eltype_size
                      walk_foreign_pointers(eltype,pdata);
                }   }
                return;
              }
            elif (eq(fvdtype,S(c_array_max)) && (fvdlen == 3))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg7 uintL eltype_size = (foreign_layout(eltype), data_size);
                if (eltype_size == 0)
                  { pushSTACK(fvd);
                    //: DEUTSCH "Elementtyp hat Größe 0: ~"
                    //: ENGLISH "element type has size 0: ~"
                    //: FRANCAIS "Le type des éléments est de grandeur 0 : ~"
                    fehler(error, GETTEXT("element type has size 0: ~"));
                  }
                { var reg6 uintL maxdim = I_to_UL(TheSvector(fvd)->data[2]);
                  var reg5 uintL len = 0;
                  var reg4 void* ptr = data;
                  until ((len == maxdim) || blockzerop(ptr,eltype_size))
                    { walk_foreign_pointers(eltype,ptr);
                      ptr = (void*)((uintP)ptr + eltype_size); len++;
                }   }
                return;
              }
            elif (eq(fvdtype,S(c_function)) && (fvdlen == 4))
              { (*walk_foreign_function_hook)(fvd,(void**)data);
                return;
              }
            elif ((eq(fvdtype,S(c_ptr)) || eq(fvdtype,S(c_ptr_null))) && (fvdlen == 2))
              { if (walk_foreign_null_terminates)
                  # NULL pointers stop the recursion
                  { if (*(void**)data == NULL) return; }
                fvd = TheSvector(fvd)->data[1];
                (*walk_foreign_pre_hook)(fvd,(void**)data);
                walk_foreign_pointers(fvd,*(void**)data);
                (*walk_foreign_post_hook)(fvd,(void**)data);
                return;
              }
            elif (eq(fvdtype,S(c_array_ptr)) && (fvdlen == 2))
              { if (walk_foreign_null_terminates)
                  # NULL pointers stop the recursion
                  { if (*(void**)data == NULL) return; }
               {var reg6 object elfvd = TheSvector(fvd)->data[1];
                (*walk_foreign_pre_hook)(elfvd,(void**)data);
                { var reg5 uintL eltype_size = (foreign_layout(elfvd), data_size);
                  if (eltype_size == 0)
                    { pushSTACK(fvd);
                      //: DEUTSCH "Elementtyp hat Größe 0: ~"
                      //: ENGLISH "element type has size 0: ~"
                      //: FRANCAIS "Le type des éléments est de grandeur 0 : ~"
                      fehler(error, GETTEXT("element type has size 0: ~"));
                    }
                 {var reg4 void* ptr = *(void**)data;
                  until (blockzerop(ptr,eltype_size))
                    { walk_foreign_pointers(elfvd,ptr);
                      ptr = (void*)((uintP)ptr + eltype_size);
                }}  }
                (*walk_foreign_post_hook)(elfvd,(void**)data);
                return;
              }}
      }   }
    fehler_foreign_type(fvd);
  }

# Free the storage used by foreign data.
global void free_foreign (object fvd, void* data);
local void free_walk_pre (object fvd, void** pdata);
local void free_walk_post (object fvd, void** pdata);
local void free_walk_function (object fvd, void** pdata);
local void free_walk_pre(fvd,pdata)
  var reg1 object fvd;
  var reg2 void** pdata;
  { }
local void free_walk_post(fvd,pdata)
  var reg2 object fvd;
  var reg1 void** pdata;
  { free(*pdata);
    *pdata = NULL; # for safety
  }
local void free_walk_function(fvd,pdata)
  var reg2 object fvd;
  var reg1 void** pdata;
  { free_foreign_callin(*pdata);
    *pdata = NULL; # for safety
  }
global void free_foreign(fvd,data)
  var reg1 object fvd;
  var reg2 void* data;
  { walk_foreign_null_terminates = TRUE;
    walk_foreign_pre_hook = &free_walk_pre;
    walk_foreign_post_hook = &free_walk_post;
    walk_foreign_function_hook = &free_walk_function;
    walk_foreign_pointers(fvd,data);
  }

# Walk Lisp data, giving special attention to the pointers.
# kann GC auslösen
local void walk_lisp_pointers (object fvd, object obj);
# Some flags and hooks that direct the walk:
local boolean walk_lisp_nil_terminates;
local void (*walk_lisp_pre_hook) (object fvd, object obj);
local void (*walk_lisp_post_hook) (object fvd, object obj);
local void (*walk_lisp_function_hook) (object fvd, object obj);
local void walk_lisp_pointers(fvd,obj)
  var reg1 object fvd;
  var reg3 object obj;
  { if (!foreign_with_pointers_p(fvd))
      return;
    check_SP();
    check_STACK();
    if (symbolp(fvd))
      { if (eq(fvd,S(c_string)))
          { if (walk_lisp_nil_terminates)
              # NIL pointers stop the recursion
              { if (nullp(obj)) return; }
            if (!stringp(obj)) goto bad_obj;
            (*walk_lisp_pre_hook)(fvd,obj);
            (*walk_lisp_post_hook)(fvd,obj);
            return;
      }   }
    elif (simple_vector_p(fvd))
      { var reg8 uintL fvdlen = TheSvector(fvd)->length;
        if (fvdlen > 0)
          { var reg2 object fvdtype = TheSvector(fvd)->data[0];
            if (eq(fvdtype,S(c_struct)) && (fvdlen > 2))
              { var reg8 object slots = TheSvector(fvd)->data[1];
                var reg8 object constructor = TheSvector(fvd)->data[2];
                if (!(simple_vector_p(slots) && (TheSvector(slots)->length==fvdlen-3)))
                  { fehler_foreign_type(fvd); }
                if (eq(constructor,L(vector)))
                  { if (!(simple_vector_p(obj) && (TheSvector(obj)->length==fvdlen-3)))
                      goto bad_obj;
                  }
                elif (eq(constructor,L(list)))
                  { }
                else
                  { if (!(structurep(obj) || instancep(obj)))
                      goto bad_obj;
                  }
                pushSTACK(constructor);
                pushSTACK(slots);
                pushSTACK(fvd);
                pushSTACK(obj);
               {var reg4 uintL cumul_size = 0;
                var reg5 uintL cumul_alignment = struct_alignment;
                var reg6 uintL i;
                for (i = 3; i < fvdlen; i++)
                  { var reg8 object obji;
                    if (eq(STACK_3,L(vector)))
                      { obji = TheSvector(STACK_0)->data[i-3]; }
                    elif (eq(STACK_3,L(list)))
                      { obji = STACK_0;
                        if (atomp(obji)) goto bad_obj;
                        STACK_0 = Cdr(obji); obji = Car(obji);
                      }
                    else # simple_vector_p(slots) && (TheSvector(slots)->length==fvdlen-3)
                      { pushSTACK(STACK_0); pushSTACK(TheSvector(STACK_(2+1))->data[i-3]);
                        funcall(L(slot_value),2); obji = value1;
                      }
                    { var reg7 object fvdi = TheSvector(STACK_1)->data[i];
                      foreign_layout(fvdi);
                      # We assume all alignments are of the form 2^k.
                      cumul_size += (-cumul_size) & (data_alignment-1);
                      cumul_size += data_size;
                      # cumul_alignment = lcm(cumul_alignment,data_alignment);
                      if (data_alignment > cumul_alignment)
                        cumul_alignment = data_alignment;
                      # Now we are finished with data_size and data_alignment.
                      # Descend into the structure slot:
                      walk_lisp_pointers(fvdi,obji);
                  } }
                skipSTACK(4);
                return;
              }}
            elif (eq(fvdtype,S(c_union)) && (fvdlen > 1))
              { # Use the union's first component.
                if (fvdlen > 2)
                  walk_lisp_pointers(TheSvector(fvd)->data[2],obj);
                return;
              }
            elif (eq(fvdtype,S(c_array)) && (fvdlen > 1))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg6 uintL size = 1;
                foreign_layout(eltype);
                { var reg5 uintL i;
                  for (i = 2; i < fvdlen; i++)
                    { var reg4 object dim = TheSvector(fvd)->data[i];
                      if (!uint32_p(dim)) { fehler_foreign_type(fvd); }
                      size = size * I_to_uint32(dim);
                }   }
                if (!(arrayp(obj) && array_total_size(obj)==size))
                  goto bad_obj;
                pushSTACK(eltype);
                pushSTACK(obj);
                { var reg4 uintL i;
                  for (i = 0; i < size; i++)
                    { pushSTACK(STACK_0); pushSTACK(fixnum(i));
                      funcall(L(row_major_aref),2);
                      walk_lisp_pointers(STACK_1,value1);
                }   }
                skipSTACK(2);
                return;
              }
            elif (eq(fvdtype,S(c_array_max)) && (fvdlen == 3))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg6 uintL maxdim = I_to_UL(TheSvector(fvd)->data[2]);
                foreign_layout(eltype);
                if (!vectorp(obj))
                  goto bad_obj;
               {var reg5 uintL len = vector_length(obj);
                if (len > maxdim) { len = maxdim; }
                pushSTACK(eltype);
                pushSTACK(obj);
                { var reg4 uintL i;
                  for (i = 0; i < len; i++)
                    { pushSTACK(STACK_0); pushSTACK(fixnum(i));
                      funcall(L(aref),2);
                      walk_lisp_pointers(STACK_1,value1);
                }   }
                skipSTACK(2);
                return;
              }}
            elif (eq(fvdtype,S(c_function)) && (fvdlen == 4))
              { (*walk_lisp_function_hook)(fvd,obj);
                return;
              }
            elif ((eq(fvdtype,S(c_ptr)) || eq(fvdtype,S(c_ptr_null))) && (fvdlen == 2))
              { if (walk_lisp_nil_terminates)
                  # NIL pointers stop the recursion
                  { if (nullp(obj)) return; }
                (*walk_lisp_pre_hook)(fvd,obj);
                pushSTACK(fvd);
                walk_lisp_pointers(TheSvector(fvd)->data[1],obj);
                fvd = popSTACK();
                (*walk_lisp_post_hook)(fvd,obj);
                return;
              }
            elif (eq(fvdtype,S(c_array_ptr)) && (fvdlen == 2))
              { if (walk_lisp_nil_terminates)
                  # NIL pointers stop the recursion
                  { if (nullp(obj)) return; }
                if (!vectorp(obj)) goto bad_obj;
                (*walk_lisp_pre_hook)(fvd,obj);
                pushSTACK(fvd);
                pushSTACK(TheSvector(fvd)->data[1]); # eltype
                pushSTACK(obj);
                { var reg5 uintL size = vector_length(obj);
                  var reg4 uintL i;
                  for (i = 0; i < size; i++)
                    { pushSTACK(STACK_0); pushSTACK(fixnum(i));
                      funcall(L(aref),2);
                      walk_lisp_pointers(STACK_1,value1);
                }   }
                skipSTACK(2);
                fvd = popSTACK();
                (*walk_lisp_post_hook)(fvd,obj);
                return;
              }
      }   }
    fehler_foreign_type(fvd);
   bad_obj:
    fehler_convert(fvd,obj);
  }

# Determine amount of additional storage needed to convert Lisp data to foreign data.
# kann GC auslösen
local void convert_to_foreign_needs (object fvd, object obj);
local uintL walk_counter;
local uintL walk_alignment;
local void count_walk_pre (object fvd, object obj);
local void count_walk_post (object fvd, object obj);
local void count_walk_pre(fvd,obj)
  var reg1 object fvd;
  var reg4 object obj;
  { var reg3 uintL size;
    var reg2 uintL alignment;
    if (eq(fvd,S(c_string)))
      { size = (nullp(obj) ? 0 : vector_length(obj)+1); alignment = 1; }
      else # fvd = #(c-ptr ...) or #(c-ptr-null ...) or #(c-array-ptr ...)
      { foreign_layout(TheSvector(fvd)->data[1]);
        size = data_size; alignment = data_alignment;
      }
    walk_counter = ((walk_counter + alignment-1) & -alignment) + size;
    # walk_alignment = lcm(walk_alignment,alignment);
    if (alignment > walk_alignment)
      walk_alignment = alignment;
  }
local void count_walk_post(fvd,obj)
  var reg1 object fvd;
  var reg2 object obj;
  { }
local void convert_to_foreign_needs(fvd,obj)
  var reg1 object fvd;
  var reg2 object obj;
  { walk_lisp_nil_terminates = TRUE;
    walk_counter = 0; walk_alignment = 1;
    walk_lisp_pre_hook = &count_walk_pre;
    walk_lisp_post_hook = &count_walk_post;
    walk_lisp_function_hook = &count_walk_post;
    walk_lisp_pointers(fvd,obj);
    data_size = walk_counter; data_alignment = walk_alignment;
  }

# Convert Lisp data to foreign data. Storage is allocated through converter_malloc().
# Only the toplevel storage must already exist; its address is given.
# kann GC auslösen
local void convert_to_foreign (object fvd, object obj, void* data);
local void* (*converter_malloc) (void* old_data, uintL size, uintL alignment);
local void convert_to_foreign(fvd,obj,data)
  var reg9 object fvd;
  var reg9 object obj;
  var reg9 void* data;
  { check_SP();
    check_STACK();
    if (symbolp(fvd))
      { if (eq(fvd,S(nil)))
          # If we are presented the empty type, we take it as "ignore".
          { return; }
        elif (eq(fvd,S(boolean)))
          { var reg2 int* pdata = (int*)data;
            if (eq(obj,NIL)) { *pdata = 0; }
            elif (eq(obj,T)) { *pdata = 1; }
            else goto bad_obj;
            return;
          }
        elif (eq(fvd,S(character)))
          { var reg2 uintB* pdata = (unsigned char *)data;
            if (!string_char_p(obj)) goto bad_obj;
            *pdata = char_code(obj);
            return;
          }
        elif (eq(fvd,S(char)) || eq(fvd,S(sint8)))
          { var reg2 sint8* pdata = (sint8*)data;
            if (!sint8_p(obj)) goto bad_obj;
            *pdata = I_to_sint8(obj);
            return;
          }
        elif (eq(fvd,S(uchar)) || eq(fvd,S(uint8)))
          { var reg2 uint8* pdata = (uint8*)data;
            if (!uint8_p(obj)) goto bad_obj;
            *pdata = I_to_uint8(obj);
            return;
          }
        elif (eq(fvd,S(short)) || eq(fvd,S(sint16)))
          { var reg2 sint16* pdata = (sint16*)data;
            if (!sint16_p(obj)) goto bad_obj;
            *pdata = I_to_sint16(obj);
            return;
          }
        elif (eq(fvd,S(ushort)) || eq(fvd,S(uint16)))
          { var reg2 uint16* pdata = (uint16*)data;
            if (!uint16_p(obj)) goto bad_obj;
            *pdata = I_to_uint16(obj);
            return;
          }
        elif (eq(fvd,S(sint32)))
          { var reg2 sint32* pdata = (sint32*)data;
            if (!sint32_p(obj)) goto bad_obj;
            *pdata = I_to_sint32(obj);
            return;
          }
        elif (eq(fvd,S(uint32)))
          { var reg2 uint32* pdata = (uint32*)data;
            if (!uint32_p(obj)) goto bad_obj;
            *pdata = I_to_uint32(obj);
            return;
          }
        #ifdef HAVE_LONGLONG
        elif (eq(fvd,S(sint64)))
          { var reg2 struct_sint64* pdata = (struct_sint64*)data;
            if (!sint64_p(obj)) goto bad_obj;
           {var reg5 sint64 val = I_to_sint64(obj);
            #if (long_bitsize<64)
            pdata->hi = (sint32)(val>>32); pdata->lo = (uint32)val;
            #else
            *pdata = val;
            #endif
            return;
          }}
        elif (eq(fvd,S(uint64)))
          { var reg2 struct_uint64* pdata = (struct_uint64*)data;
            if (!uint64_p(obj)) goto bad_obj;
           {var reg5 uint64 val = I_to_uint64(obj);
            #if (long_bitsize<64)
            pdata->hi = (uint32)(val>>32); pdata->lo = (uint32)val;
            #else
            *pdata = val;
            #endif
            return;
          }}
        #else
        elif (eq(fvd,S(sint64)) || eq(fvd,S(uint64)))
          { fehler_64bit(fvd); }
        #endif
        elif (eq(fvd,S(int)))
          { var reg2 int* pdata = (int*)data;
            if (!sint_p(obj)) goto bad_obj;
            *pdata = I_to_sint(obj);
            return;
          }
        elif (eq(fvd,S(uint)))
          { var reg2 unsigned int * pdata = (unsigned int *)data;
            if (!uint_p(obj)) goto bad_obj;
            *pdata = I_to_uint(obj);
            return;
          }
        elif (eq(fvd,S(long)))
          { var reg2 long* pdata = (long*)data;
            if (!slong_p(obj)) goto bad_obj;
            *pdata = I_to_slong(obj);
            return;
          }
        elif (eq(fvd,S(ulong)))
          { var reg2 unsigned long * pdata = (unsigned long *)data;
            if (!ulong_p(obj)) goto bad_obj;
            *pdata = I_to_ulong(obj);
            return;
          }
        elif (eq(fvd,S(single_float)))
          { var reg2 ffloatjanus* pdata = (ffloatjanus*) data;
            if (!single_float_p(obj)) goto bad_obj;
            FF_to_c_float(obj,pdata);
            return;
          }
        elif (eq(fvd,S(double_float)))
          { var reg2 dfloatjanus* pdata = (dfloatjanus*) data;
            if (!double_float_p(obj)) goto bad_obj;
            DF_to_c_double(obj,pdata);
            return;
          }
        elif (eq(fvd,S(c_pointer)))
          { if (!faddressp(obj)) goto bad_obj;
            *(void**)data = Faddress_value(obj);
            return;
          }
        elif (eq(fvd,S(c_string)))
          { if (nullp(obj))
              { *(char**)data = NULL; return; }
            if (!stringp(obj)) goto bad_obj;
           {var uintL len;
            var reg2 uintB* ptr1 = unpack_string(obj,&len);
            var reg5 char* asciz = converter_malloc(*(char**)data,len+1,1);
            {var reg1 uintB* ptr2 = (uintB*)asciz;
             var reg4 uintL count;
             dotimesL(count,len, { *ptr2++ = *ptr1++; } );
             *ptr2++ = '\0';
            }
            *(char**)data = asciz;
            return;
          }}
      }
    elif (simple_vector_p(fvd))
      { var reg8 uintL fvdlen = TheSvector(fvd)->length;
        if (fvdlen > 0)
          { var reg2 object fvdtype = TheSvector(fvd)->data[0];
            if (eq(fvdtype,S(c_struct)) && (fvdlen > 2))
              { var reg8 object slots = TheSvector(fvd)->data[1];
                var reg8 object constructor = TheSvector(fvd)->data[2];
                if (!(simple_vector_p(slots) && (TheSvector(slots)->length==fvdlen-3)))
                  { fehler_foreign_type(fvd); }
                if (eq(constructor,L(vector)))
                  { if (!(simple_vector_p(obj) && (TheSvector(obj)->length==fvdlen-3)))
                      goto bad_obj;
                  }
                elif (eq(constructor,L(list)))
                  { }
                else
                  { if (!(structurep(obj) || instancep(obj)))
                      goto bad_obj;
                  }
                pushSTACK(constructor);
                pushSTACK(slots);
                pushSTACK(fvd);
                pushSTACK(obj);
               {var reg4 uintL cumul_size = 0;
                var reg5 uintL cumul_alignment = struct_alignment;
                var reg6 uintL i;
                for (i = 3; i < fvdlen; i++)
                  { var reg8 object obji;
                    if (eq(STACK_3,L(vector)))
                      { obji = TheSvector(STACK_0)->data[i-3]; }
                    elif (eq(STACK_3,L(list)))
                      { obji = STACK_0;
                        if (atomp(obji)) goto bad_obj;
                        STACK_0 = Cdr(obji); obji = Car(obji);
                      }
                    else # simple_vector_p(slots) && (TheSvector(slots)->length==fvdlen-3)
                      { pushSTACK(STACK_0); pushSTACK(TheSvector(STACK_(2+1))->data[i-3]);
                        funcall(L(slot_value),2); obji = value1;
                      }
                    { var reg7 object fvdi = TheSvector(STACK_1)->data[i];
                      foreign_layout(fvdi);
                      # We assume all alignments are of the form 2^k.
                      cumul_size += (-cumul_size) & (data_alignment-1);
                     {var reg9 void* pdata = (char*)data + cumul_size;
                      cumul_size += data_size;
                      # cumul_alignment = lcm(cumul_alignment,data_alignment);
                      if (data_alignment > cumul_alignment)
                        cumul_alignment = data_alignment;
                      # Now we are finished with data_size and data_alignment.
                      # Descend into the structure slot:
                      convert_to_foreign(fvdi,obji,pdata);
                  } }}
                skipSTACK(4);
                return;
              }}
            elif (eq(fvdtype,S(c_union)) && (fvdlen > 1))
              { # Use the union's first component.
                convert_to_foreign(fvdlen > 2 ? TheSvector(fvd)->data[2] : NIL,obj,data);
                return;
              }
            elif (eq(fvdtype,S(c_array)) && (fvdlen > 1))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg7 uintL eltype_size = (foreign_layout(eltype), data_size);
                var reg6 uintL size = 1;
                { var reg5 uintL i;
                  for (i = 2; i < fvdlen; i++)
                    { var reg4 object dim = TheSvector(fvd)->data[i];
                      if (!uint32_p(dim)) { fehler_foreign_type(fvd); }
                      size = size * I_to_uint32(dim);
                }   }
                if (!(arrayp(obj) && array_total_size(obj)==size))
                  goto bad_obj;
                if (eq(eltype,S(character)) && stringp(obj))
                  { var uintL len;
                    var reg2 uintB* ptr1 = unpack_string(obj,&len);
                    var reg1 uintB* ptr2 = (uintB*)data;
                    var reg4 uintL count;
                    dotimesL(count,len, { *ptr2++ = *ptr1++; } );
                  }
                elif (eq(eltype,S(uint8))
                      && ((typecode(obj) & ~imm_array_mask) == bvector_type)
                      && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_8Bit)
                     )
                  { var uintL index = 0;
                    obj = array_displace_check(obj,size,&index);
                   {var reg2 uint8* ptr1 = &TheSbvector(TheArray(obj)->data)->data[index];
                    var reg1 uint8* ptr2 = (uint8*)data;
                    var reg4 uintL count;
                    dotimesL(count,size, { *ptr2++ = *ptr1++; } );
                  }}
                elif (eq(eltype,S(uint16))
                      && ((typecode(obj) & ~imm_array_mask) == bvector_type)
                      && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_16Bit)
                     )
                  { var uintL index = 0;
                    obj = array_displace_check(obj,size,&index);
                   {var reg2 uint16* ptr1 = (uint16*)&TheSbvector(TheArray(obj)->data)->data[2*index];
                    var reg1 uint16* ptr2 = (uint16*)data;
                    var reg4 uintL count;
                    dotimesL(count,size, { *ptr2++ = *ptr1++; } );
                  }}
                elif (eq(eltype,S(uint32))
                      && ((typecode(obj) & ~imm_array_mask) == bvector_type)
                      && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_32Bit)
                     )
                  { var uintL index = 0;
                    obj = array_displace_check(obj,size,&index);
                   {var reg2 uint32* ptr1 = (uint32*)&TheSbvector(TheArray(obj)->data)->data[4*index];
                    var reg1 uint32* ptr2 = (uint32*)data;
                    var reg4 uintL count;
                    dotimesL(count,size, { *ptr2++ = *ptr1++; } );
                  }}
                else
                  { pushSTACK(eltype);
                    pushSTACK(obj);
                    { var reg4 uintL i;
                      var reg5 char* pdata = (char*)data;
                      for (i = 0; i < size; i++, pdata += eltype_size)
                        { # pdata = (char*)data + i*eltype_size
                          pushSTACK(STACK_0); pushSTACK(fixnum(i));
                          funcall(L(row_major_aref),2);
                          convert_to_foreign(STACK_1,value1,pdata);
                    }   }
                    skipSTACK(2);
                  }
                return;
              }
            elif (eq(fvdtype,S(c_array_max)) && (fvdlen == 3))
              { var reg9 object eltype = TheSvector(fvd)->data[1];
                var reg7 uintL eltype_size = (foreign_layout(eltype), data_size);
                var reg6 uintL maxdim = I_to_UL(TheSvector(fvd)->data[2]);
                if (!vectorp(obj))
                  goto bad_obj;
               {var reg5 uintL len = vector_length(obj);
                if (len > maxdim) { len = maxdim; }
                if (eq(eltype,S(character)) && stringp(obj))
                  { var uintL dummy_len;
                    var reg2 uintB* ptr1 = unpack_string(obj,&dummy_len);
                    var reg1 uintB* ptr2 = (uintB*)data;
                    var reg4 uintL count;
                    dotimesL(count,len, { *ptr2++ = *ptr1++; } );
                    if (len < maxdim) { *ptr2 = '\0'; }
                  }
                elif (eq(eltype,S(uint8))
                      && ((typecode(obj) & ~imm_array_mask) == bvector_type)
                      && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_8Bit)
                     )
                  { var uintL index = 0;
                    obj = array_displace_check(obj,len,&index);
                   {var reg2 uint8* ptr1 = &TheSbvector(TheArray(obj)->data)->data[index];
                    var reg1 uint8* ptr2 = (uint8*)data;
                    var reg4 uintL count;
                    dotimesL(count,len, { *ptr2++ = *ptr1++; } );
                    if (len < maxdim) { *ptr2 = 0; }
                  }}
                elif (eq(eltype,S(uint16))
                      && ((typecode(obj) & ~imm_array_mask) == bvector_type)
                      && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_16Bit)
                     )
                  { var uintL index = 0;
                    obj = array_displace_check(obj,len,&index);
                   {var reg2 uint16* ptr1 = (uint16*)&TheSbvector(TheArray(obj)->data)->data[2*index];
                    var reg1 uint16* ptr2 = (uint16*)data;
                    var reg4 uintL count;
                    dotimesL(count,len, { *ptr2++ = *ptr1++; } );
                    if (len < maxdim) { *ptr2 = 0; }
                  }}
                elif (eq(eltype,S(uint32))
                      && ((typecode(obj) & ~imm_array_mask) == bvector_type)
                      && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_32Bit)
                     )
                  { var uintL index = 0;
                    obj = array_displace_check(obj,len,&index);
                   {var reg2 uint32* ptr1 = (uint32*)&TheSbvector(TheArray(obj)->data)->data[4*index];
                    var reg1 uint32* ptr2 = (uint32*)data;
                    var reg4 uintL count;
                    dotimesL(count,len, { *ptr2++ = *ptr1++; } );
                    if (len < maxdim) { *ptr2 = 0; }
                  }}
                else
                  { pushSTACK(eltype);
                    pushSTACK(obj);
                    { var reg4 uintL i;
                      var reg5 char* pdata = (char*)data;
                      for (i = 0; i < len; i++, pdata += eltype_size)
                        { # pdata = (char*)data + i*eltype_size
                          pushSTACK(STACK_0); pushSTACK(fixnum(i));
                          funcall(L(aref),2);
                          convert_to_foreign(STACK_1,value1,pdata);
                        }
                      if (len < maxdim) { blockzero(pdata,eltype_size); }
                    }
                    skipSTACK(2);
                  }
                return;
              }}
            elif (eq(fvdtype,S(c_function)) && (fvdlen == 4))
              { var reg3 object ffun =
                  convert_function_to_foreign(obj,
                                              TheSvector(fvd)->data[1],
                                              TheSvector(fvd)->data[2],
                                              TheSvector(fvd)->data[3]
                                             );
                *(void**)data = Faddress_value(TheFfunction(ffun)->ff_address);
                return;
              }
            elif (eq(fvdtype,S(c_ptr)) && (fvdlen == 2))
              { fvd = TheSvector(fvd)->data[1];
                foreign_layout(fvd);
               {var reg3 void* p = converter_malloc(*(void**)data,data_size,data_alignment);
                *(void**)data = p;
                convert_to_foreign(fvd,obj,p);
                return;
              }}
            elif (eq(fvdtype,S(c_ptr_null)) && (fvdlen == 2))
              { if (nullp(obj))
                  { *(void**)data = NULL; return; }
                fvd = TheSvector(fvd)->data[1];
                foreign_layout(fvd);
               {var reg3 void* p = converter_malloc(*(void**)data,data_size,data_alignment);
                *(void**)data = p;
                convert_to_foreign(fvd,obj,p);
                return;
              }}
            elif (eq(fvdtype,S(c_array_ptr)) && (fvdlen == 2))
              { if (nullp(obj))
                  { *(void**)data = NULL; return; }
                if (!vectorp(obj)) goto bad_obj;
               {var reg5 uintL len = vector_length(obj);
                fvd = TheSvector(fvd)->data[1];
                foreign_layout(fvd);
                {var reg4 uintL eltype_size = data_size;
                 var reg3 void* p = converter_malloc(*(void**)data,(len+1)*eltype_size,data_alignment);
                 *(void**)data = p;
                 pushSTACK(fvd);
                 pushSTACK(obj);
                 {var reg1 uintL i;
                  for (i = 0; i < len; i++, p = (void*)((char*)p + eltype_size))
                    { pushSTACK(STACK_0); pushSTACK(fixnum(i));
                      funcall(L(aref),2);
                      convert_to_foreign(STACK_1,value1,p);
                 }  }
                 skipSTACK(2);
                 blockzero(p,eltype_size);
                }
                return;
              }}
      }   }
    fehler_foreign_type(fvd);
   bad_obj:
    fehler_convert(fvd,obj);
  }

# Convert Lisp data to foreign data.
# The foreign data has dynamic extent.
# 1. convert_to_foreign_need(fvd,obj);
# 2. make room according to data_size and data_alignment, set allocaing_room_pointer.
# 3. convert_to_foreign_allocaing(fvd,obj,data,room_pointer);
global void convert_to_foreign_allocaing (object fvd, object obj, void* data);
local void* allocaing_room_pointer;
local void* allocaing (void* old_data, uintL size, uintL alignment);
local void* allocaing(old_data,size,alignment)
  var reg2 void* old_data;
  var reg1 uintL size;
  var reg3 uintL alignment;
  { allocaing_room_pointer = (void*)(((uintP)allocaing_room_pointer + alignment-1) & -(long)alignment);
   {var reg4 void* result = allocaing_room_pointer;
    allocaing_room_pointer = (void*)((uintP)allocaing_room_pointer + size);
    return result;
  }}
global void convert_to_foreign_allocaing(fvd,obj,data)
  var reg1 object fvd;
  var reg2 object obj;
  var reg3 void* data;
  { converter_malloc = &allocaing;
    convert_to_foreign(fvd,obj,data);
  }

# Convert Lisp data to foreign data.
# The foreign data is allocated through malloc() and has more than dynamic
# extent. (Not exactly indefinite extent: It is deallocated the next time
# free_foreign() is called on it.)
global void convert_to_foreign_mallocing (object fvd, object obj, void* data);
local void* mallocing (void* old_data, uintL size, uintL alignment);
local void* mallocing(old_data,size,alignment)
  var reg2 void* old_data;
  var reg1 uintL size;
  var reg3 uintL alignment;
  { return xmalloc(size); }
global void convert_to_foreign_mallocing(fvd,obj,data)
  var reg1 object fvd;
  var reg2 object obj;
  var reg3 void* data;
  { converter_malloc = &mallocing;
    convert_to_foreign(fvd,obj,data);
  }

# Convert Lisp data to foreign data.
# The foreign data storage is reused.
# DANGEROUS, especially for type C-STRING !!
# Also beware against NULL pointers! They are not treated specially.
global void convert_to_foreign_nomalloc (object fvd, object obj, void* data);
local void* nomalloc (void* old_data, uintL size, uintL alignment);
local void* nomalloc(old_data,size,alignment)
  var reg1 void* old_data;
  var reg2 uintL size;
  var reg3 uintL alignment;
  { return old_data; }
global void convert_to_foreign_nomalloc(fvd,obj,data)
  var reg1 object fvd;
  var reg2 object obj;
  var reg3 void* data;
  { converter_malloc = &nomalloc;
    convert_to_foreign(fvd,obj,data);
  }


# Error messages.
nonreturning_function(local, fehler_foreign_variable, (object obj));
local void fehler_foreign_variable(obj)
  var reg1 object obj;
  { pushSTACK(obj);
    pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Argument ist keine Foreign-Variable: ~"
    //: ENGLISH "~: argument is not a foreign variable: ~"
    //: FRANCAIS "~ : l'argument n'est pas une variable étrangère: ~"
    fehler(error, GETTEXT("~: argument is not a foreign variable: ~"));
  }
nonreturning_function(local, fehler_variable_no_fvd, (object obj));
local void fehler_variable_no_fvd(obj)
  var reg1 object obj;
  { pushSTACK(obj);
    pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Foreign-Variable mit unbekanntem Typ, DEF-C-VAR fehlt: ~"
    //: ENGLISH "~: foreign variable with unknown type, missing DEF-C-VAR: ~"
    //: FRANCAIS "~ : variable étrangère de type inconnu, DEF-C-VAR manquant: ~"
    fehler(error, GETTEXT("~: foreign variable with unknown type, missing DEF-C-VAR: ~"));
  }

# (FFI::LOOKUP-FOREIGN-VARIABLE foreign-variable-name foreign-type)
# looks up a foreign variable, given its Lisp name.
LISPFUNN(lookup_foreign_variable,2)
  { var reg3 object fvd = popSTACK();
    var reg2 object name = popSTACK();
    var reg1 object fvar = gethash(name,O(foreign_variable_table));
    if (eq(fvar,nullobj))
      { pushSTACK(name);
        //: DEUTSCH "Eine Foreign-Variable ~ gibt es nicht."
        //: ENGLISH "A foreign variable ~ does not exist"
        //: FRANCAIS "Il n'y a pas de variable étrangère ~."
        fehler(error, GETTEXT("A foreign variable ~ does not exist"));
      }
    # The first LOOKUP-FOREIGN-VARIABLE determines the variable's type.
    if (nullp(TheFvariable(fvar)->fv_type))
      { foreign_layout(fvd);
        if (!((posfixnum_to_L(TheFvariable(fvar)->fv_size) == data_size)
              && (((long)Faddress_value(TheFvariable(fvar)->fv_address) & (data_alignment-1)) == 0)
           ) )
          { pushSTACK(fvar);
            pushSTACK(TheSubr(subr_self)->name);
            //: DEUTSCH "~: Foreign-Variable ~ hat nicht die geforderte Größe oder Alignment."
            //: ENGLISH "~: foreign variable ~ does not have the required size or alignment"
            //: FRANCAIS "~ : variable étrangère ~ n'a pas la taille ou le placement nécessaire."
            fehler(error, GETTEXT("~: foreign variable ~ does not have the required size or alignment"));
          }
        TheFvariable(fvar)->fv_type = fvd;
      }
    # Subsequent LOOKUP-FOREIGN-VARIABLE calls only compare the type.
    elif (!equal_fvd(TheFvariable(fvar)->fv_type,fvd))
      { if (!equalp_fvd(TheFvariable(fvar)->fv_type,fvd))
          { var reg4 object *fvd_ptr;
            var reg5 object *fvar_ptr;
            pushSTACK(fvd); fvd_ptr=&STACK_0;
            pushSTACK(fvar); fvar_ptr=&STACK_0;
            dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
            pushSTACK(*fvd_ptr);
            fvar=*fvar_ptr;
            pushSTACK(TheFvariable(fvar)->fv_type);
            pushSTACK(fvar);
            pushSTACK(TheSubr(subr_self)->name);
            //: DEUTSCH "~: Typangaben für Foreign-Variable ~ widersprechen sich: ~ und ~"
            //: ENGLISH "~: type specifications for foreign variable ~ conflict: ~ and ~"
            //: FRANCAIS "~ : type de variable étrangère ~ se contredisent: ~ et ~"
            fehler(error, GETTEXT("~: type specifications for foreign variable ~ conflict: ~ and ~"));
          }
        # If the types are not exactly the same but still compatible,
        # allocate a new foreign variable with the given fvd.
        pushSTACK(fvd);
        pushSTACK(fvar);
       {var reg2 object new_fvar = allocate_fvariable();
        fvar = popSTACK();
        TheFvariable(new_fvar)->recflags   = TheFvariable(fvar)->recflags;
        TheFvariable(new_fvar)->fv_name    = TheFvariable(fvar)->fv_name;
        TheFvariable(new_fvar)->fv_address = TheFvariable(fvar)->fv_address;
        TheFvariable(new_fvar)->fv_size    = TheFvariable(fvar)->fv_size;
        TheFvariable(new_fvar)->fv_type    = popSTACK();
        fvar = new_fvar;
      }}
    value1 = fvar; mv_count=1;
  }

# (FFI::FOREIGN-VALUE foreign-variable)
# returns the value of the foreign variable as a Lisp data structure.
LISPFUNN(foreign_value,1)
  { var reg1 object fvar = popSTACK();
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
   {var reg3 void* address = Faddress_value(TheFvariable(fvar)->fv_address);
    var reg2 object fvd = TheFvariable(fvar)->fv_type;
    if (nullp(fvd)) { fehler_variable_no_fvd(fvar); }
    value1 = convert_from_foreign(fvd,address);
    mv_count=1;
  }}

# (FFI::SET-FOREIGN-VALUE foreign-variable new-value)
# sets the value of the foreign variable.
LISPFUNN(set_foreign_value,2)
  { var reg1 object fvar = STACK_1;
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
   {var reg3 void* address = Faddress_value(TheFvariable(fvar)->fv_address);
    var reg2 object fvd = TheFvariable(fvar)->fv_type;
    if (nullp(fvd)) { fehler_variable_no_fvd(fvar); }
    if (TheFvariable(fvar)->recflags & fv_readonly)
      { pushSTACK(fvar);
        pushSTACK(TheSubr(subr_self)->name);
        //: DEUTSCH "~: Foreign-Variable ~ darf nicht verändert werden."
        //: ENGLISH "~: foreign variable ~ may not be modified"
        //: FRANCAIS "~ : variable étrangère ~ n'est pas modifiable."
        fehler(error, GETTEXT("~: foreign variable ~ may not be modified"));
      }
    if (TheFvariable(fvar)->recflags & fv_malloc)
      { # Protect this using a semaphore??
        # Free old value:
        free_foreign(fvd,address);
        # Put in new value:
        convert_to_foreign_mallocing(fvd,STACK_0,address);
      }
      else
      { # Protect this using a semaphore??
        # Put in new value, reusing the old value's storage:
        convert_to_foreign_nomalloc(fvd,STACK_0,address);
      }
    value1 = STACK_0; mv_count=1;
    skipSTACK(2);
  }}

# (FFI::FOREIGN-TYPE foreign-variable)
LISPFUNN(foreign_type,1)
  { var reg1 object fvar = popSTACK();
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
    if (nullp((value1 = TheFvariable(fvar)->fv_type))) { fehler_variable_no_fvd(fvar); }
    mv_count=1;
  }

# (FFI::FOREIGN-SIZE foreign-variable)
LISPFUNN(foreign_size,1)
  { var reg1 object fvar = popSTACK();
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
    if (nullp(TheFvariable(fvar)->fv_type)) { fehler_variable_no_fvd(fvar); }
    value1 = TheFvariable(fvar)->fv_size; mv_count=1;
  }

  local void fehler_subscripts_wrong_type (void);
  local void fehler_subscripts_wrong_type()
    {
      //: DEUTSCH "~: Subscripts ~ für ~ sind nicht vom Typ `(INTEGER 0 (,ARRAY-DIMENSION-LIMIT))."
      //: ENGLISH "~: subscripts ~ for ~ are not of type `(INTEGER 0 (,ARRAY-DIMENSION-LIMIT))"
      //: FRANCAIS "~: Les indices ~ pour ~ ne sont pas de type `(INTEGER 0 (,ARRAY-DIMENSION-LIMIT))."
      fehler(error, GETTEXT("~: subscripts ~ for ~ are not of type `(INTEGER 0 (,ARRAY-DIMENSION-LIMIT))"));
    }

  local void fehler_subscripts_out_of_range (void);
  local void fehler_subscripts_out_of_range()
    {
      //: DEUTSCH "~: Subscripts ~ für ~ liegen nicht im erlaubten Bereich."
      //: ENGLISH "~: subscripts ~ for ~ are out of range"
      //: FRANCAIS "~: Les indices ~ pour ~ ne sont pas dans l'intervalle permis."
      fehler(error, GETTEXT("~: subscripts ~ for ~ are out of range"));
    }

# (FFI::%ELEMENT foreign-array-variable {index}*)
# returns a foreign variable, corresponding to the specified array element.
LISPFUN(element,1,0,rest,nokey,0,NIL)
  { var reg2 object fvar = Before(rest_args_pointer);
    # Check that fvar is a foreign variable:
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
    # Check that fvar is a foreign array:
   {var reg3 object fvd = TheFvariable(fvar)->fv_type;
    var reg5 uintL fvdlen;
    if (!(simple_vector_p(fvd)
          && ((fvdlen = TheSvector(fvd)->length) > 1)
          && (eq(TheSvector(fvd)->data[0],S(c_array)) || eq(TheSvector(fvd)->data[0],S(c_array_max)))
       ) )
      { var reg6 object *fvd_ptr;
        var reg7 object *fvar_ptr;
        pushSTACK(fvd); fvd_ptr=&STACK_0;
        pushSTACK(fvar); fvar_ptr=&STACK_0;
        dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
        pushSTACK(*fvd_ptr);
        pushSTACK(*fvar_ptr);
        pushSTACK(S(element));
        //: DEUTSCH "~: Foreign-Variable ~ vom Typ ~ ist kein Array."
        //: ENGLISH "~: foreign variable ~ of type ~ is not an array"
        //: FRANCAIS "~ : variable étrangère ~ de type ~ n'est pas une matrice."
        fehler(error, GETTEXT("~: foreign variable ~ of type ~ is not an array"));
      }
    # Check the subscript count:
    if (!(argcount == fvdlen-2))
      { pushSTACK(fixnum(fvdlen-2));
        pushSTACK(fvar);
        pushSTACK(fixnum(argcount));
        pushSTACK(S(element));
        //: DEUTSCH "~: Es wurden ~ Subscripts angegeben, ~ hat aber den Rang ~."
        //: ENGLISH "~: got ~ subscripts, but ~ has rank ~"
        //: FRANCAIS "~: ~ indices donnés mais ~ est de rang ~."
        fehler(error, GETTEXT("~: got ~ subscripts, but ~ has rank ~"));
      }
    # Check the subscripts:
    {var reg9 uintL row_major_index = 0;
     {var reg7 object* args_pointer = rest_args_pointer;
      var reg6 object* dimptr = &TheSvector(fvd)->data[2];
      var reg8 uintC count;
      dotimesC(count,argcount,
        { var reg1 object subscriptobj = NEXT(args_pointer);
          if (!posfixnump(subscriptobj))
            { var reg10 object list = listof(argcount);
              # STACK_0 is fvar now.
              pushSTACK(list);
              pushSTACK(S(element));
              fehler_subscripts_wrong_type();
            }
         {var reg4 uintL subscript = posfixnum_to_L(subscriptobj);
          var reg8 uintL dim = I_to_uint32(*dimptr);
          if (!(subscript<dim))
            { var reg10 object list = listof(argcount);
              # STACK_0 is fvar now.
              pushSTACK(list);
              pushSTACK(S(element));
              fehler_subscripts_out_of_range();
            }
          # Compute row_major_index := row_major_index*dim+subscript:
          row_major_index = mulu32_unchecked(row_major_index,dim)+subscript;
          *dimptr++;
        }});
     }
     set_args_end_pointer(rest_args_pointer);
     fvd = TheSvector(fvd)->data[1]; # the element's foreign type
     pushSTACK(fvd);
     foreign_layout(fvd);
     {var reg4 uintL size = data_size; # the element's size
      pushSTACK(make_faddress(TheFaddress(TheFvariable(fvar)->fv_address)->fa_base,
                              TheFaddress(TheFvariable(fvar)->fv_address)->fa_offset
                              + row_major_index * size
               )             );
      {var reg1 object new_fvar = allocate_fvariable();
       fvar = STACK_2;
       TheFvariable(new_fvar)->recflags   = TheFvariable(fvar)->recflags;
       TheFvariable(new_fvar)->fv_name    = NIL; # no name known
       TheFvariable(new_fvar)->fv_address = popSTACK();
       TheFvariable(new_fvar)->fv_size    = fixnum(size);
       TheFvariable(new_fvar)->fv_type    = popSTACK();
       value1 = new_fvar; mv_count=1;
       skipSTACK(1);
  }}}}}

# (FFI::%DEREF foreign-pointer-variable)
# returns a foreign variable, corresponding to what the specified pointer
# points to.
LISPFUNN(deref,1)
  { var reg2 object fvar = STACK_0;
    # Check that fvar is a foreign variable:
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
    # Check that fvar is a foreign pointer:
   {var reg3 object fvd = TheFvariable(fvar)->fv_type;
    if (!(simple_vector_p(fvd)
          && (TheSvector(fvd)->length == 2)
          && (eq(TheSvector(fvd)->data[0],S(c_ptr))
              || eq(TheSvector(fvd)->data[0],S(c_ptr_null)))
       ) )
      { var reg4 object *fvd_ptr;
        var reg5 object *fvar_ptr;
        pushSTACK(fvd); fvd_ptr=&STACK_0;
        pushSTACK(fvar); fvar_ptr=&STACK_0;
        dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
        pushSTACK(*fvd_ptr);
        pushSTACK(*fvar_ptr);
        pushSTACK(S(element));
        //: DEUTSCH "~: Foreign-Variable ~ vom Typ ~ ist kein Pointer."
        //: ENGLISH "~: foreign variable ~ of type ~ is not a pointer"
        //: FRANCAIS "~ : variable étrangère ~ de type ~ n'est pas un pointeur."
        fehler(error, GETTEXT("~: foreign variable ~ of type ~ is not a pointer"));
      }
    fvd = TheSvector(fvd)->data[1]; # the target's foreign type
    pushSTACK(fvd);
    foreign_layout(fvd);
    {var reg4 uintL size = data_size; # the target's size
     # Actually dereference the pointer:
     var reg5 void* address = *(void**)Faddress_value(TheFvariable(fvar)->fv_address);
     if (address == NULL)
       # Don't mess with NULL pointers, return NIL instead.
       { value1 = NIL; mv_count=1; skipSTACK(2); }
       else
       { pushSTACK(make_faddress(O(fp_zero),(uintP)address));
        {var reg1 object new_fvar = allocate_fvariable();
         fvar = STACK_2;
         TheFvariable(new_fvar)->recflags   = TheFvariable(fvar)->recflags;
         TheFvariable(new_fvar)->fv_name    = NIL; # no name known
         TheFvariable(new_fvar)->fv_address = popSTACK();
         TheFvariable(new_fvar)->fv_size    = fixnum(size);
         TheFvariable(new_fvar)->fv_type    = popSTACK();
         value1 = new_fvar; mv_count=1;
         skipSTACK(1);
  }}}  }}

# (FFI::%SLOT foreign-struct/union-variable slot-name)
# returns a foreign variable, corresponding to the specified struct slot or
# union alternative.
LISPFUNN(slot,2)
  { var reg6 object fvar = STACK_1;
    var reg4 object slot = STACK_0;
    # Check that fvar is a foreign variable:
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
    # Check that fvar is a foreign struct or a foreign union:
   {var reg2 object fvd = TheFvariable(fvar)->fv_type;
    var reg8 uintL fvdlen;
    if (simple_vector_p(fvd) && ((fvdlen = TheSvector(fvd)->length) > 0))
      { if (eq(TheSvector(fvd)->data[0],S(c_struct)) && (fvdlen > 2))
          { var reg1 object slots = TheSvector(fvd)->data[1];
            if (!(simple_vector_p(slots) && (TheSvector(slots)->length==fvdlen-3)))
              { fehler_foreign_type(fvd); }
           {var reg5 uintL cumul_size = 0;
            var reg3 uintL i;
            for (i = 3; i < fvdlen; i++)
              { var reg7 object fvdi = TheSvector(fvd)->data[i];
                foreign_layout(fvdi);
                # We assume all alignments are of the form 2^k.
                cumul_size += (-cumul_size) & (data_alignment-1);
                if (eq(TheSvector(slots)->data[i-3],slot))
                  { pushSTACK(fvdi); goto found_struct_slot; }
                cumul_size += data_size;
              }
            goto bad_slot;
            found_struct_slot:
            { var reg3 uintL size = data_size;
              pushSTACK(make_faddress(TheFaddress(TheFvariable(fvar)->fv_address)->fa_base,
                                      TheFaddress(TheFvariable(fvar)->fv_address)->fa_offset
                                      + cumul_size
                       )             );
             {var reg1 object new_fvar = allocate_fvariable();
              fvar = STACK_3;
              TheFvariable(new_fvar)->recflags   = TheFvariable(fvar)->recflags;
              TheFvariable(new_fvar)->fv_name    = NIL; # no name known
              TheFvariable(new_fvar)->fv_address = popSTACK();
              TheFvariable(new_fvar)->fv_size    = fixnum(size);
              TheFvariable(new_fvar)->fv_type    = popSTACK();
              value1 = new_fvar; mv_count=1;
              skipSTACK(2);
              return;
          }}}}
        if (eq(TheSvector(fvd)->data[0],S(c_union)) && (fvdlen > 1))
          { var reg1 object slots = TheSvector(fvd)->data[1];
            if (!(simple_vector_p(slots) && (TheSvector(slots)->length==fvdlen-2)))
              { fehler_foreign_type(fvd); }
           {var reg3 uintL i;
            for (i = 2; i < fvdlen; i++)
              { if (eq(TheSvector(slots)->data[i-2],slot))
                  goto found_union_slot;
              }
            goto bad_slot;
            found_union_slot:
            pushSTACK(TheSvector(fvd)->data[i]);
            {var reg1 object new_fvar = allocate_fvariable();
             fvd = popSTACK(); # the alternative's type
             fvar = STACK_1;
             TheFvariable(new_fvar)->recflags   = TheFvariable(fvar)->recflags;
             TheFvariable(new_fvar)->fv_name    = NIL; # no name known
             TheFvariable(new_fvar)->fv_address = TheFvariable(fvar)->fv_address;
             TheFvariable(new_fvar)->fv_size    = (foreign_layout(fvd), fixnum(data_size));
             TheFvariable(new_fvar)->fv_type    = fvd;
             value1 = new_fvar; mv_count=1;
             skipSTACK(2);
             return;
          }}}
      }
    { var reg1 object *fvd_ptr;
      var reg2 object *fvar_ptr;
      pushSTACK(fvd); fvd_ptr=&STACK_0;
      pushSTACK(fvar); fvar_ptr=&STACK_0;
      dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
      pushSTACK(*fvd_ptr);
      pushSTACK(*fvar_ptr);
      pushSTACK(S(slot));
      //: DEUTSCH "~: Foreign-Variable ~ vom Typ ~ ist kein Struct oder Union."
      //: ENGLISH "~: foreign variable ~ of type ~ is not a struct or union"
      //: FRANCAIS "~ : variable étrangère ~ de type ~ n'est pas un «struct» ou «union»."
      fehler(error, GETTEXT("~: foreign variable ~ of type ~ is not a struct or union"));
    }
    bad_slot:
    { var reg1 object *fvd_ptr;
      var reg2 object *fvar_ptr;
      var reg3 object *slot_ptr;
      pushSTACK(fvd); fvd_ptr=&STACK_0;
      pushSTACK(fvar); fvar_ptr=&STACK_0;
      pushSTACK(slot); slot_ptr=&STACK_0;
      dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
      pushSTACK(*slot_ptr);
      pushSTACK(*fvd_ptr);
      pushSTACK(*fvar_ptr);
      pushSTACK(S(slot));
      //: DEUTSCH "~: Foreign-Variable ~ vom Typ ~ hat keine Komponente namens ~."
      //: ENGLISH "~: foreign variable ~ of type ~ has no component with name ~"
      //: FRANCAIS "~ : variable étrangère ~ de type ~ n'a pas de composante de nom ~."
      fehler(error, GETTEXT("~: foreign variable ~ of type ~ has no component with name ~"));
    }
  }}

# (FFI::%CAST foreign-variable c-type)
# returns a foreign variable, referring to the same memory locations, but of
# the given c-type.
LISPFUNN(cast,2)
  { var reg1 object fvar = STACK_1;
    if (!fvariablep(fvar)) { fehler_foreign_variable(fvar); }
   {var reg3 object fvd = TheFvariable(fvar)->fv_type;
    if (nullp(fvd)) { fehler_variable_no_fvd(fvar); }
    # The old and the new type must have the same size.
    foreign_layout(STACK_0);
    if (!eq(TheFvariable(fvar)->fv_size,fixnum(data_size)))
      { fehler_convert(STACK_0,fvar); }
    # Allocate a new foreign variable.
    {var reg2 object new_fvar = allocate_fvariable();
     fvar = STACK_1;
     TheFvariable(new_fvar)->recflags   = TheFvariable(fvar)->recflags;
     TheFvariable(new_fvar)->fv_name    = TheFvariable(fvar)->fv_name;
     TheFvariable(new_fvar)->fv_address = TheFvariable(fvar)->fv_address;
     TheFvariable(new_fvar)->fv_size    = TheFvariable(fvar)->fv_size;
     TheFvariable(new_fvar)->fv_type    = STACK_0;
     value1 = new_fvar; mv_count=1;
     skipSTACK(2);
  }}}


# Error messages.
nonreturning_function(local, fehler_foreign_function, (object obj));
local void fehler_foreign_function(obj)
  var reg1 object obj;
  { pushSTACK(obj);
    pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Argument ist keine Foreign-Funktion: ~"
    //: ENGLISH "~: argument is not a foreign function: ~"
    //: FRANCAIS "~ : l'argument n'est pas une fonction étrangère: ~"
    fehler(error, GETTEXT("~: argument is not a foreign function: ~"));
  }
nonreturning_function(local, fehler_function_no_fvd, (object obj, object caller));
local void fehler_function_no_fvd(obj,caller)
  var reg1 object obj;
  var reg2 object caller;
  { pushSTACK(obj);
    pushSTACK(caller);
    //: DEUTSCH "~: Foreign-Funktion mit unbekannter Aufrufkonvention, DEF-CALL-OUT fehlt: ~"
    //: ENGLISH "~: foreign function with unknown calling convention, missing DEF-CALL-OUT: ~"
    //: FRANCAIS "~ : convention d'appel inconnue pour fonction étrangère, DEF-CALL-OUT manquant: ~"
    fehler(error, GETTEXT("~: foreign function with unknown calling convention, missing DEF-CALL-OUT: ~"));
  }

# (FFI::LOOKUP-FOREIGN-FUNCTION foreign-function-name foreign-type)
# looks up a foreign function, given its Lisp name.
LISPFUNN(lookup_foreign_function,2)
  { var reg1 object ffun = allocate_ffunction();
    var reg4 object fvd = popSTACK();
    var reg3 object name = popSTACK();
    if (!(simple_vector_p(fvd) && (TheSvector(fvd)->length == 4)
          && eq(TheSvector(fvd)->data[0],S(c_function))
       ) )
      { var reg5 object *fvd_ptr;
        pushSTACK(fvd); fvd_ptr=&STACK_0;
        dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
        pushSTACK(*fvd_ptr);
        pushSTACK(S(lookup_foreign_function));
        //: DEUTSCH "~: ungültiger Typ für externe Funktion: ~"
        //: ENGLISH "~: illegal foreign function type ~"
        //: FRANCAIS "~ : type invalide de fonction externe : ~"
        fehler(error, GETTEXT("~: illegal foreign function type ~"));
      }
   {var reg2 object oldffun = gethash(name,O(foreign_function_table));
    if (eq(oldffun,nullobj))
      { pushSTACK(name);
        pushSTACK(S(lookup_foreign_function));
        //: DEUTSCH "~: Eine Foreign-Funktion ~ gibt es nicht."
        //: ENGLISH "~: A foreign function ~ does not exist"
        //: FRANCAIS "~ : Il n'y a pas de fonction étrangère ~."
        fehler(error, GETTEXT("~: A foreign function ~ does not exist"));
      }
    if (!eq(TheFfunction(oldffun)->ff_flags,TheSvector(fvd)->data[3]))
      { pushSTACK(oldffun);
        pushSTACK(S(lookup_foreign_function));
        //: DEUTSCH "~: Aufrufkonventionen für Foreign-Funktion ~ widersprechen sich."
        //: ENGLISH "~: calling conventions for foreign function ~ conflict"
        //: FRANCAIS "~ : conventions d'appel de fonction étrangère ~ se contredisent."
        fehler(error, GETTEXT("~: calling conventions for foreign function ~ conflict"));
      }
    TheFfunction(ffun)->ff_name = TheFfunction(oldffun)->ff_name;
    TheFfunction(ffun)->ff_address = TheFfunction(oldffun)->ff_address;
    TheFfunction(ffun)->ff_resulttype = TheSvector(fvd)->data[1];
    TheFfunction(ffun)->ff_argtypes = TheSvector(fvd)->data[2];
    TheFfunction(ffun)->ff_flags = TheSvector(fvd)->data[3];
    value1 = ffun; mv_count=1;
  }}

# Here is the point where we use the AVCALL package.

# Call the appropriate av_start_xxx macro for the result.
# do_av_start(flags,result_fvd,&alist,address,result_address,result_size,result_splittable);
  local void do_av_start (uintWL flags, object result_fvd, av_alist * alist, void* address, void* result_address, uintL result_size, boolean result_splittable);
  local void do_av_start(flags,result_fvd,alist,address,result_address,result_size,result_splittable)
    var reg3 uintWL flags;
    var reg1 object result_fvd;
    var reg4 av_alist * alist;
    var reg5 void* address;
    var reg6 void* result_address;
    var reg7 uintL result_size;
    var reg8 boolean result_splittable;
    { if (symbolp(result_fvd))
        { if (eq(result_fvd,S(nil)))
            { av_start_void(*alist,address); }
          elif (eq(result_fvd,S(char)) || eq(result_fvd,S(sint8)))
            { if (flags & ff_lang_ansi_c)
                { av_start_schar(*alist,address,result_address); }
                else # `signed char' promotes to `int'
                { av_start_int(*alist,address,result_address); }
            }
          elif (eq(result_fvd,S(uchar)) || eq(result_fvd,S(uint8)) || eq(result_fvd,S(character)))
            { if (flags & ff_lang_ansi_c)
                { av_start_uchar(*alist,address,result_address); }
                else # `unsigned char' promotes to `unsigned int'
                { av_start_uint(*alist,address,result_address); }
            }
          elif (eq(result_fvd,S(short)) || eq(result_fvd,S(sint16)))
            { if (flags & ff_lang_ansi_c)
                { av_start_short(*alist,address,result_address); }
                else # `short' promotes to `int'
                { av_start_int(*alist,address,result_address); }
            }
          elif (eq(result_fvd,S(ushort)) || eq(result_fvd,S(uint16)))
            { if (flags & ff_lang_ansi_c)
                { av_start_ushort(*alist,address,result_address); }
                else # `unsigned short' promotes to `unsigned int'
                { av_start_uint(*alist,address,result_address); }
            }
          elif (eq(result_fvd,S(boolean)) || eq(result_fvd,S(int))
                #if (int_bitsize==32)
                || eq(result_fvd,S(sint32))
                #endif
               )
            { av_start_int(*alist,address,result_address); }
          elif (eq(result_fvd,S(uint))
                #if (int_bitsize==32)
                || eq(result_fvd,S(uint32))
                #endif
               )
            { av_start_uint(*alist,address,result_address); }
          elif (eq(result_fvd,S(long))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(result_fvd,S(sint32))
                #endif
                #if (long_bitsize==64)
                || eq(result_fvd,S(sint64))
                #endif
               )
            { av_start_long(*alist,address,result_address); }
          elif (eq(result_fvd,S(ulong))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(result_fvd,S(uint32))
                #endif
                #if (long_bitsize==64)
                || eq(result_fvd,S(uint64))
                #endif
               )
            { av_start_ulong(*alist,address,result_address); }
          #if (long_bitsize<64)
          elif (eq(result_fvd,S(sint64)))
            { av_start_struct(*alist,address,struct_sint64,av_word_splittable_2(uint32,uint32),result_address); }
          elif (eq(result_fvd,S(uint64)))
            { av_start_struct(*alist,address,struct_uint64,av_word_splittable_2(uint32,uint32),result_address); }
          #endif
          elif (eq(result_fvd,S(single_float)))
            { if (flags & ff_lang_ansi_c)
                { av_start_float(*alist,address,result_address); }
                else # `float' promotes to `double'
                { av_start_double(*alist,address,result_address); }
            }
          elif (eq(result_fvd,S(double_float)))
            { av_start_double(*alist,address,result_address); }
          elif (eq(result_fvd,S(c_pointer)) || eq(result_fvd,S(c_string)))
            { av_start_ptr(*alist,address,void*,result_address); }
          else
            { fehler_foreign_type(result_fvd); }
        }
      elif (simple_vector_p(result_fvd))
        { var reg2 object result_fvdtype = TheSvector(result_fvd)->data[0];
          if (eq(result_fvdtype,S(c_struct)) || eq(result_fvdtype,S(c_union))
              || eq(result_fvdtype,S(c_array)) || eq(result_fvdtype,S(c_array_max))
             )
            { _av_start_struct(*alist,address,result_size,result_splittable,result_address); }
          elif (eq(result_fvdtype,S(c_function))
                || eq(result_fvdtype,S(c_ptr))
                || eq(result_fvdtype,S(c_ptr_null))
                || eq(result_fvdtype,S(c_array_ptr))
               )
            { av_start_ptr(*alist,address,void*,result_address); }
          else
            { fehler_foreign_type(result_fvd); }
        }
      else
        { fehler_foreign_type(result_fvd); }
    }

# Call the appropriate av_xxx macro for an argument.
# do_av_arg(flags,arg_fvd,&alist,arg_address,arg_size,arg_alignment);
  local void do_av_arg (uintWL flags, object arg_fvd, av_alist * alist, void* arg_address, unsigned long arg_size, unsigned long arg_alignment);
  #ifdef AMIGAOS
  local sintWL AV_ARG_REGNUM; # number of register where the argument is to be passed
  #endif
  local void do_av_arg(flags,arg_fvd,alist,arg_address,arg_size,arg_alignment)
    var reg3 uintWL flags;
    var reg1 object arg_fvd;
    var reg4 av_alist * alist;
    var reg2 void* arg_address;
    var reg5 unsigned long arg_size;
    var reg6 unsigned long arg_alignment;
    { if (symbolp(arg_fvd))
        { if (eq(arg_fvd,S(nil)))
            { }
          elif (eq(arg_fvd,S(char)) || eq(arg_fvd,S(sint8)))
            { if (flags & ff_lang_ansi_c)
                { av_schar(*alist,*(sint8*)arg_address); }
                else # `signed char' promotes to `int'
                { av_int(*alist,*(sint8*)arg_address); }
            }
          elif (eq(arg_fvd,S(uchar)) || eq(arg_fvd,S(uint8)) || eq(arg_fvd,S(character)))
            { if (flags & ff_lang_ansi_c)
                { av_uchar(*alist,*(uint8*)arg_address); }
                else # `unsigned char' promotes to `unsigned int'
                { av_uint(*alist,*(uint8*)arg_address); }
            }
          elif (eq(arg_fvd,S(short)) || eq(arg_fvd,S(sint16)))
            { if (flags & ff_lang_ansi_c)
                { av_short(*alist,*(sint16*)arg_address); }
                else # `short' promotes to `int'
                { av_int(*alist,*(sint16*)arg_address); }
            }
          elif (eq(arg_fvd,S(ushort)) || eq(arg_fvd,S(uint16)))
            { if (flags & ff_lang_ansi_c)
                { av_ushort(*alist,*(uint16*)arg_address); }
                else # `unsigned short' promotes to `unsigned int'
                { av_uint(*alist,*(uint16*)arg_address); }
            }
          elif (eq(arg_fvd,S(boolean)) || eq(arg_fvd,S(int))
                #if (int_bitsize==32)
                || eq(arg_fvd,S(sint32))
                #endif
               )
            { av_int(*alist,*(int*)arg_address); }
          elif (eq(arg_fvd,S(uint))
                #if (int_bitsize==32)
                || eq(arg_fvd,S(uint32))
                #endif
               )
            { av_uint(*alist,*(unsigned int *)arg_address); }
          elif (eq(arg_fvd,S(long))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(arg_fvd,S(sint32))
                #endif
                #if (long_bitsize==64)
                || eq(arg_fvd,S(sint64))
                #endif
               )
            { av_long(*alist,*(long*)arg_address); }
          elif (eq(arg_fvd,S(ulong))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(arg_fvd,S(uint32))
                #endif
                #if (long_bitsize==64)
                || eq(arg_fvd,S(uint64))
                #endif
               )
            { av_ulong(*alist,*(unsigned long *)arg_address); }
          #if (long_bitsize<64)
          elif (eq(arg_fvd,S(sint64)))
            { av_struct(*alist,struct_sint64,*(struct_sint64*)arg_address); }
          elif (eq(arg_fvd,S(uint64)))
            { av_struct(*alist,struct_uint64,*(struct_uint64*)arg_address); }
          #endif
          elif (eq(arg_fvd,S(single_float)))
            { if (flags & ff_lang_ansi_c)
                { av_float(*alist,*(float*)arg_address); }
                else # `float' promotes to `double'
                { av_double(*alist,*(float*)arg_address); }
            }
          elif (eq(arg_fvd,S(double_float)))
            { av_double(*alist,*(double*)arg_address); }
          elif (eq(arg_fvd,S(c_pointer)))
            { av_ptr(*alist,void*,*(void**)arg_address); }
          elif (eq(arg_fvd,S(c_string)))
            { av_ptr(*alist,char*,*(char**)arg_address); }
          else
            { fehler_foreign_type(arg_fvd); }
        }
      elif (simple_vector_p(arg_fvd))
        { var reg5 object arg_fvdtype = TheSvector(arg_fvd)->data[0];
          if (eq(arg_fvdtype,S(c_struct)) || eq(arg_fvdtype,S(c_union))
              || eq(arg_fvdtype,S(c_array)) || eq(arg_fvdtype,S(c_array_max))
             )
            { _av_struct(*alist,arg_size,arg_alignment,arg_address); }
          elif (eq(arg_fvdtype,S(c_function))
                || eq(arg_fvdtype,S(c_ptr)) 
                || eq(arg_fvdtype,S(c_ptr_null))
                || eq(arg_fvdtype,S(c_array_ptr))
               )
            { av_ptr(*alist,void*,*(void**)arg_address); }
          else
            { fehler_foreign_type(arg_fvd); }
        }
      else
        { fehler_foreign_type(arg_fvd); }
    }

# (FFI::FOREIGN-CALL-OUT foreign-function . args)
# calls a foreign function with Lisp data structures as arguments,
# and returns the return value as a Lisp data structure.
LISPFUN(foreign_call_out,1,0,rest,nokey,0,NIL)
  { var reg3 object ffun = Before(rest_args_pointer);
    if (!ffunctionp(ffun)) { fehler_foreign_function(ffun); }
   {var reg4 object argfvds = TheFfunction(ffun)->ff_argtypes;
    if (!simple_vector_p(argfvds)) { fehler_function_no_fvd(ffun,S(foreign_call_out)); }
    { var reg6 uintWL flags = posfixnum_to_L(TheFfunction(ffun)->ff_flags);
      switch (flags & 0xFF00)
        { # For the moment, the only supported languages are "C" and "ANSI C".
          case ff_lang_c:
          case ff_lang_ansi_c:
            break;
          default:
            fehler_function_no_fvd(ffun,S(foreign_call_out));
        }
      { var av_alist alist;
       {var reg6 void* address = Faddress_value(TheFfunction(ffun)->ff_address);
        var reg5 object result_fvd = TheFfunction(ffun)->ff_resulttype;
        # Allocate space for the result and maybe the args:
        foreign_layout(result_fvd);
        { var reg4 uintL result_size = data_size;
          var reg4 uintL result_alignment = data_alignment;
          var reg10 boolean result_splittable = data_splittable;
          var reg4 uintL result_totalsize = result_size+result_alignment; # >= result_size+result_alignment-1, > 0
          var reg4 uintL cumul_alignment = result_alignment;
          var reg4 uintL cumul_size = result_totalsize;
          var reg4 uintL allargcount = TheSvector(argfvds)->length/2;
          var reg4 uintL outargcount = 0;
          { var reg4 sintL inargcount = 0;
            var reg3 uintL i;
            for (i = 0; i < allargcount; i++)
              { var reg9 object argfvds = TheFfunction(Before(rest_args_pointer))->ff_argtypes;
                var reg5 object arg_fvd = TheSvector(argfvds)->data[2*i];
                var reg5 uintWL arg_flags = posfixnum_to_L(TheSvector(argfvds)->data[2*i+1]);
                if (!(arg_flags & ff_out))
                  { inargcount++;
                    if (!(inargcount <= argcount))
                      { pushSTACK(ffun);
                        pushSTACK(fixnum(inargcount));
                        pushSTACK(fixnum(argcount));
                        pushSTACK(S(foreign_call_out));
                        //: DEUTSCH "~: Zu wenig Argumente (~ statt mindestens ~) für ~."
                        //: ENGLISH "~: Too few arguments (~ instead of at least ~) to ~"
                        //: FRANCAIS "~ : Trop peu d'arguments (~ au lieu d'au moins ~) pour ~."
                        fehler(error, GETTEXT("~: Too few arguments (~ instead of at least ~) to ~"));
                  }   }
                if (arg_flags & (ff_out | ff_inout))
                  { if (!(simple_vector_p(arg_fvd) && (TheSvector(arg_fvd)->length == 2)
                          && (eq(TheSvector(arg_fvd)->data[0],S(c_ptr))
                              || eq(TheSvector(arg_fvd)->data[0],S(c_ptr_null))
                       ) )   )
                      { var reg1 object *arg_fvd_ptr;
                        pushSTACK(arg_fvd); arg_fvd_ptr=&STACK_0;
                        dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
                        pushSTACK(*arg_fvd_ptr);
                        pushSTACK(S(foreign_call_out));
                        //: DEUTSCH "~: :OUT-Argument ist kein Pointer: ~"
                        //: ENGLISH "~: :OUT argument is not a pointer: ~"
                        //: FRANCAIS "~ : paramètre :OUT n'est pas indirecte: ~"
                        fehler(error, GETTEXT("~: :OUT argument is not a pointer: ~"));
                      }
                    outargcount++;
                  }
                if (arg_flags & ff_alloca)
                  { # Room for arg itself:
                    { foreign_layout(arg_fvd);
                      # We assume all alignments are of the form 2^k.
                      cumul_size += (-cumul_size) & (data_alignment-1);
                      cumul_size += data_size;
                      # cumul_alignment = lcm(cumul_alignment,data_alignment);
                      if (data_alignment > cumul_alignment)
                        cumul_alignment = data_alignment;
                    }
                    if (arg_flags & ff_out)
                      # Room for top-level pointer in arg:
                      { var reg8 object argo_fvd = TheSvector(arg_fvd)->data[1];
                        foreign_layout(argo_fvd);
                        # We assume all alignments are of the form 2^k.
                        cumul_size += (-cumul_size) & (data_alignment-1);
                        cumul_size += data_size;
                        # cumul_alignment = lcm(cumul_alignment,data_alignment);
                        if (data_alignment > cumul_alignment)
                          cumul_alignment = data_alignment;
                      }
                      else
                      # Room for pointers in arg:
                      { var reg8 object arg = Before(rest_args_pointer STACKop -inargcount);
                        convert_to_foreign_needs(arg_fvd,arg);
                        # We assume all alignments are of the form 2^k.
                        cumul_size += (-cumul_size) & (data_alignment-1);
                        cumul_size += data_size;
                        # cumul_alignment = lcm(cumul_alignment,data_alignment);
                        if (data_alignment > cumul_alignment)
                          cumul_alignment = data_alignment;
              }   }   }
            if (!(argcount == inargcount))
              { pushSTACK(ffun);
                pushSTACK(fixnum(inargcount));
                pushSTACK(fixnum(argcount));
                pushSTACK(S(foreign_call_out));
                //: DEUTSCH "~: Zu viele Argumente (~ statt ~) für ~."
                //: ENGLISH "~: Too many arguments (~ instead of ~) to ~"
                //: FRANCAIS "~ : Trop d'arguments (~ au lieu de ~) pour ~."
                fehler(error, GETTEXT("~: Too many arguments (~ instead of ~) to ~"));
              }
          }
          #ifdef AMIGAOS
          # set register a6 as for a library call, even if not used
          # library pointer has already been validated through Fpointer_value() above
          alist.regargs[8+7-1] = (uintP)TheFpointer(TheFaddress(TheFfunction(ffun)->ff_address)->fa_base)->fp_pointer;
          #endif
         {var reg4 uintL result_count = 0;
          typedef struct { void* address; } result_descr; # fvd is pushed onto the STACK
          var DYNAMIC_ARRAY(reg10,results,result_descr,1+outargcount);
          cumul_size += (-cumul_size) & (cumul_alignment-1);
          { var DYNAMIC_ARRAY(reg10,total_room,char,cumul_size+cumul_alignment/*-1*/);
           {var reg7 void* result_address = (void*)((uintP)(total_room+result_alignment-1) & -(long)result_alignment);
            allocaing_room_pointer = (void*)((uintP)result_address + result_size);
            if (!eq(result_fvd,S(nil)))
              { pushSTACK(result_fvd); results[0].address = result_address; result_count++; }
            # Call av_start_xxx:
            do_av_start(flags,result_fvd,&alist,address,result_address,result_size,result_splittable);
            # Now pass the arguments.
            { var reg3 uintL i;
              var reg4 sintL j;
              for (i = 0, j = 0; i < allargcount; i++)
                { var reg9 object argfvds = TheFfunction(Before(rest_args_pointer))->ff_argtypes;
                  var reg5 object arg_fvd = TheSvector(argfvds)->data[2*i];
                  var reg5 uintWL arg_flags = posfixnum_to_L(TheSvector(argfvds)->data[2*i+1]);
                  var reg8 object arg;
                  if (arg_flags & ff_out)
                    { arg = unbound; } # only to avoid uninitialized variable
                    else
                    { arg = Next(rest_args_pointer STACKop -j); j++; }
                  # Allocate temporary space for the argument:
                  foreign_layout(arg_fvd);
                  { var reg4 uintL arg_size = data_size;
                    var reg4 uintL arg_alignment = data_alignment;
                    if (arg_flags & ff_alloca)
                      { allocaing_room_pointer = (void*)(((uintP)allocaing_room_pointer + arg_alignment-1) & -(long)arg_alignment);
                       {var reg7 void* arg_address = allocaing_room_pointer;
                        allocaing_room_pointer = (void*)((uintP)allocaing_room_pointer + arg_size);
                        if (arg_flags & ff_out)
                          # Pass top-level pointer only:
                          { var reg8 object argo_fvd = TheSvector(arg_fvd)->data[1];
                            foreign_layout(argo_fvd);
                            allocaing_room_pointer = (void*)(((uintP)allocaing_room_pointer + data_alignment-1) & -(long)data_alignment);
                            *(void**)arg_address = allocaing_room_pointer;
                            pushSTACK(argo_fvd); results[result_count].address = allocaing_room_pointer;
                            result_count++;
                            # Durchnullen, um uninitialisiertes Ergebnis zu vermeiden:
                            blockzero(allocaing_room_pointer,data_size);
                            allocaing_room_pointer = (void*)((uintP)allocaing_room_pointer + data_size);
                          }
                          else
                          # Convert argument:
                          { convert_to_foreign_allocaing(arg_fvd,arg,arg_address);
                            if (arg_flags & ff_inout)
                              { pushSTACK(TheSvector(arg_fvd)->data[1]); results[result_count].address = *(void**)arg_address;
                                result_count++;
                              }
                          }
                        # Call av_xxx:
                        #ifdef AMIGAOS
                        AV_ARG_REGNUM = (int)(arg_flags >> 8) - 1;
                        #endif
                        do_av_arg(flags,arg_fvd,&alist,arg_address,arg_size,arg_alignment);
                      }}
                      else
                      { var reg4 uintL arg_totalsize = arg_size+arg_alignment; # >= arg_size+arg_alignment-1, > 0
                        var DYNAMIC_ARRAY(reg10,arg_room,char,arg_totalsize);
                       {var reg7 void* arg_address = (void*)((uintP)(arg_room+arg_alignment-1) & -(long)arg_alignment);
                        if (!(arg_flags & ff_out))
                          # Convert argument:
                          { if (arg_flags & ff_malloc)
                              { convert_to_foreign_mallocing(arg_fvd,arg,arg_address); }
                              else
                              { convert_to_foreign_nomalloc(arg_fvd,arg,arg_address); }
                            if (arg_flags & ff_inout)
                              { pushSTACK(TheSvector(arg_fvd)->data[1]); results[result_count].address = *(void**)arg_address;
                                result_count++;
                              }
                          }
                        # Call av_xxx:
                        #ifdef AMIGAOS
                        AV_ARG_REGNUM = (int)(arg_flags >> 8) - 1;
                        #endif
                        do_av_arg(flags,arg_fvd,&alist,arg_address,arg_size,arg_alignment);
                        FREE_DYNAMIC_ARRAY(arg_room);
                      }}
            }   } }
            # Finally call the function.
            begin_call();
            av_call(alist);
            end_call();
            # Convert the result(s) back to Lisp.
            { var reg1 object* resptr = (&STACK_0 STACKop result_count) STACKop -1;
              var reg4 uintL i;
              for (i = 0; i < result_count; i++)
                { *resptr = convert_from_foreign(*resptr,results[i].address);
                  resptr skipSTACKop -1;
            }   }
            # Return them as multiple values.
            if (result_count >= mv_limit) { fehler_mv_zuviel(S(foreign_call_out)); }
            STACK_to_mv(result_count);
            if (flags & ff_alloca)
              { # The C functions we passed also have dynamic extent. Free them.
                # Not done now. ??
              }
            if (flags & ff_malloc)
              { result_fvd = TheFfunction(Before(rest_args_pointer))->ff_resulttype;
                free_foreign(result_fvd,result_address);
              }
            FREE_DYNAMIC_ARRAY(total_room);
          }}
          FREE_DYNAMIC_ARRAY(results);
      }}}}
      set_args_end_pointer(rest_args_pointer STACKop 1); # STACK aufräumen
  }}}

# Here is the point where we use the VACALL package.

# Call the appropriate va_start_xxx macro for the result.
# do_va_start(flags,result_fvd,alist,result_size,result_alignment,result_splittable);
  local void do_va_start (uintWL flags, object result_fvd, va_alist alist, uintL result_size, uintL result_alignment, boolean result_splittable);
  local void do_va_start(flags,result_fvd,alist,result_size,result_alignment,result_splittable)
    var reg3 uintWL flags;
    var reg1 object result_fvd;
    var reg4 va_alist alist;
    var reg5 uintL result_size;
    var reg6 uintL result_alignment;
    var reg7 boolean result_splittable;
    { if (symbolp(result_fvd))
        { if (eq(result_fvd,S(nil)))
            { va_start_void(alist); }
          elif (eq(result_fvd,S(char)) || eq(result_fvd,S(sint8)))
            { if (flags & ff_lang_ansi_c)
                { va_start_schar(alist); }
                else # `signed char' promotes to `int'
                { va_start_int(alist); }
            }
          elif (eq(result_fvd,S(uchar)) || eq(result_fvd,S(uint8)) || eq(result_fvd,S(character)))
            { if (flags & ff_lang_ansi_c)
                { va_start_uchar(alist); }
                else # `unsigned char' promotes to `unsigned int'
                { va_start_uint(alist); }
            }
          elif (eq(result_fvd,S(short)) || eq(result_fvd,S(sint16)))
            { if (flags & ff_lang_ansi_c)
                { va_start_short(alist); }
                else # `short' promotes to `int'
                { va_start_int(alist); }
            }
          elif (eq(result_fvd,S(ushort)) || eq(result_fvd,S(uint16)))
            { if (flags & ff_lang_ansi_c)
                { va_start_ushort(alist); }
                else # `unsigned short' promotes to `unsigned int'
                { va_start_uint(alist); }
            }
          elif (eq(result_fvd,S(boolean)) || eq(result_fvd,S(int))
                #if (int_bitsize==32)
                || eq(result_fvd,S(sint32))
                #endif
               )
            { va_start_int(alist); }
          elif (eq(result_fvd,S(uint))
                #if (int_bitsize==32)
                || eq(result_fvd,S(uint32))
                #endif
               )
            { va_start_uint(alist); }
          elif (eq(result_fvd,S(long))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(result_fvd,S(sint32))
                #endif
                #if (long_bitsize==64)
                || eq(result_fvd,S(sint64))
                #endif
               )
            { va_start_long(alist); }
          elif (eq(result_fvd,S(ulong))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(result_fvd,S(uint32))
                #endif
                #if (long_bitsize==64)
                || eq(result_fvd,S(uint64))
                #endif
               )
            { va_start_ulong(alist); }
          #if (long_bitsize<64)
          elif (eq(result_fvd,S(sint64)))
            { va_start_struct(alist,struct_sint64,va_word_splittable_2(uint32,uint32)); }
          elif (eq(result_fvd,S(uint64)))
            { va_start_struct(alist,struct_uint64,va_word_splittable_2(uint32,uint32)); }
          #endif
          elif (eq(result_fvd,S(single_float)))
            { if (flags & ff_lang_ansi_c)
                { va_start_float(alist); }
                else # `float' promotes to `double'
                { va_start_double(alist); }
            }
          elif (eq(result_fvd,S(double_float)))
            { va_start_double(alist); }
          elif (eq(result_fvd,S(c_pointer)) || eq(result_fvd,S(c_string)))
            { va_start_ptr(alist,void*); }
          else
            { fehler_foreign_type(result_fvd); }
        }
      elif (simple_vector_p(result_fvd))
        { var reg2 object result_fvdtype = TheSvector(result_fvd)->data[0];
          if (eq(result_fvdtype,S(c_struct)) || eq(result_fvdtype,S(c_union))
              || eq(result_fvdtype,S(c_array)) || eq(result_fvdtype,S(c_array_max))
             )
            { _va_start_struct(alist,result_size,result_alignment,result_splittable); }
          elif (eq(result_fvdtype,S(c_function))
                || eq(result_fvdtype,S(c_ptr)) 
                || eq(result_fvdtype,S(c_ptr_null))
                || eq(result_fvdtype,S(c_array_ptr))
               )
            { va_start_ptr(alist,void*); }
          else
            { fehler_foreign_type(result_fvd); }
        }
      else
        { fehler_foreign_type(result_fvd); }
    }

# Call the appropriate va_arg_xxx macro for an arguemnt
# and return its address (in temporary storage).
# do_va_arg(flags,arg_fvd,alist)
  local void* do_va_arg (uintWL flags, object arg_fvd, va_alist alist);
  local void* do_va_arg(flags,arg_fvd,alist)
    var reg3 uintWL flags;
    var reg1 object arg_fvd;
    var reg4 va_alist alist;
    { if (symbolp(arg_fvd))
        { if (eq(arg_fvd,S(nil)))
            { return NULL; }
          elif (eq(arg_fvd,S(char)) || eq(arg_fvd,S(sint8)))
            { alist->tmp._schar =
                (flags & ff_lang_ansi_c
                 ? va_arg_schar(alist)
                 : # `signed char' promotes to `int'
                   va_arg_int(alist)
                );
              return &alist->tmp._schar;
            }
          elif (eq(arg_fvd,S(uchar)) || eq(arg_fvd,S(uint8)) || eq(arg_fvd,S(character)))
            { alist->tmp._uchar =
                (flags & ff_lang_ansi_c
                 ? va_arg_uchar(alist)
                 : # `unsigned char' promotes to `unsigned int'
                   va_arg_uint(alist)
                );
              return &alist->tmp._uchar;
            }
          elif (eq(arg_fvd,S(short)) || eq(arg_fvd,S(sint16)))
            { alist->tmp._short =
                (flags & ff_lang_ansi_c
                 ? va_arg_short(alist)
                 : # `short' promotes to `int'
                   va_arg_int(alist)
                );
              return &alist->tmp._short;
            }
          elif (eq(arg_fvd,S(ushort)) || eq(arg_fvd,S(uint16)))
            { alist->tmp._ushort =
                (flags & ff_lang_ansi_c
                 ? va_arg_ushort(alist)
                 : # `unsigned short' promotes to `unsigned int'
                   va_arg_uint(alist)
                );
              return &alist->tmp._ushort;
            }
          elif (eq(arg_fvd,S(boolean)) || eq(arg_fvd,S(int))
                #if (int_bitsize==32)
                || eq(arg_fvd,S(sint32))
                #endif
               )
            { alist->tmp._int = va_arg_int(alist);
              return &alist->tmp._int;
            }
          elif (eq(arg_fvd,S(uint))
                #if (int_bitsize==32)
                || eq(arg_fvd,S(uint32))
                #endif
               )
            { alist->tmp._uint = va_arg_uint(alist);
              return &alist->tmp._uint;
            }
          elif (eq(arg_fvd,S(long))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(arg_fvd,S(sint32))
                #endif
                #if (long_bitsize==64)
                || eq(arg_fvd,S(sint64))
                #endif
               )
            { alist->tmp._long = va_arg_long(alist);
              return &alist->tmp._long;
            }
          elif (eq(arg_fvd,S(ulong))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(arg_fvd,S(uint32))
                #endif
                #if (long_bitsize==64)
                || eq(arg_fvd,S(uint64))
                #endif
               )
            { alist->tmp._ulong = va_arg_ulong(alist);
              return &alist->tmp._ulong;
            }
          #if (long_bitsize<64)
          elif (eq(arg_fvd,S(sint64)))
            { return &va_arg_struct(alist,struct_sint64); }
          elif (eq(arg_fvd,S(uint64)))
            { return &va_arg_struct(alist,struct_uint64); }
          #endif
          elif (eq(arg_fvd,S(single_float)))
            { alist->tmp._float =
                (flags & ff_lang_ansi_c
                 ? va_arg_float(alist)
                 : # `float' promotes to `double'
                   va_arg_double(alist)
                );
              return &alist->tmp._float;
            }
          elif (eq(arg_fvd,S(double_float)))
            { alist->tmp._double = va_arg_double(alist);
              return &alist->tmp._double;
            }
          elif (eq(arg_fvd,S(c_pointer)) || eq(arg_fvd,S(c_string)))
            { alist->tmp._ptr = va_arg_ptr(alist,void*);
              return &alist->tmp._ptr;
            }
          else
            { fehler_foreign_type(arg_fvd); }
        }
      elif (simple_vector_p(arg_fvd))
        { var reg2 object arg_fvdtype = TheSvector(arg_fvd)->data[0];
          if (eq(arg_fvdtype,S(c_struct)) || eq(arg_fvdtype,S(c_union))
              || eq(arg_fvdtype,S(c_array)) || eq(arg_fvdtype,S(c_array_max))
             )
            { foreign_layout(arg_fvd);
             {var reg5 uintL arg_size = data_size;
              var reg6 uintL arg_alignment = data_alignment;
              return _va_arg_struct(alist,arg_size,arg_alignment);
            }}
          elif (eq(arg_fvdtype,S(c_function))
                || eq(arg_fvdtype,S(c_ptr)) 
                || eq(arg_fvdtype,S(c_ptr_null))
                || eq(arg_fvdtype,S(c_array_ptr))
               )
            { alist->tmp._ptr = va_arg_ptr(alist,void*);
              return &alist->tmp._ptr;
            }
          else
            { fehler_foreign_type(arg_fvd); }
        }
      else
        { fehler_foreign_type(arg_fvd); }
    }

# Call the appropriate va_return_xxx macro for the result.
# do_va_return(flags,result_fvd,alist,result_size,result_alignment);
  local void do_va_return (uintWL flags, object result_fvd, va_alist alist, void* result_address, uintL result_size, uintL result_alignment);
  local void do_va_return(flags,result_fvd,alist,result_address,result_size,result_alignment)
    var reg4 uintWL flags;
    var reg1 object result_fvd;
    var reg5 va_alist alist;
    var reg3 void* result_address;
    var reg6 uintL result_size;
    var reg7 uintL result_alignment;
    { if (symbolp(result_fvd))
        { if (eq(result_fvd,S(nil)))
            { va_return_void(alist); }
          elif (eq(result_fvd,S(char)) || eq(result_fvd,S(sint8)))
            { if (flags & ff_lang_ansi_c)
                { va_return_schar(alist,*(sint8*)result_address); }
                else # `signed char' promotes to `int'
                { va_return_int(alist,*(sint8*)result_address); }
            }
          elif (eq(result_fvd,S(uchar)) || eq(result_fvd,S(uint8)) || eq(result_fvd,S(character)))
            { if (flags & ff_lang_ansi_c)
                { va_return_uchar(alist,*(uint8*)result_address); }
                else # `unsigned char' promotes to `unsigned int'
                { va_return_uint(alist,*(uint8*)result_address); }
            }
          elif (eq(result_fvd,S(short)) || eq(result_fvd,S(sint16)))
            { if (flags & ff_lang_ansi_c)
                { va_return_short(alist,*(sint16*)result_address); }
                else # `short' promotes to `int'
                { va_return_int(alist,*(sint16*)result_address); }
            }
          elif (eq(result_fvd,S(ushort)) || eq(result_fvd,S(uint16)))
            { if (flags & ff_lang_ansi_c)
                { va_return_ushort(alist,*(uint16*)result_address); }
                else # `unsigned short' promotes to `unsigned int'
                { va_return_uint(alist,*(uint16*)result_address); }
            }
          elif (eq(result_fvd,S(boolean)) || eq(result_fvd,S(int))
                #if (int_bitsize==32)
                || eq(result_fvd,S(sint32))
                #endif
               )
            { va_return_int(alist,*(int*)result_address); }
          elif (eq(result_fvd,S(uint))
                #if (int_bitsize==32)
                || eq(result_fvd,S(uint32))
                #endif
               )
            { va_return_uint(alist,*(unsigned int *)result_address); }
          elif (eq(result_fvd,S(long))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(result_fvd,S(sint32))
                #endif
                #if (long_bitsize==64)
                || eq(result_fvd,S(sint64))
                #endif
               )
            { va_return_long(alist,*(long*)result_address); }
          elif (eq(result_fvd,S(ulong))
                #if (int_bitsize<32) && (long_bitsize==32)
                || eq(result_fvd,S(uint32))
                #endif
                #if (long_bitsize==64)
                || eq(result_fvd,S(uint64))
                #endif
               )
            { va_return_ulong(alist,*(unsigned long *)result_address); }
          #if (long_bitsize<64)
          elif (eq(result_fvd,S(sint64)))
            { va_return_struct(alist,struct_sint64,*(struct_sint64*)result_address); }
          elif (eq(result_fvd,S(uint64)))
            { va_return_struct(alist,struct_uint64,*(struct_uint64*)result_address); }
          #endif
          elif (eq(result_fvd,S(single_float)))
            { if (flags & ff_lang_ansi_c)
                { va_return_float(alist,*(float*)result_address); }
                else # `float' promotes to `double'
                { va_return_double(alist,*(float*)result_address); }
            }
          elif (eq(result_fvd,S(double_float)))
            { va_return_double(alist,*(double*)result_address); }
          elif (eq(result_fvd,S(c_pointer)) || eq(result_fvd,S(c_string)))
            { va_return_ptr(alist,void*,*(void**)result_address); }
          else
            { fehler_foreign_type(result_fvd); }
        }
      elif (simple_vector_p(result_fvd))
        { var reg2 object result_fvdtype = TheSvector(result_fvd)->data[0];
          if (eq(result_fvdtype,S(c_struct)) || eq(result_fvdtype,S(c_union))
              || eq(result_fvdtype,S(c_array)) || eq(result_fvdtype,S(c_array_max))
             )
            { _va_return_struct(alist,result_size,result_alignment,result_address); }
          elif (eq(result_fvdtype,S(c_function))
                || eq(result_fvdtype,S(c_ptr)) 
                || eq(result_fvdtype,S(c_ptr_null))
                || eq(result_fvdtype,S(c_array_ptr))
               )
            { va_return_ptr(alist,void*,*(void**)result_address); }
          else
            { fehler_foreign_type(result_fvd); }
        }
      else
        { fehler_foreign_type(result_fvd); }
    }

# This is the CALL-IN function called by the trampolines.
  local void callback ();
  local void callback(alist)
    va_alist alist;
    { var reg1 uintL index = (uintL)trampvar;
      begin_callback();
     {var reg2 object* triple = &TheSvector(TheArray(O(foreign_callin_vector))->data)->data[3*index-2];
      var reg4 object fun = triple[0];
      var reg1 object ffun = triple[1];
      var reg3 uintWL flags = posfixnum_to_L(TheFfunction(ffun)->ff_flags);
      var reg5 object result_fvd = TheFfunction(ffun)->ff_resulttype;
      var reg9 object argfvds = TheFfunction(ffun)->ff_argtypes;
      var reg6 uintL argcount = TheSvector(argfvds)->length/2;
      pushSTACK(result_fvd);
      pushSTACK(fun);
      pushSTACK(argfvds);
      switch (flags & 0xFF00)
        { # For the moment, the only supported languages are "C" and "ANSI C".
          case ff_lang_c:
          case ff_lang_ansi_c:
            break;
          default:
            fehler_function_no_fvd(ffun,S(foreign_call_in));
        }
      foreign_layout(result_fvd);
      { var reg7 uintL result_size = data_size;
        var reg8 uintL result_alignment = data_alignment;
        var reg10 boolean result_splittable = data_splittable;
        # Call va_start_xxx:
        do_va_start(flags,result_fvd,alist,result_size,result_alignment,result_splittable);
        # Walk through the arguments, convert them to Lisp data:
        { var reg2 uintL i;
          for (i = 0; i < argcount; i++)
            { var reg9 object argfvds = STACK_(i);
              var reg1 object arg_fvd = TheSvector(argfvds)->data[2*i];
              var reg9 uintWL arg_flags = posfixnum_to_L(TheSvector(argfvds)->data[2*i+1]);
              var reg4 void* arg_addr = do_va_arg(flags,arg_fvd,alist);
              var reg5 object arg = convert_from_foreign(arg_fvd,arg_addr);
              if (arg_flags & ff_malloc)
                { free_foreign(arg_fvd,arg_addr); }
              pushSTACK(arg);
        }   }
        # Call the Lisp function:
        funcall(STACK_(1+argcount),argcount);
        # Allocate space for the result:
        { var DYNAMIC_ARRAY(reg10,result_room,char,result_size+result_alignment/*-1*/);
         {var reg7 void* result_address = (void*)((uintP)(result_room+result_alignment-1) & -(long)result_alignment);
        # Convert the result:
          if (flags & ff_malloc)
            { convert_to_foreign_mallocing(STACK_2,value1,result_address); }
            else
            { convert_to_foreign_nomalloc(STACK_2,value1,result_address); }
        # Call va_return_xxx:
          do_va_return(flags,STACK_2,alist,result_address,result_size,result_alignment);
          FREE_DYNAMIC_ARRAY(result_room);
        }}
      }
      skipSTACK(3);
      end_callback();
    }}


#ifdef AMIGAOS

# O(foreign_libraries) is an alist of all open libraries.

# Open a library.
  local struct Library * open_library (object name, uintL version);
  local struct Library * open_library(name,version)
    var reg5 object name;
    var reg6 uintL version;
    { var reg4 struct Library * libaddr;
      with_string_0(name,libname,
        { begin_system_call();
          libaddr = OpenLibrary(libname,version);
          end_system_call();
        });
      if (libaddr == NULL)
        { pushSTACK(name);
          pushSTACK(S(foreign_library));
          //: DEUTSCH "~: Kann Bibliothek ~ nicht öffnen."
          //: ENGLISH "~: Cannot open library ~"
          //: FRANCAIS "~ : Ne peux ouvrir bibliothèque ~."
          fehler(error, GETTEXT("~: Cannot open library ~"));
        }
      return libaddr;
    }

# (FFI::FOREIGN-LIBRARY name [required-version])
# returns a foreign library specifier.
LISPFUN(foreign_library,1,1,norest,nokey,0,NIL)
  { var reg2 object name = STACK_1;
    var reg6 uintL v;
    if (!stringp(name)) { fehler_string(name); }
    { var reg7 object version = STACK_0;
      if (eq(STACK_0,unbound))
        { v = 0; }
      else
        { check_uint32(version); v = I_to_uint32(version); }
    }
    # Check whether the library is on the alist or has already been opened.
    { var reg1 object alist = O(foreign_libraries);
      while (consp(alist))
        { if (equal(name,Car(Car(alist))))
            { var reg4 object address = Cdr(Car(alist));
              var reg3 object lib = TheFaddress(address)->fa_base;
              if (!fp_validp(TheFpointer(lib)))
                # Library already existed in a previous Lisp session.
                # Update the address, and make it valid.
                { var reg5 struct Library * libaddr = open_library(name,v);
                  TheFpointer(lib)->fp_pointer = libaddr;
                  mark_fp_valid(TheFpointer(lib));
                }
              value1 = address;
              goto done;
            }
          alist = Cdr(alist);
    }   }
    # Pre-allocate room:
    pushSTACK(allocate_cons()); pushSTACK(allocate_cons());
    pushSTACK(allocate_fpointer((void*)0));
    pushSTACK(allocate_faddress());
    # Open the library:
    { var reg5 struct Library * libaddr = open_library(STACK_(1+4),v);
      var reg4 object lib = popSTACK();
      TheFpointer(STACK_0)->fp_pointer = libaddr;
      TheFaddress(lib)->fa_base = popSTACK();
      TheFaddress(lib)->fa_offset = 0;
      value1 = lib;
     {var reg1 object acons = popSTACK();
      var reg3 object new_cons = popSTACK();
      Car(acons) = STACK_1; Cdr(acons) = lib;
      Car(new_cons) = acons; Cdr(new_cons) = O(foreign_libraries);
      O(foreign_libraries) = new_cons;
    }}
    done:
    mv_count=1; skipSTACK(2);
  }

# Try to make a Foreign-Pointer valid again.
# validate_fpointer(obj);
  global void validate_fpointer (object obj);
  global void validate_fpointer(obj)
    var reg3 object obj;
    { # If the foreign pointer belongs to a foreign library from a previous
      # session, we reopen the library.
      { var reg1 object l = O(foreign_libraries);
        while (consp(l))
          { var reg2 object acons = Car(l);
            l = Cdr(l);
            if (eq(TheFaddress(Cdr(acons))->fa_base,obj))
              { var reg4 struct Library * libaddr = open_library(Car(acons),0); # version ??
                TheFpointer(obj)->fp_pointer = libaddr;
                mark_fp_valid(TheFpointer(obj));
                return;
      }   }   }
      fehler_fpointer_invalid(obj);
    }

# (FFI::FOREIGN-ADDRESS-VARIABLE name library offset c-type)
# returns a foreign variable.
LISPFUNN(foreign_library_variable,4)
  { if (!mstringp(STACK_3)) { fehler_string(STACK_3); }
    STACK_3 = coerce_ss(STACK_3);
    if (!faddressp(STACK_2))
      { pushSTACK(STACK_2);
        pushSTACK(TheSubr(subr_self)->name);
        //: DEUTSCH "~: Argument ist keine Foreign-Adresse: ~"
        //: ENGLISH "~: argument is not a foreign address: ~"
        //: FRANCAIS "~ : l'argument n'est pas une adresse étrangère : ~."
        fehler(error, GETTEXT("~: argument is not a foreign address: ~"));
      }
    check_sint32(STACK_1);
    foreign_layout(STACK_0);
   {var reg3 uintL size = data_size;
    var reg2 uintL alignment = data_alignment;
    pushSTACK(make_faddress(TheFaddress(STACK_2)->fa_base,
                            TheFaddress(STACK_2)->fa_offset
                            + (sintP)I_to_sint32(STACK_1)));
    { var reg1 object fvar = allocate_fvariable();
      TheFvariable(fvar)->fv_name = STACK_(3+1);
      TheFvariable(fvar)->fv_address = STACK_0;
      TheFvariable(fvar)->fv_size = fixnum(size);
      TheFvariable(fvar)->fv_type = STACK_(0+1);
      if (!(((uintP)Faddress_value(TheFvariable(fvar)->fv_address) & (alignment-1)) == 0))
        { pushSTACK(fvar);
          pushSTACK(TheSubr(subr_self)->name);
          //: DEUTSCH "~: Foreign-Variable ~ hat nicht das geforderte Alignment."
          //: ENGLISH "~: foreign variable ~ does not have the required alignment"
          //: FRANCAIS "~ : variable étrangère ~ n'a pas le placement nécessaire."
          fehler(error, GETTEXT("~: foreign variable ~ does not have the required alignment"));
        }
      value1 = fvar; mv_count=1; skipSTACK(4+1);
  }}}

# (FFI::FOREIGN-LIBRARY-FUNCTION name library offset c-function-type)
# returns a foreign function.
LISPFUNN(foreign_library_function,4)
  { if (!mstringp(STACK_3)) { fehler_string(STACK_3); }
    STACK_3 = coerce_ss(STACK_3);
    if (!faddressp(STACK_2)) # TODO? search in O(foreign_libraries)
      { pushSTACK(STACK_2);
        pushSTACK(TheSubr(subr_self)->name);
        //: DEUTSCH "~: ~ ist keine Bibliothek."
        //: ENGLISH "~: ~ is not a library"
        //: FRANCAIS "~ : ~ n'est pas une bibliothèque."
        fehler(error, GETTEXT("~: ~ is not a library"));
      }
    check_sint32(STACK_1);
    { var reg1 object fvd = STACK_0;
      if (!(simple_vector_p(fvd)
            && (TheSvector(fvd)->length == 4)
            && eq(TheSvector(fvd)->data[0],S(c_function))
            && m_simple_vector_p(TheSvector(fvd)->data[2])
         ) )
        { var reg1 object *fvd_ptr;
          pushSTACK(fvd); fvd_ptr=&STACK_0;
          dynamic_bind(S(print_circle),T); # *PRINT-CIRCLE* an T binden
          pushSTACK(*fvd_ptr);
          pushSTACK(TheSubr(subr_self)->name);
          //: DEUTSCH "~: ungültiger Typ für externe Funktion: ~"
          //: ENGLISH "~: illegal foreign function type ~"
          //: FRANCAIS "~ : type invalide de fonction externe : ~"
          fehler(error, GETTEXT("~: illegal foreign function type ~"));
        }
    }
    pushSTACK(make_faddress(TheFaddress(STACK_2)->fa_base,
                            TheFaddress(STACK_2)->fa_offset
                            + (sintP)I_to_sint32(STACK_1)));
    { var reg1 object ffun = allocate_ffunction();
      var reg2 object fvd = STACK_(0+1);
      TheFfunction(ffun)->ff_name = STACK_(3+1);
      TheFfunction(ffun)->ff_address = STACK_0;
      TheFfunction(ffun)->ff_resulttype = TheSvector(fvd)->data[1];
      TheFfunction(ffun)->ff_argtypes = TheSvector(fvd)->data[2];
      TheFfunction(ffun)->ff_flags = TheSvector(fvd)->data[3];
      value1 = ffun; mv_count=1; skipSTACK(4+1);
  } }

#else # UNIX

# Try to make a Foreign-Pointer valid again.
# validate_fpointer(obj);
  global void validate_fpointer (object obj);
  global void validate_fpointer(obj)
    var reg1 object obj;
    { # Can't do anything.
      fehler_fpointer_invalid(obj);
    }

#endif

# Initialize the FFI.
  global void init_ffi (void);
  global void init_ffi()
    { # Make vacall() call callback():
      vacall_function = &callback;
      # Allocate a fresh zero foreign pointer:
      O(fp_zero) = allocate_fpointer((void*)0);
    }

# De-Initialize the FFI.
  global void exit_ffi (void);
  global void exit_ffi()
    {
      #ifdef AMIGAOS
      # Close all foreign libraries.
      { var reg1 object alist = O(foreign_libraries);
        while (consp(alist))
          { var reg4 object acons = Car(alist);
            var reg3 object obj = TheFaddress(Cdr(acons))->fa_base;
            if (fp_validp(TheFpointer(obj)))
              { var reg2 struct Library * libaddr = (struct Library *)(TheFpointer(obj)->fp_pointer);
                begin_system_call();
                CloseLibrary(libaddr);
                end_system_call();
              }
            alist = Cdr(alist);
          }
        O(foreign_libraries) = NIL;
      }
      #endif
    }

#endif

