
OPT OSVERSION=39
OPT PREPROCESS

MODULE 'tools/easygui','intuition/screens','tools/exceptions',
       'intuition/intuition','protracker','graphics/rastport',
       'graphics/text','asl','libraries/asl','utility/tagitem',
       'dos/dos','exec/memory','xpkmaster','libraries/xpk',
       'libraries/gadtools','commodities','icon','amigalib/argarray',
       'exec/ports','libraries/commodities','tools/ports','utility',
       'med/mmd','medplayer','med/reloc','octaplayer','playsid',
       'libraries/playsidbase','exec/execbase','replay/jamcracker'


RAISE "LIB"  IF OpenLibrary()=0,
      "FONT" IF OpenFont()=0,
      "DRI"  IF GetScreenDrawInfo()=0,
      "ASL"  IF AllocAslRequest()=0,
      "SCR"  IF LockPubScreen()=0,
      "PORT" IF CreateMsgPort()=0,
      "cxOB" IF CreateCxObj()=0,
           1 IF CxBroker()=0


OBJECT modinfo OF plugin
    window:PTR TO window
PRIVATE
    rawkey:LONG
    visible:INT
    size:LONG
    name[128]:ARRAY OF CHAR
    type[128]:ARRAY OF CHAR
    author[128]:ARRAY OF CHAR
    comment[128]:ARRAY OF CHAR
ENDOBJECT


DEF mi:PTR TO modinfo,mp=0:PTR TO mmd0,ml=0,freq=0:PTR TO filerequester,
    sreq=0:PTR TO filerequester,pl=0,mfl=0,gh=0:PTR TO guihandle,
    defldir[256]:STRING,defsdir[256]:STRING,sc:PTR TO screen,
    brokerPort=0:PTR TO mp,broker=0,filter=0,type=0,sg,song,minsong,maxsong

->fs "modinfo class code"
PROC modinfo(name=NIL,size=0,t=0,au=0,com=0) OF modinfo
    IF name THEN AstrCopy(self.name,name,128) ELSE AstrCopy(self.name,'No module loaded',128)
    self.size:=size
    IF t THEN AstrCopy(self.type,t,128) ELSE AstrCopy(self.type,'None',128)
    IF au THEN AstrCopy(self.author,au,128) ELSE AstrCopy(self.author,'Unknown',128)
    IF com THEN AstrCopy(self.comment,com,128) ELSE AstrCopy(self.comment,'None',128)
ENDPROC

PROC will_resize() OF modinfo IS RESIZEX

PROC min_size(fh) OF modinfo IS fh*10,fh*5

PROC render(x,y,xs,ys,wd:PTR TO window) OF modinfo
    DEF rp:PTR TO rastport,w,tw,s[32]:STRING,c,dri:PTR TO drawinfo,
        font:PTR TO textfont
    self.visible:=TRUE
    self.window:=wd
    font:=OpenFont(wd.wscreen.font)
    dri:=GetScreenDrawInfo(wd.wscreen)
    rp:=wd.rport
    SetAPen(rp,dri.pens[BACKGROUNDPEN])
    RectFill(rp,x,y,x+xs-1,y+ys-1)
    SetAPen(rp,dri.pens[TEXTPEN])
    SetFont(rp,font)
    tw:=Max(TextLength(rp,'Comment: ',9),Max(TextLength(rp,'Author: ',8),Max(TextLength(rp,'Name: ',6),Max(TextLength(rp,'Size: ',6),TextLength(rp,'Type: ',6)))))
    Move(rp,x,y+rp.font.baseline)
    Text(rp,'Name:',5)
    Move(rp,x,y+rp.font.baseline+rp.font.ysize)
    Text(rp,'Size:',5)
    Move(rp,x,y+rp.font.baseline+Shl(rp.font.ysize,1))
    Text(rp,'Type:',5)
    Move(rp,x,y+rp.font.baseline+Shl(rp.font.ysize,1)+rp.font.ysize)
    Text(rp,'Author:',7)
    Move(rp,x,y+rp.font.baseline+Shl(rp.font.ysize,2))
    Text(rp,'Comment:',8)
    StringF(s,'\d',self.size)
    Move(rp,x+tw,y+rp.font.baseline)
    c:=StrLen(self.name)
    w:=TextLength(rp,self.name,c)
    WHILE w>(xs-tw)
        DEC c
        EXIT c=0
        w:=TextLength(rp,self.name,c)
    ENDWHILE
    IF c THEN Text(rp,self.name,c)
    Move(rp,x+tw,y+rp.font.baseline+rp.font.ysize)
    c:=StrLen(s)
    w:=TextLength(rp,s,c)
    WHILE w>(xs-tw)
        DEC c
        EXIT c=0
        w:=TextLength(rp,s,c)
    ENDWHILE
    IF c THEN Text(rp,s,c)
    Move(rp,x+tw,y+rp.font.baseline+Shl(rp.font.ysize,1))
    c:=StrLen(self.type)
    w:=TextLength(rp,self.type,c)
    WHILE w>(xs-tw)
        DEC c
        EXIT c=0
        w:=TextLength(rp,self.type,c)
    ENDWHILE
    IF c THEN Text(rp,self.type,c)
    Move(rp,x+tw,y+rp.font.baseline+Shl(rp.font.ysize,1)+rp.font.ysize)
    c:=StrLen(self.author)
    w:=TextLength(rp,self.author,c)
    WHILE w>(xs-tw)
        DEC c
        EXIT c=0
        w:=TextLength(rp,self.author,c)
    ENDWHILE
    IF c THEN Text(rp,self.author,c)
    Move(rp,x+tw,y+rp.font.baseline+Shl(rp.font.ysize,2))
    c:=StrLen(self.comment)
    w:=TextLength(rp,self.comment,c)
    WHILE w>(xs-tw)
        DEC c
        EXIT c=0
        w:=TextLength(rp,self.comment,c)
    ENDWHILE
    IF c THEN Text(rp,self.comment,c)
    FreeScreenDrawInfo(wd.wscreen,dri)
    CloseFont(font)
ENDPROC

PROC clear_render(u) OF modinfo
    self.visible:=FALSE
    self.window:=NIL
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,wd:PTR TO window) OF modinfo
    IF imsg.class=IDCMP_RAWKEY
        self.rawkey:=imsg.code
        RETURN TRUE
    ENDIF
ENDPROC FALSE

PROC message_action(wd:PTR TO window) OF modinfo
    DEF k
    k:=self.rawkey
    SELECT k
        CASE $19
            play()
        CASE $21
            stop()
        CASE $12
            eject()
        CASE $34
            save()
        CASE $28
            load()
        CASE $45
            RETURN TRUE
        CASE CURSORLEFT
            prev()
        CASE CURSORRIGHT
            next()
    ENDSELECT
ENDPROC FALSE

PROC setname(name=0) OF modinfo
    IF name THEN AstrCopy(self.name,name,128) ELSE AstrCopy(self.name,'No module loaded',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC setsize(size=0) OF modinfo
    self.size:=size
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC settype(t=0) OF modinfo
    IF t THEN AstrCopy(self.type,t,128) ELSE AstrCopy(self.type,'None',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC setauthor(au=0) OF modinfo
    IF au THEN AstrCopy(self.author,au,128) ELSE AstrCopy(self.author,'Unknown',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC setcomment(com=0) OF modinfo
    IF com THEN AstrCopy(self.comment,com,128) ELSE AstrCopy(self.comment,'None',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC setinfo(name=0,size=0,t=0,au=0,com=0) OF modinfo
    IF name THEN AstrCopy(self.name,name,128) ELSE AstrCopy(self.name,'No module loaded',128)
    self.size:=size
    IF t THEN AstrCopy(self.type,t,128) ELSE AstrCopy(self.type,'None',128)
    IF au THEN AstrCopy(self.author,au,128) ELSE AstrCopy(self.author,'Unknown',128)
    IF com THEN AstrCopy(self.comment,com,128) ELSE AstrCopy(self.comment,'None',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC
->fe

PROC main() HANDLE
    DEF res=-1,mask=0,sig,ttypes=NIL,msg,msgtype,msgid

    aslbase:=OpenLibrary('asl.library',37)
    xpkbase:=OpenLibrary('xpkmaster.library',2)
    iconbase:=OpenLibrary('icon.library',37)
    cxbase:=OpenLibrary('commodities.library',37)
    utilitybase:=OpenLibrary('utility.library',37)

    brokerPort:=CreateMsgPort()
    IF (ttypes:=argArrayInit())=0 THEN Raise("args")
    broker:=CxBroker([NB_VERSION,0,
                      'PsiloPlayer',
                      'PsiloPlayer v1.0',
                      'A small module player',
                      NBU_UNIQUE OR NBU_NOTIFY,COF_SHOW_HIDE,
                      argInt(ttypes,'CX_PRIORITY',0),0,
                      brokerPort,0]:newbroker,NIL)
    AttachCxObj(broker,filter:=CxFilter(argString(ttypes,'CX_POPKEY','ctrl alt d')))
    AttachCxObj(filter,CxSender(brokerPort,23))
    AttachCxObj(filter,CxTranslate(NIL))
    IF CxObjError(filter) THEN Raise("cxFU")
    ActivateCxObj(broker,TRUE)

    loadprefs()

    freq:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_PRIVATEIDCMP,TRUE,
                                           ASLFR_SLEEPWINDOW,TRUE,
                                           ASLFR_TITLETEXT,'Select a module to load',
                                           ASLFR_POSITIVETEXT,'Load',
                                           ASLFR_NEGATIVETEXT,'Cancel',
                                           ASLFR_REJECTICONS,TRUE,
                                           ASLFR_INITIALDRAWER,defldir,
                                           TAG_DONE])
    sreq:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_PRIVATEIDCMP,TRUE,
                                           ASLFR_SLEEPWINDOW,TRUE,
                                           ASLFR_TITLETEXT,'Select filename to save as',
                                           ASLFR_POSITIVETEXT,'Save',
                                           ASLFR_NEGATIVETEXT,'Cancel',
                                           ASLFR_REJECTICONS,TRUE,
                                           ASLFR_DOSAVEMODE,TRUE,
                                           ASLFR_INITIALDRAWER,defsdir,
                                           TAG_DONE])

    sc:=LockPubScreen(NIL)

    IF Stricmp('yes',argString(ttypes,'CX_POPUP','yes'))=0 THEN opengui()

    WHILE res<0
        mask:=Shl(1,brokerPort.sigbit)
        IF gh THEN mask:=Or(mask,gh.sig)
        sig:=Wait(mask)
        IF And(sig,Shl(1,brokerPort.sigbit))
            WHILE msg:=GetMsg(brokerPort)
                msgtype:=CxMsgType(msg)
                msgid:=CxMsgID(msg)
                ReplyMsg(msg)
                SELECT msgtype
                    CASE CXM_IEVENT
                        IF msgid=23
                            IF gh THEN closegui() ELSE opengui()
                        ENDIF
                    CASE CXM_COMMAND
                        SELECT msgid
                            CASE CXCMD_APPEAR
                                opengui()
                            CASE CXCMD_DISAPPEAR
                                closegui()
                            CASE CXCMD_DISABLE
                                ActivateCxObj(broker,FALSE)
                            CASE CXCMD_ENABLE
                                ActivateCxObj(broker,TRUE)
                            CASE CXCMD_KILL
                                res:=0
                            CASE CXCMD_UNIQUE
                                opengui()
                        ENDSELECT
                ENDSELECT
            ENDWHILE
        ELSEIF gh
            IF And(sig,gh.sig) THEN res:=guimessage(gh)
            IF res=23
                res:=-1
                closegui()
            ENDIF
        ENDIF
    ENDWHILE

    saveprefs()

EXCEPT DO
    eject()
    closegui()
    IF sc THEN UnlockPubScreen(NIL,sc)
    IF sreq THEN FreeAslRequest(sreq)
    IF freq THEN FreeAslRequest(freq)
    IF broker THEN DeleteCxObjAll(broker)
    IF ttypes THEN argArrayDone()
    IF brokerPort THEN deletePortSafely(brokerPort)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF cxbase THEN CloseLibrary(cxbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF xpkbase THEN CloseLibrary(xpkbase)
    IF aslbase THEN CloseLibrary(aslbase)
    IF exception>1 THEN report_exception()
ENDPROC

PROC opengui()
    IF gh THEN RETURN
    gh:=guiinit('PsiloPlayer',  [ROWS,
                                    [BAR],
                                    [BEVELR,[PLUGIN,0,NEW mi.modinfo(name(mp,type),ml,typename(type),author(mp,type),comment(mp,type))]],
                                    [BAR],
                                    sg:=[TEXT,'No module loaded',0,TRUE,10],
                                    [EQCOLS,
                                        [SBUTTON,{play},'Play'],
                                        [SBUTTON,{stop},'Stop'],
                                        [SBUTTON,{prev},'Prev'],
                                        [SBUTTON,{next},'Next'],
                                        [SBUTTON,{eject},'Eject'],
                                        [SBUTTON,{save},'Save'],
                                        [SBUTTON,{load},'Load']
                                    ],
                                    [BAR]
                                ],0,sc,0,[NM_TITLE,0,'Project',0,0,0,0,
                                          NM_ITEM,0, 'Load module...','L',NM_COMMANDSTRING,0,{load},
                                          NM_ITEM,0, 'Save module...','V',NM_COMMANDSTRING,0,{save},
                                          NM_ITEM,0, NM_BARLABEL,0,0,0,0,
                                          NM_ITEM,0, 'Eject module','E',NM_COMMANDSTRING,0,{eject},
                                          NM_ITEM,0, NM_BARLABEL,0,0,0,0,
                                          NM_ITEM,0, 'Hide','H',0,0,23,
                                          NM_ITEM,0, 'Quit','ESC',NM_COMMANDSTRING,0,0,
                                          NM_TITLE,0,'Edit',0,0,0,0,
                                          NM_ITEM,0, 'Play','P',NM_COMMANDSTRING,0,{play},
                                          NM_ITEM,0, 'Stop','S',NM_COMMANDSTRING,0,{stop},
                                          NM_ITEM,0, NM_BARLABEL,0,0,0,0,
                                          NM_ITEM,0, 'Previous song','LEFT',NM_COMMANDSTRING,0,{prev},
                                          NM_ITEM,0, 'Next song','RIGHT',NM_COMMANDSTRING,0,{next},
                                          NM_END,0,0,0,0,0,0
                                         ]:newmenu)
ENDPROC

PROC closegui(i=0)
    IF gh
        cleangui(gh)
        gh:=0
    ENDIF
ENDPROC

PROC load(i=0)
    IF AslRequest(freq,[ASLFR_WINDOW,mi.window,TAG_DONE])=0 THEN RETURN
    loadmodule(freq.drawer,freq.file)
ENDPROC

PROC loadmodule(d,n)
    DEF s[512]:STRING
    IF mp THEN eject()
    StrCopy(s,d)
    AddPart(s,n,512)
    SetStr(s,StrLen(s))
    status('Loading module...')
    XpkUnpack([XPK_INNAME,s,XPK_GETOUTBUF,{mp},XPK_GETOUTLEN,{ml},
               XPK_GETOUTBUFLEN,{mfl},XPK_OUTMEMTYPE,MEMF_CHIP,
               XPK_PASSTHRU,TRUE,TAG_DONE])
    IF (type:=checkformat(mp))=0
        FreeMem(mp,mfl)
        mp:=0
        status('Wrong format!')
    ELSE
        mi.setinfo(name(mp,type),ml,typename(type),author(mp,type),comment(mp,type))
        play()
    ENDIF
ENDPROC

PROC save(i=0)
    IF mp=0
        status('Load a module first!')
    ELSE
        IF AslRequest(sreq,[ASLFR_WINDOW,mi.window,
                            ASLFR_INITIALFILE,freq.file,
                            TAG_DONE])=0 THEN RETURN
        status('Saving module...')
        savemodule(sreq.drawer,sreq.file)
        status('Module saved.')
    ENDIF
ENDPROC

PROC savemodule(d,n)
    DEF s[512]:STRING
    StrCopy(s,d)
    AddPart(s,n,512)
    SetStr(s,StrLen(s))
    XpkPack([XPK_INBUF,mp,XPK_INLEN,ml,XPK_OUTNAME,s,
             XPK_PACKMETHOD,'SQSH',XPK_PACKMODE,100,
             TAG_DONE])
ENDPROC

PROC play(i=0)
    DEF execbase:PTR TO execbase
    IF mp=0 THEN status('Load a module first!')
    IF mp AND (pl=0)
        BSET    #1,$BFE001
        SELECT type
            CASE 1  -> ProTracker
                ptbase:=OpenLibrary('protracker.library',1)
                pl:=Mt_StartInt(mp)
                IF pl=0
                    CloseLibrary(ptbase)
                    ptbase:=0
                ENDIF
            CASE 2  -> MED
                medplayerbase:=OpenLibrary('medplayer.library',5)
                pl:=IF GetPlayer(0) THEN FALSE ELSE TRUE
                IF pl
                    SetModnum(song)
                    PlayModule(mp)
                ELSE
                    CloseLibrary(medplayerbase)
                    medplayerbase:=0
                ENDIF
            CASE 3  -> OctaMED
                octaplayerbase:=OpenLibrary('octaplayer.library',5)
                pl:=IF GetPlayer8() THEN FALSE ELSE TRUE
                IF pl
                    SetModnum8(song)
                    PlayModule8(mp)
                ELSE
                    CloseLibrary(octaplayerbase)
                    octaplayerbase:=0
                ENDIF
            CASE 4  -> PlaySID
                playsidbase:=OpenLibrary('playsid.library',1)
                pl:=AllocEmulResource()
                IF pl=0
                    execbase:=Long(4)
                    SetVertFreq(execbase.powersupplyfrequency)
                    SetModule(mp,mp,ml)
                    pl:=StartSong(song)
                    IF pl THEN FreeEmulResource()
                ENDIF
                IF pl
                    CloseLibrary(playsidbase)
                    playsidbase:=0
                ENDIF
                pl:=IF pl THEN FALSE ELSE TRUE
            CASE 5  -> JamCracker
                pl:=jc_StartInt(mp)
        ENDSELECT
        IF pl THEN status('Playing module...') ELSE status('Can''t play module!')
    ENDIF
ENDPROC

PROC eject(i=0)
    IF mp
        stop()
        FreeMem(mp,mfl)
        mp:=0;ml:=0
        type:=0
        mi.setinfo()
        status('Module ejected.')
    ELSE
        status('No module loaded!')
    ENDIF
ENDPROC

PROC stop(i=0)
    IF pl
        SELECT type
            CASE 1  -> ProTracker
                Mt_StopInt()
                CloseLibrary(ptbase)
                ptbase:=0
            CASE 2  -> MED
                StopPlayer()
                FreePlayer()
                CloseLibrary(medplayerbase)
                medplayerbase:=0
            CASE 3  -> OctaMED
                StopPlayer8()
                FreePlayer8()
                CloseLibrary(octaplayerbase)
                octaplayerbase:=0
            CASE 4  -> PlaySID
                StopSong()
                FreeEmulResource()
                CloseLibrary(playsidbase)
                playsidbase:=0
            CASE 5  -> JamCracker
                jc_StopInt()
        ENDSELECT
        pl:=0
        status('Module stopped.')
    ELSE
        status('No module playing!')
    ENDIF
ENDPROC

PROC checkformat(m:PTR TO mmd0)
    DEF v
    song:=0
    minsong:=0
    maxsong:=0
    IF Long(m+1080)="M.K." THEN RETURN 1
    v:=Long(m)
    IF v="BeEp" THEN RETURN 5
    IF v="PSID"
        song:=m::sidheader.defsong
        minsong:=1
        maxsong:=m::sidheader.number
        RETURN 4
    ENDIF
    IF (v="MMD0") OR (v="MMD1") OR (v="MMD2")
        relocModule(m)
        song:=0
        minsong:=0
        maxsong:=m.extra_songs
        RETURN IF And(m.song.flags,FLAG_8CHANNEL) THEN 3 ELSE 2
    ENDIF
ENDPROC 0

PROC name(mod:PTR TO mmd0,t)
    IF mod=0 THEN RETURN 'No module loaded'
    SELECT t
        CASE 0  -> None loaded
            RETURN 'Fnord!'
        CASE 1  -> ProTracker
            PutChar(mod+19,0)
            RETURN mod
        CASE 2  -> MED
            RETURN mod.expdata.songname
        CASE 3  -> OctaMED
            RETURN mod.expdata.songname
        CASE 4  -> PlaySID
            RETURN mod::sidheader.name
        CASE 5  -> JamCracker
            RETURN freq.file
    ENDSELECT
ENDPROC 'Untitled'

PROC author(mod:PTR TO mmd0,t)
    DEF i,j
    IF mod=0 THEN RETURN 'No module loaded'
    SELECT t
        CASE 0  -> None loaded
            RETURN 'Prof. Adam Weishaupt'
        CASE 1  -> ProTracker
            IF Char(mod+20)<>"#" THEN RETURN 'Unknown'
            i:=mod+21
            WHILE Char(i)="#" DO INC i
            j:=i
            WHILE (Char(i)<>"#") AND (i<(mod+42)) DO INC i
            IF Char(i)="#" THEN PutChar(i,0) ELSE PutChar(i-1,0)
            RETURN j
        CASE 2  -> MED
            RETURN 'Unknown'
        CASE 3  -> OctaMED
            RETURN 'Unknown'
        CASE 4  -> PlaySID
            RETURN mod::sidheader.author
        CASE 5  -> JamCracker
            RETURN 'Unknown'
    ENDSELECT
ENDPROC 'Untitled'

PROC comment(mod:PTR TO mmd0,t)
    IF mod=0 THEN RETURN 'No module loaded'
    SELECT t
        CASE 0  -> None loaded
            RETURN 'Fnord!'
        CASE 1  -> ProTracker
            RETURN 'None'
        CASE 2  -> MED
            RETURN mod.expdata.annotxt
        CASE 3  -> OctaMED
            RETURN mod.expdata.annotxt
        CASE 4  -> PlaySID
            RETURN mod::sidheader.copyright
        CASE 5  -> JamCracker
            RETURN 'None'
    ENDSELECT
ENDPROC 'Untitled'

PROC typename(t) IS ListItem(['None','ProTracker','OctaMED 4-Channel',
                              'OctaMED 8-Channel','PlaySID','JamCracker'],t)

PROC status(t) IS settext(gh,sg,t)

PROC loadprefs()
    DEF fh
    fh:=Open('ENVARC:PsiloPlayer.prefs',MODE_OLDFILE)
    IF fh
        ReadStr(fh,defldir)
        ReadStr(fh,defsdir)
        Close(fh)
    ENDIF
ENDPROC

PROC saveprefs()
    DEF fh
    fh:=Open('ENVARC:PsiloPlayer.prefs',MODE_NEWFILE)
    IF fh=0 THEN Raise("FILE")
    VfPrintf(fh,'%s\n%s\n',[freq.drawer,sreq.drawer])
    Close(fh)
ENDPROC

PROC next(i=0)
    IF song<maxsong
        stop()
        INC song
        play()
    ELSE
        status('This is the last song!')
    ENDIF
ENDPROC

PROC prev(i=0)
    IF song>minsong
        stop()
        DEC song
        play()
    ELSE
        status('This is the first song!')
    ENDIF
ENDPROC


