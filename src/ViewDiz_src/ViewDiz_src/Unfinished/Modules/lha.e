MODULE '*external', 'dos/var', 'dos/dos', 'dos/dostags'

PROC main()
  DEF str[200]:STRING, rdargs=NIL, args:PTR TO vdModuleArgs,
      readme[200]:STRING, name, path[200]:STRING,
      obj:PTR TO vdExternalArgs

  -> READ ARGUMENTS
  IF rdargs:=ReadArgs( 'FILE/A,CMD,DESC,OBJECT',args:=[0,0,'file_id.diz',0],NIL)
    LowerStr(args.cmd)

    -> GET OBJECT ADDRESS
    IF args.object THEN
      StrToLong( args.object, {obj} )

    PrintF('Type: \s\n', obj.finf.cfg.filetype[1] )

    -> EXTRACT DESCRIPTION
    IF StrCmp(args.cmd, 'read')
      StringF(str, 'Lha e -X -m -a0 "\s" "\s" >NIL:', args.file, args.desc )
      Execute(str,0,0)
      Execute('cd',0,0)

      IF FileLength(args.desc)=-1   ->No diz!
        name:=FilePart(args.file)
        StrCopy( path, args.file, name-args.file)

        IF SplitName( name, $2E, readme, 0, 200 )<>-1
          StringF( readme, '\s.readme', readme)
        ELSE
          StringF( readme, '\s.readme', name)
        ENDIF
        AddPart( path, readme, 200 )

        IF FileLength(path)=-1  ->No extra readme file - perhaps in archive?
          StringF(str, 'Lha e -X -m -a0 "\s" "\s" >NIL:', args.file, readme )
          Execute(str,0,0)
        ELSE
          StrCopy( readme, path )
        ENDIF

        IF FileLength(readme)<>-1
          StringF(str, 'execute env:viewdiz/modules/readme "\s" cmd=read desc="\s" >NIL:', readme, args.desc )
          Execute(str,0,0)
        ENDIF
      ENDIF
    ENDIF

    -> ADD/SAVE DESCRIPTION
    IF StrCmp(args.cmd, 'write')
      StringF(str, 'Lha r -X -q -m "\s" "\s" >NIL:', args.file,args.desc )
      Execute(str,0,0)
    ENDIF

    -> PERFORM AN ACTION ON THE FILE
    IF StrCmp(args.cmd, 'execute')
      StringF( str, 'Lha x -X -a -m -M "\s" Ram: >CON:', args.file)
      Execute(str,0,0)
    ENDIF

    -> REMOVE/DELETE DESCRIPTION
    IF StrCmp(args.cmd, 'delete')
      StringF(str, 'Lha -X d "\s" "\s" >NIL:', args.file, args.desc )
      Execute(str,0,0)
    ENDIF

    -> SHOW MODULEINFO
    IF StrCmp(args.cmd, 'info')
      StringF( str, '\s rwxd 6 _UnLha #?.(lha|lzh) Lha-archive', args.file)
      SetVar( 'viewdiz/.minf', str, -1, GVF_GLOBAL_ONLY )
    ENDIF

    FreeArgs(rdargs)
  ENDIF
ENDPROC

-> SET VERSION INFO
CHAR '$VER: ViewDiz-Lha.module 1.3 (11.11.98) Mikael Lund',0
