MODULE '*external', 'dos/var'

PROC main()
  DEF longval:PTR TO LONG, args:PTR TO vdExternalArgs, str[200]:STRING,fh

  IF StrToLong( arg, {longval} )<>-1
    args:=^longval

    IF args.command=VDCMD_READ
      StringF(str, 'xDiz "\s" x "\s" >NIL:',
              args.finf.filename, args.finf.cfg.descfile )
      Execute(str,0,0)
    ENDIF

    IF args.command=VDCMD_WRITE
      StringF(str, 'xDiz "\s" a "\s" >NIL:',
              args.finf.filename, args.finf.cfg.descfile )
      Execute(str,0,0)
    ENDIF

    IF args.command=VDCMD_EXECUTE
      Execute('execute env:viewdiz/modules/.getdrawer >dest',0,0)
      IF fh:=Open('dest',OLDFILE)
        Read( fh, str, StrMax(str) )
        PrintF('\s\n', str)
        Close(fh)
        DeleteFile('dest')
      ENDIF
    ENDIF

    IF args.command=VDCMD_DELETE
      StringF( str, 'xDiz "\s" s >NIL:', args.finf.filename )
      Execute(str,0,0)
    ENDIF

  ELSE

    StringF( str, '\s rwxd 9 _Unpack (#?.xpk) XPK-packed', arg)
    SetVar( 'viewdiz/.minf', str, -1, GVF_GLOBAL_ONLY )

  ENDIF
ENDPROC

CHAR '$VER: ViewDiz-XPK.module 1.3 (11.11.98) Mikael Lund'
