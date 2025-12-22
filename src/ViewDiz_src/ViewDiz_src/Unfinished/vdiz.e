MODULE  '*emods/viewdiz', '*emods/match', '*emods/external',
        'dos/dos', 'dos/var', 'dos/rdargs', 'dos/dostags', 'dos/dosasl'

OBJECT myargs
  file:PTR TO LONG, to, kill, execute, autosave, savenote,
  edit, uppercase, lowercase, pubscreen, font:PTR TO CHAR,
  fontsize:PTR TO LONG, keepdiz, quiet
ENDOBJECT

DEF args:PTR TO myargs,cfg:PTR TO vdConfig,finf:PTR TO vdFileInfo,
    descfile[30]:STRING

PROC main()
  DEF rdargs=NIL, pat[200]:STRING, file:PTR TO LONG, i=0, lock=NIL,
      buf[200]:STRING, number=0, tmpl

  args  := NEW [ 0,0,0,0,0,0,  0,0,0,0,0,  0,1,0 ]
  tmpl  := 'FILE/M,TO/K,KILL/S,EXECUTE=EX/S,AUTOSAVE=AS/S,SAVENOTE=SN/S,'+
           'EDIT=ED/S,UPPERCASE=UC/S,LOWERCASE=LC/S,'+
           'PUBSCREEN=PS/K,FONT=F/K,FONTSIZE=FS/K/N,KEEPDIZ=KD/T,QUIET=Q/S'

  IF rdargs:=ReadArgs( tmpl, args, NIL )

    IF lock:=Lock( 't:', SHARED_LOCK )
      IF cfg:=vdStartup(lock,NIL)
        IF finf:=vdAllocObject(VDO_FILEINFO)

          StringF(descfile, '\s/\s', cfg.descdir, cfg.descfile)
          file,number := match( args.file, 100 )

          FOR i:=0 TO number-1
            IF file[i]<>NIL
              DeleteFile(descfile)
              IF getdescription(file[i])
                handleargs()
              ENDIF
            ELSE
              SetIoErr( ERROR_OBJECT_NOT_FOUND )
              PrintFault( IoErr(), args.file[i] )
            ENDIF
          ENDFOR

        ENDIF

        vdFreeStartup(cfg)
      ENDIF
      UnLock(lock)
    ENDIF

    FreeArgs(rdargs)
  ENDIF
ENDPROC

/************************************************
         EXTRACT SOME KIND OF DESCRIPTION
 ************************************************/
PROC getdescription(file)
  DEF rc=FALSE, len

  IF vdExamineFile(finf, file, cfg)

    vdRunModule( finf, VDCMD_READ )

    IF FileLength(descfile) < 1
      IF StrLen(finf.fib.comment) > 0
        writeStr( descfile, finf.fib.comment, StrLen(finf.fib.comment) )
      ELSE
        vdGetVersion( finf.filename, descfile )
      ENDIF
    ENDIF

    len := FileLength(descfile)
    IF len>0
      finf.desc:=New(len)
      vdReadFile(descfile, finf.desc, len )
      rc:=TRUE
    ENDIF
        
  ENDIF
ENDPROC rc


/************************************************
           HANDLE ARGUMENTS FROM USER
 ************************************************/
PROC handleargs()

  IF args.quiet<>FALSE THEN
    IF args.savenote<>FALSE THEN args.autosave:=TRUE

  IF args.edit<>FALSE    THEN vdRunModule( finf, VDCMD_EDIT )
  IF args.execute<>FALSE THEN vdRunModule( finf, VDCMD_EXECUTE )
  IF args.kill<>FALSE    THEN vdRunModule( finf, VDCMD_DELETE )

  IF args.autosave<>FALSE
    IF args.savenote<>FALSE
      saveNote( finf )
    ELSE
      vdRunModule( finf, VDCMD_WRITE )
    ENDIF
  ENDIF

ENDPROC




/************************************************
               MINOR HELP-PROCEDURES
 ************************************************/
PROC saveNote( finf:PTR TO vdFileInfo )
  DEF note[79]:STRING
  vdTrimStr( finf.desc, note, StrLen(note), finf.cfg.tabu )
  PrintF('Note: \s\n', note )
ENDPROC SetComment( finf.filename, note )

PROC writeStr( file, mem, memlen )
  DEF fh,l,rc=FALSE
  IF fh:=Open( file, MODE_NEWFILE )
    IF ( l:=Write(fh,mem,memlen) )<>-1 THEN rc:=l
    Close( fh )
  ENDIF
ENDPROC rc

-> Convert string to estring using dynamic allocation
PROC estr( str )
  DEF estr
  estr:=String( StrLen(str) )
  StrCopy( estr, str )
ENDPROC estr
