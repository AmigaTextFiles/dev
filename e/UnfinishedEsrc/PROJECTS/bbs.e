->By Ian Chapman
->This is one of my first half decent BBS intros, it includes a nice but simple scroller
->followed by a rotating filled vector cube. LMB and RMB zooms in and out, bother together
->quits. The MOD was not created by me.

OPT OSVERSION=39

MODULE 'intuition/intuition',
       'intuition/screens',
       'tools/filledvector',
       'tools/filledvdefs',
       'tools/scrbuffer',
       'graphics/rastport',
       'protracker',
       'exec/memory'
          
CONST   SWIDTH=640,
        SHEIGHT=256,
        FWIDTH=8,
        FHEIGHT=12

DEF scrv,
    polycon,
    cube:PTR TO vobject,
    rastv:rastport,
    mem,
    scr:PTR TO screen,
    rast,
    count,
    text[1000]:STRING,
    col,inc

PROC main()

col:=20
inc:=20

IF (ptbase:=OpenLibrary('protracker.library',1))<>NIL
    mem:=NewM(31000,MEMF_CHIP)
    CopyMem({file},mem,19275)
    Mt_StartInt(mem)
ENDIF

IF (scr:=OpenS(SWIDTH,SHEIGHT,6,$8000,'Jelly Scroll',NIL))<>NIL


    StrCopy(text,'Welcome to a nice little intro entirely coded in Amiga E by Ian Chapman. To pause this scroller at any time just hold down LMB. The reason for this intro?     To plug my BBS of course :) .   For the best in Amiga, PC, Mac, Acorn, Atari and UNIX Call THE JELLY ZONE (num removed) 24hrs!.                          Greetz to (Names Removed)                                 Well the next part of the intro is a nice rotating vector cube. Use LMB to Zoom in and use RMB to Zoom out. Press both Mouse Buttons to exit. Thats it from me!!!                                                                           Powered By AMIGA                           ')
    rast:=scr.rastport
    count:=0
    SetColour(scr,0,0,0,0)
    SetColour(scr,1,0,0,0)
    SetColour(scr,2,255,255,255)
    Colour(2)

    scroll(FWIDTH,FHEIGHT,1,0,123)

    CloseS(scr)
ELSE
    PrintF('Unable to open main screen!\n')
ENDIF


-> Initialise the empty Rast port for drawing
InitRastPort(rastv)

->Open a buffered screen
scrv:=sb_OpenScreen([SA_DEPTH,4,SA_WIDTH,320,SA_HEIGHT,256,0],0);


polycon:=newPolyContext(sb_GetBitMap(scrv),50)
setPolyFlags(polycon,1,1)


->Set up the cube. First do the point distances followed
->by the joining of the points.


cube:=newVectorObject(0,
                        8,
                        6,
                        [-150,150,-150,
                        150,150,-150,
                        150,-150,-150,
                        -150,-150,-150,
                        -150,150,150,
                        150,150,150,
                        150,-150,150,
                        -150,-150,150]:INT,
                        [0,1,2,1,[4,0,1,1,2,2,3,3,0]:INT,0,
                        6,5,4,2,[4,5,4,4,7,7,6,6,5]:INT,0,
                        1,5,6,3,[4,1,5,5,6,6,2,2,1]:INT,0,
                        4,0,3,4,[4,4,0,0,3,3,7,7,4]:INT,0,
                        4,5,1,5,[4,4,5,5,1,1,0,0,4]:INT,0,
                        3,2,6,6,[4,3,2,2,6,6,7,7,3]:INT,0]:face);
/*


cube:=newVectorObject(0,20,12,
        [-178*3,98*3,20*4,      /* points */
        -34*3,98*3,20*4,
        -34*3,66*3,20*4,
        -146*3,-50*3,20*4,
        -34*3,-50*3,20*4,
        -34*3,-82*3,20*4,
        -178*3,-82*3,20*4,
        -178*3,-50*3,20*4,
        -66*3,66*3,20*4,
        -178*3,66*3,20*4,
        -178*3,98*3,-20*4,      /* lower side */
        -34*3,98*3,-20*4,
        -34*3,66*3,-20*4,
        -146*3,-50*3,-20*4,
        -34*3,-50*3,-20*4,
        -34*3,-82*3,-20*4,
        -178*3,-82*3,-20*4,
        -178*3,-50*3,-20*4,
        -66*3,66*3,-20*4,
        -178*3,66*3,-20*4]:INT,
        /* since no 'depth' sorting is done - ensure innermost surfaces drawn first */
        [3,4,14,1,      /* bottom inside edge */
                [4,3,4,4,14,14,13,13,3]:INT,0,
        8,9,19,2,       /* top inside edge */
                [4,8,9,9,19,19,18,18,8]:INT,0,

        2,3,13,3,       /* sloping inside edge */
                [4,2,3,3,13,13,12,12,2]:INT,0,
        7,8,18,4,       /* sloping inside edge-left */
                [4,7,8,8,18,18,17,17,7]:INT,0,

        2,1,0,5,        /* front face */
                [10,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,0]:INT,0,
        10,11,12,6,     /* back face */
                [10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,10]:INT,0,
        0,1,11,7,       /* top bar of z */
                [4,0,1,1,11,11,10,10,0]:INT,0,
        5,6,16,8,       /* bottom bar of z */
                [4,5,6,6,16,16,15,15,5]:INT,0,
        1,2,12,9,       /* first back end */
                [4,1,2,2,12,12,11,11,1]:INT,0,
        4,5,15,10,      /* next back end */
                [4,4,5,5,15,15,14,14,4]:INT,0,
        6,7,17,11,      /* left lower end */
                [4,6,7,7,17,17,16,16,6]:INT,0,
        9,0,10,12,      /* upper left end */
                [4,9,0,0,10,10,19,19,9]:INT,0]:face);

*/
cube.pz:=9000

WHILE cube.pz>1300
    rastv.bitmap:=sb_NextBuffer(scrv);
    SetRast(rast,0)
    setPolyBitMap(polycon, rastv.bitmap)
    drawVObject(polycon, cube)

    cube.ax:=cube.ax+1
    cube.ay:=cube.ay+2
    cube.az:=cube.az+3
cube.pz:=cube.pz-200
ENDWHILE

WHILE Mouse()<>3  ->Check for both mouse button presses.
    rastv.bitmap:=sb_NextBuffer(scrv);
    SetRast(rastv,0)
    setPolyBitMap(polycon, rastv.bitmap)
    drawVObject(polycon, cube)

    cube.ax:=cube.ax+1
    cube.ay:=cube.ay+2
    cube.az:=cube.az+3
    IF Mouse()=1 THEN cube.pz:=cube.pz-30 ->Zoom in on left button
    IF Mouse()=2 THEN cube.pz:=cube.pz+30 ->Zoom out on right
ENDWHILE

WHILE cube.pz<12000
    rastv.bitmap:=sb_NextBuffer(scrv);
    SetRast(rastv,0)
    setPolyBitMap(polycon, rastv.bitmap)
    drawVObject(polycon, cube)

    cube.ax:=cube.ax+1
    cube.ay:=cube.ay+2
    cube.az:=cube.az+3

cube.pz:=cube.pz+200

ENDWHILE

freeVectorObject(cube)
sb_CloseScreen(scrv)

IF ptbase<>NIL
    Mt_StopInt()
    CloseLibrary(ptbase)
ENDIF

PrintF('Remember the kewlest board around!\nThe Jelly Zone (Number Removed) 24 hrs!\n')

ENDPROC

PROC scroll(fontwidth,fontheight,deltax,deltay,scrollbase)
DEF x,letter,out[2]:STRING

WHILE letter>-1
    letter:=letterproc()
    StringF(out,'\c',letter)
    TextF(SWIDTH-FWIDTH,scrollbase-3,out)
    col:=col+inc
    IF (col=240) OR (col=20) THEN inc:=inc*-1
    SetColour(scr,2,col,0,col)
    WHILE Mouse()=1
    ENDWHILE

    FOR x:=1 TO fontwidth

        ScrollRaster(rast,deltax,deltay,0,scrollbase-fontheight,SWIDTH,scrollbase)
    ENDFOR

ENDWHILE

ENDPROC


PROC letterproc()
DEF theletter,length
length:=EstrLen(text)

IF count=length THEN theletter:=-5 ELSE theletter:=text[count]

count:=count+1

ENDPROC theletter

file:
INCBIN 'cabbage.mod'

