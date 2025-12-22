/* Sauve les options de compilations selectionnées par l'intermédiaire    */
/* d'une fenêtre gadtools dans une variable d'environnement.              */

    OPT OSVERSION=37

    MODULE 'dos/dos','dos/rdargs'
    MODULE 'gadtools','libraries/gadtools'
    MODULE 'intuition/intuition','intuition/screens','intuition/gadgetclass',
           'intuition/intuitionbase','intuition/gadgetclass'
    MODULE 'graphics/text'
    MODULE 'utility/tagitem'

    ENUM OWN_ERROR=21,IO_ERROR,FIND_ERROR,MEM_ERROR,GAD

    DEF ecoptionswnd:PTR TO window,ecoptionsglist:PTR TO gadget,
        scr:PTR TO screen,visual=NIL,tattr,optstr[50]:STRING,
        opthandle,opt,optname1:PTR TO CHAR,
        optname2:PTR TO CHAR,args:PTR TO rdargs,gad:PTR TO gadget,
        g:PTR TO gadget,argarray:PTR TO LONG

    RAISE GAD IF CreateGadgetA()=NIL

/*FOLDER "main()"*/
PROC main() HANDLE
    openpwindow()
    wait4message(ecoptionswnd)
    quit(RETURN_OK,NIL)
EXCEPT
    SELECT exception
        CASE GAD ; quit(OWN_ERROR,'CreateGadgetA()')
    ENDSELECT
ENDPROC
/*FEND*/
CHAR '$VER: ECOpt 1.010 (09 Oct 1994) © BURGHARD Eric | WANABOSO/AGOA'

/*FOLDER "openpwindow()"*/
PROC openpwindow()
    DEF ib:PTR TO intuitionbase,gtname:PTR TO CHAR

    ib:=intuitionbase
    scr:=ib.activescreen
    gtname:='gadtools.library'
    IF (gadtoolsbase:=OpenLibrary(gtname,37))=NIL THEN quit(FIND_ERROR,gtname)
    IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN quit(OWN_ERROR,'GetVisualInfo()')
    tattr:=['topaz.font',8,0,0]:textattr
    IF (g:=CreateContext({ecoptionsglist}))=NIL THEN quit(OWN_ERROR,'CreateContext()')
    g:=CreateGadgetA(INTEGER_KIND,g,[143,89,99,14,'',tattr,0,0,visual,0]:newgadget,
                                    [GTIN_NUMBER,0,GTIN_MAXCHARS,1,
                                     NIL])
    g:=CreateGadgetA(CHECKBOX_KIND,g,[19,89,26,11,'REGISTERS',tattr,1,PLACETEXT_RIGHT,visual,0]:newgadget,
                                     [NIL])
    g:=CreateGadgetA(CHECKBOX_KIND,g,[19,24,26,11,'IGNORE CACHE',tattr,2,PLACETEXT_RIGHT,visual,0]:newgadget,
                                     [NIL])
    g:=CreateGadgetA(CHECKBOX_KIND,g,[19,76,26,11,'OPTIMISATIONS',tattr,3,PLACETEXT_RIGHT,visual,0]:newgadget,
                                     [NIL])
    g:=CreateGadgetA(CHECKBOX_KIND,g,[19,50,26,11,'SYMBOLS',tattr,4,PLACETEXT_RIGHT,visual,0]:newgadget,
                                     [NIL])
    g:=CreateGadgetA(CHECKBOX_KIND,g,[19,63,26,11,'LINEDEBUG',tattr,5,PLACETEXT_RIGHT,visual,0]:newgadget,
                                     [NIL])
    g:=CreateGadgetA(CHECKBOX_KIND,g,[19,37,26,11,'LARGE MODEL',tattr,6,PLACETEXT_RIGHT,visual,0]:newgadget,
                                     [NIL])
    g:=CreateGadgetA(BUTTON_KIND,g,[12,110,77,17,'USE',tattr,7,PLACETEXT_IN,visual,0]:newgadget,
                                   [NIL])
    g:=CreateGadgetA(BUTTON_KIND,g,[92,110,77,17,'SAVE',tattr,8,PLACETEXT_IN,visual,0]:newgadget,
                                   [NIL])
    g:=CreateGadgetA(BUTTON_KIND,g,[172,110,77,17,'CANCEL',tattr,9,PLACETEXT_IN,visual,0]:newgadget,
                                   [NIL])
    optname1:='ENV:ECOpt'
    optname2:='ENVARC:ECOpt'
    IF setflg(optname1)=FALSE THEN setflg(optname2)
    SetStr(optstr,0)
    IF (ecoptionswnd:=OpenWindowTagList(NIL,[WA_LEFT,184,WA_TOP,48,
                                             WA_WIDTH,260,WA_HEIGHT,131,
                                             WA_IDCMP,(IDCMP_REFRESHWINDOW OR IDCMP_GADGETUP OR IDCMP_CLOSEWINDOW),
                                             WA_FLAGS,(WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_DRAGBAR OR WFLG_ACTIVATE),
                                             WA_TITLE,'ECompiler Options',
                                             WA_CUSTOMSCREEN,scr,
                                             WA_AUTOADJUST,1,
                                             WA_GADGETS,ecoptionsglist,
                                             NIL]))=NIL THEN quit(OWN_ERROR,'OpenWindowTagList()')
    DrawBevelBoxA(ecoptionswnd.rport,12,17,237,92,[GT_VISUALINFO,visual,NIL])
ENDPROC
/*FEND*/
/*FOLDER "setflg(name)"*/
PROC setflg(name)
    IF (opthandle:=Open(name,MODE_OLDFILE))
        ReadStr(opthandle,optstr)
        Close(opthandle) ; opthandle:=0
        IF (args:=AllocDosObject(DOS_RDARGS,NIL))
            args::csource.buffer:=optstr
            args::csource.length:=EstrLen(optstr)
            argarray:=[-1,0,0,0,0,0]:LONG
            IF ReadArgs('REG/K/N,IGNORECACHE/S,OPTI/S,SYM/S,LINEDEBUG/S,LARGE/S',argarray,args)
                gad:=ecoptionsglist.nextgadget
                g:=gad.nextgadget
                Gt_SetGadgetAttrsA(g,NIL,NIL,[GTCB_CHECKED,IF argarray[0]<>-1 THEN TRUE ELSE FALSE,TAG_END])
                Gt_SetGadgetAttrsA(gad,NIL,NIL,[GA_DISABLED,IF argarray[0]<>-1 THEN FALSE ELSE TRUE,GTIN_NUMBER,IF argarray[0]<>-1 THEN Long(argarray[0]) ELSE 0,TAG_END])
                g:=g.nextgadget
                FOR opt:=1 TO 5
                    Gt_SetGadgetAttrsA(g,NIL,NIL,[GTCB_CHECKED,IF argarray[opt] THEN TRUE ELSE FALSE,TAG_END])
                    g:=g.nextgadget
                ENDFOR
                FreeArgs(args)
            ELSE ; quit(IO_ERROR,'ECOpt')
            ENDIF
        ELSE ; quit(MEM_ERROR,'AllocDosObject()')
        ENDIF
    ELSE ; RETURN FALSE
    ENDIF
ENDPROC TRUE

/*FEND*/
/*FOLDER "wait4message(win:PTR TO window)"*/
PROC wait4message(win:PTR TO window)
    DEF mes:PTR TO intuimessage,type:PTR TO gadget,gadid

    REPEAT
        type:=0
        IF mes:=Gt_GetIMsg(win.userport)
            type:=mes.class
            IF type<>IDCMP_CLOSEWINDOW
                SELECT type
                    CASE IDCMP_GADGETUP
                        type:=mes.iaddress
                        gadid:=type.gadgetid
                        SELECT gadid
                            CASE 1
                                gad:=ecoptionsglist.nextgadget
                                Gt_SetGadgetAttrsA(gad,ecoptionswnd,NIL,[GA_DISABLED,IF (type.flags AND GFLG_SELECTED) THEN FALSE ELSE TRUE,TAG_END])
                                type:=0
                            CASE 7
                                optfmt()
                                saveopt(optname1)
                            CASE 8
                                optfmt()
                                saveopt(optname1)
                                saveopt(optname2)
                            CASE 9 ; NOP
                            DEFAULT ; type:=0
                        ENDSELECT
                    CASE IDCMP_REFRESHWINDOW
                        Gt_BeginRefresh(win)
                        Gt_EndRefresh(win,TRUE)
                        type:=0
                ENDSELECT
            ENDIF
            Gt_ReplyIMsg(mes)
        ELSE ; WaitPort(win.userport)
        ENDIF
    UNTIL type
ENDPROC type
/*FEND*/
/*FOLDER "optfmt()"*/
PROC optfmt()
    DEF tmpstr[15]:STRING,sinfo:PTR TO stringinfo

    gad:=ecoptionsglist.nextgadget
    sinfo:=gad.specialinfo
    gad:=gad.nextgadget
    FOR opt:=0 TO 5
        IF (gad.flags AND GFLG_SELECTED)
            StringF(tmpstr,ListItem(['REG \d ','IGNORECACHE ','OPTI ','SYM ','LINEDEBUG ','LARGE ']:LONG,opt),sinfo.longint)
            StrAdd(optstr,tmpstr,ALL)
        ENDIF
        gad:=gad.nextgadget
    ENDFOR
ENDPROC

/*FEND*/
/*FOLDER "saveopt(name)"*/
PROC saveopt(name)
    IF (opthandle:=Open(name,MODE_NEWFILE))
        IF Fputs(opthandle,optstr) THEN quit(IO_ERROR,name)
        Close(opthandle) ; opthandle:=0
    ENDIF
ENDPROC

/*FEND*/
/*FOLDER "quit(err,obj)"*/
PROC quit(err,obj)
    DEF flt=0

    IF err<>RETURN_OK
        IF err<>OWN_ERROR
            SELECT err
                CASE IO_ERROR  ; flt:=IoErr()
                CASE MEM_ERROR ; flt:=ERROR_NO_FREE_STORE
                CASE FIND_ERROR; flt:=ERROR_OBJECT_NOT_FOUND
            ENDSELECT
            err:=RETURN_ERROR
            PrintFault(flt,obj)
        ELSE
            WriteF('Error with \s\n',obj)
            err:=RETURN_ERROR
        ENDIF
    ENDIF
    IF args THEN FreeDosObject(DOS_RDARGS,args)
    IF opthandle THEN Close(opthandle)
    IF visual THEN FreeVisualInfo(visual)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF ecoptionswnd THEN CloseWindow(ecoptionswnd)
    IF ecoptionsglist THEN FreeGadgets(ecoptionsglist)
    CleanUp(err)
ENDPROC
/*FEND*/

