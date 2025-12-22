# AFFI Poor man's simple foreign function calls
# Jörg Höhle 11.8.1996

#include "lispbibl.c"
# TODO? check offset against number of library vectors
# TODO: LISPFUN(%CHECK-PROTO) by calling a do-nothing function
# TODO: LISPFUN(VALIDP)             \
# TODO: LISPFUN(INVALIDATE-FOREIGN)  +- useful with FINALIZE
# TODO: LISPFUN(FOREIGN-NULLP)      /

#ifdef HAVE_AFFI

# die Moduldefinition ist am Dateiende

#ifdef MC680X0
  #undef HAVE_REG_FF_CALL
  #define HAVE_REG_FF_CALL

  #define reg_num  15
  #define reg_coding 4 # used bits in mask
  struct reg_map { ULONG reg[reg_num]; }; # d0-7,a0-6. a7 ist sp und nicht belegbar

  #ifdef AMIGAOS
    #define libbase_reg 14 # a6 wird mit der Librarybase belegt
  #endif

  #if defined(GNU) && !defined(NO_ASM)
  local ULONG reg_call (aint address, struct reg_map *);
  local ULONG reg_call(address, regs)
    var reg2 aint address;
    var reg1 struct reg_map *regs;
    { var reg3 ULONG result  __asm__("d0");
  #if 1 # DEBUG
      begin_system_call();
      asm("
          moveml #0x3f3e,sp@-     | d2-d7,a2-a6
        | pea pc@(Lgoon)          | ATTN: BUG: previous gas needed pc@(Lgoon+2)
          pea Lgoon               | ATTN: BUG: as-2.5.x makes 68020 code for pea pc@(Lgoon)
          movel %1,sp@-           | where to jump
          moveml %2@,#0x7fff      | a6-a0,d7-d0
          rts                     | jump
        Lgoon:
          moveml sp@+,#0x7cfc     | a6-a2,d7-d2
  "
          : "=d" (result)
          : "r" (address), "a" (regs)
          : "memory");
      end_system_call();
  #elif 0
      begin_system_call();
      asm("
          moveml #0x3f3e,sp@-     | d2-d7,a2-a6
          movel %1,sp@-           | where to jump
          moveml %2@,#0x7fff      | a6-a0,d7-d0
          jbsr sp@(4)             | call function
          addqw #4,sp             | pop address
          moveml sp@+,#0x7cfc     | a6-a2,d7-d2
  "
          : "=d" (result)
          : "r" (address), "a" (regs)
          : "memory");
      end_system_call();
  #else
      var reg1 uintC count = reg_num;
      asciz_out("Sprungadresse "); hex_out(address); asciz_out("\n");
      dotimesC(count,count,
        { dez_out(count); asciz_out(": "); hex_out(regs->reg[count]); asciz_out("\n"); });
      result = regs->reg[0];
  #endif # DEBUG
      return result;
    }
  #endif # GNU
#endif # MC680X0


# stattdessen fehler_funspec verwenden?
nonreturning_function(local, fehler_ffi_nocall, (object ffinfo));
local void fehler_ffi_nocall(ffinfo)
  var reg1 object ffinfo;
  { pushSTACK(ffinfo); pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Nicht unterstützter Aufrufmechanismus: ~"
    //: ENGLISH "~: Unsupported call mechanism: ~"
    //: FRANCAIS "~: Convention d'appel non supportée : ~"
    fehler(control_error,GETTEXT("~: Unsupported call mechanism: ~"));
  }

nonreturning_function(local, fehler_ffi_proto, (object ffinfo));
local void fehler_ffi_proto(ffinfo)
  var reg1 object ffinfo;
  { pushSTACK(ffinfo);
    pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Ungültiger Funktionsprototyp: ~"
    //: ENGLISH "~: Bad function prototype: ~"
    //: FRANCAIS "~ : Mauvais prototype : ~"
    fehler(program_error,GETTEXT("~: Bad function prototype: ~"));
  }

nonreturning_function(local, fehler_ffi_argcount, (object ffinfo));
local void fehler_ffi_argcount(ffinfo)
  var reg1 object ffinfo;
  { pushSTACK(ffinfo);
    pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Unpassende Anzahl Argumente für Prototyp ~."
    //: ENGLISH "~: Wrong number of arguments for prototype ~"
    //: FRANCAIS "~: Mauvais nombre d'arguments pour le prototype ~."
    fehler(program_error,GETTEXT("~: Wrong number of arguments for prototype ~"));
  }

nonreturning_function(local, fehler_ffi_argtype, (object obj, object type, object ffinfo));
local void fehler_ffi_argtype(obj,type,ffinfo)
  var reg2 object obj;
  var reg1 object type; # wird nur unpräzise verwendet
  var reg3 object ffinfo;
  { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
    pushSTACK(fixnump(type) ? S(integer) : T); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
    pushSTACK(obj); pushSTACK(ffinfo); pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Unpassendes Argument für Prototyp ~: ~"
    //: ENGLISH "~: Bad argument for prototype ~: ~"
    //: FRANCAIS "~: Argument incorrect pour le prototype ~ : ~"
    fehler(type_error,GETTEXT("~: Bad argument for prototype ~: ~"));
  }

#define fehler_ffi_type  fehler_ffi_arg
nonreturning_function(local, fehler_ffi_arg, (object obj));
local void fehler_ffi_arg(obj)
  var reg1 object obj;
  { pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
    //: DEUTSCH "~: Unpassendes Argument: ~"
    //: ENGLISH "~: Bad argument: ~"
    //: FRANCAIS "~: Argument incorrect : ~"
    fehler(control_error,GETTEXT("~: Bad argument: ~"));
  }

# Lese gültige Adresse inklusive Offset
local aint convert_address (object obj, object offset);
local aint convert_address(obj, offset)
  var reg1 object obj;
  var reg3 object offset;
  { var reg2 aint address = 0;
    if (uint32_p(obj))
      { address = I_to_UL(obj); }
    elif (fpointerp(obj) && fp_validp(TheFpointer(obj)))
      { address = (aint)(TheFpointer(obj)->fp_pointer); }
    if (address == 0)
      { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
        pushSTACK(S(unsigned_byte)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
        pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
        //: DEUTSCH "~: ~ ist keine gültige Adresse."
        //: ENGLISH "~: ~ is not a valid address"
        //: FRANCAIS "~: ~ n'est pas une bonne adresse."
        fehler(type_error,GETTEXT("~: ~ is not a valid address"));
      }
    if (!eq(offset,unbound))
      { address += I_to_L(offset); }
    return address;
  }


#if defined(HAVE_LONGLONG) && 1 # benötigt Funktionen aus INTELEM.D und LISPBIBL.D
#define uintbig  uint64
#define uintbig_p(obj)  uint64_p(obj) # reicht für reg_num <= 16 (AmigaOS)
#define I_to_Ubig(obj)  I_to_UQ(obj)
#else
#define uintbig  uintL
#define uintbig_p(obj)  uint32_p(obj) # reicht nicht für reg_num > 8
#define I_to_Ubig(obj)  I_to_UL(obj)
#endif

# Führt Funktionsaufruf aus und erzeugt LISP-Ergebnis.
# Die Argumente müssen zuvor überprüft worden sein (Typ und Zahl)
# < value1, mv_count
local void affi_callit (aint address, object ffinfo, aint* args);
local void affi_callit(address, ffinfo, args)
  var reg6 aint address;
  var object ffinfo;
  var reg4 aint* args;
  { var reg7 sintL offset;
    var reg3 object mask;
    var reg3 aint thing;
    { var reg4 object both = TheSvector(ffinfo)->data[0];
      if (nullp(both))
        { mask = NIL;
          offset = 0;
        }
      elif (consp(both))
        { mask = Cdr(both);
          offset = I_to_L(Car(both)); # nur fixnum_to_L() (dann mit Überprüfung) ?
        }
      else goto bad_proto;
    }
    if (nullp(mask))
      { # Stack-based call mechanism
        #ifdef HAVE_STACK_FF_CALL
        thing = stack_call(address+offset,args,ffinfo);
        #else
        goto bad_call;
        #endif
      }
    elif (integerp(mask))
      { # Register-based call mechanism
        #ifdef HAVE_REG_FF_CALL
        var struct reg_map regs;
        if (uintbig_p(mask))
          {
            var reg2 uintC count = TheSvector(ffinfo)->length-2;
            #ifdef AMIGAOS # Always fill a6 with possible library base address
            regs.reg[libbase_reg] = address;
            #endif
            if (eq(mask,Fixnum_0))
              { if (count!=0) goto bad_proto; }
              else
              { var reg5 unsigned_int_with_n_bits(reg_num) used = 0;
                var reg3 uintbig lowmask = I_to_Ubig(mask);
                dotimesC(count,count,
                  { var reg1 uintBW index = (lowmask & (bit(reg_coding)-1));
                    index = index-1; # 0 gilt nicht als Index
                    if (index >= reg_num || bit_test(used,index)) goto bad_proto;
                    used |= bit(index);
                    regs.reg[index] = *args++;
                    lowmask >>= reg_coding;
                  });
                if (lowmask!=0) goto bad_proto;
          }   }
        else goto bad_proto;
        # Regcall ausführen
        thing = reg_call(address+offset,&regs);
        #else
        goto bad_call;
        #endif
      }
    else
      { bad_proto:
        fehler_ffi_proto(ffinfo);
        bad_call:
        fehler_ffi_nocall(ffinfo);
      }
    # Aufruf erfolgreich, Werte setzen
    # Ergebnis kann bei GC (wegen String oder Bignum) und RESET verloren gehen
    { var reg2 object rtype = TheSvector(ffinfo)->data[1];
      if (eq(rtype,NIL))
        { mv_count=0; value1 = NIL; }
        else
        { if (fixnump(rtype))
            { switch(fixnum_to_L(rtype))
                { case  4L: value1 = UL_to_I(thing); break;
                  case  2L: value1 = UL_to_I((uint16)thing); break;
                  case  1L: value1 = UL_to_I((uint8)thing); break;
                  case  0L: value1 = thing ? T : NIL; break; # Typ BOOL
                  case -1L: value1 = L_to_I((sint8)thing); break;
                  case -2L: value1 = L_to_I((sint16)thing); break;
                  case -4L: value1 = L_to_I(thing); break;
                  # andere Fälle wurde schon mit Fehler abgefangen
                  default: value1 = NIL;
            }   }
          elif (eq(rtype,S(string)))    # string
            { value1 = (thing == 0) ? NIL : asciz_to_string((char*)thing); }
          elif (eq(rtype,S(mal)))       # *
            { value1 = UL_to_I(thing); }
          elif (eq(rtype,S(Kexternal))) # :external
            { value1 = (thing == 0) ? NIL : allocate_fpointer((FOREIGN)thing); }
          # andere Fälle wurden schon mit Fehler abgefangen
          else { value1 = NIL; }
          mv_count=1;
  } }   }


# Führt Typüberprüfungen und Aufruf aus. Ermittelt dabei und belegt
# mittels alloca() die Größe des Bereichs für die LISP-STRING nach C
# (asciz) Umwandlung
# Darf bis zum Aufruf keine GC auslösen.
# < value1, mv_count
local void affi_call_argsa (aint address, object ffinfo, object* args, uintC count);
local void affi_call_argsa(address, ffinfo, args, count)
  var aint address;
  var reg3 object ffinfo;
  var reg7 object* args;
  var reg4 uintC count;
  { # if (!simple_vector_p(ffinfo)) goto bad_proto; # oder fehler_kein_svector();
    # Zahl der Argumente überprüfen
    { var reg1 uintL vlen = TheSvector(ffinfo)->length;
      if (vlen != count+2) { fehler_ffi_argcount(ffinfo); }
    }
    # Return-Type schon vor dem Aufruf überprüfen
    { var reg2 object rtype = TheSvector(ffinfo)->data[1];
      if (fixnump(rtype))
        { var reg1 sintL size = fixnum_to_L(rtype);
          if (size < 0) { size = -size; }
          if (size > 4 || size == 3) goto bad_proto;
        }
      elif (!( nullp(rtype) || eq(rtype,S(mal)) || eq(rtype,S(Kexternal)) || eq(rtype,S(string)) )) goto bad_proto;
    }
    # Typprüfung und Speicherung (auf Stack SP) der Argumente
    #define ACCEPT_ADDR_ARG      bit(0)
    #define ACCEPT_STRING_ARG    bit(1)
    #define ACCEPT_UBVECTOR_ARG  bit(2)
    #define ACCEPT_MAKE_ASCIZ    bit(3)
    #define ACCEPT_NIL_ARG       bit(4)
    #define ACCEPT_NUM_ARG       bit(5)
    { var DYNAMIC_ARRAY(,things,aint,count);
      var reg6 object* types = &TheSvector(ffinfo)->data[2];
      var reg8 aint* thing = &things[0];
      dotimesC(count,count,
        { var reg2 object type = *types++;
          var reg3 object arg = NEXT(args);
          if (fixnump(type))
            { if (integerp(arg))
                { switch (fixnum_to_L(type))
                    { case 1L:
                        if (!uint8_p(arg)) goto bad_arg; # Fehlermeldung mit O(type_uint8) denkbar
                          else *thing = I_to_uint8(arg);
                        break;
                      case 2L:
                        if (!uint16_p(arg)) goto bad_arg;
                          else *thing = I_to_uint16(arg);
                        break;
                      case 4L:
                        if (!uint32_p(arg)) goto bad_arg;
                          else *thing = I_to_uint32(arg);
                        break;
                      case -1L:
                        if (!sint8_p(arg)) goto bad_arg;
                          else *thing = I_to_sint8(arg);
                        break;
                      case -2L:
                        if (!sint16_p(arg)) goto bad_arg;
                          else *thing = I_to_sint16(arg);
                        break;
                      case -4L:
                        if (!sint32_p(arg)) goto bad_arg;
                          else *thing = I_to_sint32(arg);
                        break;
                      default: goto bad_proto;
                }   }
                else
                { bad_arg:
                  fehler_ffi_argtype(arg,type,ffinfo);
            }   }
            else # !fixnump(type)
            { var reg1 uintBWL accept;
              if (eq(type,S(mal))) # Zeiger
                  { accept = ACCEPT_ADDR_ARG | ACCEPT_UBVECTOR_ARG | ACCEPT_STRING_ARG | ACCEPT_MAKE_ASCIZ | ACCEPT_NIL_ARG; }
              elif (eq(type,S(string)))
                  { accept = ACCEPT_ADDR_ARG | ACCEPT_STRING_ARG | ACCEPT_MAKE_ASCIZ | ACCEPT_NIL_ARG; }
              elif (eq(type,S(Kio)))
                  { accept = ACCEPT_ADDR_ARG | ACCEPT_UBVECTOR_ARG | ACCEPT_STRING_ARG; }
              elif (eq(type,S(Kexternal)))
                  { accept = ACCEPT_ADDR_ARG | ACCEPT_NIL_ARG; }
              else goto bad_proto;
              switch (typecode(arg))
                { case_posfixnum: case_posbignum:
                    if (!(accept & ACCEPT_ADDR_ARG)) goto bad_arg;
                    *thing = (aint)I_to_UL(arg);
                    break;
                  case_string:
                    if (!(accept & ACCEPT_STRING_ARG)) goto bad_arg;
                    # Cf. with_string_0() macro in lispbibl.d
                    { var uintL length;
                      var reg2 uintB* charptr = unpack_string(arg,&length);
                      if (accept & ACCEPT_MAKE_ASCIZ)
                        { var reg1 uintB* ptr = alloca(1+length); # TODO Ergebnis testen
                          *thing = (aint)ptr;
                          dotimesL(length,length, { *ptr++ = *charptr++; } );
                          *ptr = '\0';
                        }
                        else
                        { *thing = (aint)charptr; }
                    }
                    break;
                  case_symbol:
                    if (!(accept & ACCEPT_NIL_ARG)) goto bad_arg;
                    if (!nullp(arg)) goto bad_arg;
                    *thing = (aint)0;
                    break;
                  case_orecord:
                    if (!(accept & ACCEPT_ADDR_ARG)) goto bad_arg;
                    if (!((TheRecord(arg)->rectype == Rectype_Fpointer)
                          && fp_validp(TheFpointer(arg)))) goto bad_arg;
                    *thing = (aint)(TheFpointer(arg)->fp_pointer);
                    break;
                  case_obvector:
                    if (!(accept & ACCEPT_UBVECTOR_ARG)) goto bad_arg;
                    { var reg1 uintBWL bsize = TheArray(arg)->flags & arrayflags_atype_mask;
                      if (!((bsize==Atype_8Bit) || (bsize==Atype_16Bit) || (bsize==Atype_32Bit))) goto bad_arg;
                     {var uintL index = 0;
                      arg = array1_displace_check(arg,0,&index); # UNSAFE
                      *thing = (aint)&TheSbvector(TheArray(arg)->data)->data[index];
                    }}
                    break;
                  default: goto bad_arg;
            }   }
          thing++;
        });
      affi_callit(address,ffinfo,&things[0]);
      FREE_DYNAMIC_ARRAY(things);
      return;
    }
    bad_proto:
    fehler_ffi_proto(ffinfo);
  }

# (SYSTEM::%LIBCALL base ff-description &rest args)
# kann GC auslösen (nach erfolgtem Aufruf)
LISPFUN(affi_libcall,2,0,rest,nokey,0,NIL)
  { var reg1 object ffinfo = Before(rest_args_pointer); # #((offset . mask) return-type . arg-types*))
    var reg2 aint address = convert_address(Before(rest_args_pointer STACKop 1),unbound);
    if (!simple_vector_p(ffinfo))
      { fehler_kein_svector(TheSubr(subr_self)->name,ffinfo); }
    affi_call_argsa(address,ffinfo,rest_args_pointer,argcount);
    # value1 und mv_count wurden darin gesetzt
    set_args_end_pointer(rest_args_pointer STACKop 2);
  }


local void bytecopy (void* to, const void* from, uintL length, uintC size);
local void bytecopy(to,from,length,size)
  var reg3 void* to;
  var reg2 const void* from;
  var reg1 uintL length;
  var reg4 uintC size;
  { switch (size)
      { case 1: case 8:
          dotimesL(length,length, { *((UBYTE*)to)++ = *((UBYTE*)from)++; }); break;
        case 2: case 16:
          dotimesL(length,length, { *((UWORD*)to)++ = *((UWORD*)from)++; }); break;
        case 4: case 32:
          dotimesL(length,length, { *((ULONG*)to)++ = *((ULONG*)from)++; }); break;
        default:
          /* NOTREACHED */
  }   }

# (SYSTEM::MEM-READ address into [offset]) reads from address[+offset].
# kann GC auslösen
LISPFUN(mem_read,2,1,norest,nokey,0,NIL)
  { var reg2 aint address = convert_address(STACK_2,STACK_0);
    # TODO? address could be a LISP string or vector. Better not
    var reg3 object into = STACK_1; # Größe in Byte, '*, 'STRING, string oder vector
    skipSTACK(3);
    if (eq(into,S(mal))) # pointer dereference
      { value1 = UL_to_I(*(aint*)address); }
    elif (posfixnump(into))
      { var reg1 uintL content;
        switch (posfixnum_to_L(into))
          { case 1L: content = *(UBYTE *)address; break;
            case 2L: content = *(UWORD *)address; break;
            case 4L: content = *(ULONG *)address; break;
            default: goto fehler_type;
          }
        value1 = UL_to_I(content);
      }
    elif (fixnump(into))
      { var reg1 sintL content;
        switch (negfixnum_to_L(into))
          { case -1L: content = *(BYTE *)address; break;
            case -2L: content = *(WORD *)address; break;
            case -4L: content = *(LONG *)address; break;
            default: goto fehler_type;
          }
        value1 = L_to_I(content);
      }
    elif (eq(into,S(string))) # make a LISP string
      { value1 = asciz_to_string((uintB*)address); }
    elif (stringp(into)) # copy memory into a LISP string
      { var uintL length;
        var reg1 uintB* charptr = unpack_string(into,&length);
        dotimesL(length,length, { *charptr++ = *((uintB*)address)++; } );
        value1 = into;
      }
    elif (!bit_vector_p(into) # copy memory into a LISP unsigned-byte vector
          && ((typecode(into)&~imm_array_mask)==bvector_type))
      { var reg3 uintBWL size = TheArray(into)->flags & arrayflags_atype_mask;
        if (!((size==Atype_8Bit) || (size==Atype_16Bit) || (size==Atype_32Bit))) { goto fehler_type; }
       {var reg4 uintL length = vector_length(into);
        var uintL index = 0;
        var reg5 object dv = array1_displace_check(into,length,&index);
        bytecopy(&TheSbvector(TheArray(dv)->data)->data[index],(void*)address,length,bit(size));
        value1 = into;
      }}
    else
      { fehler_type:
        fehler_ffi_type(into);
      }
    mv_count=1;
  }


# (SYSTEM::MEM-WRITE address type value [offset]) writes to address[+offset].
LISPFUN(mem_write,3,1,norest,nokey,0,NIL)
  { var reg1 aint address = convert_address(STACK_3,STACK_0);
    var reg2 object wert = STACK_1;
    var reg3 object type = STACK_2; # Größe in Byte oder *
    skipSTACK(4);
    if (eq(type,S(mal))) # pointer dereference
      { if (integerp(wert))
          { *(aint*)address = I_to_UL(wert); }
        elif (fpointerp(wert))
          { *(aint*)address = (aint)TheFpointer(wert)->fp_pointer; }
        else goto bad_arg;
      }
    elif (!integerp(wert)) goto bad_arg;
    elif (posfixnump(type))
      { var reg2 ULONG value = I_to_UL(wert);
        switch (posfixnum_to_L(type))
          { case 1L: if (value & ~0xFF) goto bad_arg;
                     else *(UBYTE *)address = value; break;
            case 2L: if (value & ~0xFFFF) goto bad_arg;
                     else *(UWORD *)address = value; break;
            case 4L:      *(ULONG *)address = value; break;
            default: goto bad_type;
      }   }
    elif (fixnump(type))
      { var reg2 LONG value = I_to_L(wert);
        switch (negfixnum_to_L(type)) # TODO valid range checks
          { case -1L: *(BYTE *)address = value; break;
            case -2L: *(WORD *)address = value; break;
            case -4L: *(LONG *)address = value; break;
            default: goto bad_type;
      }   }
    else
      { bad_type:
        fehler_ffi_type(type);
        bad_arg:
        fehler_ffi_arg(wert);
      }
    value1 = NIL; mv_count=0;
  }

# (SYSTEM::MEM-WRITE-VECTOR address vector [offset]) writes string to address.
LISPFUN(mem_write_vector,2,1,norest,nokey,0,NIL)
  { var reg1 aint address = convert_address(STACK_2,STACK_0);
    var reg2 object from = STACK_1;
    skipSTACK(3);
    if (stringp(from)) # write a LISP string to memory
      { var uintL length;
        var reg1 uintB* charptr = unpack_string(from,&length);
        dotimesL(length,length, { *((uintB*)address)++ = *charptr++; } );
        *(uintB*)address = '\0'; # and zero-terminate memory!
      }
    elif (!bit_vector_p(from) # copy memory into a LISP unsigned-byte vector
          && ((typecode(from)&~imm_array_mask)==bvector_type))
      { var reg3 uintBWL size = TheArray(from)->flags & arrayflags_atype_mask;
        if (!((size==Atype_8Bit) || (size==Atype_16Bit) || (size==Atype_32Bit))) { goto fehler_type; }
       {var reg4 uintL length = vector_length(from);
        var uintL index = 0;
        var reg5 object dv = array1_displace_check(from,length,&index);
        bytecopy((void*)address,&TheSbvector(TheArray(dv)->data)->data[index],length,bit(size));
      }}
    else
      { fehler_type:
        fehler_ffi_type(from);
      }
    value1 = NIL; mv_count=0;
  }

# (SYSTEM::NZERO-POINTER-P pointer) returns NIL for either NIL, 0 or NULL fpointer
LISPFUN(affi_nonzerop,1,0,norest,nokey,0,NIL)
  { var reg1 object arg = popSTACK();
#if 0
    # TODO? error if other data type
    if (nullp(arg)
        || eq(arg,Fixnum_0)
        || (fpointerp(arg) && (TheFpointer(arg)->fp_pointer == (void*)0)))
      { value1 = NIL; }
    else
      { value1 = T; }
#else
    switch (typecode(arg))
      { case_posfixnum: case_posbignum:
          value1 = (eq(arg,Fixnum_0)) ? NIL : T;
          break;
        case_orecord:
          if (TheRecord(arg)->rectype == Rectype_Fpointer)
            { value1 = (TheFpointer(arg)->fp_pointer == (void*)0) ? NIL : T;
              break;
            }
          # fall through
        case_symbol:
          if (nullp(arg))
            { value1 = NIL;
              break;
            }
          # fall through
        default:
          fehler_ffi_arg(arg);
      }
#endif
    mv_count=1;
  }


# Moduldefinitionen

uintC module__affi__object_tab_size = 0;
object module__affi__object_tab[1];
object_initdata module__affi__object_tab_initdata[1];

#undef LISPFUN
#define LISPFUN LISPFUN_F
#undef LISPSYM
#define LISPSYM(name,printname,package)  { package, printname },
#define system  "SYSTEM"

#define subr_anz  5

uintC module__affi__subr_tab_size = subr_anz;

subr_ module__affi__subr_tab[subr_anz] = {
  LISPFUN(affi_libcall,2,0,rest,nokey,0,NIL)
  LISPFUN(mem_read,2,1,norest,nokey,0,NIL)
  LISPFUN(mem_write,3,1,norest,nokey,0,NIL)
  LISPFUN(mem_write_vector,2,1,norest,nokey,0,NIL)
  LISPFUN(affi_nonzerop,1,0,norest,nokey,0,NIL)
# LISPFUNN(string_to_asciz,1)
};

subr_initdata module__affi__subr_tab_initdata[subr_anz] = {
  LISPSYM(affi_libcall,"%LIBCALL",system)
  LISPSYM(mem_read,"MEM-READ",system)
  LISPSYM(mem_write,"MEM-WRITE",system)
  LISPSYM(mem_write_vector,"MEM-WRITE-VECTOR",system)
  LISPSYM(affi_nonzerop,"NZERO-POINTER-P",system)
# LISPSYM(string_to_asciz,"STRING-TO-ASCIZ",system)
};

# called once when module is initialized, not called if found in .mem file
void module__affi__init_function_1(module)
  var reg3 module_* module;
  { # evtl. keywords-Slot müssten wir initialisieren
  }

# called for every session
void module__affi__init_function_2(module)
  var reg3 module_* module;
  {
  }

# If we had a module exit function, we could close all libraries the programmer forgot.

#endif # HAVE_AFFI
