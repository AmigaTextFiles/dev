/* MAC2E triton.macros */
OPT PREPROCESS
OPT MODULE
OPT EXPORT
OPT OSVERSION=37,
    REG=5

-> TRITON defs
#define EndGroup                TRGR_END,NIL
#define EndProject              TAG_END
#define FWListROCN(ent,id,top)  TROB_LISTVIEW,(ent),TRAT_FLAGS,TRLV_FWFONT OR TRLV_READONLY OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_VALUE,0,TRLV_TOP,top
#define HorizGroupA             TRGR_HORIZ,TRGR_ALIGN
#define HorizGroupEC            TRGR_HORIZ,TRGR_EQUALSHARE OR TRGR_CENTER
#define Line(flags)             TROB_LINE,flags
#define ListSelC(ent,id,top)    TROB_LISTVIEW,(ent),TRAT_FLAGS,TRLV_SELECT OR TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_VALUE,0,TRLV_TOP,top
#define ListSSN(e,id,top,v)     TROB_LISTVIEW,(e),TRAT_FLAGS,TRLV_SHOWSELECTED OR TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_VALUE,v,TRLV_TOP,top
#define NamedSeparatorIN(te,id) HorizGroupEC,Line(TROF_HORIZ),Space,TextT(te),TRAT_ID,id,Space,Line(TROF_HORIZ),EndGroup
#define Space                   TROB_SPACE,TRST_NORMAL
#define TextT(text)             TROB_TEXT,NIL,TRAT_TEXT,text,TRAT_FLAGS,TRTX_TITLE
#define VertGroupA              TRGR_VERT,TRGR_ALIGN
#define WindowDimensions(dim)   TRWI_DIMENSIONS,(dim)
#define WindowID(id)            TRWI_ID,(id)
#define WindowPosition(pos)     TRWI_POSITION,(pos)
#define WindowTitle(t)          TRWI_TITLE,(t)
-> TRITON defs

MODULE 'triton',
       'exec/lists',
       'exec/nodes',
       'libraries/triton',
       'utility/tagitem'

MODULE '*global'

DEF mainApp:PTR TO tr_App,
    mainProject:PTR TO tr_Project

PROC doLists() HANDLE
  DEF closeProject=FALSE
  DEF trmsg:PTR TO tr_Message, listsProject:PTR TO tr_Project,
      lists_dim:tr_Dimensions, listsTrWinTags, class, i, n:PTR TO ln,
      lvList1=NIL:PTR TO mlh, lvList2=NIL:PTR TO mlh, lvList3=NIL:PTR TO mlh,
      lvNodes1=NIL:PTR TO LONG, lvNodes2=NIL:PTR TO LONG, lvNodes3=NIL:PTR TO LONG
  NEW lvList1
  NEW lvList2
  NEW lvList3

  lvNodes1:=NewR(19*4)
  lvNodes2:=NewR(9*4)
  lvNodes3:=NewR(13*4)

  lvNodes1[0]:=[0, lvList1,                         0, 0, 'This is a' ]:ln
  lvNodes1[1]:=[0, lvNodes1[0],                     0, 0, 'READ']:ln
  lvNodes1[2]:=[0, lvNodes1[1],                     0, 0, 'ONLY']:ln
  lvNodes1[3]:=[0, lvNodes1[2],                     0, 0, 'Listview']:ln
  lvNodes1[4]:=[0, lvNodes1[3],                     0, 0, 'gadget']:ln
  lvNodes1[5]:=[0, lvNodes1[4],                     0, 0, 'using the']:ln
  lvNodes1[6]:=[0, lvNodes1[5],                     0, 0, 'fixed-width']:ln
  lvNodes1[7]:=[0, lvNodes1[ 6],                    0, 0, 'font.']:ln
  lvNodes1[8]:=[0, lvNodes1[ 7],                    0, 0, '']:ln
  lvNodes1[9]:=[0, lvNodes1[ 8],                    0, 0, 'This window']:ln
  lvNodes1[10]:=[0, lvNodes1[ 9],                   0, 0, 'uses a']:ln
  lvNodes1[11]:=[0, lvNodes1[10],                   0, 0, 'dimensions']:ln
  lvNodes1[12]:=[0, lvNodes1[11],                   0, 0, 'structure,']:ln
  lvNodes1[13]:=[0, lvNodes1[12],                   0, 0, 'so it will']:ln
  lvNodes1[14]:=[0, lvNodes1[13],                   0, 0, 'remember']:ln
  lvNodes1[15]:=[0, lvNodes1[14],                   0, 0, 'its']:ln
  lvNodes1[16]:=[0, lvNodes1[15],                   0, 0, 'position']:ln
  lvNodes1[17]:=[0, lvNodes1[16],                   0, 0, 'when you']:ln
  lvNodes1[18]:=[lvList1+4, lvNodes1[17],           0, 0, 'reopen it.']:ln

  lvNodes2[0]:=[0, lvList2,                         0, 0, 'This is a' ]:ln
  lvNodes2[1]:=[0, lvNodes2[0],                     0, 0, 'SELECT']:ln
  lvNodes2[2]:=[0, lvNodes2[1],                     0, 0, 'Listview']:ln
  lvNodes2[3]:=[0, lvNodes2[2],                     0, 0, 'gadget.']:ln
  lvNodes2[4]:=[0, lvNodes2[3],                     0, 0, 'Use the']:ln
  lvNodes2[5]:=[0, lvNodes2[4],                     0, 0, 'numeric']:ln
  lvNodes2[6]:=[0, lvNodes2[5],                     0, 0, 'key pad to']:ln
  lvNodes2[7]:=[0, lvNodes2[6],                     0, 0, 'move']:ln
  lvNodes2[8]:=[lvList2+4, lvNodes2[7],             0, 0, 'around.' ]:ln

  lvNodes3[0]:=[0,  lvList3,                         0, 0, 'This is a']:ln
  lvNodes3[1]:=[0,  lvNodes3[0],                     0, 0, 'SHOW']:ln
  lvNodes3[2]:=[0,  lvNodes3[1],                     0, 0, 'SELECTED']:ln
  lvNodes3[3]:=[0,  lvNodes3[2],                     0, 0, 'Listview']:ln
  lvNodes3[4]:=[0,  lvNodes3[3],                     0, 0, 'gadget.']:ln
  lvNodes3[5]:=[0,  lvNodes3[4],                     0, 0, 'This list']:ln
  lvNodes3[6]:=[0,  lvNodes3[5],                     0, 0, 'is a bit']:ln
  lvNodes3[7]:=[0,  lvNodes3[6],                     0, 0, 'longer, so']:ln
  lvNodes3[8]:=[0,  lvNodes3[7],                     0, 0, 'that you']:ln
  lvNodes3[9]:=[0,  lvNodes3[8],                     0, 0, 'can try the']:ln
  lvNodes3[10]:=[0, lvNodes3[9],                     0, 0, 'other']:ln
  lvNodes3[11]:=[0, lvNodes3[10],                    0, 0, 'keyboard']:ln
  lvNodes3[12]:=[lvList3+4, lvNodes3[11],            0, 0, 'shortcuts.']:ln

  FOR i:=0 TO 17
    n:=lvNodes1[i]
    n.succ:=lvNodes1[i+1]
  ENDFOR
  FOR i:=0 TO 7
    n:=lvNodes2[i]
    n.succ:=lvNodes2[i+1]
  ENDFOR
  FOR i:=0 TO 11
    n:=lvNodes3[i]
    n.succ:=lvNodes3[i+1]
  ENDFOR

  lvList1.head:=lvNodes1[0]; lvList1.tailpred:=lvNodes1[18]
  lvList2.head:=lvNodes2[0]; lvList2.tailpred:=lvNodes2[8]
  lvList3.head:=lvNodes3[0]; lvList3.tailpred:=lvNodes3[12]

  listsTrWinTags:=[WindowID(9), WindowTitle('Lists'),
                   WindowPosition(TRWP_CENTERDISPLAY), WindowDimensions(lists_dim),
    HorizGroupA, Space, VertGroupA,
      Space,
      NamedSeparatorIN('_Read only', 1),
      Space,
      FWListROCN(lvList1, 1, 0),
      Space,
      NamedSeparatorIN('_Select', 2),
      Space,
      ListSelC(lvList2, 2, 0),
      Space,
      NamedSeparatorIN('S_how selected', 3),
      Space,
      ListSSN(lvList3, 3, 0, 1),
      Space,
    EndGroup, Space, EndGroup,
    EndProject]
  IF listsProject:=Tr_OpenProject(mainApp, listsTrWinTags)
    Tr_LockProject(mainProject)
    WHILE closeProject=FALSE
      Tr_Wait(mainApp, NIL)
      WHILE trmsg:=Tr_GetMsg(mainApp)
        IF trmsg.project=listsProject
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
    Tr_CloseProject(listsProject)
  ELSE
    DisplayBeep(NIL)
  ENDIF
EXCEPT DO
  IF lvList1 THEN END lvList1
  IF lvList2 THEN END lvList2
  IF lvList3 THEN END lvList3
  IF lvNodes1 THEN Dispose(lvNodes1)
  IF lvNodes2 THEN Dispose(lvNodes2)
  IF lvNodes3 THEN Dispose(lvNodes3)
  IF exception THEN ReThrow()
ENDPROC
