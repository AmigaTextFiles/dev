OPT     OSVERSION=37            /* EasyGUI arbeitet erst ab V.37*/

MODULE  'intuition/intuition'   /* Für das image-object...      */
MODULE  'plugin/sizeplug'       /* für das Size-plugin          */
MODULE  'tools/easygui'         /* für easygui                  */

 DEF    p:PTR TO sizeplug       /* Pointer auf das Sizeplug-Obj */,
        len=10                  /* Längenmaß...                 */

PROC main()     HANDLE                                          /* MAIN-Prozedur mit EXCEPTION-HANDLING */
 DEF    ourtask                                                 /* Zeiger auf unseren Task...           */
  ourtask:=FindTask(NIL)                                        /* Unseren Task ausfindig machen...     */
   SetTaskPri(ourtask,-2)                                       /* Da wir ja praktisch nix tun sollen...*/
    easygui('Size-Plugintest!',                                 /* EasyGUI-Prozedur                     */
        [ROWS,
                [PLUGIN, 0, NEW p.create(0,12,10,0)],           /* Window(size)-Plugin                  */
                [SBUTTON,{next},'Next']])
EXCEPT DO                                                       /* Exception Handling...                */
    END p                                                       /* Speicher für p wieder freigeben      */
   IF exception THEN CleanUp(20) ELSE CleanUp(0)                /* CleanUp() DOS-Returnwert setzen      */
ENDPROC                                                         /* Ende der MainProzedur...             */

PROC next()
 p.change(len,len,len,len)                                      /* Fenster um eine längeneinheit größer */
  len:=len+10
ENDPROC
