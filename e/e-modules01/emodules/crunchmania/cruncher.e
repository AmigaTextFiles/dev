OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   file cruncher based on CrM.library
*   File            :   cruncher.e
*   Copyright       :   © 1995 Piotr Gapinski
*   Author          :   Piotr Gapinski
*   Creation Date   :   29.12.95
*   Current version :   1.1
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   17.12.95      0.9             to many exceptions...
*   26.12.95      0.91            decrunch opt not work
*   28.12.95      1.0             decrunch fixed, tooltypes improved
*   29.12.95      1.1             crunch hook added
*
*-- REV_END --*
*/

MODULE 'dos/dos','dos/dosextens',
       'intuition/intuition','intuition/screens',
       'exec/lists','exec/nodes',
       'libraries/crm','crm',
       'libraries/reqtools','reqtools',
       'libraries/reqtools','reqtools',
       'utility/tagitem','utility/hooks',
       'tools/easygui',
       'tools/exceptions','tools/constructors',
       'Fabio/ttparse_oo',
       'other/ecode'

#define PROGRAMVERSION '$VER: Cruncher 1.1 (29.12.95)'
->#define SIMPLEGUI 1
#define REQTOOLSNAME 'reqtools.library'
#define REQTOOLSVERSION 38

OBJECT guiprefs
  gh:PTR TO guihandle
  scr:PTR TO screen
  crunch:PTR TO cmcrunchstruct
  data:PTR TO dataheader
  freq:PTR TO rtfilerequester
  hook:PTR TO hook
  filegad,listgad,hookgad
  mem,len
  status,count
  messages:PTR TO lh
  filename[40]:ARRAY OF CHAR
ENDOBJECT

ENUM ERR_TTYPE,ERR_OK,ERR_ARGS,ERR_CRMLIB,ERR_REQLIB,ERR_CRMSTRUCT,
     ERR_REQSTRUCT,ERR_NOMEM,ERR_NOFILE,ERR_NOSIZE,ERR_READ,ERR_WRITE,
     ERR_CRUNCH,ERR_STATUS
ENUM ARG_SCREEN,NUMARGS
ENUM STATUS_WAIT,STATUS_CRUNCHED,STATUS_DECRUNCHED

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,templ,
      scr=0,scrname[40]:STRING,
      gp=NIL:PTR TO guiprefs,res=-1,
      ttype:PTR TO ttparse
  DEF file,list,hook

  IF wbmessage
    NEW ttype.ttparse(TRUE)
    IF ttype.error() THEN Raise(ERR_TTYPE)
    StrCopy(scrname,ttype.get('PUBSCREEN'))
    END ttype
  ELSE
    templ:='PUBSCREEN/K'
    IF (rdargs:=ReadArgs(templ,args,NIL))=NIL THEN Raise(ERR_ARGS)
    StrCopy(scrname,args[ARG_SCREEN])
    FreeArgs(rdargs)
  ENDIF
  scr:=LockPubScreen(scrname)
  IF scr=NIL
    scrname:=NIL
    LockPubScreen(scrname)
  ENDIF
  IF (crmbase:=OpenLibrary(CRMNAME,CRMVERSION))=NIL THEN Raise(ERR_CRMLIB)
  IF (reqtoolsbase:=OpenLibrary(REQTOOLSNAME,
      REQTOOLSVERSION))=NIL THEN Raise(ERR_REQLIB)

  gp:=New(SIZEOF guiprefs)
  gp.data:=New(SIZEOF dataheader)
  gp.hook:=New(SIZEOF hook)
  gp.scr:=scr
  gp.crunch:=CmAllocCrunchStructA(
       [CMCS_ALGO,CM_LZH /*OR CM_SAMPLE*/ OR CMF_OVERLAY OR CMF_LEDFLASH,
       TAG_DONE])
  IF gp.crunch=NIL THEN Raise(ERR_CRMSTRUCT)
  gp.freq:=RtAllocRequestA(RT_FILEREQ,NIL)
  IF gp.freq=NIL THEN Raise(ERR_REQSTRUCT)
  gp.messages:=newlist()

#ifdef SIMPLEGUI
  gp.gh:=guiinit('Cruncher  (c)Piotr Gapinski',
      [EQROWS,
        file:=[TEXT,NIL,'File:',TRUE,3],
        [EQCOLS,
          [SBUTTON,{load},'Load'],
          [SBUTTON,{save},'Save'],
          [SBUTTON,{info},'About'],
          [SBUTTON,{delete},'Delete']
        ],
        [BAR],
        [EQCOLS,
          [TEXT,' Messages:',NIL,FALSE,3],
          [SPACEH],
          [SBUTTON,{clear},'Clear']
        ],
        list:=[LISTV,{dummy},NIL,40,14,gp.messages,TRUE,0,0],
        hook:=[TEXT,NIL,NIL,TRUE,3]
    ],gp,scr)
#endif

#ifndef SIMPLEGUI
  gp.gh:=guiinit('Cruncher  (c)Piotr Gapinski',
    [ROWS,
      [BEVEL,
        [EQROWS,
          file:=[TEXT,NIL,'File:',TRUE,3],
          [COLS,
            [BEVELR,
              [EQCOLS,
                [SBUTTON,{load},'Load'],
                [SBUTTON,{save},'Save'],
                [SBUTTON,{info},'About']
              ]
            ],
            [BEVELR,[SBUTTON,{delete},'Delete']]
          ]
        ]
      ],
      [BEVELR,
        [EQROWS,
          [EQCOLS,
            [TEXT,' Messages:',NIL,FALSE,3],
            [SPACEH],
            [SBUTTON,{clear},'Clear']
          ],
          list:=[LISTV,{dummy},NIL,40,12,gp.messages,TRUE,0,0],
          [BEVEL,
          hook:=[TEXT,NIL,NIL,FALSE,3]
          ]
        ]
      ]
    ],gp,scr)
#endif

  gp.filegad:=file
  gp.listgad:=list
  gp.hookgad:=hook
  IF gp.gh<>NIL THEN gp.gh.wnd.flags:=gp.gh.wnd.flags OR WFLG_RMBTRAP

  info(gp)  -> say hello :)

  WHILE res<0
    Wait(gp.gh.sig)
    res:=guimessage(gp.gh)
  ENDWHILE
EXCEPT DO
  IF gp.gh THEN cleangui(gp.gh)
  IF scr THEN UnlockPubScreen(scrname,scr)
  IF gp
    IF gp.crunch THEN CmFreeCrunchStruct(gp.crunch)
    IF gp.freq THEN RtFreeRequest(gp.freq)
    IF gp.messages THEN freelist(gp.messages,TRUE)
    IF gp.data THEN Dispose(gp.data)
    IF gp.hook THEN Dispose(gp.hook)
    Dispose(gp)
  ENDIF
  IF crmbase THEN CloseLibrary(crmbase)
  IF reqtoolsbase<>NIL THEN CloseLibrary(reqtoolsbase)
  IF exception
    SELECT exception
    CASE ERR_TTYPE
      WriteF('ToolType Parser Error: \d\n', ttype.error())
    CASE ERR_ARGS
      WriteF('Bad args! (try "cruncher ?")\n')
    CASE ERR_CRMLIB
      WriteF('Couldn\at open crm.library!\n')
    CASE ERR_REQLIB
      WriteF('Couldn\at open reqtools.library!\n')
    CASE ERR_CRMSTRUCT
      WriteF('Couldn\at allocate struct (crm)!\n')
    CASE ERR_REQSTRUCT
      WriteF('Couldn\at allocate struct (reqtools)!\n')
    DEFAULT
      WriteF('maybe no free memory?\n');
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

PROC load(gp:PTR TO guiprefs) HANDLE
  DEF handle=NIL,lock=NIL,dir=0,guilock=0,selected

  selected:=RtFileRequestA(gp.freq,gp.filename,'Load file...',
    [RT_UNDERSCORE,"_",RT_LOCKWINDOW,TRUE,RT_PUBSCRNAME,gp.scr,
     RT_WINDOW,gp.gh.wnd,
     RTFI_OKTEXT,'_Load',TAG_DONE])
  IF selected<>0
    guilock:=RtLockWindow(gp.gh.wnd)
    IF gp.status<>STATUS_WAIT
      IF gp.mem THEN Dispose(gp.mem)
      gp.mem:=NIL
      gp.status:=STATUS_WAIT
    ENDIF
    settext(gp.gh,gp.filegad,gp.filename)
    lock:=Lock(gp.freq.dir,ACCESS_READ)
    dir:=CurrentDir(lock)

    addinfo(gp,'loading "\s" ...',gp.filename)
    IF (handle:=Open(gp.filename,MODE_OLDFILE))=NIL THEN Raise(ERR_NOFILE)
    IF (Read(handle,gp.data,SIZEOF dataheader))<>SIZEOF dataheader THEN
        Raise(ERR_READ)

    IF (CmCheckCrunched(gp.data))=0
      crunch(gp,handle)
    ELSE
      decrunch(gp,handle)
    ENDIF
  ELSE
    settext(gp.gh,gp.filegad,NIL)
    addinfo(gp,'nothing to load, no file selected')
  ENDIF
EXCEPT DO
  settext(gp.gh,gp.hookgad,NIL)
  IF guilock THEN RtUnlockWindow(gp.gh.wnd,guilock)
  IF handle THEN Close(handle)
  IF lock
    IF dir THEN CurrentDir(dir)
    UnLock(lock)
  ENDIF
  IF exception
    SELECT exception
    CASE ERR_NOFILE
      addinfo(gp,'aborted, file not found!')
    CASE ERR_NOSIZE
      addinfo(gp,'aborted, file is empty!')
    CASE ERR_READ
      addinfo(gp,'aborted, error while reading!')
    CASE ERR_NOMEM
      addinfo(gp,'aborted, no free memory, file to big')
    CASE ERR_CRUNCH
      addinfo(gp,'aborted, (de)crunch failed!')
    DEFAULT
      report_exception()
      WriteF('LEVEL: load()\n')
    ENDSELECT
    IF gp.status<>STATUS_WAIT
      IF gp.mem THEN Dispose(gp.mem)
      gp.mem:=NIL
      gp.status:=STATUS_WAIT
    ENDIF
  ENDIF
ENDPROC

PROC save(gp:PTR TO guiprefs) HANDLE
  DEF handle=0,lock=0,dir=0,guilock=0,selected

  IF gp.status=STATUS_WAIT THEN Raise(ERR_STATUS)
  selected:=RtFileRequestA(gp.freq,gp.filename,'Save file as...',
    [RT_UNDERSCORE,"_",RT_LOCKWINDOW,TRUE,RT_PUBSCRNAME,gp.scr,
     RT_WINDOW,gp.gh.wnd,RTFI_FLAGS,FREQF_SAVE OR FREQF_NOBUFFER,
     RTFI_OKTEXT,'_Save',TAG_DONE])
  IF selected<>0
    guilock:=RtLockWindow(gp.gh.wnd)
    lock:=Lock(gp.freq.dir,ACCESS_READ)
    dir:=CurrentDir(lock)
    addinfo(gp,'  saving as "\s"',gp.filename)
    IF (handle:=Open(gp.filename,MODE_NEWFILE))=NIL THEN Raise(ERR_NOFILE)
    IF gp.status=STATUS_CRUNCHED
      IF (Write(handle,gp.data,SIZEOF dataheader))<>SIZEOF dataheader THEN
        Raise(ERR_WRITE)
    ENDIF
    IF (Write(handle,gp.mem+gp.data.minsecdist,gp.len))<>gp.len THEN Raise(ERR_WRITE)
    addinfo(gp,'OK, saved')
  ELSE
    addinfo(gp,'saving aborted')
  ENDIF
EXCEPT DO
  IF guilock THEN RtUnlockWindow(gp.gh.wnd,guilock)
  IF lock
    CurrentDir(dir)
    UnLock(lock)
  ENDIF
  IF handle THEN Close(handle)
  IF exception
    SELECT exception
    CASE ERR_STATUS
      addinfo(gp,'nothing to save, buffer is empty!')
    CASE ERR_NOFILE
      addinfo(gp,'aborted, can\at create file!')
    CASE ERR_WRITE
      addinfo(gp,'aborted, error while writing!')
    DEFAULT
      report_exception()
      WriteF('LEVEL: save()\n')
    ENDSELECT
  ENDIF
ENDPROC

PROC crunch(gp:PTR TO guiprefs,handle)
  DEF mem,size,newsize

  Seek(handle,0,OFFSET_END)
  size:=Seek(handle,0,OFFSET_BEGINNING)
  gp.len:=size
  mem:=New(size)
  gp.mem:=mem
  IF mem=NIL THEN Raise(ERR_NOMEM)
  IF (Read(handle,mem,size))<>size THEN Raise(ERR_READ)
  addinfo(gp,'  OK.')

  gp.crunch.src:=mem
  gp.crunch.srclen:=size
  gp.crunch.dest:=mem
  gp.crunch.destlen:=size
  gp.crunch.datahdr:=gp.data

  gp.hook.entry:=eCode({crunchhook})
  gp.hook.subentry:=NIL
  gp.hook.data:=gp
  gp.crunch.displayhook:=gp.hook
  gp.crunch.displaystep:=1024

  addinfo(gp,'  C R U N C H I N G')
  newsize:=CmCrunchData(gp.crunch)

  gp.len:=newsize
  IF newsize=NIL THEN Raise(ERR_CRUNCH)
  addinfo(gp,'  original len=\d',size)
  addinfo(gp,'  crunched len=\d',newsize)
  gp.status:=STATUS_CRUNCHED
ENDPROC

PROC decrunch(gp:PTR TO guiprefs,handle)
  DEF orig,crun,mem,buffsize

  orig:=gp.data.originallen
  crun:=gp.data.crunchedlen
  gp.len:=orig
  buffsize:=orig+gp.data.minsecdist
  mem:=New(buffsize)
  gp.mem:=mem
  IF mem=NIL THEN Raise(ERR_NOMEM)
  IF (Read(handle,mem,crun))<>crun THEN Raise(ERR_READ)
  addinfo(gp,'  OK.')
  addinfo(gp,'  D E C R U N C H I N G')
  IF (CmDecrunch(mem,mem+gp.data.minsecdist,gp.data))=NIL THEN Raise(ERR_CRUNCH)
  addinfo(gp,'  crunched len=\d',crun)
  addinfo(gp,'  original len=\d',orig)
  gp.status:=STATUS_DECRUNCHED
ENDPROC

PROC info(gp:PTR TO guiprefs)
  addinfo(gp,'*')
  addinfo(gp,PROGRAMVERSION)
  addinfo(gp,'file cruncher based on CrM.library')
  addinfo(gp,'   (c)1995 by Piotr Gapinski')
  addinfo(gp,'            email')
  addinfo(gp,'  kolo8@sparc10.ely.pg.gda.pl')
  addinfo(gp,'            snail')
  addinfo(gp,'    Gutkowo,ul.Stokowa 19,')
  addinfo(gp,'    11-041 Olsztyn, Poland')
  addinfo(gp,NIL)
  addinfo(gp,'CrM.library is (c) by Thomas Schwarz')
  addinfo(gp,'*')
ENDPROC

PROC delete(gp:PTR TO guiprefs)
  DEF lock=0,dir=0,answer,selected

  selected:=RtFileRequestA(gp.freq,gp.filename,'Delete file...',
    [RT_UNDERSCORE,"_",RT_LOCKWINDOW,TRUE,RT_PUBSCRNAME,gp.scr,
     RT_WINDOW,gp.gh.wnd,RTFI_FLAGS,FREQF_SAVE OR FREQF_NOBUFFER,
     RTFI_OKTEXT,'_Delete',TAG_DONE])
  IF selected<>0
    lock:=Lock(gp.freq.dir,ACCESS_READ)
    dir:=CurrentDir(lock)
    answer:=easygui('Request',
      [ROWS,
        [TEXT,' Delete?',NIL,FALSE,30],
        [TEXT,' Are you sure?',NIL,FALSE,30],
        [BAR],
        [EQCOLS,
          [SBUTTON,0,'Delete'],
          [SPACEH],
          [SBUTTON,1,'Cancel']
      ]
    ],gp,gp.scr)
    IF answer=0
      addinfo(gp,'deleting "\s"...',gp.filename)
      addinfo(gp,IF DeleteFile(gp.filename) THEN 'OK, deleted' ELSE 'error!')
    ELSE
      addinfo(gp,'deleting aborted')
    ENDIF
  ENDIF
  IF lock
    IF dir THEN CurrentDir(dir)
    UnLock(lock)
  ENDIF
ENDPROC

PROC clear(gp:PTR TO guiprefs)
  setlistvlabels(gp.gh,gp.listgad,-1)
  freelist(gp.messages)
  setlistvlabels(gp.gh,gp.listgad,gp.messages)
  gp.count:=0
ENDPROC

CONST MAX_MESSAGE = 40
PROC addinfo(gp:PTR TO guiprefs,format:PTR TO CHAR,data=NIL)
  DEF node:PTR TO ln,str,temp[40]:STRING

  IF (node:=New(SIZEOF ln))=NIL THEN Raise(ERR_NOMEM)
  IF format<>NIL
    IF data<>NIL
      StringF(temp,format,data)
    ELSE
      StrCopy(temp,format)
    ENDIF
    IF (str:=String(StrLen(temp)))=NIL THEN Raise(ERR_NOMEM)
    StrCopy(str,temp)
    node.name:=str
  ENDIF
  setlistvlabels(gp.gh,gp.listgad,-1)
  gp.count:=gp.count+1
  IF gp.count>=MAX_MESSAGE
    gp.count:=MAX_MESSAGE
    freenode(gp.messages)
  ENDIF
  AddTail(gp.messages,node)
  setlistvlabels(gp.gh,gp.listgad,gp.messages)
ENDPROC

PROC freelist(list:PTR TO lh,all=FALSE)
  IF list=NIL THEN RETURN     -> already de-allocated
  REPEAT
  UNTIL freenode(list)=FALSE
  IF all=TRUE THEN END list   -> use only with 'constructors.m' lists
ENDPROC

PROC freenode(list:PTR TO lh)
  DEF node:PTR TO ln

  node:=RemHead(list)
  IF node<>0
    DisposeLink(node.name)
    Dispose(node)
    RETURN TRUE
  ENDIF
ENDPROC FALSE

PROC crunchhook()
  DEF stats:PTR TO cmcurrentstats,
      gp:PTR TO guiprefs,
      thishook:PTR TO hook,
      temp[40]:STRING,var

  MOVE.L A0,thishook
  MOVE.L A1,stats
  gp:=thishook.data
  var:=Mul(stats.togo,100)
  StringF(temp,' Complete \d %',100-Div(var,gp.len))
  settext(gp.gh,gp.hookgad,temp)
ENDPROC TRUE

PROC dummy()
ENDPROC
CHAR PROGRAMVERSION
/*EE folds
-1
44 12 52 137 55 61 58 42 61 31 64 16 67 12 70 31 73 4 77 21 80 4 83 8 86 11 
EE folds*/
