-> Source code for 'The Rout of Civilisation' written by Ian Chapman
-> Concept & Design: Ian Chapman, Marc Bradshaw
-> Some Gfx: Ian Chapman
-> Some Sfx: Ian Chapman, Jonathan Corns
-> Source Code Revision: 0.0.1b
-> Revision Date 21.8.97


->Important Information
->---------------------
-> 2MB OF CHIP RAM IS (probably) NEEDED. If you experience serious gfx probs, reset and try
-> again.
-> Designed with a gfx card in mind on 640x480 256 col display
-> Works on AGA in PAL HIRES LACED 256 cols - although not very nicely
-> Wont work on an ECS or OCS screen.
-> Some parts can be skipped by pressing either or both mousebuttons.


OPT OSVERSION=39

MODULE  'reqtools',
        'libraries/reqtools',
        'intuition/screens',
        'intuition/intuition',
        'exec/memory',
        'dos/dos',
        'graphics/gfx',
        'graphics/text',
        'gadtools',
        'libraries/gadtools',
        'utility/tagitem',
        'exec/ports',
        'exec/nodes',
        'exec/lists',
        'intuition/gadgetclass',
        'tools/easysound',
        'protracker',
        'diskfont'

OBJECT framepar
bitmapptr
raster
filesize
width
height
depth
srcx
srcy
destx
desty
ENDOBJECT

OBJECT unitvals
energy
movement
attack
defend
ENDOBJECT



ENUM OKAY, NOSCR, NOREQTOOLS, NOMODE, NOGAD, NOPRO, NOFONT, SCRSMALL, PROGEND, PROGQUIT

DEF scr:PTR TO screen,
    visual=NIL,
    class,
    iadd:PTR TO gadget,
    mbitmap,
    mbitmapsize,
    mframe:framepar,
    music,
    unitlist[256]:ARRAY OF unitvals

->First set of gadgets are the language selection
CONST   GA_BUT_ENG=0,
        GA_BUT_GER=1,
        GA_BUT_ITA=2,
        GA_BUT_FRE=3,
        GA_BUT_SWE=4,
        GA_BUT_CAN=5,
        GA_BUT_USA=6,
->Follow set are the main screen gadgets
        GA_START=0,
        GA_OPTIONS=1,
        GA_STORY=2,
        GA_CREDITS=3,
        GA_QUIT=4,
->The follow are used for the display area actually used!
        DISWIDTH=640,
        DISHEIGHT=480,
        DISDEPTH=8,
        BOXSIZE=40


PROC main() HANDLE
DEF req:PTR TO rtscreenmoderequester,
    ret,
    musicsize

IF (diskfontbase:=OpenLibrary('diskfont.library',39))=NIL THEN Raise(NOFONT)
IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(NOGAD)
IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(NOREQTOOLS)
IF (ptbase:=OpenLibrary('protracker.library',1))=NIL THEN Raise(NOPRO)

req:=RtAllocRequestA(RT_SCREENMODEREQ,NIL)
IF (ret:=RtScreenModeRequestA(req,'Select Screenmode',[RT_REQPOS,REQPOS_POINTER,NIL,NIL]))=NIL THEN Raise(NOMODE)

IF req.displaywidth<DISWIDTH THEN Raise(SCRSMALL)
IF req.displayheight<DISHEIGHT THEN Raise(SCRSMALL)

IF (scr:=OpenScreenTagList(0,[SA_DEPTH,req.displaydepth,
                              SA_DISPLAYID,req.displayid,
                              SA_SHOWTITLE,NIL,
                              SA_WIDTH,req.displaywidth,
                              SA_HEIGHT,req.displayheight,
                              0,0]))=NIL THEN Raise(NOSCR)


/**************START OF MAIN SECTION**************/

SetRGB4(scr.viewport,0,$0,$0,$0)
SetRGB4(scr.viewport,1,$F,$0,$0)
SetRGB4(scr.viewport,2,$F,$F,$F)
SetRGB4(scr.viewport,3,$0,$0,$F)

->langpal()
playsnd('lang.raw',15000)


->Calls the language selection routine
langgads()


->Main Screen Pics & Sounds
mbitmap,mbitmapsize:=loadfile('mainpic.raw',MEMF_CHIP)
mainpal()
playsnd('firepass.raw',10000)
maindisplay()
playsnd('thunder.raw',13000)

music,musicsize:=loadfile('cabbage.mod',MEMF_CHIP)
Mt_StartInt(music)

maingads()

FreeMem(mbitmap,mbitmapsize)

diskdisplay()

Mt_StopInt()
FreeMem(music,musicsize)

wilfdisplay()
gamesetup()


Raise(PROGEND)


->Error handler & close down system
EXCEPT DO
    IF exception=PROGEND
        CloseScreen(scr)
        RtFreeRequest(req)
        CloseLibrary(reqtoolsbase)
        CloseLibrary(gadtoolsbase)
        CloseLibrary(ptbase)
        CloseLibrary(diskfontbase)
    ELSEIF exception=PROGQUIT
        FreeMem(mbitmap,mbitmapsize)
        Mt_StopInt()
        FreeMem(music,musicsize)
        CloseScreen(scr)
        RtFreeRequest(req)
        CloseLibrary(reqtoolsbase)
        CloseLibrary(gadtoolsbase)
        CloseLibrary(ptbase)
        CloseLibrary(diskfontbase)
    ELSEIF exception=NOREQTOOLS
        CloseLibrary(gadtoolsbase)
        PrintF('Unable to open reqtools.library V37+\n')
        CloseLibrary(diskfontbase)
    ELSEIF exception=NOGAD
        PrintF('Unable to open gadtools.library V37+\n')
        CloseLibrary(diskfontbase)
    ELSEIF exception=NOSCR
        CloseLibrary(ptbase)
        RtFreeRequest(req)
        CloseLibrary(gadtoolsbase)
        CloseLibrary(reqtoolsbase)
        PrintF('Unable to open screen!\n')
        CloseLibrary(diskfontbase)
    ELSEIF exception=NOMODE
        CloseLibrary(ptbase)
        RtFreeRequest(req)
        CloseLibrary(reqtoolsbase)
        CloseLibrary(gadtoolsbase)
        CloseLibrary(diskfontbase)
        PrintF('No screen mode selected!\n')
    ELSEIF exception=NOPRO
        CloseLibrary(reqtoolsbase)
        CloseLibrary(gadtoolsbase)
        CloseLibrary(diskfontbase)
        PrintF('Unable to open protracker.library V1+\n')
    ELSEIF exception=SCRSMALL
        CloseLibrary(ptbase)
        RtFreeRequest(req)
        CloseLibrary(gadtoolsbase)
        CloseLibrary(reqtoolsbase)
        CloseLibrary(diskfontbase)
        PrintF('Screen Size too small! Minimum Size = 640x480!\n')
    ELSEIF exception=NIL
        CloseLibrary(diskfontbase)
        PrintF('Unable to open diskfont.library V39+\n')
    ENDIF

ENDPROC



/*Procedure to display a raw bitmap*/

PROC showbitmap(inmap:PTR TO framepar)
DEF mainbit:bitmap,
    planesize

planesize:=Div(inmap.filesize,inmap.depth)
InitBitMap(mainbit,inmap.depth,inmap.width,inmap.height)

mainbit.planes[0]:=inmap.bitmapptr
mainbit.planes[1]:=inmap.bitmapptr+planesize
mainbit.planes[2]:=inmap.bitmapptr+Mul(planesize,2)
mainbit.planes[3]:=inmap.bitmapptr+Mul(planesize,3)
mainbit.planes[4]:=inmap.bitmapptr+Mul(planesize,4)
mainbit.planes[5]:=inmap.bitmapptr+Mul(planesize,5)
mainbit.planes[6]:=inmap.bitmapptr+Mul(planesize,6)
mainbit.planes[7]:=inmap.bitmapptr+Mul(planesize,7)

BltBitMapRastPort(mainbit,inmap.srcx,inmap.srcy,inmap.raster,inmap.destx,inmap.desty,inmap.width,inmap.height,$C0)

ENDPROC




/*Procedure to setup language GUI*/

PROC langgads()
DEF id,
    tattr:PTR TO textattr,
    lwindow:PTR TO window,
    langglist,
    checkquit=NIL,
    but_eng,
    but_ger,
    but_fre,
    but_ita,
    but_can,
    but_usa


    tattr:=['MegaBall.font',8,0,0]:textattr
    IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN PrintF('Unable to get visual information!\n')
    IF (langglist:=CreateContext({langglist}))=NIL THEN PrintF('Unable to allocate g context!\n')
    but_eng:=CreateGadgetA(BUTTON_KIND,langglist,[5,7,105,25,'BRITAIN',tattr,0,16,visual,0]:newgadget,[TAG_DONE])
    but_ger:=CreateGadgetA(BUTTON_KIND,but_eng,[5,40,105,25,'DEUTSCHLAND',tattr,1,16,visual,NIL]:newgadget,[TAG_DONE])
    but_ita:=CreateGadgetA(BUTTON_KIND,but_ger,[5,73,105,25,'ITALIA',tattr,2,16,visual,NIL]:newgadget,[TAG_DONE])
    but_fre:=CreateGadgetA(BUTTON_KIND,but_ita,[5,106,105,25,'FRANCE',tattr,3,16,visual,NIL]:newgadget,[TAG_DONE])
    but_can:=CreateGadgetA(BUTTON_KIND,but_fre,[5,139,105,25,'CANADA',tattr,5,16,visual,NIL]:newgadget,[TAG_DONE])
    but_usa:=CreateGadgetA(BUTTON_KIND,but_can,[5,172,105,25,'USA',tattr,6,16,visual,NIL]:newgadget,[TAG_DONE])

    IF (lwindow:=OpenWindowTagList(NIL,
                                [WA_LEFT,100,
                                WA_TOP,100,
                                WA_WIDTH,124,
                                WA_HEIGHT,227,
                                WA_IDCMP,$26C,
                                WA_FLAGS,$160E,
                                WA_GADGETS,langglist,
                                WA_TITLE,'Language',
                                WA_CUSTOMSCREEN,scr,
                                TAG_DONE]))=NIL THEN PrintF('Unable to open window!\n')

    REPEAT
        wait4mess(lwindow)
        SELECT class
            CASE IDCMP_REFRESHWINDOW
            CASE IDCMP_MOUSEBUTTONS
            CASE IDCMP_GADGETDOWN
                class:=IDCMP_GADGETUP
            CASE IDCMP_GADGETUP
                id:=iadd.gadgetid
                SELECT id
                    CASE GA_BUT_ENG
                        playsnd('click.raw',10000)
                        playsnd('thankbri.raw',15000)
                        playsnd('gb.raw',13000)
                        checkquit:=TRUE
                    CASE GA_BUT_GER
                        playsnd('click.raw',10000)
                        playsnd('thankdeu.raw',15000)
                        playsnd('deutschland.raw',13000)
                        checkquit:=TRUE
                    CASE GA_BUT_ITA
                        playsnd('click.raw',10000)
                        playsnd('thankita.raw',15000)
                        playsnd('italia.raw',13000)
                        checkquit:=TRUE
                    CASE GA_BUT_FRE
                        playsnd('click.raw',10000)
                        playsnd('thankfra.raw',15000)
                        playsnd('france.raw',13000)
                        checkquit:=TRUE
                    CASE GA_BUT_CAN
                        playsnd('click.raw',10000)
                        playsnd('thankcan.raw',15000)
                        playsnd('canada.raw',13000)
                        checkquit:=TRUE
                    CASE GA_BUT_USA
                        playsnd('click.raw',10000)
                        playsnd('thankusa.raw',15000)
                        playsnd('usa.raw',13000)
                        checkquit:=TRUE
                ENDSELECT
            CASE IDCMP_CLOSEWINDOW
                checkquit:=TRUE
            ENDSELECT
        UNTIL checkquit=TRUE

IF lwindow THEN CloseWindow(lwindow)
IF langglist THEN FreeGadgets(langglist)
IF visual THEN FreeVisualInfo(visual)

ENDPROC

PROC maindisplay()

IF mbitmap>NIL

mframe:=[mbitmap,
        scr.rastport,
        mbitmapsize,
        DISWIDTH,
        DISHEIGHT,
        DISDEPTH,
        0,
        0,
        0,
        0]:framepar

showbitmap(mframe)
ENDIF


ENDPROC



->Procedure for setting up the main window gadgets
PROC maingads()
DEF id,
    tattr:PTR TO textattr,
    mwindow:PTR TO window,
    mainglist,
    checkquit,
    but_start,
    but_options,
    but_story,
    but_credits,
    but_quit,
    x,y,
    reopen=NIL,
    noclosewin=NIL,
    quitprog=NIL


tattr:=['WebFixed.font',15,0,0]:textattr
IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN PrintF('Unable to get visual information!\n')
IF (mainglist:=CreateContext({mainglist}))=NIL THEN PrintF('Unable to get main g list!\n')
but_start:=CreateGadgetA(BUTTON_KIND,mainglist,[5,5,74,21,'START',tattr,0,16,visual,0]:newgadget,[TAG_DONE])
but_options:=CreateGadgetA(BUTTON_KIND,but_start,[82,5,74,21,'OPTIONS',tattr,1,16,visual,NIL]:newgadget,[TAG_DONE])
but_story:=CreateGadgetA(BUTTON_KIND,but_options,[159,5,74,21,'STORY',tattr,2,16,visual,NIL]:newgadget,[TAG_DONE])
but_credits:=CreateGadgetA(BUTTON_KIND,but_story,[236,5,74,21,'CREDITS',tattr,3,16,visual,NIL]:newgadget,[TAG_DONE])
but_quit:=CreateGadgetA(BUTTON_KIND,but_credits,[313,5,74,21,'QUIT',tattr,4,16,visual,NIL]:newgadget,[TAG_DONE])


IF (mwindow:=OpenWindowTagList(NIL,
                                            [WA_LEFT,120,
                                             WA_TOP,420,
                                             WA_WIDTH,392,
                                             WA_HEIGHT,30,
                                             WA_CLOSEGADGET,NIL,
                                             WA_BACKDROP,TRUE,
                                             WA_BORDERLESS,TRUE,
                                             WA_IDCMP,$37C,
                                             WA_FLAGS,$408,
                                             WA_GADGETS,mainglist,
                                             WA_ACTIVATE,TRUE,
                                             WA_CUSTOMSCREEN,scr,
                                             TAG_DONE]))=NIL THEN PrintF('Unable to open window!\n')


REPEAT
    wait4mess(mwindow)
    SELECT class
        CASE IDCMP_REFRESHWINDOW
        CASE IDCMP_MOUSEBUTTONS
            CASE IDCMP_GADGETDOWN
                class:=IDCMP_GADGETUP
            CASE IDCMP_GADGETUP
                id:=iadd.gadgetid
                SELECT id
                    CASE GA_START
                        y:=480
                        FOR x:=1 TO 120
                            ScrollRaster(scr.rastport,0,4,0,0,DISWIDTH,y)
                            y:=y-4
                        ENDFOR
                        checkquit:=TRUE
                    CASE GA_OPTIONS
                        checkquit:=TRUE
                    CASE GA_STORY
                        CloseWindow(mwindow)
                        storydisplay()
                        checkquit:=TRUE
                        reopen:=TRUE
                        noclosewin:=TRUE
                    CASE GA_CREDITS
                        CloseWindow(mwindow)
                        creditsdisplay()
                        checkquit:=TRUE
                        reopen:=TRUE
                        noclosewin:=TRUE
                    CASE GA_QUIT
                        quitprog:=TRUE
                        checkquit:=TRUE
                ENDSELECT
            CASE IDCMP_CLOSEWINDOW
                checkquit:=TRUE
            ENDSELECT
        UNTIL checkquit=TRUE

IF (noclosewin=NIL) THEN CloseWindow(mwindow)
IF mainglist THEN FreeGadgets(mainglist)
IF visual THEN FreeVisualInfo(visual)

IF quitprog=TRUE THEN Raise(PROGQUIT)

IF (reopen=TRUE)
    maindisplay()
    maingads()
ENDIF

ENDPROC

->Story Display
PROC storydisplay()
DEF sbitmap,
    sbitmapsize,
    sframe:framepar

    Mt_StopInt()
    sbitmap,sbitmapsize:=loadfile('storypic.raw',MEMF_CHIP)

    sframe:=[sbitmap,
            scr.rastport,
            sbitmapsize,
            DISWIDTH,
            DISHEIGHT,
            DISDEPTH,
            0,
            0,
            0,
            0]:framepar

    showbitmap(sframe)
    Execute('c:play16 story.raw FREQ=14000',NIL,NIL)
    Move(scr.rastport,0,0)
    ClearScreen(scr.rastport)
    FreeMem(sbitmap,sbitmapsize)
    Delay(30)
    Mt_StartInt(music)
ENDPROC

PROC creditsdisplay()
DEF font,
    fontatts

fontatts:=['WebFixed.font',15,0,0]
font:=OpenDiskFont(fontatts)
SetFont(scr.rastport,font)
cls()
textcentre(scr.rastport,'GAME CONCEPT & DESIGN',21,100)
textcentre(scr.rastport,'IAN CHAPMAN',11,200)
textcentre(scr.rastport,'MARC BRADSHAW',13,300)
Delay(100)
cls()
textcentre(scr.rastport,'PROGRAM CODING',14,100)
textcentre(scr.rastport,'IAN CHAPMAN',11,200)
Delay(100)
cls()
textcentre(scr.rastport,'GFX',3,100)
textcentre(scr.rastport,'IAN CHAPMAN',11,200)
textcentre(scr.rastport,'JONATHAN CORNS',14,300)
Delay(100)
cls()
textcentre(scr.rastport,'SFX',3,100)
textcentre(scr.rastport,'IAN CHAPMAN',11,200)
textcentre(scr.rastport,'JONATHAN CORNS',14,300)
Delay(100)
cls()
textcentre(scr.rastport,'DEVELOPMENT EQUIPMENT',21,100)
Delay(100)

CloseFont(font)

ENDPROC

->Disk Animation
PROC diskdisplay()
DEF x,
    disk1,
    disk2,
    disk3,
    disksize,
    diskframe:framepar

diskpal()
disk1,disksize:=loadfile('disk.raw',MEMF_CHIP)
disk2,disksize:=loadfile('disk2.raw',MEMF_CHIP)
disk3,disksize:=loadfile('disk3.raw',MEMF_CHIP)

diskframe:=[disk1,
            scr.rastport,
            disksize,
            166,
            156,
            DISDEPTH,
            0,
            0,
            230,
            162]:framepar

REPEAT
Delay(50)
diskframe.bitmapptr:=disk1
showbitmap(diskframe)
Delay(2)
diskframe.bitmapptr:=disk2
showbitmap(diskframe)
Delay(2)
diskframe.bitmapptr:=disk3
showbitmap(diskframe)
Delay(2)
diskframe.bitmapptr:=disk2
showbitmap(diskframe)
Delay(2)
diskframe.bitmapptr:=disk1
showbitmap(diskframe)
UNTIL Mouse()>1

FOR x:=1 TO 80
ScrollRaster(scr.rastport,0,1,230,162,396,240)
ScrollRaster(scr.rastport,0,-1,230,240,396,318)
ENDFOR

FreeMem(disk1,disksize)
FreeMem(disk2,disksize)
FreeMem(disk3,disksize)
ENDPROC



->Wilf Animation
PROC wilfdisplay()
DEF  wilf1,
     wilf2,
     wilf3,
     wilf4,
     wilf5,
     wilfsize,
     wframe:framepar


->wbitmap,wbitmapsize:=loadfile('wilf.raw',MEMF_CHIP)

wilf1,wilfsize:=loadfile('wilfnorm.raw',MEMF_CHIP)
wilf2,wilfsize:=loadfile('wilfleft.raw',MEMF_CHIP)
wilf3,wilfsize:=loadfile('wilfright.raw',MEMF_CHIP)
wilf4,wilfsize:=loadfile('wilfup.raw',MEMF_CHIP)
wilf5,wilfsize:=loadfile('wilfdown.raw',MEMF_CHIP)

wframe:=[wilf1,
        scr.rastport,
        wilfsize,
        97,
        154,
        DISDEPTH,
        0,
        0,
        230,
        162]:framepar


showbitmap(wframe)
playsnd('inhelp.raw',15000)

REPEAT

wframe.bitmapptr:=wilf2
showbitmap(wframe)
Delay(25)

wframe.bitmapptr:=wilf1
showbitmap(wframe)
Delay(33)

wframe.bitmapptr:=wilf3
showbitmap(wframe)
Delay(28)

wframe.bitmapptr:=wilf1
showbitmap(wframe)
Delay(29)

wframe.bitmapptr:=wilf4
showbitmap(wframe)
Delay(25)

wframe.bitmapptr:=wilf1
showbitmap(wframe)
Delay(45)

wframe.bitmapptr:=wilf5
showbitmap(wframe)
Delay(5)

wframe.bitmapptr:=wilf1
showbitmap(wframe)
Delay(15)

wframe.bitmapptr:=wilf2
showbitmap(wframe)
Delay(35)

wframe.bitmapptr:=wilf1
showbitmap(wframe)
Delay(50)

wframe.bitmapptr:=wilf3
showbitmap(wframe)
Delay(70)

wframe.bitmapptr:=wilf1
showbitmap(wframe)
Delay(80)

UNTIL Mouse()>1

FreeMem(wilf1,wilfsize)
FreeMem(wilf2,wilfsize)
FreeMem(wilf3,wilfsize)
FreeMem(wilf4,wilfsize)
FreeMem(wilf5,wilfsize)

ENDPROC


PROC gamesetup()
DEF gamewindow:PTR TO window,
    controlwindow:PTR TO window,
    twen,
    twenty:framepar,
    twentysize,
    placex,
    placey,
    click:esound,
    totalunits=NIL,
    x

loadraw('click.raw',click)

cls()
mainpal()

twen,twentysize:=loadfile('20.raw',MEMF_CHIP)


IF (gamewindow:=OpenWindowTagList(NIL,
                                        [WA_LEFT,NIL,
                                        WA_TOP,NIL,
                                        WA_WIDTH,DISWIDTH-200,
                                        WA_HEIGHT,DISHEIGHT,
                                        WA_CLOSEGADGET,NIL,
                                        WA_BACKDROP,TRUE,
                                        WA_BORDERLESS,TRUE,
                                        WA_IDCMP,$37C,
                                        WA_FLAGS,$408,
                                        WA_GADGETS,NIL,
                                        WA_ACTIVATE,TRUE,
                                        WA_CUSTOMSCREEN,scr,
                                        TAG_DONE]))=NIL THEN PrintF('Unable to open game window!\n')
twenty:=[twen,
        gamewindow.rport,
        twentysize,
        BOXSIZE,
        BOXSIZE,
        DISDEPTH,
        0,
        0,
        0,
        0]:framepar


REPEAT


IF gamewindow.mousex>430
    IF gamewindow.mousex<441 THEN ScrollRaster(gamewindow.rport,BOXSIZE,0,0,0,DISWIDTH,DISHEIGHT)
ELSEIF gamewindow.mousex<10
    ScrollRaster(gamewindow.rport,-BOXSIZE,0,0,0,DISWIDTH,DISHEIGHT)
ELSEIF gamewindow.mousey<10
    ScrollRaster(gamewindow.rport,0,-BOXSIZE,0,0,DISWIDTH,DISHEIGHT)
ELSEIF gamewindow.mousey>470
    ScrollRaster(gamewindow.rport,0,BOXSIZE,0,0,DISWIDTH,DISHEIGHT)
ENDIF


IF Mouse()=1
    unitlist[totalunits].energy:=Rnd(200)
    totalunits:=totalunits+1
    playsndnoload(click,22000)
    placex:=Div(gamewindow.mousex,BOXSIZE)
    placey:=Div(gamewindow.mousey,BOXSIZE)
    twenty.destx:=Mul(placex,BOXSIZE)
    twenty.desty:=Mul(placey,BOXSIZE)
    showbitmap(twenty)

ENDIF

UNTIL Mouse()>1

PrintF('Total Number of Units = \d\n',totalunits)
FOR x:=0 TO (totalunits-1)
PrintF('Unit energy values = \d\n',unitlist[x].energy)
ENDFOR

clearsound(click)
CloseWindow(gamewindow)

ENDPROC

/**************ROUTINES*************/

PROC cls()
Move(scr.rastport,0,0)
ClearScreen(scr.rastport)
ENDPROC

PROC textcentre(raster,text,numchars,y)
DEF textlen

    textlen:=TextLength(raster,text,numchars)
    Move(raster,Div((DISWIDTH-textlen),2),y)
    Text(raster,text,numchars)
ENDPROC


->Procedure to wait for a message from chosen window and return its class
PROC wait4mess(win:PTR TO window)
DEF mes:PTR TO intuimessage,
    code

REPEAT
    class:=0
    IF mes:=Gt_GetIMsg(win.userport)
        class:=mes.class
        code:=mes.code
        iadd:=mes.iaddress
        Gt_ReplyIMsg(mes)
    ELSE
        WaitPort(win.userport)
    ENDIF
UNTIL class
ENDPROC


->Procedure to play a sample
PROC playsnd(fname,freq)
DEF snd:esound
loadraw(fname,snd)
playsound(snd,freq,[1,2,4,8]:CHAR)
clearsound(snd)
ENDPROC

PROC playsndnoload(snd:PTR TO esound,freq)
playsound(snd,freq,[1,2,4,8]:CHAR)
ENDPROC



->Procedure to load a file into chosen memory type and return pointer
PROC loadfile(fname,memtype)
DEF fh=NIL, mem=NIL, len=NIL
len:=FileLength(fname)
IF (fh:=Open(fname,MODE_OLDFILE))<>NIL
    IF (mem:=AllocMem(len,memtype))<>NIL
        Read(fh,mem,len)
    ENDIF
    Close(fh)
ELSE
    mem:=0
    PrintF('Unable to open file \s!\n',fname)
ENDIF

ENDPROC mem,len


->Palette for main picture display
PROC mainpal()
LoadRGB32(scr.viewport,
            [$01000000,$18000000,$20000000,$10000000,$59000000,$59000000,$59000000,$79000000,
            $8A000000,$BE000000,$82000000,$96000000,$C6000000,$96000000,$96000000,$96000000,
            $71000000,$82000000,$B2000000,$82000000,$82000000,$82000000,$FF000000,$FF000000,
            $FF000000,$C6000000,$DF000000,$F7000000,$96000000,$A6000000,$CE000000,$8A000000,
            $9E000000,$C6000000,$9E000000,$A6000000,$CE000000,$A6000000,$AE000000,$D6000000,
            $69000000,$79000000,$B2000000,$8A000000,$9E000000,$CE000000,$9E000000,$AE000000,
            $D6000000,$71000000,$82000000,$BE000000,$61000000,$61000000,$61000000,$8A000000,
            $96000000,$C6000000,$82000000,$71000000,$51000000,$69000000,$79000000,$AE000000,
            $BE000000,$D6000000,$F7000000,$79000000,$69000000,$49000000,$79000000,$79000000,
            $79000000,$69000000,$69000000,$69000000,$49000000,$49000000,$49000000,$79000000,
            $8A000000,$C6000000,$96000000,$9E000000,$CE000000,$E7000000,$EF000000,$F7000000,
            $51000000,$51000000,$51000000,$CE000000,$DF000000,$F7000000,$61000000,$71000000,
            $B2000000,$BE000000,$D6000000,$EF000000,$82000000,$8A000000,$BE000000,$8A000000,
            $79000000,$59000000,$AE000000,$AE000000,$AE000000,$71000000,$71000000,$71000000,
            $79000000,$69000000,$51000000,$71000000,$61000000,$49000000,$82000000,$96000000,
            $BE000000,$28000000,$28000000,$28000000,$59000000,$71000000,$B2000000,$D6000000,
            $DF000000,$EF000000,$EF000000,$EF000000,$F7000000,$A6000000,$B2000000,$D6000000,
            $71000000,$8A000000,$BE000000,$E7000000,$E7000000,$E7000000,$61000000,$51000000,
            $39000000,$96000000,$82000000,$61000000,$61000000,$79000000,$B2000000,$DF000000,
            $E7000000,$F7000000,$BE000000,$CE000000,$DF000000,$C6000000,$DF000000,$EF000000,
            $59000000,$51000000,$39000000,$9E000000,$8A000000,$69000000,$AE000000,$96000000,
            $82000000,$AE000000,$AE000000,$96000000,$E7000000,$F7000000,$F7000000,$D6000000,
            $CE000000,$D6000000,$49000000,$49000000,$41000000,$B2000000,$BE000000,$DF000000,
            $61000000,$59000000,$51000000,$69000000,$69000000,$41000000,$41000000,$41000000,
            $31000000,$9E000000,$9E000000,$9E000000,$59000000,$69000000,$A6000000,$A6000000,
            $9E000000,$82000000,$28000000,$31000000,$31000000,$20000000,$20000000,$20000000,
            $C6000000,$CE000000,$EF000000,$49000000,$59000000,$96000000,$8A000000,$71000000,
            $61000000,$F7000000,$F7000000,$FF000000,$DF000000,$DF000000,$DF000000,$9E000000,
            $96000000,$79000000,$41000000,$41000000,$41000000,$AE000000,$A6000000,$8A000000,
            $61000000,$71000000,$AE000000,$BE000000,$B2000000,$BE000000,$96000000,$96000000,
            $BE000000,$82000000,$79000000,$61000000,$AE000000,$B2000000,$D6000000,$C6000000,
            $BE000000,$A6000000,$39000000,$31000000,$39000000,$CE000000,$CE000000,$CE000000,
            $A6000000,$A6000000,$A6000000,$69000000,$82000000,$B2000000,$79000000,$71000000,
            $49000000,$AE000000,$B2000000,$B2000000,$82000000,$71000000,$59000000,$69000000,
            $59000000,$59000000,$71000000,$69000000,$51000000,$96000000,$8A000000,$82000000,
            $96000000,$82000000,$69000000,$96000000,$8A000000,$61000000,$51000000,$69000000,
            $AE000000,$82000000,$9E000000,$C6000000,$71000000,$59000000,$39000000,$79000000,
            $82000000,$BE000000,$59000000,$69000000,$59000000,$61000000,$59000000,$39000000,
            $CE000000,$CE000000,$EF000000,$9E000000,$A6000000,$D6000000,$EF000000,$EF000000,
            $EF000000,$C6000000,$C6000000,$BE000000,$8A000000,$8A000000,$71000000,$71000000,
            $71000000,$51000000,$59000000,$59000000,$82000000,$71000000,$79000000,$B2000000,
            $D6000000,$E7000000,$F7000000,$69000000,$59000000,$39000000,$82000000,$8A000000,
            $C6000000,$41000000,$31000000,$31000000,$BE000000,$DF000000,$F7000000,$C6000000,
            $E7000000,$F7000000,$79000000,$79000000,$9E000000,$F7000000,$FF000000,$FF000000,
            $41000000,$31000000,$20000000,$BE000000,$AE000000,$8A000000,$BE000000,$C6000000,
            $E7000000,$DF000000,$E7000000,$EF000000,$AE000000,$B2000000,$DF000000,$79000000,
            $28000000,$28000000,$31000000,$49000000,$28000000,$79000000,$96000000,$BE000000,
            $8A000000,$82000000,$79000000,$96000000,$A6000000,$D6000000,$A6000000,$8A000000,
            $71000000,$A6000000,$A6000000,$96000000,$A6000000,$79000000,$61000000,$AE000000,
            $BE000000,$DF000000,$A6000000,$9E000000,$8A000000,$69000000,$79000000,$BE000000,
            $59000000,$39000000,$31000000,$79000000,$69000000,$69000000,$59000000,$59000000,
            $41000000,$E7000000,$DF000000,$F7000000,$A6000000,$8A000000,$82000000,$96000000,
            $71000000,$59000000,$A6000000,$AE000000,$CE000000,$BE000000,$C6000000,$D6000000,
            $82000000,$82000000,$69000000,$A6000000,$B2000000,$DF000000,$CE000000,$CE000000,
            $AE000000,$AE000000,$C6000000,$DF000000,$49000000,$51000000,$49000000,$AE000000,
            $B2000000,$8A000000,$8A000000,$59000000,$39000000,$8A000000,$82000000,$61000000,
            $79000000,$79000000,$69000000,$9E000000,$AE000000,$C6000000,$D6000000,$EF000000,
            $F7000000,$CE000000,$CE000000,$DF000000,$F7000000,$F7000000,$F7000000,$69000000,
            $71000000,$AE000000,$DF000000,$DF000000,$BE000000,$82000000,$8A000000,$79000000,
            $A6000000,$A6000000,$B2000000,$49000000,$49000000,$31000000,$8A000000,$96000000,
            $9E000000,$96000000,$82000000,$71000000,$9E000000,$8A000000,$79000000,$D6000000,
            $DF000000,$F7000000,$AE000000,$BE000000,$B2000000,$82000000,$71000000,$39000000,
            $49000000,$49000000,$51000000,$8A000000,$79000000,$49000000,$61000000,$59000000,
            $69000000,$82000000,$79000000,$8A000000,$82000000,$A6000000,$BE000000,$82000000,
            $96000000,$CE000000,$49000000,$51000000,$31000000,$82000000,$69000000,$51000000,
            $71000000,$79000000,$79000000,$9E000000,$A6000000,$9E000000,$A6000000,$96000000,
            $96000000,$E7000000,$EF000000,$FF000000,$31000000,$20000000,$20000000,$8A000000,
            $69000000,$51000000,$AE000000,$AE000000,$B2000000,$69000000,$71000000,$71000000,
            $A6000000,$A6000000,$71000000,$8A000000,$8A000000,$96000000,$71000000,$51000000,
            $41000000,$31000000,$41000000,$31000000,$61000000,$79000000,$AE000000,$B2000000,
            $A6000000,$8A000000,$61000000,$79000000,$BE000000,$61000000,$59000000,$61000000,
            $79000000,$8A000000,$9E000000,$51000000,$49000000,$41000000,$DF000000,$DF000000,
            $EF000000,$D6000000,$DF000000,$E7000000,$96000000,$8A000000,$96000000,$A6000000,
            $AE000000,$AE000000,$28000000,$20000000,$18000000,$41000000,$41000000,$51000000,
            $49000000,$69000000,$59000000,$9E000000,$9E000000,$96000000,$71000000,$B2000000,
            $79000000,$9E000000,$8A000000,$96000000,$9E000000,$9E000000,$82000000,$51000000,
            $49000000,$49000000,$59000000,$71000000,$AE000000,$96000000,$82000000,$51000000,
            $82000000,$79000000,$82000000,$69000000,$69000000,$71000000,$59000000,$61000000,
            $59000000,$C6000000,$DF000000,$FF000000,$41000000,$8A000000,$61000000,$71000000,
            $69000000,$71000000,$96000000,$A6000000,$B2000000,$20000000,$20000000,$28000000,
            $71000000,$71000000,$79000000,$20000000,$28000000,$20000000,$EF000000,$EF000000,
            $FF000000,$28000000,$28000000,$31000000,$EF000000,$EF000000,$E7000000,$49000000,
            $59000000,$51000000,$41000000,$51000000,$51000000,$28000000,$20000000,$28000000,
            $BE000000,$CE000000,$EF000000,$8A000000,$82000000,$59000000,$71000000,$8A000000,
            $9E000000,$79000000,$82000000,$79000000,$B2000000,$AE000000,$AE000000,$8A000000,
            $8A000000,$8A000000,$C6000000,$D6000000,$E7000000,$E7000000,$DF000000,$E7000000,
            $8A000000,$96000000,$CE000000,$71000000,$61000000,$51000000,$AE000000,$AE000000,
            $CE000000,$96000000,$9E000000,$96000000,$A6000000,$AE000000,$DF000000,$71000000,
            $59000000,$49000000,$59000000,$51000000,$28000000,$79000000,$69000000,$59000000,
            $F7000000,$EF000000,$F7000000,$A6000000,$A6000000,$8A000000,$41000000,$49000000,
            $49000000,$79000000,$69000000,$39000000,$EF000000,$E7000000,$E7000000,$B2000000,
            $B2000000,$D6000000,$CE000000,$DF000000,$FF000000,$71000000,$82000000,$C6000000,
            $9E000000,$BE000000,$9E000000,$8A000000,$9E000000,$D6000000,$96000000,$9E000000,
            $D6000000,$9E000000,$AE000000,$DF000000,$82000000,$9E000000,$BE000000,$18000000,
            $20000000,$20000000,$FF000000,$F7000000,$F7000000,$18000000,$18000000,$18000000,
            $51000000,$71000000,$AE000000,$61000000,$71000000,$BE000000,$96000000,$96000000,
            $CE000000,$00000000]:LONG)

ENDPROC


->Palette for disk animation
PROC diskpal()
LoadRGB32(scr.viewport,
            [$01000000,$00000000,$00000000,$00000000,$A2000000,$A2000000,$A2000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FB000000,$00000000,$82000000,$FF000000,$00000000,
            $00000000,$FF000000,$00000000,$00000000,$FF000000,$7D000000,$00000000,$FF000000,
            $FF000000,$00000000,$82000000,$FF000000,$00000000,$00000000,$FF000000,$79000000,
            $00000000,$FF000000,$CE000000,$00000000,$FF000000,$FF000000,$00000000,$D6000000,
            $FF000000,$00000000,$82000000,$FF000000,$00000000,$00000000,$FF000000,$7D000000,
            $00000000,$00000000,$00000000,$FF000000,$04000000,$08000000,$FF000000,$0C000000,
            $10000000,$FF000000,$10000000,$14000000,$FF000000,$18000000,$1C000000,$FF000000,
            $1C000000,$20000000,$FF000000,$20000000,$24000000,$FF000000,$28000000,$2D000000,
            $FF000000,$2D000000,$31000000,$FF000000,$31000000,$35000000,$FF000000,$39000000,
            $3D000000,$FF000000,$3D000000,$41000000,$FF000000,$41000000,$45000000,$FF000000,
            $49000000,$4D000000,$FF000000,$4D000000,$51000000,$FF000000,$51000000,$55000000,
            $FF000000,$59000000,$59000000,$FF000000,$5D000000,$61000000,$FF000000,$61000000,
            $65000000,$FF000000,$69000000,$69000000,$FF000000,$6D000000,$71000000,$FF000000,
            $71000000,$75000000,$FF000000,$79000000,$79000000,$FF000000,$7D000000,$82000000,
            $FF000000,$82000000,$86000000,$FF000000,$8A000000,$8A000000,$FF000000,$8E000000,
            $8E000000,$FF000000,$92000000,$96000000,$FF000000,$9A000000,$9A000000,$FF000000,
            $9E000000,$9E000000,$FF000000,$A2000000,$A6000000,$FF000000,$AA000000,$AA000000,
            $FF000000,$AE000000,$AE000000,$FF000000,$B2000000,$B6000000,$FF000000,$B6000000,
            $BA000000,$FF000000,$BE000000,$BE000000,$FF000000,$C2000000,$C2000000,$FF000000,
            $CA000000,$CA000000,$FF000000,$CE000000,$CE000000,$FF000000,$D2000000,$D6000000,
            $FF000000,$DB000000,$DB000000,$FF000000,$DF000000,$DF000000,$FF000000,$E3000000,
            $E7000000,$FF000000,$EB000000,$EB000000,$FF000000,$EF000000,$EF000000,$FF000000,
            $F3000000,$F7000000,$FF000000,$FB000000,$FB000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$4D000000,$00000000,$00000000,$59000000,$00000000,$00000000,$71000000,
            $00000000,$00000000,$86000000,$00000000,$00000000,$9E000000,$00000000,$00000000,
            $B6000000,$00000000,$00000000,$CE000000,$00000000,$00000000,$E7000000,$00000000,
            $00000000,$FF000000,$00000000,$00000000,$FF000000,$1C000000,$1C000000,$FF000000,
            $39000000,$39000000,$FF000000,$51000000,$51000000,$FF000000,$6D000000,$6D000000,
            $FF000000,$8A000000,$8A000000,$FF000000,$A2000000,$A2000000,$FF000000,$BE000000,
            $BE000000,$4D000000,$24000000,$00000000,$55000000,$28000000,$00000000,$6D000000,
            $35000000,$00000000,$86000000,$41000000,$00000000,$9E000000,$49000000,$00000000,
            $B6000000,$59000000,$00000000,$CE000000,$65000000,$00000000,$E7000000,$71000000,
            $00000000,$FF000000,$7D000000,$00000000,$FF000000,$8E000000,$1C000000,$FF000000,
            $9A000000,$35000000,$FF000000,$A6000000,$51000000,$FF000000,$B2000000,$6D000000,
            $FF000000,$BE000000,$86000000,$FF000000,$CE000000,$A2000000,$FF000000,$DB000000,
            $BE000000,$4D000000,$49000000,$00000000,$59000000,$51000000,$00000000,$71000000,
            $69000000,$00000000,$86000000,$82000000,$00000000,$9E000000,$96000000,$00000000,
            $B6000000,$AE000000,$00000000,$CE000000,$C6000000,$00000000,$E7000000,$E3000000,
            $00000000,$FF000000,$FF000000,$00000000,$FF000000,$FB000000,$1C000000,$FF000000,
            $F7000000,$39000000,$FF000000,$FB000000,$51000000,$FF000000,$F7000000,$6D000000,
            $FF000000,$F7000000,$86000000,$FF000000,$F7000000,$A2000000,$FF000000,$FB000000,
            $BE000000,$00000000,$4D000000,$00000000,$00000000,$61000000,$00000000,$00000000,
            $79000000,$00000000,$00000000,$8E000000,$00000000,$00000000,$A6000000,$00000000,
            $00000000,$BA000000,$00000000,$00000000,$D2000000,$00000000,$00000000,$E7000000,
            $00000000,$00000000,$FF000000,$00000000,$1C000000,$FF000000,$1C000000,$39000000,
            $FF000000,$39000000,$55000000,$FF000000,$51000000,$71000000,$FF000000,$6D000000,
            $8A000000,$FF000000,$86000000,$A6000000,$FF000000,$A2000000,$BE000000,$FF000000,
            $BE000000,$00000000,$41000000,$41000000,$00000000,$59000000,$59000000,$00000000,
            $71000000,$71000000,$00000000,$86000000,$86000000,$00000000,$9E000000,$9E000000,
            $00000000,$B6000000,$B6000000,$00000000,$CE000000,$CE000000,$00000000,$E7000000,
            $E7000000,$00000000,$FF000000,$FF000000,$59000000,$FF000000,$F7000000,$75000000,
            $FF000000,$FB000000,$8A000000,$FF000000,$FF000000,$9E000000,$FF000000,$FB000000,
            $BA000000,$FF000000,$FB000000,$CA000000,$FF000000,$FF000000,$DB000000,$FF000000,
            $FF000000,$00000000,$20000000,$41000000,$00000000,$2D000000,$59000000,$00000000,
            $39000000,$71000000,$00000000,$45000000,$86000000,$00000000,$51000000,$9E000000,
            $00000000,$5D000000,$B6000000,$00000000,$69000000,$CE000000,$00000000,$75000000,
            $E7000000,$00000000,$82000000,$FF000000,$1C000000,$8E000000,$FF000000,$39000000,
            $9E000000,$FF000000,$51000000,$AA000000,$FF000000,$6D000000,$BA000000,$FF000000,
            $8A000000,$C6000000,$FF000000,$A2000000,$D2000000,$FF000000,$BE000000,$E3000000,
            $FF000000,$00000000,$04000000,$4D000000,$00000000,$04000000,$65000000,$00000000,
            $04000000,$79000000,$00000000,$04000000,$8E000000,$00000000,$04000000,$A6000000,
            $00000000,$00000000,$BA000000,$00000000,$04000000,$D2000000,$00000000,$04000000,
            $E7000000,$00000000,$00000000,$FF000000,$1C000000,$24000000,$FF000000,$39000000,
            $41000000,$FF000000,$51000000,$5D000000,$FF000000,$6D000000,$79000000,$FF000000,
            $8A000000,$92000000,$FF000000,$A2000000,$AA000000,$FF000000,$BE000000,$C6000000,
            $FF000000,$28000000,$00000000,$4D000000,$35000000,$00000000,$65000000,$41000000,
            $00000000,$82000000,$4D000000,$00000000,$9A000000,$59000000,$00000000,$B2000000,
            $65000000,$00000000,$CA000000,$71000000,$00000000,$E7000000,$82000000,$00000000,
            $FF000000,$79000000,$00000000,$FF000000,$8E000000,$1C000000,$FF000000,$96000000,
            $39000000,$FF000000,$A6000000,$51000000,$FF000000,$AE000000,$6D000000,$FF000000,
            $BE000000,$86000000,$FF000000,$CA000000,$A2000000,$FF000000,$DB000000,$BA000000,
            $FF000000,$4D000000,$00000000,$4D000000,$5D000000,$00000000,$61000000,$75000000,
            $00000000,$79000000,$8A000000,$00000000,$8E000000,$9E000000,$00000000,$A6000000,
            $B6000000,$00000000,$BA000000,$CA000000,$00000000,$D2000000,$DF000000,$00000000,
            $E7000000,$F3000000,$00000000,$FF000000,$F3000000,$1C000000,$FF000000,$FB000000,
            $39000000,$FF000000,$FB000000,$51000000,$FF000000,$FB000000,$6D000000,$FF000000,
            $FB000000,$86000000,$FF000000,$FF000000,$A2000000,$FF000000,$FF000000,$BE000000,
            $FF000000,$20000000,$00000000,$00000000,$2D000000,$04000000,$00000000,$3D000000,
            $08000000,$04000000,$49000000,$0C000000,$0C000000,$55000000,$18000000,$10000000,
            $61000000,$20000000,$18000000,$71000000,$2D000000,$24000000,$7D000000,$39000000,
            $2D000000,$86000000,$45000000,$3D000000,$9A000000,$59000000,$4D000000,$AA000000,
            $6D000000,$5D000000,$BA000000,$82000000,$75000000,$CA000000,$9A000000,$8A000000,
            $DB000000,$B2000000,$A2000000,$EF000000,$CA000000,$BE000000,$FF000000,$EB000000,
            $DF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,$FF000000,
            $FF000000,$00000000]:LONG)
ENDPROC


