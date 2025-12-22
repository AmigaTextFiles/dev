/*   ProNET-Control's reaction gui in Amiga E by Dave Norris,
     expanded from ClickTabExample.e by Eric Sauvageau.  */

OPT PREPROCESS

MODULE 'tools/constructors', 'tools/boopsi'

MODULE 'exec/types','exec/memory','dos/dos','dos/dosextens','exec/lists',
       'exec/nodes','intuition','graphics','intuition/intuition','exec/ports',
       'intuition/gadgetclass','intuition/imageclass',->'amigalib/boopsi',
       'intuition/intuitionbase','intuition/classusr',->'',
       'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
       'intuition/classes','intuition/sghooks','graphics/gfxbase',
       'graphics/text','graphics/gfxmacros','utility/tagitem','utility/hooks'

MODULE 'clicktab','gadgets/clicktab','window','classes/window','layout',
       'gadgets/layout','label','images/label','images/bevel',
       'space','gadgets/space','chooser','gadgets/chooser','images/glyph',
       'string','gadgets/string','listbrowser','gadgets/listbrowser',
       'reaction/reaction_macros'

DEF listitems1:PTR TO mlh,listitems2:PTR TO mlh,listitems3:PTR TO mlh,
    listitems5:PTR TO mlh,listitems4:PTR TO mlh,listitems6:PTR TO mlh,
    listitems7:PTR TO mlh,listitems8:PTR TO mlh,appport:PTR TO mp,

    listheader1[6]:ARRAY OF columninfo,listheader2[2]:ARRAY OF columninfo,
    listheader3[2]:ARRAY OF columninfo


ENUM ID_CLICKTAB1=1, ID_CLICKTAB2,
     ID_LISTBROWSER1, ID_LISTBROWSER2, ID_LISTBROWSER3, ID_LISTBROWSER4,
     ID_STRING1, ID_STRING2, ID_STRING3,
     ID_CHOOSER1, ID_CHOOSER2, ID_CHOOSER3, ID_CHOOSER4,
     ID_BUTTON1, ID_BUTTON2, ID_BUTTON3, ID_BUTTON4, ID_BUTTON5, ID_BUTTON6

PROC clickTabNodes(list:PTR TO lh, labels:PTR TO LONG)
DEF node=NIL, i=0
  newlist(list)
  WHILE labels[i]
    IF (node:=AllocClickTabNodeA([TNA_TEXT, labels[i],
                                  TNA_NUMBER, i,
                                  TAG_DONE]))
      AddTail(list,node)
    ENDIF
    INC i
  ENDWHILE
ENDPROC

PROC freeClickTabNodes(list:PTR TO lh)
DEF node:PTR TO ln, nextnode:PTR TO ln
   node:=list.head
   WHILE (nextnode = node.succ)
      FreeClickTabNode(node)
      node:=nextnode
   ENDWHILE
   END list  -> Optional, the E cleanup code would do it for us anyway.
ENDPROC

PROC chooserNodes(list:PTR TO lh, labels:PTR TO LONG)
DEF node=NIL, i=0

  newlist(list)
  WHILE labels[i]
    IF (node:=AllocChooserNodeA([CNA_TEXT, labels[i],
                                 TNA_NUMBER, i,
                                 TAG_DONE]))
      AddTail(list,node)
    ENDIF
    INC i
  ENDWHILE
ENDPROC

PROC freeChooserNodes(list:PTR TO lh)
DEF node:PTR TO ln, nextnode:PTR TO ln
   node:=list.head
   WHILE (nextnode = node.succ)
      FreeChooserNode(node)
      node:=nextnode
   ENDWHILE
   END list   -> Optional, the E cleanup code would do it for us anyway.
ENDPROC

PROC listBrowserNodes(list:PTR TO lh, labels:PTR TO LONG)
DEF node=NIL
  newlist(list)
  IF (node:=AllocListBrowserNodeA(1,
                      [LBNA_COLUMN, 0,
                         LBNCA_TEXT, labels[],
                         LBNCA_MAXCHARS, 30,
                       TAG_DONE]))
    AddTail(list,node)
  ENDIF
ENDPROC

PROC main()
DEF win=NIL:PTR TO window, mainpage=NIL:PTR TO object, win_object=NIL:PTR TO object,
    wait, signal, result, done = FALSE, code, tmpres,tmpres2

DEF tablist1:PTR TO LONG,tablist2:PTR TO LONG,
    chooserlist1:PTR TO LONG,chooserlist2:PTR TO LONG,
    browserlist1:PTR TO LONG,browserlist2:PTR TO LONG,
    node=NIL,x,startlist:PTR TO LONG,
    ci_width:PTR TO LONG,ci_title:PTR TO LONG,ci_flags:PTR TO LONG

  ci_width:=[50,50,70,70,50,-1]
  ci_title:=[' Status',' Local Name',' Remote Name',' Volumn Name',' Unique',0]
  ci_flags:=[0,0,0,0,0,-1]

  FOR x:=0 TO 5
    listheader1[x].width:=ci_width[x]
    listheader1[x].title:=ci_title[x]
    listheader1[x].flags:=ci_flags[x]
  ENDFOR

  listheader2[0].width:=100
  listheader2[0].title:=' Click on a unit to activate it '
  listheader2[0].flags:=0

  listheader2[1].width:=-1
  listheader2[1].title:=0
  listheader2[1].flags:=-1

  listheader3[0].width:=100
  listheader3[0].title:=' Units activated'
  listheader3[0].flags:=0

  listheader3[1].width:=-1
  listheader3[1].title:=0
  listheader3[1].flags:=-1

  tablist1:=[' Startup',' Server',' Client',NIL]
  tablist2:=[' Mount',' Page',' Talk',NIL]

  chooserlist1:=[' 0',' 1',' 2',NIL]
  chooserlist2:=[' Open Window',' Iconfiy',NIL]

  browserlist1:=[' .config file not yet loaded',NIL]
  browserlist2:=[' None',NIL]

  startlist:=[' ',' Example of using reaction in E.',' ',' By Dave Norris.',NIL]

->  Open the classes

  windowbase := OpenLibrary('window.class',0)
  layoutbase := OpenLibrary('gadgets/layout.gadget',0)
  clicktabbase := OpenLibrary('gadgets/clicktab.gadget',0)
  labelbase := OpenLibrary('images/label.image',0)
  spacebase := OpenLibrary('gadgets/space.gadget',0)
  chooserbase := OpenLibrary('gadgets/chooser.gadget',0)
  stringbase := OpenLibrary('gadgets/string.gadget',0)
  listbrowserbase := OpenLibrary('gadgets/listbrowser.gadget',0)

  appport:=CreateMsgPort()

  IF (windowbase AND layoutbase AND clicktabbase AND labelbase AND spacebase AND chooserbase AND stringbase AND listbrowserbase)
    clickTabNodes(NEW listitems1, tablist1)
    clickTabNodes(NEW listitems2, tablist2)
    chooserNodes(NEW listitems3 ,chooserlist1)
    chooserNodes(NEW listitems4 ,chooserlist2)

    newlist(NEW listitems5)
    IF (node:=AllocListBrowserNodeA(5,
                     [LBNA_COLUMN, 0,
                        LBNCA_TEXT, 'one',
                        LBNCA_MAXCHARS, 30,
                      LBNA_COLUMN, 1,
                        LBNCA_TEXT, 'two',
                        LBNCA_MAXCHARS, 30,
                      LBNA_COLUMN, 2,
                        LBNCA_TEXT, 'three',
                        LBNCA_MAXCHARS, 30,
                      LBNA_COLUMN, 3,
                        LBNCA_TEXT, 'four',
                        LBNCA_MAXCHARS, 30,
                      LBNA_COLUMN, 4,
                        LBNCA_TEXT, 'five',
                        LBNCA_MAXCHARS, 30,
                      TAG_DONE]))
        AddTail(listitems5,node)
    ENDIF

    listBrowserNodes(NEW listitems6 ,browserlist1)
    listBrowserNodes(NEW listitems7 ,browserlist2)

    newlist(NEW listitems8)
    FOR x:=0 TO 3
      IF (node:=AllocListBrowserNodeA(1,
                      [LBNA_COLUMN, 0,
                         LBNCA_TEXT, startlist[x],
                         LBNCA_MAXCHARS, 30,
                       TAG_DONE]))
        AddTail(listitems8,node)
      ENDIF
    ENDFOR

    win_object:=WindowObject,              -> Create the window object.

        [WA_SCREENTITLE,        ' ProNET-C gui reaction example',
         WA_TITLE,              ' ProNET-C gui reaction example',
         WA_SIZEGADGET,         TRUE,
         WA_DEPTHGADGET,        TRUE,
         WA_DRAGBAR,            TRUE,
         WA_CLOSEGADGET,        TRUE,
         WA_ACTIVATE,           TRUE,
  ->       WA_SMARTREFRESH,       TRUE,     -> selected in reaction prefs
         WINDOW_APPPORT,        appport,       -> needed to use iconfiy
         WINDOW_ICONIFYGADGET,  TRUE,
         WINDOW_ICONTITLE,      'hello!',
         WINDOW_POSITION,       WPOS_CENTERSCREEN,
         WINDOW_LAYOUT,         VLayoutObject,
           LAYOUT_DEFERLAYOUT,    TRUE,
           mainpage:=ClickTabTitles(listitems1,ID_CLICKTAB1),
             ClickTabPages,

               Page_so_si,
                 Layout_so_si_v_cj,
                   ListBrowser(ID_LISTBROWSER1),
                     LISTBROWSER_COLUMNTITLES, FALSE,
                     LISTBROWSER_LABELS, listitems8,
                     GA_READONLY, TRUE,
                   ListBrowserEnd,
                   Layoutex_so_si(' Startup Prefs '),
                     ChooserPU(listitems4,ID_CHOOSER1,2),
                     Button_MinW(' Snapshot Window ',ID_BUTTON1),
                   LayoutEnd,
                   CHILD_WEIGHTEDHEIGHT, 0,
                   CHILD_WEIGHTEDWIDTH, 0,
                 LayoutEnd,
               PageEnd,

               Page_so_si,
                 Layout_so_si_v,
                 ListBrowser(ID_LISTBROWSER2),
                   LISTBROWSER_COLUMNTITLES, TRUE,
                   LISTBROWSER_COLUMNINFO,   listheader2,
                   LISTBROWSER_LABELS, listitems6,
                 ListBrowserEnd,
                 Button(' Load units from Devs:ProNET/.config ',ID_BUTTON2),
                 ListBrowser(ID_LISTBROWSER3),
                   LISTBROWSER_COLUMNTITLES, TRUE,
                   LISTBROWSER_COLUMNINFO,   listheader3,
                   LISTBROWSER_LABELS, listitems7,
                   GA_READONLY, TRUE,
                 ListBrowserEnd,
                 Button(' Stop ProNET-Server on all units ',ID_BUTTON3),
                 LayoutEnd,
               PageEnd,

               Page,
                 ClickTabTitles(listitems2,ID_CLICKTAB2),
                   ClickTabPages,

                     Page_so_si,
                       Layout_so_si_v,
                         ListBrowser(ID_LISTBROWSER4),
                           LISTBROWSER_COLUMNTITLES, TRUE,
                           LISTBROWSER_COLUMNINFO,   listheader1,
                           LISTBROWSER_LABELS, listitems5,
                           LISTBROWSER_MINVISIBLE, 9,
                           LISTBROWSER_AUTOFIT, TRUE,
                         ListBrowserEnd,
                         Stringad_ro('Start the remote server before attempting to scan it',ID_STRING1,60,0),
                         Layout_so_si,
                           Layout_v,
                             Button(' Scan Server ',ID_BUTTON4),
                           LayoutEnd,
                           Layout_v,
                             ChooserPU(listitems3,ID_CHOOSER2,3), ->CHILD_WEIGHTEDWIDTH, 0,
                             Label('  Unit:'),
                           LayoutEnd,
                           Layout_v,
                             Stringad_d('',ID_STRING2,20,10),
                             Label('  Local Name:'),
                           LayoutEnd,
                         LayoutEnd,
                       LayoutEnd,
                     PageEnd,

                     Page_so_si_cj,
                       Layoutex_so_si_v_cj(' Send message to Server '),
                         Space,
                         Space,
                         Label(' Message:\n '),
                         Stringad('',ID_STRING3,60,0),  ->Stringad(gid,text,maxchars,show)
                         Layout_so_si,
                           Space,
                           ChooserPU(listitems3,ID_CHOOSER3,3),     ->CHILD_WEIGHTEDWIDTH, 0,
                           Label('Unit:'),
                           Space,
                           Button_MinW(' Send message ',ID_BUTTON5),
                           Space,
                         LayoutEnd,
                       LayoutEnd,
                       CHILD_WEIGHTEDHEIGHT, 0,
                     PageEnd,

                     Page_so_si_cj,
                       Layoutex_so_si_v_cj(' Chat with Server '),
                         Button_MinW(' Start Pronet-talk on both machines ',ID_BUTTON6),
                         ChooserPU(listitems3,ID_CHOOSER4,3),     ->CHILD_WEIGHTEDWIDTH, 0,
                         Label('Unit:'),
                       LayoutEnd,
                       CHILD_WEIGHTEDHEIGHT, 0,
                       CHILD_WEIGHTEDWIDTH, 0,
                     PageEnd,

                   ClickTabPagesEnd,
                 ClickTabTitlesEnd,
               PageEnd,

             ClickTabPagesEnd,
           ClickTabTitlesEnd,
         LayoutEnd,
       WindowEnd  -> NIL])

     IF win_object                                   -> Object creation sucessful?
      IF (win:=RA_OpenWindow(win_object))            -> Open the window.
        GetAttr(WINDOW_SIGMASK,win_object,{signal})  -> Get the window wait signal mask.
        WHILE done=FALSE                             -> Input Event Loop
          wait:=Wait(signal OR SIGBREAKF_CTRL_C)
          IF (wait AND SIGBREAKF_CTRL_C)
            done:=TRUE
          ELSE
            WHILE (result:=RA_HandleInput(win_object,code)) <> WMHI_LASTMSG
              tmpres:=(result AND WMHI_CLASSMASK)
              SELECT tmpres
                CASE WMHI_CLOSEWINDOW;  done:=TRUE
                CASE WMHI_ICONIFY
                  RA_Iconify(win_object)
                  win:=NIL
                CASE WMHI_UNICONIFY
                  IF (win:=RA_Uniconify(win_object))
                    GetAttr(WINDOW_SIGMASK,win_object,{signal})
                  ELSE
                    done:=TRUE
                  ENDIF
                CASE WMHI_GADGETUP
                  tmpres2:=(result AND WMHI_GADGETMASK)
                  SELECT tmpres2
                    CASE ID_BUTTON4; PrintF('Scan button was clicked\n')
                  ENDSELECT
              ENDSELECT
            ENDWHILE
          ENDIF
        ENDWHILE
      ENDIF

      /* Disposing of the window object will also close the window if it is
       * already opened and it will dispose of all objects attached to it. */

      DisposeObject(win_object)
    ENDIF
  ELSE
    PrintF('failed to open a library\n')
  ENDIF

  FreeListBrowserList(listitems8)
  FreeListBrowserList(listitems7)
  FreeListBrowserList(listitems6)
  FreeListBrowserList(listitems5)
  freeChooserNodes(listitems4)
  freeChooserNodes(listitems3)
  freeClickTabNodes(listitems2)
  freeClickTabNodes(listitems1)

   /* Close the classes. */

  IF listbrowserbase THEN CloseLibrary(listbrowserbase)
  IF stringbase THEN CloseLibrary(stringbase)
  IF chooserbase THEN CloseLibrary(chooserbase)
  IF spacebase THEN CloseLibrary(spacebase)
  IF labelbase THEN CloseLibrary(labelbase)
  IF clicktabbase THEN CloseLibrary(clicktabbase)
  IF layoutbase THEN CloseLibrary(layoutbase)
  IF windowbase THEN CloseLibrary(windowbase)

ENDPROC
