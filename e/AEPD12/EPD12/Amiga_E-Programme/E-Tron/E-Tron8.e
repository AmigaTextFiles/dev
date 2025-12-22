OPT OSVERSION=37

MODULE 'intuition/intuition'
MODULE 'gadtools'

MODULE 'libraries/gadtools'
MODULE 'intuition/gadgetclass'
MODULE 'intuition/screens'
MODULE 'graphics/text'
MODULE 'exec/lists'
MODULE 'exec/ports'
MODULE 'eropenlib'
MODULE 'utility/tagitem'
MODULE 'tools/ilbm'
MODULE 'tools/ilbmdefs'
MODULE 'graphics/modeid'
MODULE 'graphics/rastport'
MODULE 'graphics/text'
MODULE 'diskfont'
MODULE 'ReqTools'
        
ENUM ER_NONE,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW

DEF xv,yv, xc,yc, xd, yd, xe,ye, plots=0,
    w1=0, w2=0, w3=0, w4=0, lev=0,
    visual=NIL, tmp,
    tattr:PTR TO textattr,
    reelquit=FALSE, loop=FALSE, 
    offy, bm, screen:PTR TO screen,font=NIL
DEF myitext:PTR TO intuitext
DEF mytextattr:PTR TO textattr
DEF myfont:PTR TO textfont
DEF sizex , sizey, dobrd, ribrd, upbrd, lebrd

DEF x,y, x2, y2, x3, y3, x4,y4, l1, l2, l3, l4

DEF spieler= 2
DEF speed  = 15

/*=======================================
 = et Definitions
 =======================================*/
DEF et_window=NIL:PTR TO window
DEF et_glist=NIL
/*
CONST SIZEX=708
CONST SIZEY=280
CONST RBORD  = SIZEX-4
CONST LBORD  = 6
CONST DBORD  = SIZEY-3
CONST UBORD  = 12
*/
CONST DEPTH  = 4

/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_START=0
CONST GA_PLAYER=1
CONST GA_QUIT=2
CONST GA_POWER=3
/*=============================
 = Gadgets labels of et
 =============================*/
DEF start
DEF player
DEF quit
DEF power

PROC p_OpenLibraries() HANDLE /*"p_OpenLibraries()"*/

    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN  Raise(ER_INTUITIONLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL   THEN  Raise(ER_GADTOOLSLIB)
    IF (gfxbase:=OpenLibrary('graphics.library',37))=NIL        THEN  Raise(ER_GRAPHICSLIB)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL   THEN  Raise(ER_REQTOOLSLIB)
    IF (diskfontbase:=OpenLibrary('diskfont.library',36))=NIL   THEN  Raise(ER_DISKFONTLIB)

        mytextattr := ['shannonbold.font',100,0,1]:textattr
        myfont     := OpenDiskFont(mytextattr)

    IF diskfontbase THEN CloseLibrary(diskfontbase)

    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC

PROC p_CloseLibraries()  /*"p_CloseLibraries()"*/
    IF gfxbase       THEN CloseLibrary(gfxbase)
    IF gadtoolsbase  THEN CloseLibrary(gadtoolsbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
    IF reqtoolsbase  THEN CloseLibrary(reqtoolsbase)
ENDPROC

PROC p_SetUpScreen() HANDLE /*"p_SetUpScreen()"*/
DEF  pub_screen:PTR TO screen, screen_drawinfo=NIL:PTR TO drawinfo
  IF pub_screen:=LockPubScreen('Workbench')
    IF screen_drawinfo:=GetScreenDrawInfo(pub_screen)
            sizex:=pub_screen.width
            sizey:=pub_screen.height
            upbrd:=12
            dobrd:=sizey-3
            lebrd:=6
            ribrd:=sizex-4
            IF (screen:=OpenScreenTagList(NIL,
              [SA_WIDTH,      sizex,
               SA_HEIGHT,     sizey,
               SA_DEPTH,      DEPTH,
               SA_OVERSCAN,   OSCAN_TEXT,
               SA_AUTOSCROLL, TRUE,
               SA_PENS,       screen_drawinfo.pens,
               SA_DISPLAYID,  $8000,
               SA_PUBNAME,    'E-Tron',
               SA_PUBTASK,NIL,
               SA_TITLE,      'E-Tron by DvG in 1994',
               NIL]))=NIL THEN  Raise(ER_LOCKSCREEN)
     ENDIF
   ENDIF
    PubScreenStatus(screen,0)                 /* make it available */
    SetDefaultPubScreen('E-Tron')

    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ER_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)+1
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC p_SetDownScreen() /*"p_SetDownScreen()"*/
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN CloseScreen(screen)
ENDPROC
PROC p_InitetWindow() HANDLE /*"p_InitetWindow()"*/
    IF (et_glist:=CreateContext({et_glist}))=NIL THEN Raise(ER_CONTEXT)
    IF (start :=CreateGadgetA(BUTTON_KIND,et_glist,[sizex/2-70,sizey-75,140,15,'Start' ,tattr,GA_START ,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (player:=CreateGadgetA(BUTTON_KIND,start,   [sizex/2-70,sizey-50,140,15,'Player',tattr,GA_PLAYER,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (power :=CreateGadgetA(BUTTON_KIND,player,  [sizex/2-70,sizey-35,140,15,'Speed' ,tattr,GA_POWER ,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    IF (quit  :=CreateGadgetA(BUTTON_KIND,power,   [sizex/2-70,sizey-20,140,15,'Quit'  ,tattr,GA_QUIT  ,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC

PROC p_RenderetWindow() /*"p_RenderetWindow()"*/
    RefreshGList(start,et_window,NIL,-1)
    Gt_RefreshWindow(et_window,NIL)
ENDPROC

PROC p_OpenetWindow() HANDLE /*"p_OpenetWindow()"*/
    IF (et_window:=OpenWindowTagList(NIL,
                      [WA_LEFT,0,
                       WA_TOP,0,
                       WA_WIDTH,sizex,
                       WA_HEIGHT,sizey,
                       WA_IDCMP,$200644,
                       WA_BACKDROP,TRUE,
                       WA_FLAGS,$E,
                       WA_GADGETS,et_glist,
                       WA_TITLE,'E Tron',
                       WA_SCREENTITLE,'E-Tron programmed with Amiga E 3.0a by Daniel van Gerpen',
                       WA_CUSTOMSCREEN,screen, 
                       TAG_DONE]))=NIL THEN Raise(ER_WINDOW)
    p_RenderetWindow()
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC

PROC p_RemetWindow() /*"p_RemetWindow()"*/
    IF et_window THEN CloseWindow(et_window)
    IF et_glist  THEN FreeGadgets(et_glist)
ENDPROC

PROC p_LooketMessage() /*"p_LooketMessage()"*/
   DEF mes:PTR TO intuimessage, odx, ody, o2x, o2y, o3x, o3y, o4x, o4y
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL

       tmp:=joy()

       IF tmp<>0 THEN IF loop=FALSE THEN p_start()

       SELECT tmp
          o4x:=xe; o4y:=ye
          CASE 4; xe:=1; ye:=0;
          CASE 1; xe:=-1;ye:=0;
          CASE 3; xe:=0; ye:=-1;
          CASE 2; xe:=0; ye:=1;
       ENDSELECT

       IF (o4x<>xe) AND (o4y=ye) THEN xe:=-xe;
       IF (o4y<>ye) AND (o4x=xe) THEN ye:=-ye;

   IF mes:=Gt_GetIMsg(et_window.userport)
       type:=mes.class

       SELECT type
           CASE IDCMP_CLOSEWINDOW
              reelquit:=TRUE
           CASE IDCMP_VANILLAKEY
              IF loop=FALSE THEN p_start()
              infos:=mes.code
              odx:=xv; ody:=yv
              o2x:=xc; o2y:=yc
              o3x:=xd; o3y:=yd

              SELECT infos

                CASE "s"; xv:= 1; yv:= 0
                CASE "a"; xv:=-1; yv:= 0
                CASE "w"; xv:= 0; yv:=-1
                CASE "y"; xv:= 0; yv:= 1
                CASE "ä"; xc:= 1; yc:= 0
                CASE "ö"; xc:=-1; yc:= 0
                CASE "ü"; xc:= 0; yc:=-1
                CASE "-"; xc:= 0; yc:= 1
                CASE "6"; xd:= 1; yd:= 0
                CASE "4"; xd:=-1; yd:= 0
                CASE "8"; xd:= 0; yd:=-1
                CASE "2"; xd:= 0; yd:= 1

              ENDSELECT

              IF (odx<>xv) AND (ody=yv) THEN xv:=-xv;
              IF (ody<>yv) AND (odx=xv) THEN yv:=-yv;

              IF (o2x<>xc) AND (o2y=yc) THEN xc:=-xc;
              IF (o2y<>yc) AND (o2x=xc) THEN yc:=-yc;

              IF (o3x<>xd) AND (o3y=yd) THEN xd:=-xd;
              IF (o3y<>yd) AND (o3x=xd) THEN yd:=-yd;

           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                CASE GA_START           
                  p_start()
                CASE GA_PLAYER
                  RtGetLongA({spieler},'How many ? (2-4)',0,0)
                CASE GA_POWER
                  RtGetLongA({speed},'How fast ? (1-100)',0,0)
                CASE GA_QUIT
                  reelquit:=TRUE
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDIF
ENDPROC

PROC joy()
DEF joypos, joyx, joyy, firebutton

        joypos:=Long($dff00a) AND $FFFF
        firebutton:=Char($bfe001)
        joyx:=joypos AND %11
        joyy:=Shr(joypos,8) AND %11
        IF ((joyx AND %10) = %10)         THEN RETURN(4)
        IF ((joyy AND %10) = %10)         THEN RETURN(1)
        IF (joyx = %01) OR (joyx = %10)   THEN RETURN(2)
        IF (joyy = %01) OR (joyy = %10)   THEN RETURN(3)

        IF (firebutton AND %10000000) = 0 THEN RETURN(5)
ENDPROC

PROC p_start()
DEF p, a,b, i

loop:=TRUE

SetPointer( et_window, [0,0,0,0] , 0 , 0, 0, 0 )

Box(lebrd-2,upbrd-1,ribrd-1,dobrd,0)
/*
 FOR i:=1 TO IF lev<20 THEN 160 ELSE 160
  p:=Rnd(120)+1
  a,b:=Mod(p,20)
  Line(110+(a*20),25+(b*10),110+(a*20),34+(b*10),2)
  Line(110+(a*20),25+(b*10),129+(a*20),25+(b*10),2)
  Line(129+(a*20),34+(b*10),129+(a*20),25+(b*10),1)
  Line(129+(a*20),34+(b*10),110+(a*20),34+(b*10),1)
 ENDFOR 
*/
    xv:=1;   yv:=0; x :=lebrd+10;  y :=upbrd+10; 
    xc:=-1;  yc:=0; x2:=ribrd-10;  y2:=dobrd-10; 
    xd:=-1;  yd:=0; x3:=ribrd-10;  y3:=upbrd+10; 
    xe:=1;   ye:=0; x4:=lebrd+10;  y4:=dobrd-10; 

    l4:=IF spieler>0 THEN TRUE ELSE FALSE
    l3:=IF spieler>1 THEN TRUE ELSE FALSE
    l1:=IF spieler>2 THEN TRUE ELSE FALSE
    l2:=IF spieler>3 THEN TRUE ELSE FALSE

    IF quit   THEN RemoveGadget( et_window, quit)
    IF power  THEN RemoveGadget( et_window, power)
    IF player THEN RemoveGadget( et_window, player)
    IF start  THEN RemoveGadget( et_window, start)

    plots:=0
ENDPROC

PROC showimage(filename)

DEF ilbm,bmh:PTR TO bmhd,pi:PTR TO picinfo,i,j

	IF ilbm:=ilbm_New(filename,0)
		ilbm_LoadPicture(ilbm,[ILBML_GETBITMAP,{bm},0])

		-> get a pointer TO the images picture-info, we extract the bitmap header,
		-> and read the picture's size.
		pi:=ilbm_PictureInfo(ilbm)
		bmh:=pi.bmhd;
/*		width:=bmh.w;
		height:=bmh.h;*/
        SetRGB4(screen.viewport,0,0,0,0)
        SetRGB4(screen.viewport,1,60,60,60)
        SetRGB4(screen.viewport,2,40,40,40)
        SetRGB4(screen.viewport,3,70,70,70)
        SetRGB4(screen.viewport,10,0,255,0)
        SetRGB4(screen.viewport,11,255,255,0)
        SetRGB4(screen.viewport,5,40,40,46)
        SetRGB4(screen.viewport,9,255,0,0)

		-> the ilbm-handle is no longer needed, we can free it
		ilbm_Dispose(ilbm)

		-> if a bitmap actually opened, open a window, and blit it in
		IF bm
				-> bit into actual dimensions the OS could give us (the window might not be as big as the picture)

				BltBitMapRastPort(bm,0,10,et_window.rport,
					et_window.borderleft+120,et_window.bordertop+30,
                    422,130,
					$c0);
    			ilbm_FreeBitMap(bm)
		ENDIF
	ENDIF
ENDPROC

PROC winner(player,points)
DEF pstr, testsub

 loop:=FALSE

 INC lev
 myitext := [6,0,RP_JAM1,NIL,30,mytextattr,NIL,0]:intuitext
   IF myfont<>0 THEN SetFont(stdrast,myfont)

 SELECT player
   CASE 1; INC w1; myitext.itext := 'Cyan wins';   myitext.frontpen:=6
   CASE 2; INC w2; myitext.itext := 'Yellow wins'; myitext.frontpen:=11 
   CASE 3; INC w3; myitext.itext := 'Green wins';  myitext.frontpen:=10
   CASE 4; INC w4; myitext.itext := 'White wins';  myitext.frontpen:=1
 ENDSELECT

   myitext.leftedge := (sizex/2)-(IntuiTextLength(myitext)/2)
   PrintIText(stdrast, myitext, 0, 0)
   myitext.frontpen:=3
   myitext.leftedge := myitext.leftedge-3
   PrintIText(stdrast, myitext, 0, 0)
/*
   StringF(pstr,'Plots : \d[4]    P1:\d[3] P2:\d[3] P3:\d[3] P4:\d[3]',points,w1,w2,w3,w4)
   SetWindowTitles(et_window,-1,pstr)
*/
   IF (start :=CreateGadgetA(BUTTON_KIND,et_glist,[sizex/2-70,sizey/2,140,15,   'Start' ,tattr,GA_START ,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
   IF (player:=CreateGadgetA(BUTTON_KIND,start   ,[sizex/2-70,sizey/2+20,140,15,'Player',tattr,GA_PLAYER,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
   IF (power :=CreateGadgetA(BUTTON_KIND,player  ,[sizex/2-70,sizey/2+35,140,15,'Speed' ,tattr,GA_POWER ,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)
   IF (quit  :=CreateGadgetA(BUTTON_KIND,power   ,[sizex/2-70,sizey/2+50,140,15,'Quit'  ,tattr,GA_QUIT  ,16,visual,0]:newgadget,[GA_RELVERIFY,TRUE,GA_DISABLED,FALSE,GT_UNDERSCORE,"_",TAG_DONE,0]))=NIL THEN Raise(ER_GADGET)

   p_RenderetWindow()
   ClearPointer(et_window)

/*   Delay(10)*/
ENDPROC

PROC main() HANDLE /*"main()"*/
    DEF testmain, i, j, k, l

    tattr:=['topaz.font',8,0,0]:textattr

    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_SetUpScreen())<>ER_NONE   THEN Raise(testmain)
    IF (testmain:=p_InitetWindow())<>ER_NONE  THEN Raise(testmain)
    IF (testmain:=p_OpenetWindow())<>ER_NONE  THEN Raise(testmain)

    SetStdRast(et_window.rport)

    showimage('etron.ilbm')

    Execute('smartplay music NOWINDOW NOCONFIG LOOP',NIL,NIL)

    REPEAT
        p_LooketMessage()
        IF loop
        IF l1 
           Plot(x,y,6);     x :=x +xv ;  y :=y+yv
        ENDIF
        IF l2
           Plot(x2,y2,11);  x2:=x2+xc ;  y2:=y2+yc
        ENDIF
        IF l3
           Plot(x3,y3,10);  x3:=x3+xd ;  y3:=y3+yd
        ENDIF
        IF l4
           Plot(x4,y4,1);   x4:=x4+xe ;  y4:=y4+ye
        ENDIF

        INC plots

        IF (ReadPixel(et_window.rport,x ,y ))>0 THEN l1:=FALSE
        IF (ReadPixel(et_window.rport,x2,y2))>0 THEN l2:=FALSE
        IF (ReadPixel(et_window.rport,x3,y3))>0 THEN l3:=FALSE
        IF (ReadPixel(et_window.rport,x4,y4))>0 THEN l4:=FALSE
        IF (l1=FALSE) AND (l2=FALSE) AND (l4=FALSE) THEN winner(3,plots)
        IF (l3=FALSE) AND (l2=FALSE) AND (l4=FALSE) THEN winner(1,plots)
        IF (l1=FALSE) AND (l3=FALSE) AND (l4=FALSE) THEN winner(2,plots)
        IF (l1=FALSE) AND (l2=FALSE) AND (l3=FALSE) THEN winner(4,plots)

        FOR i:=1 TO (100*speed) DO NOP
/*        WaitTOF()*/
        ENDIF
    UNTIL reelquit=TRUE
    Execute('smartplay STOP',NIL,NIL)
    Raise(ER_NONE)
EXCEPT
    p_RemetWindow()
    p_SetDownScreen()
    SetDefaultPubScreen(NIL)    /* workbench is default again */
    p_CloseLibraries()
    IF myfont THEN CloseFont(myfont)

    SELECT exception
        CASE ER_LOCKSCREEN; WriteF('Lock Screen Failed.')
        CASE ER_VISUAL;     WriteF('Error Visual.')
        CASE ER_CONTEXT;    WriteF('Error Context.')
        CASE ER_MENUS;      WriteF('Error Menus.')
        CASE ER_GADGET;     WriteF('Error Gadget.')
        CASE ER_WINDOW;     WriteF('Error Window.')
    ENDSELECT
ENDPROC
