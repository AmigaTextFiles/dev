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

PROC doDisabling()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, disablingProject:PTR TO tr_Project,
      disablingTrWinTags, class
  disablingTrWinTags:=[WindowID(4), WindowTitle('Disabling'),
                       WindowPosition(TRWP_CENTERDISPLAY),
    TRGR_VERT,                  TRGR_PROPSHARE OR TRGR_ALIGN,
      TROB_SPACE,               NIL,
      TRGR_HORIZ,               TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_SPACE,             NIL,
        TROB_CHECKBOX,          NIL, TRAT_ID, 1, TRAT_VALUE, TRUE,
        TROB_SPACE,             NIL,
        TROB_TEXT,              NIL, TRAT_TEXT, '_Disable', TRAT_ID, 1,
        TRGR_HORIZ,             TRGR_PROPSPACES,
          TROB_SPACE,           NIL,
          TRGR_END,             NIL,
        TRGR_END,               NIL,
      TROB_SPACE,               NIL,
      TRGR_HORIZ,               TRGR_EQUALSHARE OR TRGR_CENTER,
        TROB_SPACE,             NIL,
        TROB_LINE,              TROF_HORIZ,
        TROB_SPACE,             NIL,
        TRGR_END,               NIL,
      TROB_SPACE,               NIL,
      TRGR_HORIZ,               TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_SPACE,             NIL,
        TROB_CHECKBOX,          NIL, TRAT_VALUE, TRUE, TRAT_ID, 2, TRAT_DISABLED, TRUE,
        TROB_SPACE,             NIL,
        TROB_TEXT,              NIL, TRAT_TEXT, '_Checkbox', TRAT_ID, 2,
        TROB_SPACE,             NIL,
      TRGR_END,                 NIL,
      TROB_SPACE,               NIL,
      TRGR_HORIZ,               TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER,
        TROB_SPACE,             NIL,
        TROB_BUTTON,            NIL, TRAT_TEXT, '_Button', TRAT_ID, 3, TRAT_DISABLED, TRUE,
        TROB_SPACE,             NIL,
      TRGR_END,                 NIL,
      TROB_SPACE,               NIL,
    TRGR_END,                   NIL,
    TAG_END]
  IF disablingProject:=Tr_OpenProject(mainApp, disablingTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=disablingProject
          class:=trmsg.class
          SELECT class
            CASE TRMS_CLOSEWINDOW; closeProject:=TRUE
            CASE TRMS_ERROR;       WriteF('\s\n', Tr_GetErrorString(trmsg.data))
            CASE TRMS_NEWVALUE
              IF trmsg.id=1
                Tr_SetAttribute(disablingProject, 2, TRAT_DISABLED, trmsg.data)
                Tr_SetAttribute(disablingProject, 3, TRAT_DISABLED, trmsg.data)
              ENDIF
          ENDSELECT
        ENDIF
        Tr_ReplyMsg(trmsg)
      ENDWHILE
    ENDWHILE
    Tr_UnlockProject(mainProject)
    Tr_CloseProject(disablingProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
