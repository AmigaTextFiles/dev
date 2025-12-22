-> preprocess (and use) the version macros (VERSION_INFO and VERSION_STRING)
-> however, these are not used here, so it's left commented
-> OPT PREPROCESS

-> implements a full Commodore-Amiga compliant versionstring.

/*
**
** name          : xpkrev.e
**
** original name : Bumpee.e (included in Bumpee archive)
**
** Bumpee 1.44 © 1995 by Leon Woestenberg (leon@stack.urc.tue.nl)
** (found in aminet:dev/e/ directory or in this package.)
**
** xpkrev is a modified Bumpee to use with xpk sublibraries
** for easier version/revision-control. No major change though.
**
** Feel free to alter this source to suit your needs under the
** conditions in Bumpee.doc
**
** The changes are:
**
** - will for example crete LIB_NAME 'xpkNONE.library'
**   from source name 'none.e'. 'none' converted to upper case.
** - some defines to build other define strings
**   (define's are ugly aren't they. I sould want string constants instead.
** - modes, info - versions (BUMPINFO=INFO/S,BUMPMODES=MODES/S)
** - new datestring inspired by Commodore libraries versionstrings
**   (old one still in  'datestring', new in 'datestr')
** - changed filename extension to avoid confusion (_xpkrev.e)
** - moved errors to exception handler instead of IF,ELSE,ENDIF
** - some error messages slightly changed
** - added a few error messages (ERR_BUMP_DELETE, ERR_OPEN_BUMP_WRITE)
** - added comments, som initialisation values, type LONG in DEF
**
**
** Read the documentation for Bumpee for usage, etc, etc.
**
**
** Thanks to Leon for releasing this program with it's source!
**
**
** /Torgil Svensson (snorq@lysator.liu.se) 
**
** (orig. bumpee used to bump this program)
** 
*/

MODULE '*xpkrev_rev'

MODULE 'dos/dos','dos/rdargs','dos/datetime','intuition/intuition'


ENUM ERR_NONE=0,
     ERR_ARGS,
     ERR_NO_SOURCE,
     ERR_LAST_COMPILED,
     ERR_NO_BUMPFILE,
     ERR_BUMP_DELETE,
     ERR_OPEN_BUMP_WRITE


RAISE ERR_ARGS IF ReadArgs() = NIL


PROC main() HANDLE

  -> args
  DEF readargs:PTR TO rdargs,
      args          =NIL   :PTR TO LONG,
      exefile[256]         :STRING,      -> NAME
      forcebump     =FALSE :LONG,        -> CREATE=FORCE
      bumpversion   =FALSE :LONG,        -> BUMPVERSION=VERSION
      donotcompile  =FALSE :LONG,        -> DONOTCOMPILE
      ecpath[256]          :STRING,      -> ECFILEPATH
      bumpinfo      =FALSE :LONG,        -> BUMPINFO=INFO
      bumpmodes     =FALSE :LONG         -> BUMPMODES=MODES


  -> file stuff
  DEF sourcefile[256]      :STRING,      -> NAME.e
      modfile[256]         :STRING,      -> NAME.m
      bumpfile[256]        :STRING,      -> NAME_xpkrev.e
      bumpfh          =NIL :LONG,        -> bump filehandle
      exefh           =NIL :LONG,        -> used to compare dates

      bumpfib = NIL :PTR TO fileinfoblock, -> used to compare dates
      exefib  = NIL :PTR TO fileinfoblock, -> used to compare dates

      bumpcontents[1024] :STRING   -> r/w-buffer for bumpfile (Fputs/Fgets)


  -> dos date vars
  DEF datetime:datetime,
      datestring[LEN_DATSTRING]:STRING


  -> values changed each bump
  DEF name[256]     :STRING,
      day       =0  :LONG,
      month     =0  :LONG,
      year      =0  :LONG,
      version   =1  :LONG,
      revision  =0  :LONG,

      info_version  =0      :LONG,  -> added for xpkrev
      modes_version =0      :LONG,  -> added for xpkrev
      datestr[LEN_DATSTRING]:STRING -> added for xpkrev


  -> misc
  DEF bumpflag=FALSE      :LONG,  -> ...
      commandstring[256]  :STRING -> cmd-string for execute (compile)




/*---------------------------  read args  ---------------------------*/


  GetProgramName(exefile,256)
  readargs:=ReadArgs('NAME/A,'                 +
                     'CREATE=FORCE/S,'         +
                     'BUMPVERSION=VERSION/S,'  +
                     'DONOTCOMPILE/S,'         +
                     'ECFILEPATH/K,'           +
                     'BUMPINFO=INFO/S,'        +
                     'BUMPMODES=MODES/S'     ,
       args:=[NIL,FALSE,FALSE,FALSE,'EC',FALSE,FALSE],NIL)
  StrCopy(exefile,args[0])
  forcebump:=args[1]
  bumpversion:=args[2]
  donotcompile:=args[3]
  StrCopy(ecpath,args[4])
  bumpinfo:=args[5]
  bumpmodes:=args[6]
  FreeArgs(readargs)




/*---------------------  file names (copyright) ---------------------*/


  IF StrCmp(exefile+EstrLen(exefile)-2,'.e',2)
    MidStr(exefile,exefile,0,EstrLen(exefile)-2)
  ENDIF
  StrCopy(sourcefile,exefile)
  StrAdd(sourcefile,'.e')
  StrCopy(modfile,exefile)
  StrAdd(modfile,'.m')
  StrCopy(bumpfile,exefile)
  StrAdd(bumpfile,'_xpkrev.e')

  -> print out a copyright notice with actual version information
  PrintF('xpkrev \d.\d Changed for use with xpk sublibraries by Torgil Svensson.\n\n'+
         'Original program: Bumpee 1.44 (6.1.95) © 1995 by Leon Woestenberg\n\n',
         VERSION,REVISION)

  -> look for source
  IF FileLength(sourcefile) = 0 THEN Raise(ERR_NO_SOURCE)




/*--------------------------  datestring  ---------------------------*/


  -> create dos datestring
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

  -> create new datestr.
  IF year < 78 THEN StrCopy(datestr,'20',2) ELSE StrCopy(datestr,'19',2)
  StrAdd(datestr,datestring+6,2)  -> year
  StrAdd(datestr,datestring+2,4)  -> -month-
  StrAdd(datestr,datestring,2)    -> day




/*------------------------  bump versions  --------------------------*/


  IF bumpfh:=Open(bumpfile,MODE_OLDFILE)


/*
** set bumpflag if exefile newer than bumpfile (dates)
** else raise exception
*/

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


    IF bumpflag = FALSE THEN Raise(ERR_LAST_COMPILED)


/*
**  read the versions from the BUMP structure
**  note that MODES/INFO_VERSION must be tested before VERSION
*/

    WHILE Fgets(bumpfh,bumpcontents,1023)
      IF InStr(bumpcontents,'BUMP')<>-1
        WHILE Fgets(bumpfh,bumpcontents,1023)
           EXIT InStr(bumpcontents,'ENDBUMP')<>-1
           IF InStr(bumpcontents,'NAME=')<>-1
             MidStr(name,bumpcontents,InStr(bumpcontents,'=')+1)
             SetStr(name,StrLen(name)-1)
           ELSEIF InStr(bumpcontents,'INFO_VERSION=')<>-1
             info_version:=Val(bumpcontents+InStr(bumpcontents,'=')+1)
           ELSEIF InStr(bumpcontents,'MODES_VERSION=')<>-1
             modes_version:=Val(bumpcontents+InStr(bumpcontents,'=')+1)
           ELSEIF InStr(bumpcontents,' VERSION=')<>-1
             version:=Val(bumpcontents+InStr(bumpcontents,'=')+1)
           ELSEIF InStr(bumpcontents,' REVISION=')<>-1
             revision:=Val(bumpcontents+InStr(bumpcontents,'=')+1)
           ENDIF
        ENDWHILE
      ENDIF
      EXIT StrCmp(bumpcontents,'ENDBUMP')
    ENDWHILE


/*
**  Bump version-numbers
*/

    IF bumpinfo
      info_version  := info_version  + 1
      PrintF('Bumping xpkInfo structure verision to \d\n',info_version)
    ENDIF
    IF bumpmodes
      modes_version  := modes_version  + 1
      PrintF('Bumping xpk mode descriptors verision to \d\n',modes_version)
    ENDIF
    IF bumpversion
      version:=version+1
      revision:=0
      PrintF('Bumping version to \d.\d...',version,revision)
    ELSE
      revision:=revision+1
      PrintF('Bumping revision to \d.\d...',version,revision)
    ENDIF
    Close(bumpfh)

  ELSE  ->  if Open(bumpfile,...) failed


/*
** Bumpfile does not exist
** Create new bumpfile if CREATE (forcebump) option is set.
*/

    IF forcebump = FALSE THEN Raise(ERR_NO_BUMPFILE)
    StrCopy(name,FilePart(exefile))
    UpperStr(name)
    bumpflag:=TRUE
    PrintF('Creating bump module...')

  ENDIF




/*-------------------  save/compile new bumpfile  -------------------*/


  IF bumpflag


/*
** (Re)write Bumpfile with new values
*/

    DeleteFile(bumpfile)
    IF FileLength(bumpfile)<>-1 THEN Raise(ERR_BUMP_DELETE)
    bumpfh:=Open(bumpfile,MODE_NEWFILE)
    IF bumpfh = NIL THEN Raise(ERR_OPEN_BUMP_WRITE)

    StringF(bumpcontents,'-> xpkrev module. Do not alter this file manually.\n\n'+
                         'OPT MODULE\n'+
                         'OPT EXPORT\n'+
                         'OPT PREPROCESS\n'+
                         '\n'+
                         '/*\n'+
                         'BUMP\n'+
                         '  NAME=\s\n'+
                         '  VERSION=\d\n'+
                         '  REVISION=\d\n'+
                         '  INFO_VERSION=\d\n'+
                         '  MODES_VERSION=\d\n'+
                         'ENDBUMP\n'+
                         '*/\n'+
                         '\n'+
                         'CONST VERSION=\d\n'+
                         'CONST REVISION=\d\n'+
                         'CONST INFO_VERSION=\d\n'+
                         'CONST MODES_VERSION=\d\n'+
                         '\n'+
                         'CONST VERSION_DAY=\d\n'+
                         'CONST VERSION_MONTH=\d\n'+
                         'CONST VERSION_YEAR=\d\n'+
                         '\n'+
                         'CONST LIB_ID="\s"\n'+
                         '\n'+
                         '#define LIB_VERSION \a\d\a\n'+
                         '#define LIB_REVISION \a\d\a\n'+
                         '\n'+
                         '#define LIB_NAME \a\s\a\n'+
                         '#define LIB_FULL_NAME \axpk\s.library\a\n'+
                         '#define LIB_DATE \a\s\a\n'+
                         '#define LIB_VERSTR '+
                         '\a$VER: xpk\s.library \d.\d (\s)\a\n'+
                         '\n'+
                         '#define VERSION_STRING {version_string}\n'+
                         '#define VERSION_INFO {version_info}\n'+
                         '\n'+
                         'PROC dummy() IS NIL\n'+
                         '\n'+
                         'version_string:\n'+
                         'CHAR \a$VER: \a\n'+
                         'version_info:\n'+
                         'CHAR \axpk\s.library \d.\d (\s)\a,0\n',
                         name,
                         version,
                         revision,
                         info_version,
                         modes_version,
                         version,
                         revision,
                         info_version,
                         modes_version,
                         day,
                         month,
                         year,
                         name,      -> LIB_ID
                         version,   -> LIB_VERSION
                         revision,  -> LIB_REVISION
                         name,      -> LIB_NAME
                         name,      -> LIB_FULL_NAME
                         datestr,   -> LIB_DATE
                         name, version, revision, datestr,
                         name, version, revision, datestr)
    Fputs(bumpfh,bumpcontents)
    Close(bumpfh)
    PrintF('Done.\n')


/*
** Compile bumpfile
*/

    IF donotcompile
    ELSE
      StringF(commandstring,'\s \s',ecpath,bumpfile)
      Execute(commandstring,NIL,NIL)
    ENDIF
  ENDIF




/*--------------------------  exceptions  ---------------------------*/


EXCEPT
  SELECT exception

    CASE ERR_ARGS
      PrintFault(IoErr(),exefile)

    CASE ERR_NO_SOURCE
      PrintF('Sourcefile \a\s\a not found...xpkrev did nothing.\n',sourcefile)

    CASE ERR_LAST_COMPILED
      PrintF('Last revision still uncompiled...No need to bump.\n')

    CASE ERR_NO_BUMPFILE
      PrintF('No bumpfile (_xpkrev.e) exists for \a\s\a...xpkrev did nothing.\n'+
             'Set CREATE switch to create a bumpfile.\n',exefile)

    CASE ERR_BUMP_DELETE
      PrintF('\nCouldn\at rewrite (delete) bumpfile. Remove delete protection.\n')

    CASE ERR_OPEN_BUMP_WRITE
      PrintF('\n')
      PrintFault(IoErr(),bumpfile)

  ENDSELECT
ENDPROC
