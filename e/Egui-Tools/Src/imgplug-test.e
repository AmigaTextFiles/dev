OPT     OSVERSION=37                                            /* EasyGUI arbeitet erst ab V.37        */

MODULE  'icon'                                                  /* Zum laden des Icons...               */
MODULE  'intuition/intuition'                                   /* Für das image-object...              */
MODULE  'intuition/imageclass'                                  /* Für die Zustände des Images          */
MODULE  '*imgplug'                                              /* für das image-plugin                 */
MODULE  'tools/easygui'                                         /* für easygui                          */
MODULE  'workbench/workbench'                                   /* Objecte ect...                       */

DEF     p:PTR TO imgplug,                                       /* Pointer auf das imgplug-Obj          */
        file:PTR TO diskobject                                  /* Pointer auf das Diskobject           */

PROC main()     HANDLE                                          /* MAIN-Prozedur mit EXCEPTION-HANDLING */
 DEF    ourtask                                                 /* Zeiger auf unseren Task...           */
  ourtask:=FindTask(NIL)                                        /* Unseren Task ausfindig machen...     */
   SetTaskPri(ourtask,-2)                                       /* Da wir ja praktisch nix tun sollen...*/
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise('dummy')       /* iconlibrary öffnen   */
     IF (file:=GetDiskObject(arg))=NIL THEN Raise('dummy')      /* Icon öffnen (arg=filename)           */
      WriteF(' Click on the Image and look what happens...:-)\n\n')    /* Text ausgeben...             */
       easygui('Image-Plugintest!',                             /* EasyGUI-Prozedur                     */
                [ROWS,
                [BEVELR,
                [PLUGIN, {msg}, NEW p.create(file.gadget,TRUE)]],       /* Imgobjekt initialisieren     */
                [SBUTTON,{dummy},'DUMMY']])
EXCEPT DO                                                       /* Exception Handling...                */
      END p                                                     /* Speicher für p wieder freigeben      */
     IF file THEN FreeDiskObject(file)                          /* Iconimage wieder freigeben           */
    IF iconbase THEN CloseLibrary(iconbase)                     /* icon.library wieder schließen        */
   IF exception THEN CleanUp(20) ELSE CleanUp(0)                /* CleanUp() DOS-Returnwert setzen      */
ENDPROC                                                         /* Ende der MainProzedur...             */

PROC msg()                                                      /* Solle normal beim anklicken des      */
 WriteF(' Pressed! \n')                                         /* Plugins ausgegeben werden ,aber das  */
ENDPROC                                                         /* akt. EasyGUI macht das (?) nicht!    */

PROC dummy()                                                    /* Ein Dummy...                         */
 WriteF(' Dummy! \n')
ENDPROC                                                         /* Ende der Prozedur                    */

