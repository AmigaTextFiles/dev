->
->  Original C Code by Calogero Cali
->
->  Translation into E by Andrew Cashmore
->

OPT PREPROCESS

MODULE 'amigalib/boopsi',
       'muimaster', 
       'libraries/mui',
       'utility/tagitem', 
       'mui/pkb_mcc'

ENUM ER_NON, ER_MUILIB, ER_APP
ENUM ID_DISPLAY=1,ID_EDIT,ID_DELETE,ID_SAVE 

PROC main() HANDLE

DEF cy_0,cy_2,cy_1
DEF app,wi_Browser,cq,cr,sl,sl1,sl2,sl3,slA,slB,but1,but2,cx,ch,ottava
DEF running=TRUE,signal,result

cy_0:=['NORMAL','RANGE','SPECIAL',NIL]
cy_1:=['HEAD OFF','HEAD TOP','HEAD BOOT',NIL]
cy_2:=['QUIET OFF','QUIET ON',NIL]

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

  app := ApplicationObject,
    MUIA_Application_Title      , 'Keyboard',
    MUIA_Application_Version    , '$VER: Keybard 0.001 (17-Jan-1999)',
    MUIA_Application_Copyright  , '© 1999 Calogero Cali',
    MUIA_Application_Author     , 'Calogero Cali (E conversion by Andrew Cashmore)',
    MUIA_Application_Description, 'Keyboard custom class',
    MUIA_Application_Base       , 'Keyboard',
    SubWindow, wi_Browser:= WindowObject,
      MUIA_Window_ID, "CLS1",
      MUIA_Window_Title, 'Keyboard custom class',
      WindowContents, VGroup,
              Child, ColGroup(2),
                Child, cq:=Cycle(cy_2),
                Child, cr:=SimpleButton('Refresh'),
              End,
              Child, ColGroup(2),
                Child, ColGroup(2),
                  Child, CLabel('KeyRelease'),  Child,  sl:=Slider(0,131,0),
                  Child, CLabel('KeyCurrent'),  Child,  sl1:=Slider(0,131,0),
                  Child, CLabel('From'),        Child,  sl2:=Slider(0,131,0),
                  Child, CLabel('To'),          Child,  sl3:=Slider(0,131,0),
                End,
                Child, ColGroup(2),
                  Child, CLabel('Down'),       
                  Child,  slA:=Slider(0,131,0),
                  Child, CLabel('Up'),         
                  Child,  slB:=Slider(0,131,0),
                End,
            End,
            Child, HGroup,
                GroupFrame,
                MUIA_Group_HorizSpacing, 2,
                Child,but1:=SimpleButton('Reset'),
                Child,but2:=SimpleButton('Range 12~24'),
                Child,  cx:=Cycle(cy_0),
                Child,  ch:=Cycle(cy_1),
            End,

            Child, ScrollgroupObject,
                MUIA_Scrollgroup_FreeVert,FALSE,
                MUIA_Scrollgroup_Contents, ottava:=PkbObject,
                    VirtualFrame,
                    MUIA_Background, MUII_BACKGROUND,
                    MUIA_Pkb_Octv_Start, 1,
                    MUIA_Pkb_Octv_Range, 10,
                    MUIA_Pkb_Octv_Name,1,
                    MUIA_Pkb_Octv_Base, 0,
                End,
              End,
           End,
       End,
    End

  IF app=NIL THEN Raise(ER_APP)

  doMethodA(wi_Browser,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
  doMethodA(cx,        [MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,ottava,3,MUIM_Set,MUIA_Pkb_Mode,MUIV_TriggerValue])
  doMethodA(ch,        [MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,ottava,3,MUIM_Set,MUIA_Pkb_Mode,MUIV_TriggerValue])
  doMethodA(cq,        [MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,ottava,3,MUIM_Set,MUIA_Pkb_Quiet,MUIV_TriggerValue])
  doMethodA(cr,        [MUIM_Notify,MUIA_Pressed,FALSE,ottava,1,MUIM_Pkb_Refresh])
  doMethodA(but1,      [MUIM_Notify,MUIA_Pressed,FALSE,ottava,1,MUIM_Pkb_Reset])
  doMethodA(but2,      [MUIM_Notify,MUIA_Pressed, FALSE, ottava,3,MUIM_Pkb_Range,24,12])
  doMethodA(slA,       [MUIM_Notify,MUIA_Numeric_Value, MUIV_EveryTime,ottava,3,MUIM_Set,MUIA_Pkb_Key_Press,MUIV_TriggerValue])
  doMethodA(slB,       [MUIM_Notify,MUIA_Numeric_Value, MUIV_EveryTime,ottava,3,MUIM_Set,MUIA_Pkb_Key_Release,MUIV_TriggerValue])
  doMethodA(ottava,    [MUIM_Notify,MUIA_Pkb_Key_Release, MUIV_EveryTime,sl, 3,MUIM_Set,MUIA_Numeric_Value,MUIV_TriggerValue])
  doMethodA(ottava,    [MUIM_Notify,MUIA_Pkb_Current,    MUIV_EveryTime,sl1,3, MUIM_Set,MUIA_Numeric_Value,MUIV_TriggerValue])
  doMethodA(ottava,    [MUIM_Notify,MUIA_Pkb_Range_Start,MUIV_EveryTime, sl2,3, MUIM_Set,MUIA_Numeric_Value,MUIV_TriggerValue])
  doMethodA(ottava,    [MUIM_Notify,MUIA_Pkb_Range_End,  MUIV_EveryTime,sl3,3,MUIM_Set,MUIA_Numeric_Value,MUIV_TriggerValue])

  set(wi_Browser,MUIA_Window_Open,MUI_TRUE)

    WHILE running
      result:= doMethodA(app,[MUIM_Application_Input,{signal}])
        SELECT result
               CASE MUIV_Application_ReturnID_Quit
                    running:=FALSE
         ENDSELECT

      IF (running AND signal) THEN Wait(signal)
    ENDWHILE

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  
  SELECT exception
    CASE ER_MUILIB
      WriteF('Failed to open \s.\n',MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      WriteF('Failed to create application.\n')
      CleanUp(20)
      
  ENDSELECT
ENDPROC 0
