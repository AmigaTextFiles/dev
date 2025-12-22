/* An old ClassAct example converted to PortablE.
   From http://aminet.net/package/dev/gui/ClassAct2Demo */

/* ClickTabExample.e - Ported to E by Eric Sauvageau. */

OPT AMIGAE
OPT PREPROCESS

MODULE 'tools/constructors', 'tools/boopsi'

MODULE 'exec/types','exec/memory','dos/dos','dos/dosextens','exec/lists',
       'exec/nodes','intuition','graphics','intuition/intuition',
       'intuition/gadgetclass','intuition/imageclass',
       'intuition/intuitionbase','intuition/classusr',
       'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
       'intuition/classes','intuition/sghooks','graphics/gfxbase',
       'graphics/text','graphics/gfxmacros','utility/tagitem','utility/hooks'


MODULE 'clicktab','gadgets/clicktab','window','classes/window','layout',
       'gadgets/layout', 'other/classact_macros'

DEF listitems:PTR TO mlh


CONST ID_CLICKTAB =1

PROC clickTabNodes(list:PTR TO lh, labels:PTR TO LONG)
DEF node=NIL, i=0

   newlist(list)

   WHILE labels[i]

      IF (node := AllocClickTabNodeA([TNA_TEXT, labels[i],
                                      TNA_NUMBER, i,
                                      TNA_ENABLED, TRUE,
                                      TNA_SPACING, 6,
                                      TAG_DONE]))

         AddTail(list,node)
      ENDIF

      INC i

   ENDWHILE
ENDPROC


PROC freeClickTabNodes(list:PTR TO lh)
DEF node:PTR TO ln, nextnode:PTR TO ln

   node:= list.head

   WHILE (nextnode := node.succ)
      FreeClickTabNode(node)
      node := nextnode
   ENDWHILE

   END list  -> Optional, the E cleanup code would do it for us anyway.
ENDPROC



PROC main()
DEF win=NIL:PTR TO window, tab_object=NIL:PTR TO object, win_object=NIL:PTR TO object
DEF wait, signal, result, done = FALSE, code, tmpres,tmpres2
DEF names:PTR TO LONG

   names:=['Tab_1','Tab_2','Tab_3','Tab_4',NIL]

->  Open the classes.  We could also use openClass() from classact_lib.m

   windowbase := OpenLibrary('window.class',0)
   layoutbase := OpenLibrary('gadgets/layout.gadget',0)
   clicktabbase := OpenLibrary('gadgets/clicktab.gadget',0)

   IF (windowbase AND layoutbase AND clicktabbase)
      clickTabNodes(NEW listitems, names)

      /* Create the window object. */
      win_object := WindowObject,
                       WA_SCREENTITLE, 'ClassAct Copyright 1995, Phantom Development LLC.',
                       WA_TITLE, 'ClassAct clicktab.gadget Example',
                       WA_SIZEGADGET, TRUE,
                       WA_LEFT, 40,
                       WA_TOP, 30,
                       WA_DEPTHGADGET, TRUE,
                       WA_DRAGBAR, TRUE,
                       WA_CLOSEGADGET, TRUE,
                       WA_ACTIVATE, TRUE,
                       WA_SMARTREFRESH, TRUE,
                       WINDOW_PARENTGROUP, VLayoutObject,
                          LAYOUT_SPACEOUTER, TRUE,
                          LAYOUT_DEFERLAYOUT, TRUE,
                          LAYOUT_ADDCHILD, tab_object := ClickTabObject,
                             GA_ID, ID_CLICKTAB,
                             CLICKTAB_LABELS, listitems,
                             CLICKTAB_CURRENT, 0,
                          End,
                       End,
                    End

-> Object creation sucessful?

      IF win_object

-> Open the window.

         IF (win := CA_OpenWindow(win_object))
				
-> Obtain the window wait signal mask.

            GetAttr( WINDOW_SIGMASK, win_object, ADDRESSOF signal)

-> Input Event Loop

            WHILE done = FALSE
               wait:= Wait(signal OR SIGBREAKF_CTRL_C)

               IF (wait AND SIGBREAKF_CTRL_C)
                  done := TRUE					
               ELSE

                  WHILE (result := domethod(win_object, [WM_HANDLEINPUT,ADDRESSOF code])) <> WMHI_LASTMSG
                     tmpres := (result AND WMHI_CLASSMASK)
                     SELECT tmpres
         
                        CASE WMHI_CLOSEWINDOW
                             done := TRUE

                        CASE WMHI_GADGETUP
                           tmpres2 := (result AND WMHI_GADGETMASK)

                           SELECT tmpres2
                             CASE ID_CLICKTAB ; NOP

                           ENDSELECT

                     ENDSELECT
                  ENDWHILE
               ENDIF
            ENDWHILE
         ENDIF

         /* Disposing of the window object will
          * also close the window if it is
          * already opened and it will dispose of
          * all objects attached to it.
          */
          DisposeObject(win_object)
      ENDIF

   ENDIF

   freeClickTabNodes(listitems)

   /* Close the classes. */

   IF clicktabbase THEN CloseLibrary(clicktabbase)
   IF layoutbase THEN CloseLibrary(layoutbase)
   IF windowbase THEN CloseLibrary(windowbase)

ENDPROC
