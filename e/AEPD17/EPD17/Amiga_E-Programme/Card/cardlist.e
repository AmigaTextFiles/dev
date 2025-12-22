MODULE 'workbench/startup', 'workbench/workbench', 'icon'

CONST MEMSTART=$600000, BLOCKSIZE=$100, FILEINFOSIZE=$20, MAGIC=$2000
CONST HEADEROFF=2*BLOCKSIZE, BLKPTRSIZE=2, FILELEN=13
CONST FREEOFF=HEADEROFF+BLOCKSIZE, HEADER=HEADEROFF+MEMSTART
CONST FREEBLOCKS=FREEOFF+MEMSTART, EOFB=$FFFE, EOC=$FFFF, DEL=0, START=0
CONST VERB_COLS=2, NOVERB_COLS=3

ENUM NO_ERR, BAD_CARD, NO_FREE, OPEN_LIB

OBJECT fileinfo
  file, next
ENDOBJECT

RAISE OPEN_LIB IF OpenLibrary()=NIL

/* lastinfo is a block pointer with MAGIC, e.g., $213A (not $13A) */
DEF thefiles:PTR TO fileinfo, lastfile:PTR TO fileinfo, lastinfo

PROC main() HANDLE
  DEF f:PTR TO fileinfo, i=0, verbose=FALSE, startup:PTR TO wbstartup,
      args=FALSE, rdargs=NIL, templ, wargs:PTR TO wbarg, oldlock=NIL,
      dobj:PTR TO diskobject
  iconbase:=OpenLibrary('icon.library', 33)
  IF startup:=wbmessage
    IF startup.numargs>=1
      wargs:=startup.arglist
      IF wargs.lock THEN oldlock:=CurrentDir(wargs.lock)
      IF wargs.name
        IF dobj:=GetDiskObject(wargs.name)
          verbose:=FindToolType(dobj.tooltypes, 'VERBOSE')
          FreeDiskObject(dobj)
        ENDIF
      ENDIF
      IF oldlock THEN CurrentDir(oldlock)
    ENDIF
  ELSE
    templ:='V=VERBOSE/S'
    rdargs:=ReadArgs(templ,{args},NIL)
    IF rdargs THEN verbose:=args
  ENDIF
  getinfo()
  f:=thefiles.next
  WHILE f
    printfile(f.file, {i}, verbose)
    f:=f.next
  ENDWHILE
  printfile(NIL, {i}, verbose)  /* Trailing linefeed? */
  Raise(NO_ERR)
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF iconbase THEN CloseLibrary(iconbase)
  SELECT exception
  CASE OPEN_LIB
    WriteF('Could not open icon library\n')
  CASE BAD_CARD
    WriteF('No PCMCIA card, or not from Notepad\n')
  CASE NO_FREE
    WriteF('No more free blocks -- card is full\n')
  ENDSELECT
ENDPROC

PROC printfile(file, count, verbose)
  IF file
    IF deleted(file)=FALSE
      ^count:=^count+1
      IF verbose
        WriteF('\l\s[12]  \r\d[5]', filename(file), filesize(file))
        printdate(file)
        WriteF(IF Mod(^count, VERB_COLS)=0 THEN '\n' ELSE '   ')
      ELSE
        WriteF('\l\s[12]  \r\d[5]\s', filename(file), filesize(file),
               IF Mod(^count, NOVERB_COLS)=0 THEN '\n' ELSE '   ')
      ENDIF
    ENDIF
  ELSE
    IF Mod(^count, IF verbose THEN VERB_COLS ELSE NOVERB_COLS)<>0
      WriteF('\n')
    ENDIF
  ENDIF
ENDPROC

PROC printdate(file)
  DEF date, year, month, day, hour, min
  date:=filedate(file)
  year:=Mod(90+Shr(date, 25), 100)
  month:=Shr(date AND $1FFFFFF, 21)
  IF (month>12) OR (month<1) THEN month:=0
  day:=Shr(date AND $1FFFFF, 16)
  hour:=Shr(date AND $FFFF, 11)
  min:=Shr(date AND $7FF, 5)
  WriteF(' \r\d[2]-\s-\z\d[2] \r\d[2]:\z\d[2]', day,
         ListItem(['XXX', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                   'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], month),
         year, hour, min)
ENDPROC

PROC getinfo()
  DEF info, nofiles=FALSE, atend=FALSE, file
  file:=HEADER
  lastinfo:=firstblock(file)
  thefiles:=lastfile:=newfile(file)
  IF validate(file)
    file:=file+FILEINFOSIZE
    REPEAT   /* for all info blocks */
      REPEAT /* for all files */
        IF blank(file)
          nofiles:=TRUE
        ELSE
          lastfile.next:=newfile(file)
          lastfile:=lastfile.next
          file:=file+FILEINFOSIZE
          IF Mod(file, BLOCKSIZE)=0 THEN atend:=TRUE
        ENDIF
      UNTIL atend OR nofiles
      IF atend
        info:=follow(lastinfo)
	IF (info<>EOC) AND (info<>DEL)
          lastinfo:=info
          file:=address(lastinfo)
          atend:=FALSE
        ELSE
          nofiles:=TRUE
        ENDIF
      ENDIF
    UNTIL nofiles
  ELSE
    Raise(BAD_CARD)
  ENDIF
ENDPROC

PROC follow(block) RETURN int(blockaddr(block))
PROC blockaddr(block) RETURN (block-MAGIC)*BLKPTRSIZE+FREEBLOCKS
PROC address(block) RETURN (block-MAGIC)*BLOCKSIZE+MEMSTART

PROC validate(file)
  RETURN StrCmp(filename(file), 'NC', 2) AND
        (firstblock(file)=HEADEROFF+MAGIC)
ENDPROC

PROC blank(file)
  DEF n
  FOR n:=0 TO FILEINFOSIZE-1 DO IF file[]++<>0 THEN RETURN FALSE
ENDPROC TRUE

PROC filename(file) RETURN file
PROC filesize(file) RETURN int(file+14)
PROC filedate(file) RETURN long(file+16)
PROC firstblock(file) RETURN int(file+20)
PROC deleted(file) RETURN file[]=0
PROC int(p) RETURN p[]++ OR Shl(p[],8)
PROC long(p) RETURN p[]++ OR Shl(p[]++,8) OR Shl(p[]++,16) OR Shl(p[],24)

PROC newfile(ptr)
  DEF p
  CopyMem([ptr, NIL]:fileinfo, p:=New(SIZEOF fileinfo), SIZEOF fileinfo)
ENDPROC p
