-> DOREV
-> :ts=2

/*
** RevFlex.e
** FlexRev clone with added functionality
**
** Build MorphOS PPC binary: ecx RevFlex.e DEFINE="PPC"
** Build AmigaOS 68K binary: ecx RevFlex.e DEFINE="AMIGA"
** Build AmigaOS4 PPC binary: ecx RevFlex.e DEFINE="OS4"
**
** Bumping build: RevFlex RV=revflex_revision PROTO=az_protofile.e TARGET=reflex_revision.e IB
** Build reflex_revision.m: ec reflex_revision.e
**
** (c) 2022 by Matthias "UltraGelb" Böcker/#amigazeux
*/

OPT OSVERSION=37
OPT PREPROCESS
OPT REG=-1

#ifdef PPC
OPT MORPHOS
->OPT EXENAME = 'RevFlex_MOS'
#endif

#ifdef AMIGA
OPT AMIGAOS
OPT EXENAME = 'RevFlex_68k'
#endif

#ifdef OS4
OPT AMIGAOS4
OPT EXENAME = 'RevFlex_AOS4'
#endif

MODULE  'exec/lists',
        'exec/nodes',
        'exec/memory'

MODULE  'dos',
        'dos/dos',
        'dos/rdargs'

MODULE  'utility', -> Amiga2Date()
        'utility/date'

MODULE  'workbench/startup'

MODULE  '*RevFlex_revision'

/* protofile keywords ${keyword}
  VERSION   -> <versionnumber>
  VER       -> <versionnumber>
  REVISION  -> <revisionnumber>
  REV       -> <revisionnumber>
  BUILD     -> <buildnumber>
  VERREV    -> <version>.<revision>
  FULLVER   -> <version>.<revision>.<build>
  VERREVBUILD - synonymous for FULLVER, just for completeness
  DATE      -> <dd.mm.yyyy>
  TIME      -> <hh:mm:ss>
  DAY       -> <day number>
  MONTH     -> <month number>
  YEAR      -> <yyyy>
*/

STATIC argtemplate= 'RV=REVFILE/A,' +
                    'TARGET,' +
                    'PROTO,' +
                    'IB=INCBUILD/S,' +
                    'IR=INCREVISION/S,' +
                    'IV=INCVERSION/S' +
                    'VERBOSE=DEBUG/S'

OBJECT myargs
  revfile:PTR TO LONG
  target:PTR TO LONG
  proto:PTR TO LONG
  incbuild:PTR TO LONG
  increv:PTR TO LONG
  incver:PTR TO LONG
  verbose:PTR TO LONG
ENDOBJECT

OBJECT revitem OF mln
  internal:INT
  key[1024]:ARRAY OF CHAR
  data[1024]:ARRAY OF CHAR
ENDOBJECT

OBJECT revdata
  version:LONG
  revision:LONG
  build:LONG

  oldversion:LONG
  oldrevision:LONG
  oldbuild:LONG

  targetfile[1024]:ARRAY OF CHAR
  protofile[1024]:ARRAY OF CHAR
  increv:LONG
  incver:LONG
  incbuild:LONG

  date[32]:ARRAY OF CHAR
  time[32]:ARRAY OF CHAR
ENDOBJECT

PROC main() HANDLE
  DEF libn, libv
  DEF rdargs
  DEF args:myargs
  DEF verbose

  DEF revfile[1024]:ARRAY OF CHAR, revsize, revchanged, writerevsize
  DEF revlist:PTR TO mlh
  DEF rd:revdata

  DEF protobuf=NIL:PTR TO CHAR, protosize, ret
  DEF targetsize

  DEF bverbuf[16]:STRING, brevbuf[16]:STRING, bbuildbuf[16]:STRING
  DEF makebold, makenormal

  WriteF('\e[0;1m' + PROGRAM_NAME + ' ' + PROGRAM_VER + ' [' + __TARGET__ + '] \e[0;3mCopyright (c) ' + COMPILE_YEAR + ' ' + PROGRAM_AUTHOR + '\e[0m\n')

  IF (utilitybase := OpenLibrary(libn := 'utility.library', libv := 37)) = NIL THEN Raise("LIB")

  #ifdef OS4
  utilityiface := GetInterface(utilitybase, 'main', 1, NIL)
  #endif

  args.revfile := ''
  args.target := ''
  args.proto := ''
  args.incver := 0
  args.increv := 0
  args.incbuild := 0
  args.verbose := 0

  IF (rdargs := ReadArgs(argtemplate, args, NIL)) = NIL THEN Raise("ARGS")

  AstrCopy(revfile, args.revfile, 1023)
  AstrCopy(rd.targetfile, args.target, 1023)
  AstrCopy(rd.protofile, args.proto, 1023)
  rd.incver := args.incver
  rd.increv := args.increv
  rd.incbuild := args.incbuild

  verbose := args.verbose

  FreeArgs(rdargs)

  rd.version := 0
  rd.revision := 0
  rd.build := 0

  /*
  ** different from flexrev we can also live with no VERSION/REVISION/BUILD, we just use 0.0.0 then
  ** but we need at least a target and a protofile. if these are missing, we fail
  */

  revlist := NewR(SIZEOF mlh)
  NewList(revlist)


  IF verbose THEN WriteF('Reading revision file: "\s" ... ',revfile)
  revchanged,revsize := readrevfile(revfile, revlist, rd) -> version/revision/build got bumped or were just created, write file back
  IF revchanged < 0
    IF verbose THEN WriteF('failed.\n')
    Raise("NREV")
  ELSEIF verbose
    WriteF(' \d bytes read.\n', revsize)
  ENDIF

  IF rd.protofile[] = 0 THEN Raise("NPRO") -> no protofile
  IF rd.targetfile[] = 0 THEN Raise("NTAR") -> no target

  IF revchanged
    IF verbose
      IF rd.incver THEN WriteF('Bumping version \d -> \d\n',rd.oldversion,rd.version)
      IF rd.increv THEN WriteF('Bumping revision \d -> \d\n',rd.oldrevision,rd.revision)
      IF rd.incbuild THEN WriteF('Bumping build \d -> \d\n',rd.oldbuild,rd.build)

      WriteF('Writing updated revision file ... ')
    ENDIF
    writerevsize := writerevfile(revfile, revlist)
    IF writerevsize = 0
      WriteF('Warning: could not write revision file "\s"!\n', revfile)
    ELSEIF verbose
      WriteF('\d bytes written.\n', writerevsize)
    ENDIF
  ENDIF

  makebold := '\e[0;1m\d\e[0m'
  makenormal := '\d'

  StringF(bverbuf, IF rd.incver THEN makebold ELSE makenormal, rd.version)
  StringF(brevbuf, IF rd.increv THEN makebold ELSE makenormal, rd.revision)
  StringF(bbuildbuf, IF rd.incbuild THEN makebold ELSE makenormal, rd.build)

  ->WriteF('Date=\s Time=\s Version=\d.\d.\d Old=\d.\d.\d\n', rd.date, rd.time, rd.version, rd.revision, rd.build, rd.oldversion, rd.oldrevision, rd.oldbuild)
  WriteF('Date=\s Time=\s Version=\s.\s.\s Old=\d.\d.\d\n', rd.date, rd.time, bverbuf, brevbuf, bbuildbuf, rd.oldversion, rd.oldrevision, rd.oldbuild)

  IF verbose THEN WriteF('Reading prototype file: "\s" ... ', rd.protofile)
  protobuf,protosize,ret := readprotofile(rd.protofile)
  IF ret
    IF verbose THEN WriteF('failed.\n')
    Raise(ret)
  ELSEIF verbose
    WriteF('\d bytes read.\n', protosize)
  ENDIF

  IF verbose THEN WriteF('Writing target file: "\s" ... ', rd.targetfile)
  targetsize := writetarget(protobuf, protosize, revlist, rd)
  IF targetsize < 0
    IF verbose THEN WriteF('failed.\n')
    Raise("ETAR")
  ELSEIF verbose
    WriteF('\d bytes written\nRevFlex is done.\n', targetsize)
  ENDIF

EXCEPT DO
  SELECT exception
  CASE "MEM"  ; WriteF('Error: Out of Memory!\n')
  CASE "LIB"  ; WriteF('Error: Could not open \s V\d\n', libn, libv)
  CASE "ARGS" ; WriteF('Error: Wrong arguments!\n')
  CASE "NPRO" ; WriteF('Error: No protofile specified in either arguments or revision file!\n')
  CASE "SPRO" ; WriteF('Error: proto file size <= 0!\n')
  CASE "OPRO" ; WriteF('Error: Could not open prototype file "\s"!\n', rd.protofile)
  CASE "NTAR" ; WriteF('Error: No target specified in either arguments or revision file!\n')
  CASE "ETAR" ; WriteF('Error: Could not open target file "\s" for writing!\n', rd.targetfile)
  ENDSELECT

  IF protobuf THEN Dispose(protobuf)

  IF revlist
    DEF ri:PTR TO revitem
    WHILE ri := RemHead(revlist) DO Dispose(ri)
    Dispose(revlist)
  ENDIF

  #ifdef OS4
  DropInterface(utilityiface)
  #endif
  CloseLibrary(utilitybase)
ENDPROC

PROC getseconds()
  DEF now:datestamp
  DateStamp(now) -> datestamp datum
ENDPROC (now.days * 86400) + (now.minute * 60) + (now.tick / TICKS_PER_SECOND)

PROC aStripCRLF(text:PTR TO CHAR)
  DEF len

  IF text
    len := StrLen(text) - 1
    WHILE len >= 0
      EXIT (text[len] <> "\b") AND (text[len] <> "\n")
      text[len] := 0
      len--
    ENDWHILE
  ENDIF
ENDPROC text

-> returns -1 for failed to open, 0=nothing was updated, 1=something was updated
PROC readrevfile(fn:PTR TO CHAR, revlist:PTR TO mlh, rd:PTR TO revdata) HANDLE
  DEF handle
  DEF abuf[1024]:ARRAY OF CHAR, cptr:PTR TO CHAR, eqptr:PTR TO CHAR
  DEF eqpos
  DEF buf[1024]:STRING
  DEF ri:PTR TO revitem
  DEF hasversion=0, hasrevision=0, hasbuild=0
  DEF changed=0
  DEF revsize=0

  IF (handle := Open(fn, MODE_OLDFILE)) = NIL THEN Raise("NREV")

  WHILE Fgets(handle, abuf, 1023)
    revsize := revsize + StrLen(abuf)

    cptr := TrimStr(abuf)

    aStripCRLF(cptr)

    ri := NewR(SIZEOF revitem)
    ri.internal := 0

    eqpos := InStr(cptr, '=', 0)
    IF eqpos > 0
      eqptr := TrimStr(cptr + eqpos + 1)

      AstrCopy(ri.key, cptr, Min(eqpos + 1, 1023))
      AstrCopy(ri.data, eqptr, 1023)

      IF StrCmp(cptr, 'PROTO', STRLEN)
        AstrCopy(rd.protofile, eqptr, 1023)

      ELSEIF StrCmp(cptr, 'TARGET', STRLEN)
        AstrCopy(rd.targetfile, eqptr, 1023)

      ELSEIF StrCmp(cptr, 'VERSION',STRLEN)
        rd.version := Val(eqptr)
        rd.oldversion := rd.version
        IF rd.incver
          rd.version++
          StringF(buf, '\d', rd.version)
          AstrCopy(ri.data, buf)
          changed := 1
        ENDIF
        hasversion := 1

      ELSEIF StrCmp(cptr, 'REVISION', STRLEN)
        rd.revision := Val(eqptr)
        rd.oldrevision := rd.revision
        IF rd.increv
          rd.revision++
          StringF(buf, '\d', rd.revision)
          AstrCopy(ri.data, buf)
          changed := 1
        ENDIF
        hasrevision := 1

      ELSEIF StrCmp(cptr, 'BUILD', STRLEN)
        rd.build := Val(eqptr)
        rd.oldbuild := rd.build
        IF rd.incbuild
          rd.build++
          StringF(buf, '\d', rd.build)
          AstrCopy(ri.data, buf)
          changed := 1
        ENDIF
        hasbuild := 1

      ENDIF

      AddTail(revlist, ri)
    ELSE
      ri.key[0] := 0
      AstrCopy(ri.data, abuf)
    ENDIF
  ENDWHILE

EXCEPT DO
  SELECT exception
  CASE "MEM"  ; WriteF('Error: Out of Memory!\n')
  CASE "NREV" ; changed := -1
  ENDSELECT

  IF handle THEN Close(handle)

  IF changed >= 0
    -> if these were not given, just create them since we need them when writing back revfile
    IF hasbuild = 0
      addkey(revlist, 'BUILD', '0', 0)
      rd.oldbuild := rd.build
      changed := 1
    ENDIF

    IF hasrevision = 0
      addkey(revlist, 'REVISION', '0', 0)
      rd.oldrevision := rd.revision
      changed := 1
    ENDIF

    IF hasversion = 0
      addkey(revlist, 'VERSION', '0', 0)
      rd.oldversion := rd.version
      changed := 1
    ENDIF

    addinternalkeywords(revlist, rd)
  ENDIF
ENDPROC changed, revsize

PROC addinternalkeywords(revlist:PTR TO mlh, rd:PTR TO revdata)
  DEF cd:clockdata
  DEF buf[256]:STRING

  Amiga2Date(getseconds(), cd)
  StringF(buf,'\r\z\d[2].\r\z\d[2].\r\z\d[4]', cd.mday, cd.month, cd.year)
  addkey(revlist, 'DATE', buf)
  AstrCopy(rd.date, buf)

  StringF(buf,'\r\z\d[2]:\r\z\d[2]:\r\z\d[2]', cd.hour, cd.min, cd.sec)
  addkey(revlist, 'TIME', buf)
  AstrCopy(rd.time, buf)

  StringF(buf,'\d',cd.mday)
  addkey(revlist, 'DAY', buf)

  StringF(buf,'\d',cd.month)
  addkey(revlist, 'MONTH', buf)

  StringF(buf,'\d',cd.year)
  addkey(revlist, 'YEAR', buf)

  StringF(buf, '\d.\d', rd.version, rd.revision)
  addkey(revlist, 'VERREV', buf)

  StringF(buf, '\d.\d.\d', rd.version, rd.revision, rd.build)
  addkey(revlist, 'FULLVER', buf)
  addkey(revlist, 'FULLVERREV', buf)
  addkey(revlist, 'VERREVBUILD', buf)
ENDPROC

PROC addkey(revlist:PTR TO mlh, key, data, internal=1)
  DEF ri:PTR TO revitem

  ri := NewR(SIZEOF revitem)
  ri.internal := internal
  AstrCopy(ri.key, key, 1023)
  AstrCopy(ri.data, data, 1023)
  AddHead(revlist, ri)
ENDPROC ri

-> write rev file back from revlist
PROC writerevfile(fn:PTR TO CHAR, revlist:PTR TO mlh)
  DEF handle
  DEF ri:PTR TO revitem
  DEF buf[2048]:STRING
  DEF revsize=0

  IF handle := Open(fn, MODE_NEWFILE)
    ri := revlist.head
    WHILE ri.succ
      IF ri.internal = 0 -> don't write internal keys
        StringF(buf, '\s=\s\n', ri.key, ri.data)
        Fputs(handle, buf)

        revsize := revsize + StrLen(buf)
      ENDIF
      ri := ri.succ
    ENDWHILE

    Close(handle)
  ENDIF
ENDPROC revsize

PROC readprotofile(fn:PTR TO CHAR)
  DEF handle
  DEF fib:PTR TO fileinfoblock
  DEF size=0
  DEF protobuf=NIL:PTR TO CHAR, ret=0

  IF handle := Open(fn, MODE_OLDFILE)
    IF fib := AllocDosObject(DOS_FIB, 0)
      IF ExamineFH(handle, fib)
        size := fib.size
      ENDIF
      FreeDosObject(DOS_FIB, fib)

      IF size <= 0
        ret := "SPRO"
      ELSE
        IF protobuf := New(size + 2) -> no NewR() since we don't want an exception raised but just return "MEM" in case of failed alloc
          Read(handle, protobuf, size)
        ELSE
          ret := "MEM"
        ENDIF
      ENDIF
    ELSE
      ret := "MEM"
    ENDIF

    Close(handle)
  ELSE
    ret := "OPRO"
  ENDIF
ENDPROC protobuf, size, ret

PROC writetarget(protobuf:PTR TO CHAR, protosize, revlist:PTR TO mlh, rd:PTR TO revdata) HANDLE
  DEF handle

  DEF ri:PTR TO revitem

  DEF cptr:PTR TO CHAR
  DEF v,r

  DEF inkey=0, keybuf[1024]:STRING, keylen, keysize
  DEF datalen, paddata[2002]:STRING

  DEF outbuf:PTR TO CHAR

  outbuf := String(protosize * 2)
  IF outbuf = NIL THEN Raise("MEM")

  cptr := protobuf
  WHILE cptr[]
    IF inkey = 0
      IF cptr[] = "$"
        cptr++
        cptr := TrimStr(cptr)

        IF cptr[] = "{" -> keyword
          inkey++
          StrCopy(keybuf, '')
          keylen := 0

          v,r := Val(cptr + 1)
          IF r > 0 -> got size integer
            cptr := cptr + r
            keysize := v
          ELSE
            keysize := 0
          ENDIF
        ELSEIF cptr[]
          StrAdd(outbuf, '$')
          StrAdd(outbuf, [cptr[], 0]:CHAR, 1)
        ELSE
          BREAK /* needs ECX V59 WIP */
        ENDIF
      ELSE
        StrAdd(outbuf, [cptr[], 0]:CHAR, 1)
      ENDIF

      cptr++
    ELSE -> we are in a key
      IF cptr[] = "}" -> end of key
        ri := revlist.head
        WHILE ri.succ
          ->IF Stricmp(keybuf, ri.key) = 0 -> case insensitive version
          IF StrCmp(keybuf, ri.key)

            IF keysize <> 0 -> limit or pad data to left/right
              datalen := StrLen(ri.data)
              padstring(ri.data, paddata, datalen, Bounds(keysize, -500, 500))
              StrAdd(outbuf, paddata)

            ELSE -> just add
              StrAdd(outbuf, ri.data)

            ENDIF

            BREAK /* needs ECX V59 WIP */
          ENDIF
          ri := ri.succ
        ENDWHILE

        keylen := 0
        StrCopy(keybuf, '')
        keysize := 0
        inkey--
      ELSE
        StrAdd(keybuf, [cptr[], 0]:CHAR, 1)
        keylen++
        IF keylen >= 1000 THEN Raise("KEYL")
      ENDIF

      cptr++
    ENDIF
  ENDWHILE

  IF (handle := Open(rd.targetfile, MODE_NEWFILE)) = NIL THEN RETURN -1
  Fputs(handle, outbuf)
  Close(handle)

EXCEPT DO
  SELECT exception
  CASE "MEM"  ; WriteF('Error: Out of Memory!\n')
  CASE "ERR1" ; WriteF('Error: "{" expected, aborting!\n')
  CASE "KEYL" ; WriteF('Error: keyword length exceeds 1000 chars, aborting!\n')
  ENDSELECT
ENDPROC StrLen(outbuf)

PROC padstring(str:PTR TO CHAR, dst:PTR TO CHAR, strlen, padsize)
  DEF i=0, spacelen

  StrCopy(dst, '')

  IF padsize > 0 -> left align
    WHILE i < padsize
      StrAdd(dst, IF i < strlen THEN str + i ELSE ' ', 1)
      i++
    ENDWHILE

  ELSEIF padsize < 0 -> right align
    padsize := -padsize
    IF padsize < strlen
      StrCopy(dst, str, padsize)
    ELSE
      spacelen := padsize - strlen
      WHILE i < padsize
        StrAdd(dst, IF i < spacelen THEN ' ' ELSE str + i - spacelen, 1)
        i++
      ENDWHILE
    ENDIF
  ENDIF
ENDPROC
