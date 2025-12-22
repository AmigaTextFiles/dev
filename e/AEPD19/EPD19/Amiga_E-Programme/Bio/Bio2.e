OPT OSVERSION=37, LARGE

MODULE 'dos/dos',
        'intuition/intuition',
        'asl',
        'libraries/asl',
        'utility/tagitem',
        'gadtools',
        'libraries/gadtools',
        'intuition/gadgetclass',
        'exec/nodes',
        'intuition/screens',
        'graphics/text','graphics/displayinfo'

ENUM    ER_NONE,
        ER_ARRAY_OUT_OF_BOUNDS,
        ER_FILE,
        ER_MEM,
        ER_OUT,
        ER_ILLEGAL,
        ER_OPENLIB,
        ER_WB,
        ER_VISUAL,
        ER_CONTEXT,
        ER_GADGET,
        ER_WINDOW,
        ER_MENUS

CONST SOUPSIZE      = 4000,
      REGISTERS     = 4,
      STACKSIZE     = 10,
      MAXATOMS      = 100,
      RADIUS        = 100,
      MAXTZ         = 7,
      MAXMUTATE     = 5,
      MYLEFTEDGE    = 133,
      MYTOPEDGE     = 40,
      MYWIDTH       = 320,
      MYHEIGHT      = 140,
      IFLAGS        = IDCMP_CLOSEWINDOW+IDCMP_GADGETUP,
      WFLAGS        = WFLG_SMART_REFRESH+WFLG_ACTIVATE+WFLG_DRAGBAR+WFLG_DEPTHGADGET+WFLG_CLOSEGADGET,
      BUFSIZE       = GADGETSIZE*3,
      RND_MAX       = 1000

OBJECT cell     /* Structure of cells in the soup                       */
    ownerid,    /* ID # of structure that owns the content of the cell  */
    content     /* Binary representation of the content of the cell     */
ENDOBJECT

OBJECT cpu                /* structure for registers of virtual cpu   */
    ax,                   /* array of registers                       */
    bx,
    cx,
    dx,
    sp,                   /* stack pointer                            */
    st0,                  /* stack                                    */
    st1,
    st2,
    st3,
    st4,
    st5,
    st6,
    st7,
    st8,
    st9,
    ip,                   /* instruction pointer                      */
    fl                    /* flag                                     */
ENDOBJECT

DEF atom[MAXATOMS]      :ARRAY OF cpu,
    soup[SOUPSIZE]      :ARRAY OF cell,
    atomcount,
    largestatom,
    largestsize,
    howmany,
    births,
    deaths,
    mutrate,
    sysclock,
    cellsize[MAXATOMS]      :ARRAY OF LONG,
    atomloc[MAXATOMS]       :ARRAY OF LONG,
    daughterlist[MAXATOMS]  :ARRAY OF LONG,
    reaperq[MAXATOMS]       :ARRAY OF LONG,
    slicerq[MAXATOMS]       :ARRAY OF LONG,
    slicerptr,
    scr       = NIL         :PTR TO screen,
    win       = NIL         :PTR TO window,
    scr_error = NIL         :PTR TO LONG,
    visual    = NIL,
    glist     = NIL,
    hlist     = NIL,
    hwin      = NIL         :PTR TO window,
    class,hclass,
    offx,offy,tattr,menu,flen,mem,index,
    handle                  = NIL,
    frtags    = NIL         :PTR TO LONG,
    button1                 :PTR TO gadget,
    text1                   :PTR TO gadget,
    gad1,
    gad2

PROC infile ()                          /* Load an environment.              */
        DEF  fr = NIL : PTR TO filerequester
        frtags :=  [ASL_HAIL,           'Please choose a text file',
                    ASL_HEIGHT,         MYHEIGHT,
                    ASL_WIDTH,          MYWIDTH,
                    ASL_LEFTEDGE,       MYLEFTEDGE,
                    ASL_TOPEDGE,        MYTOPEDGE,
                    ASL_OKTEXT,         'Accept',
                    ASL_CANCELTEXT,     'Cancel',
                    ASL_PATTERN,        '#?.env',
                    ASL_FILE,           'dummy.env',
                    ASL_DIR,            'df0:',
                    TAG_DONE] : tagitem
        IF aslbase := OpenLibrary('asl.library', 37)
          IF fr := AllocAslRequest (ASL_FILEREQUEST, frtags)
            IF AslRequest (fr, NIL)
                flen   := FileLength (fr.file)
                handle := Open (fr.file, OLDFILE)
                IF (flen < 1) OR (handle = NIL) THEN Raise (ER_FILE)
                mem    := New (flen+4)
                IF mem = NIL THEN Raise (ER_MEM)
                IF Read (handle, mem, flen) <> flen THEN Raise (ER_FILE)
                Close (handle); handle := NIL
                displayprogress ('File loaded.')
            ELSE
                displayprogress ('File load cancelled.')
            ENDIF
            FreeAslRequest (fr)
          ENDIF
        CloseLibrary (aslbase)
        ENDIF
ENDPROC                                 /* infile */

PROC setupscreen ()
  IF (gadtoolsbase := OpenLibrary ('gadtools.library', 37)) = NIL THEN Raise(ER_OPENLIB)
  IF (scr          := LockPubScreen ('Workbench')) = NIL THEN Raise(ER_WB)
  IF (visual       := GetVisualInfoA (scr, NIL))   = NIL THEN Raise(ER_VISUAL)
  offy             := scr.wbortop + Int (scr.rastport+58)-10
  tattr            := ['ibm.font', 8, 0, 0] : textattr
ENDPROC
/*---------------------------------------------------------------------------*/
PROC openscreen()
  DEF g : PTR TO gadget
  IF (g := CreateContext({glist}))=NIL THEN Raise(ER_CONTEXT)
  IF (button1 := g := CreateGadgetA(BUTTON_KIND,g,gad1,
                         [GT_UNDERSCORE,        "_",
                          GA_DISABLED,          FALSE,
                          NIL])) = NIL THEN Raise (ER_GADGET)
  IF (text1 := g := CreateGadgetA(TEXT_KIND,g,gad2,
                         [GTTX_BORDER,          TRUE,
                          NIL])) = NIL THEN Raise (ER_GADGET)
  IF (menu := CreateMenusA([1, 0, 'Project', 0,  $0, 0, 0,
                            2, 0, 'Load'  , 'o', $0, 0, 0,
                            2, 0, 'Save'  , 'w', $0, 0, 0,
                            2, 0, 'Quit'  , 'q', $0, 0, 0,
                            0, 0, 0, 0, 0, 0, 0]:newmenu,NIL))=NIL THEN Raise(ER_MENUS)
  IF LayoutMenusA (menu, visual, NIL) = FALSE THEN Raise(ER_MENUS)
  IF (win := OpenWindowTagList (NIL,
       [WA_LEFT,                15,
        WA_TOP,                 15,
        WA_WIDTH,               offx+520,
        WA_HEIGHT,              offy+150,
        WA_GADGETS,             glist,
        WA_CUSTOMSCREEN,        scr,
        WA_IDCMP,               IFLAGS,
        WA_FLAGS,               WFLAGS,
        WA_TITLE,               'Bio  (c)1994 PsychoNaut Labs.',
        WA_SCREENTITLE,         'Bio',
        NIL])) = NIL THEN Raise (ER_WINDOW)

        IF SetMenuStrip (win, menu) = FALSE THEN Raise (ER_MENUS)
        SetAPen(win.rport,1)

ENDPROC
/*---------------------------------------------------------------------------*/
PROC closewindow()
  IF win   THEN ClearMenuStrip(win)
  IF menu  THEN FreeMenus(menu)
  IF win   THEN CloseW(win)
  IF glist THEN FreeGadgets(glist)
ENDPROC
/*---------------------------------------------------------------------------*/
PROC closeDownScreen()
  IF visual       THEN FreeVisualInfo(visual)
  IF scr          THEN CloseScreen(scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC
/*---------------------------------------------------------------------------*/
PROC displayprogress(t)
  Gt_SetGadgetAttrsA (text1,win,NIL,[GTTX_TEXT,t,NIL])
ENDPROC

PROC initsoup ()        /*  Zero out every cell in the soup */
    DEF x
    debug(1,0)
    births:=0
    deaths:=0
    FOR x:=0 TO SOUPSIZE-1
        soup[x].ownerid:=0
        soup[x].content:=0
    ENDFOR
ENDPROC

PROC initcpu ()
    DEF x,y,t
    debug(2,0)
    FOR x:=0 TO MAXATOMS-1
      atom[x].sp:=0
      atom[x].ip:=0
      atom[x].fl:=0
      atom[x].ax:=0
      atom[x].bx:=0
      atom[x].cx:=0
      atom[x].dx:=0
      atom[x].st0:=0
      atom[x].st1:=0
      atom[x].st2:=0
      atom[x].st3:=0
      atom[x].st4:=0
      atom[x].st5:=0
      atom[x].st6:=0
      atom[x].st7:=0
      atom[x].st8:=0
      atom[x].st9:=0
      daughterlist[x]:=0
      cellsize[x]:=0
      atomloc[x]:=0
      reaperq[x]:=0
      slicerq[x]:=0
    ENDFOR
ENDPROC

PROC initrand ()        /*  Randomly seed the rnd fn generator  */

    DEF ds : datestamp, i
    debug(3,0)
    /*===============================================================*/
    /* This does the same thing as RANDOMIZE TIMER.                  */
        VOID DateStamp (ds)
        FOR i := 0 TO ds.tick DO VOID Rnd (RND_MAX)
    /*===============================================================*/
ENDPROC

PROC initpopsoup ()  /*  Initially populate soup with randomly generated code  */
  DEF x,z,tmpinst
  debug(4,0)
  births:=1
  atomcount:=1
  z:=1                                /*  Find an empty memory location    */
  makeancestor(z)
  atom[1].ip:=z                       /* point atom's cpu to cell location */
  slicerq[0]:=z                       /* put the cell into the slicer      */
  reaperq[0]:=z                       /* ...and put it in the reaper too!  */
ENDPROC

PROC makeancestor(adr)
     soup[adr].ownerid:=1
     soup[adr].content:=0
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=28
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=1
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=31
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=7
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=25
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=29
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=0
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=8
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=6
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=30
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=13
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=0
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=26
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=10
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=5
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=23
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=8
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=9
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=21
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=1
     INC adr
     soup[adr].ownerid:=1
     soup[adr].content:=26
     INC adr
ENDPROC

PROC displaysoup ()
ENDPROC

PROC main () HANDLE
    DEF x,t,c,s,q,r,port,mes:PTR TO intuimessage,iad,i,oldrast,tempctr,ww
    setupscreen ()
/*---------------------------------------------------------------------------*/
    gad1 := [offx+440,offy+15,70,12,'_Quit',tattr,1,0,visual,0]    :newgadget
    gad2 := [offx+15,offy+132,485,15,'',tattr,2,0,visual,0]         : newgadget
    openscreen ()
    oldrast:=SetStdRast(win.rport)
    debug(6,0)
    initrand ()
    initsoup ()
    initcpu ()
    initpopsoup ()
    mutrate:=SOUPSIZE*4
    mutrate:=mutrate/5
    mutrate:=SOUPSIZE-mutrate
    slicerptr:=0
    sysclock:=0
    tempctr:=0
    REPEAT                                /*  Begin IDCMP handling loop.  */
        port  := win.userport
        IF (mes := Gt_GetIMsg (port)) = NIL
            REPEAT                            /*  Begin NO IDCMP msg. loop.   */
                displayprogress('           Running...')
                INC tempctr
                IF tempctr=1000
                    tempctr:=0
                    INC sysclock
                ENDIF
                IF (slicerq[slicerptr]<>0)
                    slicer(slicerptr)               /* Let everyone run a tick      */
                    reorgreaperq()
                ENDIF
                INC slicerptr
                IF slicerptr>=MAXATOMS
                    manageslicerq()
                    slicerptr:=0
                    stats()
                ENDIF
                s:=freemem()                       /*  If the soup is 80% full,    */
                IF s<=mutrate THEN reaper()        /*    invoke the reaper!        */
                c:=Rnd(30000)
                IF c>=29950
                    displayprogress('MUTATING!!!')
                    FOR q:=1 TO MAXMUTATE
                        r:=Rnd(SOUPSIZE)
                        mutate(r)
                    ENDFOR
                ENDIF
            UNTIL (mes := Gt_GetIMsg (port)) <> NIL
        ENDIF
        class := mes.class
        iad   := mes.iaddress
        SELECT class
            CASE IDCMP_GADGETUP
                IF (iad = button1)
                    displayprogress('Exiting program...')
                    Raise(ER_NONE)  /* Quit */
                ENDIF
            CASE IDCMP_CLOSEWINDOW
                Raise(ER_NONE)
        ENDSELECT
        Gt_ReplyIMsg (mes)
    UNTIL (class = IDCMP_CLOSEWINDOW)
    Raise (ER_NONE)                      /*                 End cleanly. */

/*****************************************************************************
 **  Cleanup routines.                                                      **
 *****************************************************************************/
    EXCEPT
        SELECT exception
            CASE ER_ARRAY_OUT_OF_BOUNDS ; displayprogress ('Bounds check failed.')
            CASE ER_NONE                ; displayprogress ('Done.')
            CASE ER_FILE                ; displayprogress ('Could not open file!')
            CASE ER_MEM                 ; displayprogress ('Not enough memory!')
            CASE ER_OUT                 ; displayprogress ('Error writing file.')
            CASE ER_ILLEGAL             ; displayprogress ('Wrong number of characters!')
            CASE ER_OPENLIB             ; displayprogress ('Could not open library.')
            CASE ER_WB                  ; displayprogress ('Error allocating WB.')
            CASE ER_VISUAL              ; displayprogress ('Error allocating visual info.')
            CASE ER_CONTEXT             ; displayprogress ('Error establishing context.')
            CASE ER_GADGET              ; displayprogress ('Error creating gadgets.')
            CASE ER_WINDOW              ; displayprogress ('Error opening window.')
            CASE ER_MENUS               ; displayprogress ('Error creating menus.')
            DEFAULT                     ; displayprogress ('Oof!  What hit me?')
        ENDSELECT
        closewindow ()
        closeDownScreen ()
        CleanUp (RETURN_FAIL)
        displaysoup()
ENDPROC

PROC mutate(me)
    DEF x,y,z,a
    debug(7,me)
    x:=Rnd(5)+1
    y:=1
    FOR z:=1 TO x
        y:=y*2
    ENDFOR
    IF soup[me].content<y
        soup[me].content:=soup[me].content+y
    ELSEIF soup[me].content>y
        soup[me].content:=soup[me].content-y
    ELSEIF soup[me].content=y
        soup[me].content:=0
    ENDIF
ENDPROC

PROC stats()
    DEF f,g
    f:=freemem()
    computesize()
    computeaddress()
    findlargestcell()
    countlargestcell()
    g:=countcellsizes()
    TextF(offx+350,offy+55, '       STATISTICS')
    TextF(offx+350,offy+70, '    Free mem:\d[4]',f)
    TextF(offx+350,offy+80, '  # of sizes:\d[4]',g)
    TextF(offx+350,offy+90, '# of largest:\d[4]',howmany)
    TextF(offx+350,offy+100,'Largest cell:\d[4]',largestatom)
    TextF(offx+350,offy+110,'Largest size:\d[4]',largestsize)
ENDPROC

PROC freemem()
    DEF x,y,z,fm
    debug(8,0)
    fm:=0
    FOR x:=0 TO SOUPSIZE-1
        IF soup[x].ownerid=0 THEN INC fm
    ENDFOR
ENDPROC fm

PROC computesize()
    DEF x,y,z
    debug(9,0)
    howmany:=0
    FOR x:=0 TO MAXATOMS-1
        cellsize[x]:=0
    ENDFOR
    FOR x:=0 TO SOUPSIZE-1
        y:=soup[x].ownerid
        IF y<>0 THEN cellsize[y]:=cellsize[y]+1
    ENDFOR
ENDPROC

PROC countcellsizes()
    DEF x,y,dummy[MAXATOMS]:ARRAY OF LONG,g,flag,dptr,numsizes
    dptr:=0
    flag:=0
    FOR x:=0 TO MAXATOMS-1          /* zero out the dummy array */
        dummy[x]:=0
    ENDFOR
    FOR x:=1 TO MAXATOMS-1
        g:=cellsize[x]              /* get a size to check */
        IF (g<>0)
            flag:=0
            FOR y:=0 TO MAXATOMS-1  /* Have we already accounted for that size? */
                IF (dummy[y]=g) THEN flag:=1
            ENDFOR
            IF (flag=0)             /* If not, add it to dummy */
                dummy[dptr]:=g
                INC dptr
            ENDIF
        ENDIF
    ENDFOR
    numsizes:=0
    FOR x:=0 TO MAXATOMS-1
        IF (dummy[x]<>0) THEN INC numsizes
    ENDFOR
ENDPROC numsizes

PROC countlargestcell()
    DEF x
    howmany:=0
    FOR x:=0 TO MAXATOMS-1
        IF cellsize[x]=largestsize THEN INC howmany
    ENDFOR
ENDPROC

PROC findlargestcell()
    DEF x,z
    z:=0
    FOR x:=0 TO MAXATOMS-1
        IF cellsize[x]>z
            z:=cellsize[x]
            largestatom:=x
            largestsize:=z
        ENDIF
    ENDFOR
ENDPROC

PROC computeaddress()
    DEF x,y
    debug(10,0)
    FOR x:=0 TO MAXATOMS-1
        atomloc[x]:=0
    ENDFOR
    FOR x:=0 TO SOUPSIZE-1
        y:=soup[x].ownerid
        IF (y<>0 AND atomloc[y]=0) THEN atomloc[y]:=x
    ENDFOR
ENDPROC

PROC slicer(p)
    DEF x,y,z,s
    debug(11,0)
    IF (p>=0) AND (p<MAXATOMS)
        x:=slicerq[p]
        y:=atom[x].ip
        IF (y<>0) AND (x<>0) AND (x>0) AND (x<MAXATOMS)
            computesize()
            FOR z:=0 TO 14
                execute(x)
                atom[x].ip:=atom[x].ip+1
                IF atom[x].ip>=SOUPSIZE THEN atom[x].ip:=1
            ENDFOR
        ENDIF
    ENDIF
ENDPROC

PROC manageslicerq()    /*  Compact the slicer queue after cells have been killed */
    DEF dummy[MAXATOMS]:ARRAY OF LONG,x,p
    FOR x:=0 TO MAXATOMS-1
        dummy[x]:=0
    ENDFOR
    p:=0
    FOR x:=0 TO MAXATOMS-1
        IF (slicerq[x]<>0)
            dummy[p]:=slicerq[x]
            INC p
        ENDIF
    ENDFOR
    FOR x:=0 TO MAXATOMS-1
        slicerq[x]:=dummy[x]
    ENDFOR
ENDPROC

PROC manageraeperq()    /*  Compact the slicer queue after cells have been killed */
    DEF dummy[MAXATOMS]:ARRAY OF LONG,x,p
    FOR x:=0 TO MAXATOMS-1
        dummy[x]:=0
    ENDFOR

    p:=0
    FOR x:=0 TO MAXATOMS-1
        IF (reaperq[x]<>0)
            dummy[p]:=reaperq[x]
            INC p
        ENDIF
    ENDFOR
    FOR x:=0 TO MAXATOMS-1
        reaperq[x]:=dummy[x]
    ENDFOR
ENDPROC

PROC reorgreaperq()
    DEF x,a,b,r,s,flag
    REPEAT
        flag:=0
        FOR x:=1 TO MAXATOMS-1
            r:=reaperq[x-1]
            s:=reaperq[x]
            a:=atom[r].fl
            b:=atom[s].fl
            IF (b>a)
                reaperq[x-1]:=s
                reaperq[x]:=r
                flag:=1
            ENDIF
        ENDFOR
    UNTIL (flag=0)
    FOR x:=1 TO MAXATOMS-1
        atom[x].fl:=0
    ENDFOR
ENDPROC

PROC reaper()
    DEF y,z,a,c
    displayprogress('REAPING!!!')
    debug(12,0)
    c:=reaperq[0]
    FOR z:=0 TO SOUPSIZE-1
        IF (soup[z].ownerid=c) THEN soup[z].ownerid:=0
    ENDFOR
    atom[c].ip:=0
    atom[c].fl:=0
    daughterlist[c]:=0
    cellsize[c]:=0
    atomloc[c]:=0
    reaperq[0]:=0
    FOR z:=0 TO MAXATOMS-1
        IF slicerq[z]=c THEN slicerq[z]:=0
    ENDFOR
    DEC atomcount
    INC deaths
    manageraeperq()
ENDPROC

PROC chooseelements()
ENDPROC

PROC checkbonding(i1, i2)
  DEF flag
  debug(14,0)
  flag:=0
  IF i1=17 AND i2=18 THEN flag:=1   /* INC_C and DEC_C cannot bond  */
  IF i1=18 AND i2=17 THEN flag:=1
  IF i2=19 AND (i1=17 OR i1=18 OR i1=8 OR i1=20 OR i1=21) THEN flag:=1 /* Keep ZERO from changing CX unnecessarily */
  IF (i1>21 AND i1<26) AND (i2>21 AND i2<26) THEN flag:=1  /* IP manip's can't bond */
  IF (i1>26 AND i1<30) AND (i2>26 AND i2<30) THEN flag:=1
ENDPROC flag

PROC execute(ce)
    DEF x,y,z
    debug(15,ce)
    x:=atom[ce].ip
    IF (x<>0)
    y:=soup[x].content
    SELECT y
        CASE 0
            nop0(ce)
    CASE 1
      nop1(ce)
    CASE 2
      not0(ce)
    CASE 3
      pshl(ce)
    CASE 4
      pzero(ce)
    CASE 5
      pifz(ce)
    CASE 6
      psub_ab(ce)
    CASE 7
      psub_ac(ce)
    CASE 8
      pinc_a(ce)
    CASE 9
      pinc_b(ce)
    CASE 10
      pdec_c(ce)
    CASE 11
      pinc_c(ce)
    CASE 12
      ppushax(ce)
    CASE 13
      ppushbx(ce)
    CASE 14
      ppushcx(ce)
    CASE 15
      ppushdx(ce)
    CASE 16
      ppopax(ce)
    CASE 17
      ppopbx(ce)
    CASE 18
      ppopcx(ce)
    CASE 19
      ppopdx(ce)
    CASE 20
      pjmp(ce)
    CASE 21
      pjmpb(ce)
    CASE 22
      pcall(ce)
    CASE 23
      pret(ce)
    CASE 24
      pmovcd(ce)
    CASE 25
      pmovab(ce)
    CASE 26
      pmovii(ce)
    CASE 27
      padr(ce)
    CASE 28
      padrb(ce)
    CASE 29
      padrf(ce)
    CASE 30
      pmal(ce)
    CASE 31
      pdivide(ce)
  ENDSELECT
  ENDIF
ENDPROC

PROC nop0(ce)
    debug(16,ce)
ENDPROC

PROC nop1(ce)
    debug(17,ce)
ENDPROC

PROC not0(ce)
  DEF x
  debug(18,ce)
  x:=atom[ce].cx
  IF Odd(x) THEN DEC x ELSE INC x
  IF x<=0 THEN x:=0
  atom[ce].cx:=x
ENDPROC

PROC pshl(ce)
    DEF x,y
    debug(19,ce)
    x:=atom[ce].cx
    y:=x
    y:=y*2
    atom[ce].cx:=y
    IF x=0 THEN atom[ce].cx:=1
    IF y>=SOUPSIZE
      atom[ce].cx:=0
      atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC pzero(ce)
debug(20,ce)
  atom[ce].cx:=0
ENDPROC

PROC pifz(ce)
debug(21,ce)
  IF atom[ce].cx<>0 THEN atom[ce].ip:=atom[ce].ip+1
  IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
ENDPROC

PROC psub_ab(ce)
  DEF x,y,z
  debug(22,ce)
  x:=atom[ce].bx
  y:=atom[ce].ax
  z:=y-x
  IF z<=0 THEN z:=0
  atom[ce].cx:=z
  IF z>=SOUPSIZE
    atom[ce].cx:=0
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
  IF z<=0
    atom[ce].cx:=0
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC psub_ac(ce)
  DEF x,y,z
  debug(23,ce)
  x:=atom[ce].ax
  y:=atom[ce].cx
  z:=x-y
  IF z<=0 THEN z:=0
  atom[ce].ax:=z
ENDPROC

PROC pinc_a(ce)
    debug(24,ce)
    atom[ce].ax:=atom[ce].ax+1
ENDPROC

PROC pinc_b(ce)
    debug(25,ce)
    atom[ce].bx:=atom[ce].bx+1
ENDPROC

PROC pdec_c(ce)
    DEF x
    debug(26,ce)
    x:=atom[ce].cx
    DEC x
    IF x<=0
        atom[ce].cx:=0
        atom[ce].fl:=atom[ce].fl+1
    ELSE
        atom[ce].cx:=x
    ENDIF
ENDPROC


PROC pinc_c(ce)
    DEF x
    debug(27,ce)
    x:=atom[ce].cx
    INC x
    atom[ce].cx:=x
    IF x>=SOUPSIZE
        atom[ce].cx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC storeonstack(ce,value)
    DEF p
    atom[ce].sp:=atom[ce].sp+1
    IF atom[ce].sp>=STACKSIZE
        atom[ce].sp:=0
    ENDIF
    p:=atom[ce].sp
    SELECT p
        CASE 0
            atom[ce].st0:=value
        CASE 1
            atom[ce].st1:=value
        CASE 2
            atom[ce].st2:=value
        CASE 3
            atom[ce].st3:=value
        CASE 4
            atom[ce].st4:=value
        CASE 5
            atom[ce].st5:=value
        CASE 6
            atom[ce].st6:=value
        CASE 7
            atom[ce].st7:=value
        CASE 8
            atom[ce].st8:=value
        CASE 9
            atom[ce].st9:=value
    ENDSELECT
ENDPROC

PROC ppushax(ce)
    DEF x
    debug(28,ce)
    x:=atom[ce].ax
    storeonstack(ce,x)
ENDPROC

PROC ppushbx(ce)
    DEF x
    debug(29,ce)
    x:=atom[ce].bx
    storeonstack(ce,x)
ENDPROC

PROC ppushcx(ce)
    DEF x
    debug(30,ce)
    x:=atom[ce].cx
    storeonstack(ce,x)
ENDPROC

PROC ppushdx(ce)
    DEF x
    debug(31,ce)
    x:=atom[ce].dx
    storeonstack(ce,x)
ENDPROC

PROC getfromstack(ce,pointer)
    DEF value
    value:=0
    SELECT pointer
        CASE 0
            value:=atom[ce].st0
        CASE 1
            value:=atom[ce].st1
        CASE 2
            value:=atom[ce].st2
        CASE 3
            value:=atom[ce].st3
        CASE 4
            value:=atom[ce].st4
        CASE 5
            value:=atom[ce].st5
        CASE 6
            value:=atom[ce].st6
        CASE 7
            value:=atom[ce].st7
        CASE 8
            value:=atom[ce].st8
        CASE 9
            value:=atom[ce].st9
    ENDSELECT
ENDPROC value

PROC ppopax(ce)
    DEF x,p
    debug(32,ce)
    p:=atom[ce].sp
    x:=getfromstack(ce,p)
    atom[ce].ax:=x
    atom[ce].sp:=atom[ce].sp-1
    IF atom[ce].sp<0 THEN atom[ce].sp:=STACKSIZE-1
ENDPROC

PROC ppopbx(ce)
    DEF x,p
    debug(33,ce)
    p:=atom[ce].sp
    x:=getfromstack(ce,p)
    atom[ce].bx:=x
    atom[ce].sp:=atom[ce].sp-1
    IF atom[ce].sp<0 THEN atom[ce].sp:=STACKSIZE-1
ENDPROC

PROC ppopcx(ce)
    DEF x,p,z
    debug(34,ce)
    p:=atom[ce].sp
    x:=getfromstack(ce,p)
    atom[ce].cx:=x
    atom[ce].sp:=atom[ce].sp-1
    IF atom[ce].sp<0 THEN atom[ce].sp:=STACKSIZE-1
    z:=atom[ce].cx
    IF z>=SOUPSIZE
        atom[ce].cx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
    IF z<0
        atom[ce].cx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC ppopdx(ce)
    DEF x,p,z
    debug(35,ce)
    p:=atom[ce].sp
    x:=getfromstack(ce,p)
    atom[ce].dx:=x
    atom[ce].sp:=atom[ce].sp-1
    IF atom[ce].sp<0 THEN atom[ce].sp:=STACKSIZE-1
    z:=atom[ce].dx
    IF z>=SOUPSIZE
        atom[ce].dx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
    IF z<0
        atom[ce].dx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC pret(ce)
    DEF q,p
    debug(36,ce)
    p:=atom[ce].sp
    q:=getfromstack(ce,p)
    atom[ce].ip:=q
    atom[ce].sp:=atom[ce].sp-1
    IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    IF atom[ce].ip<1 THEN atom[ce].ip:=1
    IF atom[ce].sp<0 THEN atom[ce].sp:=9
ENDPROC

PROC pmovcd(ce)
    DEF x
    debug(37,ce)
    x:=atom[ce].cx
    atom[ce].dx:=x
    IF x>=SOUPSIZE
        atom[ce].dx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
    IF x<0
        atom[ce].dx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC pmovab(ce)
    DEF x
    debug(39,ce)
    x:=atom[ce].ax
    atom[ce].bx:=x
    IF x>=SOUPSIZE
        atom[ce].bx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
    IF x<0
        atom[ce].bx:=0
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC pmovii(ce)
    DEF x,y,id
    debug(39,ce)
    x:=atom[ce].bx
    y:=atom[ce].ax
    id:=soup[y].ownerid
    IF (x<>y) AND ((id=ce) OR (id=0)) AND (y<SOUPSIZE) AND (y>0)
        soup[y].content:=soup[x].content
    ELSE
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC pjmp(ce)
    DEF ip,ptr,tz,x,flag,distance
    debug(40,ce)
    ip:=atom[ce].ip
    ptr:=ip+1
    tz:=0

    IF soup[ptr].content<=1  /* IS there a nop next? */
        REPEAT
            INC ptr
            INC tz
        UNTIL soup[ptr].content>1
    IF tz<=MAXTZ
/*****************/
/*  frwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ptr-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                INC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
        IF flag=0
            atom[ce].ip:=ptr-1
            atom[ce].dx:=tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
/*****************/
/*  bkwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ip-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                DEC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
    ENDIF
        IF flag=0
            atom[ce].ip:=ptr+1
            atom[ce].dx:=tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
      atom[ce].fl:=atom[ce].fl+1
      atom[ce].ip:=atom[ce].ip+tz
      IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    ENDIF
    ENDIF
  ELSE
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC pjmpb(ce)
  DEF ip,ptr,tz,x,flag,distance
debug(41,ce)
  ip:=atom[ce].ip
  ptr:=ip+1
  tz:=0

  IF soup[ptr].content<=1  /* IS there a nop next? */
        REPEAT
            INC ptr
            INC tz
        UNTIL soup[ptr].content>1
IF tz<=MAXTZ
/*****************/
/*  bkwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ip-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                DEC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)

        IF flag=0
            atom[ce].ip:=ptr+1
            atom[ce].dx:=tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
      atom[ce].fl:=atom[ce].fl+1
      atom[ce].ip:=atom[ce].ip+tz
      IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    ENDIF
    ENDIF
  ELSE
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC pcall(ce)
  DEF ip,ptr,tz,x,flag,distance
debug(42,ce)
  ip:=atom[ce].ip
  ptr:=ip+1
  tz:=0

  IF soup[ptr].content<=1  /* IS there a nop next? */
        REPEAT
            INC ptr
            INC tz
        UNTIL soup[ptr].content>1
IF tz<=MAXTZ
/*****************/
/*  frwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ptr-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                INC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
        IF flag=0
            atom[ce].ip:=ptr-1
            atom[ce].dx:=tz
            storeonstack(ce,ip+tz+1)
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
/*****************/
/*  bkwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ip-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                DEC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
    ENDIF
        IF flag=0
            atom[ce].ip:=ptr+1
            atom[ce].dx:=tz
            storeonstack(ce,ip+tz+1)
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
      atom[ce].fl:=atom[ce].fl+1
      atom[ce].ip:=atom[ce].ip+tz
      IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    ENDIF
    ENDIF
  ELSE
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC padr(ce)
  DEF ip,ptr,tz,x,flag,distance
debug(43,ce)
  ip:=atom[ce].ip
  ptr:=ip+1
  tz:=0

  IF soup[ptr].content<=1  /* IS there a nop next? */
        REPEAT
            INC ptr
            INC tz
        UNTIL soup[ptr].content>1
IF tz<=MAXTZ
/*****************/
/*  frwd search  */
/*****************/
        distance:=0
        ptr:=ptr-tz-1
        flag:=0
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                INC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
        IF flag=0
            atom[ce].ax:=ptr+tz+1
            atom[ce].cx:=tz
            atom[ce].ip:=ip+tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
/*****************/
/*  bkwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ip-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                DEC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
    ENDIF
        IF flag=0
            atom[ce].ax:=ptr+1
            atom[ce].cx:=tz
            atom[ce].ip:=ip+tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
      atom[ce].fl:=atom[ce].fl+1
      atom[ce].ip:=atom[ce].ip+tz
      IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    ENDIF
    ENDIF
  ELSE
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC padrb(ce)
  DEF ip,ptr,tz,x,flag,distance
debug(44,ce)
  ip:=atom[ce].ip
  ptr:=ip+1
  tz:=0

  IF soup[ptr].content<=1  /* IS there a nop next? */
        REPEAT
            INC ptr
            INC tz
        UNTIL soup[ptr].content>1
        DEC ptr
IF tz<=MAXTZ
/*****************/
/*  bkwd search  */
/*****************/
        distance:=0
        flag:=0
        ptr:=ip-tz-1
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                DEC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
        IF flag=0
            atom[ce].ax:=ptr+1
            atom[ce].cx:=tz
            atom[ce].ip:=ip+tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
      atom[ce].fl:=atom[ce].fl+1
      atom[ce].ip:=atom[ce].ip+tz
      IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    ENDIF
    ENDIF
  ELSE
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC padrf(ce)
  DEF ip,ptr,tz,x,flag,distance
debug(45,ce)
  ip:=atom[ce].ip
  ptr:=ip+1
  tz:=0

  IF soup[ptr].content<=1  /* IS there a nop next? */
        REPEAT
            INC ptr
            INC tz
        UNTIL soup[ptr].content>1
IF tz<=MAXTZ
/*****************/
/*  frwd search  */
/*****************/
        distance:=0
        ptr:=ptr-tz-1
        flag:=0
        REPEAT
            flag:=0
            FOR x:=1 TO tz
                IF soup[ptr+x].content<2
                    IF (soup[ptr+x].content=1) AND (soup[ip+x].content=0)
                        flag:=0
                    ELSEIF (soup[ptr+x].content=0) AND (soup[ip+x].content=1)
                        flag:=0
                    ELSE
                        flag:=1
                    ENDIF
                ELSE
                    flag:=1
                ENDIF
            ENDFOR
            IF flag=1
                INC ptr
                INC distance
            ENDIF
            IF ptr+tz>=SOUPSIZE THEN ptr:=1
        UNTIL (flag=0) OR (distance>RADIUS)
        IF flag=0
            atom[ce].ax:=ptr+tz+1
            atom[ce].cx:=tz
            atom[ce].ip:=ip+tz
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
        ENDIF
    IF flag<>0
      atom[ce].fl:=atom[ce].fl+1
      atom[ce].ip:=atom[ce].ip+tz
      IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
    ENDIF
    ENDIF
  ELSE
    atom[ce].fl:=atom[ce].fl+1
  ENDIF
ENDPROC

PROC pmal(ce)
    DEF x,rsize,loc
    debug(46,ce)
    rsize:=atom[ce].cx
    IF (rsize>0) AND (rsize<=(3*cellsize[ce])) AND (daughterlist[ce]=0)
        REPEAT
            loc:=findfreemem(rsize)
            IF loc=0 THEN reaper()
        UNTIL loc<>0

        FOR x:=loc TO loc+rsize-1
            soup[x].ownerid:=ce
        ENDFOR
        atom[ce].ax:=loc
        atom[ce].fl:=atom[ce].fl-1
        daughterlist[ce]:=loc
    ELSE
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC pdivide(ce)
    DEF x,y,z,f
    displayprogress('Cell division is starting...')
    debug(47,ce)
    x:=daughterlist[ce]
    y:=soup[x].ownerid
    IF (x<>0) AND (y=ce)
        z:=x
        f:=findfreecellnum()
        IF (f<>0)
            REPEAT
                soup[z].ownerid:=f
                INC z
            UNTIL soup[z].ownerid<>ce
            atom[f].ip:=x
            INC atomcount
            INC births
            IF atom[ce].ip>=SOUPSIZE THEN atom[ce].ip:=1
            daughterlist[ce]:=0
            addcelltoqs(f)
            atom[ce].fl:=atom[ce].fl-1
        ENDIF
    ELSE
        atom[ce].fl:=atom[ce].fl+1
    ENDIF
ENDPROC

PROC addcelltoqs(cellnum)
    DEF qptr,flag
    qptr:=0
    REPEAT
        flag:=0
        IF (slicerq[qptr]<>0)
            flag:=1
            INC qptr
        ENDIF
    UNTIL (flag=0)
    slicerq[qptr]:=cellnum
    qptr:=0
    REPEAT
        flag:=0
        IF (reaperq[qptr]<>0)
            flag:=1
            INC qptr
        ENDIF
    UNTIL (flag=0)
    reaperq[qptr]:=cellnum
    reorgreaperq()
ENDPROC


PROC findfreecellnum()
    DEF x,num,y,flag
    flag:=0
    num:=0
    FOR x:=MAXATOMS-1 TO 1 STEP -1
        FOR y:=0 TO MAXATOMS-1
            IF (slicerq[y]=x)
                flag:=1
            ENDIF
        ENDFOR
        IF (flag=0) THEN num:=x
    ENDFOR
ENDPROC num


PROC findfreemem(s)
    DEF x,flag,ctr,lookout
    debug(48,s)
    ctr:=0
    REPEAT
        flag:=0
        lookout:=0
        INC ctr
        FOR x:=ctr TO ctr+s-1
           IF (soup[x].ownerid=0) THEN flag:=0 ELSE flag:=1
           IF (soup[x].ownerid=0) THEN INC lookout
        ENDFOR
    UNTIL ((flag=0) AND (lookout=s)) OR ((ctr+s-1)>=SOUPSIZE)
    IF flag<>0 THEN ctr:=0
ENDPROC ctr

PROC showcell(ce)
    DEF t
        TextF(offx+15,offy+40,'  Cell #\d[4]',ce)
        TextF(offx+15,offy+50,'        IP:\d[4]       SP:\d[4]     FL:\d[4]',atom[ce].ip,atom[ce].sp,atom[ce].fl)
        t:=getfromstack(ce,0)
        TextF(offx+15,offy+60,'        AX:\d[4]       s0:\d[4]',atom[ce].ax,t)
        t:=getfromstack(ce,1)
        TextF(offx+15,offy+70,'        BX:\d[4]       s1:\d[4]',atom[ce].bx,t)
        t:=getfromstack(ce,2)
        TextF(offx+15,offy+80,'        CX:\d[4]       s2:\d[4]',atom[ce].cx,t)
        t:=getfromstack(ce,3)
        TextF(offx+15,offy+90,'        DX:\d[4]       s3:\d[4]',atom[ce].dx,t)
ENDPROC


PROC debug(codenum,ce)
    DEF t
  TextF(offx+15,offy+20,'      Births: \d[4]   Deaths: \d[4]',births,deaths)
  TextF(offx+15,offy+30,'Active atoms: \d[4]     Time: \d[4]',atomcount,sysclock)
  SELECT codenum
/*    CASE 1
      WriteF('DEBUG: InitSoup \n')
    CASE 2
      WriteF('DEBUG:  InitCPU\n')
    CASE 3
      WriteF('DEBUG:  InitRand\n')
    CASE 4
      WriteF('DEBUG:  InitPopSoup\n')
    CASE 5
      WriteF('DEBUG:  DisplaySoup\n')
    CASE 6
      WriteF('DEBUG:  MAIN\n')
    CASE 7
      WriteF('DEBUG:  Mutate\n')
    CASE 8
      WriteF('DEBUG:  FreeMem\n')
    CASE 9
      WriteF('DEBUG:  ComputeSize\n')
    CASE 10
      WriteF('DEBUG:  ComputeAddress\n')
    CASE 11
      WriteF('DEBUG:  Slicer\n')
    CASE 12
      WriteF('DEBUG:  Reaper\n')
    CASE 13
      WriteF('DEBUG:  ChooseElements\n')
    CASE 14
      WriteF('DEBUG:  CheckBonding\n')
    CASE 15
      WriteF('DEBUG:  Execute\n')                   */
    CASE 16
      TextF(offx+35,offy+105,'DEBUG:  nop0  ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 17
      TextF(offx+35,offy+105,'DEBUG:  nop1   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 18
      TextF(offx+35,offy+105,'DEBUG:  not0   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 19
      TextF(offx+35,offy+105,'DEBUG:  shl   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 20
      TextF(offx+35,offy+105,'DEBUG:  zero   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 21
      TextF(offx+35,offy+105,'DEBUG:  ifz   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 22
      TextF(offx+35,offy+105,'DEBUG:  sub_ab   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 23
      TextF(offx+35,offy+105,'DEBUG:  sub_ac   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 24
      TextF(offx+35,offy+105,'DEBUG:  inc_a   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 25
      TextF(offx+35,offy+105,'DEBUG:  inc_b   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 26
      TextF(offx+35,offy+105,'DEBUG:  dec_c   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 27
      TextF(offx+35,offy+105,'DEBUG:  inc_c   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 28
      TextF(offx+35,offy+105,'DEBUG:  pushax   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 29
      TextF(offx+35,offy+105,'DEBUG:  pushbx   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 30
      TextF(offx+35,offy+105,'DEBUG:  pushcx   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 31
      TextF(offx+35,offy+105,'DEBUG:  pushdx   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 32
      TextF(offx+35,offy+105,'DEBUG:  popax   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 33
      TextF(offx+35,offy+105,'DEBUG:  popbx   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 34
      TextF(offx+35,offy+105,'DEBUG:  popcx   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 35
      TextF(offx+35,offy+105,'DEBUG:  popdx   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 36
      TextF(offx+35,offy+105,'DEBUG:  ret   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 37
      TextF(offx+35,offy+105,'DEBUG:  movcd   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 38
      TextF(offx+35,offy+105,'DEBUG:  movab   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 39
      TextF(offx+35,offy+105,'DEBUG:  movii   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 40
      TextF(offx+35,offy+105,'DEBUG:  jmp   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 41
      TextF(offx+35,offy+105,'DEBUG:  jmpb   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 42
      TextF(offx+35,offy+105,'DEBUG:  call   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 43
      TextF(offx+35,offy+105,'DEBUG:  adr   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 44
      TextF(offx+35,offy+105,'DEBUG:  adrb   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 45
      TextF(offx+35,offy+105,'DEBUG:  adrf   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 46
      TextF(offx+35,offy+105,'DEBUG:  mal   ')
      IF ce<>0
        showcell(ce)
      ENDIF
    CASE 47
      TextF(offx+35,offy+105,'DEBUG:  divide   ')
      IF ce<>0
        showcell(ce)
      ENDIF
/*    CASE 48
      WriteF('\nDEBUG:  FindFreeMem\n')         */
  ENDSELECT
ENDPROC
