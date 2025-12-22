MODULE '*///emods/external', 'dos/var', 'dos/dos', 'dos/dostags'

PROC main()
  DEF str[200]:STRING, rdargs=NIL, args:PTR TO vdModuleArgs,
      readme[200]:STRING, name, path[200]:STRING,
      finf:PTR TO vdFileInfo

  IF rdargs:=ReadArgs( 'FILE/A,CMD,DESC,FINF,/F',args:=[0,0,'file_id.diz',0,0],NIL)
    LowerStr(args.cmd)

    IF StrCmp(args.cmd, 'read')
      StringF(str, 'xDiz "\s" x "\s" >NIL:', args.file, args.desc )
      Execute(str,0,0)
    ENDIF

    IF StrCmp(args.cmd, 'write')
      StringF(str, 'xDiz "\s" a "\s" >NIL:', args.file, args.desc )
      Execute(str,0,0)
    ENDIF

    IF StrCmp(args.cmd, 'execute')
    ENDIF

    IF StrCmp(args.cmd, 'delete')
      StringF( str, 'xDiz "\s" s >NIL:', args.file )
      Execute(str,0,0)
    ENDIF

    IF StrCmp(args.cmd, 'info')
      StringF( str, '\s rwxd 9 _Unpack (#?.xpk) XPK-packed', arg)
      SetVar( 'viewdiz/.minf', str, -1, GVF_GLOBAL_ONLY )
    ENDIF

    FreeArgs(rdargs)
  ENDIF
ENDPROC

CHAR '$VER: ViewDiz-XPK.module 1.3 (11.11.98) Mikael Lund',0
