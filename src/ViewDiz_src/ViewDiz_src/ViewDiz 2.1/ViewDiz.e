/*******************************************************************

  Program:   ViewDiz
  Function:  Extract, view & manipulate file-descriptions.
  Author:    Mikael Lund <ki9656@unidhp.uni-c.dk> <lund@kiku.dk>
  Copyright: ©1997-98 by Mikael Lund
  Language:  AmigaE
  Remarks:   This source is private - please don't spread it.

 *******************************************************************/

OPT OSVERSION=38
OPT PREPROCESS

MODULE  'graphics/text',
        'libraries/reqtools',
        'libraries/diskfont',
        'libraries/locale',
        'reqtools',
        'diskfont',
        'locale',
        'utility/tagitem',
        'utility/hooks',
        'intuition/intuition',
        'tools/exceptions',
        'tools/file',
        'dos/dos',
        'dos/dostags',
        'dos/var',
        'dos/rdargs'

CONST REQTOOLS_VERSION=37,
      DISKFONT_VERSION=37,
      LOCALE_VERSION=38,
      MAXLEN=1024,
      VDIZ_VER="2",
      VDIZ_REV="1"

OBJECT configargs
  module, flags, item, default, pattern, filetype
ENDOBJECT

OBJECT myargs
  file, to, kill, execute, autosave, savenote,
  edit, uppercase, lowercase, pubscreen, font:PTR TO CHAR,
  fontsize:PTR TO LONG, keepdiz, quiet, wizard:PTR TO LONG
ENDOBJECT

OBJECT filetype
  type, id, pos
ENDOBJECT

DEF file[MAXLEN]:STRING, module[MAXLEN]:STRING, filetype[MAXLEN]:STRING,
    properties[MAXLEN]:STRING, actionbutton[MAXLEN]:STRING,
    desc[MAXLEN]:STRING, descfile:PTR TO CHAR, button[MAXLEN]:STRING,
    rdargs=NIL, args:PTR TO myargs, template:PTR TO CHAR,
    catalog=NIL
    
PROC main()
  DEF responseA:PTR TO INT, responseB:PTR TO INT,
      moduletype[10]:STRING, header[16]:STRING, i=0,
      lock, rc=0, fh=NIL

  -> Initialize variables
  args      := NEW [ 0,0,0,0,0,0,  0,0,0,0,0,  0,1,0,0 ]
  args.font := 'topaz.font'
  descfile  := 't:file_id.diz'
  template  := 'FILE/A,TO/K,KILL/S,EXECUTE=EX/S,AUTOSAVE=AS/S,SAVENOTE=SN/S,'+
               'EDIT=ED/S,UPPERCASE=UC/S,LOWERCASE=LC/S,'+
               'PUBSCREEN=PS/K,FONT=F/K,FONTSIZE=FS/K/N,KEEPDIZ=KD/T,QUIET=Q/S,'+
               'WIZARD=WZ/M'

  -> Handle arguments
  IF rdargs:=ReadArgs(template, args, NIL )
    IF lock:=Lock( args.file, ACCESS_READ )
      NameFromLock( lock, file, MAXLEN )
      UnLock( lock )
    ENDIF
    IF IoErr()>0
      rc:=5
      JUMP cleanup
    ENDIF

    IF localebase := OpenLibrary( 'locale.library', LOCALE_VERSION )
      catalog:=OpenCatalogA(  NIL, 'viewdiz.catalog', [OC_BUILTINLANGUAGE,
                              'english', TAG_DONE] )

      -> Handle filetype
      DeleteFile( descfile )
      StrCopy( header, readbinary(file) )
      checkxpk( header )
      IF getconfig( file )=FALSE
        StrCopy( moduletype, checkbinary( header ) )
        IF EstrLen(moduletype)=0
          StrCopy( properties, 'RW' )
          SetStr( module, 0 )
          args.savenote:=TRUE
        ELSE
          getconfig( moduletype )
        ENDIF
      ENDIF

      IF InStr( properties, 'R' ) = -1
        IF InStr( properties, 'W' ) = -1
          StrAdd( properties, 'RW')
          args.savenote:=TRUE
        ENDIF
      ENDIF

      -> Retrieve description
      runmodule( module, file, 'READ', descfile )
      IF file2string( descfile, desc )=FALSE
        IF examinefile( file, desc )=FALSE
          IF versioninfo( file, desc, descfile )=FALSE
            IF fh:=Open(descfile, NEWFILE) THEN Close(fh)
            StrCopy(desc, GetCatalogStr(catalog, 11, 'No description') )
          ENDIF
        ENDIF
      ENDIF

      IF FileLength(descfile)=-1 THEN string2file( descfile, desc)
      StrCopy( desc, simplewrap( desc ) )

      -> Handle some more arguments
      IF args.quiet<>FALSE
        IF args.savenote<>FALSE THEN args.autosave:=TRUE
      ENDIF

      WHILE args.wizard[i]
        runwizard( args.wizard[i], file, descfile)
        INC i
      ENDWHILE
      IF i<>0 THEN file2string( descfile, desc )

      IF args.uppercase<>FALSE
        UpperStr(desc)
        string2file(descfile, desc)
      ENDIF
      IF args.lowercase<>FALSE
        LowerStr(desc)
        string2file(descfile, desc)
      ENDIF

      IF args.edit<>FALSE
        IF openeditor( descfile )<>FALSE
          file2string( descfile, desc )
        ENDIF
      ENDIF

      IF args.autosave<>FALSE
        IF args.savenote<>FALSE
          savefilenote( file, desc )
        ELSE
          setDizNote()
          runmodule( module, file, 'WRITE', descfile )
        ENDIF
      ENDIF

      IF StrLen(args.to) > 0 THEN string2file( args.to, desc )

      IF args.execute<>FALSE
        IF InStr( properties, 'X' ) <> -1
          runmodule( module, file, 'EXECUTE', descfile )
        ENDIF
      ENDIF

      IF args.kill<>FALSE
        IF InStr( properties, 'D' ) <> -1
          runmodule( module, file, 'DELETE', descfile )
        ENDIF
      ENDIF

      -> Handle requester
      IF args.quiet=FALSE
        IF reqtoolsbase := OpenLibrary( 'reqtools.library', REQTOOLS_VERSION )
          responseA := request( desc, buttons() )

          IF responseA = 1
            IF InStr( properties, 'W' ) <> -1
              IF openeditor( descfile )<>FALSE
                file2string( descfile, desc )
              ENDIF

              StringF( button, '\s|\s',
                       GetCatalogStr(catalog, 2, '_Save'),
                       GetCatalogStr(catalog, 4, '_Cancel') )

              responseB := request( desc, button )
              SELECT responseB
              CASE 1
                IF args.savenote<>FALSE
                  savefilenote( file, desc )
                ELSE
                  setDizNote()
                  runmodule( module, file, 'WRITE', descfile )
                ENDIF
              ENDSELECT
            ELSE
              INC responseA
            ENDIF
          ENDIF

          IF responseA = 2
            IF InStr( properties, 'X' ) <> -1
              runmodule( module, file, 'EXECUTE', descfile )
            ELSE
              INC responseA
            ENDIF
          ENDIF
        CloseLibrary( reqtoolsbase )
        ELSE
          PrintF('\s v\d+\n',
                 GetCatalogStr(catalog, 12, 'Couldn\at open reqtools.library'),
                 REQTOOLS_VERSION)
          rc:=10
        ENDIF
      ENDIF
      CloseCatalog(catalog)
      CloseLibrary(localebase)
    ELSE
      PrintF('Couldn\at open locale.library\n')
      rc:=10
   ENDIF
  ELSE
    rc:=10
  ENDIF
cleanup:
  PrintFault(IoErr(), NIL)
  FreeArgs(rdargs)
  IF args.keepdiz = FALSE THEN DeleteFile( descfile )
ENDPROC rc


/************* EXTERNAL METHODS ************/

/****** Which Buttons ? ******/
PROC buttons()
  IF InStr(properties, 'W') <> -1 THEN
      StringF( button, '\s|', GetCatalogStr(catalog, 1, '_Edit') )

  IF InStr(properties, 'X') <> -1 THEN
      StringF(button, '\s\s|',button, actionbutton)

  StringF(button, '\s\s', button, GetCatalogStr(catalog, 3, '_Quit'))
ENDPROC button

/****** Configuration ******/
PROC getconfig( file )
  DEF args:configargs, rdargs=NIL, rda:PTR TO rdargs, rc=FALSE,
      m, l, n, list, cnt=0:PTR TO CHAR, estr[1024]:STRING,
      filepart[MAXLEN]:STRING

  m,l  := readfile( 'env:viewdiz/.modules' )
  n    := countstrings( m, l )
  list := stringsinfile( m, l, n )
  StrCopy( filepart, FilePart(file) )

  IF rda:=AllocDosObject( DOS_RDARGS, NIL )
    WHILE cnt<>n
      StringF( estr, '\s\n', ListItem(list,cnt++) )
      rda.source.buffer := estr
      rda.source.length := EstrLen( estr )
      rda.source.curchr := NIL
      rda.buffer        := NIL

      IF rdargs := ReadArgs( 'M,F,I,D,P,F', args:=NEW [0,0,0,0,0,0]:configargs, rda)
        ParsePatternNoCase( args.pattern, estr, (2*StrLen(args.pattern)+2) )
        IF MatchPatternNoCase(estr, filepart) <> FALSE
          StrCopy( module, args.module )
          StrCopy( properties, UpperStr( args.flags ) )
          StrCopy( filetype, args.filetype)
          StrCopy( actionbutton,GetCatalogStr(catalog,Val(args.item),args.default) )
          cnt:=n
          rc:=TRUE
        ENDIF
        FreeArgs( rdargs )
      ENDIF
    ENDWHILE
    FreeDosObject( DOS_RDARGS, rda )
  ENDIF
ENDPROC rc

/****** Binary filetype check ******/
PROC checkbinary(header)
  DEF t:PTR TO filetype
  t := NEW [
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
    IF StrCmp(header+t[].pos, t[].id, StrLen(t[].id)) THEN RETURN t[].type
    t++
  ENDWHILE
ENDPROC NIL

/****** XPK Checker ******/
PROC checkxpk( header )
  DEF var:PTR TO CHAR
  var:='xpkstatus'
  IF InStr( header, 'XPKF' ) = 0
    SetVar( var, '1', 1, GVF_LOCAL_ONLY )
    RETURN TRUE
  ELSE
    SetVar( var, '0', 1, GVF_LOCAL_ONLY )
  ENDIF
ENDPROC FALSE


/****** Requester ******/
PROC request( text, buttons )
  DEF tags, font:PTR TO textattr, df=NIL, result, size:PTR TO INT

  size := IF args.fontsize THEN args.fontsize[] ELSE 8
  font := NEW [ args.font, size, FS_NORMAL, NIL ]:textattr
  IF diskfontbase:=OpenLibrary( 'diskfont.library', DISKFONT_VERSION ) THEN
    df:=OpenDiskFont( font )

  tags := NEW [ RT_TEXTATTR, font,
                RT_PUBSCRNAME, args.pubscreen,
                RT_UNDERSCORE, $5F,
                RTEZ_DEFAULTRESPONSE, 0,
                RT_REQPOS, REQPOS_CENTERSCR,
                RTEZ_REQTITLE, 'ViewDiz 2.1, ©1997-98 Mikael Lund', TAG_DONE ]

  result:=RtEZRequestA( text, buttons, NIL, NIL, tags)

  IF df<>NIL THEN CloseFont(df)
  IF diskfontbase<>NIL THEN CloseLibrary( diskfontbase )
ENDPROC result


/****** Run module-script ******/
PROC runmodule( module, file, command, descfile )
  DEF s[MAXLEN]:STRING
  IF EstrLen(module)=0 THEN RETURN FALSE
  StringF( s, 'execute "\s" FILE="\s" cmd="\s" desc="\s"', module, file, command, descfile )
ENDPROC Execute( s, NIL, NIL )


/****** Run wizard ******/
PROC runwizard( wizard, file, descfile )
  DEF s[MAXLEN]:STRING
  IF StrLen(wizard)=0 THEN RETURN FALSE
  StringF( s, 'execute env:viewdiz/wizards/\s file="\s" desc="\s"', wizard, file, descfile )
ENDPROC Execute(s,NIL,NIL)


/****** Start text-editor ******/
PROC openeditor( file )
  DEF s[MAXLEN]:STRING
  IF InStr( properties, 'E' ) <> -1
    RETURN runmodule( module, file, 'EDIT', descfile )
  ELSE
    StringF( s, 'execute >NIL: env:viewdiz/.editor "\s"', file )
    IF SystemTagList( s, [NP_SYNCHRONOUS, TRUE, TAG_DONE] )=0 THEN RETURN TRUE
  ENDIF
ENDPROC FALSE


/****** Read file to a string ******/
PROC file2string( file, edest )
  DEF buf[10000]:STRING, fh:PTR TO LONG,length:PTR TO INT
  IF fh:=Open( file, OLDFILE)
    length:=Read(fh,buf,StrMax(buf))
    IF length<>-1
      SetStr( buf, length)
      StrCopy( edest, buf)
    ENDIF
    Close( fh )
    IF EstrLen(edest) > 0 THEN RETURN TRUE
  ENDIF
ENDPROC FALSE

/****** Save "string" to "file" ******/
PROC string2file( file, string )
  DEF fh:PTR TO LONG,result=FALSE
  IF fh:=Open( file, NEWFILE )
    IF Write( fh, string, StrLen(string) )>0 THEN result:=TRUE
    Close( fh )
  ENDIF
ENDPROC result


/****** Read binaryfile (substitute 0 chars with 20 ) ******/
PROC readbinary( file, length=14 )
  DEF fh, header, x:PTR TO CHAR, i
  header:=String(64)
  IF fh:=Open( file, OLDFILE )
    FOR i:=0 TO length
      x := FgetC(fh)
      IF x=0 THEN x:=20
      header[i] := x
    ENDFOR
    Close( fh )
  ENDIF
ENDPROC header

/****** Wrap & Trim single lined descriptions ******/
PROC simplewrap( string )
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
    RETURN TrimStr(d)
  ENDIF
  IF InStr( d, '\n', l-1 )<>-1 THEN SetStr( d, l-1 )
ENDPROC d

/****** Save string to filenote ******/
PROC savefilenote( file, string )
  DEF tabu[MAXLEN]:STRING, temp[79]:STRING, note[MAXLEN]:STRING

  GetVar( 'viewdiz/.tabu', tabu, StrMax(tabu), GVF_BINARY_VAR )
  WHILE string[]
    temp[] := string[]++
    IF InStr( tabu, temp ) = -1 THEN StrAdd( note, temp )
  ENDWHILE
  StrCopy( temp, TrimStr( note ) )
ENDPROC SetComment( file, temp )

/****** Set File_id.diz filenote ******/
PROC setDizNote() IS SetComment(descfile,'ViewDiz 2.1 by Mikael Lund')

/****** Retrieve file information ******/
PROC examinefile( file, edest)
  DEF i:PTR TO fileinfoblock, lock, rc=FALSE
  IF i:=AllocDosObject( DOS_FIB, NIL )
    IF lock := Lock(file, SHARED_LOCK)
      Examine(lock, i)
      UnLock(lock)
      IF StrLen(i.comment)>0
        SetStr(edest, StrLen(i.comment))
        StrCopy( edest, i.comment)
        rc:=TRUE
      ENDIF
    ENDIF
    FreeDosObject( DOS_FIB, i )
  ENDIF
ENDPROC rc

/****** Get version info ******/
PROC versioninfo(file, edest, descfile)
  DEF cmd[MAXLEN]:STRING,fh,output,rc=FALSE

  StringF( cmd, 'version "\s" full >"\s"', file, descfile)
  IF output:=Open( 'NIL:', NEWFILE )
    IF SystemTagList( cmd, NEW [SYS_OUTPUT, output, NP_SYNCHRONOUS, TRUE, TAG_DONE] )<>0
      DeleteFile( descfile )
    ELSE
      IF fh:=Open(descfile,OLDFILE)
        SetStr( edest, Read(fh,edest,StrMax(edest)) )
        Close(fh)
        rc:=TRUE
      ENDIF
    ENDIF
    Close(output)
  ENDIF
ENDPROC rc

CHAR '$VER: ViewDiz ', VDIZ_VER,'.', VDIZ_REV, ' (8.10.98) ',
     '©1997-98 Mikael Lund (lund@kiku.dk)',0
