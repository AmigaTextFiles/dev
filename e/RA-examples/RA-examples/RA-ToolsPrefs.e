
/*   ToolsPrefs reaction gui example in Amiga E by Dave Norris  */

OPT PREPROCESS

MODULE 'tools/constructors', 'tools/boopsi'

MODULE 'exec/types','exec/memory','dos/dos','dos/dosextens','exec/lists',
       'exec/nodes','intuition','graphics','intuition/intuition','exec/ports',
       'intuition/gadgetclass','intuition/imageclass',->'amigalib/boopsi',
       'intuition/intuitionbase','intuition/classusr',->'',
       'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
       'intuition/classes','intuition/sghooks','graphics/gfxbase',
       'graphics/text','graphics/gfxmacros','utility/tagitem','utility/hooks'

MODULE 'window','classes/window','layout','gadgets/layout',
       'images/bevel','images/glyph','listbrowser','gadgets/listbrowser',
       'space','gadgets/space','chooser','gadgets/chooser','string','gadgets/string',
       'checkbox','gadgets/checkbox','integer','gadgets/integer',
       'reaction/reaction_macros','label','images/label' ,'gadgets/clicktab'

DEF listitems1:PTR TO mlh, appport:PTR TO mp

ENUM ID_LISTBROWSER1, ID_LISTBROWSER2, ID_CHECKBOX1, ID_CHECKBOX2, ID_CHOOSER1,
     ID_STRING1, ID_STRING2, ID_STRING3, ID_STRING4, ID_STRING5, ID_INTEGER1,
     ID_BUTTON1, ID_BUTTON2, ID_BUTTON3, ID_BUTTON4, ID_BUTTON5,ID_BUTTON6,
     ID_BUTTON7, ID_BUTTON8, ID_BUTTON9

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

PROC main()
DEF win=NIL:PTR TO window, win_object=NIL:PTR TO object, chooserlist1:PTR TO LONG,
    wait, signal, result, done = FALSE, code, tmpres, tmpres2

  chooserlist1:=[' WB','CLI',NIL]

->  Open the classes

  windowbase := OpenLibrary('window.class',0)
  layoutbase := OpenLibrary('gadgets/layout.gadget',0)
  labelbase := OpenLibrary('images/label.image',0)
  spacebase := OpenLibrary('gadgets/space.gadget',0)
  chooserbase := OpenLibrary('gadgets/chooser.gadget',0)
  stringbase := OpenLibrary('gadgets/string.gadget',0)
  listbrowserbase := OpenLibrary('gadgets/listbrowser.gadget',0)
  checkboxbase := OpenLibrary('gadgets/checkbox.gadget',0)
  integerbase := OpenLibrary('gadgets/integer.gadget',0)

  appport:=CreateMsgPort()

  IF (windowbase AND layoutbase AND labelbase AND spacebase AND chooserbase AND stringbase AND listbrowserbase)

    chooserNodes(NEW listitems1 ,chooserlist1)

    win_object:=WindowObject,              -> Create the window object.

        [WA_SCREENTITLE,        ' ToolsPrefs gui reaction example',
         WA_TITLE,              ' ToolsPrefs gui reaction example',
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
           Layout_si,
             Layout_so_si_v,
               Layoutex_so_si_v('Menu Items'),
                 ListBrowser(ID_LISTBROWSER1),
                   LISTBROWSER_MINVISIBLE, 9,
                 ListBrowserEnd,
                 Stringad('',ID_STRING1,20,10),
                 Layout_si_e,
                   Button('_New',ID_BUTTON1),
                   Button('Delete',ID_BUTTON2),
                   Button('Insert',ID_BUTTON3),
                 LayoutEnd,
               LayoutEnd,
             LayoutEnd,
             Layout_si_v,
               Space,
               CheckBox('_Menu',ID_CHECKBOX1,FALSE),
               CheckBox('_Sub',ID_CHECKBOX2,FALSE),
               Button('Bar',ID_BUTTON4),
               Space,
               Layoutex_so_si_bo('AmiKey'),
                 Stringad('',ID_STRING2,10,0),
               LayoutEnd,
               Space,
               Layoutex_so_si_bo('Comment'),
                 Stringad('',ID_STRING3,10,0),
               LayoutEnd,
               Space,
             LayoutEnd,
             Layout_so_si_v,
               Layoutex_so_si('Hot Key'),
                 Stringad('',ID_STRING4,20,0),
               LayoutEnd,
               Layoutex_so_si_v('Commands'),
                 ListBrowser(ID_LISTBROWSER2),
                   LISTBROWSER_MINVISIBLE, 6,
                 ListBrowserEnd,
                 Layout_si,
                   Stringad('',ID_STRING5,10,0),
                   Integer(4096,ID_INTEGER1,FALSE),
                   CHILD_WEIGHTEDWIDTH, 0,
                 LayoutEnd,
                 Layout_si,
                   Layout_si_e,
                     Button('_Add',ID_BUTTON5),
                     Button('Delete',ID_BUTTON6),
                     Button('Insert',ID_BUTTON7),
                   LayoutEnd,
                   ChooserPU(listitems1,ID_CHOOSER1,2),
                 LayoutEnd,
               LayoutEnd,
             LayoutEnd,
           LayoutEnd,
           Layout_so_si_e,
             Button('Save',ID_BUTTON8),
             CHILD_WEIGHTEDWIDTH, 0,
             Button(' Cancel ',ID_BUTTON9),
             CHILD_WEIGHTEDWIDTH, 0,
           LayoutEnd,
         LayoutEnd,
       WindowEnd

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
                    CASE ID_BUTTON9; done:=TRUE    -> ID_BUTTON9 = Cancel button
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

  freeChooserNodes(listitems1)

   /* Close the classes. */

  IF integerbase THEN CloseLibrary(integerbase)
  IF checkboxbase THEN CloseLibrary(checkboxbase)
  IF listbrowserbase THEN CloseLibrary(listbrowserbase)
  IF stringbase THEN CloseLibrary(stringbase)
  IF chooserbase THEN CloseLibrary(chooserbase)
  IF spacebase THEN CloseLibrary(spacebase)
  IF labelbase THEN CloseLibrary(labelbase)
  IF layoutbase THEN CloseLibrary(layoutbase)
  IF windowbase THEN CloseLibrary(windowbase)

ENDPROC
