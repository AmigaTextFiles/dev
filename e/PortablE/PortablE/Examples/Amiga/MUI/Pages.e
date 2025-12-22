/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/mui36dev-E */

/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

OPT PREPROCESS, POINTER

/*
** Loading the needed MODULEs
*/

MODULE 'exec'
MODULE 'tools/domethod'
MODULE 'muimaster', 'libraries/mui'
MODULE 'utility/tagitem', 'utility/hooks'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'libraries/gadtools'

TYPE PTIO IS PTR TO INTUIOBJECT

ENUM ER_NON, ER_MUILIB, ER_APP          /* for the exception handling */
 
/*
** DEFining the var s
*/

DEF app:PTIO, window:PTIO
DEF sex, pages, races, classes


/*
** main()
*/

PROC main()

DEF signal, running, result

/*
** Open the muimaster.library
*/
   sex := ['male','female',NIL]
   pages := ['Race','Class','Armor','Level',NIL]
   races := ['Human','Elf','Dwarf','Hobbit','Gnome',NIL]
   classes := ['Warrior','Rogue','Bard','Monk','Magician','Archmage',NIL]

   IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

    app := ApplicationObject,
      MUIA_Application_Title      , 'Pages-Demo',
      MUIA_Application_Version    , '$VER: Pages-Demo 10.11 (23.12.94)',
      MUIA_Application_Copyright  , ' 1992/93, Stefan Stuntz',
      MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
      MUIA_Application_Description, 'Show MUIs Page Groups',
      MUIA_Application_Base       , 'PAGESDEMO',
      SubWindow, window := WindowObject,
        MUIA_Window_Title, 'Character Definition',
        MUIA_Window_ID   , "PAGE",
        WindowContents, VGroup,
          Child, ColGroup(2),
            Child, Label2('Name:'), Child, StringMUI('Frodo',32),
            Child, Label1('Sex:' ), Child, Cycle(sex),
          End,
          Child, VSpace(2),
          Child, RegisterGroup(pages),
            MUIA_Register_Frame, MUI_TRUE,
            Child, HCenter(Radio(NIL,races)),
            Child, HCenter(Radio(NIL,classes)),
            Child, HGroup,
              Child, HSpace(0),
              Child, ColGroup(2),
                Child, Label1('Cloak:' ), Child, CheckMark(MUI_TRUE),
                Child, Label1('Shield:'), Child, CheckMark(MUI_TRUE),
                Child, Label1('Gloves:'), Child, CheckMark(MUI_TRUE),
                Child, Label1('Helmet:'), Child, CheckMark(MUI_TRUE),
              End,
              Child, HSpace(0),
            End,
            Child, ColGroup(2),
              Child, Label('Experience:'  ), Child, Slider(0,100, 3),
              Child, Label('Strength:'    ), Child, Slider(0,100,42),
              Child, Label('Dexterity:'   ), Child, Slider(0,100,24),
              Child, Label('Condition:'   ), Child, Slider(0,100,39),
              Child, Label('Intelligence:'), Child, Slider(0,100,74),
            End,
          End,
        End,
      End,
    End


  IF app=NIL THEN Raise(ER_APP)

/*
** Closing the master window forces a complete shutdown of the application.
*/

   doMethod(window, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** Everything's ready, lets launch the application. We will
** open the master window now.
*/

   set(window, MUIA_Window_Open,MUI_TRUE)


/*
** This is the main loop. As you can see, it does just nothing.
** Everything is handled by MUI, no work for the programmer.
**
** The only thing we do here is to react on a double click
** in the volume list (which causes an ID_NEWVOL) by setting
** a new directory name for the directory list. If you want
** to see a real file requester with MUI, wait for the
** next release of MFR :-)
*/


   running := TRUE  

   WHILE running

      result := doMethod(app, [MUIM_Application_Input, ADDRESSOF signal])

      SELECT result

        CASE MUIV_Application_ReturnID_Quit
        running := FALSE

      ENDSELECT

      IF signal THEN Wait(signal)

   ENDWHILE

/*
** Call the exception handling with ER_NON, this will dispose the
** application object, close "muimaster.library" and end the program.
*/

FINALLY
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  
  SELECT exception
    CASE ER_MUILIB
      Print('Failed to open \s.\n', MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      Print('Failed to create application.\n')
      CleanUp(20)
      
  ENDSELECT
ENDPROC 0


/*
** This is the end...
*/
