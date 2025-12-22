-> Quick paint!

MODULE 'muse/muse','intuition/intuition','muse/manipulators'

ENUM NONE, DOTS, LINES, CIRCLES, BOXES, COLOUR

DEF mode=DOTS, first=TRUE, two_params=FALSE, x,y, tx,ty, render=NIL, colour=1,
    quickpalette=NIL, drawtools=NIL

/*{------------------------------ The Program ------------------------------}*/
PROC initialise_draw_tools() IS [ [BOXES,  [{box},      TRUE ]],
                                  [DOTS,   [{plotpoint},FALSE]],
                                  [LINES,  [{drawline}, TRUE ]],
                                  [CIRCLES,[{circle},   TRUE ]]
                                ]

/*{-------------- Set The Mode to that specified by the user ---------------}*/
PROC setmode(event,wind)
DEF set_mode_info
   mode:=event
   set_mode_info:=info2data(mode,drawtools)
   IF Not(set_mode_info <=> [render,two_params])
      request('Umm, something''s gone wrong\n\event=\d\nwindow=\s\n'+
              'Will abort when you click OK',
              'OK',[event, get_winname(wind)])
      Raise(1)
   ENDIF
ENDPROC

/*{----------- Set the current pen to that specified by the user -----------}*/
PROC setcolour()
   IF quickpalette=NIL THEN quickpalette:=get_gadgethandle('colour')
   Colour(colour:=get_gadget_info(quickpalette))
ENDPROC

/*{-------------------------- Rendering functions --------------------------}*/
PROC mouse(wind:PTR TO window )
   stdrast:=wind.rport
   IF first
      x:=posx; y:=posy
      IF Not(two_params) THEN render(x,y)
   ELSE
      tx:=posx; ty:=posy
      IF two_params THEN render(clip(x),clip(y),clip(tx),clip(ty))
   ENDIF
   first:=Not(first)
ENDPROC

PROC clip(loc) IS IF loc<0 THEN 0 ELSE loc
PROC box(x,y,x1,y1)
DEF xt,yt
   IF x>x1 THEN x1:=(x:=(xt:=x) BUT x1) BUT xt
   IF y>y1 THEN y1:=(y:=(yt:=y) BUT y1) BUT yt
   WaitBlit()
   Box(x,y,x1,y1,colour)
ENDPROC
PROC circle(x,y,x1,y1)
   WaitBlit()
   DrawEllipse(stdrast,x,y, x1-x,y1-y)
ENDPROC
PROC drawline(x,y,x1,y1)
   WaitBlit()
   Line(x,y,x1,y1)
ENDPROC
PROC plotpoint(x,y)
   WaitBlit()
   Plot(x,y)
ENDPROC

/*{---------------- Yes, I _DO_ want to close this window! -----------------}*/
PROC closeit() IS CLOSE

/*{------------------------------ Startup-code -----------------------------}*/
PROC main()
   drawtools:=initialise_draw_tools()
   setmode(CIRCLES,NIL)
   interface()
ENDPROC

/*{------------ The interface declaration & processing section -------------}*/
PROC keys() IS [KEYS, [  [".",DOTS], ["l",LINES], ["c",CIRCLES],["b",BOXES],
                         ["q", QUIT],
                         ["k", CLOSE]
                      ]
               ]

PROC drawwindow()
DEF title, box, mywindow
   title:=    [TITLE, 'Easy Paint : Draw Window']
   box:=      [BOX, [50,80,550,170]]
   mywindow:= [title, box,keys(), [MOUSE,1]]
ENDPROC mywindow

PROC toolbar()
DEF title, box, mywindow, gadgets
   title:=    [TITLE, 'Easy Paint : Tool Bar']
   box:=      [BOX, [50,3,200,71]]
   gadgets:= [ ['STD_IMAGE', [DOTS,'',NORMAL,5,16,'DOTS']],
               ['STD_IMAGE', [BOXES,'',NORMAL,36,16,'BOX_FILL']],
               ['STD_IMAGE', [LINES,'',NORMAL,5,31,'LINE']],
               ['STD_IMAGE', [CIRCLES,'',NORMAL,36,31,'CIRCLE']],
               ['PALLETE',   [COLOUR, 'colour', 'Select Colour',67,16,62,31,2]]
             ]
   mywindow:=[title, box, [GADGETS, gadgets], keys()]
ENDPROC mywindow

PROC interface()
DEF events
   events:=   [ [DOTS,    {setmode}],   [LINES,   {setmode}],
                [CIRCLES, {setmode}],   [BOXES,   {setmode}],
                [MOUSE,   {mouse}],
                [COLOUR,  {setcolour}],
                [CLOSE,   {closeit}]
              ]
   easy_muse([ [EVENTS, events],
               [WINDOW, drawwindow()],
               [WINDOW, toolbar()]
             ])
ENDPROC
