# Aus der Speicherverwaltung ausgelagert:
# Tabelle aller festen Symbole
# Bruno Haible 13.11.1994

#include "lispbibl.c"

#undef LISPSYM

#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
  # Ein kleines Shadowing-Problem. Grr...
  #undef read
#endif
# Noch so ein Macro-Problem. Grr...
  #undef inline

# Tabelle aller festen Symbole:
  global struct symbol_tab_ symbol_tab_data
    #if defined(INIT_SYMBOL_TAB) && NIL_IS_CONSTANT
    = {
        #define LISPSYM  LISPSYM_C
        #include "constsym.c"
        #undef LISPSYM
      }
    #endif
    ;

