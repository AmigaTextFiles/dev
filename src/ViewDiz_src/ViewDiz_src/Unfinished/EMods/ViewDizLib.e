OPT MODULE

MODULE  'dos/var','dos/dos','dos/rdargs','dos/dostags',
        'utility/tagitem','utility','utility/hooks'

EXPORT MODULE '*external'

CONST   MAXLEN=2000,
        LIBVER_UTILITY = 37

OBJECT vdMiscConfig
  editor
  edargs
  tabu
ENDOBJECT

OBJECT filetype
  type, id, pos
ENDOBJECT

EXPORT PROC vdExamine( file, finf:PTR TO vdFileInfo, cfg:PTR TO vdConfig )
  DEF fib:PTR TO fileinfoblock, lock, header[11]:STRING, type, rc=TRUE

  finf.cfg := cfg

  -> GET FILEINFOBLOCK
  IF fib:=AllocDosObject( DOS_FIB, NIL )
    IF lock := Lock(file, ACCESS_READ)
      NameFromLock( lock, finf.filename, 100 )
      Examine(lock, fib)
      UnLock(lock)
      CopyMem( fib, finf.fib, SIZEOF fileinfoblock )
    ELSE
      rc:=FALSE
    ENDIF
    FreeDosObject( DOS_FIB, fib )
  ENDIF

  -> RUN SOME CHECKS ON THE FILE
  IF vdGetHeader( file, header, StrMax(header) )
    -> XPKPACKED ?
    IF vdCheckXpk( header ) THEN finf.xpk:=TRUE ELSE finf.xpk:=FALSE

    -> FILETYPE ?
    finf.configitem := vdMatchPattern( file, cfg )
    IF finf.configitem = -1
      type:=vdCheckBin(header)
      IF type<>FALSE
        finf.configitem := vdMatchPattern( type, cfg )
        DisposeLink(type)
      ENDIF
    ENDIF
  ENDIF
ENDPROC rc

EXPORT PROC vdRunModule( finf:PTR TO vdFileInfo, command )
  DEF s[512]:STRING,i, args[255]:STRING, rc=FALSE, oldlock=NIL,
      cmdstr, arglen

  -> CHECK FOR A VALID MODULE
  i:=finf.configitem
  IF i=-1 THEN RETURN FALSE

  -> BIN_CMD«»ASCII_CMD
  cmdstr:=[0,'read','delete','write','info','execute','edit']

  -> CHANGE TO TEMPDIRECTORY
  IF finf.cfg.desclock<>NIL THEN
    oldlock:=CurrentDir( finf.cfg.desclock )

  -> LOAD & RUN BINARY-TYPE MODULE. REMEMBER TO UNLOAD BEFORE EXIT !
  IF finf.cfg.module[i].seglist=NIL THEN
    finf.cfg.module[i].seglist:=LoadSeg(finf.cfg.module[i].module)

  IF finf.cfg.module[i].seglist<>NIL
    StringF( args, 'file="\s" cmd=\s desc="\s" finf=\d\n',
             finf.filename, ListItem(cmdstr,command), FilePart(finf.cfg.descfile), finf )


    IF RunCommand( finf.cfg.module[i].seglist, 4096, args, StrLen(args))=0 THEN
      rc:=TRUE

  ELSE
    -> RUN ORDINARY SCRIPT-TYPE MODULE
    StringF( args, '"\s" file="\s" cmd="\s" desc="\s"', finf.cfg.module[i].module, finf.filename, ListItem(cmdstr,command), FilePart(finf.cfg.descfile) )
    StringF( s, 'execute \s', args)
    rc:=Execute( s, NIL, NIL )

  ENDIF

  -> FIND OLD DIRECTORY
  IF oldlock<>NIL THEN
    CurrentDir(oldlock)

ENDPROC rc

EXPORT PROC vdLoadWizards( wizlist, cfg:PTR TO vdConfig )
  DEF rdargs, subrdargs, args=NIL:PTR TO LONG, subargs:PTR TO LONG,
      rda:PTR TO rdargs, str, i=0, j=0

  IF rda:=AllocDosObject( DOS_RDARGS, 0 )
    str:=strcat( wizlist, '\n' )
    rda.source.buffer := str
    rda.source.length := StrLen( str )
    rda.source.curchr := NIL
    rda.buffer        := NIL
    IF rdargs:=ReadArgs( 'WZ/M', {args}, rda )
      WHILE args[i]
        DisposeLink(str)
        str:=strcat( args[i], '\n' )
        rda.source.buffer := str
        rda.source.length := StrLen( str )
        rda.source.curchr := NIL
        rda.buffer        := NIL
        IF subrdargs:=ReadArgs( 'CMD/A,ARG/F', subargs:=[0,0], rda )
          cfg.wizard[j].command   := strcat( 'ViewDiz:Wizards/', subargs[0] )
          cfg.wizard[j].arguments := estr( subargs[1] )
          cfg.wizard[j].seglist   := LoadSeg( cfg.wizard[j].command )
          INC j
          FreeArgs(subrdargs) ; subrdargs:=0
        ENDIF
        INC i
      ENDWHILE
      FreeArgs(rdargs)
    ENDIF

    FreeDosObject( DOS_RDARGS, rda )
  ENDIF
ENDPROC j


EXPORT PROC vdUnloadWizards( cfg:PTR TO vdConfig )
  DEF i=0
  WHILE cfg.wizard[i].command<>NIL
    DisposeLink( cfg.wizard[i].arguments )
    DisposeLink( cfg.wizard[i].command )
    cfg.wizard[i].command:=NIL
    IF cfg.wizard[i].seglist<>NIL
      UnLoadSeg( cfg.wizard[i].seglist )
      cfg.wizard[i].seglist:=NIL
    ENDIF
    INC i
  ENDWHILE
ENDPROC


EXPORT PROC vdRunWizards( finf:PTR TO vdFileInfo  )
  DEF s[512]:STRING, i=0, ret=-1, arg[200]:STRING, rc=FALSE

  IF finf.filename
    WHILE finf.cfg.wizard[i].command
      StringF(  arg, 'file="\s" desc="\s" \s\n', finf.filename, finf.cfg.descfile,
                finf.cfg.wizard[i].arguments )

      IF finf.cfg.wizard[i].seglist<>NIL
        IF RunCommand( finf.cfg.wizard[i].seglist, 4096, arg, StrLen(arg) )=0 THEN
          rc:=TRUE

      ELSE
        StringF( arg, 'execute \s \s', finf.cfg.wizard[i].command, arg )
        rc:=Execute( arg,0,0 )
      ENDIF

      INC i
    ENDWHILE
  ENDIF

ENDPROC rc

EXPORT PROC vdEditFile( file, cfg:PTR TO vdConfig )
  DEF s[MAXLEN]:STRING, rc=FALSE
  StringF( s, '"\s" \s "\s"', cfg.editor, cfg.edargs, file )
  IF SystemTagList( s, [NP_SYNCHRONOUS, TRUE, TAG_DONE] )=0 THEN rc:=TRUE
ENDPROC rc

EXPORT PROC vdTrimString( string, tabulist )
  DEF temp[2]:STRING, note[MAXLEN]:STRING
  WHILE string[]
    temp[] := string[]++
    IF InStr( tabulist, temp ) = -1 THEN StrAdd( note, temp )
  ENDWHILE
ENDPROC estr( TrimStr(note) )

EXPORT PROC vdVersionInfo( finf:PTR TO vdFileInfo )
  DEF cmd[256]:STRING, rc=FALSE, out

  IF out:=Open('NIL:', NEWFILE)
    StringF( cmd, 'version "\s" full >"\s"', finf.filename, finf.cfg.descfile )

    IF SystemTagList( cmd, [SYS_OUTPUT, out, NP_SYNCHRONOUS, TRUE, TAG_DONE] )<>0
      DeleteFile( finf.cfg.descfile )
    ELSE
      rc:=TRUE
    ENDIF
  Close(out)
  ENDIF
ENDPROC rc

EXPORT PROC vdStartup(templock)
  DEF args:PTR TO vdModule, rdargs=NIL, rda:PTR TO rdargs, rc=FALSE,
      len, listlen, list, cnt=0:PTR TO CHAR, str[1024]:STRING, i=0,
      cfg:PTR TO vdConfig, mem=NIL,
      miscargs:PTR TO vdMiscConfig

  IF templock=NIL THEN RETURN FALSE

  -> READ CONFIGFILE FROM DISK
  mem:=String(FileLength('env:.modules'))
  IF (len:=GetVar('.modules', mem, StrMax(mem), GVF_BINARY_VAR)) > 0
    listlen := countstrings(mem,len)
    list    := stringsinfile( mem, len, listlen )

    ->ALLOC MEM FOR CONFIGURATION
    cfg      := New( SIZEOF vdConfig )
    cfg.tabu := String(200)

    -> GET INFO ABOUT TEMPDIR
    cfg.desclock := templock
    cfg.descfile := String(100)
    NameFromLock( cfg.desclock, cfg.descfile, StrMax(cfg.descfile) )
    AddPart( cfg.descfile, 'file_id.diz', StrMax(cfg.descfile) )

    -> CONFIGURATION FILE
    IF rda:=AllocDosObject( DOS_RDARGS, NIL )

      -> GET MISC CONFIGURATION
      StringF( str, '\s\n', ListItem(list,cnt++) )
      rda.source.buffer := str
      rda.source.length := StrLen( str )
      rda.source.curchr := NIL
      rda.buffer        := NIL
      IF miscargs := New( SIZEOF vdMiscConfig )
        IF rdargs := ReadArgs( 'EDITOR/K,EDARGS/K,TABU/F', miscargs, rda)
          cfg.editor:=estr( miscargs.editor )
          cfg.edargs:=estr( miscargs.edargs )
          cfg.tabu  :=estr( miscargs.tabu )
          FreeArgs(rdargs)
        ENDIF
        Dispose(miscargs)
      ENDIF

      -> GET MODULE INFORMATION
      args := New( SIZEOF vdModule )
      WHILE cnt<>listlen
        StringF( str, '\s\n', ListItem(list,cnt++) )
        rda.source.buffer := str
        rda.source.length := StrLen( str )
        rda.source.curchr := NIL
        rda.buffer        := NIL
        IF rdargs := ReadArgs( 'M,F,I,D,P,F', args, rda)
          cfg.module[i].module  := strcat('ViewDiz:Modules/', args.module)
          cfg.module[i].flags   := LowerStr(estr(args.flags))
          cfg.module[i].item    := estr(args.item)
          cfg.module[i].default := estr(args.default)
          cfg.module[i].pattern := estr(args.pattern)
          cfg.module[i].filetype:= estr(args.filetype)
          FreeArgs( rdargs )
          rc:=cfg
          INC i
        ENDIF
      ENDWHILE
      cfg.module[i].module:=NIL
      Dispose(args)
      FreeDosObject( DOS_RDARGS, rda )
    ENDIF
    DisposeLink(list)
  ENDIF
  DisposeLink(mem)
ENDPROC rc

EXPORT PROC vdFreeStartup( cfg:PTR TO vdConfig )
  DEF i=0

  vdUnLoadModules(cfg)

  WHILE cfg.module[i].module
    DisposeLink(cfg.module[i].module)
    DisposeLink(cfg.module[i].flags)
    DisposeLink(cfg.module[i].item)
    DisposeLink(cfg.module[i].default)
    DisposeLink(cfg.module[i].pattern)
    DisposeLink(cfg.module[i].filetype)
    INC i
  ENDWHILE

  DisposeLink(cfg.descfile)
  DisposeLink(cfg.tabu)
  Dispose(cfg)
ENDPROC

EXPORT PROC vdAllocObject(objecttype)
  DEF finf:PTR TO vdFileInfo, rc=FALSE
  IF objecttype=VDO_FILEINFO
    finf          := New( SIZEOF vdFileInfo )
    finf.fib      := New( SIZEOF fileinfoblock )
    finf.filename := String(100)
    rc:=finf
  ENDIF
ENDPROC rc

EXPORT PROC vdFreeObject( objecttype, object )
  DEF finf:PTR TO vdFileInfo
  IF objecttype=VDO_FILEINFO
    finf:=object
    DisposeLink( finf.filename )
    Dispose( finf.fib )
    Dispose( finf )
  ENDIF
ENDPROC




/*****************************************************************
 *                                                               *
 *                                                               *
 *                     NON EXPORTED ROUTINES                     *
 *                                                               *
 *                                                               *
 *****************************************************************/

PROC vdGetHeader( file, mem, memlen )
  DEF fh, x:PTR TO CHAR, i, rc=FALSE
  IF fh:=Open( file, OLDFILE )
    FOR i:=0 TO memlen
      x := FgetC(fh)
      IF x=0 THEN x:=20
      mem[i] := x
    ENDFOR
    Close( fh )
    rc:=TRUE
  ENDIF
ENDPROC rc

PROC vdMatchPattern( file, cfg:PTR TO vdConfig )
  DEF i=0, parsed[200]:STRING, rc=-1, name[100]:STRING
  StrCopy( name, FilePart(file) )
  WHILE cfg.module[i].module
    ParsePatternNoCase( cfg.module[i].pattern, parsed, (2*StrLen(cfg.module[i].pattern)+2) )
    IF MatchPatternNoCase(parsed, name) <> FALSE
      rc:=i
      JUMP end
    ENDIF
    INC i
  ENDWHILE
end:
ENDPROC rc

PROC vdCheckXpk( header )
  DEF localvar:PTR TO CHAR, rc=FALSE
  localvar:='xpkstatus'
  IF InStr( header, 'XPKF' ) = 0
    SetVar( localvar, '1', 1, GVF_LOCAL_ONLY )
    rc:=TRUE
  ELSE
    SetVar( localvar, '0', 1, GVF_LOCAL_ONLY )
  ENDIF
ENDPROC rc

PROC vdCheckBin( header )
  DEF t:PTR TO filetype
  t := [
    '.xpk',  'XPKF',  0,
    '.iff',  'ILBM',  8,
    '.gif',  'GIF',   0,
    '.lzx',  'LZX',   0,
    '.jpg',  'JFIF',  6,
    '.dms',  'DMS!',  0,
    '.lha',  '-lh0-', 2,
    '.lha',  '-lh5-', 2,
    'med.',  'MMD',   0,
    'psid.', 'PSID',  0,
    'thx.',  'THX',   0,
    NIL,     NIL,     0
  ]
  WHILE t[].type
    IF StrCmp(header+t[].pos, t[].id, StrLen(t[].id))
      RETURN estr( t[].type )
    ENDIF
    t++
  ENDWHILE
ENDPROC FALSE

PROC vdUnLoadModules( cfg:PTR TO vdConfig )
  DEF i=0
  WHILE cfg.module[i].module
    IF cfg.module[i].seglist<>NIL THEN
      IF UnLoadSeg( cfg.module[i].seglist )<>0 THEN
        cfg.module[i].seglist:=NIL
    INC i
  ENDWHILE
ENDPROC

-> Convert string to estring using dynamic allocation
PROC estr( str )
  DEF estr
  estr:=String( StrLen(str) )
  StrCopy( estr, str )
ENDPROC estr

-> Add strings. Return estring.
PROC strcat( str1, str2, str3=NIL, str4=NIL, str5=NIL )
  DEF rc
  rc:=String( StrLen(str1)+StrLen(str2)+StrLen(str3)+StrLen(str4)+StrLen(str5) )
  StringF(rc, '\s\s\s\s\s', str1,str2,str3,str4,str5)
ENDPROC rc

/* ------------------- file.m --------------------*/
PROC countstrings(mem,len)
  MOVE.L mem,A0
  MOVE.L A0,D1
  ADD.L  len,D1
  MOVEQ  #0,D0
  MOVEQ  #10,D2
strings:
  ADDQ.L #1,D0
findstring:
  CMP.B  (A0)+,D2
  BNE.S  findstring
  CMPA.L D1,A0
  BMI.S  strings
ENDPROC D0

PROC stringsinfile(mem,len,max)
  DEF list,l
  IF (list:=List(max))=NIL THEN RETURN FALSE
  MOVE.L list,A1
  MOVE.L max,D3
  MOVE.L mem,A0
  MOVE.L A0,D1
  ADD.L  len,D1
  MOVEQ  #0,D0
  MOVEQ  #10,D2
stringsl:
  CMP.L  D3,D0
  BPL.S  done
  ADDQ.L #1,D0
  MOVE.L A0,(A1)+
findstringl:
  CMP.B  (A0)+,D2
  BNE.S  findstringl
  CLR.B  -1(A0)
  CMPA.L D1,A0
  BMI.S  stringsl
done:
  MOVE.L D0,l
  SetList(list,l)
ENDPROC list
