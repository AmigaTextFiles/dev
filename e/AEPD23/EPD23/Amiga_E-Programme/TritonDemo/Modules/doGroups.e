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
#define WindowUnderscore(und)   TRWI_UNDERSCORE,(und)
#define HorizGroupA             TRGR_HORIZ,TRGR_ALIGN
#define Space                   TROB_SPACE,TRST_NORMAL
#define VertGroupA              TRGR_VERT,TRGR_ALIGN
#define NamedFrameBox(t)        TROB_FRAMEBOX,TRFB_FRAMING,TRAT_TEXT,(t)
#define ObjectBackfillWin       TRAT_BACKFILL,TRBF_WINDOWBACK
#define HorizGroupC             TRGR_HORIZ,TRGR_CENTER
#define Button(text,id)         TROB_BUTTON,NIL,TRAT_TEXT,(text),TRAT_ID,(id)
#define EndGroup                TRGR_END,NIL
#define HorizGroupEC            TRGR_HORIZ,TRGR_EQUALSHARE OR TRGR_CENTER
#define HorizGroupSC            TRGR_HORIZ,TRGR_PROPSPACES OR TRGR_CENTER
#define LineArray               TRGR_VERT,TRGR_ARRAY OR TRGR_ALIGN OR TRGR_CENTER
#define BeginLine               TRGR_HORIZ,TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER
#define EndLine                 EndGroup
#define BeginLineI              TRGR_HORIZ,TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER OR TRGR_INDEP
#define NamedSeparator(text)    HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(text),Space,Line(TROF_HORIZ),Space,EndGroup
#define TextT(text)             TROB_TEXT,NIL,TRAT_TEXT,text,TRAT_FLAGS,TRTX_TITLE
#define EndArray                EndGroup
#define EndProject              TAG_END
#define Line(flags)             TROB_LINE,flags
-> TRITON defs

MODULE 'triton',
       'libraries/triton',
       'utility/tagitem'

MODULE '*global'

DEF mainApp:PTR TO tr_App,
    mainProject:PTR TO tr_Project

PROC doGroups()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, groupsProject:PTR TO tr_Project, class
  DEF groupsTrWinTags
  groupsTrWinTags:=[WindowTitle('Groups'), WindowPosition(TRWP_CENTERDISPLAY),
                    WindowUnderscore('~'), WindowID(1),
    HorizGroupA, Space, VertGroupA,
      Space,
      NamedFrameBox('TRGR_PROPSHARE (default)'), ObjectBackfillWin, VertGroupA, Space, HorizGroupC,
        Space,
        Button('Short',1),
        Space,
        Button('And much, much longer...',2),
        Space,
        EndGroup, Space, EndGroup,
      Space,
      NamedFrameBox('TRGR_EQUALSHARE'), ObjectBackfillWin, VertGroupA, Space, HorizGroupEC,
        Space,
        Button('Short',3),
        Space,
        Button('And much, much longer...',4),
        Space,
        EndGroup, Space, EndGroup,
      Space,
      NamedFrameBox('TRGR_PROPSPACES'), ObjectBackfillWin, VertGroupA, Space, HorizGroupSC,
        Space,
        Button('Short',5),
        Space,
        Button('And much, much longer...',6),
        Space,
        EndGroup, Space, EndGroup,
      Space,
      NamedFrameBox('TRGR_ARRAY'), ObjectBackfillWin, VertGroupA, Space, LineArray,
        BeginLine,
          Space,
          Button('Short',7),
          Space,
          Button('And much, much longer...',8),
          Space,
          EndLine,
        Space,
        BeginLine,
          Space,
          Button('Not so short',9),
          Space,
          Button('And a bit longer...',10),
          Space,
          EndLine,
        Space,
        BeginLineI,
          NamedSeparator('An independant line'),
          EndLine,
        Space,
        BeginLine,
          Space,
          Button('foo bar',12),
          Space,
          Button('42',13),
          Space,
          EndLine,
        EndArray, Space, EndGroup,
      Space,
      EndGroup, Space, EndGroup,
    EndProject]
  IF groupsProject:=Tr_OpenProject(mainApp, groupsTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=groupsProject
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
    Tr_CloseProject(groupsProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
