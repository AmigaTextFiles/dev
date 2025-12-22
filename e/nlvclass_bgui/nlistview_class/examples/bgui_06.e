OPT OSVERSION=37
OPT PREPROCESS

MODULE 'bgui/bgui','bgui/bguic','bgui/bguim','bgui',
       'intuition/intuition','intuition/classes','intuition/classusr',
       'intuition/gadgetclass',
       'graphics/gfxbase','graphics/displayinfo',
       'graphics/modeid','graphics/text',
       'libraries/gadtools','libraries/asl','asl',
       'utility/tagitem','utility/hooks','utility',
       'devices/inputevent',
       'other/ecode','tools/boopsi','tools/installhook',
       'amigalib/boopsi','tools/exceptions',
       'exec/nodes','exec/lists','exec/ports'
MODULE '*nlistview_class_06'

CONST   ID_QUIT = 1,ID_LIST = 2, ID_DISABLE = 3
ENUM    ERR_NONE,ERR_LIB,ERR_CLASS

OBJECT hookData
  mx,list
ENDOBJECT

PROC tabHookFunc()
  DEF mhook:PTR TO hook,obj:PTR TO object,msg:PTR TO intuimessage
  DEF wnd=NIL:PTR TO window,my_obj:PTR TO object,pos=0,code
  DEF data:PTR TO hookData,bool=0

  MOVE.L A0,mhook
  MOVE.L A1,msg
  MOVE.L A2,obj
  data:=mhook.data
  code:=msg.code
  GetAttr(WINDOW_WINDOW,obj,{wnd})
  SELECT code
  CASE $42 /* TAB */
    my_obj:=data.mx
    GetAttr(MX_ACTIVE,my_obj,{pos})
    IF (msg.qualifier) AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT )
      pos--
    ELSE
      pos++
    ENDIF
      SetGadgetAttrsA(my_obj,wnd,NIL,[MX_ACTIVE,pos,TAG_END])
  CASE $4C /* CURS UP */
    my_obj:=data.list
    GetAttr(BT_INHIBIT,my_obj,{bool})
    IF bool THEN RETURN
    IF (msg.qualifier) AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_SELECT,LISTV_SELECT_PAGE_UP,TAG_END])
    ELSEIF (msg.qualifier) AND IEQUALIFIER_CONTROL
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_SELECT,LISTV_SELECT_FIRST,TAG_END])
    ELSE
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_SELECT,LISTV_SELECT_PREVIOUS,TAG_END])
    ENDIF
  CASE $4D /* CUSR DOWN */
    my_obj:=data.list
    GetAttr(BT_INHIBIT,my_obj,{bool})
    IF bool THEN RETURN
    IF (msg.qualifier) AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_SELECT,LISTV_SELECT_PAGE_DOWN,TAG_END])
    ELSEIF (msg.qualifier) AND (IEQUALIFIER_CONTROL)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_SELECT,LISTV_SELECT_LAST,TAG_END])
    ELSE
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_SELECT,LISTV_SELECT_NEXT,TAG_END])
    ENDIF
  CASE $4F /* CURS LEFT */
    my_obj:=data.list
    GetAttr(BT_INHIBIT,my_obj,{bool})
    IF bool THEN RETURN
    IF (msg.qualifier) AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_HORIZOFFSET,LISTV_HORIZOFFSET_PAGE_LEFT,TAG_END])
    ELSEIF (msg.qualifier) AND (IEQUALIFIER_CONTROL)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_HORIZOFFSET,LISTV_HORIZOFFSET_FIRST,TAG_END])
    ELSE
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_HORIZOFFSET,LISTV_HORIZOFFSET_LEFT,TAG_END])
    ENDIF
  CASE $4E /* CURS RIGHT */
    my_obj:=data.list
    GetAttr(BT_INHIBIT,my_obj,{bool})
    IF bool THEN RETURN
    IF (msg.qualifier) AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_HORIZOFFSET,LISTV_HORIZOFFSET_PAGE_RIGHT,TAG_END])
    ELSEIF (msg.qualifier) AND (IEQUALIFIER_CONTROL)
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_HORIZOFFSET,LISTV_HORIZOFFSET_LAST,TAG_END])
    ELSE
      SetGadgetAttrsA(my_obj,wnd,NIL,[LISTV_HORIZOFFSET,LISTV_HORIZOFFSET_RIGHT,TAG_END])
    ENDIF
  CASE    $44 /* RETURN */
  CASE    $43 /* ENTER */
  ENDSELECT
ENDPROC

PROC main() HANDLE
  DEF nlc:PTR TO nlistviewclass
  DEF wd_obj,mx_tabs,pg_page,lv1_listview,lv2_listview,sl_slide
  DEF signal,running=TRUE,rc=0,dir
  DEF my_data:hookData,tabHook:PTR TO hook,ffont:PTR TO textattr
  DEF gb:PTR TO gfxbase

  IF (aslbase:=OpenLibrary('asl.library',38))=NIL THEN Raise(ERR_LIB)
  IF (bguibase:=OpenLibrary('bgui.library',41))=NIL THEN Raise(ERR_LIB)
  IF (utilitybase:=OpenLibrary('utility.library',0))=NIL THEN Raise(ERR_LIB)
  NEW nlc.init()
  IF nlc.class=NIL THEN Raise(ERR_CLASS)
  NEW tabHook
  tabHook.entry:=eCodePreserve({tabHookFunc})

  ->- lepiej zamknâê oczy i nie patrzeê na to... brrr
  gb:=gfxbase
  NEW ffont
  ffont.name:=StrCopy(String(32),gb.defaultfont.mn.ln.name)
  ffont.style:=FS_NORMAL
  ffont.ysize:=gb.defaultfont.ysize
  ffont.flags:=gb.defaultfont.flags

  dir:=['\euTEMP                         Dir ----rwed 15-Lip-96    21:34:36\en',
        '\ep3Tools                        Dir ----rwed Ôroda        16:57:39',
        '\eu\ed3Trashcan                     Dir ----rwed Dziô         18:26:25',
        '\eb\ei\euTrashcan.info               1629 ----rw-d 23-Cze-96    17:53:21',
        'Music.info                  1233 ----rw-d 23-Cze-96    17:16:04',
        'DiskTools.info              1233 ----rw-d 27-Cze-96    14:28:22',
        'Edit.info                   1233 ----rw-d 23-Cze-96    17:20:54',
        'Graph.info                  1233 ----rw-d 23-Cze-96    18:35:37',
        'PRO.info                    1233 ----rw-d 27-Cze-96    19:56:26',
        'TEMP.info                   1233 ----rw-d 23-Cze-96    21:47:13',
        'Tools.info                  1233 ----rw-d 23-Cze-96    18:34:40',
        '\ei\ebDisk.info                   2104 ----rw-d 23-Cze-96    17:15:18\en',
        '.archie                      Dir ----rwed 10-Wrz-96    20:47:18',
        'Net                          Dir ----rwed 10-Wrz-96    23:03:14',
        'Net.info                    1233 ----rw-d 10-Wrz-96    22:42:42',
        'C                            Dir ----rwed Czwartek     16:10:49',
        'DiskTools                    Dir ----rwed 29-Sie-96    12:27:11',
        'Edit                         Dir ----rwed 02-Sie-96    22:35:33',
        'Graph                        Dir ----rwed 07-Sie-96    21:35:57',
        'LIBS                         Dir ----rwed 10-Wrz-96    22:25:19',
        'Music                        Dir ----rwed 10-Wrz-96    22:21:30',
        'PRO                          Dir ----rwed Piâtek       23:32:58',
        '.backdrop                     74 ----rw-d 18-Lip-96    23:09:13',
        NIL]

  wd_obj:=WindowObject,
    WINDOW_UNIQUEID,        "WIND",
    WINDOW_TITLE,           'BGUI',
    WINDOW_RMBTRAP,         TRUE,
    WINDOW_CLOSEONESC,      TRUE,
    WINDOW_SMARTREFRESH,    TRUE,
    WINDOW_IDCMPHOOKBITS,   IDCMP_RAWKEY,
    WINDOW_IDCMPHOOK,       tabHook,
    WINDOW_AUTOKEYLABEL,    TRUE,
    WINDOW_AUTOASPECT,      TRUE,
    WINDOW_MASTERGROUP,
      VGroupObject,HOffset(4),VOffset(4),Spacing(4),
        StartMember,
          mx_tabs:=MxObject,
            MX_TABSOBJECT,TRUE,
            MX_LABELS,['Fixed Font','Prop Font',NIL],
            MX_ACTIVE,0,
          EndObject,FixMinHeight,
        EndMember,
        StartMember,pg_page:=PageObject,

          PageMember,
            VGroupObject,
              StartMember,lv1_listview:=nlc.newObject(
                [LISTV_ENTRYARRAY,dir,
                PGA_NEWLOOK,TRUE,
                LISTV_ListFont,ffont,
                LISTV_HORIZSTEPS,60-1,
->                LISTV_PROPOBJECT,NIL,
->                LISTV_HORIZOBJECT,NIL,
->                LISTV_COLUMNS,2,
->                LISTV_SCROLLCOLUMN,1,
                BT_DRAGOBJECT,TRUE,
                NIL]),
              EndMember,
            EndObject,

          PageMember,
            VGroupObject,
              StartMember,
                KeyButton('Disable',ID_DISABLE),
                FixMinHeight,
              EndMember,
              StartMember,sl_slide:=SliderObject,
                SLIDER_MIN,-10,
                SLIDER_MAX,30,
                SLIDER_LEVEL,0,
                SLIDER_THINFRAME,TRUE,
                PGA_NEWLOOK,TRUE,
              EndObject,FixHeight(13),EndMember,
              StartMember,lv2_listview:=nlc.newObject(
                [LISTV_ENTRYARRAY,dir,
                PGA_NEWLOOK,TRUE,
                LISTV_HORIZSTEPS,80,
                LAB_LABEL,'Nowy _Listview',
                LAB_PLACE,PLACE_ABOVE,
                LISTV_HORIZOBJECT,sl_slide,
                NIL]),
              EndMember,
            EndObject,
        EndObject,EndMember,
      EndObject,
    EndObject

  IF wd_obj
    my_data.mx:=mx_tabs
    my_data.list:=lv1_listview
    tabHook.data:=my_data
    AddMap(mx_tabs,pg_page,[MX_ACTIVE,PAGE_ACTIVE,TAG_END])

    WindowOpen(wd_obj)
    GetAttr(WINDOW_SIGMASK,wd_obj,{signal})
    WHILE running=TRUE
      Wait(signal)
      WHILE (rc:=HandleEvent(wd_obj))<>WMHI_NOMORE
        SELECT rc
        CASE WMHI_CLOSEWINDOW
          running:=FALSE
        CASE ID_QUIT
          running:=FALSE
        CASE ID_DISABLE
          SetAttrsA(lv2_listview,[GA_DISABLED,TRUE,TAG_DONE])
        ENDSELECT
      ENDWHILE
    ENDWHILE
    DisposeObject( wd_obj )
  ELSE
    WriteF('Unable to create a window object\n')
  ENDIF
EXCEPT DO
  IF exception THEN report_exception()
  IF bguibase
    END nlc
    CloseLibrary(bguibase)
  ENDIF
  IF utilitybase THEN CloseLibrary(utilitybase)
  IF aslbase THEN CloseLibrary(aslbase)
ENDPROC

CHAR 0,'$VER: bgui_tester v0.6 (26.09.96) (c) by Piotr Gapiïski',0
