OPT     OSVERSION=37                                            /* NewGUI arbeitet erst ab V.37         */
OPT     LARGE

MODULE  'icon'                                                  /* Zum laden des Icons...               */
MODULE  'intuition/intuition'                                   /* Für das image-object...              */
MODULE  'newgui/pl_iconbutton'                                  /* für das Icon-plugin                  */
MODULE  'newgui/newgui'                                         /* für newgui                           */
MODULE  'workbench/workbench'                                   /* Objecte ect...                       */

DEF     i:PTR TO icon,                                          /* Pointer auf das imgplug-Obj          */
        file:PTR TO diskobject                                  /* Pointer auf das Diskobject           */

PROC main()     HANDLE                                          /* MAIN-Prozedur mit EXCEPTION-HANDLING */
 IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise('dummy')          /* iconlibrary öffnen   */
  IF (file:=GetDiskObject('sys:disk'))=NIL THEN Raise('dummy')  /* Icon öffnen (arg=filename)           */

   newguiA([
        NG_WINDOWTITLE, 'NewGUI-IconPlugin',     
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [ROWS,
                [SPACE],
                [ICON, {msg}, NEW i.icon(file.gadget,TRUE)]]],          /* Imgobjekt initialisieren     */
                [SBUTTON,{dummy},'DUMMY']],
        NIL,NIL])

EXCEPT DO                                                       /* Exception Handling...                */
    END i                                                       /* Speicher für i wieder freigeben      */
   IF (file<>NIL)    THEN FreeDiskObject(file)                  /* Icon wieder freigeben!               */
  IF (iconbase<>NIL) THEN CloseLibrary(iconbase)                /* icon.library wieder schließen        */
 CleanUp(exception)
ENDPROC                                                         /* Ende der MainProzedur...             */

PROC msg()
 WriteF(' Pressed! \n')
ENDPROC

PROC dummy()                                                    /* Ein Dummy...                         */
 WriteF(' Dummy! \n')
ENDPROC                                                         /* Ende der Prozedur                    */
