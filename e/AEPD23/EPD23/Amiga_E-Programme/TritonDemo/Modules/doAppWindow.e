/* MAC2E triton.macros */
OPT PREPROCESS
OPT MODULE
OPT EXPORT
OPT OSVERSION=37,
    REG=5


-> TRITON defs
#define CenteredText(text)      HorizGroupSC,Space,TextN(text),Space,EndGroup
#define DropBox(id)             TROB_DROPBOX,NIL,TRAT_ID,(id)
#define EndGroup                TRGR_END,NIL
#define EndProject              TAG_END
#define HorizGroupA             TRGR_HORIZ,TRGR_ALIGN
#define HorizGroupSC            TRGR_HORIZ,TRGR_PROPSPACES OR TRGR_CENTER
#define Space                   TROB_SPACE,TRST_NORMAL
#define SpaceS                  TROB_SPACE,TRST_SMALL
#define TextN(text)             TROB_TEXT,NIL,TRAT_TEXT,text
#define VertGroupA              TRGR_VERT,TRGR_ALIGN
#define WindowID(id)            TRWI_ID,(id)
#define WindowPosition(pos)     TRWI_POSITION,(pos)
#define WindowTitle(t)          TRWI_TITLE,(t)

-> TRITON defs

MODULE 'triton',
       'libraries/triton',
       'utility/tagitem',
       'workbench/startup',
       'workbench/workbench'

MODULE '*global'

DEF mainApp:PTR TO tr_App,
    mainProject:PTR TO tr_Project

PROC doAppWindow()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, appwindowProject:PTR TO tr_Project,
      reqstr[200]:STRING, dirname[100]:ARRAY, appwindowTrWinTags, class,
      data:PTR TO appmessage, id, i, c
  appwindowTrWinTags:=[WindowID(8), WindowTitle('AppWindow'),
                       WindowPosition(TRWP_CENTERDISPLAY),
    VertGroupA,
      Space,  CenteredText('This window is an application window.'),
      SpaceS, CenteredText('Drop icons into the window or into'),
      SpaceS, CenteredText('the icon drop boxes below and see'),
      SpaceS, CenteredText('what will happen...'),
      Space,  HorizGroupA,
                Space, DropBox(1),
                Space, DropBox(2),
                Space, EndGroup,
      Space, EndGroup, EndProject]
  IF appwindowProject:=Tr_OpenProject(mainApp, appwindowTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=appwindowProject
          class:=trmsg.class
          data:=trmsg.data
          id:=trmsg.id
          SELECT class
            CASE TRMS_CLOSEWINDOW; closeProject:=TRUE
            CASE TRMS_ERROR;       WriteF('\s\n', Tr_GetErrorString(data))
            CASE TRMS_ICONDROPPED
              dirname[0]:=0
              NameFromLock(data.arglist::wbarg.lock, dirname, 100)
              AddPart(dirname, data.arglist::wbarg.name, 100)
              SELECT id
                CASE 1
                  StringF(reqstr, 'Icon(s) dropped into the left box.\tName of first dropped icon:\n\s', dirname)
                CASE 2
                  StringF(reqstr, 'Icon(s) dropped into the right box.\tName of first dropped icon:\n\s', dirname)
                DEFAULT
                  StringF(reqstr, 'Icon(s) dropped into the window.\tName of first dropped icon:\n\s', dirname)
              ENDSELECT
              Tr_EasyRequest(mainApp, reqstr, '_Ok',
                             [TREZ_LOCKPROJECT, appwindowProject,
                              TREZ_TITLE,       'AppWindow report',
                              TREZ_ACTIVATE,    TRUE,
                              TAG_END])
          ENDSELECT
        ENDIF
        Tr_ReplyMsg(trmsg)
      ENDWHILE
    ENDWHILE
    Tr_UnlockProject(mainProject)
    Tr_CloseProject(appwindowProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
