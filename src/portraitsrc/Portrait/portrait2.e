-> TODO
-> Scrollers (don't actually work)
-> PLUGINS FOR AMINET RELEASE (at least one anyway, for demo purposes)
-> Project Window
-> Shapes window
-> Lines
-> Rectangles
-> Circles
-> Gradient window
-> Stencils
-> Brushes + Multiple Brushes
-> Support for >8-bit displays (ie. gfx-cards)
-> ^^ This needs more work than I tought (perhaps move it a bit further down???)
-> XPK compression for work buffer
-> Effects
-> Savers/Loaders

/****************************************************************************

Portrait.e
PortraitMode.E
© Christopher January 1998

****************************************************************************/

OPT PREPROCESS
#define DEBUG 1
OPT LARGE
->OPT REG=5
OPT OSVERSION=39
MODULE 'tools/easygui', 'plugins/colorwheel', '*/plugins/colourgrid', 'gadgets/colorwheel', '*/plugins/gradient', 'tools/file', 'graphics/text'
MODULE 'graphics/view','graphics/rastport','graphics/gfx','intuition/screens','intuition/intuition','graphics/clip','graphics/regions','exec/memory'
MODULE 'gadtools', 'libraries/gadtools', 'intuition/gadgetclass'
MODULE 'tools/copylist', 'utility/tagitem', 'asl', 'libraries/asl', 'tools/exceptions'
MODULE 'iffparse','libraries/iffparse','dos/dostags', 'dos/dos','prefs/prefhdr'
MODULE 'datatypes', 'datatypes/pictureclass', 'graphics/view', 'utility/tagitem',
       'datatypes/datatypes', 'datatypes/datatypesclass', 'intuition/classusr',
       'intuition/classes', 'graphics/gfx', 'graphics/modeid','gadgets/gradientslider',
       '*/plugins/ratio', 'graphics/scale', 'amigaguide', 'libraries/amigaguide',
       'exec/ports','plugins/tabs','gadgets/tabs'

CONST ID_PORT="PORT"
CONST ID_WORK="WORK"
CONST ID_PHDR="PHDR"
CONST ID_RNDR="RNDR"
ENUM SEL=1,MENU
ENUM CONTINUOUS=0, LINE, RECTANGLE, FILL, CLEAR, MAXDRAWMODE
ENUM OPEN=0,SAVE,PRINT,INFORMATION,MAXTOOLBAR
ENUM SQUARE,CIRCLE,BRSH
ENUM DOTTED=1,DASHED
ENUM SOLID,TRANSPARENCY,GRADIENT,BRUSH
SET CF_24BIT,CF_NEEDUPDATE,CF_USINGVMEM,CF_FORCEVMEM,CF_USEVMEM
ENUM FOREGROUND,BACKGROUND
ENUM GRAD_UPDOWN,GRAD_LEFTRIGHT
ENUM OUTLINE,FILLED
ENUM T_NONE,T_COLOUR,T_FLOOD

ENUM ERR_IFF=1,ERR_OPEN,ERR_LIB

OBJECT icon
  dto
  bitmap:PTR TO bitmap
  bmhd:PTR TO bitmapheader
ENDOBJECT
OBJECT drawmode OF plugin
  icon[MAXDRAWMODE]:ARRAY OF icon
  width,height
  mousex,mousey
  vis
ENDOBJECT
OBJECT toolbar OF plugin
  icon[MAXDRAWMODE]:ARRAY OF icon
  width,height
  mousex,mousey
  vis
  sel
ENDOBJECT
OBJECT colour
 red,green,blue:LONG
ENDOBJECT
OBJECT arrangewindow
  gui:PTR TO guihandle
  w,h:INT
ENDOBJECT
OBJECT pengradient
  direction:INT
  start:colour
  end:colour
ENDOBJECT
OBJECT brush
  width,height:INT
  bitmap:PTR TO bitmap
  pastemode:INT
  transparency:INT
  tcol:colour
  handle:INT
  outline:INT
  ratiox,ratioy:INT
ENDOBJECT
OBJECT pen
  size:INT
  shape:INT
  flags:INT
  transparency:INT
  brush:PTR TO brush
ENDOBJECT
OBJECT shape
  type:INT
  transparency:INT
ENDOBJECT
OBJECT line
  style:INT
ENDOBJECT
OBJECT xy
  x,y:INT
ENDOBJECT
OBJECT fill
  type:INT
  gradient:PTR TO pengradient
  brush:PTR TO brush
  flags:INT
  tolerance:INT
  transparency:INT
ENDOBJECT
OBJECT colourpen
  c:colour
  pen:LONG
ENDOBJECT
OBJECT canvas OF plugin
  ox,oy:LONG -> Offset for scrollers
  width,height:LONG -> Width and height
  zwidth,zheight:LONG -> Display width and height (inc. zoom)
  rastport:rastport -> Rastport for bitmap below
  bitmap:PTR TO bitmap -> Remapped bitmap
  true:PTR TO colour -> 24-Bit colour array
  scr:PTR TO screen -> Screen (for ObtainPenA)
  line:PTR TO line
  pen:PTR TO pen -> Current pen style(s)
  fill:PTR TO fill -> Current fill style (s)
  shape:PTR TO shape
  brush:PTR TO brush
  penarray[125]:ARRAY OF colourpen -> Array of colours for remapping
  remaparray[4096]:ARRAY OF CHAR -> (Much) Faster remapping
  flags:LONG -> Flags (inc. CF_NEEDUPDATE)
  minx,miny,maxx,maxy:LONG -> Area that needs to be updated
  butt:CHAR -> Mouse button held down
  mousex,mousey:LONG -> Mouse coordinates
  busy:CHAR -> Is Canvas busy (NOT IMPLEMENTED)
  horizgadget:PTR TO gadget -> Horizontal scroller gadget
  vertgadget:PTR TO gadget ->  Vertical scroller gadget
  fg:colour -> Foreground colour
  px,py:LONG -> Previous X, Y for continuous, box, etc.
  sx,sy:LONG -> Start X,Y for box, circle, etc.
  wpx,wpy:LONG -> Relative to window border
  wsx,wsy:LONG
  gl,vis,ta:LONG -> Gadget list, visual info and textattr
  vmem:LONG -> Vmem file handle
  vbuf:PTR TO CHAR -> Virtual memory buffer
  vptr:LONG -> Offset in virtual memory
  vsize:LONG -> Size of virtual memory page
  ratiox,ratioy:INT -> Zoom ratio
  scrolling:INT
  gad:PTR TO gadget
  pickup:CHAR -> Need to pick up brush? (Used in continuous drawing)
  gradminx, gradminy, gradmaxx, gradmaxy:INT -> Min, max coordinates (for gradients)
ENDOBJECT

OBJECT windowdimensions
  leftedge,topedge:INT
  width,height:INT
ENDOBJECT

OBJECT prefs
  displayid:LONG
  displaydepth:INT
  grayscale:CHAR
  canvaswindow:windowdimensions
  colourwindow:windowdimensions
  drawmodewindow:windowdimensions
  zoomwindow:windowdimensions
  statswindow:windowdimensions
  fillwindow:windowdimensions
  penwindow:windowdimensions
  anywindow:windowdimensions
  windows:LONG
  vmemloc[32]:ARRAY OF CHAR
  defwidth,defheight:INT
  vsize:LONG
  shapewindow:windowdimensions
  brushwindow:windowdimensions
  dmiconloc[64]:ARRAY OF CHAR
  tbiconloc[64]:ARRAY OF CHAR
  tbwindow:windowdimensions
  flags
  linewindow:windowdimensions
ENDOBJECT

SET CANVAS,COLOUR,DRAWMODE,ZOOM,STATISTICS,FILLWIN,PEN,SHAPE,BRUSHWIN,TOOLBAR,LINEWIN

DEF scr=NIL:PTR TO screen, rgb:colorwheelrgb, status=NIL:PTR TO window

DEF canvas=NIL:PTR TO canvas, cg=NIL:PTR TO colourgrid,
    wheel=NIL:PTR TO colorwheel, gpens:PTR TO INT, g=NIL:PTR TO gradientslider,
    drawmode=NIL:PTR TO drawmode, zoom=NIL:PTR TO ratio, scale=NIL:PTR TO ratio,
    toolbar=NIL:PTR TO toolbar
DEF wins=NIL:PTR TO multihandle, cnvwin=NIL:PTR TO guihandle, colwin=NIL:PTR TO guihandle,
    unlock=FALSE, dmwin=NIL:PTR TO guihandle, zoomwin=NIL:PTR TO guihandle,
    statswin=NIL:PTR TO guihandle,fillwin=NIL:PTR TO guihandle,anywin=NIL:PTR TO guihandle,
    penwin=NIL:PTR TO guihandle,shapewin=NIL:PTR TO guihandle,brushwin=NIL:PTR TO guihandle,
    tbwin=NIL:PTR TO guihandle, linewin=NIL:PTR TO guihandle

DEF prefs=NIL:PTR TO prefs

DEF dm=0, menu

DEF buffer[256]:ARRAY

DEF a,b,c,agad,bgad,cgad

DEF cwg,chg,csg,bsg,vg,psg,rslg,bslg,gslg

DEF tragadf,tolgadf,tragadp,sizgadp,tragads

DEF stack[4096]:ARRAY OF xy,stack2[4096]:ARRAY OF xy
-> These values have been taken out of the canvas object
-> and made global to speed up the fill operation.
-> Ideally all the fill code would be optimised in
-> assembler.
DEF sp,sp2,bytesperrow,outofstack=FALSE,special,exit=FALSE

DEF temprp:rastport,tempbmp:PTR TO bitmap

DEF hostport=NIL:PTR TO mp,clientport=NIL:PTR TO mp,cl,lock

DEF workdir[128]:STRING,workfile[64]:STRING,
    filedir[128]:STRING,filefile[64]:STRING,
    workfilename[192]:STRING,filefilename[192]:STRING

DEF rchksum

DEF args[12]:ARRAY OF LONG

DEF labels:PTR TO tablabel, tabsgui:PTR TO LONG

DEF prefsgh

PROC openhelp(node)
  IF hostport=NIL THEN hostport:=CreateMsgPort()
  IF clientport=NIL THEN clientport:=CreateMsgPort()
  IF lock:=Lock('PROGDIR:Portrait.guide',ACCESS_READ)
    IF (amigaguidebase:=OpenLibrary('amigaguide.library', 39))
      IF cl:=OpenAmigaGuideA([lock,'Portrait.guide',scr,NIL,hostport,
                             clientport,'Portrait',NIL,
                             NIL,node,NIL,NIL,NIL]:newamigaguide,NIL)
        CloseAmigaGuide(cl)
      ELSE
        error('Could not open help file')
      ENDIF
      CloseLibrary(amigaguidebase)
    ENDIF
  ENDIF
ENDPROC

PROC help() IS openhelp('Help')
PROC helpmenus() IS openhelp('Menus')
PROC helpwindows() IS openhelp('Windows')
PROC helpsettings() IS openhelp('Settings')
PROC helpvmem() IS openhelp('Virtual_Memory')
PROC helpfiles() IS openhelp('File_Formats')
PROC helpindex() IS openhelp('Index')
PROC helpcanvas() IS openhelp('Canvas')

PROC strcpy(f,t)
  DEF i=0
  WHILE Char(f+i)<>NIL
    PutChar(t+i,Char(f+i))
    i++
  ENDWHILE
ENDPROC

PROC main() HANDLE
  DEF i,msg,rdargs=NIL
  FOR i:=0 TO 11
    args[i]:=NIL
  ENDFOR
  NEW prefs
  prefs.canvaswindow.leftedge:=320
  prefs.canvaswindow.topedge:=80
  prefs.canvaswindow.width:=240
  prefs.canvaswindow.height:=120
  prefs.colourwindow.leftedge:=0
  prefs.colourwindow.topedge:=20
  prefs.colourwindow.width:=120
  prefs.colourwindow.height:=100
  prefs.drawmodewindow.leftedge:=560
  prefs.drawmodewindow.topedge:=30
  prefs.zoomwindow.leftedge:=480
  prefs.zoomwindow.topedge:=240
  prefs.statswindow.leftedge:=300
  prefs.statswindow.topedge:=150
  prefs.statswindow.width:=140
  prefs.statswindow.height:=100
  prefs.fillwindow.leftedge:=100
  prefs.fillwindow.topedge:=220
  prefs.penwindow.leftedge:=300
  prefs.penwindow.topedge:=200
  prefs.anywindow.leftedge:=640
  prefs.anywindow.topedge:=256
  prefs.brushwindow.leftedge:=0
  prefs.brushwindow.topedge:=140
  prefs.tbwindow.leftedge:=32
  prefs.tbwindow.topedge:=256
  prefs.shapewindow.leftedge:=160
  prefs.shapewindow.topedge:=220
  prefs.linewindow.leftedge:=200
  prefs.linewindow.topedge:=100
  prefs.displayid:=PAL_MONITOR_ID OR HIRES_KEY
  prefs.displaydepth:=8
  prefs.windows:=CANVAS OR COLOUR OR DRAWMODE OR PEN OR FILLWIN OR ZOOM OR BRUSHWIN OR SHAPE OR TOOLBAR OR LINEWIN
  prefs.defwidth:=160
  prefs.defheight:=128
  prefs.vsize:=512*1024
  prefs.grayscale:=0
  prefs.flags:=CF_USEVMEM
  strcpy('Temp:Portrait.vmem', prefs.vmemloc)
  strcpy('Icons/Gradient', prefs.dmiconloc)
  strcpy('Icons/Gradient', prefs.tbiconloc)
  getprefs()
  IF prefs.displaydepth<8 THEN prefs.grayscale:=1
  rgb.red:=-1
  rgb.blue:=-1
  rgb.green:=-1
  menu:=[NM_TITLE, NIL, 'Project', NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'New...', 'N', NIL, NIL, {new},
         NM_ITEM, NIL, 'Open...', 'O', NIL, NIL, {open},
         NM_ITEM, NIL, 'Save', 'S', NIL, NIL, {save},
         NM_ITEM, NIL, 'Save As...', 'A', NIL, NIL, {saveas},
         NM_ITEM, NIL, 'Print', 'P', NIL, NIL, {print},
         NM_ITEM, NIL, NM_BARLABEL, NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Open Work Buffer...', 'L', NIL, NIL, {openwork},
         NM_ITEM, NIL, 'Save Work Buffer', NIL, NIL, NIL, {savework},
         NM_ITEM, NIL, 'Save Work Buffer As..', 'W', NIL, NIL, {saveworkas},
         NM_ITEM, NIL, NM_BARLABEL, NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'About...', '?', NIL, NIL, {about},
         NM_ITEM, NIL, NM_BARLABEL, NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Quit', 'Q', NIL, NIL, {quitgui},
         NM_TITLE, NIL, 'Brush', NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Clipboard', NIL, NIL, NIL, NIL,
         NM_SUB, NIL, 'Cut', 'X', NIL, NIL, {cut},
         NM_SUB, NIL, 'Copy', 'C', NIL, NIL, {copy},
         NM_SUB, NIL, 'Paste', 'V', NIL, NIL, {paste},
         NM_SUB, NIL, 'Erase', NIL, NIL, NIL, {erase},
         NM_TITLE, NIL, 'View', NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Preview', NIL, NIL, NIL, {preview},
         NM_ITEM, NIL, NM_BARLABEL, NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, '10%', NIL, NIL, NIL, {z10},
         NM_ITEM, NIL, '25%', NIL, NIL, NIL, {z25},
         NM_ITEM, NIL, '50%', NIL, NIL, NIL, {z50},
         NM_ITEM, NIL, '100%', 'C', NIL, NIL, {z100},
         NM_ITEM, NIL, '200%', NIL, NIL, NIL, {z200},
         NM_ITEM, NIL, '500%', NIL, NIL, NIL, {z500},
         NM_ITEM, NIL, NM_BARLABEL, NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Zoom to Window Width', '(', NIL, NIL, {zoomtowidth},
         NM_ITEM, NIL, 'Zoom to Window Height', ')', NIL, NIL, {zoomtoheight},
         NM_TITLE, NIL, 'Windows', NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Colour Window', '1', NIL, NIL, {opencolour},
         NM_ITEM, NIL, 'Draw mode Window', '2', NIL, NIL, {opendm},
         NM_ITEM, NIL, 'Zoom Window', '3', NIL, NIL, {openzoom},
         NM_ITEM, NIL, 'Statistics Window', '4', NIL, NIL, {openstats},
         NM_ITEM, NIL, 'Fill Window', '5', NIL, NIL, {openfill},
         NM_ITEM, NIL, 'Pen Window', '6', NIL, NIL, {openpen},
         NM_ITEM, NIL, 'Shape Window', '7', NIL, NIL, {openshape},
         NM_ITEM, NIL, 'Brush Window', '8', NIL, NIL, {openbrush},
         NM_ITEM, NIL, 'Line Window', '9', NIL, NIL, {openline},
         NM_ITEM, NIL, 'Toolbar Window', '0', NIL, NIL, {opentb},
         NM_ITEM, NIL, NM_BARLABEL, NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Arrange', '.', NIL, NIL, {arrange},
         NM_ITEM, NIL, 'Snapshot', '[', NIL, NIL, {snapshot},
         NM_TITLE, NIL, 'Settings', NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Preferences', NIL, NIL, NIL, {changeprefs},
         NM_ITEM, NIL, 'Save', NIL, NIL, NIL, {writeprefs},
         NM_TITLE,NIL,'Help',NIL,NIL,NIL,NIL,
         NM_ITEM,NIL,'Contents...', 'H', NIL, NIL, {help},
         NM_ITEM,NIL,'Menus',NIL,NIL,NIL,{helpmenus},
         NM_ITEM,NIL,'Windows',NIL,NIL,NIL,{helpwindows},
         NM_ITEM,NIL,'Canvas',NIL,NIL,NIL,{helpcanvas},
         NM_ITEM,NIL,'Settings',NIL,NIL,NIL,{helpsettings},
         NM_ITEM,NIL,'Virtual Memory',NIL,NIL,NIL,{helpvmem},
         NM_ITEM,NIL,'File Formats',NIL,NIL,NIL,{helpfiles},
         NM_ITEM,NIL,NM_BARLABEL,NIL,NIL,NIL,NIL,
         NM_ITEM,NIL,'Index...',NIL,NIL,NIL,{helpindex},
         NM_TITLE, NIL, 'Debug', NIL, NIL, NIL, NIL,
         NM_ITEM, NIL, 'Render speed...',  NIL, NIL, NIL, {speed},
         NM_ITEM, NIL, 'Fill speed...', NIL, NIL, NIL, {fspeed},
         NM_END, NIL, NIL, NIL, NIL, NIL, NIL
         ]:newmenu
  scr:=OpenScreenTagList(NIL, [SA_DEPTH, prefs.displaydepth,
                               SA_TITLE, 'Portrait',
                               SA_LIKEWORKBENCH, TRUE,
                               SA_SHAREPENS, TRUE,
                               SA_DISPLAYID, prefs.displayid,
                               NIL])
  IF scr=NIL
    WriteF('Cannot open screen\n')
    Raise("SCR")
  ENDIF
  IF openstatus()=NIL
    WriteF('Cannot open window\n')
    Raise("WIN")
  ENDIF
  setstatus('Initialising...')
  makegradient([255,255,255]:colour,FALSE,FALSE)
  NEW cg.colourgrid()
  NEW g.gradientslider(TRUE,$7FFF,6,gpens)
  NEW wheel.colorwheel(rgb,NIL)
  NEW zoom.ratio(1, 1)
  NEW canvas.create(scr,prefs.defwidth,prefs.defheight,prefs.flags)
  NEW scale.ratio(1,1)
  NEW drawmode.buttons()
  NEW toolbar.buttons()
  wins:=multiinit()
  cnvwin:=addmultiA(wins, 'Canvas',
    [ROWS,
      [PLUGIN,0,canvas,TRUE]
    ],
    [EG_SCRN,scr,EG_TOP,prefs.canvaswindow.topedge,EG_LEFT,prefs.canvaswindow.leftedge,EG_CLOSE,{canvassnap},EG_MENU,menu,EG_HIDE,TRUE,NIL])
  colwin:=addmultiA(wins, 'Colour',
      [COLS,
        [ROWS,
          [COLS,
            [PLUGIN,{colsel},wheel],
            [PLUGIN,{gradsel},g]
          ],
          rslg:=[SLIDE,{rchg},'Red:     ',FALSE,0,255,255,5,'%2ld'],
          gslg:=[SLIDE,{gchg},'Green:   ',FALSE,0,255,255,5,'%2ld'],
          bslg:=[SLIDE,{bchg},'Blue:    ',FALSE,0,255,255,5,'%2ld'],
          [EQCOLS,
            [PLUGIN,{cgsel},cg,TRUE]
          ]
        ]
      ],
      [EG_SCRN,scr,EG_TOP,prefs.colourwindow.topedge,EG_LEFT,prefs.colourwindow.leftedge,EG_CLOSE,{coloursnap},EG_MENU,menu,EG_HIDE,TRUE,NIL])
  dmwin:=addmultiA(wins, 'Draw mode',
       [ROWS,
         [PLUGIN,NIL,drawmode,TRUE]
       ],[EG_SCRN,scr,EG_TOP,prefs.drawmodewindow.topedge,EG_LEFT,prefs.drawmodewindow.leftedge,EG_WTYPE,WTYPE_NOSIZE,EG_MENU,menu,EG_CLOSE,{dmsnap},EG_HIDE,TRUE,NIL])
  tbwin:=addmultiA(wins,'Toolbar',
       [ROWS,
         [PLUGIN,NIL,toolbar,TRUE]
       ],[EG_SCRN,scr,EG_TOP,prefs.tbwindow.topedge,EG_LEFT,prefs.tbwindow.leftedge,EG_WTYPE,WTYPE_NOSIZE,EG_MENU,menu,EG_CLOSE,{tbsnap},EG_HIDE,TRUE,NIL])
  zoomwin:=addmultiA(wins, 'Zoom',
       [ROWS,
         [PLUGIN,{changezoom},zoom,TRUE]
        ],[EG_SCRN,scr,EG_TOP, prefs.zoomwindow.topedge,EG_LEFT,prefs.zoomwindow.leftedge,EG_WTYPE,WTYPE_NOSIZE,EG_MENU, menu, EG_CLOSE,{zoomsnap},EG_HIDE,TRUE,NIL])
  statswin:=addmultiA(wins, 'Statistics',
       [ROWS,
         cwg:=[NUM,canvas.width,                                                           'Canvas Width        (Pixels):', TRUE,7],
         chg:=[NUM,canvas.height,                                                          'Canvas Height       (Pixels):',TRUE,7],
         csg:=[NUM,Div(Mul(Mul(canvas.width,canvas.height),3),1024),                                    '24-bit buffer memory     (K):', TRUE,7],
         bsg:=[NUM,Div(Mul(Mul(canvas.bitmap.depth,canvas.bitmap.bytesperrow),canvas.bitmap.rows),1024),'Preview memory           (K):', TRUE,7],
         vg:=[TEXT,IF canvas.vmem THEN 'Yes' ELSE 'No',                                   'Virtual memoy in use:        ', TRUE, 7],
         psg:=[NUM,(canvas.vsize)/1024,                                                    'Virtual memory page size (K):', TRUE, 7]
       ],[EG_SCRN,scr,EG_TOP,prefs.statswindow.topedge,EG_LEFT,prefs.statswindow.leftedge,EG_MENU,menu,EG_CLOSE,{statsnap},EG_HIDE,TRUE,NIL])
  canvas.fill.tolerance:=5
  canvas.fill.transparency:=0
  fillwin:=addmultiA(wins, 'Fill',
       [ROWS,
         [CYCLE,{filltype},'Type:',['Solid','Transparency','Gradient','Brush',NIL],canvas.fill.type],
         tolgadf:=[INTEGER,{dum},'Tolerance:   ',canvas.fill.tolerance,5],
         tragadf:=[INTEGER,{dum},'Transparency:',canvas.fill.transparency,5]
       ],[EG_TOP,prefs.fillwindow.topedge,EG_LEFT,prefs.fillwindow.leftedge,EG_SCRN,scr,EG_MENU,menu,EG_HIDE,TRUE,EG_CLOSE,{fillsnap},EG_WTYPE,WTYPE_NOSIZE,NIL])
  penwin:=addmultiA(wins, 'Pen',
       [ROWS,
         [CYCLE,{penshape},'Shape:',['Square','Circle','Brush',NIL],canvas.pen.shape],
         sizgadp:=[INTEGER,{dum},'Size:        ',canvas.pen.size,5],
         tragadp:=[INTEGER,{dum},'Transparency:',canvas.pen.transparency,5]
       ],[EG_TOP,prefs.penwindow.topedge,EG_LEFT,prefs.penwindow.leftedge,EG_SCRN,scr,EG_MENU,menu,EG_HIDE,TRUE,EG_CLOSE,{pensnap},EG_WTYPE,WTYPE_NOSIZE,NIL])
  shapewin:=addmultiA(wins, 'Shape',
        [ROWS,
          [CYCLE,{shapetype},'Type:',['Outline','Solid',NIL],canvas.shape.type],
          tragads:=[INTEGER,{dum},'Transparency:',canvas.shape.transparency,5]
        ],[EG_TOP,prefs.shapewindow.topedge,EG_LEFT,prefs.shapewindow.leftedge,EG_SCRN,scr,EG_MENU,menu,EG_HIDE,TRUE,EG_CLOSE,{shapesnap},EG_WTYPE,WTYPE_NOSIZE,NIL])
  linewin:=addmultiA(wins, 'Line',
        [ROWS,
          [CYCLE,{linestyle},'Style:',['Continuous','Dotted','Dashed',NIL],canvas.line.style]
        ],[EG_TOP,prefs.linewindow.topedge,EG_LEFT,prefs.linewindow.leftedge,EG_SCRN,scr,EG_MENU,menu,EG_HIDE,TRUE,EG_CLOSE,{linesnap},EG_WTYPE,WTYPE_NOSIZE,NIL])
  canvas.brush.transparency:=T_COLOUR
  brushwin:=addmultiA(wins, 'Brush',
        [ROWS,
           [CYCLE,{pastemode},'Paste Mode:',['Matte','Colour',NIL],canvas.brush.pastemode],
           [COLS,
             [CYCLE,{transparency}, 'Background Transparency:',['None','Colour','Flood',NIL],canvas.brush.transparency],
             [BUTTON,{transpset},'Set']
           ],
           [CYCLE,{handle},'Handle:',['Top Left','Top Right','Bottom Left','Bottom Right','Centre',NIL],canvas.brush.handle],
           [CYCLE,{outline},'Outline:',['Off','On',NIL],canvas.brush.outline],
           [COLS,
             [TEXT,'Scale:',NIL,FALSE,6],
             [PLUGIN,{changescale},scale,TRUE]
           ],
           [SBUTTON,{list},'List »']
         ],[EG_TOP,prefs.brushwindow.topedge,EG_LEFT,prefs.brushwindow.leftedge,EG_SCRN,scr,EG_MENU,menu,EG_HIDE,TRUE,EG_CLOSE,{brushsnap},EG_WTYPE,WTYPE_NOSIZE,NIL])
  about()
  PutInt(colwin+72,prefs.colourwindow.width)
  PutInt(colwin+76,prefs.colourwindow.height)
  PutInt(cnvwin+72,prefs.canvaswindow.width)
  PutInt(cnvwin+76,prefs.canvaswindow.height)
  PutInt(statswin+72,prefs.statswindow.width)
  PutInt(statswin+76,prefs.statswindow.height)
  openwins()
  setstatus('Portrait © Christopher January 1997-1998')
  WriteF('IDCMP=')
  FOR i:=0 TO 31
    IF canvas.gh.wnd.idcmpflags AND Shl(1,i) THEN WriteF('1') ELSE WriteF('0')
  ENDFOR
  WriteF('\n')
  multiloop(wins)
EXCEPT DO
  #ifdef DEBUG
  SELECT exception
  CASE "SCR"
    WriteF('Cannot open screen\n')
  CASE "WIN"
    WriteF('Cannot open window\n')
  CASE "CANV"
    WriteF('Canvas error\n')
  CASE "DTYP"
    WriteF('Datatypes error\n')
  CASE "grad"
    WriteF('Gradient slider error\n')
  DEFAULT
    IF exception
      WriteF('Noodles, noodles, noodles (unexpected error at \d)\n', exceptioninfo)
    ENDIF
  ENDSELECT
  report_exception()
  #endif
  IF wins THEN cleanmulti(wins)
  IF canvas THEN END canvas
  IF wheel THEN END wheel
  IF cg THEN END cg
  IF drawmode THEN END drawmode
  IF zoom THEN END zoom
  IF scale THEN END scale
  IF g
    FOR i:=0 TO 15
      ReleasePen(scr.viewport.colormap,gpens[i])
    ENDFOR
    END g
  ENDIF
  IF status THEN CloseWindow(status)
  IF unlock
    UnlockPubScreen(NIL,scr)
  ELSE
    IF scr THEN CloseScreen(scr)
  ENDIF
  IF datatypesbase<>NIL THEN CloseLibrary(datatypesbase)
  IF clientport
    WHILE (msg:=GetMsg(clientport))
      ReplyMsg(msg)
    ENDWHILE
    DeleteMsgPort(clientport)
  ENDIF
  IF hostport
    WHILE (msg:=GetMsg(hostport))
      ReplyMsg(msg)
    ENDWHILE
    DeleteMsgPort(hostport)
  ENDIF
  IF rdargs THEN FreeArgs(rdargs)
  ->IF temprp THEN FreeVec(temprp)
ENDPROC
/*
  displayid:LONG
  displaydepth:INT
  grayscale:CHAR
  canvaswindow:windowdimensions
  colourwindow:windowdimensions
  drawmodewindow:windowdimensions
  zoomwindow:windowdimensions
  statswindow:windowdimensions
  fillwindow:windowdimensions
  penwindow:windowdimensions
  anywindow:windowdimensions
  windows:LONG
  vmemloc[32]:ARRAY OF CHAR
  defwidth,defheight:INT
  vsize:LONG
  shapewindow:windowdimensions
  brushwindow:windowdimensions
  dmiconloc[64]:ARRAY OF CHAR
  tbiconloc[64]:ARRAY OF CHAR
  tbwindow:windowdimensions
*/
OBJECT prefsgads
  defwidth
  defheight
  dmiconloc
  tbiconloc
  vmemloc
  vsize
  curgui
ENDOBJECT
PROC changeprefs()
  DEF t=NIL:PTR TO tabs, top, pg=NIL:PTR TO prefsgads, oldprefs:prefs,
      dmstr[64]:STRING, tbstr[64]:STRING, vmemstr[32]:STRING,
      dw,dh,dml,tbl,vml,vs,res,bottom
  CopyMem(prefs,oldprefs,SIZEOF prefs)
  StrCopy(dmstr, prefs.dmiconloc)
  StrCopy(tbstr, prefs.tbiconloc)
  StrCopy(vmemstr, prefs.vmemloc)
  NEW pg
  blockwins()
  labels:=['General', -1, -1, -1, -1, NIL,
           'Canvas', -1, -1, -1, -1, NIL,
           'Paths', -1, -1, -1, -1, NIL,
           'Virtual Memory', -1, -1, -1, -1, NIL,
           NIL]:tablabel
  NEW t.tabs(labels)
  top:=[PLUGIN,{tabsaction},t]
  bottom:=[COLS,
            [BUTTON,{prefssave},'Save'],
            [SPACEH],
            [BUTTON,{prefsuse},'Use'],
            [SPACEH],
            [BUTTON,0,'Cancel']
          ]
  tabsgui:=[
         [ROWS,
           top,
           [BUTTON, {changesm}, 'Change Screenmode...'],
           bottom
         ],
         [ROWS,
           top,
           dw:=[INTEGER, {dum}, 'Default Width: ', prefs.defwidth,5],
           dh:=[INTEGER, {dum}, 'Default Height:', prefs.defheight,5],
           bottom
         ],
         [ROWS,
           top,
           [COLS,
             dml:=[STR, {dum}, 'Draw mode Icons:', dmstr, 64, 24],
             [BUTTON,{choosedmloc},'Pick']
           ],
           [COLS,
             tbl:=[STR, {dum}, 'Toolbar Icons:  ', tbstr, 64, 24],
             [BUTTON,{choosetbloc},'Pick']
           ],
           bottom
         ],
         [ROWS,
           top,
           vml:=[STR, {dum}, 'Swap file:', vmemstr, 32, 24],
           vs:=[INTEGER, {dum}, 'Page Size:', prefs.vsize, 10],
           [MX, {vuc}, NIL, ['Never use VMem','Use VMem when needed','Always use VMem',NIL],NIL,IF canvas.flags AND CF_FORCEVMEM THEN 2 ELSE IF canvas.flags AND CF_USEVMEM THEN 1 ELSE 0],
           bottom
         ]
       ]
  pg.defwidth:=dw
  pg.defheight:=dh
  pg.dmiconloc:=dml
  pg.tbiconloc:=tbl
  pg.vmemloc:=vml
  pg.vsize:=vs
  pg.curgui:=0
  res:=easyguiA('Preferences', tabsgui[], [EG_INFO, pg, EG_GHVAR, {prefsgh}, EG_SCRN, scr, EG_CLOSE, {prefsclose}, NIL])
  IF res=0 THEN CopyMem(oldprefs,prefs,SIZEOF prefs)
  IF res=2 THEN writeprefs()
  unblockwins()
  END pg
ENDPROC
PROC prefsclose(pg)
  getvalues(pg)
  quitgui(0)
ENDPROC
PROC prefsuse(pg)
  getvalues(pg)
  quitgui(1)
ENDPROC
PROC prefssave(pg)
  getvalues(pg)
  quitgui(2)
ENDPROC
PROC getvalues(pg:PTR TO prefsgads)
  DEF cur
  cur:=pg.curgui
  SELECT cur
    CASE 1
      prefs.defwidth:=getinteger(prefsgh,pg.defwidth)
      prefs.defheight:=getinteger(prefsgh,pg.defheight)
    CASE 2
      strcpy(getstr(prefsgh,pg.dmiconloc),prefs.dmiconloc)
      strcpy(getstr(prefsgh,pg.tbiconloc),prefs.tbiconloc)
    CASE 3
      prefs.vsize:=getinteger(prefsgh,pg.vsize)
      strcpy(getstr(prefsgh,pg.vmemloc),prefs.vmemloc)
      IF canvas.vmem=NIL
        canvas.vsize:=prefs.vsize
      ENDIF
  ENDSELECT
ENDPROC
PROC vuc(i,n)
  DEF f
  f:=canvas.flags
  IF f AND CF_USEVMEM THEN f:=f-CF_USEVMEM
  IF f AND CF_FORCEVMEM THEN f:=f-CF_FORCEVMEM
  SELECT n
    CASE 0
      canvas.flags:=f
      prefs.flags:=NIL
    CASE 1
      canvas.flags:=f OR CF_USEVMEM
      prefs.flags:=CF_USEVMEM
    CASE 2
      canvas.flags:=f OR CF_FORCEVMEM
      prefs.flags:=CF_FORCEVMEM
  ENDSELECT
ENDPROC
PROC changesm()
  blockwin(prefsgh)
  WbenchToFront()
  SystemTagList('PortraitMode', NIL)
  ScreenToFront(scr)
  unblockwin(prefsgh)
ENDPROC
PROC choosetbloc()
ENDPROC
PROC choosedmloc()
ENDPROC
PROC tabsaction(pg:PTR TO prefsgads,t:PTR TO tabs)
  getvalues(pg)
  pg.curgui:=t.current
  changegui(prefsgh,tabsgui[t.current])
ENDPROC
PROC snap(gui:PTR TO guihandle)
  IF gui.wnd
    prefs.anywindow.leftedge:=gui.wnd.leftedge
    prefs.anywindow.topedge:=gui.wnd.topedge
  ENDIF
  closewin(gui)
ENDPROC
PROC penshape(i,n)
  canvas.pen.shape:=n
ENDPROC
PROC filltype(i,n)
  canvas.fill.type:=n
ENDPROC
PROC linestyle(i,n)
  canvas.line.style:=n
ENDPROC
PROC shapetype(i,n)
  canvas.shape.type:=n
ENDPROC
PROC pastemode(i,n)
  canvas.brush.pastemode:=n
ENDPROC
PROC transparency(i,n)
  canvas.brush.transparency:=n
ENDPROC
PROC handle(i,n)
  canvas.brush.handle:=n
ENDPROC
PROC outline(i,n)
  canvas.brush.outline:=n
ENDPROC
PROC transpset()
  canvas.brush.tcol.red:=canvas.fg.red
  canvas.brush.tcol.green:=canvas.fg.green
  canvas.brush.tcol.blue:=canvas.fg.blue
  ->canvas.brush.newmask()
ENDPROC
PROC changescale()
  canvas.brush.ratiox:=scale.ratiox
  canvas.brush.ratioy:=scale.ratioy
  ->canvas.brush.scale()
ENDPROC
PROC print()
ENDPROC
PROC list()
ENDPROC
PROC save()
ENDPROC
PROC saveas()
ENDPROC

PROC preview()
ENDPROC

OBJECT phdr
  width,height,chksum
ENDOBJECT
PROC savework() HANDLE
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror=NIL,
      iffErrTxt:PTR TO LONG,phdr:PTR TO phdr, i
  blockwins()
  phdr:=[canvas.width,canvas.height,rchksum]:phdr
  IF (iffparsebase:=OpenLibrary('iffparse.library', 39))=NIL THEN Raise(ERR_LIB)
  iffhandle:=AllocIFF()
  IF iffhandle=NIL THEN Raise(ERR_IFF)
  iffhandle.stream:=Open(workfilename, MODE_NEWFILE)
  IF iffhandle.stream=NIL THEN Raise(ERR_OPEN)
  InitIFFasDOS(iffhandle)
  IF (ifferror:=OpenIFF(iffhandle, IFFF_WRITE))=NIL
    IF (ifferror:=PushChunk(iffhandle, ID_WORK, ID_FORM, IFFSIZE_UNKNOWN))=NIL
      IF (ifferror:=PushChunk(iffhandle, NIL, ID_PHDR, IFFSIZE_UNKNOWN))=NIL
        IF WriteChunkBytes(iffhandle, phdr,SIZEOF phdr)
          ifferror:=IFFERR_WRITE
        ENDIF
        PopChunk(iffhandle)
      ENDIF
      IF (ifferror:=PushChunk(iffhandle, NIL, ID_BODY, IFFSIZE_UNKNOWN))=NIL
        IF WriteChunkBytes(iffhandle, canvas.true,(canvas.width*canvas.height*3))<>(canvas.width*canvas.height*3)
          ifferror:=IFFERR_WRITE
        ENDIF
        PopChunk(iffhandle)
      ENDIF
      PopChunk(iffhandle)
    ENDIF
    IF ifferror
      iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
               'stream read error','stream write error','stream seek error',
               'file corrupt', 'IFF syntax error', 'not an IFF file',
               'required call-back hook missing', NIL]
       error(iffErrTxt[-ifferror-1])
    ENDIF
    CloseIFF(iffhandle)
  ENDIF
EXCEPT DO
  SELECT exception
  CASE ERR_OPEN
  CASE ERR_IFF
    error('Couldn''t allocate IFF handle')
  CASE ERR_LIB
    error('Couldn''t open iffparse.library')
  DEFAULT
    ReThrow()
  ENDSELECT
  IF iffhandle
    IF iffhandle.stream THEN Close(iffhandle.stream)
    FreeIFF(iffhandle)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
  unblockwins()
ENDPROC
PROC saveworkas()
  blockwins()
  IF openworkfr('Save As...') THEN savework()
  unblockwins()
ENDPROC
PROC openwork() HANDLE
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror,
      iffErrTxt:PTR TO LONG, sp:PTR TO storedproperty,
      cn:PTR TO contextnode,phdr:phdr
  blockwins()
  IF openworkfr('Open...')
  IF (iffparsebase:=OpenLibrary('iffparse.library', 39))=NIL THEN Raise(ERR_LIB)
  iffhandle:=AllocIFF()
  IF iffhandle=NIL THEN Raise(ERR_IFF)
  iffhandle.stream:=Open(workfilename, MODE_OLDFILE)
  IF iffhandle.stream=NIL THEN Raise(ERR_OPEN)
  InitIFFasDOS(iffhandle)
  IF (ifferror:=OpenIFF(iffhandle, IFFF_READ))=NIL
    WHILE (ifferror=NIL)
      IF ifferror:=ParseIFF(iffhandle, IFFPARSE_STEP)
        IF ifferror=IFFERR_EOC THEN ifferror:=NIL
      ELSE
        IF cn:=CurrentChunk(iffhandle)
          IF (cn.id<>ID_FORM)
            IF cn.id=ID_BODY
              ReadChunkBytes(iffhandle,canvas.true,canvas.width*canvas.height*3)
              canvas.minx:=0
              canvas.miny:=0
              canvas.maxx:=canvas.width-1
              canvas.maxy:=canvas.height-1
              ->canvas.setupdate()
              IF phdr.chksum<>rchksum
                canvas.setupdate()
              ELSE
                canvas.refresh(FALSE)
              ENDIF
            ELSEIF cn.id=ID_PHDR
              ReadChunkBytes(iffhandle,phdr,SIZEOF phdr)
              canvas.changesize(phdr.width,phdr.height)
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ENDWHILE
    IF ifferror<>IFFERR_EOF
      iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
               'stream read error','stream write error','stream seek error',
               'file corrupt', 'IFF syntax error', 'not an IFF file',
               'required call-back hook missing', NIL]
       error(iffErrTxt[-ifferror-1])
    ENDIF
    CloseIFF(iffhandle)
  ENDIF
  ENDIF
EXCEPT DO
  SELECT exception
  CASE ERR_OPEN
    error('Couldn''t open file')
  CASE ERR_IFF
    error('Couldn''t allocate IFF handle')
  CASE ERR_LIB
    error('Couldn''t open iffparse.library')
  DEFAULT
    ReThrow()
  ENDSELECT
  IF iffhandle
    IF iffhandle.stream THEN Close(iffhandle.stream)
    FreeIFF(iffhandle)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
  unblockwins()
ENDPROC
PROC cut()
ENDPROC
PROC copy()
ENDPROC
PROC paste()
ENDPROC
PROC erase()
ENDPROC
PROC new()
  blockwins()
  IF easyguiA('New',
             [ROWS,
               agad:=[INTEGER,{dum},'Width:',canvas.width,5],
               bgad:=[INTEGER,{dum},'Height:',canvas.height,5],
               [EQCOLS,
                  [BUTTON,{ok},'Ok'],
                  [BUTTON,0,'Cancel']
               ]
             ],[EG_WTYPE,WTYPE_NOSIZE,EG_SCRN,scr,NIL])
    canvas.changesize(a,b)
  ENDIF
  unblockwins()
ENDPROC
PROC arrange()
  DEF list:PTR TO arrangewindow,i=0,p:PTR TO arrangewindow,x=0,y,w,h,mh=0,toobig=FALSE
  list:=[colwin,scr.width/4,scr.height/3,cnvwin,scr.width/3,scr.height/2,
          dmwin,0,0,zoomwin,0,0,brushwin,0,0,statswin,scr.width/3,scr.height/3,
         fillwin,0,0,penwin,0,0,shapewin,0,0,brushwin,0,0,tbwin,0,0,anywin,0,0]:arrangewindow
  y:=scr.barheight+1
  WHILE (i<11) AND (toobig=FALSE)
    p:=list[i]
    IF p.gui
      IF p.gui.wnd
        w:=list[i].w
        h:=list[i].h
        IF w=0 THEN w:=p.gui.wnd.width
        IF h=0 THEN h:=p.gui.wnd.height
        IF ((x+w)>scr.width)
          y:=y+mh
          x:=0
          mh:=0
        ENDIF
        IF h>mh THEN mh:=h
        IF ((y+h)>scr.height)
          toobig:=TRUE
        ELSE
          ChangeWindowBox(p.gui.wnd,x,y,w,h)
          x:=x+w
        ENDIF
      ENDIF
    ENDIF
    i++
  ENDWHILE
  IF toobig THEN error('Too many windows to arrange')
ENDPROC
PROC dum()
ENDPROC
PROC ok(gh)
  a:=getinteger(gh,agad)
  b:=getinteger(gh,bgad)
  quitgui(1)
ENDPROC
PROC blockwins()
  IF prefs.windows AND DRAWMODE THEN blockwin(dmwin)
  IF prefs.windows AND COLOUR THEN blockwin(colwin)
  IF prefs.windows AND CANVAS THEN blockwin(cnvwin)
  IF prefs.windows AND ZOOM THEN blockwin(zoomwin)
  IF prefs.windows AND STATISTICS THEN blockwin(statswin)
  IF prefs.windows AND FILLWIN THEN blockwin(fillwin)
  IF prefs.windows AND PEN THEN blockwin(penwin)
  IF prefs.windows AND SHAPE THEN blockwin(shapewin)
  IF prefs.windows AND BRUSHWIN THEN blockwin(brushwin)
  IF prefs.windows AND TOOLBAR THEN blockwin(tbwin)
  IF prefs.windows AND LINEWIN THEN blockwin(linewin)
  IF anywin THEN blockwin(anywin)
ENDPROC
PROC unblockwins()
  IF prefs.windows AND DRAWMODE THEN unblockwin(dmwin)
  IF prefs.windows AND COLOUR THEN unblockwin(colwin)
  IF prefs.windows AND CANVAS THEN unblockwin(cnvwin)
  IF prefs.windows AND ZOOM THEN unblockwin(zoomwin)
  IF prefs.windows AND STATISTICS THEN unblockwin(statswin)
  IF prefs.windows AND FILLWIN THEN unblockwin(fillwin)
  IF prefs.windows AND PEN THEN unblockwin(penwin)
  IF prefs.windows AND SHAPE THEN unblockwin(shapewin)
  IF prefs.windows AND BRUSHWIN THEN unblockwin(brushwin)
  IF prefs.windows AND TOOLBAR THEN unblockwin(tbwin)
  IF prefs.windows AND LINEWIN THEN unblockwin(linewin)
  IF anywin THEN unblockwin(anywin)
ENDPROC
PROC openwins()
  IF prefs.windows AND DRAWMODE THEN openwin(dmwin)
  IF prefs.windows AND COLOUR THEN openwin(colwin)
  IF prefs.windows AND CANVAS THEN openwin(cnvwin)
  IF prefs.windows AND ZOOM THEN openwin(zoomwin)
  IF prefs.windows AND STATISTICS THEN openwin(statswin)
  IF prefs.windows AND FILLWIN THEN openwin(fillwin)
  IF prefs.windows AND PEN THEN openwin(penwin)
  IF prefs.windows AND SHAPE THEN openwin(shapewin)
  IF prefs.windows AND BRUSHWIN THEN openwin(brushwin)
  IF prefs.windows AND TOOLBAR THEN openwin(tbwin)
  IF prefs.windows AND LINEWIN THEN openwin(linewin)
  IF anywin THEN openwin(anywin)
ENDPROC
PROC open()
  blockwins()
  openfilefr('Open...')
  openfile()
  unblockwins()
ENDPROC
PROC openline()
  IF (prefs.windows AND LINEWIN)=NIL
    openwin(linewin)
    prefs.windows:=prefs.windows OR LINEWIN
  ENDIF
ENDPROC
PROC opentb()
  IF (prefs.windows AND TOOLBAR)=NIL
    openwin(tbwin)
    prefs.windows:=prefs.windows OR TOOLBAR
  ENDIF
ENDPROC
PROC opendm()
  IF (prefs.windows AND DRAWMODE)=NIL
    openwin(dmwin)
    prefs.windows:=prefs.windows OR DRAWMODE
  ENDIF
ENDPROC
PROC openbrush()
  IF (prefs.windows AND BRUSHWIN)=NIL
    openwin(brushwin)
    prefs.windows:=prefs.windows OR BRUSHWIN
  ENDIF
ENDPROC
PROC openshape()
  IF (prefs.windows AND SHAPE)=NIL
    openwin(shapewin)
    prefs.windows:=prefs.windows OR SHAPE
  ENDIF
ENDPROC
PROC opencolour()
  IF (prefs.windows AND COLOUR)=NIL
    openwin(colwin)
    prefs.windows:=prefs.windows OR COLOUR
  ENDIF
ENDPROC
PROC openzoom()
  IF (prefs.windows AND ZOOM)=NIL
    openwin(zoomwin)
    prefs.windows:=prefs.windows OR ZOOM
  ENDIF
ENDPROC
PROC openstats()
  IF (prefs.windows AND STATISTICS)=NIL
    openwin(statswin)
    prefs.windows:=prefs.windows OR STATISTICS
  ENDIF
ENDPROC
PROC openfill()
  IF (prefs.windows AND FILLWIN)=NIL
    openwin(fillwin)
    prefs.windows:=prefs.windows OR FILLWIN
  ENDIF
ENDPROC
PROC openpen()
  IF (prefs.windows AND PEN)=NIL
    openwin(penwin)
    prefs.windows:=prefs.windows OR PEN
  ENDIF
ENDPROC
PROC about()
  blockwins()
  EasyRequestArgs(status,[20,0,0,'Portrait V1.24 (27.07.98)\nThis program is freely distributable\n© Christopher January 1997-1998\nBy using this program you agree to the Disclaimer','Ok'],0,NIL)
  unblockwins()
ENDPROC
PROC openstatus()
  status:=OpenWindowTagList(NIL, [WA_PUBSCREEN, scr,
                                  WA_INNERWIDTH, scr.width,
                                  WA_INNERHEIGHT, scr.font.ysize,
                                  WA_LEFT, 0,
                                  WA_TOP, scr.height,
                                  WA_AUTOADJUST, TRUE,
                                  WA_SMARTREFRESH, TRUE,
                                  NIL])
ENDPROC status
PROC sqr(n) IS !Fsqrt(n!)!
PROC setstatus(str:PTR TO CHAR)
  SetAPen(status.rport,0)
  RectFill(status.rport,status.borderleft,status.bordertop,status.width-status.borderright-107,status.height-status.borderbottom-1)
  SetAPen(status.rport,1)
  Move(status.rport,2+status.borderleft,status.rport.font.baseline+status.bordertop)
  Text(status.rport,str,StrLen(str))
ENDPROC
PROC setprogress(percent)
  DEF x
  x:=status.width-status.borderright-106
  SetAPen(status.rport,0)
  RectFill(status.rport,x+percent,status.bordertop+1,status.width-status.borderright-1,status.height-status.borderbottom-2)
  IF percent>0
    SetAPen(status.rport,3)
    RectFill(status.rport,x,status.bordertop+1,x+percent-1,status.height-status.borderbottom-2)
  ENDIF
ENDPROC
PROC zoomtowidth()
  zoom.setratio(canvas.xs,canvas.width)
  changezoom()
ENDPROC
PROC z10()
  zoom.setratio(1,10)
  changezoom()
ENDPROC
PROC z25()
  zoom.setratio(1,4)
  changezoom()
ENDPROC
PROC z50()
  zoom.setratio(1,2)
  changezoom()
ENDPROC
PROC z100()
  zoom.setratio(1,1)
  changezoom()
ENDPROC
PROC z200()
  zoom.setratio(2,1)
  changezoom()
ENDPROC
PROC z500()
  zoom.setratio(5,1)
  changezoom()
ENDPROC
PROC zoomtoheight()
  zoom.setratio(canvas.ys,canvas.height)
  changezoom()
ENDPROC
PROC changezoom()
  canvas.ratiox:=zoom.ratiox
  canvas.ratioy:=zoom.ratioy
  canvas.zwidth:=(canvas.width*canvas.ratiox)/canvas.ratioy
  canvas.zheight:=(canvas.height*canvas.ratiox)/canvas.ratioy
  canvas.minx:=0
  canvas.miny:=0
  canvas.maxx:=canvas.width-1
  canvas.maxy:=canvas.height-1
  canvas.refresh(TRUE)
ENDPROC
PROC error(str:PTR TO CHAR)
  IF status
    setstatus(str)
    DisplayBeep(scr)
    Delay(150)
  ENDIF
ENDPROC
PROC rchg(i,n)
  canvas.fg.red:=n
  cg.setcolour(cg.sx,cg.sy,n,canvas.fg.green,canvas.fg.blue)
  makegradient([n,canvas.fg.green,canvas.fg.blue]:colour)
  rgb.red:=makeop(n)
  rgb.green:=makeop(canvas.fg.green)
  rgb.blue:=makeop(canvas.fg.blue)
  g.setcurval($7FFF)
  wheel.setrgb(rgb)
ENDPROC
PROC gchg(i,n)
  canvas.fg.green:=n
  cg.setcolour(cg.sx,cg.sy,canvas.fg.red,n,canvas.fg.blue)
  makegradient([canvas.fg.red,n,canvas.fg.blue]:colour)
  rgb.red:=makeop(canvas.fg.red)
  rgb.green:=makeop(n)
  rgb.blue:=makeop(canvas.fg.blue)
  g.setcurval($7FFF)
  wheel.setrgb(rgb)
ENDPROC
PROC bchg(i,n)
  canvas.fg.blue:=n
  cg.setcolour(cg.sx,cg.sy,canvas.fg.red,canvas.fg.green,n)
  makegradient([canvas.fg.red,canvas.fg.green,n]:colour)
  rgb.red:=makeop(canvas.fg.red)
  rgb.green:=makeop(canvas.fg.green)
  rgb.blue:=makeop(n)
  g.setcurval($7FFF)
  wheel.setrgb(rgb)
ENDPROC
PROC colsel(i, d:PTR TO colorwheel)
  canvas.fg.red:=makepo(d.rgb.red)
  canvas.fg.green:=makepo(d.rgb.green)
  canvas.fg.blue:=makepo(d.rgb.blue)
  setslide(colwin,rslg,makepo(d.rgb.red))
  setslide(colwin,gslg,makepo(d.rgb.green))
  setslide(colwin,bslg,makepo(d.rgb.blue))
  cg.setcolour(cg.sx,cg.sy,makepo(d.rgb.red),makepo(d.rgb.green),makepo(d.rgb.blue))
  makegradient([makepo(d.rgb.red),makepo(d.rgb.green),makepo(d.rgb.blue)]:colour)
  g.setcurval($7FFF)
ENDPROC
PROC cgsel(i, d:PTR TO colourgrid)
  canvas.fg.red:=d.palette[d.getnum(d.sx,d.sy)].red
  canvas.fg.green:=d.palette[d.getnum(d.sx,d.sy)].green
  canvas.fg.blue:=d.palette[d.getnum(d.sx,d.sy)].blue
  setslide(colwin,rslg,d.palette[d.getnum(d.sx,d.sy)].red)
  setslide(colwin,gslg,d.palette[d.getnum(d.sx,d.sy)].green)
  setslide(colwin,bslg,d.palette[d.getnum(d.sx,d.sy)].blue)
  rgb.red:=makeop(d.palette[d.getnum(d.sx,d.sy)].red)
  rgb.green:=makeop(d.palette[d.getnum(d.sx,d.sy)].green)
  rgb.blue:=makeop(d.palette[d.getnum(d.sx,d.sy)].blue)
  wheel.setrgb(rgb)
  makegradient([d.palette[d.getnum(d.sx,d.sy)].red,d.palette[d.getnum(d.sx,d.sy)].green,d.palette[d.getnum(d.sx,d.sy)].blue]:colour)
  g.setcurval($7FFF)
ENDPROC
PROC gradsel(i, d:PTR TO gradientslider)
  DEF lev,r,g,b
  lev:=Div(d.curval,128)
  r:=makepo(wheel.rgb.red)
  g:=makepo(wheel.rgb.green)
  b:=makepo(wheel.rgb.blue)
  IF lev<256
    canvas.fg.red:=255-Div(Mul(255-r,lev),256)
    canvas.fg.green:=255-Div(Mul(255-g,lev),256)
    canvas.fg.blue:=255-Div(Mul(255-b,lev),256)
  ELSE
    canvas.fg.red:=Div(Mul(r,511-lev),256)
    canvas.fg.green:=Div(Mul(g,511-lev),256)
    canvas.fg.blue:=Div(Mul(b,511-lev),256)
  ENDIF
  setslide(colwin,rslg,canvas.fg.red)
  setslide(colwin,gslg,canvas.fg.green)
  setslide(colwin,bslg,canvas.fg.blue)
  cg.setcolour(cg.sx,cg.sy,canvas.fg.red,canvas.fg.green,canvas.fg.blue)
ENDPROC
PROC makeop(c) IS Shl(c,24)+Shl(c,16)+Shl(c,8)+c
PROC makepo(c)
  c:=Mod(Shr(c,24),255)
ENDPROC IF c<0 THEN c:=c+256 ELSE c
PROC makegradient(c:PTR TO colour,free=TRUE,set=TRUE)
  DEF i,oldpens[16]:ARRAY OF INT
  IF free
    CopyMem(gpens,oldpens,32)
  ENDIF
  gpens:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1]:INT
  FOR i:=0 TO 7
    gpens[i]:=getpen(255-(((255-c.red)*i)/8),255-(((255-c.green)*i)/8),255-(((255-c.blue)*i)/8))
  ENDFOR
  FOR i:=8 TO 15
    gpens[i]:=getpen((c.red*(15-i))/7,(c.green*(15-i))/7,(c.blue*(15-i))/7)
  ENDFOR
  IF set
    g.setpens(gpens)
  ENDIF
  IF free
    FOR i:=0 TO 15
      ReleasePen(scr.viewport.colormap,oldpens[i])
    ENDFOR
  ENDIF
ENDPROC
PROC getpen(r,g,b) RETURN ObtainBestPenA(scr.viewport.colormap,Shl(r,24)+Shl(r,16)+Shl(r,8)+r,
                                                               Shl(g,24)+Shl(g,16)+Shl(g,8)+g,
                                                               Shl(b,24)+Shl(b,16)+Shl(b,8)+b,
                                                               [OBP_PRECISION, PRECISION_IMAGE,
                                                                NIL])
PROC canvassnap()
  snapshot()
  quitgui()
ENDPROC
PROC shapesnap()
  IF shapewin.wnd
    prefs.shapewindow.leftedge:=shapewin.wnd.leftedge
    prefs.shapewindow.topedge:=shapewin.wnd.topedge
    prefs.windows:=prefs.windows-SHAPE
    closewin(shapewin)
  ENDIF
ENDPROC
PROC linesnap()
  IF linewin.wnd
    prefs.linewindow.leftedge:=linewin.wnd.leftedge
    prefs.linewindow.topedge:=linewin.wnd.topedge
    prefs.windows:=prefs.windows-LINEWIN
    closewin(linewin)
  ENDIF
ENDPROC
PROC brushsnap()
  IF brushwin.wnd
    prefs.brushwindow.leftedge:=brushwin.wnd.leftedge
    prefs.brushwindow.topedge:=brushwin.wnd.topedge
    prefs.windows:=prefs.windows-BRUSHWIN
    closewin(brushwin)
  ENDIF
ENDPROC
PROC snapshot()
  prefs.canvaswindow.leftedge:=cnvwin.wnd.leftedge
  prefs.canvaswindow.topedge:=cnvwin.wnd.topedge
  prefs.canvaswindow.width:=cnvwin.wnd.width
  prefs.canvaswindow.height:=cnvwin.wnd.height
  IF colwin.wnd
    prefs.colourwindow.leftedge:=colwin.wnd.leftedge
    prefs.colourwindow.topedge:=colwin.wnd.topedge
    prefs.colourwindow.width:=colwin.wnd.width
    prefs.colourwindow.height:=colwin.wnd.height
  ENDIF
  IF dmwin.wnd
    prefs.drawmodewindow.leftedge:=dmwin.wnd.leftedge
    prefs.drawmodewindow.topedge:=dmwin.wnd.topedge
  ENDIF
  IF zoomwin.wnd
    prefs.zoomwindow.leftedge:=zoomwin.wnd.leftedge
    prefs.zoomwindow.topedge:=zoomwin.wnd.topedge
  ENDIF
  IF statswin.wnd
    prefs.statswindow.leftedge:=statswin.wnd.leftedge
    prefs.statswindow.topedge:=statswin.wnd.topedge
    prefs.statswindow.width:=statswin.wnd.width
    prefs.statswindow.height:=statswin.wnd.height
  ENDIF
  IF anywin
    IF anywin.wnd
      prefs.anywindow.leftedge:=anywin.wnd.leftedge
      prefs.anywindow.topedge:=anywin.wnd.topedge
    ENDIF
  ENDIF
  IF fillwin.wnd
    prefs.fillwindow.leftedge:=fillwin.wnd.leftedge
    prefs.fillwindow.topedge:=fillwin.wnd.topedge
  ENDIF
  IF penwin.wnd
    prefs.penwindow.leftedge:=penwin.wnd.leftedge
    prefs.penwindow.topedge:=penwin.wnd.topedge
  ENDIF
  IF brushwin.wnd
    prefs.brushwindow.leftedge:=brushwin.wnd.leftedge
    prefs.brushwindow.topedge:=brushwin.wnd.topedge
  ENDIF
  IF shapewin.wnd
    prefs.shapewindow.leftedge:=shapewin.wnd.leftedge
    prefs.shapewindow.topedge:=shapewin.wnd.topedge
  ENDIF
  IF tbwin.wnd
    prefs.tbwindow.leftedge:=tbwin.wnd.leftedge
    prefs.tbwindow.topedge:=tbwin.wnd.topedge
  ENDIF
  IF linewin.wnd
    prefs.linewindow.leftedge:=linewin.wnd.leftedge
    prefs.linewindow.topedge:=linewin.wnd.topedge
  ENDIF
ENDPROC
PROC dmsnap()
  IF dmwin.wnd
    prefs.drawmodewindow.leftedge:=dmwin.wnd.leftedge
    prefs.drawmodewindow.topedge:=dmwin.wnd.topedge
    prefs.windows:=prefs.windows-DRAWMODE
    closewin(dmwin)
  ENDIF
ENDPROC
PROC tbsnap()
  IF tbwin.wnd
    prefs.tbwindow.leftedge:=tbwin.wnd.leftedge
    prefs.tbwindow.topedge:=tbwin.wnd.topedge
    prefs.windows:=prefs.windows-TOOLBAR
    closewin(tbwin)
  ENDIF
ENDPROC
PROC zoomsnap()
  IF zoomwin.wnd
    prefs.zoomwindow.leftedge:=zoomwin.wnd.leftedge
    prefs.zoomwindow.topedge:=zoomwin.wnd.topedge
    prefs.windows:=prefs.windows-ZOOM
    closewin(zoomwin)
  ENDIF
ENDPROC
PROC fillsnap()
  IF fillwin.wnd
    prefs.fillwindow.leftedge:=fillwin.wnd.leftedge
    prefs.fillwindow.topedge:=fillwin.wnd.topedge
    prefs.windows:=prefs.windows-FILLWIN
    closewin(fillwin)
  ENDIF
ENDPROC
PROC pensnap()
  IF penwin.wnd
    prefs.penwindow.leftedge:=penwin.wnd.leftedge
    prefs.penwindow.topedge:=penwin.wnd.topedge
    prefs.windows:=prefs.windows-PEN
    closewin(penwin)
  ENDIF
ENDPROC
PROC statsnap()
  IF statswin.wnd
    prefs.statswindow.leftedge:=statswin.wnd.leftedge
    prefs.statswindow.topedge:=statswin.wnd.topedge
    prefs.statswindow.width:=statswin.wnd.width
    prefs.statswindow.height:=statswin.wnd.height
    prefs.windows:=prefs.windows-STATISTICS
    closewin(statswin)
  ENDIF
ENDPROC
PROC coloursnap()
  IF colwin.wnd
    prefs.colourwindow.leftedge:=colwin.wnd.leftedge
    prefs.colourwindow.topedge:=colwin.wnd.topedge
    prefs.colourwindow.width:=colwin.wnd.width
    prefs.colourwindow.height:=colwin.wnd.height
    prefs.windows:=prefs.windows-COLOUR
    closewin(colwin)
  ENDIF
  ->72,76
ENDPROC
PROC min_size(ta,fh) OF canvas IS 64,64
PROC will_resize() OF canvas IS RESIZEX OR RESIZEY
ENUM HORIZ_ID=100,VERT_ID
PROC clearspecial()
  DEF i
  FOR i:=0 TO Div(Mul(canvas.width,canvas.height),8)-3 STEP 4
    PutLong(i+special,0)
  ENDFOR
ENDPROC
PROC fill(x,y) OF canvas
  DEF o,r,g,b,t:REG,xx:REG,yy:REG,d:REG,
      type,w,h,swp
  w:=canvas.width
  h:=canvas.height
  blockwins()
  setstatus('Filling...')
  o:=self.gettrue(x,y)
  r:=Char(o)
  g:=Char(o+1)
  b:=Char(o+2)
  t:=Div(Mul(self.fill.tolerance,768),100)
  clearspecial()
  ->BltClear(special,Div(Mul(self.width,self.height),8),1)
  outofstack:=FALSE
  exit:=FALSE
  stack[0].x:=x
  stack[0].y:=y
  sp:=1
  sp2:=0
  WHILE (sp>0)
    WHILE (sp>0)
      sp--
      x:=stack[sp].x
      y:=stack[sp].y
      FOR xx:=x-1 TO x+1
        FOR yy:=y-1 TO y+1
          IF (xx>=0) AND (yy>=0) AND (xx<w) AND (yy<h) AND (point(xx,yy)=0) AND (abs(xx-x)<>abs(yy-y))
            o:=self.true+Mul((Mul(yy,w)+xx),3)
            d:=abs(r-Char(o))+abs(g-Char(o+1))+abs(b-Char(o+2))
            IF d<t
              put(xx,yy)
              self.drawfillpixel(xx,yy)
              stack2[sp2].x:=xx
              stack2[sp2].y:=yy
              IF sp2<4095
                sp2++
              ELSE
                outofstack:=TRUE
              ENDIF
            ENDIF
          ENDIF
        ENDFOR
      ENDFOR
    ENDWHILE
    stack:=stack2
    stack2:=stack
    swp:=stack
    sp:=sp2
    sp2:=0
  ENDWHILE
  IF outofstack THEN error('Out of stack')
  self.minx:=0
  self.miny:=0
  self.maxx:=self.width-1
  self.maxy:=self.height-1
  self.setupdate()
  unblockwins()
ENDPROC
PROC drawfillpixel(x,y) OF canvas
  DEF o:PTR TO CHAR,type,trans,ttrans
  trans:=self.fill.transparency
  ttrans:=100-trans
  type:=self.fill.type
  o:=self.gettrue(x,y)
  IF type=SOLID
    PutChar(o,self.fg.red)
    PutChar(o+1,self.fg.green)
    PutChar(o+2,self.fg.blue)
  ELSEIF type=TRANSPARENCY
    PutChar(o,((Char(o)*trans)/100)+((self.fg.red*ttrans)/100))
    PutChar(o+1,((Char(o+1)*trans)/100)+((self.fg.green*ttrans)/100))
    PutChar(o+2,((Char(o+2)*trans)/100)+((self.fg.blue*ttrans)/100))
  ENDIF
ENDPROC
/*PROC abs(n) IS IF n<0 THEN -n ELSE n*/
PROC point(x,y)
  DEF byte:REG,bit:REG
  byte:=(y*bytesperrow)+Shr(x,3)
  bit:=Mod(x,8)
ENDPROC Char(special+byte) AND Shl(1,bit)
PROC put(x,y)
  DEF byte:REG,bit:REG
  byte:=(y*bytesperrow)+Shr(x,3)
  bit:=Mod(x,8)
  PutChar(special+byte,Char(special+byte) OR Shl(1,bit))
ENDPROC
PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF canvas
  self.mousex:=imsg.mousex
  self.mousey:=imsg.mousey
  self.gad:=imsg.iaddress
  IF (imsg.class AND (IDCMP_MOUSEMOVE OR IDCMP_MOUSEBUTTONS OR SCROLLERIDCMP OR ARROWIDCMP)) THEN RETURN TRUE
ENDPROC FALSE
PROC message_action(class,qual,code,win:PTR TO window) OF canvas
  DEF rxs,rys,mx,my,id
  mx:=(((self.mousex-self.x)*self.ratioy)/self.ratiox)+self.ox
  my:=(((self.mousey-self.y)*self.ratioy)/self.ratiox)+self.oy
  rys:=Min(self.ys-10,self.zheight)
  rxs:=Min(self.xs-18,self.zwidth)
    SELECT class
    CASE IDCMP_GADGETUP
      id:=self.gad.gadgetid
      SELECT id
        CASE HORIZ_ID
          self.doscroll()
        CASE VERT_ID
          self.doscroll()
      ENDSELECT
 ENDSELECT
 IF (mx>=0) AND (my>=0) AND (mx<self.width) AND (my<self.height)
   SELECT class
    CASE IDCMP_MOUSEBUTTONS
      SELECT code
        CASE SELECTDOWN
          self.butt:=SEL
          self.px:=mx
          self.py:=my
          SELECT dm
            CASE LINE
              self.pen.transparency:=getinteger(penwin,tragadp)
              self.pen.size:=getinteger(penwin,sizgadp)
              self.wsx:=self.mousex
              self.wsy:=self.mousey
              self.sx:=mx
              self.sy:=my
              self.wpx:=self.mousex
              self.wpy:=self.mousey
              drawxorline(self.wsx, self.wsy, self.wpx, self.wpy)
            CASE RECTANGLE
              self.pen.transparency:=getinteger(penwin,tragadp)
              self.pen.size:=getinteger(penwin,sizgadp)
              self.shape.transparency:=getinteger(shapewin, tragads)
              self.wsx:=self.mousex
              self.wsy:=self.mousey
              self.sx:=mx
              self.sy:=my
              self.wpx:=self.mousex
              self.wpy:=self.mousey
              drawxorbox(self.wsx, self.wsy, self.wpx, self.wpy)
            CASE CONTINUOUS
              self.pen.transparency:=getinteger(penwin,tragadp)
              self.pen.size:=getinteger(penwin,sizgadp)
              self.plotpen(mx,my)
          ENDSELECT
        CASE SELECTUP
          SELECT dm
            CASE FILL
              self.fill.transparency:=getinteger(fillwin,tragadf)
              self.fill.tolerance:=getinteger(fillwin,tolgadf)
              self.fill(mx, my)
            CASE LINE
              drawxorline(self.wsx, self.wsy, self.wpx, self.wpy)
              self.drawline(self.sx, self.sy, mx, my, self.line.style)
            CASE RECTANGLE
              drawxorbox(self.wsx, self.wsy, self.wpx, self.wpy)
              self.rect(self.sx, self.sy, mx, my)
          ENDSELECT
          self.butt:=NIL
      ENDSELECT
    CASE IDCMP_MOUSEMOVE
      IF self.butt
        SELECT dm
          CASE CONTINUOUS
            IF self.pickup=0
              self.drawline(self.px,self.py,mx,my)
            ELSE
              self.pickup:=0
            ENDIF
            self.px:=mx
            self.py:=my
          CASE LINE
            drawxorline(self.wsx, self.wsy, self.wpx, self.wpy)
            self.px:=mx
            self.py:=my
            self.wpx:=self.mousex
            self.wpy:=self.mousey
            drawxorline(self.wsx, self.wsy, self.wpx, self.wpy)
          CASE RECTANGLE
            drawxorbox(self.wsx, self.wsy, self.wpx, self.wpy)
            self.px:=mx
            self.py:=my
            self.wpx:=self.mousex
            self.wpy:=self.mousey
            drawxorbox(self.wsx, self.wsy, self.wpx, self.wpy)
        ENDSELECT
      ENDIF
  ENDSELECT
ELSE
  SELECT class
    CASE IDCMP_MOUSEBUTTONS
      SELECT code
        CASE SELECTUP
          SELECT dm
            CASE LINE
              drawxorline(self.wsx, self.wsy, self.wpx, self.wpy)
            CASE RECTANGLE
              drawxorbox(self.wsx, self.wsy, self.wpx, self.wpy)
          ENDSELECT
          self.butt:=NIL
      ENDSELECT
    CASE IDCMP_MOUSEMOVE
      SELECT dm
        CASE CONTINUOUS
          self.pickup:=1
      ENDSELECT
  ENDSELECT
ENDIF
ENDPROC FALSE
PROC drawxorline(x1, y1, x2, y2)
  SetDrMd(cnvwin.wnd.rport, RP_COMPLEMENT)
  Move(cnvwin.wnd.rport, x1, y1)
  Draw(cnvwin.wnd.rport, x2, y2)
  SetDrMd(cnvwin.wnd.rport, RP_JAM1)
ENDPROC
PROC drawxorbox(x1, y1, x2, y2)
  SetDrMd(cnvwin.wnd.rport, RP_COMPLEMENT)
  Move(cnvwin.wnd.rport, x1, y1)
  Draw(cnvwin.wnd.rport, x2, y1)
  Draw(cnvwin.wnd.rport, x2, y2)
  Draw(cnvwin.wnd.rport, x1, y2)
  Draw(cnvwin.wnd.rport, x1, y1)
  SetDrMd(cnvwin.wnd.rport, RP_JAM1)
ENDPROC
PROC appmessage(msg,win:PTR TO window) OF canvas IS TRUE
PROC gettrue(x,y) OF canvas
  IF self.flags AND CF_USINGVMEM
    IF (Mul((Mul(y,self.width)+x),3)>(self.vptr+(self.vsize-10))) OR (Mul((Mul(y,self.width)+x),3)<self.vptr)
      Seek(self.vmem,self.vptr,OFFSET_BEGINNING)
      Write(self.vmem,self.vbuf,self.vsize)
      self.vptr:=Max(Mul((Mul(y,self.width)+x),3)-Div(self.vsize,2),0)
      Seek(self.vmem,self.vptr,OFFSET_BEGINNING)
      Read(self.vmem,self.vbuf,self.vsize)
    ENDIF
    RETURN self.vbuf+(Mul((Mul(y,self.width)+x),3)-self.vptr)
  ELSE
    RETURN self.true+Mul((Mul(y,self.width)+x),3)
  ENDIF
ENDPROC
PROC plot(x,y) OF canvas
  self.pen.transparency:=getinteger(penwin,tragadp)
  self.pen.size:=getinteger(penwin,sizgadp)
  self.plotpen(x,y)
  self.setupdate()
ENDPROC
PROC plotpen(x,y,doput=FALSE) OF canvas
  DEF shape
  IF self.pen.size=0
    self.writepixel(x,y,self.pen.transparency)
    IF self.minx>x THEN self.minx:=x
    IF self.miny>y THEN self.miny:=y
    IF self.maxx<x THEN self.maxx:=x
    IF self.maxy<y THEN self.maxy:=y
  ELSE
    shape:=self.pen.shape
    SELECT shape
      CASE SQUARE
        self.drawrect(Max(x-self.pen.size,0), Max(y-self.pen.size, 0), Min(x+self.pen.size, self.width-1), Min(y+self.pen.size, self.height-1), self.pen.transparency)
    ENDSELECT
  ENDIF
ENDPROC
PROC rect(x1, y1, x2, y2) OF canvas
  DEF t,x,y
  IF (x2<x1)
    t:=x2
    x2:=x1
    x1:=t
  ENDIF
  IF (y2<y1)
    t:=y2
    y2:=y1
    y1:=t
  ENDIF
  IF (self.shape.type=FILLED)
    FOR x:=x1 TO x2
      FOR y:=y1 TO y2
        self.drawfillpixel(x,y)
      ENDFOR
    ENDFOR
    IF self.minx>x1 THEN self.minx:=x1
    IF self.miny>y1 THEN self.miny:=y1
    IF self.maxx<x2 THEN self.maxx:=x2
    IF self.maxy<y2 THEN self.maxy:=y2
    self.setupdate()
  ENDIF
  IF (self.shape.type=OUTLINE)
    self.drawline(x1, y1, x2, y1, self.line.style)
    self.drawline(x2, y1, x2, y2, self.line.style)
    self.drawline(x2, y2, x1, y2, self.line.style)
    self.drawline(x1, y2, x1, y1, self.line.style)
  ENDIF
ENDPROC
PROC drawrect(x1, y1, x2, y2, trans) OF canvas
  DEF x,y
  FOR x:=x1 TO x2
    FOR y:=y1 TO y2
      self.writepixel(x,y,trans)
    ENDFOR
  ENDFOR
  IF self.minx>x1 THEN self.minx:=x1
  IF self.miny>y1 THEN self.miny:=y1
  IF self.maxx<x2 THEN self.maxx:=x2
  IF self.maxy<y2 THEN self.maxy:=y2
ENDPROC
PROC writepixel(x,y,trans=0) OF canvas
  DEF o,ttrans
  IF trans<>0
    ttrans:=100-trans
    o:=self.gettrue(x,y)
    PutChar(o,((Char(o)*trans)/100)+((self.fg.red*ttrans)/100))
    PutChar(o+1,((Char(o+1)*trans)/100)+((self.fg.green*ttrans)/100))
    PutChar(o+2,((Char(o+2)*trans)/100)+((self.fg.blue*ttrans)/100))
  ELSE
    o:=self.gettrue(x,y)
    PutChar(o,self.fg.red)
    PutChar(o+1,self.fg.green)
    PutChar(o+2,self.fg.blue)
  ENDIF
ENDPROC
/*PROC writepixel2(x,y) OF canvas
  DEF o
  o:=self.gettrue(x,y)
  PutChar(o,self.fg.red)
  PutChar(o+1,self.fg.green)
  PutChar(o+2,self.fg.blue)
  SetAPen(cnvwin.wnd.rport,2)
  WritePixel(cnvwin.wnd.rport,canvas.x+x-canvas.ox,canvas.y+y-canvas.oy)
ENDPROC*/
PROC drawline(x1,y1,x2,y2,style=CONTINUOUS) OF canvas
  DEF x,y,len,i,px=-1,py=-1,in=0,pat:PTR TO CHAR
  pat:=ListItem([[1,1,1,1,1,1]:CHAR,[1,0,1,0,1,0]:CHAR,[1,1,1,1,0,0]:CHAR],style)
  len:=sqr(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1)))+1
  FOR i:=0 TO len
    IF pat[in]=1
      x:=((((x2-x1)*i)/len)+x1)
      y:=((((y2-y1)*i)/len)+y1)
      IF (x<>px) OR (y<>py)
        self.plotpen(x,y)
        px:=x
        py:=y
      ENDIF
    ENDIF
    in:=Mod(in+1,6)
  ENDFOR
  self.setupdate()
ENDPROC
#define RGB32(r,g,b) Shl(r,24)+Shl(r,16)+Shl(r,8)+r,\
                     Shl(g,24)+Shl(g,16)+Shl(g,8)+g,\
                     Shl(b,24)+Shl(b,16)+Shl(b,8)+b
PROC getpen(r,g,b) OF canvas
  DEF pen
  IF r>255 THEN r:=255
  IF g>255 THEN g:=255
  IF b>255 THEN b:=255
  pen:=ObtainBestPenA(self.scr.viewport.colormap,RGB32(r,g,b),
                                                 [OBP_PRECISION, PRECISION_IMAGE,
                                                  NIL])
ENDPROC pen
PROC freepen(pen) OF canvas
  RETURN ReleasePen(self.scr.viewport.colormap,pen)
ENDPROC
PROC clear() OF canvas
  DEF x,y,pen
  blockwins()
  setstatus('Clearing canvas...')
  FOR y:=0 TO self.height-1
    FOR x:=0 TO self.width-1
      self.writepixel(x,y)
    ENDFOR
    setprogress((100*y)/self.height)
  ENDFOR
  setprogress(0)
  self.minx:=0
  self.miny:=0
  self.maxx:=self.width-1
  self.maxy:=self.height-1
  pen:=self.penarray[self.remaparray[((self.fg.red/16)*256)+((self.fg.green/16)*16)+(self.fg.blue/16)]].pen
  SetAPen(self.rastport,pen)
  RectFill(self.rastport,0,0,self.width-1,self.height-1)
  self.refresh()
  setstatus('')
  unblockwins()
ENDPROC
PROC end() OF canvas
  DEF i
  FOR i:=0 TO 124
    self.freepen(self.penarray[i].pen)
  ENDFOR
  IF self.bitmap THEN FreeBitMap(self.bitmap)
  IF self.true THEN FreeVec(self.true)
  IF self.vmem
    Close(self.vmem)
    DeleteFile(prefs.vmemloc)
  ENDIF
  IF self.vbuf THEN FreeVec(self.vbuf)
  IF special THEN FreeVec(special)
ENDPROC
PROC abs(n) IS IF n<0 THEN -n ELSE n
PROC penremap(r,g,b) OF canvas
  DEF n=0,m=768,i,d
  FOR i:=0 TO 124
    d:=abs(self.penarray[i].c.red-r)+abs(self.penarray[i].c.green-g)+abs(self.penarray[i].c.blue-b)
    IF d<m
      m:=d
      n:=i
    ENDIF
  ENDFOR
ENDPROC n
PROC speed()
  DEF secs, micro, osecs, omicro
  canvas.minx:=0
  canvas.miny:=0
  canvas.maxx:=canvas.width-1
  canvas.maxy:=canvas.height-1
  CurrentTime({secs}, {micro})
  renderloop(FALSE)
  CurrentTime({osecs}, {omicro})
  IF omicro<micro
    osecs:=osecs-1
    omicro:=omicro+1000000
  ENDIF
  StringF(buffer, '\d x \d : \d.\z\d[6] secs', canvas.width, canvas.height, osecs-secs, omicro-micro)
  setstatus(buffer)
ENDPROC
PROC fspeed()
  DEF secs, micro, osecs, omicro
  canvas.minx:=0
  canvas.miny:=0
  canvas.maxx:=canvas.width-1
  canvas.maxy:=canvas.height-1
  CurrentTime({secs}, {micro})
  canvas.fill(0,0)
  CurrentTime({osecs}, {omicro})
  IF omicro<micro
    osecs:=osecs-1
    omicro:=omicro+1000000
  ENDIF
  StringF(buffer, '\d x \d : \d.\z\d[6] secs', canvas.width, canvas.height, osecs-secs, omicro-micro)
  setstatus(buffer)
ENDPROC
PROC doscroll() OF canvas
  DEF nox,noy
  Gt_GetGadgetAttrsA(self.horizgadget, self.gh.wnd, NIL, [GTSC_TOP, {nox}, NIL])
  Gt_GetGadgetAttrsA(self.vertgadget, self.gh.wnd, NIL, [GTSC_TOP, {noy}, NIL])
  IF (nox<>self.ox) OR (noy<>self.oy)
    self.ox:=nox
    self.oy:=noy
    self.minx:=0
    self.miny:=0
    self.maxx:=self.width-1
    self.maxy:=self.height-1
    self.setupdate()
  ENDIF
ENDPROC
PROC gtrender(gl,vis,ta,x,y,xs,ys,win:PTR TO window) OF canvas
  self.gl:=gl
  self.vis:=vis
  self.ta:=ta
  self.gh.wnd:=win
  self.minx:=0
  self.miny:=0
  self.maxx:=self.width-1
  self.maxy:=self.height-1
  self.horizgadget:=CreateGadgetA(SCROLLER_KIND,gl,[self.x,self.y+self.ys-10,self.xs-18,10,NIL,ta,HORIZ_ID,NIL,vis,NIL]:newgadget,
                                  [GTSC_ARROWS,16,GTSC_TOTAL,self.zwidth,GTSC_TOP,self.ox,GTSC_VISIBLE,xs-18,GA_RELVERIFY,TRUE,NIL])
  self.vertgadget:=CreateGadgetA(SCROLLER_KIND,self.horizgadget,[self.x+self.xs-18,self.y,18,self.ys-10,NIL,ta,VERT_ID,NIL,vis,NIL]:newgadget,
                                 [GTSC_ARROWS,8,GTSC_TOTAL,self.zheight,GTSC_TOP,self.oy,GTSC_VISIBLE,ys-10,PGA_FREEDOM,LORIENT_VERT,GA_RELVERIFY,TRUE,NIL])
  self.refresh(TRUE)
  ReportMouse(TRUE,win)
ENDPROC
PROC refresh(resized=FALSE) OF canvas
  DEF x,y,w,h,dx,dy
  IF self.gh
    IF self.gh.wnd
      IF self.ratiox<>self.ratioy
        WindowToFront(self.gh.wnd)
      ENDIF
    ENDIF
  ENDIF
  IF resized
    SetAPen(self.gh.wnd.rport,0)
    RectFill(self.gh.wnd.rport,self.x,self.y,self.x+self.xs-18,self.y+self.ys-10)
  ENDIF
  IF self.ox>(self.zwidth-self.xs) THEN self.ox:=self.zwidth-self.xs
  IF self.oy>(self.zheight-self.ys) THEN self.oy:=self.zheight-self.ys
  IF self.ox<0 THEN self.ox:=0
  IF self.oy<0 THEN self.oy:=0
  x:=Max(self.minx,self.ox)
  y:=Max(self.miny,self.oy)
  dx:=(((x-self.ox)*self.ratiox)/self.ratioy)
  dy:=(((y-self.oy)*self.ratiox)/self.ratioy)
  w:=Min((self.maxx-self.minx)+1,(((self.xs-18-dx)*self.ratioy)/self.ratiox))
  h:=Min((self.maxy-self.miny)+1,(((self.ys-10-dy)*self.ratioy)/self.ratiox))
  IF self.gh
    IF self.gh.wnd
      IF self.ratiox<>self.ratioy
        BitMapScale([x,y,w,h,self.ratioy,self.ratioy,self.x+dx+self.gh.wnd.leftedge,self.y+dy+self.gh.wnd.topedge,Min(self.xs-18,self.zwidth),Min(self.ys-10,self.zheight),self.ratiox,self.ratiox,self.bitmap,self.gh.wnd.rport.bitmap,NIL,NIL,NIL,NIL,NIL]:bitscaleargs)
      ELSE
        BltBitMapRastPort(self.bitmap,x,y,self.gh.wnd.rport,self.x+dx,self.y+dy,w,h,$c0)
        -> Use faster method for 1:1
      ENDIF
    ENDIF
  ENDIF
  IF resized
    IF self.horizgadget THEN Gt_SetGadgetAttrsA(self.horizgadget,self.gh.wnd,NIL,[GTSC_TOTAL,self.zwidth,GTSC_TOP,self.ox,GTSC_VISIBLE,self.xs-18,NIL])
    IF self.vertgadget THEN Gt_SetGadgetAttrsA(self.vertgadget,self.gh.wnd,NIL,[GTSC_TOTAL,self.zheight,GTSC_TOP,self.oy,GTSC_VISIBLE,self.ys-10,NIL])
  ENDIF
  self.minx:=self.width
  self.miny:=self.height
  self.maxx:=-1
  self.maxy:=-1
ENDPROC
PROC clear_render(win) OF canvas
  self.horizgadget:=NIL
  self.vertgadget:=NIL
  self.gl:=NIL
  self.vis:=NIL
ENDPROC
/* Optimised version of render loop (10x faster!) */
/* (Still could do with being written in assembler though! */
PROC renderloop(prog)
  DEF o:REG, x:REG, y,  line:REG, t:REG, b, c:PTR TO CHAR, d:REG
  IF line:=New(canvas.width)
    b:=canvas.maxx-canvas.minx
    c:=canvas.remaparray
    d:=canvas.penarray
    FOR y:=canvas.miny TO canvas.maxy
      t:=Mul(Mul(y,canvas.width),3)+(canvas.minx*3)+canvas.true
      FOR x:=0 TO b
        o:=x*3+t
        line[x]:=Char(c[(Shl(o[0],4) AND $F00)+(o[1] AND $F0)+Shr(o[2],4)]*16+15+d)
        ->SetAPen(canvas.rastport, line[x])
        ->WritePixel(canvas.rastport, x+canvas.minx, y)
      ENDFOR
      WritePixelLine8(canvas.rastport, canvas.minx, y, canvas.maxx-canvas.minx+1, line, temprp)
      IF prog THEN setprogress((100*(y-canvas.miny))/(canvas.maxy-canvas.miny))
    ENDFOR
    Dispose(line)
  ENDIF
ENDPROC
PROC vrenderloop(prog)
  DEF o:REG, x:REG, y,  line:REG, t:REG, b, c:PTR TO CHAR, d:REG
  IF line:=New(canvas.width)
    b:=canvas.maxx-canvas.minx
    c:=canvas.remaparray
    d:=canvas.penarray
    FOR y:=canvas.miny TO canvas.maxy
      t:=Mul(Mul(y,canvas.width),3)+(canvas.minx*3)+canvas.true
      FOR x:=0 TO b
        o:=canvas.gettrue(x,y)
        line[x]:=Char(c[(Shl(o[0],4) AND $F00)+(o[1] AND $F0)+Shr(o[2],4)]*16+15+d)
        ->SetAPen(canvas.rastport, line[x])
        ->WritePixel(canvas.rastport, x+canvas.minx, y)
      ENDFOR
      WritePixelLine8(canvas.rastport, canvas.minx-canvas.ox, y-canvas.oy, canvas.maxx-canvas.minx+1, line, temprp)
      IF prog THEN setprogress((100*(y-canvas.miny))/(canvas.maxy-canvas.miny))
    ENDFOR
    Dispose(line)
  ENDIF
ENDPROC
PROC update() OF canvas
  DEF x,y,h,o:PTR TO colour,pen,prog=FALSE
  IF (self.minx>=self.width) OR (self.miny>=self.height) OR (self.maxx<0) OR (self.maxy<0) THEN RETURN
  IF (self.minx=0) AND (self.miny=0) AND (self.maxx=(self.width-1)) AND (self.maxy=(self.height-1))
    prog:=TRUE
    setstatus('Rendering...')
  ENDIF
  -> This needs to be optimised in assembler
  -> Anyone up to the job?
  -> LOOP
  ->   Wait(self.sig)
  -> This could possible be made a separate task (hence the loop above)
  -> in which case the main program would be freed up for something else.
    IF self.rastport
      IF self.flags AND CF_NEEDUPDATE THEN self.flags:=self.flags-CF_NEEDUPDATE
      IF (self.flags AND CF_USINGVMEM)=NIL
        renderloop(prog)
      ELSE
        vrenderloop(prog)
      ENDIF
    ENDIF
  -> ENDLOOP
  IF prog
    setprogress(0)
    setstatus('')
  ENDIF
  self.refresh()
ENDPROC
PROC clipupdate() OF canvas
  DEF rxs,rys
  rys:=Min(self.ys-10,self.height)
  rxs:=Min(self.xs-18,self.width)
  self.minx:=Max(self.ox,self.minx)
  self.miny:=Max(self.oy,self.miny)
  self.maxx:=Min(self.ox+rxs-1,self.maxx)
  self.maxy:=Min(self.oy+rys-1,self.maxy)
  IF (self.maxx<self.minx) OR (self.maxy<self.miny) THEN IF self.flags AND CF_NEEDUPDATE THEN self.flags:=self.flags-CF_NEEDUPDATE
ENDPROC
PROC setupdate() OF canvas
  self.flags:=self.flags OR CF_NEEDUPDATE
  self.clipupdate()
  IF self.flags AND CF_NEEDUPDATE
    self.update()
  ENDIF
  -> Signal(self.task, self.sig)
ENDPROC
PROC changesize(width,height) OF canvas
  DEF rxs,rys
  self.minx:=self.width
  self.miny:=self.height
  self.maxx:=-1
  self.maxy:=-1
  self.width:=width
  self.height:=height
  self.zwidth:=(self.width*self.ratiox)/self.ratioy
  self.zheight:=(self.height*self.ratiox)/self.ratioy
  IF self.true
    FreeVec(self.true)
    self.true:=NIL
  ENDIF
  IF self.vmem
    Close(self.vmem)
    self.vmem:=NIL
    self.flags:=self.flags-CF_USINGVMEM
  ENDIF
  IF self.bitmap
    FreeBitMap(self.bitmap)
    self.bitmap:=NIL
  ENDIF
  IF special THEN FreeVec(special)
  IF (self.flags AND CF_FORCEVMEM)=NIL THEN self.true:=AllocVec(Mul(Mul((width+1),(height+1)),3),MEMF_CLEAR)
  IF self.true=NIL
    self.allocvmem(Mul(Mul((width+1),(height+1)),3))
    IF self.vmem=NIL
      error('Cannot create 24-Bit Buffer')
      Raise("CANV")
    ENDIF
  ENDIF
  /*self.bitmap:=AllocBitMap(width,height,scr.rastport.bitmap.depth,BMF_CLEAR,NIL)
  IF self.bitmap=NIL
    error('Cannot create BitMap')
    Raise("CANV")
  ENDIF*/
  special:=AllocVec(Div(Mul(width,height),8),MEMF_CLEAR)
  IF special=NIL
    error('Cannot create Special buffer')
    Raise("CANV")
  ENDIF
  self.rastport.bitmap:=self.bitmap
  SetAPen(self.rastport,1)
  RectFill(self.rastport,0,0,self.width-1,self.height-1)
  self.minx:=0
  self.miny:=0
  self.maxx:=self.width-1
  self.maxy:=self.height-1
  self.refresh(TRUE)
  setnum(statswin,cwg,canvas.width)
  setnum(statswin,chg,canvas.height)
  setnum(statswin,csg,Div(Mul(Mul(canvas.width,canvas.height),3),1024))
  setnum(statswin,bsg,Div(Mul(Mul(canvas.bitmap.depth,canvas.bitmap.bytesperrow),canvas.bitmap.rows),1024))
  settext(statswin,vg,IF canvas.vmem THEN 'Yes' ELSE 'No')
  setnum(statswin,psg,(canvas.vsize)/1024)
  bytesperrow:=self.width/8
ENDPROC
PROC create(scr:PTR TO screen,width=160,height=128,flags=NIL) OF canvas
  DEF i=0,u,r,g,b,fh
  BltClear(self,SIZEOF canvas,1)
  self.ratiox:=1
  self.ratioy:=1
  self.minx:=self.width
  self.miny:=self.height
  self.maxx:=-1
  self.maxy:=-1
  self.flags:=flags
  self.width:=width
  self.height:=height
  self.zwidth:=width
  self.zheight:=height
  self.scr:=scr
  IF (self.flags AND CF_FORCEVMEM)=NIL THEN self.true:=AllocVec(Mul(Mul((width+1),(height+1)),3),MEMF_CLEAR)
  IF self.true=NIL
    self.allocvmem(Mul(Mul((width+1),(height+1)),3))
    IF self.vmem=NIL
      error('Cannot create 24-Bit Buffer')
      Raise("CANV")
    ENDIF
  ENDIF
  setstatus('Grabbing Pens...')
  IF prefs.grayscale
    error('Grayscale preview is not implemented\n')
    Raise("CANV")
  ELSE
  i:=0
  FOR r:=0 TO 4
    FOR g:=0 TO 4
      FOR b:=0 TO 4
        self.penarray[i].pen:=self.getpen(r*63,g*63,b*63)
        self.penarray[i].c.red:=r*63
        self.penarray[i].c.green:=g*63
        self.penarray[i].c.blue:=b*63
        i++
      ENDFOR
    ENDFOR
  ENDFOR
  setstatus('Creating Remap Array...')
  i:=0
  FOR r:=0 TO 15
    FOR g:=0 TO 15
      FOR b:=0 TO 15
        self.remaparray[i]:=(((r*17)/52)*25)+(((g*17)/52)*5)+((b*17)/52)
        i++
      ENDFOR
    ENDFOR
  ENDFOR
  ENDIF
  self.bitmap:=AllocBitMap(scr.width,scr.height,scr.rastport.bitmap.depth,BMF_CLEAR,NIL)
  IF self.bitmap=NIL
    error('Cannot create BitMap')
    Raise("CANV")
  ENDIF
  special:=AllocVec(Div(Mul(width,height),8),MEMF_CLEAR)
  IF special=NIL
    error('Cannot create Special buffer')
    Raise("CANV")
  ENDIF
  InitRastPort(temprp)
  tempbmp:=AllocBitMap(scr.width,1,scr.rastport.bitmap.depth,NIL,NIL)
  IF tempbmp=NIL
    error('Cannot create temporary BitMap')
    Raise("CANV")
  ENDIF
  temprp.bitmap:=tempbmp
  InitRastPort(self.rastport)
  self.rastport.bitmap:=self.bitmap
  NEW self.pen
  NEW self.line
  NEW self.fill
  NEW self.shape
  NEW self.brush
  SetAPen(self.rastport,1)
  RectFill(self.rastport,0,0,self.width-1,self.height-1)
  self.setupdate()
  self.fg.red:=255
  self.fg.green:=255
  self.fg.blue:=255
  self.vmem:=NIL
  self.horizgadget:=NIL
  self.vertgadget:=NIL
  IF self.flags AND CF_USEVMEM
    self.vbuf:=AllocVec(prefs.vsize,MEMF_ANY)
    self.vsize:=prefs.vsize
    IF self.vbuf=NIL THEN self.flags:=self.flags-CF_USEVMEM
  ENDIF
  dm:=CONTINUOUS
  setstatus('')
  bytesperrow:=self.width/8
ENDPROC
PROC allocvmem(size) OF canvas
  DEF alloced
  IF self.flags AND CF_USEVMEM
  self.vmem:=Open(prefs.vmemloc,MODE_READWRITE)
  IF self.vmem
    setstatus('Allocating virtual memory...')
    WriteF('VMEM: \d bytes requested\n', size)
    alloced:=SetFileSize(self.vmem,size+self.vsize,OFFSET_BEGINNING)
    WriteF('VMEM: \d bytes allocated\n', alloced)
    IF alloced<>(size+self.vsize)
      Close(self.vmem)
      WriteF('VMEM: Fatal error!\n')
      WriteF('VMEM: SetFileSize() failed\n')
      self.vmem:=NIL
    ELSE
      WriteF('VMEM: Memory allocated successfully\n')
      self.vptr:=NIL
      self.flags:=self.flags OR CF_USINGVMEM
    ENDIF
    setstatus('')
  ELSE
    WriteF('VMEM: Fatal error!\n')
    WriteF('VMEM: File \s could not be opened\n', prefs.vmemloc)
  ENDIF
  ELSE
    WriteF('VMEM: Disabled\n')
  ENDIF
ENDPROC
PROC end() OF drawmode
  DEF i
  FOR i:=0 TO MAXDRAWMODE-1
    IF self.icon[i].dto<>NIL THEN DisposeDTObject(self.icon[i].dto)
  ENDFOR
ENDPROC
PROC buttons() OF drawmode
  DEF dto,bitmap,bmhd:PTR TO bitmapheader,icons:PTR TO LONG,i
  setstatus('Loading DrawMode Icons...')
  self.width:=0
  self.height:=0
  icons:=['Continuous.iff','Line.iff','Rectangle.iff','Fill.iff','Clear.iff']
  FOR i:=0 TO MAXDRAWMODE-1
    dto,bitmap,bmhd:=loadicon(prefs.dmiconloc,icons[i])
    IF bmhd=NIL
      NEW bmhd
      bmhd.width:=6
      bmhd.height:=4
    ENDIF
    self.icon[i].dto:=dto
    self.icon[i].bitmap:=bitmap
    self.icon[i].bmhd:=bmhd
    IF bmhd.width>self.width THEN self.width:=bmhd.width
    IF bmhd.height>self.height THEN self.height:=bmhd.height
  ENDFOR
  setstatus('')
ENDPROC
PROC loadicon(path,filename)
  DEF bmhd=NIL, bitmap=NIL, dtobject=NIL, filepath[256]:STRING
  StrCopy(filepath,path)
  AddPart(filepath,filename,256)
  IF datatypesbase=NIL THEN datatypesbase:=OpenLibrary('datatypes.library', 39)
  IF (datatypesbase<>NIL) AND (scr<>NIL)
    dtobject:=NewDTObjectA(filepath,
                                [DTA_GROUPID, GID_PICTURE,
                                 PDTA_SCREEN, scr,
                                 PDTA_REMAP, TRUE,
                                 PDTA_FREESOURCEBITMAP, TRUE,
                                 OBP_PRECISION, PRECISION_ICON,
                                 TAG_DONE])
    IF dtobject
      IF DoDTMethodA(dtobject,NIL,NIL,[DTM_PROCLAYOUT,NIL,1])=NIL
        DisposeDTObject(dtobject)
        dtobject:=NIL
      ELSE
        GetDTAttrsA(dtobject, [PDTA_BITMAPHEADER, {bmhd}, PDTA_BITMAP, {bitmap}, TAG_DONE])
      ENDIF
    ENDIF
  ENDIF
ENDPROC dtobject,bitmap,bmhd
PROC will_resize() OF drawmode IS NIL
PROC min_size(ta,fh) OF drawmode IS self.width,self.height*MAXDRAWMODE
PROC gtrender(gl,vis,ta,x,y,xs,ys,win:PTR TO window) OF drawmode
  DEF i,sel,yp
  yp:=y
  FOR i:=0 TO MAXDRAWMODE-1
    IF (dm=i) THEN sel:=GTBB_RECESSED ELSE sel:=TAG_IGNORE
    IF self.icon[i].bitmap<>NIL THEN BltBitMapRastPort(self.icon[i].bitmap,0,0,win.rport,x,yp,self.icon[i].bmhd.width,self.icon[i].bmhd.height,$c0)
    DrawBevelBoxA(win.rport,x,yp,self.icon[i].bmhd.width,self.icon[i].bmhd.height,[sel,TRUE,GT_VISUALINFO,vis,NIL])
    yp:=yp+self.height
  ENDFOR
  self.vis:=vis
ENDPROC
PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF drawmode
  self.mousex:=imsg.mousex
  self.mousey:=imsg.mousey
  IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.mousex>=self.x) AND (imsg.mousey>=self.y) AND (imsg.mousex<(self.x+self.xs)) AND (imsg.mousey<(self.y+self.ys)) THEN RETURN TRUE
ENDPROC FALSE
PROC message_action(class,qual,code,win:PTR TO window) OF drawmode
  DEF olddm,re=FALSE
  olddm:=dm
  IF code=SELECTDOWN
    IF (self.mousex>=self.x) AND (self.mousex<(self.x+self.width)) AND (self.mousey>self.y) AND (self.mousey<(self.y+(MAXDRAWMODE*self.height)))
      DrawBevelBoxA(self.gh.wnd.rport,self.x,self.y+(dm*self.height),self.icon[dm].bmhd.width,self.icon[dm].bmhd.height,[GT_VISUALINFO,self.vis,NIL])
      dm:=(self.mousey-self.y)/self.height
      DrawBevelBoxA(self.gh.wnd.rport,self.x,self.y+(dm*self.height),self.icon[dm].bmhd.width,self.icon[dm].bmhd.height,[GTBB_RECESSED,TRUE,GT_VISUALINFO,self.vis,NIL])
    ENDIF
  ENDIF
  IF olddm<>dm
    anywin:=NIL
    SELECT dm
      CASE CLEAR
        blockwins()
        canvas.clear()
        unblockwins()
        re:=TRUE
    ENDSELECT
    SELECT olddm
    ENDSELECT
    IF re
      DrawBevelBoxA(self.gh.wnd.rport,self.x,self.y+(dm*self.height),self.icon[dm].bmhd.width,self.icon[dm].bmhd.height,[GT_VISUALINFO,self.vis,NIL])
      dm:=olddm
      DrawBevelBoxA(self.gh.wnd.rport,self.x,self.y+(dm*self.height),self.icon[dm].bmhd.width,self.icon[dm].bmhd.height,[GTBB_RECESSED,TRUE,GT_VISUALINFO,self.vis,NIL])
    ENDIF
  ENDIF
ENDPROC
PROC end() OF toolbar
  DEF i
  FOR i:=0 TO MAXTOOLBAR-1
    IF self.icon[i].dto<>NIL THEN DisposeDTObject(self.icon[i].dto)
  ENDFOR
ENDPROC
PROC buttons() OF toolbar
  DEF dto,bitmap,bmhd:PTR TO bitmapheader,icons:PTR TO LONG,i
  setstatus('Loading Toolbar Icons...')
  self.width:=0
  self.height:=0
  icons:=['Open.iff','Save.iff','Print.iff','Information.iff']
  FOR i:=0 TO MAXTOOLBAR-1
    dto,bitmap,bmhd:=loadicon(prefs.tbiconloc,icons[i])
    IF bmhd=NIL
      NEW bmhd
      bmhd.width:=6
      bmhd.height:=4
    ENDIF
    self.icon[i].dto:=dto
    self.icon[i].bitmap:=bitmap
    self.icon[i].bmhd:=bmhd
    IF bmhd.width>self.width THEN self.width:=bmhd.width
    IF bmhd.height>self.height THEN self.height:=bmhd.height
  ENDFOR
  setstatus('')
ENDPROC
PROC will_resize() OF toolbar IS NIL
PROC min_size(ta,fh) OF toolbar IS self.width*MAXTOOLBAR,self.height
PROC gtrender(gl,vis,ta,x,y,xs,ys,win:PTR TO window) OF toolbar
  DEF i,xp
  xp:=x
  FOR i:=0 TO MAXTOOLBAR-1
    IF self.icon[i].bitmap<>NIL THEN BltBitMapRastPort(self.icon[i].bitmap,0,0,win.rport,xp,y,self.icon[i].bmhd.width,self.icon[i].bmhd.height,$c0)
    DrawBevelBoxA(win.rport,xp,y,self.icon[i].bmhd.width,self.icon[i].bmhd.height,[GT_VISUALINFO,vis,NIL])
    xp:=xp+self.width
  ENDFOR
  self.vis:=vis
ENDPROC
PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF toolbar
  self.mousex:=imsg.mousex
  self.mousey:=imsg.mousey
  IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.mousex>=self.x) AND (imsg.mousey>=self.y) AND (imsg.mousex<(self.x+self.xs)) AND (imsg.mousey<(self.y+self.ys)) THEN RETURN TRUE
ENDPROC FALSE
PROC message_action(class,qual,code,win:PTR TO window) OF toolbar
  DEF sel
  IF code=SELECTDOWN
    IF (self.mousex>=self.x) AND (self.mousex<(self.x+(MAXTOOLBAR*self.width))) AND (self.mousey>self.y) AND (self.mousey<(self.y+self.height))
      self.sel:=(self.mousex-self.x)/self.width
      DrawBevelBoxA(self.gh.wnd.rport,self.x+(self.sel*self.width),self.y,self.icon[dm].bmhd.width,self.icon[dm].bmhd.height,[GTBB_RECESSED,TRUE,GT_VISUALINFO,self.vis,NIL])
    ENDIF
  ENDIF
  IF code=SELECTUP
    DrawBevelBoxA(self.gh.wnd.rport,self.x+(self.sel*self.width),self.y,self.icon[dm].bmhd.width,self.icon[dm].bmhd.height,[GT_VISUALINFO,self.vis,NIL])
    sel:=self.sel
    self.sel:=NIL
    SELECT sel
      CASE OPEN
        open()
      CASE SAVE
        saveas()
      CASE PRINT
        print()
      CASE INFORMATION
        openstats()
    ENDSELECT
  ENDIF
ENDPROC
PROC loadfile(filename,m)
  DEF len,rl,fh
  IF (len:=FileLength(filename))<1 THEN RETURN FALSE
  IF (fh:=Open(filename,OLDFILE))=NIL THEN RETURN FALSE
  rl:=Read(fh,m,len)
  Close(fh)
  IF rl<>len THEN RETURN FALSE
ENDPROC TRUE
PROC getprefs() HANDLE
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror,
      iffErrTxt:PTR TO LONG, sp:PTR TO storedproperty,
      cn:PTR TO contextnode
  IF (iffparsebase:=OpenLibrary('iffparse.library', 39))=NIL THEN Raise(ERR_LIB)
  iffhandle:=AllocIFF()
  IF iffhandle=NIL THEN Raise(ERR_IFF)
  iffhandle.stream:=Open('PROGDIR:Portrait.prefs', MODE_OLDFILE)
  IF iffhandle.stream=NIL THEN Raise(ERR_OPEN)
  InitIFFasDOS(iffhandle)
  IF (ifferror:=OpenIFF(iffhandle, IFFF_READ))=NIL
    PropChunk(iffhandle, ID_PREF, ID_PORT)

    WHILE (ifferror=NIL)
      IF ifferror:=ParseIFF(iffhandle, IFFPARSE_STEP)
        IF ifferror=IFFERR_EOC THEN ifferror:=NIL
      ELSE
        IF cn:=CurrentChunk(iffhandle)
          IF (cn.id<>ID_FORM)
            IF sp:=FindProp(iffhandle, ID_PREF, ID_PORT)
              CopyMem(sp.data, prefs, sp.size)
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ENDWHILE
    CloseIFF(iffhandle)
  ENDIF
  IF ifferror<>IFFERR_EOF
    iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
                'stream read error','stream write error','stream seek error',
                'file corrupt', 'IFF syntax error', 'not an IFF file',
                'required call-back hook missing', NIL]
    error(iffErrTxt[-ifferror-1])
  ENDIF
EXCEPT DO
  SELECT exception
  CASE ERR_IFF
    error('Couldn''t allocate IFF handle')
  CASE ERR_LIB
    error('Couldn''t open iffparse.library')
  ENDSELECT
  IF iffhandle
    IF iffhandle.stream THEN Close(iffhandle.stream)
    FreeIFF(iffhandle)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
ENDPROC
PROC writeprefs() HANDLE
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror,
      iffErrTxt:PTR TO LONG
  IF (iffparsebase:=OpenLibrary('iffparse.library', 39))=NIL THEN Raise(ERR_LIB)
  iffhandle:=AllocIFF()
  IF iffhandle=NIL THEN Raise(ERR_IFF)
  iffhandle.stream:=Open('PROGDIR:Portrait.prefs', MODE_NEWFILE)
  IF iffhandle.stream=NIL THEN Raise(ERR_OPEN)
  InitIFFasDOS(iffhandle)
  IF (ifferror:=OpenIFF(iffhandle, IFFF_WRITE))=NIL
    IF (ifferror:=PushChunk(iffhandle, ID_PREF, ID_FORM, IFFSIZE_UNKNOWN))=NIL
      IF (ifferror:=PushChunk(iffhandle, NIL, ID_PORT, IFFSIZE_UNKNOWN))=NIL
        IF WriteChunkBytes(iffhandle, prefs, SIZEOF prefs)<>SIZEOF prefs
          ifferror:=IFFERR_WRITE
        ENDIF
        PopChunk(iffhandle)
      ENDIF
      PopChunk(iffhandle)
    ENDIF
    IF ifferror
      iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
               'stream read error','stream write error','stream seek error',
               'file corrupt', 'IFF syntax error', 'not an IFF file',
               'required call-back hook missing', NIL]
       error(iffErrTxt[-ifferror-1])
    ENDIF
    CloseIFF(iffhandle)
  ENDIF
EXCEPT DO
  SELECT exception
  CASE ERR_OPEN
    error('Preferences error')
  CASE ERR_IFF
    error('Couldn''t allocate IFF handle')
  CASE ERR_LIB
    error('Couldn''t open iffparse.library')
  ENDSELECT
  IF iffhandle
    IF iffhandle.stream THEN Close(iffhandle.stream)
    FreeIFF(iffhandle)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
ENDPROC
PROC openfile()
  IF FileLength(filefilename)>0 THEN loaddt(filefilename)
ENDPROC
PROC loaddt(filename)
  DEF opened=FALSE, locked=FALSE, bmhd=NIL:PTR TO bitmapheader, bitmap=NIL, cr=NIL:PTR TO colorregister, i, dtobject, o, cregs[256]:ARRAY OF colorregister,c, myrport:rastport,x,y
  IF StrLen(filename)=0 THEN RETURN
  setstatus('Loading datatype...')
  InitRastPort(myrport)
  IF datatypesbase=NIL THEN datatypesbase:=OpenLibrary('datatypes.library', 39)
  IF (datatypesbase<>NIL) AND (scr<>NIL)
    dtobject:=NewDTObjectA(filename,
                                [DTA_GROUPID, GID_PICTURE,
                                 PDTA_REMAP, FALSE,
                                 PDTA_FREESOURCEBITMAP, FALSE,
                                 TAG_DONE])
    IF dtobject
      IF DoDTMethodA(dtobject,NIL,NIL,[DTM_PROCLAYOUT,NIL,1])=NIL
        DisposeDTObject(dtobject)
      ELSE
        GetDTAttrsA(dtobject, [PDTA_BITMAPHEADER, {bmhd}, PDTA_BITMAP, {bitmap}, TAG_DONE])
        IF bitmap THEN GetDTAttrsA(dtobject, [PDTA_BITMAP, {bitmap}, PDTA_COLORREGISTERS, {cr}, TAG_DONE])
        myrport.bitmap:=bitmap
        canvas.changesize(bmhd.width,bmhd.height)
        FOR i:=0 TO Min(Shl(1,bmhd.depth),255)
          cregs[i].red:=cr.red
          cregs[i].green:=cr.green
          cregs[i].blue:=cr.blue
          cr:=cr+3
        ENDFOR
        FOR x:=0 TO bmhd.width-1
          FOR y:=0 TO bmhd.height-1
            c:=ReadPixel(myrport,x,y)
            o:=canvas.gettrue(x,y)
            PutChar(o,cregs[c].red)
            PutChar(o+1,cregs[c].green)
            PutChar(o+2,cregs[c].blue)
          ENDFOR
          setprogress((100*x)/bmhd.width)
        ENDFOR
        setprogress(0)
        canvas.minx:=0
        canvas.miny:=0
        canvas.maxx:=canvas.width-1
        canvas.maxy:=canvas.height-1
        canvas.setupdate()
      ENDIF
      DisposeDTObject(dtobject)
    ELSE
      error('Datatypes error')
    ENDIF
  ENDIF
  setstatus('')
ENDPROC
PROC openfilefr(title)
DEF name=0,fr:PTR TO filerequester

IF aslbase:=OpenLibrary('asl.library',36)
  IF fr:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_TITLETEXT,title,ASLFR_INITIALDRAWER,filedir,ASLFR_INITIALFILE,filefile,ASLFR_SCREEN,scr,0])
    IF AslRequest(fr,0)

      -> sorry, a bit of ASM here.  Well ... how ELSE?
      -> this does a strcpy() ...
      MOVE.L  fr,A0
      MOVE.L  8(A0),A0  -> directory pointer from 'filerequester'
      MOVE.L  filefilename,A1
    cp: MOVE.B  (A0)+,(A1)+
      BNE.S cp
         StrCopy(filefile,fr.file)
         StrCopy(filedir,fr.drawer)
      AddPart(filefilename,fr.file,256)
      name:=filefilename
    ENDIF
    FreeAslRequest(fr)
  ENDIF
  CloseLibrary(aslbase)
ENDIF
ENDPROC name
PROC openworkfr(title)
DEF name=0,fr:PTR TO filerequester

IF aslbase:=OpenLibrary('asl.library',36)
  IF fr:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_TITLETEXT,title,ASLFR_INITIALDRAWER,workdir,ASLFR_INITIALFILE,workfile,ASLFR_SCREEN,scr,0])
    IF AslRequest(fr,0)
      -> sorry, a bit of ASM here.  Well ... how ELSE?
      -> this does a strcpy() ...
      MOVE.L  fr,A0
      MOVE.L  8(A0),A0  -> directory pointer from 'filerequester'
      MOVE.L  workfilename,A1
    cp: MOVE.B  (A0)+,(A1)+
      BNE.S cp
         StrCopy(workfile,fr.file)
         StrCopy(workdir,fr.drawer)
      AddPart(workfilename,fr.file,256)
      name:=workfilename
    ENDIF
    FreeAslRequest(fr)
  ENDIF
  CloseLibrary(aslbase)
ENDIF

ENDPROC name
CHAR '$VER: portrait 1.24 (27.07.98)',0
