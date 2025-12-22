OPT     OSVERSION=37                                            /* NewGUI arbeitet erst ab V.37         */
OPT     LARGE

MODULE  'gadgets/textfield'                                     /* Konstatnten zum Textfield-Gadget     */
MODULE  'newgui/pl_textfield'                                      /* für das textfield-plugin             */
MODULE  'newgui/newgui'                                         /* für newgui                           */

DEF     t:PTR TO textfield                                      /* Pointer auf das textfield-Plugin     */

PROC main()     HANDLE                                          /* MAIN-Prozedur mit EXCEPTION-HANDLING */
 newguiA([
        NG_WINDOWTITLE, 'NewGUI-TextPlugin',     
        NG_GUI,
                [ROWS,
                [TEXTFIELD, 0, NEW t.textfield(150,75,
                        [TEXTFIELD_TEXT,          'Blah blah-blah\nBlah-blah-blah Blah-blah Blah\nBlah\n',
                        TEXTFIELD_BLINKRATE,      500000,
                        TEXTFIELD_BLOCKCURSOR,    TRUE,
                        TEXTFIELD_BORDER,         TEXTFIELD_BORDER_DOUBLEBEVEL,
                        TEXTFIELD_TABSPACES,      4,
                        TEXTFIELD_NONPRINTCHARS,  FALSE,
                        NIL,NIL])],                            /* Imgobjekt initialisieren             */
                [SBUTTON,{dummy},'DUMMY']],
        NIL,NIL])
EXCEPT DO                                                       /* Exception Handling...                */
  END t                                                         /* Speicher für t wieder freigeben      */
 CleanUp(exception)
ENDPROC                                                         /* Ende der MainProzedur...             */

PROC dummy()                                                    /* Ein Dummy...                         */
 WriteF(' Dummy! \n')
ENDPROC                                                         /* Ende der Prozedur                    */

