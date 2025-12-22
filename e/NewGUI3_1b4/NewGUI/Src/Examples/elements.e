/* 
 *  Showing some NewGUI-Features
 * -============================-
 * 
 * 
 */

OPT     OSVERSION = 37
OPT     LARGE
OPT     PREPROCESS                      -> Needed for the gfxmacros.m

MODULE  'graphics/rastport'             -> Needed for the gfxmacros.m
MODULE  'graphics/gfxmacros'            -> Needed for the SetAfPt()-Function
MODULE  'libraries/gadtools'            -> Expected for the newmenu-object
MODULE  'newgui/newgui'                 -> The main gui engine
MODULE  'newgui/ng_showerror'           -> reports error-codes to con:

ENUM    GUI_MAIN = 1,
        GUI_BEVELS,
        GUI_FILLGROUPS,
        GUI_STANDART

DEF     menu=NIL:PTR TO newmenu

DEF     string[20]:STRING

PROC main()     HANDLE
 makemenu()
  opengui()

EXCEPT DO
  IF exception THEN ng_showerror(exception)
 CleanUp(exception)
ENDPROC

PROC makemenu()
ENDPROC

PROC opengui()
 newguiA([
        NG_WINDOWTITLE,         'Gui-Elements',
        NG_GUIID,               GUI_MAIN,
        NG_MENU,                menu,
        NG_GUI,                 
                [EQROWS,
                        [SBUTTON,{openwin},'Bevelboxes',GUI_BEVELS],
                        [SBUTTON,{openwin},'Fillgroups',GUI_FILLGROUPS],
                        [SBUTTON,{openwin},'Standart',GUI_STANDART]
                ],
        NG_NEXTGUI,
->
       [NG_WINDOWTITLE,         'Bevel-Boxes',
        NG_USEMAINMENU,         TRUE,
        NG_GUIID,               GUI_BEVELS,
        NG_GUI,
->
                [EQROWS,
                [EQCOLS,
                [BEVEL,
                [EQROWS,
                        [TEXT,'Box','Bevel',FALSE,3]
                ]
                ],
                [DBEVEL,
                [EQROWS,
                        [TEXT,'BevelBox','Double',FALSE,3]
                ]
                ]
                ],
                [EQCOLS,
                [ROWS,
                [BAR]],
                        [TEXT,'Bar','Simple',FALSE,0],
                [ROWS,
                [BAR]]
                ],
                [EQCOLS,
                [BEVELR,
                [EQROWS,
                        [TEXT,'BevelBox','Recessed',FALSE,3]
                ]
                ],
                [DBEVELR,
                [EQROWS,
                        [TEXT,'DoubleBevel','Recessed',FALSE,3]
                ]
                ]
                ],
                [EQCOLS,
                [ROWS,
                [BARR]],
                        [TEXT,'Bar','Recessed',FALSE,0],
                [ROWS,
                [BARR]]
                ],
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,0,'Close'],
                [SPACEH]
                ]
                ],
        NG_NEXTGUI,
->
       [NG_WINDOWTITLE,         'Fillgroups',
        NG_USEMAINMENU,         TRUE,
        NG_GUIID,               GUI_FILLGROUPS,
        NG_FILLHOOK,            {fillrect},
        NG_GUI,
                [ROWS,
                [BEVELR,
                [FILLGROUP1,
                [ROWS,
                        [TEXT,'are free definable by the developer','The Patterns and colors',FALSE,3],
                        [TEXT,'window-backdrop (filling)','Have a look at the',FALSE,3]]
                ]],
                [EQCOLS,
                [DBEVELR,
                [FILLGROUP1,
                [ROWS,
                        [TEXT,'1','Group',FALSE,0]
                ]]],
                [DBEVELR,
                [FILLGROUP2,
                [ROWS,
                        [TEXT,'2','Group',FALSE,0]
                ]]],
                [DBEVELR,
                [FILLGROUP3,
                [ROWS,
                        [TEXT,'3','Group',FALSE,0]
                ]]]],
                [EQCOLS,
                [DBEVELR,
                [FILLGROUP4,
                [ROWS,
                        [TEXT,'4','Group',FALSE,0]
                ]]],
                [DBEVELR,
                [FILLGROUP5,
                [ROWS,
                        [TEXT,'5','Group',FALSE,0]
                ]]],
                [DBEVELR,
                [FILLGROUP6,
                [ROWS,
                        [TEXT,'6','Group',FALSE,0]
                ]]]],
                [BEVELR,
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,0,'Close'],
                [SPACEH]
                ]
                ]
                ],
        NG_NEXTGUI,
->
       [NG_WINDOWTITLE,         'Standart-Elements',
        NG_USEMAINMENU,         TRUE,
        NG_GUIID,               GUI_STANDART,
        NG_GUI,
                [ROWS,
                [COLS,
                [ROWS,
                        [TEXT,'without Bevel','Text',FALSE,3],
                        [TEXT,'with Bevel','Text',TRUE,3]],
                [ROWS,
                        [NUM,999,'Number without Bevel',FALSE,3],
                        [NUM,123,'Number with Bevel',TRUE,3]]],
                [BAR],
                [EQCOLS,
                [COLS,
                        [RBUTTON,0,'Button with Free Height'],
                [SPACEH]],
                [ROWS,
                [COLS,
                        [BUTTON,0,'Fixed Button'],
                [SPACEH]],
                        [SBUTTON,0,'Button with free Width']
                ]],
                [BAR],
                        [PALETTE,0,'Palette:',3,5,2,0],
                [BAR],
                [COLS,
                        [MX,0,'MX:',['one','two','three','four',NIL],FALSE,1],
                [ROWS,
                        [CYCLE,0,'Cycle:',['one','two','three','four',NIL],1],
                        [CHECK,0,'Check:',FALSE,FALSE]
                ]
                ],
                [BAR],
                [COLS,
                        [LISTV,0,'ListView:',NIL,2,2,NIL,FALSE,0,0],
                [BARR],
                [ROWS,
                        [SCROLL,0,FALSE,10,0,2,2],
                        [SLIDE,0,'Slider:     ',FALSE,0,999,20,2,'%3ld'],
                [BAR],
                        [STR,0,'String:',string,10,2],
                        [INTEGER,0,'Integer:',5,3]
                ]],
                [BAR],
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,0,'Close'],
                [SPACEH]
                ]
                ],
        NIL,NIL],
->        
        NIL,NIL,
->
        NIL,NIL],        
->
        NIL,NIL],
->
        NIL,NIL])
ENDPROC

PROC openwin(id,gui)                                    -> Open a window dynamic (from the given id!)
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       id,
        NIL,            NIL])
ENDPROC

PROC fillrect(rp,x,y,width,height,type)
 DEF    oldbpen=0,
        oldapen=1
  SELECT        type
        CASE    NG_FILL_WINDOW                          -> Window-Filling (Back)
         oldbpen:=SetBPen(rp,0)                         -> Set Backpen to gray
          oldapen:=SetAPen(rp,3)                        -> Set Frontpen to blue
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> Set Pattern (ATTENTION! Macro-Definition in gfxmacros.m, this need OPT PREPROCESS!!!)
            RectFill(rp,x,y,width,height)               -> Now fill the Region!
           SetBPen(rp,oldbpen)                          -> Set the Backpen to the old value
          SetAPen(rp,oldapen)                           -> Set the Frontpen to the old value
        CASE    FILLGROUP1                              -> Fill the Group 1
         oldbpen:=SetBPen(rp,0)                         -> Set BackPen to gray
          oldapen:=SetAPen(rp,0)                        -> Set Frontpen to gray
           SetAfPt(rp,[$FFFF,$FFFF]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
        CASE    FILLGROUP2                              -> Fill the Group 2
         oldbpen:=SetBPen(rp,3)                         -> Set the Backpen to blue
          oldapen:=SetAPen(rp,2)                        -> Set the Frontpen to white
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
        CASE    FILLGROUP3                              -> Fill the Group 3
         oldbpen:=SetBPen(rp,3)                         -> Set the Backpen to blue
          oldapen:=SetAPen(rp,0)                        -> Set the Frontpen to gray
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
        CASE    FILLGROUP4                              -> Fill the Group 4
         oldbpen:=SetBPen(rp,3)                         -> Set the Backpen to blue
          oldapen:=SetAPen(rp,7)                        -> Set the Frontpen to mwb-color 7
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
        CASE    FILLGROUP5                              -> Fill the Group 5
         oldbpen:=SetBPen(rp,0)                         -> Set the Backpen to gray
          oldapen:=SetAPen(rp,7)                        -> Set the Frontpen to mwb-color 7
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
        CASE    FILLGROUP6                              -> Fill the Group 6
         oldbpen:=SetBPen(rp,3)                         -> Set the Backpen to blue
          oldapen:=SetAPen(rp,6)                        -> Set the Frontpen to mwb-color 6
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> ...
            RectFill(rp,x,y,width,height)               -> ...
           SetBPen(rp,oldbpen)                          -> ...
          SetAPen(rp,oldapen)                           -> ...
   ENDSELECT
ENDPROC
