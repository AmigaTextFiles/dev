OPT MODULE
OPT PREPROCESS,EXPORT

/*
          File: nListView_Class.e
   Description: Klasa ListView umoûliwiajâca scrollowanie w poziomie
     Copyright: Copyright (c) 1996 Piotr Gapiïski (kolo8@ely.pg.gda.pl)
         All Rights Reserved.

         Class: nListView (private)
    Superclass: BGUI_LISTVIEW_GADGET (public)

*/

MODULE 'bgui/bguic','bgui/bgui'
-> MODULE 'libraries/bgui','libraries/bguic'
MODULE 'utility/tagitem'

#define NLISTVIEWNAME    'gadgets/nlistview_bgui.gadget'
#define NLISTVIEWVERSION 0

CONST LISTV_HORIZOFFSET           = TAG_USER + $80000 + 1,   /*ISGN*/
      LISTV_HORIZOFFSET_RIGHT     = -1,
      LISTV_HORIZOFFSET_LEFT      = -2,
      LISTV_HORIZOFFSET_PAGE_LEFT = -3,
      LISTV_HORIZOFFSET_PAGE_RIGHT= -4,
      LISTV_HORIZOFFSET_FIRST     = -5,
      LISTV_HORIZOFFSET_LAST      = -6

CONST LISTV_HORIZSTEPS            = TAG_USER + $80000 + 2,   /*I.G.*/
      LISTV_SCROLLCOLUMN          = TAG_USER + $80000 + 3,   /*I...*/
      LISTV_HORIZOBJECT           = TAG_USER + $80000 + 4,   /*I.G.*/
      LISTV_VERTOBJECT            = LISTV_PROPOBJECT         /*ISG.*/

