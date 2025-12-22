/*
    Busy.mcc (c) 1994-96 by kmel, Klaus Melchior
    Example for Busy.mcc
    show_busy.c converted into AmigaE by Ralph Wermke
    <wermke@gryps1.rz.uni-greifswald.de>

*/

OPT PREPROCESS

/*** includes ***/

MODULE  'mui/busy_mcc','libraries/mui','muimaster',
        'utility/tagitem','tools/boopsi','amigalib/boopsi'

RAISE   "LIB"   IF  OpenLibrary()=0

/*** main ***/
PROC main() HANDLE
DEF app=NIL, window, bt_move, by_move, signals, running=TRUE, result

muimasterbase:=OpenLibrary('muimaster.library',11)

app := ApplicationObject,
    MUIA_Application_Title      , 'Show_BusyClass',
    MUIA_Application_Version    , 'BusyDemo 1.0 (18.02.96)',
    MUIA_Application_Copyright  , '©1993-96, kMel Klaus Melchior',
    MUIA_Application_Author     , 'Klaus Melchior',
    MUIA_Application_Description, 'Demonstrates the busy class.',
    MUIA_Application_Base       , 'SHOWBUSY',
    SubWindow, window:= WindowObject,
      MUIA_Window_Title, 'BusyClass',
      MUIA_Window_ID   , "BUSY",
      WindowContents, VGroup,

        /*** create a busy bar with a gaugeframe ***/

        Child, Mui_MakeObjectA(MUIO_BarTitle,['Speed: 20']),
        Child, BusyObject,
          MUIA_Busy_Speed, 20,
        End,

        Child, VSpace(8),
        Child, Mui_MakeObjectA(MUIO_BarTitle,['Speed: User']),
        Child, BusyBar,

        Child, VSpace(8),
        Child, Mui_MakeObjectA(MUIO_BarTitle,['Speed: Manually']),
        Child, by_move := BusyObject,
          MUIA_Busy_Speed, MUIV_Busy_Speed_Off,
        End,
        Child, bt_move := KeyButton('Move ...', "m"),

    End,
  End,
End

IF app=NIL
  WriteF('Failed to create Application.\n')
  Raise("MUIO")
ENDIF

/*** generate notifies ***/

domethod(window, [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE, app, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit])
domethod(bt_move, [MUIM_Notify, MUIA_Timer, MUIV_EveryTime, by_move, 2, MUIM_Busy_Move, MUI_TRUE])

/*** ready to open the window ... ***/

set(window,MUIA_Window_Open,MUI_TRUE)

WHILE running
  result:=doMethodA(app, [MUIM_Application_Input,{signals}])
  SELECT result
    CASE MUIV_Application_ReturnID_Quit;    running := FALSE;
  ENDSELECT
  IF signals THEN Wait(signals)
ENDWHILE

set(window, MUIA_Window_Open, FALSE);

/*** shutdown ***/

EXCEPT DO
    IF app THEN Mui_DisposeObject(app)        /* dispose all objects. */
    IF muimasterbase THEN CloseLibrary(muimasterbase)
ENDPROC 0
