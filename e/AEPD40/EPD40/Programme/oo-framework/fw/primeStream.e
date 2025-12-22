
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
    tw:=Max(TextLength(rp,'Comment: ',9),Max(TextLength(rp,'A