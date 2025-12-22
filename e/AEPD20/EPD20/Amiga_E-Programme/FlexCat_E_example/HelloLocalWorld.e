/*     HelloLocalWorld.e   */

PMODULE hellolocalworld_cat

PROC main()
   /*  Open Locale.library; No exit, if failure!       */
   localebase := OpenLibrary('locale.library', 0)

   /*  Open the catalog file.                          */
   open_hellolocalworld_catalog(NIL, NIL)

   WriteF('\s\n', get_hellolocalworld_string(MSG_HELLO_WORLD))

   close_hellolocalworld_catalog()
ENDPROC
