->  TDRender DEMO V1.0 
->  Yves Rosso - 1997
->  Example for TDRender Lib use

->  OpenCyberGfx BigScreen - BackDropWindow
->  For Double Buffering Use In 15/16/24 Bit Mode


-> OPT LARGE,STACK=200000,OSVERSION=39
    ->,RTD,020,881


MODULE 'cybergraphics',
       'libraries/cybergraphics',
       'intuition/intuition',
       'intuition/screens',
       'graphics/gfx',
       'graphics/rastport',
       'graphics/view',
       'dos',
       'dos/dos',
       'exec/memory',
       'fpu/68881_single',
       '*tdrender_lib',
       '*tdrender',
       '*tdrender_lvo'
       
ENUM ERR_NONE, ERR_LIB, ERR_REQ, ERR_SCR, ERR_WIN, ERR_OPFIL, ERR_MEM

RAISE ERR_LIB   IF OpenLibrary()=NIL,
      ERR_REQ   IF BestCModeIDTagList()=-1,
      ERR_SCR   IF OpenScreenTagList()=NIL,
      ERR_WIN   IF OpenWindowTagList()=NIL,
      ERR_OPFIL IF Open()=NIL,
      ERR_MEM   IF NewM()=NIL

CONST DBX=320,DBY=240           -> Dimension of TDRender Lib Buffer
                                -> ( Limited to 320x240x32 in asm source )

CONST SCX=640,SCY=480,SCD=15    -> Dimension of the 1/2 screen that will be opened
                                -> ( 1/2 because here a 640x960 screen is opened
                                ->   for double-buffering frames )

CONST NBSTARS=200               -> nb/2 visible stars (x,y) coords by step 2
    

-> ******************************************************************************
-> ******************************************************************************
PROC main() HANDLE -> ***********************************************************


DEF scr:PTR TO screen,
    wnd:PTR TO window,
    rp:PTR TO rastport,
    wrp,
    vp:PTR TO viewport,
    ri:PTR TO rasinfo,
    depth,width,height,modeid

DEF i,rand,
    dt,adv,
    countpix,vloop,quit=FALSE


DEF filename[40]:STRING,
    file,
    closfil,
    filelen,
    framebuffer:PTR TO LONG,
    imagbuffer:PTR TO LONG,
    imagbufferalp:PTR TO LONG,
    starsbuffer:PTR TO LONG,
    readlength

DEF stnb,xd,yd,xr,yr,angr,
    xcam,ycam,zcam,
    acam,bcam,ccam,
    xobj,yobj,zobj,
    aobj,bobj,cobj,
    xot,yot,zot,
    aot,bot,cot


DEF meteor:PTR TO LONG,
    strshp:PTR TO LONG,
    strspp:PTR TO LONG,
    meteorlist:PTR TO LONG
    
-> ******************************************************************************
     /*===================*/
     /* Open Libs & Inits */
     /*===================*/
   cybergfxbase:=OpenLibrary('cybergraphics.library',40)

   tdrenderbase:=OpenLibrary('tdrender.library',1)
    modeid:=BestCModeIDTagList([CYBRBIDTG_Depth,         SCD,   -> get best match ID
                                CYBRBIDTG_NominalWidth,  SCX,
                                CYBRBIDTG_NominalHeight, SCY])

   depth:=GetCyberIDAttr(CYBRIDATTR_DEPTH,modeid)

-> ******************************************************************************
     /*=============*/
     /* Open screen */
     /*=============*/

    scr:=OpenScreenTagList(NIL,[SA_DISPLAYID,   modeid,
                                SA_WIDTH,          SCX,
                                SA_HEIGHT,       SCY*2, -> double height for DblBuffer
                                SA_DEPTH,          SCD,
                                SA_DRAGGABLE,        0,
                                SA_AUTOSCROLL,       0, -> to prevent screen following
                                SA_OVERSCAN,         1,   -> mouse movements.
                                SA_QUIET,            1,
                                SA_TITLE,            0,
                                SA_SHOWTITLE,        0,
                                NIL,NIL])
     ShowTitle(scr,FALSE)

     width:=scr.width
     height:=scr.height

     WriteF(' Screen : \d x \d x \d   ID : \d \n',width,height,depth,modeid)

-> ******************************************************************************
     /*=============*/
     /* Open window */
     /*=============*/

     wnd:=OpenWindowTagList(NIL,[WA_ACTIVATE,          TRUE,
                                 WA_CUSTOMSCREEN,      scr,
                                 WA_WIDTH,             SCX,
                                 WA_HEIGHT,           SCY*2,
                                 WA_BORDERLESS,        TRUE,
                                 WA_BACKDROP,          TRUE,
                                 WA_TITLE,             NIL,
                                 WA_FLAGS,        WFLG_ACTIVATE,-> OR WFLG_REPORTMOUSE,
                                 WA_IDCMP,        IDCMP_RAWKEY OR IDCMP_MOUSEBUTTONS
                                                               OR IDCMP_MOUSEMOVE,
                                 NIL])
     rp:=scr.rastport
     wrp:=wnd.rport
     vp:=scr.viewport
     ri:=vp.rasinfo

   countpix:=FillPixelArray(wrp,0,0,SCX,SCY*2,$00555555)     -> Clear Frame

-> ******************************************************************************
     /*========================================*/
     /* Allocate Memory for 32 bit xRGB buffer */
     /*========================================*/

     framebuffer:=NewM(DBX*DBY*4+64,MEMF_FAST)  -> DBX x DBY 
                                                -> 32=4x8 bit xRGB Buffer
                                                -> Provided to TDRenderLibrary
                                                   
-> ******************************************************************************
     /*=========================*/
     /* Get Coords for 2D stars */
     /*=========================*/

     starsbuffer:=NewM(NBSTARS*32,MEMF_FAST)    -> get table for stars coords
     
     Rnd(-1)

     FOR i:=0 TO NBSTARS STEP 2                 -> create random 2D coords
         starsbuffer[i  ]:=Rnd(DBX-1)!
         starsbuffer[i+1]:=Rnd(DBY-1)!
     ENDFOR

-> ******************************************************************************
     /*===========================*/
     /* Get Coords for 3D meteors */
     /*===========================*/


     meteorlist:=NewM(220*6*32,MEMF_FAST)       -> Get table for 3D meteors
                                                -> here 220 meteors 
                                                -> x 6 (coords x/y/z and rotate a/b/c)

     FOR i:=0 TO 199*6 STEP 6                
         meteorlist[i  ]:=Rnd(5000)-Rnd(5000)   -> Create random 3D coords in space
         meteorlist[i+1]:=Rnd(5000)-Rnd(5000)
         meteorlist[i+2]:=Rnd(20000)-Rnd(20000)

         meteorlist[i+3]:=-360+Rnd(720)         -> Create random spatial rotate speeds
         meteorlist[i+4]:=-360+Rnd(720)
         meteorlist[i+5]:=0
     ENDFOR




-> ******************************************************************************
-> 3 Objects Examples 
-> - 3 or 4 pts per faces ( 4pts -> 2 x 3pts internally )
-> - coords and colours in 32bit format easy to use in E but certainly slooowww with no 060 !
-> - possible to have unshaded faces that appears luminous in shadows.( Shade or opt. column )
-> - coords of faces must be created in direct order to be visible in the right side
-> ******************************************************************************

-> org: (Nb Pts Per Face) , (Color Of Face In xRGB32) , (List Of Pts For Face)... , (Face Option)
-> Meteor-4 ( COG in middle of object )

->      +-------+---------++--------------++--------------++--------------++--------------+ 
->      | NbPts |  Colour ||  X    Y    Z ||  X    Y    Z ||  X    Y    Z || Shade or Opt |
->      +-------+---------++--------------++--------------++--------------++--------------+ 
meteor:=[   3,   $00BB6644,  110,   0,  40,   60,  80,  50,   30,  10,  90,           1,
            3,   $00BB6644,   60,  80,  50,  -80,  60,  70,   30,  10,  90,           1,
            3,   $00BB6644,  -80,  60,  70,  -60, -60,  60,   30,  10,  90,           1,
            3,   $00BB6644,  -60, -60,  60,   50, -80,  30,   30,  10,  90,           1,
            3,   $00BB6644,   50, -80,  30,  110,   0,  40,   30,  10,  90,           1,
            3,   $00BB6644,   60,  80,  50,  110,   0,  40,   90,  60, -50,           1,
            3,   $00BB6644,  -80,  60,  70,   60,  80,  50,  -20, 100, -70,           1,
            3,   $00BB6644,  -60, -60,  60,  -80,  60,  70,  -90, -20, -60,           1,
            3,   $00BB6644,   50, -80,  30,  -60, -60,  60,  -20,-100, -60,           1,
            3,   $00BB6644,  110,   0,  40,   50, -80,  30,   90, -60, -50,           1,
            3,   $00BB6644,   90,  60, -50,  -20, 100, -70,   60,  80,  50,           1,
            3,   $00BB6644,  -20, 100, -70,  -90, -20, -60,  -80,  60,  70,           1,
            3,   $00BB6644,  -90, -20, -60,  -20,-100, -60,  -60, -60,  60,           1,
            3,   $00BB6644,  -20,-100, -60,   90, -60, -50,   50, -80,  30,           1,
            3,   $00BB6644,   90, -60, -50,   90,  60, -50,  110,   0,  40,           1,
            3,   $00BB6644,  -20, 100, -70,   90,  60, -50,  -20,   0,-110,           1,
            3,   $00BB6644,  -90, -20, -60,  -20, 100, -70,  -20,   0,-110,           1,
            3,   $00BB6644,  -20,-100, -60,  -90, -20, -60,  -20,   0,-110,           1,
            3,   $00BB6644,   90, -60, -50,  -20,   0,-110,   90,  60, -50,           1,
            3,   $00BB6644,   90, -60, -50,  -20,-100, -60,  -20,   0,-110,           1,
            0,           0,    0,   0,   0,    0,   0,   0,    0,   0,   0,           0]
->      +-------+---------++--------------++--------------++--------------++--------------+ 
->      | NbPts |  Colour ||  X    Y    Z ||  X    Y    Z ||  X    Y    Z || Shade or Opt |
->      +-------+---------++--------------++--------------++--------------++--------------+ 

-> ******************************************************************************

-> org: (Nb Pts Per Face) , (Color Of Face In xRGB32) , (List Of Pts For Face)... , (Face Option)
-> StarShip-02 ( COG in middle of object )


->      +-------+---------++--------------++--------------++--------------++--------------+ 
->      | NbPts |  Colour ||  X    Y    Z ||  X    Y    Z ||  X    Y    Z || Shade or Opt |
->      +-------+---------++--------------++--------------++--------------++--------------+ 
strspp:=[   3,   $00EEEEFF,  -60, 130, -20,   50, 130,  10,   60, 130, -20,           0,
            3,   $00EEEEFF,   50, 130,  10,  -60, 130, -20,  -50, 130,  10,           0,
            3,   $00EEEEFF,  -50, 130,  10,  -60, 130, -20,  -70, 110,   0,           0,
            3,   $00EEEEFF,   60, 130, -20,   50, 130,  10,   70, 110,   0,           0,
            3,   $00AACCDD,  -60, 130, -20,   60, 130, -20,   50,  30, -30,           1,
            3,   $00AACCDD,  -60, 130, -20,   50,  30, -30,  -50,  30, -30,           1,
            3,   $00AACCDD,   50,  30, -30,   60, 130, -20,   70, 110,   0,           0,
            3,   $00AACCDD,  -60, 130, -20,  -50,  30, -30,  -70, 110,   0,           0,
            3,   $00555555,  -70, 110,   0,  -50,  30, -30,  -60, -30, -20,           1,
            3,   $00555555,   50,  30, -30,   70, 110,   0,   60, -30, -20,           1,
            3,   $00AACCDD,   60, -30, -20,   70, 110,   0,   60, -20,   0,           1,
            3,   $00AACCDD,  -70, 110,   0,  -60, -30, -20,  -60, -20,   0,           1,
            3,   $00AACCDD,  -70, 110,   0,  -60, -20,   0,  -40,   0,  20,           1,
            3,   $00AACCDD,  -70, 110,   0,  -40,   0,  20,  -50, 130,  10,           0,
            3,   $00AACCDD,   50, 130,  10,  -50, 130,  10,   40,   0,  20,           1,
            3,   $00AACCDD,  -50, 130,  10,  -40,   0,  20,   40,   0,  20,           1,
            3,   $00AACCDD,   50, 130,  10,   40,   0,  20,   70, 110,   0,           0,
            3,   $00AACCDD,   60, -20,   0,   70, 110,   0,   40,   0,  20,           1,
            3,   $00AA0000,   40,   0,  20,  -20, -60,  20,   20, -60,  20,           0,
            3,   $00AA0000,  -20, -60,  20,   40,   0,  20,  -40,   0,  20,           0,
            3,   $00AACCDD,   40,   0,  20,   20, -60,  20,   60, -20,   0,           1,
            3,   $00AACCDD,   60, -20,   0,   20, -60,  20,   40, -90,   0,           1,
            3,   $00AACCDD,  -20, -60,  20,  -40,   0,  20,  -60, -20,   0,           1,
            3,   $00AACCDD,  -20, -60,  20,  -60, -20,   0,  -40, -90,   0,           1,
            3,   $00AACCDD,  -40, -90,   0,  -60, -20,   0,  -60, -30, -20,           1,
            3,   $00AACCDD,  -40, -90,   0,  -60, -30, -20,  -30, -80, -20,           1,
            3,   $00AACCDD,   60, -20,   0,   40, -90,   0,   60, -30, -20,           1,
            3,   $00AACCDD,   60, -30, -20,   40, -90,   0,   30, -80, -20,           1,
            3,   $00223355,  -30, -80, -20,  -60, -30, -20,  -20, -60, -30,           1,
            3,   $00223355,  -20, -60, -30,  -60, -30, -20,  -50,  30, -30,           1,
            3,   $00223355,   60, -30, -20,   30, -80, -20,   20, -60, -30,           1,
            3,   $00223355,   60, -30, -20,   20, -60, -30,   50,  30, -30,           1,
            3,   $00AACCDD,  -20, -60, -30,  -50,  30, -30,   50,  30, -30,           1,
            3,   $00AACCDD,   50,  30, -30,   20, -60, -30,  -20, -60, -30,           1,
            3,   $00AACCDD,   30, -80, -20,   40, -90,   0,    0,-140, -10,           1,
            3,   $00AACCDD,  -40, -90,   0,  -30, -80, -20,    0,-140, -10,           1,
            3,   $00AACCDD,  -40, -90,   0,    0,-140, -10,    0,-130,   0,           0,
            3,   $00AACCDD,    0,-130,   0,    0,-140, -10,   40, -90,   0,           0,
            3,   $00223355,  -30, -80, -20,  -20, -60, -30,    0,-140, -10,           1,
            3,   $00223355,    0,-140, -10,  -20, -60, -30,   20, -60, -30,           1,
            3,   $00223355,   30, -80, -20,    0,-140, -10,   20, -60, -30,           1,
            3,   $00AA0000,   20, -60,  20,  -20, -60,  20,    0,-130,   0,           0,
            3,   $00AACCDD,   40, -90,   0,   20, -60,  20,    0,-130,   0,           1,
            3,   $00AACCDD,  -40, -90,   0,    0,-130,   0,  -20, -60,  20,           1,
            0,           0,    0,   0,   0,    0,   0,   0,    0,   0,   0,           0]
->      +-------+---------++--------------++--------------++--------------++--------------+ 
->      | NbPts |  Colour ||  X    Y    Z ||  X    Y    Z ||  X    Y    Z || Shade or Opt |
->      +-------+---------++--------------++--------------++--------------++--------------+ 

-> ******************************************************************************

-> org: (Nb Pts Per Face) , (Color Of Face In xRGB32) , (List Of Pts For Face)... , (Face Option)
-> StarShip Oomy
->         +-------+---------+--------------+--------------+--------------+--------------+--------------+ 
->         | NbPts |  Colour |  X    Y    Z |  X    Y    Z |  X    Y    Z |  X    Y    Z | Shade or Opt |
->         +-------+---------+--------------+--------------+--------------+--------------+--------------+ 
->   Down
    strshp:=[   4,  $00777777, 310,  20,  80, 310,  20, -80,-180,  20,-120,-180,  20, 120,      1,
->   Up
                4,  $00DDDDFF,  40, -40,  40,-180, -40, 120,-180, -40,-120,  40, -40, -40,      1,
->   Front
                4,  $00555555, 310,  20,  80,  40, -40,  40,  40, -40, -40, 310,  20, -80,      1,
->   Engine Back
                4,  $00FEFEFE,-180, -40, 120,-180,  20, 120,-180,  20,-120,-180, -40,-120,      0,
->   Engine Back Left
                3,  $00DEEEFF,-180, -40,-120,-180,  20,-120,   0,   0,-280,                     1,
->   Engine Back Right
                3,  $00DFEFFF,-180,  20, 120,-180, -40, 120,   0,   0, 280,                     1,
->   Up Right Front
                3,  $000073DD,  40, -40,  40, 310,  20,  80,   0,   0, 280,                     1,
->   Up Right Back
                3,  $00CCCCEE,-180, -40, 120,  40, -40,  40,   0,   0, 280,                     1,
->   Down Right
                3,  $000075DD, 310,  20,  80,-180,  20, 120,   0,   0, 280,                     1,
->   Up Left Front
                3,  $000076DD, 310,  20, -80,  40, -40, -40,   0,   0,-280,                     1,
->   Up Left Back
                3,  $00CCCCEF,  40, -40, -40,-180, -40,-120,   0,   0,-280,                     1,
->   Down Left
                3,  $000078DD,-180,  20,-120, 310,  20, -80,   0,   0,-280,                     1,
->   END
                0,          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,      0]
->         +-------+---------+--------------+--------------+--------------+--------------+--------------+ 
->         | NbPts |  Colour |  X    Y    Z |  X    Y    Z |  X    Y    Z |  X    Y    Z | Shade or Opt |
->         +-------+---------+--------------+--------------+--------------+--------------+--------------+ 

-> ******************************************************************************

   vloop:=1
      
   dt:=3
   adv:=1

    xcam:=0
    ycam:=0
    zcam:=0
    
    acam:=0
    bcam:=0
    ccam:=0
    
-> ******************************************************************************
-> ******************************************************************************
     /*================================*/
     /* BEGIN of Anim and Object Moves */
     /*================================*/

   TdSetLight(0,0,0,-10,-10,5)                  -> Set light vector direction
   
  
 REPEAT
-> ******************************************************************************
-> ******************************************************************************
 
     dt:=dt+adv
     
     
-> ==============================================================================          
->  RENDER FRAME FUNCTIONS
-> ==============================================================================          


    
  TdClearFrmBuf(framebuffer)                    -> Clear frame buffer
->  TdClearFrmBufCol(framebuffer,$00112255)     -> Clear frame buffer to dark blue

  xr:=MouseX(wnd)                               -> Get mouse pos to modify 
  yr:=MouseY(wnd)                               -> 3D environement view direction
  xd:=((SCX/2)-xr)/90
  yd:=(yr-(SCY/2))/40
  angr:=xd*3
  stnb:=(NBSTARS/2)-1

/*------------*/ 
/* Stars Part */
/*------------*/ 

  TdDrawStars(framebuffer,starsbuffer,stnb,0)               -> draw stars in buffer
  TdMovRotStars(starsbuffer,xd*3,yd*3,0,0,0,stnb)           -> rotate stars coordinates

/*----------------------*/ 

->   TdSetLight(-80000,80000,20000,0,0,0) -> 3600-(dt*20))  -> possible to get the light moving

/*----------------------*/ 
/* Camera Part Absolute */
/*----------------------*/ 

    xcam:=0   
    ycam:=0   
    zcam:=0   

    
    acam:=0   
    bcam:=bcam+xd   
    ccam:=ccam-yd

   TdSetCamera(xcam,ycam,zcam,acam,bcam,ccam)               -> Set camera vector direction of view
  
/*----------------------*/ 
/* Object Part Absolute */
/*----------------------*/ 

    xobj:=0
    yobj:=0
    zobj:=(360*10)-(dt*20)

    aobj:=dt*6      
    bobj:=(dt+90)*6+90
    cobj:=0           
    
/*------------------*/ 
/* Object Part Draw */
/*------------------*/ 


FOR i:=0 TO 199*6 STEP 6
    TdDrwObFrmCam(framebuffer,meteor,meteorlist[i],meteorlist[i+1],meteorlist[i+2],meteorlist[i+3]+aobj,meteorlist[i+4]+bobj,0)
    meteorlist[i+2]:=meteorlist[i+2]-Abs(meteorlist[i+3]/2)
    IF meteorlist[i+2]<-20000 THEN meteorlist[i+2]:=20000
ENDFOR

/*-------------*/ 

  TdDrwObFrmCam(framebuffer,strspp,0,0,800,(xr-320)/4,(xr-320)/4+180,(yr-240)/3+90)

/*-------------*/ 

 TdBox(framebuffer,0,0,319,239,$002266AA)


-> ==============================================================================          
-> ======================= FLIP DOUBLE HEIGTH SCREEN ============================
IF ri.ryoffset=DBY

-> Hight Part Of Screen *********************************************************

    countpix:=WritePixelArray(framebuffer,0,0,DBX*4,wrp,(SCX-DBX)/2,(SCY-DBY)/2,DBX,DBY,RECTFMT_ARGB)
    -> blit frame buffer on the upper part of window

    ri.ryoffset:=0      -> modify offset position of screen

ELSE

-> Low Part Of Screen ***********************************************************

    countpix:=WritePixelArray(framebuffer,0,0,DBX*4,wrp,(SCX-DBX)/2,(SCY-DBY)/2+SCY,DBX,DBY,RECTFMT_ARGB)
    -> blit frame buffer on lower part ofwindow

    countpix:=FillPixelArray(wrp,(SCX-DBX)/2,(SCY-DBY)/2+SCY,10,10,$00CC0000)   
    -> Frame Test to see screen flipping
    -> ( little red square )

    ri.ryoffset:=SCY    -> modify offset position of screen

ENDIF


     ScrollVPort(vp)    -> Switch to selected offset position


-> ==============================================================================          
-> ==============================================================================          
    IF dt>359 THEN dt:=1
    IF dt<1   THEN dt:=359
    quit:=mouse(wnd)            -> Quit if you click left mouse button

-> ******************************************************************************
-> ******************************************************************************

 UNTIL quit=TRUE OR CtrlC()

-> ******************************************************************************
     /*=====================*/
     /* BEGIN of Exceptions */
     /*=====================*/

EXCEPT DO
    IF wnd THEN CloseWindow(wnd)
    IF scr THEN CloseScreen(scr)
    IF tdrenderbase THEN CloseLibrary(tdrenderbase)
    IF cybergfxbase THEN CloseLibrary(cybergfxbase)
  
 SELECT exception
    CASE ERR_NONE;   WriteF(' All finished with success')
    CASE ERR_LIB;    WriteF(' Error : open library')
    CASE ERR_REQ;    WriteF(' Error : cant get mode ID from cybergfx')
    CASE ERR_SCR;    WriteF(' Error : open screen')
    CASE ERR_WIN;    WriteF(' Error : open window')
    CASE ERR_OPFIL;  WriteF(' Error : open file')
    CASE ERR_MEM;    WriteF(' Error : can not allocate memory')
 ENDSELECT

ENDPROC  -> END Of Main *********************************************************
-> ******************************************************************************
-> ******************************************************************************

     /*===============*/
     /* BEGIN of Subs */
     /*===============*/

PROC mouse(wnd:PTR TO window)
DEF mes:PTR TO intuimessage,quit=FALSE

  IF  mes:=GetMsg(wnd.userport)
      IF mes.class=IDCMP_MOUSEBUTTONS THEN quit:=TRUE
->      IF mes.class=IDCMP_RAWKEY THEN quit:=TRUE
      ReplyMsg(mes)
  ENDIF

ENDPROC quit

