-> preprocess (and use) the version macros (VERSION_INFO and VERSION_STRING)
-> however, these are not used here, so it's left commented
-> OPT PREPROCESS

-> implements a full Commodore-Amiga compliant versionstring.
MODULE '*bumpee_rev'

MODULE 'dos/dos','dos/rdargs','dos/datetime','intuition/intuition'

PROC main()
  DEF readargs:PTR TO rdargs,args:PTR TO LONG,datetime:datetime
  DEF exefile[256]:STRING,donotcompile=FALSE,ecpath[256]:STRING
  DEF bumpfile[256]:STRING,bumpcontents[1024]:STRING,bumpflag=FALSE
  DEF name[256]:STRING,version=1,revision=0,day=0,month=0,year=0,forcebump=FALSE
  DEF datestring[LEN_DATSTRING]:STRING,bumpversion=FALSE,commandstring[256]:STRING
  DEF bumpfh=NIL,exefh=NIL,bumpfib:PTR TO fileinfoblock,exefib:PTR TO fileinfoblock
  DEF sourcefile[256]:STRING,modfile[256]:STRING

  GetProgramName(exefile,256)
  IF readargs:=ReadArgs('NAME/A,CREATE=FORCE/S,BUMPVERSION/S,DONOTCOMPILE/S,ECFILEPATH/K',args:=[NIL,FALSE,FALSE,FALSE,'EC'],NIL)
    StrCopy(exefile,args[0])
    forcebump:=args[1]
    bumpversion:=args[2]
    donotcompile:=args[3]
    StrCopy(ecpath,args[4])
    FreeArgs(readargs)
    IF StrCmp(exefile+EstrLen(exefile)-2,'.e',2)
      MidStr(exefile,exefile,0,EstrLen(exefile)-2)
    ENDIF
    StrCopy(sourcefile,exefile)
    StrAdd(sourcefile,'.e')
    StrCopy(modfile,exefile)
    StrAdd(modfile,'.m')

    -> print out a copyright notice with actual version information
    PrintF('Bumpee \d.\d © 19\d by Leon Woestenberg\n',VERSION,REVISION,VERSION_YEAR)
    IF FileLength(sourcefile)>0
      StrCopy(bumpfile,exefile)
      StrAdd(bumpfile,'_rev.e')
      datetime.format:=FORMAT_CDN
      datetime.flags:=0
      datetime.strday:=NIL
      datetime.strdate:=datestring
      datetime.strtime:=NIL
      DateStamp(datetime)
      DateToStr(datetime)
      day:=Val(datestring)
      month:=Val(datestring+3)
      year:=Val(datestring+6)
      IF bumpfh:=Open(bumpfile,MODE_OLDFILE)
        IF forcebump
          bumpflag:=TRUE
        ELSE
          IF bumpfib:=AllocDosObject(DOS_FIB,0)
            IF ExamineFH(bumpfh,bumpfib)
              IF exefh:=Open(exefile,MODE_OLDFILE)
                IF exefib:=AllocDosObject(DOS_FIB,0)
                  IF ExamineFH(exefh,exefib)
                    bumpflag:=(CompareDates(bumpfib+132,exefib+132)>0)
                  ENDIF
                  FreeDosObject(DOS_FIB,exefib)
                ENDIF
                Close(exefh)
              ENDIF
            ENDIF
            FreeDosObject(DOS_FIB,bumpfib)
          ENDIF
        ENDIF
        IF bumpflag
          WHILE Fgets(bumpfh,bumpcontents,1023)
            IF InStr(bumpcontents,'BUMP')<>-1
              WHILE Fgets(bumpfh,bumpcontents,1023)
                EXIT InStr(bumpcontents,'ENDBUMP')<>-1
                IF InStr(bumpcontents,'NAME=')<>-1
                  MidStr(name,bumpcontents,InStr(bumpcontents,'=')+1)
                  SetStr(name,StrLen(name)-1)
                ELSEIF InStr(bumpcontents,'VERSION=')<>-1
                  version:=Val(bumpcontents+InStr(bumpcontents,'=')+1)
                ELSEIF InStr(bumpcontents,'REVISION=')<>-1
                  revision:=Val(bumpcontents+InStr(bumpcontents,'=')+1)
                ENDIF
              ENDWHILE
            ENDIF
            EXIT StrCmp(bumpcontents,'ENDBUMP')
          ENDWHILE
          IF bumpversion
            version:=version+1
            revision:=0
            PrintF('Bumping version to \d.\d...',version,revision)
          ELSE
            revision:=revision+1
            PrintF('Bumping revision to \d.\d...',version,revision)
          ENDIF
        ELSE
          PrintF('Last revision still uncompiled...No need to bump.\n')
        ENDIF
        Close(bumpfh)
      ELSE
        IF forcebump
          StrCopy(name,FilePart(exefile))
          bumpflag:=TRUE
          PrintF('Creating bump module...')
        ELSE
          PrintF('No bumpfile exists for \a\s\a...Bumpee did nothing.\nSet CREATE switch to create a bumpfile.\n',exefile)
        ENDIF
      ENDIF
      IF bumpflag
        DeleteFile(bumpfile)
        IF FileLength(bumpfile)=TRUE
          IF bumpfh:=Open(bumpfile,MODE_NEWFILE)
            StringF(bumpcontents,'-> Bumpee revision bump module. Do not alter this file manually.\n\n'+
                                 'OPT MODULE\n'+
                                 'OPT EXPORT\n'+
                                 'OPT PREPROCESS\n'+
                                 '\n'+
                                 '/*\n'+
                                 'BUMP\n'+
                                 '  NAME=\s\n'+
                                 '  VERSION=\d\n'+
                                 '  REVISION=\d\n'+
                                 'ENDBUMP\n'+
                                 '*/\n'+
                                 '\n'+
                                 'CONST VERSION=\d\n'+
                                 'CONST REVISION=\d\n'+
                                 '\n'+
                                 'CONST VERSION_DAY=\d\n'+
                                 'CONST VERSION_MONTH=\d\n'+
                                 'CONST VERSION_YEAR=\d\n'+
                                 '\n'+
                                 '#define VERSION_STRING {version_string}\n'+
                                 '#define VERSION_INFO {version_info}\n'+
                                 '\n'+
                                 'PROC dummy() IS NIL\n'+
                                 '\n'+
                                 'version_string:\n'+
                                 'CHAR \a$VER: \a\n'+
                                 'version_info:\n'+
                                 'CHAR \a\s \d.\d (\d.\d.\d)\a,0\n',
                                 name,
                                 version,
                                 revision,
                                 version,
                                 revision,
                                 day,
                                 month,
                                 year,
                                 name,
                                 version,
                                 revision,
                                 day,
                                 month,
                                 year)
            Fputs(bumpfh,bumpcontents)
            Close(bumpfh)
            PrintF('Done.\n')
            IF donotcompile
            ELSE
              StringF(commandstring,'\s \s',ecpath,bumpfile)
              Execute(commandstring,NIL,NIL)
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ELSE
      PrintF('Sourcefile \a\s\a not found...Bumpee did nothing.\n',sourcefile)
    ENDIF
  ELSE
    PrintFault(IoErr(),exefile)
  ENDIF
ENDPROC

