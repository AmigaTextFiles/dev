/* MAC2E triton.macros */
OPT PREPROCESS
OPT MODULE
OPT EXPORT
OPT OSVERSION=37,
    REG=5

-> TRITON defs
#define CenteredInteger(i)      HorizGroupSC,Space,Integer(i),Space,EndGroup
#define CenteredText(text)      HorizGroupSC,Space,TextN(text),Space,EndGroup
#define CenteredText3(text)     HorizGroupSC,Space,Text3(text),Space,EndGroup
#define CenteredTextB(text)     HorizGroupSC,Space,TextB(text),Space,EndGroup
#define CenteredTextH(text)     HorizGroupSC,Space,TextH(text),Space,EndGroup
#define EndGroup                TRGR_END,NIL
#define EndProject              TAG_END
#define HorizGroupSC            TRGR_HORIZ,TRGR_PROPSPACES OR TRGR_CENTER
#define Integer(i)              TROB_TEXT,NIL,TRAT_VALUE,(i)
#define Space                   TROB_SPACE,TRST_NORMAL
#define Text3(text)             TROB_TEXT,NIL,TRAT_TEXT,text,TRAT_FLAGS,TRTX_3D
#define TextB(text)             TROB_TEXT,NIL,TRAT_TEXT,text,TRAT_FLAGS,TRTX_BOLD
#define TextH(text)             TROB_TEXT,NIL,TRAT_TEXT,text,TRAT_FLAGS,TRTX_HIGHLIGHT
#define TextN(text)             TROB_TEXT,NIL,TRAT_TEXT,text
#define VertGroupA              TRGR_VERT,TRGR_ALIGN
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

PROC doText()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, textProject:PTR TO tr_Project, textTrWinTags, class
  textTrWinTags:=[WindowID(5), WindowTitle('Text'),
                  WindowPosition(TRWP_CENTERDISPLAY),
    VertGroupA,
      Space, CenteredText('Normal text'),
      Space, CenteredTextH('Highlighted text'),
      Space, CenteredText3('3-dimensional text'),
      Space, CenteredTextB('Bold text'),
      Space, CenteredText('A _shortcut'),
      Space, CenteredInteger(42),
      Space, EndGroup, EndProject]
  IF textProject:=Tr_OpenProject(mainApp, textTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=textProject
          class:=trmsg.class
          SELECT class
            CASE TRMS_CLOSEWINDOW; closeProject:=TRUE
            CASE TRMS_ERROR;       WriteF('\s\n', Tr_GetErrorString(trmsg.data))
          ENDSELECT
        ENDIF
        Tr_ReplyMsg(trmsg)
      ENDWHILE
    ENDWHILE
    Tr_UnlockProject(mainProject)
    Tr_CloseProject(textProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
