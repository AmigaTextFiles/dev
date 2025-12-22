OPT MODULE

MODULE  'dos/var','dos/dos','dos/rdargs','dos/dostags',
        'utility/tagitem','utility','utility/hooks'

EXPORT MODULE '*external'

CONST   MAXLEN=2000,
        LIBVER_UTILITY = 37

OBJECT vdArgs
  module, flags, item, default, pattern, filetype
ENDOBJECT

OBJECT filetype
  type, id, pos
ENDOBJECT

EXPORT PROC vdAllocObject( objecttype )
  DEF finf:PTR TO vdFileInfo, rc=FALSE
  IF objecttype=VDO_FILEINFO
    finf          := New( SIZEOF vdFileInfo )
    finf.fib      := New( SIZEOF fileinfoblock )
    finf.filename := String(100)
    rc:=finf
  ENDIF
ENDPROC rc

EXPORT PROC vdFreeObject( object, objecttype )
  DEF finf:PTR TO vdFileInfo
  IF objecttype=VDO_FILEINFO
    finf:=object
    DisposeLink( finf.filename )
    Dispose( finf.fib )
    Dispose( finf )
  ENDIF
ENDPROC

EXPORT PROC vdExamineFile( finf:PTR TO vdFileInfo, file, cfg:PTR TO vdConfig )
  DEF fib:PTR TO fileinfoblock, lock, header[11]:STRING, type, rc=TRUE

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

  finf.cfg := cfg

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

PROC vdMatchPattern( file, cfg:PTR TO vdConfig )
  DEF i=0, parsed[200]:STRING, rc=-1, name[100]:STRING
  StrCopy( name, FilePart(file) )
  WHILE cfg.module[i]
    ParsePatternNoCase( cfg.pattern[i], parsed, (2*StrLen(cfg.pattern[i])+2) )
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

/***** vdRunModule
 * =	Execute an external module
 * i	module,A0,STRPTR = Module name with full path
 * i	file,A0,STRPTR = File to precess
 * i	command,D1,STRPTR = Command to send to module
 * i	descdir,D0,STRPTR = Description directory (task specific)
 * r	bool,D0 = True (-1) or False (0)
 * f  Run an external filetype-module. Depending on which command you send
 *  to the module it will do different things:
 *  READ    - Generates 'file_id.diz' in the descdir
 *  WRITE   - Write 'file_id.diz' to the file
 *  DELETE  - Remove description from file
 *  EDIT    - Starts a specil description editor
 *  EXECUTE - Perform a specific action on the file (unpack, view etc.)
 *  INFO    - Sets global variable 'viewdiz/.minf' with info about the
 *            module. Here you should set the file to module
 *  To determine which commands a module supports, you can check the
 *  VdCfg.flags for 'RWDEX' - INFO is always supported
 ******/
EXPORT PROC vdRunModule( finf:PTR TO vdFileInfo, command )
  DEF s[512]:STRING,i, args[255]:STRING, rc=FALSE, oldlock=NIL,
      eargs:PTR TO vdExternalArgs, cmdstr

  -> CHECK FOR A VALID MODULE
  i:=finf.configitem
  IF i=-1 THEN RETURN FALSE

  -> BIN_CMD«»ASCII_CMD
  cmdstr:=[0,'read','delete','write','info','execute','edit']

  -> CHANGE TO TEMPDIRECTORY
  IF finf.cfg.desclock<>NIL THEN
    oldlock:=CurrentDir( finf.cfg.desclock )

  -> LOAD & RUN BINARY-TYPE MODULE. REMEMBER TO UNLOAD BEFORE EXIT !
  IF finf.cfg.seglist[i]=NIL THEN
    finf.cfg.seglist[i]:=LoadSeg(finf.cfg.module[i])

  IF finf.cfg.seglist[i]<>NIL
    eargs:=New(SIZEOF vdExternalArgs)
    eargs.command:=command
    eargs.finf:=finf
    StringF( args, 'file="\s" cmd=\s desc="\s" object=\d\n',
             finf.filename, ListItem(cmdstr,command), finf.cfg.descfile, eargs )
    IF RunCommand( finf.cfg.seglist[i], 4096, args, StrLen(args))=0 THEN
      rc:=TRUE

  ELSE
    -> RUN ORDINARY SCRIPT-TYPE MODULE
    StringF( args, '"\s" file="\s" cmd="\s" desc="\s"', finf.cfg.module[i], finf.filename, ListItem(cmdstr,command), finf.cfg.descfile )
    StringF( s, 'execute \s', args)
    rc:=Execute( s, NIL, NIL )

  ENDIF

  -> FIND OLD DIRECTORY
  IF oldlock<>NIL THEN
    CurrentDir(oldlock)

ENDPROC rc

PROC vdLoadModules( cfg:PTR TO vdConfig )
  DEF i=0
  WHILE cfg.module[i]
    IF InStr( cfg.flags[i], 'p' )<>-1
      cfg.seglist[i]:=LoadSeg( cfg.module[i] )
    ELSE
      cfg.seglist[i]:=NIL
    ENDIF
    INC i
  ENDWHILE
ENDPROC

PROC vdUnLoadModules( cfg:PTR TO vdConfig )
  DEF i=0
  WHILE cfg.module[i]
    IF cfg.seglist[i]<>NIL THEN
      IF UnLoadSeg( cfg.seglist[i] )<>0 THEN
        cfg.seglist[i]:=NIL
    INC i
  ENDWHILE
ENDPROC

EXPORT PROC vdRunWizard( finf:PTR TO vdFileInfo, wizard, wz:PTR TO vdWizard )
  DEF s[512]:STRING, i=0, ret=-1, arg[200]:STRING

  IF StrLen(wizard)=0 THEN RETURN FALSE

  -> CHECK IF WIZARD IS PRELOADED
  WHILE wz.name[i]
    IF StrCmp( UpperStr(wizard), wz.name[i] ) THEN ret:=i
    INC i
  ENDWHILE
  IF ret=-1
    -> NOT PRELOADED - TRY TO LOAD IT
    wz.seglist[i]:=LoadSeg( wizard )
    IF wz.seglist[i]<>NIL THEN wz.name[i] := estr( wizard )
  ELSE
    -> PRELOADED !
    i:=ret
  ENDIF

  StringF( arg, 'file="\s" desc="\s"', finf.filename, finf.cfg.descfile )

  IF wz.seglist[i]<>NIL
    -> RUN EXECUTABLE WIZARD
  ELSE
    -> RUN SCRIPT WIZARD
    -> StringF( s, 'execute env:viewdiz/wizards/\s file="\s" desc="\s"', wizard, finf.filename, finf.cfg.descfile )
  ENDIF

ENDPROC Execute(s,NIL,NIL)

EXPORT PROC vdEditDesc( finf:PTR TO vdFileInfo )
  DEF s[MAXLEN]:STRING, rc=FALSE
  StringF( s, 'execute >NIL: env:viewdiz/.editor "\s/\s"', finf.cfg.descdir, finf.cfg.descfile )
  IF SystemTagList( s, [NP_SYNCHRONOUS, TRUE, TAG_DONE] )=0 THEN rc:=TRUE
ENDPROC rc

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

PROC vdWrapStr(string,dest,destlen)
  DEF l,n,s,d
  d:=String(MAXLEN)
  StrCopy( d, string )
  l:=EstrLen( d )
  n:=InStr( d, '\n' )
  s:=InStr( d, ' ', 40 )
  IF n>=(l-1)
    SetStr( d, l-1 )
    n:=-1
  ENDIF
  IF (l>50) AND (n=-1) AND (s>39)
    d[s]:="\n"
    CopyMem(TrimStr(d), dest, destlen)
    RETURN
  ENDIF
  IF InStr( d, '\n', l-1 )<>-1 THEN SetStr( d, l-1 )
  CopyMem(d, dest, destlen)
ENDPROC

EXPORT PROC vdTrimStr( string, dest, destlen, charlist )
  DEF temp[2]:STRING, note[MAXLEN]:STRING
  WHILE string[]
    temp[] := string[]++
    IF InStr( charlist, temp ) = -1 THEN StrAdd( note, temp )
  ENDWHILE
  CopyMem( TrimStr(note), dest, destlen)
ENDPROC

EXPORT PROC vdGetVersion(file, destfile)
  DEF cmd[256]:STRING, rc=FALSE, out

  IF out:=Open('NIL:', NEWFILE)
    StringF( cmd, 'version "\s" full >"\s"', file, destfile )
    IF SystemTagList( cmd, [SYS_OUTPUT, out, NP_SYNCHRONOUS, TRUE, TAG_DONE] )<>0
      DeleteFile( destfile )
    ELSE
      rc:=TRUE
    ENDIF
  Close(out)
  ENDIF
ENDPROC rc

/***** vdStartup
 * =  Retrieve essential information about external modules etc.
 * i  configfile,D0,STRPTR = Name of configuration file.
 * r  result,D0,struct VdCfg = a structure, VdCfg
 *  Zero is returned if failure.
 * f  Reads specified configurationfile which must follow the proper
 *  template. The global variable ViewDiz/.tabu is also loaded, and a
 *  special directory name for temporary files is generated. Memory
 *  allocated with this call MUST be freed with a corresponding call to
 *  vdFreeConfig().
 * s	vdFreeConfig()
 ******/
EXPORT PROC vdStartup(templock,configfile=NIL:PTR TO CHAR)
  DEF args:PTR TO vdArgs, rdargs=NIL, rda:PTR TO rdargs, rc=FALSE,
      len, listlen, list, cnt=0:PTR TO CHAR, str[1024]:STRING, i=0,
      cfg:PTR TO vdConfig, mem=NIL

  IF templock=NIL THEN RETURN FALSE
  IF configfile=NIL THEN configfile:='env/viewdiz/.modules'

  -> READ CONFIGFILE FROM DISK
  mem:=String(FileLength(configfile))
  IF (len:=vdReadFile(configfile, mem, StrMax(mem))) > 0
    listlen := countstrings(mem,len)
    list    := stringsinfile( mem, len, listlen )

    ->READ EXTRA CONFIGFILES FROM DISK
    cfg      := New( SIZEOF vdConfig )
    cfg.tabu := String(200)
    GetVar( 'viewdiz/.tabu', cfg.tabu, StrMax(cfg.tabu), GVF_BINARY_VAR )

    -> SET DESCRIPTION SPECS
    cfg.desclock := templock
    cfg.descfile := estr( 'file_id.diz' )
    cfg.descdir  := String(100)
    NameFromLock( cfg.desclock, cfg.descdir, StrMax(cfg.descdir) )

    -> RETRIEVE CONFIGURATION DATA
    IF rda:=AllocDosObject( DOS_RDARGS, NIL )
      args := New( SIZEOF vdArgs )
      WHILE cnt<>listlen

        -> INITIALIZE READARGS OBJECT
        StringF( str, '\s\n', ListItem(list,cnt++) )
        rda.source.buffer := str
        rda.source.length := StrLen( str )
        rda.source.curchr := NIL
        rda.buffer        := NIL
        IF rdargs := ReadArgs( 'M,F,I,D,P,F', args, rda)

          -> COPY ARGDATA INTO STRINGS
          cfg.module[i]  := estr(args.module)
          cfg.flags[i]   := estr(args.flags)
          cfg.item[i]    := estr(args.item)
          cfg.default[i] := estr(args.default)
          cfg.pattern[i] := estr(args.pattern)
          cfg.filetype[i]:= estr(args.filetype)
          FreeArgs( rdargs )
          rc:=cfg
          INC i
        ENDIF
      ENDWHILE
      cfg.module[i]:=NIL
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

  WHILE cfg.module[i]
    DisposeLink(cfg.module[i])
    DisposeLink(cfg.flags[i])
    DisposeLink(cfg.item[i])
    DisposeLink(cfg.default[i])
    DisposeLink(cfg.pattern[i])
    DisposeLink(cfg.filetype[i])
    INC i
  ENDWHILE

  DisposeLink(cfg.descdir)
  DisposeLink(cfg.descfile)
  DisposeLink(cfg.tabu)
  Dispose(cfg)
ENDPROC

EXPORT PROC vdReadFile(file, mem, memlen)
  DEF fh, len=FALSE
  IF fh:=Open( file, MODE_OLDFILE)
    len:=Read(fh,mem,memlen)
    Close( fh )
  ENDIF
ENDPROC len

-> Convert string to estring using dynamic allocation
PROC estr( str )
  DEF estr
  estr:=String( StrLen(str) )
  StrCopy( estr, str )
ENDPROC estr

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

/*
EXPORT PROC vdVersatile( string, dest, destlen, tags:PTR TO tagitem, cfg:PTR TO vdConfig )
  DEF rc=FALSE
  IF utilitybase:=OpenLibrary( 'utility.library', LIBVER_UTILITY )
    IF TagInArray( VDT_TRIM, tags ) THEN rc:=vdTrimStr( string, dest, destlen, cfg.tabu )
    IF TagInArray( VDT_WRAP, tags ) THEN rc:=vdWrapStr( string, dest, destlen )
    IF TagInArray( VDT_READFILE, tags ) THEN rc:=vdReadFile( string, dest, destlen )
    IF TagInArray( VDT_WRITEFILE, tags ) THEN rc:=vdWriteStr( string, dest, destlen )
    CloseLibrary( utilitybase )
  ENDIF
ENDPROC rc
*/