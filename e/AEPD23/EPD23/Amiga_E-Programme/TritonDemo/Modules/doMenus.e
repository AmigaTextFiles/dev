/* MAC2E triton.macros */
OPT PREPROCESS
OPT MODULE
OPT EXPORT
OPT OSVERSION=37,
    REG=5

-> TRITON defs
#define WindowID(id)            TRWI_ID,(id)
#define WindowPosition(pos)     TRWI_POSITION,(pos)
#define WindowTitle(t)          TRWI_TITLE,(t)
-> TRITON defs

MODULE 'triton',
       'libraries/triton',
       'utility/tagitem'

MODULE '*global'

DEF mainApp:PTR TO tr_App,
    mainProject:PTR TO tr_Project

PROC doMenus()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, menusProject:PTR TO tr_Project,
      menusTrWinTags, class
  menusTrWinTags:=[WindowID(2), WindowTitle('Menus'),
    TRMN_TITLE,                 'A menu',
     TRMN_ITEM,                 'A simple item', TRAT_ID, 1,
     TRMN_ITEM,                 'Another item', TRAT_ID, 2,
     TRMN_ITEM,                 'And now... a barlabel', TRAT_ID, 3,
     TRMN_ITEM,                 TRMN_BARLABEL,
     TRMN_ITEM,                 '1_An item with a shortcut', TRAT_ID, 4,
     TRMN_ITEM,                 '2_Another one', TRAT_ID, 5,
     TRMN_ITEM,                 '3_And number 3', TRAT_ID, 6,
     TRMN_ITEM,                 TRMN_BARLABEL,
     TRMN_ITEM,                 '_F1_And under OS3.0: Extended command keys', TRAT_ID, 6,
     TRMN_ITEM,                 '_F2_Another one', TRAT_ID, 7,
     TRMN_ITEM,                 TRMN_BARLABEL,
     TRMN_ITEM,                 'How do you like submenus?',
      TRMN_SUB,                 'G_Great!', TRAT_ID, 8,
      TRMN_SUB,                 'F_Fine', TRAT_ID, 9,
      TRMN_SUB,                 'D_Don''t know', TRAT_ID, 10,
      TRMN_SUB,                 'N_Not so fine', TRAT_ID, 11,
      TRMN_SUB,                 'P_Puke!', TRAT_ID, 12,
    TRMN_TITLE,                 'Another menu',
     TRMN_ITEM,                 'This item is ghosted', TRMN_FLAGS, TRMF_DISABLED, TRAT_ID, 100,
     TRMN_ITEM,                 TRMN_BARLABEL,
     TRMN_ITEM,                 'Item 1 is checked', TRMN_FLAGS, TRMF_CHECKED, TRAT_ID, 13,
     TRMN_ITEM,                 'Item 2 can be checked, too', TRMN_FLAGS, TRMF_CHECKIT, TRAT_ID, 14,
    TRMN_TITLE,                 'Ghosted menu',
    TRMN_FLAGS,                 TRMF_DISABLED,
     TRMN_ITEM,                 'Item 1', TRAT_ID, 101,
     TRMN_ITEM,                 'Item 2', TRAT_ID, 102,
    TAG_END]
  IF menusProject:=Tr_OpenProject(mainApp, menusTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=menusProject
          class:=trmsg.class
          SELECT class
            CASE TRMS_CLOSEWINDOW; closeProject:=TRUE
            CASE TRMS_ERROR;       WriteF('\s\n', Tr_GetErrorString(trmsg.data))
            CASE TRMS_NEWVALUE;    WriteF('The new value of object \d is \d.\n',trmsg.id,trmsg.data)
            CASE TRMS_ACTION;      WriteF('Object \d has triggered an action.\n',trmsg.id)
          ENDSELECT
        ENDIF
        Tr_ReplyMsg(trmsg)
      ENDWHILE
    ENDWHILE
    Tr_UnlockProject(mainProject)
    Tr_CloseProject(menusProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
