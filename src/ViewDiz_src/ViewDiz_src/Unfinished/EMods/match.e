/*
   Input:  Longword array of files (with or without patterncodes).
           For example FILE/M returned by ReadArgs()
   Output: Longword array of matching files and files processed
   Note:   Directories are ignored !
   Author: Mikael Lund, 18.11.98
*/

OPT MODULE
MODULE 'dos/dos', 'dos/dosasl'

EXPORT PROC match( src:PTR TO LONG, max )
  DEF cnt=0, i=0, err=0, dest:PTR TO LONG, pat[200]:STRING,
      ap:PTR TO anchorpath, rc=FALSE, lock=NIL

  IF dest:=New( max*4+4 )
    WHILE src[i]
      IF ParsePatternNoCase( src[i], pat, StrMax(pat) )=1
        ap:=New( SIZEOF anchorpath + 100 + 4 )
        ap.breakbits:=0
        ap.strlen:=100
        
        err:=MatchFirst(src[i], ap)
        IF err=0
          IF ap.info.direntrytype<0
            dest[cnt]:=estr(ap.info+SIZEOF fileinfoblock)
            INC cnt
          ENDIF
          WHILE err=0
            err:=MatchNext( ap )
            IF err=0
              IF ap.info.direntrytype<0
                dest[cnt]:=estr(ap.info+SIZEOF fileinfoblock)
                INC cnt
              ENDIF
            ENDIF
            IF cnt>=max THEN err:=-1
          ENDWHILE
        ENDIF
        MatchEnd( ap )
      ELSE
        IF lock:=Lock(src[i], SHARED_LOCK)
          dest[cnt]:=estr(src[i])
          UnLock(lock)
        ELSE
          dest[cnt]:=NIL
        ENDIF
        INC cnt
      ENDIF
      IF cnt>=max THEN RETURN dest, cnt
      INC i
    ENDWHILE
    rc:=dest
  ENDIF
ENDPROC rc, cnt

EXPORT PROC freematch( file:PTR TO LONG, files )
  DEF i
  FOR i:=0 TO files
    IF file[i]<>NIL THEN DisposeLink( file[i])
  ENDFOR
ENDPROC

-> Convert string to estring using dynamic allocation
PROC estr( str )
  DEF estr
  estr:=String( StrLen(str) )
  StrCopy( estr, str )
ENDPROC estr
