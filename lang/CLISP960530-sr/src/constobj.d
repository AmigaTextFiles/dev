# Liste aller dem C-Programm bekannten Objekte ("Programmkonstanten")
# Bruno Haible 13.6.1995

# Die Symbole sind bereits speziell abgehandelt.
# Es wird eine Tabelle aller sonstigen dem C-Programm bekannten Objekte
# gehalten.

# Der Macro LISPOBJ deklariert ein sonstiges LISP-Objekt.
# LISPOBJ(name,initstring)
# > name: Objekt ist als object_tab.name oder als O(name) ansprechbar
# > initstring: Initialisierungsstring in LISP-Syntax

# Expander für die Deklaration der Objekt-Tabelle:
  #define LISPOBJ_A(name,initstring)  \
    object name;

# Expander für die Initialisierung der Objekt-Tabelle:
  #define LISPOBJ_B(name,initstring)  \
    NIL,
  #define LISPOBJ_C(name,initstring)  \
    initstring,

# Welcher Expander benutzt wird, muß vom Hauptfile aus eingestellt werden.

# Der Macro LISPOBJ_L deklariert ein von language abhängiges LISP-Objekt.
# LISPOBJ_L(name,deutsch_initstring,english_initstring,francais_initstring)
# > name: Objekt ist als OL(name) ansprechbar
# > deutsch_initstring: Initialisierungsstring für DEUTSCH
# > english_initstring: Initialisierungsstring für ENGLISH
# > francais_initstring: Initialisierungsstring für FRANCAIS
  #ifdef ENABLE_NLS
    #ifdef NLS_COMPILE_TIME_TRANSLATION
      #define LISPOBJ_L(english,name) LISPOBJ(name,"#.(SYS::GETTEXT '" english ")")
    #else
      #define LISPOBJ_L(english,name) LISPOBJ(name,english)
    #endif
    #define LISPOBJ__L(english,name) LISPOBJ_L(english,name)
    #define LISPOBJ__LS(english,name) LISPOBJ__L("\"" english "\"",name)
    #define LISPOBJ_LS(english,name) LISPOBJ__LS(english,name)
  #else
    #ifndef USE_PSEUDO_STRINGS
      #ifdef LANGUAGE_STATIC
        #if DEUTSCH
          #define LISPOBJ_L(english,name) LISPOBJ(name, DEUTSCH_MSG)
          #define LISPOBJ_LS(english,name) LISPOBJ(name, "\"" DEUTSCH_MSG "\"")
        #endif
        #if ENGLISH
          #define LISPOBJ_L(english,name) LISPOBJ(name, ENGLISH_MSG)
          #define LISPOBJ_LS(english,name) LISPOBJ(name, "\"" ENGLISH_MSG "\"")
        #endif
        #if FRANCAIS
          #define LISPOBJ_L(english,name) LISPOBJ(name, FRANCAIS_MSG)
          #define LISPOBJ_LS(english,name) LISPOBJ(name, "\"" FRANCAIS_MSG "\"")
        #endif
      #else
        #define LISPOBJ_L(english,name) \
          LISPOBJ(name, ENGLISH_MSG) LISPOBJ(name##_l1,DEUTSCH_MSG) LISPOBJ(name##_l2,FRANCAIS_MSG)
        #define LISPOBJ_LS(english,name) \
          LISPOBJ(name,"\"" ENGLISH_MSG "\"") LISPOBJ(name##_l1,"\"" DEUTSCH_MSG "\"") LISPOBJ(name##_l2,"\"" FRANCAIS_MSG "\"")
      #endif
    #else
      #define LISPOBJ_L(english,name) LISPOBJ(name, english)
      #define LISPOBJ_LS(english,name) LISPOBJ(name, "\"" english "\"")
    #endif
  #endif

# zu EVAL.D:
  # Die 5 aktuellen Environments:
  LISPOBJ(akt_var_env,"NIL")    # --+
  LISPOBJ(akt_fun_env,"NIL")    #   | Reihenfolge
  LISPOBJ(akt_block_env,"NIL")  #   | mit LISPBIBL.D
  LISPOBJ(akt_go_env,"NIL")     #   | abgestimmt!
  LISPOBJ(akt_decl_env,"NIL")   # --+
# zu SPVW.D:
  # Liste aller Finalisierer:
  LISPOBJ(all_finalizers,"NIL")
  # Während der GC: die Liste der nach der GC zu bearbeitenden Finalisierer:
  LISPOBJ(pending_finalizers,"NIL")
# zu CHARSTRG.D:
  # Bei Änderung der Character-Namen außer CONSTOBJ.D auch
  # CHARSTRG.D, FORMAT.LSP, IMPNOTES.TXT anpassen!
  #ifdef AMIGA_CHARNAMES
    LISPOBJ(charname_0,"\"Null\"")
    LISPOBJ(charname_1,"\"Code1\"")
    LISPOBJ(charname_2,"\"Code2\"")
    LISPOBJ(charname_3,"\"Code3\"")
    LISPOBJ(charname_4,"\"Code4\"")
    LISPOBJ(charname_5,"\"Code5\"")
    LISPOBJ(charname_6,"\"Code6\"")
    LISPOBJ(charname_7,"\"Bell\"")
    LISPOBJ(charname_8,"\"Backspace\"")
    LISPOBJ(charname_9,"\"Tab\"")
    LISPOBJ(charname_10,"\"Newline\"")
    LISPOBJ(charname_11,"\"Vt\"")
    LISPOBJ(charname_12,"\"Page\"")
    LISPOBJ(charname_13,"\"Return\"")
    LISPOBJ(charname_14,"\"So\"")
    LISPOBJ(charname_15,"\"Si\"")
    LISPOBJ(charname_16,"\"Code16\"")
    LISPOBJ(charname_17,"\"Code17\"")
    LISPOBJ(charname_18,"\"Code18\"")
    LISPOBJ(charname_19,"\"Code19\"")
    LISPOBJ(charname_20,"\"Code20\"")
    LISPOBJ(charname_21,"\"Code21\"")
    LISPOBJ(charname_22,"\"Code22\"")
    LISPOBJ(charname_23,"\"Code23\"")
    LISPOBJ(charname_24,"\"Code24\"")
    LISPOBJ(charname_25,"\"Code25\"")
    LISPOBJ(charname_26,"\"Code26\"")
    LISPOBJ(charname_27,"\"Escape\"")
    LISPOBJ(charname_28,"\"Code28\"")
    LISPOBJ(charname_29,"\"Code29\"")
    LISPOBJ(charname_30,"\"Code30\"")
    LISPOBJ(charname_31,"\"Code31\"")
    LISPOBJ(charname_32,"\"Space\"")
    LISPOBJ(charname_127,"\"Delete\"")
    LISPOBJ(charname_7bis,"\"Bel\"")
    LISPOBJ(charname_8bis,"\"Bs\"")
    LISPOBJ(charname_9bis,"\"Ht\"")
    LISPOBJ(charname_10bis,"\"Linefeed\"")
    LISPOBJ(charname_10tris,"\"Lf\"")
    LISPOBJ(charname_12bis,"\"Ff\"")
    LISPOBJ(charname_13bis,"\"Cr\"")
    LISPOBJ(charname_27bis,"\"Esc\"")
    LISPOBJ(charname_127bis,"\"Del\"")
    LISPOBJ(charname_127tris,"\"Rubout\"")
    LISPOBJ(charname_155,"\"Csi\"")
    # Namen von Characters mit Hyper-Bit:
    LISPOBJ(charname_hyper_18,"\"Down\"") # #\Hyper-Code18
    LISPOBJ(charname_hyper_20,"\"Left\"") # #\Hyper-Code20
    LISPOBJ(charname_hyper_22,"\"Right\"") # #\Hyper-Code22
    LISPOBJ(charname_hyper_24,"\"Up\"") # #\Hyper-Code24
    LISPOBJ(charname_hyper_28,"\"Help\"") # #\Hyper-Code28
    LISPOBJ(charname_hyper_a,"\"F1\"") # #\Hyper-A
    LISPOBJ(charname_hyper_b,"\"F2\"") # #\Hyper-B
    LISPOBJ(charname_hyper_c,"\"F3\"") # #\Hyper-C
    LISPOBJ(charname_hyper_d,"\"F4\"") # #\Hyper-D
    LISPOBJ(charname_hyper_e,"\"F5\"") # #\Hyper-E
    LISPOBJ(charname_hyper_f,"\"F6\"") # #\Hyper-F
    LISPOBJ(charname_hyper_g,"\"F7\"") # #\Hyper-G
    LISPOBJ(charname_hyper_h,"\"F8\"") # #\Hyper-H
    LISPOBJ(charname_hyper_i,"\"F9\"") # #\Hyper-I
    LISPOBJ(charname_hyper_j,"\"F10\"") # #\Hyper-J
  #endif
  #ifdef MSDOS_CHARNAMES
    # Namen von Characters mit Codes 0,7,...,13,26,27,32,8,10:
    LISPOBJ(charname_0,"\"Null\"")
    LISPOBJ(charname_7,"\"Bell\"")
    LISPOBJ(charname_8,"\"Backspace\"")
    LISPOBJ(charname_9,"\"Tab\"")
    LISPOBJ(charname_10,"\"Newline\"")
    LISPOBJ(charname_11,"\"Code11\"")
    LISPOBJ(charname_12,"\"Page\"")
    LISPOBJ(charname_13,"\"Return\"")
    LISPOBJ(charname_26,"\"Code26\"")
    LISPOBJ(charname_27,"\"Escape\"")
    LISPOBJ(charname_32,"\"Space\"")
    LISPOBJ(charname_8bis,"\"Rubout\"")
    LISPOBJ(charname_10bis,"\"Linefeed\"")
    # Namen von Characters mit Hyper-Bit:
    LISPOBJ(charname_hyper_13,"\"Enter\"") # #\Hyper-Return
    LISPOBJ(charname_hyper_16,"\"Insert\"") # #\Hyper-Code16
    LISPOBJ(charname_hyper_17,"\"End\"") # #\Hyper-Code17
    LISPOBJ(charname_hyper_18,"\"Down\"") # #\Hyper-Code18
    LISPOBJ(charname_hyper_19,"\"PgDn\"") # #\Hyper-Code19
    LISPOBJ(charname_hyper_20,"\"Left\"") # #\Hyper-Code20
    LISPOBJ(charname_hyper_22,"\"Right\"") # #\Hyper-Code22
    LISPOBJ(charname_hyper_23,"\"Home\"") # #\Hyper-Code23
    LISPOBJ(charname_hyper_24,"\"Up\"") # #\Hyper-Code24
    LISPOBJ(charname_hyper_25,"\"PgUp\"") # #\Hyper-Code25
    LISPOBJ(charname_hyper_29,"\"Prtscr\"") # #\Hyper-Code29
    LISPOBJ(charname_hyper_127,"\"Delete\"") # #\Hyper-Code127
    LISPOBJ(charname_hyper_a,"\"F1\"") # #\Hyper-A
    LISPOBJ(charname_hyper_b,"\"F2\"") # #\Hyper-B
    LISPOBJ(charname_hyper_c,"\"F3\"") # #\Hyper-C
    LISPOBJ(charname_hyper_d,"\"F4\"") # #\Hyper-D
    LISPOBJ(charname_hyper_e,"\"F5\"") # #\Hyper-E
    LISPOBJ(charname_hyper_f,"\"F6\"") # #\Hyper-F
    LISPOBJ(charname_hyper_g,"\"F7\"") # #\Hyper-G
    LISPOBJ(charname_hyper_h,"\"F8\"") # #\Hyper-H
    LISPOBJ(charname_hyper_i,"\"F9\"") # #\Hyper-I
    LISPOBJ(charname_hyper_j,"\"F10\"") # #\Hyper-J
    LISPOBJ(charname_hyper_k,"\"F11\"") # #\Hyper-K
    LISPOBJ(charname_hyper_l,"\"F12\"") # #\Hyper-L
  #endif
  #ifdef UNIX_CHARNAMES
    LISPOBJ(charname_0bis,"\"Null\"")
    LISPOBJ(charname_7bis,"\"Bell\"")
    LISPOBJ(charname_8bis,"\"Backspace\"")
    LISPOBJ(charname_9bis,"\"Tab\"")
    LISPOBJ(charname_10bis,"\"Newline\"")
    LISPOBJ(charname_10tris,"\"Linefeed\"")
    LISPOBJ(charname_12bis,"\"Page\"")
    LISPOBJ(charname_13bis,"\"Return\"")
    LISPOBJ(charname_27bis,"\"Escape\"")
    LISPOBJ(charname_32bis,"\"Space\"")
    LISPOBJ(charname_127bis,"\"Rubout\"")
    LISPOBJ(charname_127tris,"\"Delete\"")
    LISPOBJ(charname_0,"\"Nul\"")
    LISPOBJ(charname_1,"\"Soh\"")
    LISPOBJ(charname_2,"\"Stx\"")
    LISPOBJ(charname_3,"\"Etx\"")
    LISPOBJ(charname_4,"\"Eot\"")
    LISPOBJ(charname_5,"\"Enq\"")
    LISPOBJ(charname_6,"\"Ack\"")
    LISPOBJ(charname_7,"\"Bel\"")
    LISPOBJ(charname_8,"\"Bs\"")
    LISPOBJ(charname_9,"\"Ht\"")
    LISPOBJ(charname_10,"\"Nl\"")
    LISPOBJ(charname_11,"\"Vt\"")
    LISPOBJ(charname_12,"\"Np\"")
    LISPOBJ(charname_13,"\"Cr\"")
    LISPOBJ(charname_14,"\"So\"")
    LISPOBJ(charname_15,"\"Si\"")
    LISPOBJ(charname_16,"\"Dle\"")
    LISPOBJ(charname_17,"\"Dc1\"")
    LISPOBJ(charname_18,"\"Dc2\"")
    LISPOBJ(charname_19,"\"Dc3\"")
    LISPOBJ(charname_20,"\"Dc4\"")
    LISPOBJ(charname_21,"\"Nak\"")
    LISPOBJ(charname_22,"\"Syn\"")
    LISPOBJ(charname_23,"\"Etb\"")
    LISPOBJ(charname_24,"\"Can\"")
    LISPOBJ(charname_25,"\"Em\"")
    LISPOBJ(charname_26,"\"Sub\"")
    LISPOBJ(charname_27,"\"Esc\"")
    LISPOBJ(charname_28,"\"Fs\"")
    LISPOBJ(charname_29,"\"Gs\"")
    LISPOBJ(charname_30,"\"Rs\"")
    LISPOBJ(charname_31,"\"Us\"")
    LISPOBJ(charname_32,"\"Sp\"")
    LISPOBJ(charname_127,"\"Del\"")
    # Namen von Characters mit Hyper-Bit:
    LISPOBJ(charname_hyper_16,"\"Insert\"") # #\Hyper-Code16
    LISPOBJ(charname_hyper_17,"\"End\"") # #\Hyper-Code17
    LISPOBJ(charname_hyper_18,"\"Down\"") # #\Hyper-Code18
    LISPOBJ(charname_hyper_19,"\"PgDn\"") # #\Hyper-Code19
    LISPOBJ(charname_hyper_20,"\"Left\"") # #\Hyper-Code20
    LISPOBJ(charname_hyper_21,"\"Center\"") # #\Hyper-Code21
    LISPOBJ(charname_hyper_22,"\"Right\"") # #\Hyper-Code22
    LISPOBJ(charname_hyper_23,"\"Home\"") # #\Hyper-Code23
    LISPOBJ(charname_hyper_24,"\"Up\"") # #\Hyper-Code24
    LISPOBJ(charname_hyper_25,"\"PgUp\"") # #\Hyper-Code25
    LISPOBJ(charname_hyper_a,"\"F1\"") # #\Hyper-A
    LISPOBJ(charname_hyper_b,"\"F2\"") # #\Hyper-B
    LISPOBJ(charname_hyper_c,"\"F3\"") # #\Hyper-C
    LISPOBJ(charname_hyper_d,"\"F4\"") # #\Hyper-D
    LISPOBJ(charname_hyper_e,"\"F5\"") # #\Hyper-E
    LISPOBJ(charname_hyper_f,"\"F6\"") # #\Hyper-F
    LISPOBJ(charname_hyper_g,"\"F7\"") # #\Hyper-G
    LISPOBJ(charname_hyper_h,"\"F8\"") # #\Hyper-H
    LISPOBJ(charname_hyper_i,"\"F9\"") # #\Hyper-I
    LISPOBJ(charname_hyper_j,"\"F10\"") # #\Hyper-J
    LISPOBJ(charname_hyper_k,"\"F11\"") # #\Hyper-K
    LISPOBJ(charname_hyper_l,"\"F12\"") # #\Hyper-L
  #endif
  # Tabelle der Bitnamen:
  LISPOBJ(bitnamekw_0,":CONTROL")
  LISPOBJ(bitnamekw_1,":META")
  LISPOBJ(bitnamekw_2,":SUPER")
  LISPOBJ(bitnamekw_3,":HYPER")
# zu HASHTABL.D:
 #ifdef GENERATIONAL_GC
  LISPOBJ(gc_count,"0")
 #endif
# zu SEQUENCE.D:
  # interne Liste aller definierten Sequence-Typen:
  LISPOBJ(seq_types,"NIL")
  # Keywordpaare für test_start_end (Paare nicht trennen!):
  LISPOBJ(kwpair_start,":START")
  LISPOBJ(kwpair_end,":END")
  LISPOBJ(kwpair_start1,":START1")
  LISPOBJ(kwpair_end1,":END1")
  LISPOBJ(kwpair_start2,":START2")
  LISPOBJ(kwpair_end2,":END2")
# zu PREDTYPE.D:
  # Erkennungszeichen für Klassen, wird von CLOS::%DEFCLOS gefüllt
  LISPOBJ(class_structure_types,"(CLOS::CLASS)")
  # einige Built-In-Klassen, werden von CLOS::%DEFCLOS gefüllt
  LISPOBJ(class_array,"ARRAY")             # ---+
  LISPOBJ(class_bit_vector,"BIT-VECTOR")   #    |   Reihenfolge
  LISPOBJ(class_character,"CHARACTER")     #    |   mit clos.lsp
  LISPOBJ(class_complex,"COMPLEX")         #    |   abgestimmt!
  LISPOBJ(class_cons,"CONS")
  LISPOBJ(class_float,"FLOAT")
  LISPOBJ(class_function,"FUNCTION")
  LISPOBJ(class_hash_table,"HASH-TABLE")
  LISPOBJ(class_integer,"INTEGER")
  LISPOBJ(class_null,"NULL")
  LISPOBJ(class_package,"PACKAGE")
  LISPOBJ(class_pathname,"PATHNAME")
  #ifdef LOGICAL_PATHNAMES
  LISPOBJ(class_logical_pathname,"LOGICAL-PATHNAME")
  #endif
  LISPOBJ(class_random_state,"RANDOM-STATE")
  LISPOBJ(class_ratio,"RATIO")
  LISPOBJ(class_readtable,"READTABLE")
  LISPOBJ(class_standard_generic_function,"CLOS::STANDARD-GENERIC-FUNCTION")
  LISPOBJ(class_stream,"STREAM")
  LISPOBJ(class_file_stream,"FILE-STREAM")
  LISPOBJ(class_synonym_stream,"SYNONYM-STREAM")
  LISPOBJ(class_broadcast_stream,"BROADCAST-STREAM")
  LISPOBJ(class_concatenated_stream,"CONCATENATED-STREAM")
  LISPOBJ(class_two_way_stream,"TWO-WAY-STREAM")
  LISPOBJ(class_echo_stream,"ECHO-STREAM")
  LISPOBJ(class_string_stream,"STRING-STREAM")
  LISPOBJ(class_string,"STRING")
  LISPOBJ(class_symbol,"SYMBOL")           #    |
  LISPOBJ(class_t,"T")                     #    |
  LISPOBJ(class_vector,"VECTOR")           # ---+
# zu PACKAGE.D:
  # interne Liste aller Packages:
  LISPOBJ(all_packages,".")
  # die Keyword-Package:
  LISPOBJ(keyword_package,".")
  # die Default-Package für *PACKAGE*:
  LISPOBJ(default_package,".")
  # verschiedene Strings und Listen für interaktive Konfliktbehebung:
  //: DEUTSCH "Wählen Sie bitte aus:"
  //: ENGLISH "Please choose:"
  //: FRANCAIS "Choisissez :"
  LISPOBJ_LS("Please choose:",query_string1)
  LISPOBJ(query_string2,"\"          \"")
  LISPOBJ(query_string3,"\"  --  \"")
  //: DEUTSCH "Wählen Sie bitte eines von "
  //: ENGLISH "Please choose one of "
  //: FRANCAIS "Choisissez parmi "
  LISPOBJ_LS("Please choose one of ",query_string4)
  LISPOBJ(query_string5,"\", \"")
  //: DEUTSCH " aus."
  //: ENGLISH " ."
  //: FRANCAIS ", s.v.p."
  LISPOBJ_LS(" .",query_string6)
  LISPOBJ(query_string7,"\"> \"")
  //: DEUTSCH "Symbol "
  //: ENGLISH "symbol "
  //: FRANCAIS "Le symbole "
  LISPOBJ_LS("symbol ",unint_string1)
  //: DEUTSCH " aus #<PACKAGE "
  //: ENGLISH " from #<PACKAGE "
  //: FRANCAIS " du paquetage #<PACKAGE "
  LISPOBJ_LS(" from #<PACKAGE ",unint_string2)
  //: DEUTSCH "> wird als Shadowing deklariert"
  //: ENGLISH "> will become a shadowing symbol"
  //: FRANCAIS "> sera déclaré «shadowing»."
  LISPOBJ_LS("> will become a shadowing symbol",unint_string3)
  //: DEUTSCH "Sie dürfen auswählen, welches der gleichnamigen Symbole Vorrang bekommt, um den Konflikt aufzulösen."
  //: ENGLISH "You may choose the symbol in favour of which to resolve the conflict."
  //: FRANCAIS "Vous pouvez choisir, parmi les symboles homonymes, auquel donner priorité pour éviter le conflit de noms."
  LISPOBJ_LS("You may choose the symbol in favour of which to resolve the conflict.",unint_string4)
  //: DEUTSCH "Durch Uninternieren von ~S aus ~S entsteht ein Namenskonflikt."
  //: ENGLISH "uninterning ~S from ~S uncovers a name conflict."
  //: FRANCAIS "Un conflit de noms apparaît dès que ~S est retiré de ~S."
  LISPOBJ_LS("uninterning ~S from ~S uncovers a name conflict.",unint_string5)
  //: DEUTSCH "Sie dürfen über das weitere Vorgehen entscheiden."
  //: ENGLISH "You may choose how to proceed."
  //: FRANCAIS "Vous pouvez décider de la démarche à suivre."
  LISPOBJ_LS("You may choose how to proceed.",import_string1)
  //: DEUTSCH "Durch Importieren von ~S in ~S entsteht ein Namenskonflikt mit ~S."
  //: ENGLISH "importing ~S into ~S produces a name conflict with ~S."
  //: FRANCAIS "Un conflit de noms apparaît par l'importation de ~S dans ~S avec ~S."
  LISPOBJ_LS("importing ~S into ~S produces a name conflict with ~S.",import_string2)
  //: DEUTSCH "Durch Importieren von ~S in ~S entsteht ein Namenskonflikt mit ~S und weiteren Symbolen."
  //: ENGLISH "importing ~S into ~S produces a name conflict with ~S and other symbols."
  //: FRANCAIS "Un conflit de noms apparaît par l'importation de ~S dans ~S avec ~S et d'autres symboles."
  LISPOBJ_LS("importing ~S into ~S produces a name conflict with ~S and other symbols.",import_string3)
  //: DEUTSCH "((\"I\" \"Importieren und dabei das eine andere Symbol uninternieren\" T) (\"N\" \"Nicht importieren, alles beim alten lassen\" NIL))"
  //: ENGLISH "((\"I\" \"import it and unintern the other symbol\" T) (\"N\" \"do not import it, leave undone\" NIL))"
  //: FRANCAIS "((\"I\" \"Importer en retirant l'autre symbole\" T) (\"N\" \"Ne pas importer, ne rien faire\" NIL))"
  LISPOBJ_L("((\"I\" \"import it and unintern the other symbol\" T) (\"N\" \"do not import it, leave undone\" NIL))",import_list1)
  //: DEUTSCH "((\"I\" \"Importieren, dabei das eine andere Symbol uninternieren und die anderen Symbole verdecken\" T) (\"N\" \"Nicht importieren, alles beim alten lassen\" NIL))"  
  //: ENGLISH "((\"I\" \"import it, unintern one other symbol and shadow the other symbols\" T) (\"N\" \"do not import it, leave undone\" NIL))"
  //: FRANCAIS "((\"I\" \"Importer en retirant l'autre symbole et en cachant les autres\" T) (\"N\" \"Ne pas importer, ne rien faire\" NIL))"
  LISPOBJ_L("((\"I\" \"import it, unintern one other symbol and shadow the other symbols\" T) (\"N\" \"do not import it, leave undone\" NIL))",import_list2)
  //: DEUTSCH "((\"I\" \"Importieren und das andere Symbol shadowen\" T) (\"N\" \"Nichts tun\" NIL))"
  //: ENGLISH "((\"I\" \"import it and shadow the other symbol\" T) (\"N\" \"do nothing\" NIL))"
  //: FRANCAIS "((\"I\" \"Importer et cacher l'autre symbole\" T) (\"N\" \"Ne rien faire\"NIL))"
  LISPOBJ_L("((\"I\" \"import it and shadow the other symbol\" T) (\"N\" \"do nothing\" NIL))",import_list3)
  //: DEUTSCH "Sie dürfen über das weitere Vorgehen entscheiden."
  //: ENGLISH "You may choose how to proceed."
  //: FRANCAIS "Vous pouvez décider de la démarche à suivre."
  LISPOBJ_LS("You may choose how to proceed.",export_string1)
  //: DEUTSCH "Symbol ~S müßte erst in ~S importiert werden, bevor es exportiert werden kann."
  //: ENGLISH "symbol ~S should be imported into ~S before being exported."
  //: FRANCAIS "Le symbole ~S devrait d'abord être importé avant de pouvoir être exporté."
  LISPOBJ_LS("symbol ~S should be imported into ~S before being exported.",export_string2)
  //: DEUTSCH "((\"I\" \"Symbol erst importieren\" T) (\"N\" \"Nichts tun, Symbol nicht exportieren\" NIL))" 
  //: ENGLISH "((\"I\" \"import the symbol first\" T) (\"N\" \"do nothing, don't export the symbol\" NIL))"
  //: FRANCAIS "((\"I\" \"Tout d'abord importer le symbole\" NIL) (\"N\" \"Ne rien faire, ne pas exporter le symbole\" T))"
  LISPOBJ_L("((\"I\" \"import the symbol first\" T) (\"N\" \"do nothing, don't export the symbol\" NIL))",export_list1)
  //: DEUTSCH "Sie dürfen aussuchen, welches Symbol Vorrang hat."
  //: ENGLISH "You may choose in favour of which symbol to resolve the conflict."
  //: FRANCAIS "Vous pouvez choisir à quel symbole donner priorité."
  LISPOBJ_LS("You may choose in favour of which symbol to resolve the conflict.",export_string3)
  //: DEUTSCH "Durch Exportieren von ~S aus ~S ergibt sich ein Namenskonflikt mit ~S in ~S."
  //: ENGLISH "exporting ~S from ~S produces a name conflict with ~S from ~S."
  //: FRANCAIS "Un conflit de noms apparaît par l'exportation de ~S depuis ~S avec ~S de ~S."
  LISPOBJ_LS("exporting ~S from ~S produces a name conflict with ~S from ~S.",export_string4)
  //: DEUTSCH "Welches Symbol soll in "
  //: ENGLISH "Which symbol should be accessible in "
  //: FRANCAIS "Quel symbole devrait obtenir la priorité dans "
  LISPOBJ_LS("Which symbol should be accessible in ",export_string5)
  //: DEUTSCH " Vorrang haben?"
  //: ENGLISH " ?"
  //: FRANCAIS " ?"
  LISPOBJ_LS(" ?",export_string6)
  LISPOBJ(export_string7,"\"1\"")
  LISPOBJ(export_string8,"\"2\"")
  //: DEUTSCH "Das zu exportierende Symbol "
  //: ENGLISH "the symbol to export, "
  //: FRANCAIS "Le symbole à exporter "
  LISPOBJ_LS("the symbol to export, ",export_string9)
  //: DEUTSCH "Das alte Symbol "
  //: ENGLISH "the old symbol, "
  //: FRANCAIS "Le symbole original "
  LISPOBJ_LS("the old symbol, ",export_string10)
  //: DEUTSCH "Sie dürfen bei jedem Konflikt angeben, welches Symbol Vorrang haben soll."
  //: ENGLISH "You may choose for every conflict in favour of which symbol to resolve it."
  //: FRANCAIS "Pour chaque conflit, vous pouvez choisir à quel symbole donner priorité."
  LISPOBJ_LS("You may choose for every conflict in favour of which symbol to resolve it.",usepack_string1)
  //: DEUTSCH "~S Namenskonflikte bei USE-PACKAGE von ~S in die Package ~S."
  //: ENGLISH "~S name conflicts while executing USE-PACKAGE of ~S into package ~S."
  //: FRANCAIS "~S conflits de nom par USE-PACKAGE de ~S dans le paquetage ~S."
  LISPOBJ_LS("~S name conflicts while executing USE-PACKAGE of ~S into package ~S.",usepack_string2)
  //: DEUTSCH "Welches Symbol mit dem Namen "
  //: ENGLISH "which symbol with name "
  //: FRANCAIS "À quel symbole de nom "
  LISPOBJ_LS("which symbol with name ",usepack_string3)
  //: DEUTSCH " soll in "
  //: ENGLISH " should be accessible in "
  //: FRANCAIS " donner priorité dans "
  LISPOBJ_LS(" should be accessible in ",usepack_string4)
  //: DEUTSCH " Vorrang haben?"
  //: ENGLISH " ?"
  //: FRANCAIS " ?"
  LISPOBJ_LS(" ?",usepack_string5)
  //: DEUTSCH "Sie dürfen einen neuen Namen eingeben."
  //: ENGLISH "You can input another name."
  //: FRANCAIS "Vous pouvez entrer un nouveau nom."
  LISPOBJ_LS("You can input another name.",makepack_string1)
  //: DEUTSCH "Sie dürfen einen neuen Nickname eingeben."
  //: ENGLISH "You can input another nickname."
  //: FRANCAIS "Vous pouvez entrer un nouveau nom supplémentaire."
  LISPOBJ_LS("You can input another nickname.",makepack_string2)
  //: DEUTSCH "Eine Package mit dem Namen ~S gibt es schon."
  //: ENGLISH "a package with name ~S already exists."
  //: FRANCAIS "Il existe déjà un paquetage de nom ~S."
  LISPOBJ_LS("a package with name ~S already exists.",makepack_string3)
  //: DEUTSCH "Bitte neuen Packagenamen eingeben:"
  //: ENGLISH "Please input new package name:"
  //: FRANCAIS "Prière d'entrer un nouveau nom de paquetage :"
  LISPOBJ_LS("Please input new package name:",makepack_string4)
  //: DEUTSCH "Bitte neuen Packagenickname eingeben:"
  //: ENGLISH "Please input new package nickname:"
  //: FRANCAIS "Prière d'entrer un nouveau nom supplémentaire du paquetage :"
  LISPOBJ_LS("Please input new package nickname:",makepack_string5)
  //: DEUTSCH "Ignorieren."
  //: ENGLISH "Ignore."
  //: FRANCAIS "Ignorer cela."
  LISPOBJ_LS("Ignore.",delpack_string1)
  //: DEUTSCH "~S: Eine Package mit Namen ~S gibt es nicht."
  //: ENGLISH "~S: There is no package with name ~S."
  //: FRANCAIS "~S : Il n'y a pas de paquetage de nom ~S."
  LISPOBJ_LS("~S: There is no package with name ~S.",delpack_string2)
  //: DEUTSCH "~*~S wird trotzdem gelöscht."
  //: ENGLISH "~*Nevertheless delete ~S."
  //: FRANCAIS "~*Tout de même effacer ~S."
  LISPOBJ_LS("~*Nevertheless delete ~S.",delpack_string3)
  //: DEUTSCH "~S: ~S wird von ~{~S~^, ~} benutzt."
  //: ENGLISH "~S: ~S is used by ~{~S~^, ~}."
  //: FRANCAIS "~S: De ~S héritent ~{~S~^, ~}."
  LISPOBJ_LS("~S: ~S is used by ~{~S~^, ~}.",delpack_string4)
  # Default-Use-List:
  LISPOBJ(use_default,"(\"LISP\")")
# zu SYMBOL.D:
  LISPOBJ(gensym_prefix,"\"G\"") # Präfix für gensym, ein String
# zu MISC.D:
  # Eigenwissen:
  LISPOBJ(lisp_implementation_type_string,"\"CLISP\"")

  #include "version.h"

  LISPOBJ(lisp_implementation_version_date_string,"\"" VERSION "\"")
  LISPOBJ(lisp_implementation_version_year_string,"\"" VERSION_YYYY_STRING "\"")

  #if VERSION_MM==1
  //: DEUTSCH "Januar"
  //: ENGLISH "January"
  //: FRANCAIS "Janvier"
  LISPOBJ_LS("January",lisp_implementation_version_month_string)
  #elif VERSION_MM==2
  //: DEUTSCH "Februar"
  //: ENGLISH "February"
  //: FRANCAIS "Février"
  LISPOBJ_LS("February",lisp_implementation_version_month_string)
  #elif VERSION_MM==3
  //: DEUTSCH "März"
  //: ENGLISH "March"
  //: FRANCAIS "Mars"
  LISPOBJ_LS("March",lisp_implementation_version_month_string)
  #elif VERSION_MM==4
  //: DEUTSCH "April"
  //: ENGLISH "April"
  //: FRANCAIS "Avril"
  LISPOBJ_LS("April",lisp_implementation_version_month_string)
  #elif VERSION_MM==5
  //: DEUTSCH "Mai"
  //: ENGLISH "May"
  //: FRANCAIS "Mai"
  LISPOBJ_LS("May",lisp_implementation_version_month_string)
  #elif VERSION_MM==6
  //: DEUTSCH "Juni"
  //: ENGLISH "June"
  //: FRANCAIS "Juin"
  LISPOBJ_LS("June",lisp_implementation_version_month_string)
  #elif VERSION_MM==7
  //: DEUTSCH "Juli"
  //: ENGLISH "July"
  //: FRANCAIS "Juillet"
  LISPOBJ_LS("July",lisp_implementation_version_month_string)
  #elif VERSION_MM==8
  //: DEUTSCH "August"
  //: ENGLISH "August"
  //: FRANCAIS "Août"
  LISPOBJ_LS("August",lisp_implementation_version_month_string)
  #elif VERSION_MM==9
  //: DEUTSCH "September"
  //: ENGLISH "September"
  //: FRANCAIS "Septembre"
  LISPOBJ_LS("September",lisp_implementation_version_month_string)
  #elif VERSION_MM==10
  //: DEUTSCH "Oktober"
  //: ENGLISH "October"
  //: FRANCAIS "Octobre"
  LISPOBJ_LS("October",lisp_implementation_version_month_string)
  #elif VERSION_MM==11
  //: DEUTSCH "November"
  //: ENGLISH "November"
  //: FRANCAIS "Novembre"
  LISPOBJ_LS("November",lisp_implementation_version_month_string)
  #elif VERSION_MM==12
  //: DEUTSCH "Dezember"
  //: ENGLISH "December"
  //: FRANCAIS "Décembre"
  LISPOBJ_LS("December",lisp_implementation_version_month_string)
  #else 
  #error
  #endif
  LISPOBJ(space_string,"\" \"")
  LISPOBJ(left_paren_string,"\"(\"")
  LISPOBJ(right_paren_string,"\")\"")
  
  LISPOBJ(version,"( #.(fifth *features*)" # Symbol SYS::CLISP2 bzw. SYS::CLISP3
                   " #.sys::*jmpbuf-size*" # Zahl *jmpbuf-size*
                   " #.sys::*big-endian*"  # Flag *big-endian*
                   " 130695" # Datum der letzten Änderung des Bytecode-Interpreters
                  ")"
         )
  #ifdef MACHINE_KNOWN
    LISPOBJ(machine_type_string,"NIL")
    LISPOBJ(machine_version_string,"NIL")
    LISPOBJ(machine_instance_string,"NIL")
  #endif
  //: DEUTSCH "ANSI-C-Programm"
  //: ENGLISH "ANSI C program"
  //: FRANCAIS "Programme en ANSI C"
  LISPOBJ_LS("ANSI C program",software_type_string)
  #ifdef GNU
  //: DEUTSCH "GNU-C"
  //: ENGLISH "GNU C"
  //: FRANCAIS "GNU C"
  LISPOBJ_LS("GNU C",c_compiler_version_string)
  LISPOBJ(c_compiler_version_number_string,"\"" __VERSION__ "\"")
  #else
  //: DEUTSCH "C-Compiler"
  //: ENGLISH "C compiler"
  //: FRANCAIS "Compilateur C"
  LISPOBJ_LS("C compiler",c_compiler_version_string)
  LISPOBJ(c_compiler_version_number_string,"\"\"")
 #endif
# zu TIME.D:
 #ifdef TIME_RELATIVE
  # Start-Universal-Time:
  LISPOBJ(start_UT,"NIL")
 #endif
# zu ERROR.D:
  # Errormeldungs-Startstring:
  LISPOBJ(error_string1,"\"*** - \"")
  # Vektor mit Conditions und Simple-Conditions:
  LISPOBJ(error_types,"#()")
  # für Errors vom Typ TYPE-ERROR:
  LISPOBJ(type_uint8,"(INTEGER 0 255)") # oder "(UNSIGNED-BYTE 8)"
  LISPOBJ(type_sint8,"(INTEGER -128 127)") # oder "(SIGNED-BYTE 8)"
  LISPOBJ(type_uint16,"(INTEGER 0 65535)") # oder "(UNSIGNED-BYTE 16)"
  LISPOBJ(type_sint16,"(INTEGER -32768 32767)") # oder "(SIGNED-BYTE 16)"
  LISPOBJ(type_uint32,"(INTEGER 0 4294967295)") # oder "(UNSIGNED-BYTE 32)"
  LISPOBJ(type_sint32,"(INTEGER -2147483648 2147483647)") # oder "(SIGNED-BYTE 32)"
  LISPOBJ(type_uint64,"(INTEGER 0 18446744073709551615)") # oder "(UNSIGNED-BYTE 64)"
  LISPOBJ(type_sint64,"(INTEGER -9223372036854775808 9223372036854775807)") # oder "(SIGNED-BYTE 64)"
  LISPOBJ(type_array_index,"(INTEGER 0 (#.ARRAY-DIMENSION-LIMIT))")
  LISPOBJ(type_array_bit,"(ARRAY BIT)")
  LISPOBJ(type_posfixnum,"(INTEGER 0 #.MOST-POSITIVE-FIXNUM)")
  LISPOBJ(type_posfixnum1,"(INTEGER (0) #.MOST-POSITIVE-FIXNUM)")
  LISPOBJ(type_array_rank,"(INTEGER 0 (#.ARRAY-RANK-LIMIT))")
  LISPOBJ(type_radix,"(INTEGER 2 36)")
  LISPOBJ(type_bitname,"(MEMBER :CONTROL :META :SUPER :HYPER)")
  LISPOBJ(type_end_index,"(OR NULL INTEGER)")
  LISPOBJ(type_posinteger,"(INTEGER 0 *)")
  LISPOBJ(type_stringsymchar,"(OR STRING SYMBOL STRING-CHAR)")
  LISPOBJ(type_svector2,"(SIMPLE-VECTOR 2)")
  LISPOBJ(type_svector5,"(SIMPLE-VECTOR 5)")
  LISPOBJ(type_climb_mode,"(INTEGER 1 5)")
  LISPOBJ(type_hashtable_test,"(MEMBER EQ EQL EQUAL #.#'EQ #.#'EQL #.#'EQUAL)")
  LISPOBJ(type_hashtable_size,"(INTEGER 0 #.(floor (- most-positive-fixnum 1) 2))")
  LISPOBJ(type_hashtable_rehash_size,"(FLOAT (1.0) *)")
  LISPOBJ(type_hashtable_rehash_threshold,"(FLOAT 0.0 1.0)")
  LISPOBJ(type_boole,"(INTEGER 0 15)")
  LISPOBJ(type_not_digit,"(AND CHARACTER (NOT (SATISFIES DIGIT-CHAR-P)))")
  LISPOBJ(type_rtcase,"(MEMBER :UPCASE :DOWNCASE :PRESERVE)")
  LISPOBJ(type_peektype,"(OR (MEMBER NIL T) CHARACTER)")
  LISPOBJ(type_printcase,"(MEMBER :UPCASE :DOWNCASE :CAPITALIZE)")
  LISPOBJ(type_random_arg,"(OR (INTEGER (0) *) (FLOAT (0.0) *))")
  LISPOBJ(type_packname,"(OR PACKAGE STRING SYMBOL)")
  LISPOBJ(type_stringsym,"(OR STRING SYMBOL)")
  LISPOBJ(type_posint16,"(INTEGER (0) (65536))")
  LISPOBJ(type_gensym_arg,"(OR STRING INTEGER)")
  LISPOBJ(type_uint8_vector,"(ARRAY (UNSIGNED-BYTE 8) (*))")
  LISPOBJ(type_position,"(OR (MEMBER :START :END) (INTEGER 0 #.MOST-POSITIVE-FIXNUM))")
 #if HAS_HOST || defined(LOGICAL_PATHNAMES)
  LISPOBJ(type_host,"(OR NULL STRING)")
 #endif
 #if HAS_VERSION || defined(LOGICAL_PATHNAMES)
  LISPOBJ(type_version,"(OR (MEMBER NIL :WILD :NEWEST) (INTEGER (0) #.MOST-POSITIVE-FIXNUM) PATHNAME)")
 #else
  LISPOBJ(type_version,"(MEMBER NIL :WILD :NEWEST)")
 #endif
  LISPOBJ(type_direction,"(MEMBER :INPUT :INPUT-IMMUTABLE :OUTPUT :IO :PROBE)")
  LISPOBJ(type_if_exists,"(MEMBER :ERROR :NEW-VERSION :RENAME :RENAME-AND-DELETE :OVERWRITE :APPEND :SUPERSEDE NIL)")
  LISPOBJ(type_if_does_not_exist,"(MEMBER :ERROR :CREATE NIL)")
  LISPOBJ(type_pathname_field_key,"(MEMBER :HOST :DEVICE :DIRECTORY :NAME :TYPE :VERSION NIL)")
 #ifdef LOGICAL_PATHNAMES
  LISPOBJ(type_logical_pathname,"(OR LOGICAL-PATHNAME STRING STREAM SYMBOL)")
 #endif
# zu PATHNAME.D:
 #ifdef LOGICAL_PATHNAMES
  LISPOBJ(empty_logical_pathname,".") # (schon initialisiert)
  LISPOBJ(default_logical_pathname_host,"\"SYS\"")
 #endif
  LISPOBJ(leer_string,"\"\"")
  LISPOBJ(wild_string,"\"*\"")
  LISPOBJ(doppelpunkt_string,"\":\"")
 #if defined(PATHNAME_MSDOS) || defined(PATHNAME_OS2)
  LISPOBJ(backslash_string,"\"\\\\\"")
 #endif
 #if defined(PATHNAME_UNIX) || defined(PATHNAME_AMIGAOS)
  LISPOBJ(slash_string,"\"/\"")
 #endif
  LISPOBJ(punkt_string,"\".\"")
 #if defined(PATHNAME_MSDOS) || defined(PATHNAME_OS2) || defined(PATHNAME_UNIX) || defined(PATHNAME_AMIGAOS)
  LISPOBJ(punktpunkt_string,"\"..\"")
  LISPOBJ(punktpunktpunkt_string,"\"...\"")
 #endif
 #ifdef PATHNAME_RISCOS
  LISPOBJ(parent_string,"\"^\"")
  LISPOBJ(root_string,"\"$.\"")
  LISPOBJ(home_string,"\"&.\"")
  LISPOBJ(current_string,"\"@.\"")
  LISPOBJ(library_string,"\"%.\"")
  LISPOBJ(previous_string,"\"\\\\.\"")
 #endif
 #ifdef PATHNAME_OS2
  LISPOBJ(pipe_subdirs,"(\"PIPE\")")
 #endif
 #if defined(PATHNAME_MSDOS) || defined(PATHNAME_OS2)
  LISPOBJ(wild_wild_string,"\"*.*\"")
 #endif
  LISPOBJ(null_string,"\"0\"") # String aus einem Nullbyte
 #if defined(PATHNAME_MSDOS)
  LISPOBJ(backuptype_string,"\"BAK\"") # Filetyp von Backupfiles
 #endif
 #ifdef PATHNAME_OS2
  LISPOBJ(backuptype_string,"\"bak\"") # Filetyp von Backupfiles
 #endif
 #ifdef PATHNAME_AMIGAOS
  LISPOBJ(backupextend_string,"\".bak\"") # Namenserweiterung von Backupfiles
 #endif
 #ifdef PATHNAME_UNIX
  LISPOBJ(backupextend_string,"\"%\"") # Namenserweiterung von Backupfiles
 #endif
 #ifdef PATHNAME_RISCOS
  LISPOBJ(backupprepend_string,"\"~\"") # Namenserweiterung von Backupfiles
 #endif
 #if defined(PATHNAME_MSDOS) || defined(PATHNAME_OS2)
  # Default-Drive (als String der Länge 1):
  LISPOBJ(default_drive,"NIL")
 #endif
 #if defined(PATHNAME_UNIX) || defined(PATHNAME_AMIGAOS) || defined(PATHNAME_OS2)
  LISPOBJ(wildwild_string,"\"**\"")
  LISPOBJ(directory_absolute,"(:ABSOLUTE)") # Directory des leeren absoluten Pathname
 #endif
 #ifdef PATHNAME_RISCOS
  LISPOBJ(directory_absolute,"(:ABSOLUTE :ROOT)") # Directory des leeren absoluten Pathname
  LISPOBJ(directory_homedir,"(:ABSOLUTE :HOME)") # Directory des User-Homedir-Pathname
 #endif
 #ifdef USER_HOMEDIR
  LISPOBJ(user_homedir,"#\".\"") # User-Homedir-Pathname
 #endif
 #ifdef HAVE_SHELL
 #if defined(UNIX) || defined(WIN32_UNIX)
  LISPOBJ(command_shell,"\"" SHELL "\"") # Kommando-Shell als String
  LISPOBJ(command_shell_option,"\"-c\"") # Kommando-Shell-Option für Kommando
  LISPOBJ(user_shell,"\"/bin/csh\"") # User-Shell als String
 #endif
 #ifdef MSDOS
  #if !defined(WINDOWS)
  LISPOBJ(command_shell,"\"\\\\COMMAND.COM\"") # Kommandointerpreter als String
  #else # defined(WINDOWS)
  LISPOBJ(command_shell,"\"DOSPRMPT.PIF\"") # Kommandointerpreter als String
  #endif
  LISPOBJ(command_shell_option,"\"/C\"") # Kommandointerpreter-Option für Kommando
 #endif
 #ifdef RISCOS
  LISPOBJ(command_shell,"\"gos\"")
 #endif
 #endif
  # Liste aller offenen File-Streams, Handle-Streams, Terminal-Streams:
  LISPOBJ(open_files,"NIL")
 #ifdef GC_CLOSES_FILES
  # Während der GC: die Liste der nach der GC zu schließenden File-Streams:
  LISPOBJ(files_to_close,"NIL")
 #endif
  # Argumentliste für WRITE-TO-STRING :
  LISPOBJ(base10_radixnil,"(:BASE 10 :RADIX NIL)")
  # Defaults-Warnungs-String:
  //: DEUTSCH "Der Wert von ~S war kein Pathname. ~:*~S wird zurückgesetzt."
  //: ENGLISH "The value of ~S was not a pathname. ~:*~S is being reset."
  //: FRANCAIS "La valeur de ~S n'était pas de type PATHNAME. ~:*~S est réinitialisé."
  LISPOBJ_LS("The value of ~S was not a pathname. ~:*~S is being reset.",defaults_warn_string)
  # Defaultwert für :DIRECTORY-Argument:
  LISPOBJ(directory_default,"(:RELATIVE)")
  # Defaults für COMPILE-FILE-Aufruf in SPVW:
  LISPOBJ(source_file_type,"#\".lsp\"")
  LISPOBJ(compiled_file_type,"#\".fas\"")
  LISPOBJ(listing_file_type,"#\".lis\"")
# zu IO.D:
  # 4 Bitnamen:
  LISPOBJ(bitname_0,"\"CONTROL\"")
  LISPOBJ(bitname_1,"\"META\"")
  LISPOBJ(bitname_2,"\"SUPER\"")
  LISPOBJ(bitname_3,"\"HYPER\"")
  # 3 Readtable-Case-Werte:
  LISPOBJ(rtcase_0,":UPCASE")
  LISPOBJ(rtcase_1,":DOWNCASE")
  LISPOBJ(rtcase_2,":PRESERVE")
 # zum Reader:
  # Standard-Readtable von Common Lisp
  LISPOBJ(standard_readtable,".")
  # Präfix für Character-Namen:
  LISPOBJ(charname_prefix,"\"Code\"")
  # interne Variablen des Readers:
  LISPOBJ(token_buff_1,".")
  LISPOBJ(token_buff_2,".")
  LISPOBJ(displaced_string,".")
 # zum Printer:
  # beim Ausgeben von Objekten verwendete Teilstrings:
  LISPOBJ(printstring_array,"\"ARRAY\"")
  LISPOBJ(printstring_fill_pointer,"\"FILL-POINTER=\"")
  LISPOBJ(printstring_address,"\"ADDRESS\"")
  LISPOBJ(printstring_system,"\"SYSTEM-POINTER\"")
  LISPOBJ(printstring_frame_pointer,"\"FRAME-POINTER\"")
  LISPOBJ(printstring_read_label,"\"READ-LABEL\"")
  LISPOBJ(printstring_unbound,"\"#<UNBOUND>\"")
  LISPOBJ(printstring_special_reference,"\"#<SPECIAL REFERENCE>\"")
  LISPOBJ(printstring_disabled_pointer,"\"#<DISABLED POINTER>\"")
  LISPOBJ(printstring_dot,"\"#<DOT>\"")
  LISPOBJ(printstring_eof,"\"#<END OF FILE>\"")
  LISPOBJ(printstring_hash_table,"\"HASH-TABLE\"")
  LISPOBJ(printstring_deleted,"\"DELETED \"")
  LISPOBJ(printstring_package,"\"PACKAGE\"")
  LISPOBJ(printstring_readtable,"\"READTABLE\"")
  LISPOBJ(pathname_slotlist,"#.(list (cons :HOST #'pathname-host) (cons :DEVICE #'pathname-device) (cons :DIRECTORY #'pathname-directory) (cons :NAME #'pathname-name) (cons :TYPE #'pathname-type) (cons :VERSION #'pathname-version))")
  LISPOBJ(byte_slotlist,"#.(list (cons :SIZE #'byte-size) (cons :POSITION #'byte-position))")
  LISPOBJ(printstring_symbolmacro,"\"SYMBOL-MACRO\"")
  #ifdef FOREIGN
  LISPOBJ(printstring_invalid,"\"INVALID \"")
  LISPOBJ(printstring_fpointer,"\"FOREIGN-POINTER\"")
  #endif
  #ifdef DYNAMIC_FFI
  LISPOBJ(printstring_faddress,"\"FOREIGN-ADDRESS\"")
  LISPOBJ(printstring_fvariable,"\"FOREIGN-VARIABLE\"")
  LISPOBJ(printstring_ffunction,"\"FOREIGN-FUNCTION\"")
  #endif
  LISPOBJ(printstring_finalizer,"\"#<FINALIZER>\"")
  #ifdef SOCKET_STREAMS
  LISPOBJ(printstring_socket_server,"\"SOCKET-SERVER\"")
  #endif
  #ifdef YET_ANOTHER_RECORD
  LISPOBJ(printstring_yetanother,"\"YET-ANOTHER\"")
  #endif
  LISPOBJ(printstring_closure,"\"CLOSURE\"")
  LISPOBJ(printstring_generic_function,"\"GENERIC-FUNCTION\"")
  LISPOBJ(printstring_compiled_closure,"\"COMPILED-CLOSURE\"")
  LISPOBJ(printstring_subr,"\"SYSTEM-FUNCTION\"")
  LISPOBJ(printstring_addon_subr,"\"ADD-ON-SYSTEM-FUNCTION\"")
  LISPOBJ(printstring_fsubr,"\"SPECIAL-FORM\"")
  LISPOBJ(printstring_closed,"\"CLOSED \"")
    # Namensstring zu jedem Streamtyp, adressiert durch Streamtyp:
    LISPOBJ(printstring_strmtype_sch_file,"\"STRING-CHAR-FILE\"")
    LISPOBJ(printstring_strmtype_ch_file,"\"CHAR-FILE\"")
    LISPOBJ(printstring_strmtype_iu_file,"\"UNSIGNED-BYTE-FILE\"")
    LISPOBJ(printstring_strmtype_is_file,"\"SIGNED-BYTE-FILE\"")
    #ifdef HANDLES
    LISPOBJ(printstring_strmtype_handle,"\"FILE-HANDLE\"")
    #endif
    #ifdef KEYBOARD
    LISPOBJ(printstring_strmtype_keyboard,"\"KEYBOARD\"")
    #endif
    LISPOBJ(printstring_strmtype_terminal,"\"TERMINAL\"")
    LISPOBJ(printstring_strmtype_synonym,"\"SYNONYM\"")
    LISPOBJ(printstring_strmtype_broad,"\"BROADCAST\"")
    LISPOBJ(printstring_strmtype_concat,"\"CONCATENATED\"")
    LISPOBJ(printstring_strmtype_twoway,"\"TWO-WAY\"")
    LISPOBJ(printstring_strmtype_echo,"\"ECHO\"")
    LISPOBJ(printstring_strmtype_str_in,"\"STRING-INPUT\"")
    LISPOBJ(printstring_strmtype_str_out,"\"STRING-OUTPUT\"")
    LISPOBJ(printstring_strmtype_str_push,"\"STRING-PUSH\"")
    LISPOBJ(printstring_strmtype_pphelp,"\"PRETTY-PRINTER-HELP\"")
    LISPOBJ(printstring_strmtype_buff_in,"\"BUFFERED-INPUT\"")
    LISPOBJ(printstring_strmtype_buff_out,"\"BUFFERED-OUTPUT\"")
    #ifdef SCREEN
    LISPOBJ(printstring_strmtype_window,"\"WINDOW\"")
    #endif
    #ifdef PRINTER
    LISPOBJ(printstring_strmtype_printer,"\"PRINTER\"")
    #endif
    #ifdef PIPES
    LISPOBJ(printstring_strmtype_pipe_in,"\"PIPE-INPUT\"")
    LISPOBJ(printstring_strmtype_pipe_out,"\"PIPE-OUTPUT\"")
    #endif
    #ifdef XSOCKETS
    LISPOBJ(printstring_strmtype_xsocket,"\"XSOCKET\"")
    #endif
    #ifdef GENERIC_STREAMS
    LISPOBJ(printstring_strmtype_generic,"\"GENERIC\"")
    #endif
    #ifdef SOCKET_STREAMS
    LISPOBJ(printstring_strmtype_socket,"\"SOCKET\"")
    #endif
  LISPOBJ(printstring_stream,"\"-STREAM\"")
# zu LISPARIT.D:
  # verschiedene konstante Zahlen:
  #ifndef WIDE
  LISPOBJ(FF_zero,"0.0F0")
  LISPOBJ(FF_one,"1.0F0")
  LISPOBJ(FF_minusone,"-1.0F0")
  #endif
  LISPOBJ(DF_zero,"0.0D0")
  LISPOBJ(DF_one,"1.0D0")
  LISPOBJ(DF_minusone,"-1.0D0")
  # Defaultlänge beim Einlesen von Long-Floats (Integer >=LF_minlen, <2^intCsize):
  LISPOBJ(LF_digits,".") # (schon initialisiert)
  # variable Long-Floats: (schon initialisiert)
  LISPOBJ(SF_pi,".")   # Wert von pi als Short-Float
  LISPOBJ(FF_pi,".")   # Wert von pi als Single-Float
  LISPOBJ(DF_pi,".")   # Wert von pi als Double-Float
  LISPOBJ(pi,".")      # Wert von pi, Long-Float der Defaultlänge
  LISPOBJ(LF_pi,".")   # Wert von pi, so genau wie bekannt
  LISPOBJ(LF_ln2,".")  # Wert von ln 2, so genau wie bekannt
  LISPOBJ(LF_ln10,".") # Wert von ln 10, so genau wie bekannt
  # Warnungs-String:
  //: DEUTSCH "In ~S wurde ein illegaler Wert vorgefunden,"
  //: ENGLISH "The variable ~S had an illegal value."
  //: FRANCAIS "Une valeur invalide fut trouvée dans la variable ~S"
  LISPOBJ_LS("The variable ~S had an illegal value.",default_float_format_warnung_string_line_1)
  //: DEUTSCH "~S wird auf ~S zurückgesetzt."
  //: ENGLISH "~S has been reset to ~S."
  //: FRANCAIS "~S fut réinitialisé à ~S."
  LISPOBJ_LS("~S has been reset to ~S.",default_float_format_warnung_string_line_2)
# zu EVAL.D:
  # Toplevel-Deklarations-Environment:
  LISPOBJ(top_decl_env,"(NIL)") # Liste aus O(declaration_types) (wird nachinitialisiert)
  # Decl-Spec mit Liste der zu erkennenden Deklarations-Typen:
  LISPOBJ(declaration_types,"(DECLARATION OPTIMIZE DECLARATION)")
# zu DEBUG.D:
  LISPOBJ(newline_string,"\"" NLstring "\"")
  # Prompts:
  LISPOBJ(prompt_string,"\"> \"")
  LISPOBJ(breakprompt_string,"\". Break> \"")
  # Abschieds-String:
  //: DEUTSCH "Bis bald!"
  //: ENGLISH "Bye."
  //: FRANCAIS "À bientôt!"
  LISPOBJ_LS("Bye.",bye_string)
  # verschiedene Strings zur Beschreibung des Stacks:
  LISPOBJ(showstack_string_lisp_obj,"\"" NLstring "- \"")
  LISPOBJ(showstack_string_bindung,"\"" NLstring "  | \"")
  //: DEUTSCH "  Weiteres Environment: "
  //: ENGLISH "  Next environment: "
  //: FRANCAIS "  prochain environnement : "
  LISPOBJ_LS("  Next environment: ",showstack_string_next_env)
  //: DEUTSCH "APPLY-Frame mit Breakpoint für Aufruf "
  //: ENGLISH "APPLY frame with breakpoint for call "
  //: FRANCAIS "«frame» APPLY avec point d'interception pour l'application "
  LISPOBJ_LS("APPLY frame with breakpoint for call ",showstack_string_TRAPPED_APPLY_frame)
  //: DEUTSCH "APPLY-Frame für Aufruf "
  //: ENGLISH "APPLY frame for call "
  //: FRANCAIS "«frame» APPLY pour l'application "
  LISPOBJ_LS("APPLY frame for call ",showstack_string_APPLY_frame)
  //: DEUTSCH "EVAL-Frame mit Breakpoint für Form "
  //: ENGLISH "EVAL frame with breakpoint for form "
  //: FRANCAIS "«frame» EVAL avec point d'interception pour la forme "
  LISPOBJ_LS("EVAL frame with breakpoint for form ",showstack_string_TRAPPED_EVAL_frame)
  //: DEUTSCH "EVAL-Frame für Form "
  //: ENGLISH "EVAL frame for form "
  //: FRANCAIS "«frame» EVAL pour la forme "
  LISPOBJ_LS("EVAL frame for form ",showstack_string_EVAL_frame)
  //: DEUTSCH "Variablenbindungs-Frame bindet (~ = dynamisch):"
  //: ENGLISH "frame binding variables (~ = dynamically):"
  //: FRANCAIS "Le «frame» de liaison de variables (~ signifiant dynamique) lie :"
  LISPOBJ_LS("frame binding variables (~ = dynamically):",showstack_string_DYNBIND_frame)
  //: DEUTSCH "Variablenbindungs-Frame "
  //: ENGLISH "frame binding variables "
  //: FRANCAIS "«frame» de liaison de variables "
  LISPOBJ_LS("frame binding variables ",showstack_string_VAR_frame)
  //: DEUTSCH "Funktionsbindungs-Frame "
  //: ENGLISH "frame binding functions "
  //: FRANCAIS "«frame» de liaison de fonctions "
  LISPOBJ_LS("frame binding functions ",showstack_string_FUN_frame)
  //: DEUTSCH " bindet (~ = dynamisch):"
  //: ENGLISH " binds (~ = dynamically):"
  //: FRANCAIS " lie (~ signifiant dynamiquement) :"
  LISPOBJ_LS(" binds (~ = dynamically):",showstack_string_binds)
  LISPOBJ(showstack_string_zuord,"\" <--> \"")
  //: DEUTSCH "Block-Frame "
  //: ENGLISH "block frame "
  //: FRANCAIS "«frame» BLOCK "
  LISPOBJ_LS("block frame ",showstack_string_IBLOCK_frame)
  //: DEUTSCH "Block-Frame (genestet) "
  //: ENGLISH "nested block frame "
  //: FRANCAIS "«frame» BLOCK dépilé "
  LISPOBJ_LS("nested block frame ",showstack_string_NESTED_IBLOCK_frame)
  //: DEUTSCH " für "
  //: ENGLISH " for "
  //: FRANCAIS " pour "
  LISPOBJ_LS(" for ",showstack_string_for1)
  //: DEUTSCH "Block-Frame (compiliert) für "
  //: ENGLISH "compiled block frame for "
  //: FRANCAIS "«frame» BLOCK compilé pour "
  LISPOBJ_LS("compiled block frame for ",showstack_string_CBLOCK_frame)
  //: DEUTSCH "Tagbody-Frame "
  //: ENGLISH "tagbody frame "
  //: FRANCAIS "«frame» TAGBODY "
  LISPOBJ_LS("tagbody frame ",showstack_string_ITAGBODY_frame)
  //: DEUTSCH "Tagbody-Frame (genestet) "
  //: ENGLISH "nested tagbody frame "
  //: FRANCAIS "«frame» TAGBODY dépilé "
  LISPOBJ_LS("nested tagbody frame ",showstack_string_NESTED_ITAGBODY_frame)
  //: DEUTSCH " für"
  //: ENGLISH " for"
  //: FRANCAIS " pour"
  LISPOBJ_LS(" for",showstack_string_for2)
  LISPOBJ(showstack_string_zuordtag,"\" --> \"")
  //: DEUTSCH "Tagbody-Frame (compiliert) für "
  //: ENGLISH "compiled tagbody frame for "
  //: FRANCAIS "«frame» TAGBODY compilé pour "
  LISPOBJ_LS("compiled tagbody frame for ",showstack_string_CTAGBODY_frame)
  //: DEUTSCH "Catch-Frame für Tag "
  //: ENGLISH "catch frame for tag "
  //: FRANCAIS "«frame» CATCH pour l'étiquette "
  LISPOBJ_LS("catch frame for tag ",showstack_string_CATCH_frame)
  //: DEUTSCH "Handler-Frame für Conditions"
  //: ENGLISH "handler frame for conditions"
  //: FRANCAIS "«frame» HANDLER pour les conditions"
  LISPOBJ_LS("handler frame for conditions",showstack_string_HANDLER_frame)
  //: DEUTSCH "Unwind-Protect-Frame"
  //: ENGLISH "unwind-protect frame"
  //: FRANCAIS "«frame» UNWIND-PROTECT"
  LISPOBJ_LS("unwind-protect frame",showstack_string_UNWIND_PROTECT_frame)
  //: DEUTSCH "Driver-Frame"
  //: ENGLISH "driver frame"
  //: FRANCAIS "«driver frame»"
  LISPOBJ_LS("driver frame",showstack_string_DRIVER_frame)
  //: DEUTSCH "Environment-Bindungs-Frame"
  //: ENGLISH "frame binding environments"
  //: FRANCAIS "«frame» de liaison d'environnements"
  LISPOBJ_LS("frame binding environments",showstack_string_ENV_frame)
  LISPOBJ(showstack_string_VENV_frame,"\"" "  VAR_ENV <--> \"")
  LISPOBJ(showstack_string_FENV_frame,"\"" "  FUN_ENV <--> \"")
  LISPOBJ(showstack_string_BENV_frame,"\"" "  BLOCK_ENV <--> \"")
  LISPOBJ(showstack_string_GENV_frame,"\"" "  GO_ENV <--> \"")
  LISPOBJ(showstack_string_DENV_frame,"\"" "  DECL_ENV <--> \"")
# zu REXX.D:
 #ifdef REXX
  LISPOBJ(rexx_inmsg_list,"NIL")
  LISPOBJ(rexx_prefetch_inmsg,"NIL")
 #endif
# zu STDWIN.D:
 #ifdef STDWIN
  LISPOBJ(stdwin_drawproc_alist,"NIL")
 #endif
# zu FOREIGN.D:
 #ifdef DYNAMIC_FFI
  LISPOBJ(fp_zero,"NIL")
  LISPOBJ(foreign_variable_table,"#.(make-hash-table :test #'equal)")
  LISPOBJ(foreign_function_table,"#.(make-hash-table :test #'equal)")
  #ifdef AMIGAOS
  LISPOBJ(foreign_libraries,"NIL")
  #endif
  LISPOBJ(foreign_callin_table,"#.(make-hash-table :test #'eq)")
  LISPOBJ(foreign_callin_vector,"#.(let ((array (make-array 1 :adjustable t :fill-pointer 1))) (sys::store array 0 0) array)")
 #endif
