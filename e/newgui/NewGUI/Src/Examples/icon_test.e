OPT     OSVERSION=37                                            /* NewGUI arbeitet erst ab V.37         */
OPT     LARGE

MODULE  'icon'                                                  /* Zum laden des Icons...               */
MODULE  'intuition/intuition'                                   /* Für das image-object...              */
MODULE  'newgui/icon'                                           /* für das Icon-plugin                  */
MODULE  'newgui/newgui'                                         /* für newgui                           */
MODULE  'workbench/workbench'                                   /* Objecte ect...                       */

DEF     i:PTR TO icon,                                          /* Pointer auf das imgplug-Obj          */
        file:PTR TO diskobject                                  /* Pointer auf das Diskobject           */

PROC main()     HANDLE                                          /* MAIN-Prozedur mit EXCEPTION-HANDLING */
 IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise('dummy')          /* iconlibrary öffnen   */
  IF (file:=GetDiskObject('sys:disk'))=NIL THEN Raise('dummy')  /* Icon öffnen (arg=filename)           */
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-IconPlugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)                     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
        NG_PATTERNEXP,  1,                                      /* Exponent für den Pattern             */
        NG_PATTERN1,    [$AAAA,$5555]:INT,                      /* Muster (Pattern) für FILLPATTERN1    */
        NG_P1BACKPEN,   0,                                      /* Hintergrundstift für das Patternfilling (Muster)             */
        NG_P1FRONTPEN,  0,                                      /* Zeichenstift für das Muster (Patternfilling)                 */
/*                                                              /* ARexx-Port hinzufügen!               */
        NG_REXXNAME,    'NEWGUI',                               /* Name für einen ARexx-Port            */
        NG_REXXPROC,    {rexxmsg},                              /* Prozedur die ARexx-Messages auswertet*/
*/                                                              /* Durch den Port wird das EXE nicht größer!                    */
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [FILLPATTERN1,
                [ROWS,
                [SPACE],
                [ICON, {msg}, NEW i.icon(file.gadget,TRUE)]]]],         /* Imgobjekt initialisieren     */
                [SBUTTON,{dummy},'DUMMY']],
        NIL,NIL])
EXCEPT DO                                                       /* Exception Handling...                */
    END i                                                       /* Speicher für i wieder freigeben      */
   IF (file<>NIL)    THEN FreeDiskObject(file)                  /* Icon wieder freigeben!               */
  IF (iconbase<>NIL) THEN CloseLibrary(iconbase)                /* icon.library wieder schließen        */
 CleanUp(exception)
ENDPROC                                                         /* Ende der MainProzedur...             */

PROC msg()                                                      /* Solle normal beim anklicken des      */
 WriteF(' Pressed! \n')                                         /* Plugins ausgegeben werden ,aber das  */
ENDPROC                                                         /* akt. EasyGUI macht das (?) nicht!    */

PROC dummy()                                                    /* Ein Dummy...                         */
 WriteF(' Dummy! \n')
ENDPROC                                                         /* Ende der Prozedur                    */

/*        -> Muß für den ARexx-Port vorhanden sein (kommentarklammern dann entfernen!)
PROC rexxmsg(s,mes=NIL)
 WriteF('\nRexx-Msg: "\s"',s)

  mes:=NIL
ENDPROC  StrCmp('QUIT',s),0,'Reply-Message'
*/
