# Diverse Funktionen für CLISP
# Bruno Haible 24.5.1995

#include "lispbibl.c"

# Eigenwissen:

LISPFUNN(lisp_implementation_type,0)
# (LISP-IMPLEMENTATION-TYPE), CLTL S. 447
  { value1 = O(lisp_implementation_type_string); mv_count=1; }

LISPFUNN(lisp_implementation_version,0)
# (LISP-IMPLEMENTATION-VERSION), CLTL S. 447
  { value1 = Symbol_value(S(lisp_implementation_version_string)); mv_count=1; }

LISPFUN(version,0,1,norest,nokey,0,NIL)
# (SYSTEM::VERSION) liefert die Version des Runtime-Systems,
# (SYSTEM::VERSION version) überprüft (am Anfang eines FAS-Files),
# ob die Versionen des Runtime-Systems übereinstimmen.
  { var reg1 object arg = popSTACK();
    if (eq(arg,unbound))
      { value1 = O(version); mv_count=1; }
      else
      { if (equal(arg,O(version)))
          { value1 = NIL; mv_count=0; }
          else
          { 
            //: DEUTSCH "Dieses File stammt von einer anderen Lisp-Version, muß neu compiliert werden."
            //: ENGLISH "This file was produced by another lisp version, must be recompiled."
            //: FRANCAIS "Ce fichier provient d'une autre version de LISP et doit être recompilé."
            fehler(error, GETTEXT("This file was produced by another lisp version, must be recompiled."));
  }   }   }

#ifdef MACHINE_KNOWN

LISPFUNN(machinetype,0)
# (MACHINE-TYPE), CLTL S. 447
  { var reg1 object erg = O(machine_type_string);
    if (nullp(erg)) # noch unbekannt?
      { # ja -> holen
        #ifdef HAVE_SYS_UTSNAME_H
        var struct utsname utsname;
        begin_system_call();
        if ( uname(&utsname) <0) { OS_error(); }
        end_system_call();
        pushSTACK(asciz_to_string(&!utsname.machine));
        funcall(L(nstring_upcase),1); # in Großbuchstaben umwandeln
        erg = value1;
        #else
        # Betriebssystem-Kommando 'uname -m' bzw. 'arch' ausführen und
        # dessen Output in einen String umleiten:
        # (string-upcase
        #   (with-open-stream (stream (make-pipe-input-stream "/bin/arch"))
        #     (read-line stream nil nil)
        # ) )
        #if defined(UNIX_SUNOS4)
        pushSTACK(asciz_to_string("/bin/arch"));
        #elif defined(UNIX_NEXTSTEP)
        pushSTACK(asciz_to_string("/usr/bin/arch"));
        #else
        pushSTACK(asciz_to_string("uname -m"));
        #endif
        funcall(L(make_pipe_input_stream),1); # (MAKE-PIPE-INPUT-STREAM "/bin/arch")
        pushSTACK(value1); # Stream retten
        pushSTACK(value1); pushSTACK(NIL); pushSTACK(NIL);
        funcall(L(read_line),3); # (READ-LINE stream NIL NIL)
        pushSTACK(value1); # Ergebnis (kann auch NIL sein) retten
        stream_close(&STACK_1); # Stream schließen
        if (!nullp(STACK_0))
          { erg = string_upcase(STACK_0); } # in Großbuchstaben umwandeln
          else
          { erg = NIL; }
        skipSTACK(2);
        #endif
        # Das Ergebnis merken wir uns für's nächste Mal:
        O(machine_type_string) = erg;
      }
    value1 = erg; mv_count=1;
  }

LISPFUNN(machine_version,0)
# (MACHINE-VERSION), CLTL S. 447
  { var reg1 object erg = O(machine_version_string);
    if (nullp(erg)) # noch unbekannt?
      { # ja -> holen
        #ifdef HAVE_SYS_UTSNAME_H
        var struct utsname utsname;
        begin_system_call();
        if ( uname(&utsname) <0) { OS_error(); }
        end_system_call();
        pushSTACK(asciz_to_string(&!utsname.machine));
        funcall(L(nstring_upcase),1); # in Großbuchstaben umwandeln
        erg = value1;
        #else
        # Betriebssystem-Kommando 'uname -m' bzw. 'arch -k' ausführen und
        # dessen Output in einen String umleiten:
        # (string-upcase
        #   (with-open-stream (stream (make-pipe-input-stream "/bin/arch -k"))
        #     (read-line stream nil nil)
        # ) )
        #if defined(UNIX_SUNOS4)
        pushSTACK(asciz_to_string("/bin/arch -k"));
        #else
        pushSTACK(asciz_to_string("uname -m"));
        #endif
        funcall(L(make_pipe_input_stream),1); # (MAKE-PIPE-INPUT-STREAM "/bin/arch -k")
        pushSTACK(value1); # Stream retten
        pushSTACK(value1); pushSTACK(NIL); pushSTACK(NIL);
        funcall(L(read_line),3); # (READ-LINE stream NIL NIL)
        pushSTACK(value1); # Ergebnis (kann auch NIL sein) retten
        stream_close(&STACK_1); # Stream schließen
        funcall(L(string_upcase),1); skipSTACK(1); # in Großbuchstaben umwandeln
        #endif
        # Das Ergebnis merken wir uns für's nächste Mal:
        O(machine_version_string) = erg = value1;
      }
    value1 = erg; mv_count=1;
  }

LISPFUNN(machine_instance,0)
# (MACHINE-INSTANCE), CLTL S. 447
  { var reg1 object erg = O(machine_instance_string);
    if (nullp(erg)) # noch unbekannt?
      { # ja -> Hostname abfragen und dessen Internet-Adresse holen:
        # (let* ((hostname (unix:gethostname))
        #        (address (unix:gethostbyname hostname)))
        #   (if (or (null address) (zerop (length address)))
        #     hostname
        #     (apply #'string-concat hostname " ["
        #       (let ((l nil))
        #         (dotimes (i (length address))
        #           (push (sys::decimal-string (aref address i)) l)
        #           (push "." l)
        #         )
        #         (setf (car l) "]") ; statt (pop l) (push "]" l)
        #         (nreverse l)
        # ) ) ) )
        #if defined(HAVE_GETHOSTNAME)
        var char hostname[MAXHOSTNAMELEN+1];
        # Hostname holen:
        begin_system_call();
        if ( gethostname(&!hostname,MAXHOSTNAMELEN) <0) { OS_error(); }
        end_system_call();
        hostname[MAXHOSTNAMELEN] = '\0'; # und durch ein Nullbyte abschließen
        #elif defined(HAVE_SYS_UTSNAME_H)
        # Hostname u.a. holen:
        var struct utsname utsname;
        begin_system_call();
        if ( uname(&utsname) <0) { OS_error(); }
        end_system_call();
        #define hostname utsname.nodename
        #else
        ??
        #endif
        erg = asciz_to_string(&!hostname); # Hostname als Ergebnis
        #ifdef HAVE_GETHOSTBYNAME
        pushSTACK(erg); # Hostname als 1. String
        { var reg5 uintC stringcount = 1;
          # Internet-Information holen:
          var reg4 struct hostent * h = gethostbyname(&!hostname);
          if ((!(h == (struct hostent *)NULL)) && (!(h->h_addr == (char*)NULL))
              && (h->h_length > 0)
             )
            { pushSTACK(asciz_to_string(" ["));
             {var reg2 uintB* ptr = (uintB*)h->h_addr;
              var reg3 uintC count;
              dotimesC(count,h->h_length,
                pushSTACK(fixnum(*ptr++));
                funcall(L(decimal_string),1); # nächstes Byte in dezimal
                pushSTACK(value1);
                pushSTACK(asciz_to_string(".")); # und ein Punkt als Trennung
                );
              STACK_0 = asciz_to_string("]"); # kein Punkt am Schluß
              stringcount += (2*h->h_length + 1);
            }}
          # Strings zusammenhängen:
          erg = string_concat(stringcount);
        }
        #endif
        #undef hostname
        # Das Ergebnis merken wir uns für's nächste Mal:
        O(machine_instance_string) = erg;
      }
    value1 = erg; mv_count=1;
  }

#endif # MACHINE_KNOWN

#ifdef HAVE_ENVIRONMENT

LISPFUNN(get_env,1)
# (SYSTEM::GETENV string) liefert den zu string im Betriebssystem-Environment
# assoziierten String oder NIL.
  { var reg2 object arg = popSTACK();
    if (stringp(arg))
      { var reg1 const char* found;
        with_string_0(arg,envvar,
          { begin_system_call();
            found = getenv(envvar);
            end_system_call();
          });
        if (!(found==NULL))
          { value1 = asciz_to_string(found); } # gefunden -> String als Wert
          else
          { value1 = NIL; } # nicht gefunden -> Wert NIL
      }
      else
      { value1 = NIL; } # Kein String -> Wert NIL
    mv_count=1;
  }

#endif

LISPFUNN(software_type,0)
# (SOFTWARE-TYPE), CLTL S. 448
  { value1 = OL(software_type_string); mv_count=1; }

LISPFUNN(software_version,0)
# (SOFTWARE-VERSION), CLTL S. 448
  { value1 = Symbol_value(S(software_version_string)); mv_count=1; }

#ifdef ENABLE_NLS

  global const char *__GETTEXT (const char *msg);
  global const char *__GETTEXT(msg)
    var const char *msg;
    {
      const char *translated_msg;

      begin_system_call();
      translated_msg = gettext(msg);
      end_system_call();  
      #if 0
        # empty strings are treated like NULLs by gettext -- a workaround
        return (msg == translated_msg) ? "" : translated_msg;
      #else
        return translated_msg;
      #endif
    }


LISPFUNN(gettext,1)
# (SYS::GETTEXT object)
  {
    if (mstringp(STACK_0))
      { 
#if 1
        with_string_0(STACK_0,asciz,
          { value1 = asciz_to_string(__GETTEXT(asciz)); });
#else
        value1 = asciz_to_string(__GETTEXT(TheAsciz(string_to_asciz(STACK_0))));
#endif
        skipSTACK(1);
      }
    elif (mconsp(STACK_0))
      {
        pushSTACK(L(gettext));
        pushSTACK(STACK_(0+1));
        funcall(L(mapcar),2);
        skipSTACK(1);
      }
    else value1 = popSTACK();
    mv_count = 1;
  }
#endif

LISPFUNN(language,3)
# (SYS::LANGUAGE english deutsch francais) liefert je nach der aktuellen
# Sprache das entsprechende Argument.
  { 
    #ifdef ENABLE_NLS
    pushSTACK(STACK_2);
    funcall(S(gettext),1);  # S() for debugging
    #else
    value1 = (ENGLISH ? STACK_2 :
              DEUTSCH ? STACK_1 :
              FRANCAIS ? STACK_0 :
              NIL
              );
    #endif
    mv_count=1;
    skipSTACK(3);
  }

LISPFUNN(identity,1)
# (IDENTITY object), CLTL S. 448
  { value1 = popSTACK(); mv_count=1; }

LISPFUNN(address_of,1)
# (SYS::ADDRESS-OF object) liefert die Adresse von object
  { var reg1 object arg = popSTACK();
    #if defined(WIDE_HARD)
      value1 = UQ_to_I(untype(arg));
    #elif defined(WIDE_SOFT)
      value1 = UL_to_I(untype(arg));
    #else
      value1 = UL_to_I(as_oint(arg));
    #endif
    mv_count=1;
  }

#ifdef HAVE_DISASSEMBLER

LISPFUNN(code_address_of,1)
# (SYS::CODE-ADDRESS-OF object) liefert die Adresse des Maschinencodes von object
  { var reg1 object obj = popSTACK();
    if (ulong_p(obj)) # Zahl im Bereich eines aint == ulong -> Zahl selbst
      { value1 = obj; }
    elif (subrp(obj)) # SUBR -> seine Adresse
      { value1 = ulong_to_I((aint)(TheSubr(obj)->function)); }
    elif (fsubrp(obj)) # FSUBR -> seine Adresse
      { value1 = ulong_to_I((aint)TheMachine(TheFsubr(obj)->function)); }
    #ifdef DYNAMIC_FFI
    elif (ffunctionp(obj))
      { value1 = ulong_to_I((uintP)Faddress_value(TheFfunction(obj)->ff_address)); }
    #endif
    else
      { value1 = NIL; }
    mv_count=1;
  }

LISPFUNN(program_id,0)
# (SYS::PROGRAM-ID) returns the pid
  { begin_system_call();
   {var reg1 int pid = getpid();
    end_system_call();
    value1 = L_to_I((sint32)pid);
    mv_count=1;
  }}

#endif

