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

MODULE 'exec'
MODULE 'AmigaLib/boopsi'
MODULE 'utility/tagitem'
MODULE 'muimaster','libraries/mui','libraries/muip',
       'intuition/classes','intuition/classusr'

TYPE PTIO IS PTR TO INTUIOBJECT
       
DEF obj:PTIO
DEF bt[5]:ARRAY OF PTIO, gr:PTIO, pcy:PTIO, pgr:PTIO
DEF text[4]:ARRAY OF ARRAY OF CHAR,
    cya_computer:PTIO, cya_printer:PTIO, cya_display:PTIO,
    cy_computer:PTIO, cy_printer:PTIO, cy_display:PTIO,
    mt_computer:PTIO, mt_printer:PTIO, mt_display:PTIO,
    lv_computer:PTIO,
    bt_button[12]:ARRAY OF PTIO,
    x4sex:PTIO, x4pages:PTIO, x4classes:PTIO, x4weapons:PTIO, x4races:PTIO

#define img(nr)  ImageObject, MUIA_Image_Spec, nr, End

#define mytxt(txt) TextObject,\
    MUIA_Text_Contents,txt,\
    MUIA_Text_SetMax, MUI_TRUE,\
    End

#define ibt(i) ImageObject,\
    ImageButtonFrame,\
    MUIA_Background, MUII_ButtonBack,\
    MUIA_InputMode , MUIV_InputMode_RelVerify,\
    MUIA_Image_Spec, i,\
    End

PROC makePage1()
  text[1] := '\eiHello User !\en\n\n' +
          'This could be a very long text and you are looking\n' +
          'at it through a \euvirtual group\en. Please use the\n' +  
          'scrollbars at the right and bottom of the group to\n' +
          'move the visible area either vertically or\n' +
          'horizontally. While holding down the small arrow\n' +
          'button between both scrollbars, the display will\n' +
          'follow your mouse moves.\n\n' +
          'If you click somewhere into a \euvirtual group\en and\n' +
          'move the mouse across one of its borders, the group will\n' +
          'start scrolling. If you are lucky and own a middle mouse\n' +
          'button, you may also want to press it and try moving.\n' +
          '\n' +
          'Note to 7MHz/68000 users: Sorry if you find this\n' +
          'thingy a bit slow. Clipping in virtual groups can\n' +
          'get quite complicated. Please don\at blame me,\n' +
          'blame your \aout of date\a machine! :-)\n\n' +
          '\ei\ecHave fun, Stefan.\en'

  obj := ScrollgroupObject, MUIA_Scrollgroup_UseWinBorder, MUI_TRUE,
    MUIA_Scrollgroup_Contents, VirtgroupObject,
      VirtualFrame,
      Child, TextObject,
        MUIA_Background, MUII_TextBack,
        MUIA_Text_Contents, text[1],
      End,
    End,
  End
ENDPROC obj

PROC makePage2()
  text[2] := '\ecAs you can see, this virtual group contains a\n'+
          'lot of different objects. The (virtual) width\n'+
          'and height of the virtual group are automatically\n'+
          'calculated from the default width and height of\n'+
          'the virtual groups contents.'

  obj := ScrollgroupObject,
    MUIA_UserData, 42,
    MUIA_Scrollgroup_Contents, VGroupV, VirtualFrame,
      MUIA_UserData, 42,
      Child, TextObject,
        TextFrame,
        MUIA_Background, MUII_TextBack,
        MUIA_Text_Contents, text[2],
      End,
      Child, HGroup,
        Child, ColGroup(2), GroupFrameT('Standard Images'),
          Child, Label('ArrowUp:'    ), Child, img(MUII_ArrowUp    ),
          Child, Label('ArrowDown:'  ), Child, img(MUII_ArrowDown  ),
          Child, Label('ArrowLeft:'  ), Child, img(MUII_ArrowLeft  ),
          Child, Label('ArrowRight:' ), Child, img(MUII_ArrowRight ),
          Child, Label('RadioButton:'), Child, img(MUII_RadioButton),
          Child, Label('File:'       ), Child, img(MUII_PopFile    ),
          Child, Label('HardDisk:'   ), Child, img(MUII_HardDisk   ),
          Child, Label('Disk:'       ), Child, img(MUII_Disk       ),
          Child, Label('Chip:'       ), Child, img(MUII_Chip       ),
          Child, Label('Drawer:'     ), Child, img(MUII_Drawer     ),
        End,
        Child, VGroup, GroupFrameT('Some Backgrounds'),
          Child, HGroup,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_BACKGROUND , MUIA_FixWidth, 30, End,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_FILL       , MUIA_FixWidth, 30, End,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOW     , MUIA_FixWidth, 30, End,
          End,
          Child, HGroup,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOWBACK , MUIA_FixWidth, 30, End,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOWFILL , MUIA_FixWidth, 30, End,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOWSHINE, MUIA_FixWidth, 30, End,
          End,
          Child, HGroup,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_FILLBACK   , MUIA_FixWidth, 30, End,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHINEBACK  , MUIA_FixWidth, 30, End,
            Child, RectangleObject, TextFrame, MUIA_Background, MUII_FILLSHINE  , MUIA_FixWidth, 30, End,
          End,
        End,
      End,
      Child, ColGroup(2), GroupFrame,
        Child, Label1('Gauge:'), Child, GaugeObject, GaugeFrame, MUIA_Gauge_Current, 66, MUIA_Gauge_Horiz, TRUE, End,
        Child, VSpace(0)       , Child, ScaleObject, End,
      End,
    End,
  End
ENDPROC obj

PROC makePage3()
  text[3] := '\ecThe above pages only showed \aread only\a groups,\n' +
         'no user actions within them were possible. Of course,\n' +
         'handling user actions in a virtual group is not a\n' +
         'problem for MUI. As I promised on the first page,\n' +
         'you can use virtual groups with whatever objects\n' +
         'you want. Here\as a small example...\n' +
         '\n' +
         'Note: Due to some limitations of the operating system,\n' + 
         'it is not possible to clip gadgets depending on\n' +
         'intuition.library correctly. This affects the appearence\n' +
         'of string and proportional objects in virtual groups.\n' +
         'You will only be able to use these gadgets when they\n' +
         'are completely visible.\n' +
         '\n' +
         'PS: Also try TAB cycling here!'

  cya_computer := ['Amiga 500','Amiga 600','Amiga 1000 :)','Amiga 1200','Amiga 2000','Amiga 3000','Amiga 4000', 'Amiga 4000T', 'Atari ST :(', NIL]
  cya_printer := ['HP Deskjet','NEC P6','Okimate 20',NIL]
  cya_display := ['A1081','NEC 3D','A2024','Eizo T660i',NIL]

  obj := ScrollgroupObject,
    MUIA_Scrollgroup_Contents, VGroupV, VirtualFrame,
      Child, TextObject,
        TextFrame,
        MUIA_Background, MUII_TextBack,
        MUIA_Text_Contents, text[3],
      End,
      Child, VGroup,
        Child, HGroup,
          Child, mt_computer := Radio('Computer:',cya_computer),
          Child, VGroup,
            Child, mt_printer := Radio('Printer:',cya_printer),
            Child, VSpace(0),
            Child, mt_display := Radio('Display:',cya_display),
          End,
          Child, VGroup,
            Child, ColGroup(2), GroupFrameT('Cycle Gadgets'),
              Child, KeyLabel1('Computer:',"c"), Child, cy_computer := KeyCycle(cya_computer,"c"),
              Child, KeyLabel1('Printer:' ,"p"), Child, cy_printer  := KeyCycle(cya_printer ,"p"),
              Child, KeyLabel1('Display:' ,"d"), Child, cy_display  := KeyCycle(cya_display ,"d"),
            End,
            Child, lv_computer := ListviewObject,
              MUIA_Listview_Input, MUI_TRUE,
              MUIA_Listview_List, ListObject, InputListFrame, End,
            End,
          End,
        End,
        Child, ColGroup(4), GroupFrameT('Button Field'),
          Child, bt_button[0]  := SimpleButton('Button'),
          Child, bt_button[1]  := SimpleButton('Button'),
          Child, bt_button[2]  := SimpleButton('Button'),
          Child, bt_button[3]  := SimpleButton('Button'),
          Child, bt_button[4]  := SimpleButton('Button'),
          Child, bt_button[5]  := SimpleButton('Button'),
          Child, bt_button[6]  := SimpleButton('Button'),
          Child, bt_button[7]  := SimpleButton('Button'),
          Child, bt_button[8]  := SimpleButton('Button'),
          Child, bt_button[9]  := SimpleButton('Button'),
          Child, bt_button[10] := SimpleButton('Button'),
          Child, bt_button[11] := SimpleButton('Button'),
        End,
      End,
    End,
  End

  IF lv_computer THEN doMethodA(lv_computer, [MUIM_List_Insert, cya_computer,-1,MUIV_List_Insert_Bottom])
ENDPROC obj

PROC makePage4()
  
  x4sex := ['male','female',NIL]
  x4pages := ['Race','Class','Armors','Weapons','Levels',NIL]
  x4races := ['Human','Elf','Dwarf','Hobbit','Gnome',NIL]
  x4classes := ['Warrior','Rogue','Bard','Monk','Magician','Archmage',NIL]
  x4weapons := ['Staff','Dagger','Sword','Axe','Grenade',NIL]

  obj := ScrollgroupObject,
    MUIA_Scrollgroup_Contents, ColGroupV(3), VirtualFrame,
      MUIA_Group_Spacing, 10,
      Child, VGroup, GroupFrame,
        Child, HGroup,
          Child, HSpace(0),
          Child, bt[1] := ibt(MUII_ArrowUp),
          Child, HSpace(0),
        End,
        Child, HGroup,
          Child, bt[2] := ibt(MUII_ArrowLeft),
          Child, bt[3] := ibt(MUII_ArrowRight),
        End,
        Child, HGroup,
          Child, HSpace(0),
          Child, bt[4] := ibt(MUII_ArrowDown),
          Child, HSpace(0),
        End,
      End,
      Child, mytxt('\ecEver wanted to see\na virtual group in\na virtual group?'),
      Child, HVSpace,
      Child, mytxt('\ecHere it is!'),
      Child, ScrollgroupObject,
        MUIA_Scrollgroup_Contents, gr := VGroupV, VirtualFrame,
          Child, ColGroup(6), MUIA_Group_SameSize, MUI_TRUE,
            Child, SimpleButton('One'),
            Child, SimpleButton('Two'),
            Child, SimpleButton('Three'),
            Child, SimpleButton('Four'),
            Child, SimpleButton('Five'),
            Child, SimpleButton('Six'),
            Child, SimpleButton('Eighteen'),
            Child, mytxt('\ecThe'),
            Child, mytxt('\ecred'),
            Child, mytxt('\ecbrown'),
            Child, mytxt('\ecfox'),
            Child, SimpleButton('Seven'),
            Child, SimpleButton('Seventeen'),
            Child, mytxt('\ecdog.'),
            Child, SimpleButton('Nineteen'),
            Child, SimpleButton('Twenty'),
            Child, mytxt('\ecjumps'),
            Child, SimpleButton('Eight'),
            Child, SimpleButton('Sixteen'),
            Child, mytxt('\eclazy'),
            Child, mytxt('\ecthe'),
            Child, mytxt('\ecover'),
            Child, mytxt('\ecquickly'),
            Child, SimpleButton('Nine'),
            Child, SimpleButton('Fifteen'),
            Child, SimpleButton('Fourteen'),
            Child, SimpleButton('Thirteen'),
            Child, SimpleButton('Twelve'),
            Child, SimpleButton('Eleven'),
            Child, SimpleButton('Ten'),
          End,
        End,
      End,
      Child, mytxt('\ecDo you like it? I hope...'),
      Child, HVSpace,
      Child, mytxt('\ecI admit, it\as a\n bit crazy... :-)\nBut it demonstrates\nthe power of\n\ebobject oriented\en\nGUI design.'),
      Child, ScrollgroupObject,
        MUIA_Scrollgroup_Contents, VGroupV, VirtualFrame, InnerSpacing(4,4),
          Child, VGroup,
            Child, pcy := Cycle(x4pages),
            Child, pgr := PageGroup,
              Child, HCenter(Radio(NIL,x4races)),
              Child, HCenter(Radio(NIL,x4classes)),
              Child, HGroup,
                Child, HSpace(0),
                Child, ColGroup(2),
                  Child, Label1('Cloak:' ), Child, CheckMark(MUI_TRUE),
                  Child, Label1('Shield:'), Child, CheckMark(MUI_TRUE),
                  Child, Label1('Gloves:'), Child, CheckMark(MUI_TRUE),
                  Child, Label1('Helm:'  ), Child, CheckMark(MUI_TRUE),
                End,
                Child, HSpace(0),
              End,
              Child, HCenter(Radio(NIL,x4weapons)),
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
      End,
    End,
  End

  IF obj
    doMethodA(bt[1], [MUIM_Notify, MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Top ,0])
    doMethodA(bt[2], [MUIM_Notify, MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Left,0])
    doMethodA(bt[3], [MUIM_Notify, MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Left,9999])
    doMethodA(bt[4], [MUIM_Notify, MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Top ,9999])
    doMethodA(pcy, [MUIM_Notify, MUIA_Cycle_Active,MUIV_EveryTime,
      pgr,3,MUIM_Set,MUIA_Group_ActivePage,MUIV_TriggerValue])
  ENDIF

ENDPROC obj

PROC main()
  DEF app:PTIO, window:PTIO, sigs

  IF (muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN Throw("ERR", 'Failed to open muimaster.library')

  app := ApplicationObject,
    MUIA_Application_Title      , 'VirtualDemo',
    MUIA_Application_Version    , '$VER: VirtualDemo 13.59 (30.01.96)',
    MUIA_Application_Copyright  , 'c1993, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Show virtual groups.',
    MUIA_Application_Base       , 'VIRTUALDEMO',
    SubWindow, window := WindowObject,
      MUIA_Window_Title, 'Virtual Groups',
      MUIA_Window_ID   , "VIRT",
      MUIA_Window_UseRightBorderScroller, MUI_TRUE,
      MUIA_Window_UseBottomBorderScroller, MUI_TRUE,
      WindowContents, ColGroup(2), GroupSpacing(8),
        Child, makePage1(),
        Child, makePage2(),
        Child, makePage3(),
        Child, makePage4(),
      End,
    End,
  End

  IF app=NIL THEN Throw("ERR", 'Failed to create Application.')

  doMethodA(window, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  doMethodA(window, [MUIM_Window_SetCycleChain,
    mt_computer,mt_printer,mt_display,
    cy_computer,cy_printer,cy_display,
    lv_computer,
    bt_button[0],bt_button[1],bt_button[2],bt_button[3],
    bt_button[4],bt_button[5],bt_button[6],bt_button[7],
    bt_button[8],bt_button[9],bt_button[10],bt_button[11],
    NIL])

/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

  set(window, MUIA_Window_Open,MUI_TRUE)
  
  sigs := 0
  WHILE (doMethodA(app, [MUIM_Application_NewInput, ADDRESSOF sigs]) <> MUIV_Application_ReturnID_Quit)
    IF sigs THEN sigs := Wait(sigs)
  ENDWHILE

  set(window, MUIA_Window_Open,FALSE)

FINALLY
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exceptionInfo THEN Print('\s\n', exceptionInfo)
ENDPROC
