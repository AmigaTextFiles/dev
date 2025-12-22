# Aus der Speicherverwaltung ausgelagert:
# Tabelle aller SUBRs
# Bruno Haible 13.11.1994

#include "lispbibl.c"

#undef LISPFUN

#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
  # Ein kleines Shadowing-Problem. Grr...
  #undef read
#endif

# Tabelle aller SUBRs:
  global struct subr_tab_ subr_tab_data
    #if defined(INIT_SUBR_TAB)
    = {
        #if NIL_IS_CONSTANT
          #define LISPFUN  LISPFUN_G
        #else
          #define LISPFUN  LISPFUN_F
        #endif
        #include "subr.c"
        #undef LISPFUN
      }
    #endif
    ;
  global uintC subr_tab_data_size = sizeof(subr_tab_data)/sizeof(subr_);

