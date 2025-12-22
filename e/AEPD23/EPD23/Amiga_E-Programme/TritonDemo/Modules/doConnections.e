/* MAC2E triton.macros */
OPT PREPROCESS
OPT MODULE
OPT EXPORT
OPT OSVERSION=37,
    REG=5

-> TRITON defs
#define CheckBox(id)            TROB_CHECKBOX,NIL,TRAT_ID,id
#define EndGroup                TRGR_END,NIL
#define EndProject              TAG_END
#define HorizGroupAC            TRGR_HORIZ,TRGR_ALIGN OR TRGR_CENTER
#define HorizGroupEC            TRGR_HORIZ,TRGR_EQUALSHARE OR TRGR_CENTER
#define HorizGroupSAC           TRGR_HORIZ,TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER
#define Integer3(i)             TROB_TEXT,NIL,TRAT_VALUE,(i),TRAT_FLAGS,TRTX_3D
#define NamedSeparatorI(te,id)  HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(te),TRAT_ID,id,Space,Line(TROF_HORIZ),Space,EndGroup
#define Progress(maxi,val,id)   TROB_PROGRESS,(maxi),TRAT_ID,(id),TRAT_VALUE,(val)
#define SliderGadget(mini,maxi,val,id) TROB_SLIDER,NIL,TRSL_MIN,(mini),TRSL_MAX,(maxi),TRAT_ID,(id),TRAT_VALUE,(val)
#define Space                   TROB_SPACE,TRST_NORMAL
#define TextN(text)             TROB_TEXT,NIL,TRAT_TEXT,text
#define TextT(text)             TROB_TEXT,NIL,TRAT_TEXT,text,TRAT_FLAGS,TRTX_TITLE
#define VertGroupA              TRGR_VERT,TRGR_ALIGN
#define WindowID(id)            TRWI_ID,(id)
#define WindowPosition(pos)     TRWI_POSITION,(pos)
#define WindowTitle(t)          TRWI_TITLE,(t)
#define Line(flags)             TROB_LINE,flags
-> TRITON defs

MODULE 'triton',
       'libraries/triton',
       'utility/tagitem'

MODULE '*global'

DEF mainApp:PTR TO tr_App,
    mainProject:PTR TO tr_Project

PROC doConnections()
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, connectionsProject:PTR TO tr_Project,
      connectionsTrWinTags, class
  connectionsTrWinTags:=[WindowID(6), WindowTitle('Connections'),
                         WindowPosition(TRWP_CENTERDISPLAY),
    VertGroupA,
      Space,
      NamedSeparatorI('_Checkmarks',1),
      Space,
      HorizGroupSAC,
        Space, CheckBox(1),
        Space, CheckBox(1),
        Space, CheckBox(1),
        Space, EndGroup,
      Space,
      HorizGroupSAC,
        Space, CheckBox(1),
        Space, CheckBox(1),
        Space, CheckBox(1),
        Space, EndGroup,
      Space,
      HorizGroupSAC,
        Space, CheckBox(1),
        Space, CheckBox(1),
        Space, CheckBox(1),
        Space, EndGroup,
      Space,
      NamedSeparatorI('_Slider and Progress indicator',2),
      Space,
      HorizGroupAC,
        Space,
        SliderGadget(0,10,8,2),
        Space,
        Integer3(8),TRAT_ID,2,TRAT_MINWIDTH,3,
        Space,
        EndGroup,
      Space,
      HorizGroupAC,
        Space,
        TextN('0%'),
        Space,
        Progress(10,8,2),
        Space,
        TextN('100%'),
        Space,
        EndGroup,
      Space,
    EndGroup, EndProject]
  IF connectionsProject:=Tr_OpenProject(mainApp, connectionsTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL);
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=connectionsProject
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
    Tr_CloseProject(connectionsProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC
