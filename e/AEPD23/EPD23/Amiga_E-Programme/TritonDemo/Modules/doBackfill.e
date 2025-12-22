/* MAC2E triton.macros */
OPT PREPROCESS
OPT MODULE
OPT EXPORT
OPT OSVERSION=37,
    REG=5

-> TRITON defs
#define CenteredText(text)      HorizGroupSC,Space,TextN(text),Space,EndGroup
#define EndGroup                TRGR_END,NIL
#define EndProject              TAG_END
#define GroupBox                TROB_FRAMEBOX,TRFB_GROUPING
#define HorizGroupA             TRGR_HORIZ,TRGR_ALIGN
#define HorizGroupSC            TRGR_HORIZ,TRGR_PROPSPACES OR TRGR_CENTER
#define ObjectBackfillA         TRAT_BACKFILL,TRBF_SHADOW
#define ObjectBackfillAB        TRAT_BACKFILL,TRBF_SHADOW_BACKGROUND
#define ObjectBackfillAF        TRAT_BACKFILL,TRBF_SHADOW_FILL
#define ObjectBackfillB         TRAT_BACKFILL,TRBF_NONE
#define ObjectBackfillF         TRAT_BACKFILL,TRBF_FILL
#define ObjectBackfillFB        TRAT_BACKFILL,TRBF_FILL_BACKGROUND
#define ObjectBackfillReq       TRAT_BACKFILL,TRBF_REQUESTERBACK
#define ObjectBackfillS         TRAT_BACKFILL,TRBF_SHINE
#define ObjectBackfillSA        TRAT_BACKFILL,TRBF_SHINE_SHADOW
#define ObjectBackfillSB        TRAT_BACKFILL,TRBF_SHINE_BACKGROUND
#define ObjectBackfillSF        TRAT_BACKFILL,TRBF_SHINE_FILL
#define Space                   TROB_SPACE,TRST_NORMAL
#define SpaceB                  TROB_SPACE,TRST_BIG
#define SpaceS                  TROB_SPACE,TRST_SMALL
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

PROC doBackfill()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, backfillProject:PTR TO tr_Project,
      backfillTrWinTags, class
  backfillTrWinTags:=[WindowID(7), WindowTitle('Backfill'),
                      WindowPosition(TRWP_CENTERDISPLAY),
    VertGroupA,
      Space,  CenteredText('Each window and'),
      SpaceS, CenteredText('FrameBox can have'),
      SpaceS, CenteredText('one of the following'),
      SpaceS, CenteredText('backfill patterns'),
      Space,  HorizGroupA,
                Space, GroupBox, ObjectBackfillS, SpaceB,
                Space, GroupBox, ObjectBackfillSA, SpaceB,
                Space, GroupBox, ObjectBackfillSF, SpaceB,
                Space, EndGroup,
      Space,  HorizGroupA,
                Space, GroupBox, ObjectBackfillSB, SpaceB,
                Space, GroupBox, ObjectBackfillA, SpaceB,
                Space, GroupBox, ObjectBackfillAF, SpaceB,
                Space, EndGroup,
      Space,  HorizGroupA,
                Space, GroupBox, ObjectBackfillAB, SpaceB,
                Space, GroupBox, ObjectBackfillF, SpaceB,
                Space, GroupBox, ObjectBackfillFB, SpaceB,
                Space, EndGroup,
      Space, EndGroup, EndProject]
  IF backfillProject:=Tr_OpenProject(mainApp, backfillTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=backfillProject
          class:=trmsg.class
          SELECT class
            CASE TRMS_CLOSEWINDOW; closeProject:=TRUE
            CASE TRMS_ERROR;       WriteF('\s\n', Tr_GetErrorString(trmsg.data))
          ENDSELECT
        ENDIF
        Tr_ReplyMsg(trmsg);
      ENDWHILE
    ENDWHILE
    Tr_UnlockProject(mainProject)
    Tr_CloseProject(backfillProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
