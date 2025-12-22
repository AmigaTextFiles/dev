# Error-Handling für CLISP
# Bruno Haible 23.4.1995
# Marcus Daniels 8.4.1994

#include "lispbibl.c"


# SYS::*RECURSIVE-ERROR-COUNT* = Rekursionstiefe der Ausgabe von Errormeldungen

# UP: Beginnt die Ausgabe einer Errormeldung.
# begin_error()
# < STACK_0: Stream (i.a. *ERROR-OUTPUT*)
# < STACK_1: Wert von *error-handler*
# < STACK_2: Argumentliste für *error-handler*
# < STACK_3: Condition-Typ (i.a. SIMPLE-ERROR) oder NIL
# erniedrigt STACK um 7
  local void begin_error (void);
  local void begin_error()
    { end_system_call(); # keine Betriebssystem-Operation läuft mehr
      #ifdef PENDING_INTERRUPTS
      interrupt_pending = FALSE; # Ctrl-C-Wartezeit ist gleich beendet
      begin_system_call();
      #ifdef HAVE_UALARM
      ualarm(0,0); # SIGALRM-Timer abbrechen
      #else
      #ifdef EMUNIX_OLD_8h # EMX-Bug umgehen
      alarm(1000);
      #endif
      alarm(0); # SIGALRM-Timer abbrechen
      #endif
      end_system_call();
      #endif
      # Error-Count erhöhen, bei >3 Ausgabe-Abbruch:
      dynamic_bind(S(recursive_error_count),fixnum_inc(Symbol_value(S(recursive_error_count)),1));
      if (!sym_posfixnump(S(recursive_error_count))) # sollte ein Fixnum >=0 sein
        { set_Symbol_value(S(recursive_error_count),Fixnum_0); } # sonst Notkorrektur
      if (posfixnum_to_L(Symbol_value(S(recursive_error_count))) > 3)
        { # Mehrfach verschachtelte Fehlermeldung.
          set_Symbol_value(S(recursive_error_count),Fixnum_0); # Error-Count löschen
          # *PRINT-PRETTY* an NIL binden (um Speicher zu sparen):
          dynamic_bind(S(print_pretty),NIL);
          //: DEUTSCH "Unausgebbare Fehlermeldung"
          //: ENGLISH "Unprintable error message"
          //: FRANCAIS "Message inimprimable"
          fehler(serious_condition,GETTEXT("Unprintable error message"));
        }
     {var reg1 object error_handler = Symbol_value(S(error_handler)); # *ERROR-HANDLER*
      if (!nullp(error_handler))
        # *ERROR-HANDER* /= NIL
        { pushSTACK(NIL); pushSTACK(NIL); pushSTACK(error_handler);
          pushSTACK(make_string_output_stream()); # String-Output-Stream
        }
        else
        if (sym_nullp(S(use_clcs))) # SYS::*USE-CLCS*
          # *ERROR-HANDER* = NIL, SYS::*USE-CLCS* = NIL
          { pushSTACK(NIL); pushSTACK(NIL); pushSTACK(NIL);
            pushSTACK(var_stream(S(error_output),strmflags_wr_ch_B)); # Stream *ERROR-OUTPUT*
            terpri(&STACK_0); # neue Zeile
            write_sstring(&STACK_0,O(error_string1)); # "*** - " ausgeben
          }
          else
          # *ERROR-HANDER* = NIL, SYS::*USE-CLCS* /= NIL
          { pushSTACK(S(simple_error)); pushSTACK(NIL); pushSTACK(unbound);
            pushSTACK(make_string_output_stream()); # String-Output-Stream
          }
    }}

# UP: Gibt ein Error-Objekt aus.
  local void write_errorobject (object obj);
  local void write_errorobject(obj)
    var reg1 object obj;
    { if (nullp(STACK_1))
        { dynamic_bind(S(prin_stream),unbound); # SYS::*PRIN-STREAM* an #<UNBOUND> binden
          dynamic_bind(S(print_escape),T); # *PRINT-ESCAPE* an T binden
          prin1(&STACK_(0+DYNBIND_SIZE+DYNBIND_SIZE),obj); # direkt ausgeben
          dynamic_unbind();
          dynamic_unbind();
        }
        else
        { # obj auf die Argumentliste schieben:
          pushSTACK(obj);
          obj = allocate_cons();
          Car(obj) = popSTACK();
          Cdr(obj) = STACK_2; STACK_2 = obj;
          # und "~S" in den Format-String schreiben:
          write_schar(&STACK_0,'~'); write_schar(&STACK_0,'S');
    }   }

# UP: Gibt ein Error-Character aus.
  local void write_errorchar (object obj);
  local void write_errorchar(obj)
    var reg1 object obj;
    { if (nullp(STACK_1))
        { write_char(&STACK_0,obj); } # direkt ausgeben
        else
        { # obj auf die Argumentliste schieben:
          pushSTACK(obj);
          obj = allocate_cons();
          Car(obj) = popSTACK();
          Cdr(obj) = STACK_2; STACK_2 = obj;
          # und "~A" in den Format-String schreiben:
          write_schar(&STACK_0,'~'); write_schar(&STACK_0,'A');
    }   }

# UP: Gibt einen Errorstring aus. Bei jeder Tilde '~' wird ein Objekt aus dem
# Stack ausgegeben, bei jedem '$' wird ein Character aus dem Stack ausgegeben.
# write_errorstring(errorstring)
# > STACK_0: Stream usw.
# > errorstring: Errorstring (ein unverschieblicher ASCIZ-String)
# > STACK_7, STACK_8, ...: Argumente (für jedes '~' bzw. '$' eines),
#   in umgekehrter Reihenfolge wie bei FUNCALL !
# < ergebnis: STACK-Wert oberhalb des Stream und der Argumente
  local object* write_errorstring (const char* errorstring);
  local object* write_errorstring(errorstring)
    var reg1 const char* errorstring;
    { var reg2 object* argptr = args_end_pointer STACKop (4+DYNBIND_SIZE); # Pointer übern Stream und Frame
      loop
        { var reg3 uintB ch = *errorstring++; # nächstes Zeichen
          if (ch==0) break; # String zu Ende?
          if (ch=='~') # Tilde?
            # ja -> ein Objekt vom Stack ausgeben:
            { write_errorobject(BEFORE(argptr)); }
          elif (ch=='$') # '$' ?
            # ja -> ein Character vom Stack ausgeben:
            { write_errorchar(BEFORE(argptr)); }
          else
            # nein -> Zeichen normal ausgeben:
            { write_char(&STACK_0,code_char(ch)); }
        }
      return argptr;
    }

# Beendet die Ausgabe einer Fehlermeldung und startet neuen Driver.
# end_error();
  nonreturning_function(local, end_error, (object* stackptr));
  local void end_error(stackptr)
    var reg2 object* stackptr;
    { if (nullp(STACK_1))
        # *ERROR-HANDER* = NIL, SYS::*USE-CLCS* = NIL
        { skipSTACK(4); # Fehlermeldung wurde schon ausgegeben
          dynamic_unbind(); # Bindungsframe für sys::*recursive-error-count* auflösen,
                            # da keine Fehlermeldungs-Ausgabe mehr aktiv
          set_args_end_pointer(stackptr);
          break_driver(NIL); # Break-Driver aufrufen (kehrt nicht zurück)
        }
        else
        { STACK_0 = get_output_stream_string(&STACK_0);
         {var reg4 object arguments = nreverse(STACK_2);
          # Stackaufbau: type, args, handler, errorstring.
          if (!eq(STACK_1,unbound))
            # *ERROR-HANDER* /= NIL
            { # Stackaufbau: nil, args, handler, errorstring.
              # (apply *error-handler* nil errorstring args) ausführen:
              check_SP(); check_STACK();
              {var reg1 object error_handler = STACK_1; STACK_1 = NIL;
               apply(error_handler,2,arguments);
               skipSTACK(2);
              }
              dynamic_unbind(); # Bindungsframe für sys::*recursive-error-count* auflösen,
                                # da keine Fehlermeldungs-Ausgabe mehr aktiv
              set_args_end_pointer(stackptr);
              break_driver(NIL); # Break-Driver aufrufen (kehrt nicht zurück)
            }
            else
            # *ERROR-HANDER* = NIL, SYS::*USE-CLCS* /= NIL
            { # Stackaufbau: type, args, --, errorstring.
              var reg1 object type = STACK_3;
              var reg5 object errorstring = STACK_0;
              skipSTACK(4);
              dynamic_unbind(); # Bindungsframe für sys::*recursive-error-count* auflösen
              # (APPLY #'coerce-to-condition errorstring args 'error type keyword-arguments)
              # ausführen:
              pushSTACK(errorstring); pushSTACK(arguments); pushSTACK(S(error)); pushSTACK(type);
             {var reg3 uintC argcount = 4;
              # arithmetic-error, division-by-zero, floating-point-overflow, floating-point-underflow
              #   --> ergänze :operation :operands ??
              # cell-error, uncound-variable, undefined-function
              #   --> ergänze :name
              if (eq(type,S(simple_cell_error))
                  || eq(type,S(simple_unbound_variable))
                  || eq(type,S(simple_undefined_function))
                 )
                { pushSTACK(S(Kname)); pushSTACK(BEFORE(stackptr)); # :name ...
                  argcount += 2;
                }
              # type-error --> ergänze :datum, :expected-type
              if (eq(type,S(simple_type_error)))
                { pushSTACK(S(Kexpected_type)); pushSTACK(BEFORE(stackptr)); # :expected-type ...
                  pushSTACK(S(Kdatum)); pushSTACK(BEFORE(stackptr)); # :datum ...
                  argcount += 4;
                }
              # package-error --> ergänze :package
              if (eq(type,S(simple_package_error)))
                { pushSTACK(S(Kpackage)); pushSTACK(BEFORE(stackptr)); # :package ...
                  argcount += 2;
                }
              # print-not-readable --> ergänze :object
              if (eq(type,S(simple_print_not_readable)))
                { pushSTACK(S(Kobject)); pushSTACK(BEFORE(stackptr)); # :object
                  argcount += 2;
                }
              # stream-error, end-of-file --> ergänze :stream
              if (eq(type,S(simple_stream_error))
                  || eq(type,S(simple_end_of_file))
                 )
                { pushSTACK(S(Kstream)); pushSTACK(BEFORE(stackptr)); # :stream ...
                  argcount += 2;
                }
              # file-error --> ergänze :pathname
              if (eq(type,S(simple_file_error)))
                { pushSTACK(S(Kpathname)); pushSTACK(BEFORE(stackptr)); # :pathname ...
                  argcount += 2;
                }
              funcall(S(coerce_to_condition),argcount); # (SYS::COERCE-TO-CONDITION ...)
              # set_args_end_pointer(stackptr); # wozu? macht das Debuggen nur schwieriger!
              pushSTACK(value1); # condition retten
              pushSTACK(value1); funcall(L(clcs_signal),1); # (SIGNAL condition)
              dynamic_bind(S(prin_stream),unbound); # SYS::*PRIN-STREAM* an #<UNBOUND> binden
              pushSTACK(STACK_(0+DYNBIND_SIZE)); # condition
              funcall(L(invoke_debugger),1); # (INVOKE-DEBUGGER condition)
            }}
        }}
      NOTREACHED
    }

# Fehlermeldung mit Errorstring. Kehrt nicht zurück.
# fehler(errortype,errorstring);
# > errortype: Condition-Typ
# > errorstring: Konstanter ASCIZ-String.
#   Bei jeder Tilde wird ein LISP-Objekt vom STACK genommen und statt der
#   Tilde ausgegeben.
# > auf dem STACK: Initialisierungswerte für die Condition, je nach errortype
  nonreturning_function(global, fehler, (conditiontype errortype, const char * errorstring));
  global void fehler(errortype,errorstring)
    var reg2 conditiontype errortype;
    var reg1 const char * errorstring;
    { begin_error(); # Fehlermeldung anfangen
      if (!nullp(STACK_3)) # *ERROR-HANDLER* = NIL, SYS::*USE-CLCS* /= NIL ?
        { # Error-Typ-Symbol zu errortype auswählen:
          var reg3 object sym = S(simple_condition); # erster Error-Typ
          sym = objectplus(sym,
                           (soint)(sizeof(*TheSymbol(sym))<<(oint_addr_shift-addr_shift))
                           * (uintL)errortype
                          );
          STACK_3 = sym;
        }
      end_error(write_errorstring(errorstring)); # Fehlermeldung ausgeben, beenden
    }

  nonreturning_function(global, fehler3, (conditiontype errortype, const char *arg1,const char *arg2,const char *arg3));
  global void fehler3 (errortype, arg1,arg2,arg3)
    var conditiontype errortype;
    var reg7 const char *arg1;
    var reg6 const char *arg2;
    var reg5 const char *arg3;
    {
      var reg4 uintL count1 = asciz_length(arg1);
      var reg3 uintL count2 = asciz_length(arg2);
      var reg2 uintL count3 = asciz_length(arg3);
      var DYNAMIC_ARRAY(auto,cbuf,char,count1+count2+count3+1); 
      var reg1 char *buf;
      buf = cbuf;
      dotimesL(count1,count1, { *buf++ = *arg1++; });
      dotimesL(count2,count2, { *buf++ = *arg2++; });
      dotimesL(count3,count3, { *buf++ = *arg3++; });
      *buf = '\0';
      fehler(errortype,cbuf);
    }

  nonreturning_function(global, fehler4, (conditiontype errortype, const char *arg1,const char *arg2,const char *arg3, const char *arg4));
  global void fehler4 (errortype, arg1,arg2,arg3,arg4)
    var conditiontype errortype;
    var reg9 const char *arg1;
    var reg8 const char *arg2;
    var reg7 const char *arg3;
    var reg6 const char *arg4;
    {
      var reg5 uintL count1 = asciz_length(arg1);
      var reg4 uintL count2 = asciz_length(arg2);
      var reg3 uintL count3 = asciz_length(arg3);
      var reg2 uintL count4 = asciz_length(arg4);
      var DYNAMIC_ARRAY(auto,cbuf,char,count1+count2+count3+count4+1); 
      var reg1 char *buf;
      buf = cbuf;
      dotimesL(count1,count1, { *buf++ = *arg1++;});
      dotimesL(count2,count2, { *buf++ = *arg2++; });
      dotimesL(count3,count3, { *buf++ = *arg3++; });
      dotimesL(count4,count4, { *buf++ = *arg4++; });
      *buf = '\0';
      fehler(errortype,cbuf);
    }

  nonreturning_function(global, fehler5, (conditiontype errortype, const char *arg1,const char *arg2,const char *arg3, const char *arg4, const char *arg5));
  global void fehler5 (errortype, arg1,arg2,arg3,arg4, arg5)
    var conditiontype errortype;
    var reg10 const char *arg1;
    var reg9 const char *arg2;
    var reg8 const char *arg3;
    var reg7 const char *arg4;
    var const char *arg5;
    {
      var reg6 uintL count1 = asciz_length(arg1);
      var reg5 uintL count2 = asciz_length(arg2);
      var reg4 uintL count3 = asciz_length(arg3);
      var reg3 uintL count4 = asciz_length(arg4);
      var reg2 uintL count5 = asciz_length(arg5);
      var DYNAMIC_ARRAY(auto,cbuf,char,count1+count2+count3+count4+count5+1); 
      var reg1 char *buf;
      buf = cbuf;
      dotimesL(count1,count1, { *buf++ = *arg1++;});
      dotimesL(count2,count2, { *buf++ = *arg2++; });
      dotimesL(count3,count3, { *buf++ = *arg3++; });
      dotimesL(count4,count4, { *buf++ = *arg4++; });
      dotimesL(count5,count5, { *buf++ = *arg5++; });
      *buf = '\0';
      fehler(errortype,cbuf);
    }

#ifdef AMIGAOS
  # Behandlung von AMIGAOS-Fehlern
  # OS_error_();
  # > IoErr(): Fehlercode
    nonreturning_function(global, OS_error_, (void));

  # Tabelle der Fehlermeldungen und ihrer Namen:
    local const char* error100_msg_table[23][2];
    local const char* error200_msg_table[44][2];
    local const char* error300_msg_table[6][2];

  # Initialisierung der Tabelle:
    global int init_errormsg_table (void);
    global int init_errormsg_table()
      {
        # A remanescence of pre-gettext times
        #ifdef LANGUAGE_STATIC
          #define lang3(english,deutsch,francais)  ENGLISH ? english : DEUTSCH ? deutsch : FRANCAIS ? francais : ""
          #define lang1(string)  string
          #define langcount  1
          #define language  0
        #else
          #define lang3(english,deutsch,francais)  english, deutsch, francais
          #define lang1(string)  string, string, string
          #define langcount  3
        #endif
        error100_msg_table[0][0]=""; error100_msg_table[0][1]="";
        error100_msg_table[1][0]=""; error100_msg_table[1][1]="";
        error100_msg_table[2][0]=""; error100_msg_table[2][1]="";

        error100_msg_table[3][0]="ERROR_NO_FREE_STORE";
        //: DEUTSCH "nicht genügend Speicher vorhanden"
        //: ENGLISH "not enough memory available"
        //: FRANCAIS "Pas assez de mémoire"
        error100_msg_table[3][1]=GETTEXT("not enough memory available");

        error100_msg_table[4][0]=""; error100_msg_table[4][1]="";

        error100_msg_table[5][0]="ERROR_TASK_TABLE_FULL";
        //: DEUTSCH "keine weiteren CLI Prozesse mehr"
        //: ENGLISH "process table full"
        //: FRANCAIS "La table des processus est pleine"
        error100_msg_table[5][1]=GETTEXT("process table full");

        error100_msg_table[6][0]=""; error100_msg_table[6][1]="";
        error100_msg_table[7][0]=""; error100_msg_table[7][1]="";
        error100_msg_table[8][0]=""; error100_msg_table[8][1]="";
        error100_msg_table[9][0]=""; error100_msg_table[9][1]="";
        error100_msg_table[10][0]=""; error100_msg_table[10][1]="";
        error100_msg_table[11][0]=""; error100_msg_table[11][1]="";
        error100_msg_table[12][0]=""; error100_msg_table[12][1]="";
        error100_msg_table[13][0]=""; error100_msg_table[13][1]="";

        error100_msg_table[14][0]="ERROR_BAD_TEMPLATE";
        //: DEUTSCH "ungültiges Muster"
        //: ENGLISH "bad template"
        //: FRANCAIS "mauvais schéma"
        error100_msg_table[14][1]=GETTEXT("bad template");

        error100_msg_table[15][0]="ERROR_BAD_NUMBER";
        //: DEUTSCH "ungültige Zahl"
        //: ENGLISH "bad number"
        //: FRANCAIS "mauvais nombre"
        error100_msg_table[15][1]=GETTEXT("bad number");

        error100_msg_table[16][0]="ERROR_REQUIRED_ARG_MISSING";
        //: DEUTSCH "benötigtes Schlüsselwort nicht vorhanden"
        //: ENGLISH "required argument missing"
        //: FRANCAIS "mot clé manque"
        error100_msg_table[16][1]=GETTEXT("required argument missing");

        error100_msg_table[17][0]="ERROR_KEY_NEEDS_ARG";
        //: DEUTSCH "kein Wert nach Schlüsselwort vorhanden"
        //: ENGLISH "value after keyword missing"
        //: FRANCAIS "mot clé sans valeur"
        error100_msg_table[17][1]=GETTEXT("value after keyword missing");

        error100_msg_table[18][0]="ERROR_TOO_MANY_ARGS";
        //: DEUTSCH "falsche Anzahl Argumente"
        //: ENGLISH "wrong number of arguments"
        //: FRANCAIS "mauvais nombre d'arguments"
        error100_msg_table[18][1]=GETTEXT("wrong number of arguments");
 
        error100_msg_table[19][0]="ERROR_UNMATCHED_QUOTES";
        //: DEUTSCH "ausstehende Anführungszeichen"
        //: ENGLISH "unmatched quotes"
        //: FRANCAIS "guillemets non terminés"
        error100_msg_table[19][1]=GETTEXT("unmatched quotes");

        error100_msg_table[20][0]="ERROR_LINE_TOO_LONG";
        //: DEUTSCH "ungültige Zeile oder Zeile zu lang"
        //: ENGLISH "argument line invalid or too long"
        //: FRANCAIS "ligne est mauvaise ou trop longue"
        error100_msg_table[20][1]="argument line invalid or too long";

        error100_msg_table[21][0]="ERROR_FILE_NOT_OBJECT";
        //: DEUTSCH "Datei ist nicht ausführbar"
        //: ENGLISH "file is not executable"
        //: FRANCAIS "fichier non exécutable"
        error100_msg_table[21][1]=GETTEXT("file is not executable");

        error100_msg_table[22][0]="ERROR_INVALID_RESIDENT_LIBRARY";
        //: DEUTSCH "ungültige residente Library"
        //: ENGLISH "invalid resident library"
        //: FRANCAIS "Librarie résidente non valide"
        error100_msg_table[22][1]=GETTEXT("invalid resident library");
 
        error200_msg_table[0][0]=""; error200_msg_table[0][1]="";
        
        error200_msg_table[1][0]="ERROR_NO_DEFAULT_DIR";
        error200_msg_table[1][1]="";

        error200_msg_table[2][0]="ERROR_OBJECT_IN_USE";
        //: DEUTSCH "Objekt wird schon benutzt"
        //: ENGLISH "object is in use"
        //: FRANCAIS "l'objet est utilisé"
        error200_msg_table[2][1]=GETTEXT("object is in use");
        
        error200_msg_table[3][0]="ERROR_OBJECT_EXISTS";
        //: DEUTSCH "Objekt existiert bereits"
        //: ENGLISH "object already exists"
        //: FRANCAIS "l'objet existe déjà"
        error200_msg_table[3][1]=GETTEXT("object already exists");

        error200_msg_table[4][0]="ERROR_DIR_NOT_FOUND";
        //: DEUTSCH "Verzeichnis nicht gefunden"
        //: ENGLISH "directory not found"
        //: FRANCAIS "répertoire non trouvé"
        error200_msg_table[4][1]=GETTEXT("directory not found");

        error200_msg_table[5][0]="ERROR_OBJECT_NOT_FOUND";
        //: DEUTSCH "Objekt nicht gefunden"
        //: ENGLISH "object not found"
        //: FRANCAIS "objet non trouvé"
        error200_msg_table[5][1]=GETTEXT("object not found");

        error200_msg_table[6][0]="ERROR_BAD_STREAM_NAME";
        //: DEUTSCH "ungültige Fensterbeschreibung"
        //: ENGLISH "invalid window description"
        //: FRANCAIS "mauvais descripteur de fenêtre"
        error200_msg_table[6][1]=GETTEXT("invalid window description");

        error200_msg_table[7][0]="ERROR_OBJECT_TOO_LARGE";
        //: DEUTSCH "Objekt zu groß"
        //: ENGLISH "object too large"
        //: FRANCAIS "objet trop grand"
        error200_msg_table[7][1]=GETTEXT("object too large");

        error200_msg_table[8][0]=""; error200_msg_table[8][1]="";

        error200_msg_table[9][0]="ERROR_ACTION_NOT_KNOWN";
        //: DEUTSCH "unbekannter Pakettyp" # ??
        //: ENGLISH "packet request type unknown"
        //: FRANCAIS "Type de paquet inconnu"
        error200_msg_table[9][1]=GETTEXT("packet request type unknown");

        error200_msg_table[10][0]="ERROR_INVALID_COMPONENT_NAME";
        //: DEUTSCH "ungültiger Objektname"
        //: ENGLISH "object name invalid"
        //: FRANCAIS "nom d'objet incorrect"
        error200_msg_table[10][1]=GETTEXT("object name invalid");
        
        error200_msg_table[11][0]="ERROR_INVALID_LOCK";
        //: DEUTSCH "ungültiger Objektlock"
        //: ENGLISH "invalid object lock"
        //: FRANCAIS "«lock» invalide d'un objet"
        error200_msg_table[11][1]=GETTEXT("invalid object lock");

        error200_msg_table[12][0]="ERROR_OBJECT_WRONG_TYPE";
        //: DEUTSCH "Objekt ist nicht von benötigten Typ"
        //: ENGLISH "object is not of required type"
        //: FRANCAIS "objet de mauvais type"
        error200_msg_table[12][1]=GETTEXT("object is not of required type");

        error200_msg_table[13][0]="ERROR_DISK_NOT_VALIDATED";
        //: DEUTSCH "Datenträger ist nicht validiert"
        //: ENGLISH "disk not validated"
        //: FRANCAIS "volume non validé"
        error200_msg_table[13][1]=GETTEXT("disk not validated");

        error200_msg_table[14][0]="ERROR_DISK_WRITE_PROTECTED";
        //: DEUTSCH "Datenträger ist schreibgeschützt"
        //: ENGLISH "disk is write-protected"
        //: FRANCAIS "disquette protégée contre l'écriture"
        error200_msg_table[14][1]=GETTEXT("disk is write-protected");

        error200_msg_table[15][0]="ERROR_RENAME_ACROSS_DEVICES";
        //: DEUTSCH "rename über Laufwerke versucht"
        //: ENGLISH "rename across devices attempted"
        //: FRANCAIS "«rename» à travers des unités distinctes"
        error200_msg_table[15][1]=GETTEXT("rename across devices attempted");

        error200_msg_table[16][0]="ERROR_DIRECTORY_NOT_EMPTY";
        //: DEUTSCH "Verzeichnis ist nicht leer"
        //: ENGLISH "directory not empty"
        //: FRANCAIS "répertoire non vide"
        error200_msg_table[16][1]=GETTEXT("directory not empty");

        error200_msg_table[17][0]="ERROR_TOO_MANY_LEVELS";
        //: DEUTSCH "zu viele Verweise"
        //: ENGLISH "too many levels"
        //: FRANCAIS "trop de niveaux"
        error200_msg_table[17][1]=GETTEXT("too many levels");

        error200_msg_table[18][0]="ERROR_DEVICE_NOT_MOUNTED";
        //: DEUTSCH "Datenträger ist in keinem Laufwerk"
        //: ENGLISH "device (or volume) is not mounted"
        //: FRANCAIS "l'unité n'est dans aucun lecteur"
        error200_msg_table[18][1]=GETTEXT("device (or volume) is not mounted");

        error200_msg_table[19][0]="ERROR_SEEK_ERROR";
        //: DEUTSCH "seek schlug fehl"
        //: ENGLISH "seek failure"
        //: FRANCAIS "erreur pendant un déplacement (seek)"
        error200_msg_table[19][1]=GETTEXT("seek failure");

        error200_msg_table[20][0]="ERROR_COMMENT_TOO_BIG";
        //: DEUTSCH "Kommentar ist zu lang"
        //: ENGLISH "comment is too long"
        //: FRANCAIS "Commentaire trop long"
        error200_msg_table[20][1]=GETTEXT("comment is too long");

        error200_msg_table[21][0]="ERROR_DISK_FULL";
        //: DEUTSCH "Datenträger ist voll"
        //: ENGLISH "disk is full"
        //: FRANCAIS "support plein"
        error200_msg_table[21][1]=GETTEXT("disk is full");

        error200_msg_table[22][0]="ERROR_DELETE_PROTECTED";
        //: DEUTSCH "Datei ist gegen Löschen geschützt"
        //: ENGLISH "object is protected from deletion"
        //: FRANCAIS "objet est protégé contre l'effacement"
        error200_msg_table[22][1]=GETTEXT("object is protected from deletion");

        error200_msg_table[23][0]="ERROR_WRITE_PROTECTED";
        //: DEUTSCH "Datei ist schreibgeschützt"
        //: ENGLISH "file is write protected"
        //: FRANCAIS "fichier protégé contre l'écriture"
        error200_msg_table[23][1]=GETTEXT("file is write protected");

        error200_msg_table[24][0]="ERROR_READ_PROTECTED";
        //: DEUTSCH "Datei ist lesegeschützt"
        //: ENGLISH "file is read protected"
        //: FRANCAIS "fichier protégé contre la lecture"
        error200_msg_table[24][1]=GETTEXT("file is read protected");

        error200_msg_table[25][0]="ERROR_NOT_A_DOS_DISK";
        //: DEUTSCH "kein gültiger DOS-Datenträger"
        //: ENGLISH "not a valid DOS disk"
        //: FRANCAIS "disque non DOS"
        error200_msg_table[25][1]=GETTEXT("not a valid DOS disk");

        error200_msg_table[26][0]="ERROR_NO_DISK";
        //: DEUTSCH "kein Datenträger im Laufwerk"
        //: ENGLISH "no disk in drive"
        //: FRANCAIS "pas de disquette dans le lecteur"
        error200_msg_table[26][1]=GETTEXT("no disk in drive");

        error200_msg_table[27][0]=""; error200_msg_table[27][1]="";
        error200_msg_table[28][0]=""; error200_msg_table[28][1]="";
        error200_msg_table[29][0]=""; error200_msg_table[29][1]="";
        error200_msg_table[30][0]=""; error200_msg_table[30][1]="";
        error200_msg_table[31][0]=""; error200_msg_table[31][1]="";

        error200_msg_table[32][0]="ERROR_NO_MORE_ENTRIES";
        //: DEUTSCH "keine weiteren Verzeichniseinträge mehr"
        //: ENGLISH "no more entries in directory"
        //: FRANCAIS "pas plus d'entrées dans le répertoire"
        error200_msg_table[32][1]=GETTEXT("no more entries in directory");

        error200_msg_table[33][0]="ERROR_IS_SOFT_LINK";
        //: DEUTSCH "Objekt ist ein Softlink"
        //: ENGLISH "object is soft link"
        //: FRANCAIS "l'objet est un «soft link»"
        error200_msg_table[33][1]=GETTEXT("object is soft link");

        error200_msg_table[34][0]="ERROR_OBJECT_LINKED";
        //: DEUTSCH "Objekt ist gelinkt"
        //: ENGLISH "object is linked"
        //: FRANCAIS "l'objet est lié"
        error200_msg_table[34][1]=GETTEXT("object is linked");

        error200_msg_table[35][0]="ERROR_BAD_HUNK";
        //: DEUTSCH "Datei teilweise nicht ladbar"
        //: ENGLISH "bad loadfile hunk"
        //: FRANCAIS "fichier pas entièrement chargeable"
        error200_msg_table[35][1]=GETTEXT("bad loadfile hunk");

        error200_msg_table[36][0]="ERROR_NOT_IMPLEMENTED";
        //: DEUTSCH "unimplementierte Funktion"
        //: ENGLISH "function not implemented"
        //: FRANCAIS "fonction non implémentée"
        error200_msg_table[36][1]=GETTEXT("function not implemented");

        error200_msg_table[37][0]=""; error200_msg_table[37][1]="";
        error200_msg_table[38][0]=""; error200_msg_table[38][1]="";
        error200_msg_table[39][0]=""; error200_msg_table[39][1]="";

        error200_msg_table[40][0]="ERROR_RECORD_NOT_LOCKED";
        //: DEUTSCH ""
        //: ENGLISH "record not locked"
        //: FRANCAIS ""
        error200_msg_table[40][1]=GETTEXT("record not locked");

        error200_msg_table[41][0]="ERROR_LOCK_COLLISION";
        //: DEUTSCH ""
        //: ENGLISH "record lock collision"
        //: FRANCAIS ""
        error200_msg_table[41][1]=GETTEXT("record lock collision");

        error200_msg_table[42][0]="ERROR_LOCK_TIMEOUT";
        //: DEUTSCH ""
        //: ENGLISH "record lock timeout"
        //: FRANCAIS ""
        error200_msg_table[42][1]=GETTEXT("record lock timeout");

        error200_msg_table[43][0]="ERROR_UNLOCK_ERROR";
        //: DEUTSCH ""
        //: ENGLISH "record unlock error"
        //: FRANCAIS ""
        error200_msg_table[43][1]=GETTEXT("record unlock error");

        error300_msg_table[0][0]=""; error300_msg_table[0][1]="";
        error300_msg_table[1][0]=""; error300_msg_table[1][1]="";
        error300_msg_table[2][0]=""; error300_msg_table[2][1]="";

        error300_msg_table[3][0]="ERROR_BUFFER_OVERFLOW";
        //: DEUTSCH "Puffer-Überlauf"
        //: ENGLISH "buffer overflow"
        //: FRANCAIS "débordement de tampon"
        error300_msg_table[3][1]=GETTEXT("buffer overflow");

        error300_msg_table[4][0]="ERROR_BREAK";
        //: DEUTSCH "Unterbrechung"
        //: ENGLISH "break"
        //: FRANCAIS "interruption"
        error300_msg_table[4][1]=GETTEXT("break");

        error300_msg_table[5][0]="ERROR_NOT_EXECUTABLE";
        //: DEUTSCH "Datei ist nicht ausführbar"
        //: ENGLISH "file not executable"
        //: FRANCAIS "fichier non exécutable"
        error300_msg_table[5][1]=GETTEXT("file not executable");
        return 0;
      }

    global void OS_error_ ()
      { var reg1 sintW errcode = IoErr(); # Fehlernummer
        end_system_call();
        clr_break_sem_4(); # keine AMIGAOS-Operation mehr aktiv
        begin_error(); # Fehlermeldung anfangen
        # Meldungbeginn ausgeben:
        //: DEUTSCH "AmigaOS-Fehler "
        //: ENGLISH "Amiga OS error "
        //: FRANCAIS "Erreur S.E. Amiga "
        write_errorstring(GETTEXT("Amiga OS error "));
        # Fehlernummer ausgeben:
        write_errorobject(fixnum(errcode));
        {
          var reg3 const char* errorname = "";
          var reg3 const char* errormsg = "";
          var reg2 uintC index;

          if (errcode == 0)
            { errorname = "";
              //: DEUTSCH "OK, kein Fehler"
              //: ENGLISH "Ok, No error"
              //: FRANCAIS "Ok, pas d'erreur"
              errormsg =GETTEXT("Ok, No error");
            }
          elif ((index = errcode-100) < 23)
            { errorname = error100_msg_table[index][0];
              errormsg = error100_msg_table[index][1];
            }
          elif ((index = errcode-200) < 44)
            { errorname = error200_msg_table[index][0];
              errormsg = error200_msg_table[index][1];
            }
          elif ((index = errcode-300) < 6)
            { errorname = error300_msg_table[index][0];
              errormsg = error300_msg_table[index][1];
            }
          if (!(errorname[0] == 0)) # bekannter Name?
            { write_errorstring(" (");
              write_errorstring(errorname);
              write_errorstring(")");
            }
          if (!(errormsg[0] == 0)) # nichtleere Meldung?
            { write_errorstring(": ");
              write_errorstring(errormsg);
            }
        }
        SetIoErr(0L); # Fehlercode löschen (fürs nächste Mal):
        end_error(args_end_pointer STACKop (4+DYNBIND_SIZE)); # Fehlermeldung beenden
      }
#endif

#ifdef DJUNIX
  # Behandlung von DJUNIX-(DOS-)Fehlern
  # OS_error_();
  # > int errno: Fehlercode
    nonreturning_function(global, OS_error_, (void));
    global void OS_error_ ()
      { var reg1 uintC errcode = errno; # positive Fehlernummer
        end_system_call();
        clr_break_sem_4(); # keine DOS-Operation mehr aktiv
        begin_error(); # Fehlermeldung anfangen
        # Meldungbeginn ausgeben:
        //: DEUTSCH "DJDOS-Fehler "
        //: ENGLISH "DJDOS error "
        //: FRANCAIS "Erreur DJDOS "
        write_errorstring(GETTEXT("DJDOS error "));
        # Fehlernummer ausgeben:
        write_errorobject(fixnum(errcode));
        # nach Möglichkeit noch ausführlicher:
        #if (DJGPP == 2)
        if (errcode < 39)
        #else
        if (errcode < 36)
        #endif
          {# Zu Fehlernummern <36/39 ist ein Text da.
           #ifdef LANGUAGE_STATIC
             #define lang3(english,deutsch,francais)  ENGLISH ? english : DEUTSCH ? deutsch : FRANCAIS ? francais : ""
             #define lang1(string)  string
             #define langcount  1
             #define language  0
           #else
             #define lang3(english,deutsch,francais)  english, deutsch, francais
             #define lang1(string)  string, string, string
             #define langcount  3
           #endif
           local const char* errormsg_table[39][2];
           var reg2 const char* errorname;
           var reg3 const char* errormsg;

           errormsg_table[0][0]=""; errormsg_table[0][1]="";

           errormsg_table[ENOSYS][0]="ENOSYS";
           //: DEUTSCH "Funktion ist nicht implementiert"
           //: ENGLISH "Function not implemented"
           //: FRANCAIS "fonction non implémentée"
           errormsg_table[ENOSYS][1]=GETTEXT("Function not implemented");

           errormsg_table[ENOENT][0]="ENOENT";
           //: DEUTSCH "File oder Directory existiert nicht"
           //: ENGLISH "No such file or directory"
           //: FRANCAIS "fichier ou répertoire non existant"
           errormsg_table[ENOENT][1]=GETTEXT("No such file or directory");

           errormsg_table[ENOTDIR][0]="ENOTDIR";
           //: DEUTSCH "Das ist kein Directory"
           //: ENGLISH "Not a directory"
           //: FRANCAIS "n'est pas un répertoire"
           errormsg_table[ENOTDIR][1]=GETTEXT("Not a directory");

           errormsg_table[EMFILE][0]="EMFILE";
           //: DEUTSCH "Zu viele offene Files"
           //: ENGLISH "Too many open files"
           //: FRANCAIS "Trop de fichiers ouverts"
           errormsg_table[EMFILE][1]=GETTEXT("Too many open files");

           errormsg_table[EACCES][0]="EACCES";
           //: DEUTSCH "Keine Berechtigung"
           //: ENGLISH "Permission denied"
           //: FRANCAIS "Accès dénié"
           errormsg_table[EACCES][1]=GETTEXT("Permission denied");

           errormsg_table[EBADF][0]="EBADF";
           //: DEUTSCH "File-Descriptor wurde nicht für diese Operation geöffnet"
           //: ENGLISH "Bad file number"
           //: FRANCAIS "descripteur de fichier non alloué"
           errormsg_table[EBADF][1]=GETTEXT("Bad file number");

           errormsg_table[ENOMEM][0]="ENOMEM";
           //: DEUTSCH "Hauptspeicher oder Swapspace reicht nicht"
           //: ENGLISH "Not enough memory"
           //: FRANCAIS "Pas assez de mémoire"
           errormsg_table[ENOMEM][1]=GETTEXT("Not enough memory");

           errormsg_table[ENODEV][0]="ENODEV";
           //: DEUTSCH "Gerät nicht da oder unpassend"
           //: ENGLISH "No such device"
           //: FRANCAIS "il n'y a pas de telle unité"
           errormsg_table[ENODEV][1]=GETTEXT("No such device");

           #if DJGPP == 2
           errormsg_table[ENOMORE][0]="ENMFILE";
           #else
           errormsg_table[ENOMORE][0]="ENOMORE";
           #endif
           //: DEUTSCH "Keine weiteren Dateien"
           //: ENGLISH "No more files"
           //: FRANCAIS "pas plus de fichier"
           errormsg_table[ENOMORE][1]=GETTEXT("No more files");

           errormsg_table[EINVAL][0]="EINVAL";
           //: DEUTSCH "Ungültiger Parameter"
           //: ENGLISH "Invalid argument"
           //: FRANCAIS "Paramètre illicite"
           errormsg_table[EINVAL][1]=GETTEXT("Invalid argument");

           errormsg_table[E2BIG][0]="E2BIG";
           //: DEUTSCH "Zu lange Argumentliste"
           //: ENGLISH "Arg list too long"
           //: FRANCAIS "liste d'arguments trop longue"
           errormsg_table[E2BIG][1]=GETTEXT("Arg list too long");

           errormsg_table[ENOEXEC][0]="ENOEXEC";
           //: DEUTSCH "Kein ausführbares Programm"
           //: ENGLISH "Exec format error"
           //: FRANCAIS "Programme non exécutable"
           errormsg_table[ENOEXEC][1]=GETTEXT("Exec format error");

           errormsg_table[EXDEV][0]="EXDEV";
           //: DEUTSCH "Links können nur aufs selbe Gerät gehen"
           //: ENGLISH "Cross-device link"
           //: FRANCAIS "liens uniquement sur la même unité"
           errormsg_table[EXDEV][1]=GETTEXT("Cross-device link");

           errormsg_table[EDOM][0]="EDOM";
           //: DEUTSCH "Argument zu mathematischer Funktion außerhalb des Definitionsbereichs"
           //: ENGLISH "Argument out of domain"
           //: FRANCAIS "argument hors du domaine de définition d'une fonction mathématique"
           errormsg_table[EDOM][1]=GETTEXT("Argument out of domain");

           errormsg_table[ERANGE][0]="ERANGE";
           //: DEUTSCH "Ergebnis mathematischer Funktion zu groß"
           //: ENGLISH "Result too large"
           //: FRANCAIS "débordement de valeur"
           errormsg_table[ERANGE][1]=GETTEXT("Result too large");

           errormsg_table[EEXIST][0]="EEXIST";
           //: DEUTSCH "File existiert schon"
           //: ENGLISH "File exists"
           //: FRANCAIS "Le fichier existe déjà"
           errormsg_table[EEXIST][1]=GETTEXT("File exists");

           #if DJGPP == 2

           errormsg_table[EAGAIN][0]="EAGAIN";
           //: DEUTSCH ""
           //: ENGLISH "Resource temporarily unavailable"
           //: FRANCAIS ""
           errormsg_table[EAGAIN][1]=GETTEXT("Try again");

           errormsg_table[EBUSY][0]="EBUSY";
           //: DEUTSCH ""
           //: ENGLISH "Resource busy"
           //: FRANCAIS ""
           errormsg_table[EBUSY][1]=GETTEXT("Resource busy");

           errormsg_table[ECHILD][0]="ECHILD";
           //: DEUTSCH "Worauf warten?"
           //: ENGLISH "No child processes"
           //: FRANCAIS "Pas de processus fils"
           errormsg_table[ECHILD][1]=GETTEXT("No more child processes");

           errormsg_table[EDEADLK][0]="EDEADLK";
           //: DEUTSCH "Das würde zu einem Deadlock führen"
           //: ENGLISH "Resource deadlock would occur"
           //: FRANCAIS "Blocage mutuel de la ressource "
           errormsg_table[EDEADLK][1]=GETTEXT("Resource deadlock avoided");

           errormsg_table[EFAULT][0]="EFAULT";
           //: DEUTSCH "Ungültige Adresse"
           //: ENGLISH "Bad address"
           //: FRANCAIS "Mauvaise adresse"
           errormsg_table[EFAULT][1]=GETTEXT("Bad address");

           errormsg_table[EFBIG][0]="EFBIG";
           //: DEUTSCH "Zu großes File"
           //: ENGLISH "File too large"
           //: FRANCAIS "Fichier trop grand"
           errormsg_table[EFBIG][1]=GETTEXT("File too large");

           errormsg_table[EINTR][0]="EINTR";
           //: DEUTSCH "Unterbrechung während Betriebssystem-Aufruf"
           //: ENGLISH "Interrupted system call"
           //: FRANCAIS "Appel système interrompu"
           errormsg_table[EINTR][1]=GETTEXT("Interrupted system call");

           errormsg_table[EIO][0]="EIO";
           //: DEUTSCH "Fehler bei Schreib-/Lesezugriff"
           //: ENGLISH "I/O error"
           //: FRANCAIS "Erreur E/S"
           errormsg_table[EIO][1]=GETTEXT("Input or output");

           errormsg_table[EISDIR][0]="EISDIR";
           //: DEUTSCH "Das ist ein Directory"
           //: ENGLISH "Is a directory"
           //: FRANCAIS "Est un répertoire"
           errormsg_table[EISDIR][1]=GETTEXT("Is a directory");

           errormsg_table[EMLINK][0]="EMLINK";
           //: DEUTSCH "Zu viele Links auf ein File"
           //: ENGLISH "Too many links"
           //: FRANCAIS "Trop de liens"
           errormsg_table[EMLINK][1]=GETTEXT("Too many links");

           errormsg_table[ENAMETOOLONG][0]="ENAMETOOLONG";
           //: DEUTSCH "Zu langer Filename"
           //: ENGLISH "File name too long"
           //: FRANCAIS "Nom du fichier trop long"
           errormsg_table[ENAMETOOLONG][1]=GETTEXT("File name too long");

           errormsg_table[ENOLCK][0]="ENOLCK";
           //: DEUTSCH "Zu viele Zugriffsvorbehalte auf einmal"
           //: ENGLISH "No record locks available"
           //: FRANCAIS "Pas de verrou disponible"
           errormsg_table[ENOLCK][1]=GETTEXT("No locks available");

           errormsg_table[ENOSPC][0]="ENOSPC";
           //: DEUTSCH "Platte oder Diskette voll"
           //: ENGLISH "No space left on device"
           //: FRANCAIS "Plus d'espace libre sur le périphérique"
           errormsg_table[ENOSPC][1]=GETTEXT("No space left on drive");

           errormsg_table[ENOTEMPTY][0]="ENOTEMPTY";
           //: DEUTSCH "Directory ist nicht leer"
           //: ENGLISH "Directory not empty"
           //: FRANCAIS "Répertoire non vide"
           errormsg_table[ENOTEMPTY][1]=GETTEXT("Directory not empty");

           errormsg_table[ENOTTY][0]="ENOTTY";
           //: DEUTSCH "Falscher Gerätetyp"
           //: ENGLISH "Inappropriate ioctl for device"
           //: FRANCAIS "Périphérique ne comprend pas ce ioctl"
           errormsg_table[ENOTTY][1]=GETTEXT("Inappropriate I/O control operation");

           errormsg_table[ENXIO][0]="ENXIO";
           //: DEUTSCH "Gerät existiert nicht oder Laufwerk leer"
           //: ENGLISH "No such device or address"
           //: FRANCAIS "Périphérique ou adresse inexistant"
           errormsg_table[ENXIO][1]=GETTEXT("No such device or address");

           errormsg_table[EPERM][0]="EPERM";
           //: DEUTSCH "Keine Berechtigung dazu"
           //: ENGLISH "Operation not permitted"
           //: FRANCAIS "Opération non autorisée"
           errormsg_table[EPERM][1]=GETTEXT("Operation not permitted");

           errormsg_table[EPIPE][0]="EPIPE";
           //: DEUTSCH "Output versackt"
           //: ENGLISH "Broken pipe"
           //: FRANCAIS "Rupture du tuyau"
           errormsg_table[EPIPE][1]=GETTEXT("Broken pipe");

           errormsg_table[EROFS][0]="EROFS";
           //: DEUTSCH "Dieses Filesystem erlaubt keinen Schreibzugriff"
           //: ENGLISH "Read-only file system"
           //: FRANCAIS "Système de fichiers en lecture seulement"
           errormsg_table[EROFS][1]=GETTEXT("Read-only file system");

           errormsg_table[ESPIPE][0]="ESPIPE";
           //: DEUTSCH "Nicht positionierbares File"
           //: ENGLISH "Illegal seek"
           //: FRANCAIS "seek illégal"
           errormsg_table[ESPIPE][1]=GETTEXT("Invalid seek");

           errormsg_table[ESRCH][0]="ESRCH";
           //: DEUTSCH "Dieser Prozeß existiert nicht (mehr)"
           //: ENGLISH "No such process"
           //: FRANCAIS "Processus inexistant"
           errormsg_table[ESRCH][1]=GETTEXT("No such process");

           #else
           errormsg_table[11][0]=""; errormsg_table[11][1]="";

           errormsg_table[EARENA][0]="EARENA";
           //: DEUTSCH "Speicherverwaltung ist durcheinander"
           //: ENGLISH "Memory control blocks destroyed"
           //: FRANCAIS "gestionnaire de mémoire perdu"
           errormsg_table[EARENA][1]=GETTEXT("Memory control blocks destroyed");

           errormsg_table[EACCODE][0]="EACCODE";
           //: DEUTSCH "Ungültiger Zugriffsmodus"
           //: ENGLISH "Invalid access code"
           //: FRANCAIS "mode d'accès illégal"
           errormsg_table[EACCODE][1]=GETTEXT("Invalid access code");

           errormsg_table[EBADENV][0]="EBADENV";
           //: DEUTSCH "Ungültiges Environment"
           //: ENGLISH "Invalid environment"
           //: FRANCAIS "environnement incorrect"
           errormsg_table[EBADENV][1]=GETTEXT("Invalid environment");

           errormsg_table[13][0]=""; errormsg_table[13][1]="";
           errormsg_table[14][0]=""; errormsg_table[14][1]="";

           errormsg_table[ECURDIR][0]="ECURDIR";
           //: DEUTSCH "Das aktuelle Verzeichnis kann nicht entfernt werden"
           //: ENGLISH "Attempt to remove the current directory"
           //: FRANCAIS "Le répertoire courant ne peut pas être effacé"
           errormsg_table[ECURDIR][1]=GETTEXT("Attempt to remove the current directory");

           errormsg_table[ENOTSAME][0]="ENOTSAME";
           //: DEUTSCH "Verschieben geht nicht über Laufwerksgrenzen hinweg"
           //: ENGLISH "Can't move to other than the same device"
           //: FRANCAIS "ne peux pas déplacer au-delà de l'unité"
           errormsg_table[ENOTSAME][1]=GETTEXT("Can't move to other than the same device");

           errormsg_table[ESEGV][0]="ESEGV";
           //: DEUTSCH "Ungültige Speicher-Adresse"
           //: ENGLISH "Invalid memory address"
           //: FRANCAIS "adresse mémoire illicite"
           errormsg_table[ESEGV][1]=GETTEXT("Invalid memory address");

           errormsg_table[23][0]=""; errormsg_table[23][1]="";
           errormsg_table[24][0]=""; errormsg_table[24][1]="";
           errormsg_table[25][0]=""; errormsg_table[25][1]="";
           errormsg_table[26][0]=""; errormsg_table[26][1]="";
           errormsg_table[27][0]=""; errormsg_table[27][1]="";
           errormsg_table[28][0]=""; errormsg_table[28][1]="";
           errormsg_table[29][0]=""; errormsg_table[29][1]="";
           errormsg_table[30][0]=""; errormsg_table[30][1]="";
           errormsg_table[31][0]=""; errormsg_table[31][1]="";
           errormsg_table[32][0]=""; errormsg_table[32][1]="";
           #endif

           errorname = errormsg_table[errcode][0];
           errormsg = errormsg_table[errcode][1];

           if (!(errorname[0] == 0)) # bekannter Name?
             { write_errorstring(" (");
               write_errorstring(errorname);
               write_errorstring(")");
             }
           if (!(errormsg[0] == 0)) # nichtleere Meldung?
             { write_errorstring(": ");
               write_errorstring(errormsg);
             }
          }
        end_error(args_end_pointer STACKop (4+DYNBIND_SIZE)); # Fehlermeldung beenden
      }

  # Ausgabe eines Fehlers, direkt übers Betriebssystem
  # errno_out(errorcode);
  # > int errorcode: Fehlercode
    global void errno_out (int errorcode);
    global void errno_out(errorcode)
      var reg1 int errorcode;
      { asciz_out(" errno = "); dez_out(errorcode); asciz_out("." CRLFstring); }
#endif

#if defined(UNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS) || defined(WIN32_DOS) || defined(WIN32_UNIX)

  # Behandlung von UNIX-Fehlern
  # OS_error_();
  # > int errno: Fehlercode
    nonreturning_function(global, OS_error_, (void));

  # Problem: viele verschiedene UNIX-Versionen, jede wieder mit anderen
  # Fehlermeldungen.
  # Abhilfe: Die Fehlernamen sind einigermaßen portabel. Die englische
  # Fehlermeldung übernehmen wir, die Übersetzungen machen wir selbst.
  # Französische Fehlermeldungen von Tristan <marc@david.saclay.cea.fr>.

  #if !(defined(UNIX) || defined(EMUNIX) || defined(WATCOM) || defined(WIN32_DOS) || defined(WIN32_UNIX))
    extern int sys_nerr; # Anzahl der Betriebssystem-Fehlermeldungen
    extern char* sys_errlist[]; # Betriebssystem-Fehlermeldungen
  #endif

  # Tabelle der Fehlermeldungen und ihrer Namen:
    typedef struct { const char* name; const char* msg; } os_error;
    local os_error* errormsg_table;

  # Initialisierung der Tabelle:
    global int init_errormsg_table (void);
    global int init_errormsg_table()
      { var reg1 uintC i;
        begin_system_call();
        errormsg_table = (os_error*) malloc(sys_nerr * sizeof(os_error));
        end_system_call();
        if (errormsg_table == NULL) # Speicher reicht nicht?
          { return -1; }
        # Tabelle vor-initialisieren:
        for (i=0; i<sys_nerr; i++)
          { errormsg_table[i].name = "";
            errormsg_table[i].msg = sys_errlist[i];
          }
        # Tabelle initialisieren:
        # Obacht: Auf sys_nerr ist kein Verlaß. (Bei IRIX 5.2 ist EDQUOT >= sys_nerr !)
        /* allgemein verbreitete UNIX-Errors: */
        #ifdef EPERM
        if (EPERM < sys_nerr) {
        errormsg_table[EPERM].name = "EPERM";
        #if !defined(UNIX_LINUX)
        //: DEUTSCH "Keine Berechtigung dazu"
        //: ENGLISH "Not owner"
        //: FRANCAIS "Opération non autorisée"
        errormsg_table[EPERM].msg = GETTEXT("Not owner");
        #else
        //: DEUTSCH "Keine Berechtigung dazu"
        //: ENGLISH "Operation not permitted"
        //: FRANCAIS "Opération non autorisée"
        errormsg_table[EPERM].msg = GETTEXT("Operation not permitted");
        #endif
        }
        #endif
        #ifdef ENOENT
        if (ENOENT < sys_nerr) {
        errormsg_table[ENOENT].name = "ENOENT";
        //: DEUTSCH "File oder Directory existiert nicht"
        //: ENGLISH "No such file or directory"
        //: FRANCAIS "Fichier ou répertoire inéxistant"
        errormsg_table[ENOENT].msg = GETTEXT("No such file or directory");
        }
        #endif
        #ifdef ESRCH
        if (ESRCH < sys_nerr) {
        errormsg_table[ESRCH].name = "ESRCH";
        //: DEUTSCH "Dieser Prozeß existiert nicht (mehr)"
        //: ENGLISH "No such process"
        //: FRANCAIS "Processus inexistant"
        errormsg_table[ESRCH].msg = GETTEXT("No such process");
        }
        #endif
        #ifdef EINTR
        if (EINTR < sys_nerr) {
        errormsg_table[EINTR].name = "EINTR";
        //: DEUTSCH "Unterbrechung während Betriebssystem-Aufruf"
        //: ENGLISH "Interrupted system call"
        //: FRANCAIS "Appel système interrompu"
        errormsg_table[EINTR].msg = GETTEXT("Interrupted system call");
        }
        #endif
        #ifdef EIO
        if (EIO < sys_nerr) {
        errormsg_table[EIO].name = "EIO";
        //: DEUTSCH "Fehler bei Schreib-/Lesezugriff"
        //: ENGLISH "I/O error"
        //: FRANCAIS "Erreur E/S"
        errormsg_table[EIO].msg = GETTEXT("I/O error");
        }
        #endif
        #ifdef ENXIO
        if (ENXIO < sys_nerr) {
        errormsg_table[ENXIO].name = "ENXIO";
        //: DEUTSCH "Gerät existiert nicht oder Laufwerk leer"
        //: ENGLISH "No such device or address"
        //: FRANCAIS "Périphérique ou adresse inexistant"
        errormsg_table[ENXIO].msg = GETTEXT("No such device or address");
        }
        #endif
        #ifdef E2BIG
        if (E2BIG < sys_nerr) {
        errormsg_table[E2BIG].name = "E2BIG";
        //: DEUTSCH "Zu lange Argumentliste"
        //: ENGLISH "Arg list too long"
        //: FRANCAIS "Liste d'arguments trop longue"
        errormsg_table[E2BIG].msg = GETTEXT("Arg list too long");
        }
        #endif
        #ifdef ENOEXEC
        if (ENOEXEC < sys_nerr) {
        errormsg_table[ENOEXEC].name = "ENOEXEC";
        //: DEUTSCH "Kein ausführbares Programm"
        //: ENGLISH "Exec format error"
        //: FRANCAIS "Erreur sur le format exécutable"
        errormsg_table[ENOEXEC].msg = GETTEXT("Exec format error");
        }
        #endif
        #ifdef EBADF
        if (EBADF < sys_nerr) {
        errormsg_table[EBADF].name = "EBADF";
        //: DEUTSCH "File-Descriptor wurde nicht für diese Operation geöffnet"
        //: ENGLISH "Bad file number"
        //: FRANCAIS "Mauvais numéro de fichier"
        errormsg_table[EBADF].msg = GETTEXT("Bad file number");
        }
        #endif
        #ifdef ECHILD
        if (ECHILD < sys_nerr) {
        errormsg_table[ECHILD].name = "ECHILD";
        //: DEUTSCH "Worauf warten?"
        //: ENGLISH "No child processes"
        //: FRANCAIS "Pas de processus fils"
        errormsg_table[ECHILD].msg = GETTEXT("No child processes");
        }
        #endif
        #ifdef EAGAIN
        if (EAGAIN < sys_nerr) {
        errormsg_table[EAGAIN].name = "EAGAIN";
        //: DEUTSCH "Kann keinen weiteren Prozeß erzeugen"
        //: ENGLISH "No more processes"
        //: FRANCAIS "Essayez encore"
        errormsg_table[EAGAIN].msg = GETTEXT("No more processes");
        }
        #endif
        #ifdef ENOMEM
        if (ENOMEM < sys_nerr) {
        errormsg_table[ENOMEM].name = "ENOMEM";
        #if !defined(UNIX_SUNOS4)
        //: DEUTSCH "Hauptspeicher oder Swapspace reicht nicht"
        //: ENGLISH "Not enough memory"
        //: FRANCAIS "Plus de mémoire"
        errormsg_table[ENOMEM].msg = GETTEXT("Not enough memory");
        #else
        //: DEUTSCH "Speicher-Adreßbereich oder Swapspace reicht nicht"
        //: ENGLISH "Not enough memory"
        //: FRANCAIS "Plus de mémoire"
        errormsg_table[ENOMEM].msg = GETTEXT("Not enough memory");
        #endif
        }
        #endif
        #ifdef EACCES
        if (EACCES < sys_nerr) {
        errormsg_table[EACCES].name = "EACCES";
        //: DEUTSCH "Keine Berechtigung"
        //: ENGLISH "Permission denied"
        //: FRANCAIS "Permission refusée"
        errormsg_table[EACCES].msg = GETTEXT("Permission denied");
        }
        #endif
        #ifdef EFAULT
        if (EFAULT < sys_nerr) {
        errormsg_table[EFAULT].name = "EFAULT";
        //: DEUTSCH "Ungültige Adresse"
        //: ENGLISH "Bad address"
        //: FRANCAIS "Mauvaise adresse"
        errormsg_table[EFAULT].msg = GETTEXT("Bad address");
        }
        #endif
        #ifdef ENOTBLK
        if (ENOTBLK < sys_nerr) {
        errormsg_table[ENOTBLK].name = "ENOTBLK";
        //: DEUTSCH "Nur block-strukturierte Geräte erlaubt"
        //: ENGLISH "Block device required"
        //: FRANCAIS "Périphérique bloc requis"
        errormsg_table[ENOTBLK].msg = GETTEXT("Block device required");
        }
        #endif
        #ifdef EBUSY
        if (EBUSY < sys_nerr) {
        errormsg_table[EBUSY].name = "EBUSY";
        #if !defined(UNIX_SUNOS4)
        //: DEUTSCH "Gerät enthält Einheit und darf sie nicht auswerfen"
        //: ENGLISH "Mount device busy"
        //: FRANCAIS "Périphérique occupé"
        errormsg_table[EBUSY].msg = GETTEXT("Mount device busy");
        #else
        //: DEUTSCH "Filesystem darf nicht gekappt werden"
        //: ENGLISH "Device busy"
        //: FRANCAIS "Périphérique occupé"
        errormsg_table[EBUSY].msg = GETTEXT("Device busy");
        #endif
        }
        #endif
        #ifdef EEXIST
        if (EEXIST < sys_nerr) {
        errormsg_table[EEXIST].name = "EEXIST";
        //: DEUTSCH "File existiert schon"
        //: ENGLISH "File exists"
        //: FRANCAIS "Le fichier existe"
        errormsg_table[EEXIST].msg = GETTEXT("File exists");
        }
        #endif
        #ifdef EXDEV
        if (EXDEV < sys_nerr) {
        errormsg_table[EXDEV].name = "EXDEV";
        //: DEUTSCH "Links können nur aufs selbe Gerät gehen"
        //: ENGLISH "Cross-device link"
        //: FRANCAIS "Lien entre périphériques différents"
        errormsg_table[EXDEV].msg = GETTEXT("Cross-device link");
        }
        #endif
        #ifdef ENODEV
        if (ENODEV < sys_nerr) {
        errormsg_table[ENODEV].name = "ENODEV";
        //: DEUTSCH "Gerät nicht da oder unpassend"
        //: ENGLISH "No such device"
        //: FRANCAIS "Périphérique inexistant"
        errormsg_table[ENODEV].msg = GETTEXT("No such device");
        }
        #endif
        #ifdef ENOTDIR
        if (ENOTDIR < sys_nerr) {
        errormsg_table[ENOTDIR].name = "ENOTDIR";
        //: DEUTSCH "Das ist kein Directory"
        //: ENGLISH "Not a directory"
        //: FRANCAIS "N'est pas un répertoire"
        errormsg_table[ENOTDIR].msg = GETTEXT("Not a directory");
        }
        #endif
        #ifdef EISDIR
        if (EISDIR < sys_nerr) {
        errormsg_table[EISDIR].name = "EISDIR";
        //: DEUTSCH "Das ist ein Directory"
        //: ENGLISH "Is a directory"
        //: FRANCAIS "Est un répertoire"
        errormsg_table[EISDIR].msg = GETTEXT("Is a directory");
        }
        #endif
        #ifdef EINVAL
        if (EINVAL < sys_nerr) {
        errormsg_table[EINVAL].name = "EINVAL";
        //: DEUTSCH "Ungültiger Parameter"
        //: ENGLISH "Invalid argument"
        //: FRANCAIS "Argument invalide"
        errormsg_table[EINVAL].msg = GETTEXT("Invalid argument");
        }
        #endif
        #ifdef ENFILE
        if (ENFILE < sys_nerr) {
        errormsg_table[ENFILE].name = "ENFILE";
        //: DEUTSCH "Tabelle der offenen Files ist voll"
        //: ENGLISH "File table overflow"
        //: FRANCAIS "Dépassement de la table des fichiers"
        errormsg_table[ENFILE].msg = GETTEXT("File table overflow");
        }
        #endif
        #ifdef EMFILE
        if (EMFILE < sys_nerr) {
        errormsg_table[EMFILE].name = "EMFILE";
        //: DEUTSCH "Zu viele offene Files"
        //: ENGLISH "Too many open files"
        //: FRANCAIS "Trop de fichiers ouverts"
        errormsg_table[EMFILE].msg = GETTEXT("Too many open files");
        }
        #endif
        #ifdef ENOTTY
        if (ENOTTY < sys_nerr) {
        errormsg_table[ENOTTY].name = "ENOTTY";
        //: DEUTSCH "Falscher Gerätetyp"
        //: ENGLISH "Inappropriate ioctl for device"
        //: FRANCAIS "Périphérique ne comprend pas ce ioctl"
        errormsg_table[ENOTTY].msg = GETTEXT("Inappropriate ioctl for device");
        }
        #endif
        #ifdef ETXTBSY
        if (ETXTBSY < sys_nerr) {
        errormsg_table[ETXTBSY].name = "ETXTBSY";
        //: DEUTSCH "Programm wird gerade geändert oder ausgeführt"
        //: ENGLISH "Text file busy"
        //: FRANCAIS "Fichier code occupé"
        errormsg_table[ETXTBSY].msg = GETTEXT("Text file busy");
        }
        #endif
        #ifdef EFBIG
        if (EFBIG < sys_nerr) {
        errormsg_table[EFBIG].name = "EFBIG";
        //: DEUTSCH "Zu großes File"
        //: ENGLISH "File too large"
        //: FRANCAIS "Fichier trop grand"
        errormsg_table[EFBIG].msg = GETTEXT("File too large");
        }
        #endif
        #ifdef ENOSPC
        if (ENOSPC < sys_nerr) {
        errormsg_table[ENOSPC].name = "ENOSPC";
        //: DEUTSCH "Platte oder Diskette voll"
        //: ENGLISH "No space left on device"
        //: FRANCAIS "Plus d'espace libre sur le périphérique"
        errormsg_table[ENOSPC].msg = GETTEXT("No space left on device");
        }
        #endif
        #ifdef ESPIPE
        if (ESPIPE < sys_nerr) {
        errormsg_table[ESPIPE].name = "ESPIPE";
        //: DEUTSCH "Nicht positionierbares File"
        //: ENGLISH "Illegal seek"
        //: FRANCAIS "seek illégal"
        errormsg_table[ESPIPE].msg = GETTEXT("Illegal seek");
        }
        #endif
        #ifdef EROFS
        if (EROFS < sys_nerr) {
        errormsg_table[EROFS].name = "EROFS";
        //: DEUTSCH "Dieses Filesystem erlaubt keinen Schreibzugriff"
        //: ENGLISH "Read-only file system"
        //: FRANCAIS "Système de fichiers en lecture seulement"
        errormsg_table[EROFS].msg = GETTEXT("Read-only file system");
        }
        #endif
        #ifdef EMLINK
        if (EMLINK < sys_nerr) {
        errormsg_table[EMLINK].name = "EMLINK";
        //: DEUTSCH "Zu viele Links auf ein File"
        //: ENGLISH "Too many links"
        //: FRANCAIS "Trop de liens"
        errormsg_table[EMLINK].msg = GETTEXT("Too many links");
        }
        #endif
        #ifdef EPIPE
        if (EPIPE < sys_nerr) {
        errormsg_table[EPIPE].name = "EPIPE";
        //: DEUTSCH "Output versackt"
        //: ENGLISH "Broken pipe"
        //: FRANCAIS "Rupture du tuyau"
        errormsg_table[EPIPE].msg = GETTEXT("Broken pipe");
        }
        #endif
        /* Errors bei mathematischen Funktionen: */
        #ifdef EDOM
        if (EDOM < sys_nerr) {
        errormsg_table[EDOM].name = "EDOM";
        //: DEUTSCH "Argument zu mathematischer Funktion außerhalb des Definitionsbereichs"
        //: ENGLISH "Argument out of domain"
        //: FRANCAIS "Argument mathématique en dehors du domaine de définition de la fonction"
        errormsg_table[EDOM].msg = GETTEXT("Argument out of domain");
        }
        #endif
        #ifdef ERANGE
        if (ERANGE < sys_nerr) {
        errormsg_table[ERANGE].name = "ERANGE";
        //: DEUTSCH "Ergebnis mathematischer Funktion zu groß"
        //: ENGLISH "Result too large"
        //: FRANCAIS "Résultat mathématique non représentable"
        errormsg_table[ERANGE].msg = GETTEXT("Result too large");
        }
        #endif
        /* Errors bei Non-Blocking I/O und Interrupt I/O: */
        #ifdef EWOULDBLOCK
        if (EWOULDBLOCK < sys_nerr) {
        errormsg_table[EWOULDBLOCK].name = "EWOULDBLOCK";
        //: DEUTSCH "Darauf müßte gewartet werden"
        //: ENGLISH "Operation would block"
        //: FRANCAIS "L'opération devrait bloquer"
        errormsg_table[EWOULDBLOCK].msg = GETTEXT("Operation would block");
        }
        #endif
        #ifdef EINPROGRESS
        if (EINPROGRESS < sys_nerr) {
        errormsg_table[EINPROGRESS].name = "EINPROGRESS";
        //: DEUTSCH "Das kann lange dauern"
        //: ENGLISH "Operation now in progress"
        //: FRANCAIS "Operation maintenant en cours"
        errormsg_table[EINPROGRESS].msg = GETTEXT("Operation now in progress");
        }
        #endif
        #ifdef EALREADY
        if (EALREADY < sys_nerr) {
        errormsg_table[EALREADY].name = "EALREADY";
        //: DEUTSCH "Es läuft schon eine Operation"
        //: ENGLISH "Operation already in progress"
        //: FRANCAIS "Operation déjà en cours"
        errormsg_table[EALREADY].msg = GETTEXT("Operation already in progress");
        }
        #endif
        /* weitere allgemein übliche Errors: */
        #ifdef ELOOP
        if (ELOOP < sys_nerr) {
        errormsg_table[ELOOP].name = "ELOOP";
        //: DEUTSCH "Zu viele symbolische Links in einem Pathname"
        //: ENGLISH "Too many levels of symbolic links"
        //: FRANCAIS "Trop de liens symboliques rencontrés"
        errormsg_table[ELOOP].msg = GETTEXT("Too many levels of symbolic links");
        }
        #endif
        #ifdef ENAMETOOLONG
        if (ENAMETOOLONG < sys_nerr) {
        errormsg_table[ENAMETOOLONG].name = "ENAMETOOLONG";
        //: DEUTSCH "Zu langer Filename"
        //: ENGLISH "File name too long"
        //: FRANCAIS "Nom du fichier trop long"
        errormsg_table[ENAMETOOLONG].msg = GETTEXT("File name too long");
        }
        #endif
        #ifdef ENOTEMPTY
        if (ENOTEMPTY < sys_nerr) {
        errormsg_table[ENOTEMPTY].name = "ENOTEMPTY";
        //: DEUTSCH "Directory ist nicht leer"
        //: ENGLISH "Directory not empty"
        //: FRANCAIS "Répertoire non vide"
        errormsg_table[ENOTEMPTY].msg = GETTEXT("Directory not empty");
        }
        #endif
        /* Errors im Zusammenhang mit Network File System (NFS): */
        #ifdef ESTALE
        if (ESTALE < sys_nerr) {
        errormsg_table[ESTALE].name = "ESTALE";
        //: DEUTSCH "Offenes File auf entferntem Filesystem wurde gelöscht"
        //: ENGLISH "Stale NFS file handle"
        //: FRANCAIS "Fichier NFS perdu"
        errormsg_table[ESTALE].msg = GETTEXT("Stale NFS file handle");
        }
        #endif
        #ifdef EREMOTE
        if (EREMOTE < sys_nerr) {
        errormsg_table[EREMOTE].name = "EREMOTE";
        //: DEUTSCH "Mount läuft nicht auf entfernten Filesystemen"
        //: ENGLISH "Too many levels of remote in path"
        //: FRANCAIS "Mount éloigné ne marche pas"
        errormsg_table[EREMOTE].msg = GETTEXT("Too many levels of remote in path");
        }
        #endif
        /* Errors im Zusammenhang mit Sockets, IPC und Netzwerk: */
        #ifdef ENOTSOCK
        if (ENOTSOCK < sys_nerr) {
        errormsg_table[ENOTSOCK].name = "ENOTSOCK";
        //: DEUTSCH "Socket-Operation und kein Socket"
        //: ENGLISH "Socket operation on non-socket"
        //: FRANCAIS "Opération de type socket sur un fichier non-socket"
        errormsg_table[ENOTSOCK].msg = GETTEXT("Socket operation on non-socket");
        }
        #endif
        #ifdef EDESTADDRREQ
        if (EDESTADDRREQ < sys_nerr) {
        errormsg_table[EDESTADDRREQ].name = "EDESTADDRREQ";
        //: DEUTSCH "Operation braucht Zieladresse"
        //: ENGLISH "Destination address required"
        //: FRANCAIS "Adresse de destination obligatoire"
        errormsg_table[EDESTADDRREQ].msg = GETTEXT("Destination address required");
        }
        #endif
        #ifdef EMSGSIZE
        if (EMSGSIZE < sys_nerr) {
        errormsg_table[EMSGSIZE].name = "EMSGSIZE";
        //: DEUTSCH "Zu lange Nachricht"
        //: ENGLISH "Message too long"
        //: FRANCAIS "Message trop long"
        errormsg_table[EMSGSIZE].msg = GETTEXT("Message too long");
        }
        #endif
        #ifdef EPROTOTYPE
        if (EPROTOTYPE < sys_nerr) {
        errormsg_table[EPROTOTYPE].name = "EPROTOTYPE";
        //: DEUTSCH "Dieses Protokoll paßt nicht zu diesem Socket"
        //: ENGLISH "Protocol wrong type for socket"
        //: FRANCAIS "Mauvais type de protocole pour un socket"
        errormsg_table[EPROTOTYPE].msg = GETTEXT("Protocol wrong type for socket");
        }
        #endif
        #ifdef ENOPROTOOPT
        if (ENOPROTOOPT < sys_nerr) {
        errormsg_table[ENOPROTOOPT].name = "ENOPROTOOPT";
        #if defined(UNIX_SUNOS4)
        //: DEUTSCH "Fehlerhafte Option zu Protokoll auf Socket"
        //: ENGLISH "Option not supported by protocol"
        //: FRANCAIS "Protocole non disponible"
        errormsg_table[ENOPROTOOPT].msg = GETTEXT("Option not supported by protocol");
        #else
        #if defined(UNIX_BSD)
        //: DEUTSCH "Fehlerhafte Option zu Protokoll auf Socket"
        //: ENGLISH "Bad protocol option"
        //: FRANCAIS "Protocole non disponible"
        errormsg_table[ENOPROTOOPT].msg = GETTEXT("Bad protocol option");
        #else /* UNIX_HPUX, UNIX_LINUX */
        //: DEUTSCH "Fehlerhafte Option zu Protokoll auf Socket"
        //: ENGLISH "Protocol not available"
        //: FRANCAIS "Protocole non disponible"
        errormsg_table[ENOPROTOOPT].msg = GETTEXT("Protocol not available");
        #endif
        #endif
        }
        #endif
        #ifdef EPROTONOSUPPORT
        if (EPROTONOSUPPORT < sys_nerr) {
        errormsg_table[EPROTONOSUPPORT].name = "EPROTONOSUPPORT";
        //: DEUTSCH "Protokoll nicht implementiert"
        //: ENGLISH "Protocol not supported"
        //: FRANCAIS "Protocole non supporté"
        errormsg_table[EPROTONOSUPPORT].msg = GETTEXT("Protocol not supported");
        }
        #endif
        #ifdef ESOCKTNOSUPPORT
        if (ESOCKTNOSUPPORT < sys_nerr) {
        errormsg_table[ESOCKTNOSUPPORT].name = "ESOCKTNOSUPPORT";
        //: DEUTSCH "Socket-Typ nicht implementiert"
        //: ENGLISH "Socket type not supported"
        //: FRANCAIS "Type de socket non supporté"
        errormsg_table[ESOCKTNOSUPPORT].msg = GETTEXT("Socket type not supported");
        }
        #endif
        #ifdef EOPNOTSUPP
        if (EOPNOTSUPP < sys_nerr) {
        errormsg_table[EOPNOTSUPP].name = "EOPNOTSUPP";
        //: DEUTSCH "Operation auf diesem Socket nicht implementiert"
        //: ENGLISH "Operation not supported on socket"
        //: FRANCAIS "Opération non supportée sur socket"
        errormsg_table[EOPNOTSUPP].msg = GETTEXT("Operation not supported on socket");
        }
        #endif
        #ifdef EPFNOSUPPORT
        if (EPFNOSUPPORT < sys_nerr) {
        errormsg_table[EPFNOSUPPORT].name = "EPFNOSUPPORT";
        //: DEUTSCH "Protokoll-Familie nicht implementiert"
        //: ENGLISH "Protocol family not supported"
        //: FRANCAIS "Famille de protocoles non supportée"
        errormsg_table[EPFNOSUPPORT].msg = GETTEXT("Protocol family not supported");
        }
        #endif
        #ifdef EAFNOSUPPORT
        if (EAFNOSUPPORT < sys_nerr) {
        errormsg_table[EAFNOSUPPORT].name = "EAFNOSUPPORT";
        //: DEUTSCH "Adressen-Familie paßt nicht zu diesem Protokoll"
        //: ENGLISH "Address family not supported by protocol family"
        //: FRANCAIS "Famille d'adresses non supportée par le protocole"
        errormsg_table[EAFNOSUPPORT].msg = GETTEXT("Address family not supported by protocol family");
        }
        #endif
        #ifdef EADDRINUSE
        if (EADDRINUSE < sys_nerr) {
        errormsg_table[EADDRINUSE].name = "EADDRINUSE";
        //: DEUTSCH "Adresse schon belegt"
        //: ENGLISH "Address already in use"
        //: FRANCAIS "Adresse déjà utilisée"
        errormsg_table[EADDRINUSE].msg = GETTEXT("Address already in use");
        }
        #endif
        #ifdef EADDRNOTAVAIL
        if (EADDRNOTAVAIL < sys_nerr) {
        errormsg_table[EADDRNOTAVAIL].name = "EADDRNOTAVAIL";
        //: DEUTSCH "Adresse nicht (auf diesem Rechner) verfügbar"
        //: ENGLISH "Can't assign requested address"
        //: FRANCAIS "Ne peut pas assigner l'adresse demandée"
        errormsg_table[EADDRNOTAVAIL].msg = GETTEXT("Can't assign requested address");
        }
        #endif
        #ifdef ENETDOWN
        if (ENETDOWN < sys_nerr) {
        errormsg_table[ENETDOWN].name = "ENETDOWN";
        //: DEUTSCH "Netz streikt"
        //: ENGLISH "Network is down"
        //: FRANCAIS "Le réseau est éteint"
        errormsg_table[ENETDOWN].msg = GETTEXT("Network is down");
        }
        #endif
        #ifdef ENETUNREACH
        if (ENETUNREACH < sys_nerr) {
        errormsg_table[ENETUNREACH].name = "ENETUNREACH";
        //: DEUTSCH "Netz unbekannt und außer Sichtweite"
        //: ENGLISH "Network is unreachable"
        //: FRANCAIS "Le réseau ne peut être atteint"
        errormsg_table[ENETUNREACH].msg = GETTEXT("Network is unreachable");
        }
        #endif
        #ifdef ENETRESET
        if (ENETRESET < sys_nerr) {
        errormsg_table[ENETRESET].name = "ENETRESET";
        //: DEUTSCH "Rechner bootete, Verbindung gekappt"
        //: ENGLISH "Network dropped connection on reset"
        //: FRANCAIS "Le réseau a rompu la connection à cause d'une remise à zéro"
        errormsg_table[ENETRESET].msg = GETTEXT("Network dropped connection on reset");
        }
        #endif
        #ifdef ECONNABORTED
        if (ECONNABORTED < sys_nerr) {
        errormsg_table[ECONNABORTED].name = "ECONNABORTED";
        //: DEUTSCH "Mußte diese Verbindung kappen"
        //: ENGLISH "Software caused connection abort"
        //: FRANCAIS "Echec de connection à cause du logiciel"
        errormsg_table[ECONNABORTED].msg = GETTEXT("Software caused connection abort");
        }
        #endif
        #ifdef ECONNRESET
        if (ECONNRESET < sys_nerr) {
        errormsg_table[ECONNRESET].name = "ECONNRESET";
        //: DEUTSCH "Gegenseite kappte die Verbindung"
        //: ENGLISH "Connection reset by peer"
        //: FRANCAIS "Connection remise à zéro par le correspondant"
        errormsg_table[ECONNRESET].msg = GETTEXT("Connection reset by peer");
        }
        #endif
        #ifdef ENOBUFS
        if (ENOBUFS < sys_nerr) {
        errormsg_table[ENOBUFS].name = "ENOBUFS";
        //: DEUTSCH "Nicht genügend Platz für einen Buffer"
        //: ENGLISH "No buffer space available"
        //: FRANCAIS "Pas d'espace disponible pour un buffer"
        errormsg_table[ENOBUFS].msg = GETTEXT("No buffer space available");
        }
        #endif
        #ifdef EISCONN
        if (EISCONN < sys_nerr) {
        errormsg_table[EISCONN].name = "EISCONN";
        //: DEUTSCH "Socket ist bereits verbunden"
        //: ENGLISH "Socket is already connected"
        //: FRANCAIS "Le socket est déjà connecté"
        errormsg_table[EISCONN].msg = GETTEXT("Socket is already connected");
        }
        #endif
        #ifdef ENOTCONN
        if (ENOTCONN < sys_nerr) {
        errormsg_table[ENOTCONN].name = "ENOTCONN";
        //: DEUTSCH "Socket hat keine Verbindung"
        //: ENGLISH "Socket is not connected"
        //: FRANCAIS "Le socket n'est pas connecté"
        errormsg_table[ENOTCONN].msg = GETTEXT("Socket is not connected");
        }
        #endif
        #ifdef ESHUTDOWN
        if (ESHUTDOWN < sys_nerr) {
        errormsg_table[ESHUTDOWN].name = "ESHUTDOWN";
        //: DEUTSCH "Shutdown hat den Socket schon deaktiviert"
        //: ENGLISH "Can't send after socket shutdown"
        //: FRANCAIS "Impossibilité d'envoyer après un arrêt de socket"
        errormsg_table[ESHUTDOWN].msg = GETTEXT("Can't send after socket shutdown");
        }
        #endif
        #ifdef ETOOMANYREFS
        if (ETOOMANYREFS < sys_nerr) {
        errormsg_table[ETOOMANYREFS].name = "ETOOMANYREFS";
        //: DEUTSCH "Too many references: can't splice"
        //: ENGLISH "Too many references: can't splice"
        //: FRANCAIS "Too many references: can't splice"
        errormsg_table[ETOOMANYREFS].msg = GETTEXT("Too many references: can't splice");
        }
        #endif
        #ifdef ETIMEDOUT
        if (ETIMEDOUT < sys_nerr) {
        errormsg_table[ETIMEDOUT].name = "ETIMEDOUT";
        //: DEUTSCH "Verbindung nach Timeout gekappt"
        //: ENGLISH "Connection timed out"
        //: FRANCAIS "Durée écoulée pour la connection"
        errormsg_table[ETIMEDOUT].msg = GETTEXT("Connection timed out");
        }
        #endif
        #ifdef ECONNREFUSED
        if (ECONNREFUSED < sys_nerr) {
        errormsg_table[ECONNREFUSED].name = "ECONNREFUSED";
        //: DEUTSCH "Gegenseite verweigert die Verbindung"
        //: ENGLISH "Connection refused"
        //: FRANCAIS "Connection refusée"
        errormsg_table[ECONNREFUSED].msg = GETTEXT("Connection refused");
        }
        #endif
        #if 0
        errormsg_table[].name = "";
        //: DEUTSCH "Remote peer released connection"
        //: ENGLISH "Remote peer released connection"
        //: FRANCAIS "Remote peer released connection"
        errormsg_table[].msg = GETTEXT("Remote peer released connection");
        #endif
        #ifdef EHOSTDOWN
        if (EHOSTDOWN < sys_nerr) {
        errormsg_table[EHOSTDOWN].name = "EHOSTDOWN";
        //: DEUTSCH "Gegenseite ist wohl abgeschaltet"
        //: ENGLISH "Host is down"
        //: FRANCAIS "L'hôte est éteint"
        errormsg_table[EHOSTDOWN].msg = GETTEXT("Host is down");
        }
        #endif
        #ifdef EHOSTUNREACH
        if (EHOSTUNREACH < sys_nerr) {
        errormsg_table[EHOSTUNREACH].name = "EHOSTUNREACH";
        //: DEUTSCH "Gegenseite nicht in Sichtweite, nicht erreichbar"
        //: ENGLISH "Host is unreachable"
        //: FRANCAIS "Aucune route pour cet hôte"
        errormsg_table[EHOSTUNREACH].msg = GETTEXT("Host is unreachable");
        }
        #endif
        #if 0
        errormsg_table[].name = "";
        //: DEUTSCH "Networking error"
        //: ENGLISH "Networking error"
        //: FRANCAIS "Networking error"
        errormsg_table[].msg = GETTEXT("Networking error");
        #endif
        /* Quotas: */
        #ifdef EPROCLIM
        if (EPROCLIM < sys_nerr) {
        errormsg_table[EPROCLIM].name = "EPROCLIM";
        //: DEUTSCH "Zu viele Prozesse am Laufen"
        //: ENGLISH "Too many processes"
        //: FRANCAIS "Trop de processus"
        errormsg_table[EPROCLIM].msg = GETTEXT("Too many processes");
        }
        #endif
        #ifdef EUSERS
        if (EUSERS < sys_nerr) {
        errormsg_table[EUSERS].name = "EUSERS";
        //: DEUTSCH "Zu viele Benutzer aktiv"
        //: ENGLISH "Too many users"
        //: FRANCAIS "Trop d'utilisateurs"
        errormsg_table[EUSERS].msg = GETTEXT("Too many users");
        }
        #endif
        #ifdef EDQUOT
        if (EDQUOT < sys_nerr) {
        errormsg_table[EDQUOT].name = "EDQUOT";
        //: DEUTSCH "Plattenplatz rationiert, Ihr Anteil ist erschöpft"
        //: ENGLISH "Disk quota exceeded"
        //: FRANCAIS "Ration d'espace est épuisée"
        errormsg_table[EDQUOT].msg = GETTEXT("Disk quota exceeded");
        }
        #endif
        /* Errors im Zusammenhang mit STREAMS: */
        #ifdef ENOSTR
        if (ENOSTR < sys_nerr) {
        errormsg_table[ENOSTR].name = "ENOSTR";
        //: DEUTSCH "Das ist kein STREAM"
        //: ENGLISH "Not a stream device"
        //: FRANCAIS "Not a stream device"
        errormsg_table[ENOSTR].msg = GETTEXT("Not a stream device");
        }
        #endif
        #ifdef ETIME
        if (ETIME < sys_nerr) {
        errormsg_table[ETIME].name = "ETIME";
        //: DEUTSCH "STREAM braucht länger als erwartet"
        //: ENGLISH "Timer expired"
        //: FRANCAIS "Timer expired"
        errormsg_table[ETIME].msg = GETTEXT("Timer expired");
        }
        #endif
        #ifdef ENOSR
        if (ENOSR < sys_nerr) {
        errormsg_table[ENOSR].name = "ENOSR";
        //: DEUTSCH "Kein Platz für weiteren STREAM"
        //: ENGLISH "Out of stream resources"
        //: FRANCAIS "Out of stream resources"
        errormsg_table[ENOSR].msg = GETTEXT("Out of stream resources");
        }
        #endif
        #ifdef ENOMSG
        if (ENOMSG < sys_nerr) {
        errormsg_table[ENOMSG].name = "ENOMSG";
        //: DEUTSCH "Nachrichten dieses Typs gibt es hier nicht"
        //: ENGLISH "No message of desired type"
        //: FRANCAIS "No message of desired type"
        errormsg_table[ENOMSG].msg = GETTEXT("No message of desired type");
        }
        #endif
        #ifdef EBADMSG
        if (EBADMSG < sys_nerr) {
        errormsg_table[EBADMSG].name = "EBADMSG";
        //: DEUTSCH "Nachricht von unbekanntem Typ angekommen"
        //: ENGLISH "Not a data message"
        //: FRANCAIS "Not a data message"
        errormsg_table[EBADMSG].msg = GETTEXT("Not a data message");
        }
        #endif
        /* Errors bei SystemV IPC: */
        #ifdef EIDRM
        if (EIDRM < sys_nerr) {
        errormsg_table[EIDRM].name = "EIDRM";
        //: DEUTSCH "Name (einer Semaphore) wurde gelöscht"
        //: ENGLISH "Identifier removed"
        //: FRANCAIS "Identificateur supprimé"
        errormsg_table[EIDRM].msg = GETTEXT("Identifier removed");
        }
        #endif
        /* Errors bei SystemV Record-Locking: */
        #ifdef EDEADLK
        if (EDEADLK < sys_nerr) {
        errormsg_table[EDEADLK].name = "EDEADLK";
        //: DEUTSCH "Das würde zu einem Deadlock führen"
        //: ENGLISH "Resource deadlock would occur"
        //: FRANCAIS "Blocage mutuel de la ressource "
        errormsg_table[EDEADLK].msg = GETTEXT("Resource deadlock would occur");
        }
        #endif
        #ifdef ENOLCK
        if (ENOLCK < sys_nerr) {
        errormsg_table[ENOLCK].name = "ENOLCK";
        //: DEUTSCH "Zu viele Zugriffsvorbehalte auf einmal"
        //: ENGLISH "No record locks available"
        //: FRANCAIS "Pas de verrou disponible"
        errormsg_table[ENOLCK].msg = GETTEXT("No record locks available");
        }
        #endif
        /* Errors bei Remote File System (RFS): */
        #ifdef ENONET
        if (ENONET < sys_nerr) {
        errormsg_table[ENONET].name = "ENONET";
        //: DEUTSCH "Rechner nicht übers Netz erreichbar"
        //: ENGLISH "Machine is not on the network"
        //: FRANCAIS "La machine n'est pas sur le réseau"
        errormsg_table[ENONET].msg = GETTEXT("Machine is not on the network");
        }
        #endif
        #ifdef EREMOTE
        if (EREMOTE < sys_nerr) {
        errormsg_table[EREMOTE].name = "EREMOTE";
        //: DEUTSCH "Das kann nur der dortige Rechner"
        //: ENGLISH "Object is remote"
        //: FRANCAIS "Objet à distance"
        errormsg_table[EREMOTE].msg = GETTEXT("Object is remote");
        }
        #endif
        #ifdef ERREMOTE
        if (ERREMOTE < sys_nerr) {
        errormsg_table[ERREMOTE].name = "ERREMOTE";
        //: DEUTSCH "Das kann nur der dortige Rechner"
        //: ENGLISH "Object is remote"
        //: FRANCAIS "Objet à distance"
        errormsg_table[ERREMOTE].msg = GETTEXT("Object is remote");
        }
        #endif
        #ifdef ENOLINK
        if (ENOLINK < sys_nerr) {
        errormsg_table[ENOLINK].name = "ENOLINK";
        //: DEUTSCH "Verbindung ist zusammengebrochen"
        //: ENGLISH "Link has been severed"
        //: FRANCAIS "Le lien a été coupé"
        errormsg_table[ENOLINK].msg = GETTEXT("Link has been severed");
        }
        #endif
        #ifdef EADV
        if (EADV < sys_nerr) {
        errormsg_table[EADV].name = "EADV";
        //: DEUTSCH "Andere Rechner benutzen noch unsere Ressourcen"
        //: ENGLISH "Advertise error"
        //: FRANCAIS "Erreur d'annonce"
        errormsg_table[EADV].msg = GETTEXT("Advertise error");
        }
        #endif
        #ifdef ESRMNT
        if (ESRMNT < sys_nerr) {
        errormsg_table[ESRMNT].name = "ESRMNT";
        //: DEUTSCH "Andere Rechner benutzen noch unsere Ressourcen"
        //: ENGLISH "Srmount error"
        //: FRANCAIS "Erreur srmount"
        errormsg_table[ESRMNT].msg = GETTEXT("Srmount error");
        }
        #endif
        #ifdef ECOMM
        if (ECOMM < sys_nerr) {
        errormsg_table[ECOMM].name = "ECOMM";
        //: DEUTSCH "Beim Senden: Rechner nicht erreichbar"
        //: ENGLISH "Communication error on send"
        //: FRANCAIS "Erreur de communication lors d'un envoi"
        errormsg_table[ECOMM].msg = GETTEXT("Communication error on send");
        }
        #endif
        #ifdef EPROTO
        if (EPROTO < sys_nerr) {
        errormsg_table[EPROTO].name = "EPROTO";
        //: DEUTSCH "Protokoll klappt nicht"
        //: ENGLISH "Protocol error"
        //: FRANCAIS "Erreur de protocole"
        errormsg_table[EPROTO].msg = GETTEXT("Protocol error");
        }
        #endif
        #ifdef EMULTIHOP
        if (EMULTIHOP < sys_nerr) {
        errormsg_table[EMULTIHOP].name = "EMULTIHOP";
        //: DEUTSCH "Ressourcen nicht direkt erreichbar"
        //: ENGLISH "Multihop attempted"
        //: FRANCAIS "Tentative de sauts multiples"
        errormsg_table[EMULTIHOP].msg = GETTEXT("Multihop attempted");
        }
        #endif
        #ifdef EDOTDOT
        if (EDOTDOT < sys_nerr) {
        errormsg_table[EDOTDOT].name = "EDOTDOT";
        //: DEUTSCH "EDOTDOT"
        //: ENGLISH "EDOTDOT"
        //: FRANCAIS "EDOTDOT"
        errormsg_table[EDOTDOT].msg = GETTEXT("EDOTDOT");
        }
        #endif
        #ifdef EREMCHG
        if (EREMCHG < sys_nerr) {
        errormsg_table[EREMCHG].name = "EREMCHG";
        //: DEUTSCH "Rechner hat jetzt eine andere Adresse"
        //: ENGLISH "Remote address changed"
        //: FRANCAIS "Adresse à distance changée"
        errormsg_table[EREMCHG].msg = GETTEXT("Remote address changed");
        }
        #endif
        /* Errors von POSIX: */
        #ifdef ENOSYS
        if (ENOSYS < sys_nerr) {
        errormsg_table[ENOSYS].name = "ENOSYS";
        //: DEUTSCH "POSIX-Funktion hier nicht implementiert"
        //: ENGLISH "Function not implemented"
        //: FRANCAIS "Fonction non implémenté"
        errormsg_table[ENOSYS].msg = GETTEXT("Function not implemented");
        }
        #endif
        /* Sonstige: */
        #ifdef EMSDOS /* emx 0.8e - 0.8h */
        if (EMSDOS < sys_nerr) {
        errormsg_table[EMSDOS].name = "EMSDOS";
        //: DEUTSCH "Das geht unter MS-DOS nicht"
        //: ENGLISH "Not supported under MS-DOS"
        //: FRANCAIS "Pas supporté sous MS-DOS"
        errormsg_table[EMSDOS].msg = GETTEXT("Not supported under MS-DOS");
        }
        #endif
        return 0;
      }

    global void OS_error_ ()
      { var reg1 uintC errcode = errno; # positive Fehlernummer
        end_system_call();
        clr_break_sem_4(); # keine UNIX-Operation mehr aktiv
        begin_error(); # Fehlermeldung anfangen
       {# Meldungbeginn ausgeben:
        #ifdef UNIX
        //: DEUTSCH "UNIX-Fehler "
        //: ENGLISH "UNIX error "
        //: FRANCAIS "Erreur UNIX "
        write_errorstring(GETTEXT("Unix error "));
        #else
        //: DEUTSCH "UNIX-Bibliotheks-Fehler "
        //: ENGLISH "UNIX library error "
        //: FRANCAIS "Erreur dans la librairie UNIX "
        write_errorstring(GETTEXT("Unix library error "));
        #endif
        # Fehlernummer ausgeben:
        write_errorobject(fixnum(errcode));
        #if 0
        { # Fehlermeldung des Betriebssystems ausgeben:
          if (errcode < sys_nerr)
            { var reg2 const char* errormsg = sys_errlist[errcode];
              write_errorstring(": ");
              write_errorstring(errormsg);
        }   }
        #else # nach Möglichkeit noch ausführlicher:
        { # eigene Fehlermeldung ausgeben:
          if (errcode < sys_nerr)
            # Zu dieser Fehlernummer ist ein Text da.
            { var reg2 const char* errorname = errormsg_table[errcode].name;
              var reg2 const char* errormsg = errormsg_table[errcode].msg;
              if (!(errorname[0] == 0)) # bekannter Name?
                { write_errorstring(" (");
                  write_errorstring(errorname);
                  write_errorstring(")");
                }
              if (!(errormsg[0] == 0)) # nichtleere Meldung?
                { write_errorstring(": ");
                  write_errorstring(errormsg);
                }
        }   }
        #endif
       }
        errno = 0; # Fehlercode löschen (fürs nächste Mal)
        end_error(args_end_pointer STACKop (4+DYNBIND_SIZE)); # Fehlermeldung beenden
      }

  # Ausgabe eines Fehlers, direkt übers Betriebssystem
  # errno_out(errorcode);
  # > int errorcode: Fehlercode
    global void errno_out (int errorcode);
    global void errno_out(errorcode)
      var reg1 int errorcode;
      { asciz_out(" errno = ");
        if ((uintL)errorcode < sys_nerr)
          { var reg2 const char* errorname = errormsg_table[errorcode].name;
            var reg2 const char* errormsg = errormsg_table[errorcode].msg;
            if (!(errorname[0] == 0)) # bekannter Name?
              { asciz_out(errorname); }
              else
              { dez_out(errorcode); }
            if (!(errormsg[0] == 0)) # nichtleere Meldung?
              { asciz_out(": "); asciz_out(errormsg); }
          }
          else
          { dez_out(errorcode); }
        asciz_out("." CRLFstring);
      }

#endif # UNIX || EMUNIX || WATCOM || RISCOS

  nonreturning_function(global, OS_error_debug, (const char *,int));
  global void OS_error_debug (const char *filename,int lineno);
  global void OS_error_debug(filename,lineno)
    var const char *filename;
    var int lineno;
    {
      asciz_out(CRLFstring "filename: "); asciz_out(filename); 
      asciz_out(CRLFstring "line: "); dez_out(lineno);
      asciz_out(CRLFstring);
      OS_error_();
    }

LISPFUN(error,1,0,rest,nokey,0,NIL)
# (ERROR errorstring {expr})
# Kehrt nicht zurück.
# (defun error (errorstring &rest args)
#   (if (or *error-handler* (not *use-clcs*))
#     (progn
#       (if *error-handler*
#         (apply *error-handler* nil errorstring args)
#         (progn
#           (terpri *error-output*)
#           (write-string "*** - " *error-output*)
#           (apply #'format *error-output* errorstring args)
#       ) )
#       (funcall *break-driver* nil)
#     )
#     (let ((condition (coerce-to-condition errorstring args 'error 'simple-error)))
#       (signal condition)
#       (invoke-debugger condition)
#     )
# ) )
  { if (!sym_nullp(S(error_handler)) || sym_nullp(S(use_clcs)))
      { begin_error(); # Fehlermeldung anfangen
        rest_args_pointer skipSTACKop 1; # Pointer über die Argumente
        {var reg5 object fun;
         var reg4 object arg1;
         if (nullp(STACK_1))
           { fun = S(format); arg1 = STACK_0; } # (FORMAT *error-output* ...)
           else
           { fun = STACK_1; arg1 = NIL; } # (FUNCALL *error-handler* NIL ...)
         skipSTACK(3);
         # Errormeldung ausgeben:
         #   (FORMAT *ERROR-OUTPUT* errorstring {expr})
         # bzw. ({handler} nil errorstring {expr})
         pushSTACK(arg1);
         { var reg1 object* ptr = rest_args_pointer;
           var reg3 uintC count;
           dotimespC(count,1+argcount, { pushSTACK(NEXT(ptr)); } );
         }
         funcall(fun,2+argcount); # fun (= FORMAT bzw. handler) aufrufen
        }
        # Fehlermeldung beenden, vgl. end_error():
        dynamic_unbind(); # Keine Fehlermeldungs-Ausgabe mehr aktiv
        set_args_end_pointer(rest_args_pointer); # STACK aufräumen
        break_driver(NIL); # Break-Driver aufrufen (kehrt nicht zurück)
      }
      else
      { {var reg1 object arguments = listof(argcount); pushSTACK(arguments); }
        pushSTACK(S(error));
        pushSTACK(S(simple_error));
        funcall(S(coerce_to_condition),4); # (SYS::COERCE-TO-CONDITION ...)
        pushSTACK(value1); # condition retten
        pushSTACK(value1); funcall(L(clcs_signal),1); # (SIGNAL condition)
        dynamic_bind(S(prin_stream),unbound); # SYS::*PRIN-STREAM* an #<UNBOUND> binden
        pushSTACK(STACK_(0+DYNBIND_SIZE)); # condition
        funcall(L(invoke_debugger),1); # (INVOKE-DEBUGGER condition)
      }
    NOTREACHED
  }

LISPFUNN(defclcs,1)
# (SYSTEM::%DEFCLCS error-types)
# setzt die für ERROR-OF-TYPE benötigten Daten.
  { O(error_types) = popSTACK();
    value1 = NIL; mv_count=0;
  }

# Konvertiert einen Condition-Typ zur entsprechenden Simple-Condition.
# convert_simple_condition(type)
  local object convert_simple_condition (object type);
  local object convert_simple_condition(type)
    var reg2 object type;
    { # Vektor O(error_types) wie eine Aliste durchlaufen:
      var reg4 object v = O(error_types);
      var reg1 object* ptr = &TheSvector(v)->data[0];
      var reg3 uintL count;
      dotimesL(count,TheSvector(v)->length,
               { if (eq(type,Car(*ptr))) { return Cdr(*ptr); }
                 ptr++;
               });
      return type; # nicht gefunden -> Typ unverändert lassen
    }

LISPFUN(error_of_type,2,0,rest,nokey,0,NIL)
# (SYSTEM::ERROR-OF-TYPE type {keyword value}* errorstring {expr}*)
# Kehrt nicht zurück.
# (defun error-of-type (type &rest arguments)
#   ; Keyword-Argumente von den anderen Argumenten abspalten:
#   (let ((keyword-arguments '()))
#     (loop
#       (unless (and (consp arguments) (keywordp (car arguments))) (return))
#       (push (pop arguments) keyword-arguments)
#       (push (pop arguments) keyword-arguments)
#     )
#     (setq keyword-arguments (nreverse keyword-arguments))
#     (let ((errorstring (first arguments))
#           (args (rest arguments)))
#       ; Los geht's!
#       (if (or *error-handler* (not *use-clcs*))
#         (progn
#           (if *error-handler*
#             (apply *error-handler* nil errorstring args)
#             (progn
#               (terpri *error-output*)
#               (write-string "*** - " *error-output*)
#               (apply #'format *error-output* errorstring args)
#           ) )
#           (funcall *break-driver* nil)
#         )
#         (let ((condition
#                 (apply #'coerce-to-condition errorstring args
#                        'error (convert-simple-condition type) keyword-arguments
#              )) )
#           (signal condition)
#           (invoke-debugger condition)
#         )
# ) ) ) )
  { var reg6 uintC keyword_argcount = 0;
    rest_args_pointer skipSTACKop 1; # Pointer über die Argumente hinter type
    while (argcount>=2)
      { var reg3 object next_arg = Next(rest_args_pointer); # nächstes Argument
        if (!(symbolp(next_arg) && keywordp(next_arg))) break; # Keyword?
        rest_args_pointer skipSTACKop -2; argcount -= 2; keyword_argcount += 2;
      }
    # Nächstes Argument hoffentlich ein String.
    if (!sym_nullp(S(error_handler)) || sym_nullp(S(use_clcs)))
      { # Der Typ und die Keyword-Argumente werden ignoriert.
        begin_error(); # Fehlermeldung anfangen
        {var reg5 object fun;
         var reg4 object arg1;
         if (nullp(STACK_1))
           { fun = S(format); arg1 = STACK_0; } # (FORMAT *error-output* ...)
           else
           { fun = STACK_1; arg1 = NIL; } # (FUNCALL *error-handler* NIL ...)
         skipSTACK(3);
         # Errormeldung ausgeben:
         #   (FORMAT *ERROR-OUTPUT* errorstring {expr})
         # bzw. ({handler} nil errorstring {expr})
         pushSTACK(arg1);
         { var reg1 object* ptr = rest_args_pointer;
           var reg3 uintC count;
           dotimespC(count,1+argcount, { pushSTACK(NEXT(ptr)); } );
         }
         funcall(fun,2+argcount); # fun (= FORMAT bzw. handler) aufrufen
        }
        # Fehlermeldung beenden, vgl. end_error():
        dynamic_unbind(); # Keine Fehlermeldungs-Ausgabe mehr aktiv
        set_args_end_pointer(rest_args_pointer); # STACK aufräumen
        break_driver(NIL); # Break-Driver aufrufen (kehrt nicht zurück)
      }
      else
      { var reg5 object arguments = listof(argcount);
        # Stackaufbau: type, {keyword, value}*, errorstring.
        # Ein wenig im Stack umordnen:
        var reg4 object errorstring = STACK_0;
        pushSTACK(NIL); pushSTACK(NIL);
        { var reg1 object* ptr2 = args_end_pointer;
          var reg2 object* ptr1 = ptr2 STACKop 3;
          var reg3 uintC count;
          dotimesC(count,keyword_argcount, { BEFORE(ptr2) = BEFORE(ptr1); } );
          BEFORE(ptr2) = convert_simple_condition(BEFORE(ptr1));
          BEFORE(ptr2) = S(error);
          BEFORE(ptr2) = arguments;
          BEFORE(ptr2) = errorstring;
        }
        # Stackaufbau: errorstring, args, ERROR, type, {keyword, value}*.
        funcall(S(coerce_to_condition),4+keyword_argcount); # (SYS::COERCE-TO-CONDITION ...)
        pushSTACK(value1); # condition retten
        pushSTACK(value1); funcall(L(clcs_signal),1); # (SIGNAL condition)
        dynamic_bind(S(prin_stream),unbound); # SYS::*PRIN-STREAM* an #<UNBOUND> binden
        pushSTACK(STACK_(0+DYNBIND_SIZE)); # condition
        funcall(L(invoke_debugger),1); # (INVOKE-DEBUGGER condition)
      }
    NOTREACHED
  }

LISPFUNN(invoke_debugger,1)
# (INVOKE-DEBUGGER condition), CLtL2 S. 915
# Kehrt nicht zurück.
# (defun invoke-debugger (condition)
#   (when *debugger-hook*
#     (let ((debugger-hook *debugger-hook*)
#           (*debugger-hook* nil))
#       (funcall debugger-hook condition debugger-hook)
#   ) )
#   (funcall *break-driver* nil condition t)
# )
  { var reg1 object hook = Symbol_value(S(debugger_hook));
    if (!nullp(hook))
      { var reg2 object condition = STACK_0;
        dynamic_bind(S(debugger_hook),NIL); # *DEBUGGER-HOOK* an NIL binden
        pushSTACK(condition); pushSTACK(hook); funcall(hook,2); # Debugger-Hook aufrufen
        dynamic_unbind();
      }
    # *BREAK-DRIVER* kann hier als /= NIL angenommen werden.
    pushSTACK(NIL); pushSTACK(STACK_(0+1)); pushSTACK(T);
    funcall(Symbol_value(S(break_driver)),3); # Break-Driver aufrufen
    reset(); # kehrt wider Erwarten zurück -> zur nächsten Schleife zurück
    NOTREACHED
  }

# UP: Führt eine Break-Schleife wegen Tastaturunterbrechung aus.
# > STACK_0 : aufrufende Funktion
# verändert STACK, kann GC auslösen
  global void tast_break (void);
  global void tast_break()
    {
      #ifdef PENDING_INTERRUPTS
      interrupt_pending = FALSE; # Ctrl-C-Wartezeit ist gleich beendet
      begin_system_call();
      #ifdef HAVE_UALARM
      ualarm(0,0); # SIGALRM-Timer abbrechen
      #else
      #ifdef EMUNIX_OLD_8h # EMX-Bug umgehen
      alarm(1000);
      #endif
      alarm(0); # SIGALRM-Timer abbrechen
      #endif
      end_system_call();
      #endif
      # Simuliere begin_error(), 7 Elemente auf den STACK:
      pushSTACK(NIL); pushSTACK(NIL); pushSTACK(NIL);
      pushSTACK(NIL); pushSTACK(NIL); pushSTACK(NIL);
      pushSTACK(var_stream(S(debug_io),strmflags_wr_ch_B)); # Stream *DEBUG-IO*
      terpri(&STACK_0); # neue Zeile
      write_sstring(&STACK_0,O(error_string1)); # "*** - " ausgeben
      # String ausgeben, Aufrufernamen verbrauchen, STACK aufräumen:
      //: DEUTSCH "~: Tastatur-Interrupt"
      //: ENGLISH "~: User break"
      //: FRANCAIS "~ : Interruption clavier"
      set_args_end_pointer(write_errorstring(GETTEXT("~: User break")));
      break_driver(T); # Break-Driver aufrufen
    }

LISPFUN(clcs_signal,1,0,rest,nokey,0,NIL)
# (SIGNAL datum {arg}*), CLtL2 S. 888
# (defun signal (datum &rest arguments)
#   (let ((condition
#           (coerce-to-condition datum arguments 'signal
#                                'simple-condition ; CLtL2 p. 918 specifies this
#        )) )
#     (when (typep condition *break-on-signals*)
#       ; Enter the debugger prior to signalling the condition
#       (restart-case (invoke-debugger condition)
#         (continue ())
#     ) )
#     (invoke-handlers condition)
#     nil
# ) )
  { {var reg1 object arguments = listof(argcount); pushSTACK(arguments); }
    pushSTACK(S(clcs_signal));
    pushSTACK(S(simple_condition));
    funcall(S(coerce_to_condition),4); # (SYS::COERCE-TO-CONDITION ...)
    pushSTACK(value1); # condition retten
    pushSTACK(value1); pushSTACK(Symbol_value(S(break_on_signals)));
    funcall(S(safe_typep),2); # (SYS::SAFE-TYPEP condition *BREAK-ON-SIGNALS*)
    if (!nullp(value1))
      # Break-Driver aufrufen: (funcall *break-driver* t condition t)
      { # *BREAK-DRIVER* kann hier als /= NIL angenommen werden.
        pushSTACK(T); pushSTACK(STACK_(0+1)); pushSTACK(T);
        funcall(Symbol_value(S(break_driver)),3);
      }
   {var reg1 object condition = popSTACK(); # condition zurück
    invoke_handlers(condition); # Handler aufrufen
    value1 = NIL; mv_count=1; # Wert NIL
  }}

# Fehlermeldung, wenn ein Objekt keine Liste ist.
# fehler_list(obj);
# > arg: Nicht-Liste
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_list, (object obj));
  global void fehler_list(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(list)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine Liste."
      //: ENGLISH "~: ~ is not a list"
      //: FRANCAIS "~ : ~ n'est pas une liste."
      fehler(type_error, GETTEXT("~: ~ is not a list"));
    }

# Fehlermeldung, wenn ein Objekt kein Symbol ist.
# fehler_kein_symbol(caller,obj);
# > caller: Aufrufer (ein Symbol)
# > obj: Nicht-Symbol
  nonreturning_function(global, fehler_kein_symbol, (object caller, object obj));
  global void fehler_kein_symbol(caller,obj)
    var reg2 object caller;
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(symbol)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj);
      pushSTACK(caller);
      //: DEUTSCH "~: ~ ist kein Symbol."
      //: ENGLISH "~: ~ is not a symbol"
      //: FRANCAIS "~ : ~ n'est pas un symbole."
      fehler(type_error, GETTEXT("~: ~ is not a symbol"));
    }

# Fehlermeldung, wenn ein Objekt kein Symbol ist.
# fehler_symbol(obj);
# > subr_self: Aufrufer (ein SUBR oder FSUBR)
# > obj: Nicht-Symbol
  nonreturning_function(global, fehler_symbol, (object obj));
  global void fehler_symbol(obj)
    var reg2 object obj;
    { var reg1 object aufrufer = subr_self;
      aufrufer = (subrp(aufrufer) ? TheSubr(aufrufer)->name : TheFsubr(aufrufer)->name);
      fehler_kein_symbol(aufrufer,obj);
    }

# Fehlermeldung, wenn ein Objekt kein Simple-Vector ist.
# fehler_kein_svector(caller,obj);
# > caller: Aufrufer (ein Symbol)
# > obj: Nicht-Svector
  nonreturning_function(global, fehler_kein_svector, (object caller, object obj));
  global void fehler_kein_svector(caller,obj)
    var reg2 object caller;
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(simple_vector)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj);
      pushSTACK(caller);
      //: DEUTSCH "~: ~ ist kein Simple-Vector."
      //: ENGLISH "~: ~ is not a simple-vector"
      //: FRANCAIS "~: ~ n'est pas de type SIMPLE-VECTOR."
      fehler(type_error, GETTEXT("~: ~ is not a simple-vector"));
    }

# Fehlermeldung, wenn ein Objekt kein Vektor ist.
# fehler_vector(obj);
# > subr_self: Aufrufer (ein SUBR)
# > obj: Nicht-Vektor
  nonreturning_function(global, fehler_vector, (object obj));
  global void fehler_vector(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(vector)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist kein Vektor."
      //: ENGLISH "~: ~ is not a vector"
      //: FRANCAIS "~: ~ n'est pas un vecteur."
      fehler(type_error, GETTEXT("~: ~ is not a vector"));
    }

# Fehlermeldung, falls ein Argument kein Character ist:
# fehler_char(obj);
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_char, (object obj));
  global void fehler_char(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(character)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ ist kein Character."
      //: ENGLISH "~: argument ~ is not a character"
      //: FRANCAIS "~: L'argument ~ n'est pas un caractère."
      fehler(type_error, GETTEXT("~: argument ~ is not a character"));
    }

# Fehler, wenn Argument kein String-Char ist.
# fehler_string_char(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_string_char, (object obj));
  global void fehler_string_char(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(string_char)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist kein String-Char."
      //: ENGLISH "~: ~ is not a string-char"
      //: FRANCAIS "~ : ~ n'est pas de type STRING-CHAR."
      fehler(type_error, GETTEXT("~: ~ is not a string-char"));
    }

# Fehlermeldung, falls ein Argument kein String ist:
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_string, (object obj));
  global void fehler_string(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(string)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ ist kein String."
      //: ENGLISH "~: argument ~ is not a string"
      //: FRANCAIS "~: L'argument ~ n'est pas une chaîne."
      fehler(type_error, GETTEXT("~: argument ~ is not a string"));
    }

# Fehlermeldung, falls ein Argument kein Simple-String ist:
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_sstring, (object obj));
  global void fehler_sstring(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(simple_string)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ ist kein Simple-String."
      //: ENGLISH "~: argument ~ is not a simple string"
      //: FRANCAIS "~: L'argument ~ n'est pas de type SIMPLE-STRING."
      fehler(type_error, GETTEXT("~: argument ~ is not a simple string"));
    }

# Fehlermeldung, wenn ein Argument kein Stream ist:
# fehler_stream(obj);
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_stream, (object obj));
  global void fehler_stream(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(stream)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument muß ein Stream sein, nicht ~"
      //: ENGLISH "~: argument ~ should be a stream"
      //: FRANCAIS "~ : L'argument doit être de type STREAM et non pas ~."
      fehler(type_error, GETTEXT("~: argument ~ should be a stream"));
    }

# Fehlermeldung, wenn ein Argument kein Stream vom geforderten Stream-Typ ist:
# fehler_streamtype(obj,type);
# > obj: Das fehlerhafte Argument
# > type: geforderten Stream-Typ
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_streamtype, (object obj, object type));
  global void fehler_streamtype(obj,type)
    var reg1 object obj;
    var reg2 object type;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(type); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(type); pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: Argument ~ sollte ein Stream vom Typ ~ sein."
      //: ENGLISH "~: argument ~ should be a stream of type ~"
      //: FRANCAIS "~ : L'argument ~ devrait être de type ~."
      fehler(type_error, GETTEXT("~: argument ~ should be a stream of type ~"));
    }

#ifdef HAVE_FFI

# Fehler, wenn Argument kein Integer vom Typ `uint8' ist.
# fehler_uint8(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_uint8, (object obj));
  global void fehler_uint8(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_uint8)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 8-bit-Zahl."
      //: ENGLISH "~: ~ is not an 8-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 8 bits."
      fehler(type_error, GETTEXT("~: ~ is not an 8-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `sint8' ist.
# fehler_sint8(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_sint8, (object obj));
  global void fehler_sint8(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_sint8)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 8-bit-Zahl."
      //: ENGLISH "~: ~ is not an 8-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 8 bits."
      fehler(type_error, GETTEXT("~: ~ is not an 8-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `uint16' ist.
# fehler_uint16(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_uint16, (object obj));
  global void fehler_uint16(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_uint16)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 16-bit-Zahl."
      //: ENGLISH "~: ~ is not a 16-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 16 bits."
      fehler(type_error, GETTEXT("~: ~ is not a 16-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `sint16' ist.
# fehler_sint16(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_sint16, (object obj));
  global void fehler_sint16(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_sint16)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 16-bit-Zahl."
      //: ENGLISH "~: ~ is not a 16-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 16 bits."
      fehler(type_error, GETTEXT("~: ~ is not a 16-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `uint32' ist.
# fehler_uint32(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_uint32, (object obj));
  global void fehler_uint32(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_uint32)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 32-bit-Zahl."
      //: ENGLISH "~: ~ is not an 32-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 32 bits."
      fehler(type_error, GETTEXT("~: ~ is not an 32-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `sint32' ist.
# fehler_sint32(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_sint32, (object obj));
  global void fehler_sint32(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_sint32)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 32-bit-Zahl."
      //: ENGLISH "~: ~ is not an 32-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 32 bits."
      fehler(type_error, GETTEXT("~: ~ is not an 32-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `uint64' ist.
# fehler_uint64(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_uint64, (object obj));
  global void fehler_uint64(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_uint64)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 64-bit-Zahl."
      //: ENGLISH "~: ~ is not an 64-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 64 bits."
      fehler(type_error, GETTEXT("~: ~ is not an 64-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `sint64' ist.
# fehler_sint64(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_sint64, (object obj));
  global void fehler_sint64(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(O(type_sint64)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine 64-bit-Zahl."
      //: ENGLISH "~: ~ is not an 64-bit number"
      //: FRANCAIS "~ : ~ n'est pas un nombre à 64 bits."
      fehler(type_error, GETTEXT("~: ~ is not an 64-bit number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `uint' ist.
# fehler_uint(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_uint, (object obj));
  global void fehler_uint(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      #if (int_bitsize==16)
      pushSTACK(O(type_uint16)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #else # (int_bitsize==32)
      pushSTACK(O(type_uint32)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #endif
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine `unsigned int'-Zahl."
      //: ENGLISH "~: ~ is not an `unsigned int' number"
      //: FRANCAIS "~ : ~ n'est pas un nombre «unsigned int»."
      fehler(type_error, GETTEXT("~: ~ is not an `unsigned int' number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `sint' ist.
# fehler_sint(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_sint, (object obj));
  global void fehler_sint(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      #if (int_bitsize==16)
      pushSTACK(O(type_sint16)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #else # (int_bitsize==32)
      pushSTACK(O(type_sint32)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #endif
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine `int'-Zahl."
      //: ENGLISH "~: ~ is not an `int' number"
      //: FRANCAIS "~ : ~ n'est pas un nombre «int»."
      fehler(type_error, GETTEXT("~: ~ is not an `int' number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `ulong' ist.
# fehler_ulong(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_ulong, (object obj));
  global void fehler_ulong(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      #if (long_bitsize==32)
      pushSTACK(O(type_uint32)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #else # (long_bitsize==64)
      pushSTACK(O(type_uint64)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #endif
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine `unsigned long'-Zahl."
      //: ENGLISH "~: ~ is not a `unsigned long' number"
      //: FRANCAIS "~ : ~ n'est pas un nombre «unsigned long»."
      fehler(type_error, GETTEXT("~: ~ is not a `unsigned long' number"));
    }

# Fehler, wenn Argument kein Integer vom Typ `slong' ist.
# fehler_slong(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_slong, (object obj));
  global void fehler_slong(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      #if (long_bitsize==32)
      pushSTACK(O(type_sint32)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #else # (long_bitsize==64)
      pushSTACK(O(type_sint64)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      #endif
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist keine `long'-Zahl."
      //: ENGLISH "~: ~ is not a `long' number"
      //: FRANCAIS "~ : ~ n'est pas un nombre «long»."
      fehler(type_error, GETTEXT("~: ~ is not a `long' number"));
    }

# Fehler, wenn Argument kein Single-Float ist.
# fehler_ffloat(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_ffloat, (object obj));
  global void fehler_ffloat(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(single_float)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist kein Single-Float."
      //: ENGLISH "~: ~ is not a single-float"
      //: FRANCAIS "~ : ~ n'est pas de type SINGLE-FLOAT."
      fehler(type_error, GETTEXT("~: ~ is not a single-float"));
    }

# Fehler, wenn Argument kein Double-Float ist.
# fehler_dfloat(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(global, fehler_dfloat, (object obj));
  global void fehler_dfloat(obj)
    var reg1 object obj;
    { pushSTACK(obj); # Wert für Slot DATUM von TYPE-ERROR
      pushSTACK(S(double_float)); # Wert für Slot EXPECTED-TYPE von TYPE-ERROR
      pushSTACK(obj); pushSTACK(TheSubr(subr_self)->name);
      //: DEUTSCH "~: ~ ist kein Double-Float."
      //: ENGLISH "~: ~ is not a double-float"
      //: FRANCAIS "~ : ~ n'est pas de type DOUBLE-FLOAT."
      fehler(type_error, GETTEXT("~: ~ is not a double-float"));
    }

#endif

