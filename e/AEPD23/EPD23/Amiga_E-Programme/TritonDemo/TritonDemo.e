/****************************************************************************
**
** This demo translated by Barry Wills from the original Triton demo source,
** demo.c, the program description of which follows:
**
**   Triton - The object oriented GUI creation system for the Amiga
**   Written by Stefan Zeiger in 1993-1994
**
**   (c) 1993-1994 by Stefan Zeiger
**   You are hereby allowed to use this source or parts
**   of it for creating programs for AmigaOS which use the
**   Triton GUI creation system. All other rights reserved.
**
**   demo.c - Triton demo program
**
******
**
** Things I Jørgen 'Da' Larsen have done to the source from Barry Wills
**
**  * Replaced Mac2e macros with real AmigaE3.1a defines
**  * Fixed bug with the menu 'Project/help'
**  * Included defs_all
**  * Moved modules (*.m) to modules/
**  * Compiled with EC3.1a
**
** Remember that the above things are small things the real hard work was
** done by Barry Wills ( ;-> The E smily ) and Stefan Zeiger.
**
*/

OPT PREPROCESS
OPT OSVERSION=37,
    REG=5

-> TRITON defs
#define BeginMenu(t)            TRMN_TITLE,(t)
#define BeginRequesterGads      Space,EndGroup,Space
#define CenteredButtonRE(t,i)   HorizGroupSC,Space,TROB_BUTTON,NIL,TRAT_FLAGS,TRBU_RETURNOK OR TRBU_ESCOK,TRAT_TEXT,(t),TRAT_ID,(i),Space,EndGroup
#define EndRequester            Space,EndGroup,EndProject
#define HorizGroupEA            TRGR_HORIZ,TRGR_EQUALSHARE OR TRGR_ALIGN
#define HorizSeparator          HorizGroupEC,Space,Line(TROF_HORIZ),Space,EndGroup
#define ItemBarlabel            TRMN_ITEM,TRMN_BARLABEL
#define MenuItem(t,id)          TRMN_ITEM,(t),TRAT_ID,id
#define TRITONNAME 'triton.library'
#define WindowBackfillReq       TRWI_BACKFILL,TRBF_REQUESTERBACK
#define WindowFlags(f)          TRWI_FLAGS,(f)
#define WindowID(id)            TRWI_ID,(id)
#define WindowPosition(pos)     TRWI_POSITION,(pos)
#define WindowTitle(t)          TRWI_TITLE,(t)
#define BeginRequester(t,p)     WindowTitle(t),WindowPosition(p),WindowBackfillReq,\
                                WindowFlags(TRWF_NOZIPGADGET OR TRWF_NOSIZEGADGET OR TRWF_NOCLOSEGADGET OR TRWF_NODELZIP OR TRWF_NOESCCLOSE),\
                                VertGroupA,Space,HorizGroupA,Space,GroupBox,ObjectBackfillB
-> TRITON defs

MODULE 'triton',
       'dos/dos',
       'libraries/triton',
       'utility/tagitem'

MODULE '*modules/global',
       '*modules/doGadgets',
       '*modules/doGroups',
       '*modules/doText',
       '*modules/doConnections',
       '*modules/doBackfill',
       '*modules/doDisabling',
       '*modules/doAppWindow',
       '*modules/doMenus',
       '*modules/doLists'

DEF mainApp:PTR TO tr_App,
    mainProject:PTR TO tr_Project

PROC quitRequest(app) IS Tr_EasyRequest(app, '%3Do you really want to QUIT?',
                                        'Yes|No', NIL)

PROC doMain() HANDLE
  DEF projectTags, aboutTrWinTags
  DEF trmsg:PTR TO tr_Message, class, id, data
  DEF closeProject=FALSE, reqstr[200]:STRING
  projectTags:=[WindowID(10), WindowTitle('Triton Demo'),
                WindowPosition(TRWP_CENTERDISPLAY), WindowFlags(TRWF_HELP),
    BeginMenu('Project'),
      MenuItem('?_About...',101),
      ItemBarlabel,
      MenuItem('H_Help',102),
      ItemBarlabel,
      MenuItem('Q_Quit',103),
    VertGroupA,
      Space,  CenteredText3('T · r · i · t · o · n'),
      Space,  CenteredText3('The object oriented GUI creation system'),
      Space,  CenteredText('Demo program'),
      Space,  CenteredText('Written and © 1993-1994 by Stefan Zeiger'),
      Space,  HorizSeparator,
      Space,  HorizGroupEA,
                Space, Button('_Gadgets',1),
                Space, Button('G_roups',2),
                Space, Button('_Text',3),
                Space, EndGroup,
      Space, HorizGroupEA,
                Space, Button('_Connections',4),
                Space, Button('_Backfill',5),
                Space, Button('_Disabling',6),
                Space, EndGroup,
      Space, HorizGroupEA,
                Space, Button('_AppWindow',7),
                Space, Button('_Menus',8),
                Space, Button('_Lists',9),
                Space, EndGroup,
      Space, EndGroup, EndProject]
  aboutTrWinTags:=[BeginRequester('About...', TRWP_CENTERDISPLAY),
    VertGroupA, Space,  CenteredText3('Triton Demo'),
                SpaceS, CenteredText('© 1993-1994 by Stefan Zeiger'),
                Space,  HorizSeparator,
                Space,  CenteredText('This program is using the'),
                SpaceS, CenteredText('Triton GUI creation system'),
                SpaceS, CenteredText('which is © by Stefan Zeiger'),
                Space,  EndGroup,
    BeginRequesterGads,
    CenteredButtonRE('_Ok',1),
    EndRequester]
  IF (mainProject:=Tr_OpenProject(mainApp, projectTags))=NIL THEN Raise('open triton project')
  WHILE closeProject=FALSE
    Tr_Wait(mainApp, NIL)
    WHILE trmsg:=Tr_GetMsg(mainApp)
      IF trmsg.project=mainProject
        class:=trmsg.class
        id:=trmsg.id
        data:=trmsg.data
        Tr_ReplyMsg(trmsg)
        SELECT class
          CASE TRMS_CLOSEWINDOW; closeProject:=quitRequest(mainApp)
          CASE TRMS_HELP;        StringF(reqstr,'You requested help for object \d.',id) -> Add by Da
								 Tr_EasyRequest(mainApp, reqstr, '_Ok',
                                                [TREZ_LOCKPROJECT, mainProject,
                                                 TREZ_TITLE,       'Triton help',
                                                 TAG_END]);
          CASE TRMS_ERROR;       WriteF('\s\n', Tr_GetErrorString(data))
          CASE TRMS_ACTION;
            SELECT id
              CASE 1;   doGadgets()
              CASE 2;   doGroups()
              CASE 3;   doText()
              CASE 4;   doConnections()
              CASE 5;   doBackfill()
              CASE 6;   doDisabling()
              CASE 7;   doAppWindow()
              CASE 8;   doMenus()
              CASE 9;   doLists()
              CASE 101; Tr_AutoRequest(mainApp, mainProject, aboutTrWinTags);
              CASE 102; Tr_EasyRequest(mainApp, 'To get help, move the mouse pointer over\n'+
                                            'any gadget or menu item and press <Help>.', '_Ok',
                                       [TREZ_LOCKPROJECT, mainProject,
                                        TREZ_TITLE, 'Triton help',
                                        TAG_END])
              CASE 103; closeProject:=TRUE
            ENDSELECT
        ENDSELECT
      ENDIF
    ENDWHILE
  ENDWHILE
EXCEPT DO
  IF mainProject THEN Tr_CloseProject(mainProject)
  IF exception THEN ReThrow()
ENDPROC
  /* doMain */

PROC main() HANDLE
  DEF status=RETURN_OK
  IF (tritonbase:=OpenLibrary(TRITONNAME, TRITON10VERSION))=NIL THEN
     Raise('open triton.library v1.1')
  IF (mainApp:=Tr_CreateApp([TRCA_NAME,     'AmigaETritonDemo',
                             TRCA_LONGNAME, 'AmigaE Triton Demo',
                             TRCA_VERSION,  '0.0',
                             TAG_DONE]))=NIL THEN Raise('create triton application')
  doMain()
EXCEPT DO
  IF exception
    IF (tritonbase<>NIL) AND (mainApp<>NIL)
      Tr_EasyRequest(mainApp, '%3Could not \s!', 'Ok', [exception])
    ELSE
      WriteF('Could not \s!', exception)
    ENDIF
    status:=RETURN_FAIL
  ENDIF
  IF mainApp THEN Tr_DeleteApp(mainApp)
  IF tritonbase THEN CloseLibrary(tritonbase)
ENDPROC status
  /* main */
