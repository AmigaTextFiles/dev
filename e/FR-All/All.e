/* $VER: All 1.4 (28-9-97) © Frédéric Rodrigues - Registered
   Give wildcards and multiple arguments to commands + Listing utility

   V1.0 (19-3-97)- first
   V1.1 (25-3-97)- replaced Execute() by SystemTagList() wich permits
                   breaking of command executed
                   different format of prefs file, simpler
                   corrected little bugs
                   changed type strings and added new
                   coded prefs file
   V1.2 (5-4-97) - better work around against the bug on V36
                   matchfirst()-matchend() functions : listing is now
                   immediate
                   added new types
   V1.3 (9-4-97) - now TYPE option accepts a pattern
                   added new types
                   now display bytes free
                   removed *=#? because of StarClick
   V1.4 (28-9-97)- added command % : date,time,size,blocks,comment,
                   protection,type,key
                   modified little things
                   introduced %% for % character
                   now it is possible to choose the prefs file

   Times (listing of all df0:) :
   List of AmigaDos - 48 s
   All V1.2 - 1 mn 41 s
   All V1.1 - 2 mn 15 s
*/

OPT OSVERSION=36

MODULE 'dos/dos','dos/dosasl','dos/datetime','dos/dosextens'

CONST MAX_PATH=256,MAX_OUTSTRING=1024
ENUM ER_DOS=1,ER_MEM,ER_DATE,ER_CTRLC,ER_PREF
ENUM ARG_FILES,ARG_COMMAND,ARG_SIZEMIN,ARG_SIZEMAX,ARG_DATEMIN,ARG_DATEMAX,
     ARG_TYPEPATTERN,ARG_TYPESFILE,ARG_DO,ARG_ALL

DEF fib:PTR TO fileinfoblock,myargs:PTR TO LONG,rdargs,files:PTR TO LONG,
    anchor:PTR TO anchorpath,err,outstring[MAX_OUTSTRING]:STRING,
    datetime:datetime,date[9]:STRING,time[8]:STRING,
    nbfiles,sumsize,fh,type,
    lentype,listcommands[1]:STRING,allname,types,sumfree,infodata:infodata,
    protection[7]:STRING

PROC main() HANDLE
  DEF s,t,readtype,list,patternparsed
  myargs:=[NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL]
  IF (rdargs:=ReadArgs('FILES/M,COM=COMMAND/K,SIZEMIN/N/K,SIZEMAX/N/K,DATEMIN/K,DATEMAX/K,TYPE=TYPEPATTERN/K,FILE=TYPESFILE/K,DO/S,ALL/S',myargs,NIL))=NIL THEN Raise(ER_DOS)
  IF myargs[ARG_FILES]=NIL
    myargs[ARG_FILES]:=['#?',NIL]
  ENDIF
  IF myargs[ARG_COMMAND]=FALSE THEN WriteF('\e[1;3;2m\s\e[22;23;39m\n\n',{program})
  IF readtype:=myargs[ARG_TYPEPATTERN] OR (myargs[ARG_COMMAND]=FALSE) OR (InStr(myargs[ARG_COMMAND],'%y')<>-1)
    IF (t:=myargs[ARG_TYPESFILE])=FALSE THEN t:='ENV:All.prefs'
    IF (s:=FileLength(t))=-1 THEN Raise(ER_PREF)
    IF (types:=String(s+1))=NIL THEN Raise(ER_MEM)
    IF (fh:=Open(t,OLDFILE))=NIL THEN Raise(ER_PREF)
    IF Read(fh,types,s)<=0 THEN Raise(ER_PREF)
    Close(fh)
    fh:=NIL
    types[s]:="ÿ"
    MOVE.L s,D7
    SUBQ.L #1,D7
    s:=types+4
    lentype:=^s
    IF (type:=String(lentype))=NIL THEN Raise(ER_MEM)
    /* decoding */
    MOVEA.L types,A0
a: NOT.B (A0)+
   DBRA.L D7,a
  ENDIF
  IF myargs[ARG_TYPEPATTERN]
    IF (patternparsed:=String(s:=2*StrLen(myargs[ARG_TYPEPATTERN])+2))=NIL THEN Raise(ER_MEM)
    ParsePattern(myargs[ARG_TYPEPATTERN],patternparsed,s)
  ENDIF
  datetime.format:=FORMAT_DOS
  datetime.flags:=DTF_SUBST
  datetime.strday:=NIL
  files:=myargs[ARG_FILES]
  IF (anchor:=New(SIZEOF anchorpath+MAX_PATH))=NIL THEN Raise(ER_MEM)
  anchor.breakbits:=SIGBREAKF_CTRL_C
  anchor.strlen:=MAX_PATH
  list:=listcommands
  WHILE files[]
    IF (err:=MatchFirst(files[]++,anchor))=0
      Info(anchor.last.lock,infodata)
      nbfiles:=0
      sumsize:=0
      sumfree:=infodata.bytesperblock*(infodata.numblocks-infodata.numblocksused)
    ENDIF
    WHILE err=0
      fib:=anchor.info
      IF fib.direntrytype>0
        IF ((anchor.flags AND APF_DIDDIR)=0) AND myargs[ARG_ALL] THEN
          anchor.flags:=anchor.flags OR APF_DODIR
        anchor.flags:=anchor.flags AND Not(APF_DIDDIR)
      ELSE
        IF s:=myargs[ARG_SIZEMIN] THEN IF fib.size<^s THEN JUMP l
        IF s:=myargs[ARG_SIZEMAX] THEN IF fib.size>^s THEN JUMP l
        datetime.strtime:=NIL
        IF myargs[ARG_DATEMIN]
          datetime.strdate:=myargs[ARG_DATEMIN]
          IF StrToDate(datetime)=FALSE THEN Raise(ER_DATE)
          IF CompareDates(datetime.stamp,fib.datestamp)<0 THEN JUMP l
        ENDIF
        IF myargs[ARG_DATEMAX]
          datetime.strdate:=myargs[ARG_DATEMAX]
          IF StrToDate(datetime)=FALSE THEN Raise(ER_DATE)
          IF CompareDates(datetime.stamp,fib.datestamp)>0 THEN JUMP l
        ENDIF
        allname:=anchor+SIZEOF anchorpath
        IF readtype
          IF (fh:=Open(allname,OLDFILE))=NIL THEN Raise(ER_DOS)
          IF (s:=Read(fh,type,lentype))<0 THEN Raise(ER_DOS)
          Close(fh)
          fh:=NIL
          dotype()
        ENDIF
        IF myargs[ARG_TYPEPATTERN] THEN IF MatchPattern(patternparsed,type)=FALSE THEN JUMP l
        INC nbfiles
        sumsize:=sumsize+fib.size
        datetime.stamp.days:=fib.datestamp.days
        datetime.stamp.minute:=fib.datestamp.minute
        datetime.stamp.tick:=fib.datestamp.tick
        datetime.strdate:=date
        datetime.strtime:=time
        DateToStr(datetime)
        s:=protection
        IF fib.protection AND FIBF_SCRIPT THEN s[]++:="s"
        IF fib.protection AND FIBF_PURE THEN s[]++:="p"
        IF fib.protection AND FIBF_ARCHIVE THEN s[]++:="a"
        IF (fib.protection AND FIBF_READ)=FALSE THEN s[]++:="r"
        IF (fib.protection AND FIBF_WRITE)=FALSE THEN s[]++:="w"
        IF (fib.protection AND FIBF_EXECUTE)=FALSE THEN s[]++:="e"
        IF (fib.protection AND FIBF_DELETE)=FALSE THEN s[]++:="d"
        s[]:=0
        IF myargs[ARG_COMMAND]
          makeoutstring()
          IF myargs[ARG_DO]
            IF (s:=String(MAX_OUTSTRING))=NIL THEN Raise(ER_MEM)
            StrCopy(s,outstring,ALL)
            Link(list,s)
            list:=s
          ELSE
            PutStr(outstring)
          ENDIF
        ELSE
          WriteF('\e[1m\l\s[32]\e[22m \e[33m\s[8]\e[39m \r\d[7] \e[3m\l\s[7]\e[23m \s[9] \e[3m\s[8]\e[23m \e[3;2m\s\e[23;39m\n',
            IF StrLen(allname)>32 THEN allname+StrLen(allname)-32 ELSE allname,
            type,fib.size,protection,date,time,fib.comment)
        ENDIF
l:
      ENDIF
      err:=MatchNext(anchor)
    ENDWHILE
    IF err<>ERROR_NO_MORE_ENTRIES THEN Raise(ER_DOS)
    MatchEnd(anchor)
    IF myargs[ARG_COMMAND]=FALSE THEN WriteF('\e[4m\d files - \d bytes listed - \d bytes free\e[24m\n\n',nbfiles,sumsize,sumfree)
  ENDWHILE
  anchor:=NIL
  IF myargs[ARG_COMMAND]
    IF myargs[ARG_DO]
      outstring:=listcommands
      WHILE outstring:=Next(outstring)
        IF CtrlC() THEN Raise(ER_CTRLC)
        SystemTagList(outstring,0)
      ENDWHILE
    ENDIF
  ENDIF
EXCEPT DO
  IF fh THEN Close(fh)
  IF anchor THEN MatchEnd(anchor)
  IF rdargs THEN FreeArgs(rdargs)
  SELECT exception
    CASE ER_DOS;PrintFault(IoErr(),{error});RETURN RETURN_ERROR
    CASE ER_MEM;PrintFault(ERROR_NO_FREE_STORE,{error});RETURN RETURN_FAIL
    CASE ER_DATE;WriteF('\s: bad date\n',{error});RETURN RETURN_ERROR
    CASE ER_CTRLC;PrintFault(ERROR_BREAK,{error});RETURN RETURN_OK
    CASE ER_PREF;WriteF('\s: with prefs\n',{error});RETURN RETURN_FAIL
  ENDSELECT
ENDPROC

PROC makeoutstring()
  DEF s,t,u,command,out,str[10]:STRING
  command:=myargs[ARG_COMMAND]
  out:=outstring
  WHILE command[]<>0
    IF command[]="%"
      INC command
      IF command[]="%"
        out[]++:=command[]
      ELSE
        IF command[]="a"
          s:=allname
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="f"
          s:=fib.filename
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="m"
          s:=fib.filename
          WHILE (s[]<>0) AND (s[]<>".") DO out[]++:=s[]++
        ELSEIF command[]="e"
          s:=fib.filename
          WHILE (s[]<>0) AND (s[]<>".") DO INC s
          IF s[]<>0 THEN INC s
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="p"
          t:=NIL
          s:=u:=allname
          WHILE s[]<>0
            IF s[]="/" THEN t:=s+1
            IF s[]=":" THEN u:=s+1
            INC s
          ENDWHILE
          IF t
            s:=u
            DEC t
            WHILE s<>t DO out[]++:=s[]++
          ENDIF
        ELSEIF command[]="v"
          t:=NIL
          s:=allname
          WHILE s[]<>0
            IF s[]=":" THEN t:=s
            INC s
          ENDWHILE
          IF t
            s:=allname
            WHILE s<>t DO out[]++:=s[]++
          ENDIF
        ELSEIF command[]="c"
          s:=fib.comment
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="d"
          s:=date
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="t"
          s:=time
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="s"
          StringF(str,'\d',fib.size)
          s:=str
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="y"
          s:=type
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="k"
          StringF(str,'\d',fib.diskkey)
          s:=str
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="b"
          StringF(str,'\d',fib.numblocks)
          s:=str
          WHILE s[]<>0 DO out[]++:=s[]++
        ELSEIF command[]="r"
          s:=protection
          WHILE s[]<>0 DO out[]++:=s[]++
        ENDIF
      ENDIF
    ELSE
      out[]++:=command[]
    ENDIF
    INC command
  ENDWHILE
  out[]++:="\n"
  out[]:=0
ENDPROC

PROC dotype()
  DEF s,t,known
  s:=types+12
  WHILE s[]<>"ÿ"
    t:=type
    known:=TRUE
    WHILE s[]<>";"
      IF s[]<>"?" THEN IF s[]<>t[] THEN known:=FALSE
      INC s
      INC t
    ENDWHILE
    INC s
    IF known
      StrCopy(type,s,ALL)
      RETURN
    ENDIF
    WHILE s[]++<>0 DO NOP
  ENDWHILE
  StrCopy(type,'UNKNOWN',ALL)
ENDPROC

CHAR '$VER: '
program: CHAR 'All 1.4 (28-9-97) © Frédéric Rodrigues - Registered\nGive wildcards and multiple arguments to commands + Listing utility',0
error: CHAR 'All error',0
