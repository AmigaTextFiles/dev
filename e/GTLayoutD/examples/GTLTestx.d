// a simple gtlayout button in a window

MODULE 'gadtools', 'gtlayout', 'libraries/gadtools', 'libraries/gtlayout'

ENUM NOERROR,ERROR
CONST NULL=0, TRUE=1

DEF Window:PTR TO Window,
    Handle:PTR TO LayoutHandle,
    GTLayoutBase:PTR TO Lib,
    GadToolsBase:PTR TO Lib

PROC OpenAll()(LONG)
  IFN GadToolsBase:=OpenLibrary('gadtools.library',40) THEN RETURN ERROR
  IFN GTLayoutBase:=OpenLibrary('gtlayout.library',41) THEN RETURN ERROR

  IFN Handle:=LT_CreateHandleTags(NULL, LAHN_AutoActivate, TRUE, TAG_DONE) THEN RETURN ERROR

  LT_New(Handle, LA_Type, HORIZONTAL_KIND, LA_LabelText, ' A small example ', TAG_DONE)
  LT_New(Handle, LA_Type, BUTTON_KIND, LABT_ExtraFat, TRUE, LA_LabelText, ' A Button ', LA_ID, 5, TAG_DONE)
  LT_New(Handle, LA_Type, TAG_END)
//  LT_EndGroup(Handle)

  IFN Window := LT_Build(Handle,
    LAWN_Title, 'Title',
    LAWN_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_GADGETDOWN | IDCMP_GADGETUP,
    LAWN_Zoom, TRUE,
    LAHN_ExactClone, TRUE,
    WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET | WFLG_ACTIVATE,
    WA_AutoAdjust, TRUE,
    WA_SmartRefresh, TRUE,
    WA_CloseGadget, TRUE,
    TAG_DONE) THEN RETURN ERROR
ENDPROC NOERROR

PROC CloseAll()
//  IF Window THEN CloseWindow(Window) ELSE PrintF('Unable to open window!\n')
  IF Handle THEN LT_DeleteHandle(Handle) ELSE PrintF('Unable to create a handle!\n')
  IF GTLayoutBase THEN CloseLibrary(GTLayoutBase) ELSE PrintF('Unable to open gtlayout.library v41+!\n')
  IF GadToolsBase THEN CloseLibrary(GadToolsBase) ELSE PrintF('Unable to open gadtools.library v40+!\n')
ENDPROC

PROC main()
  IF OpenAll() THEN Raise()
  WaitPort(Window.UserPort)
  Delay(100)
  Raise()
EXCEPT
  CloseAll()
ENDPROC
