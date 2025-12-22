GOTO SkipVer {*** version string ***}
ASSEM
EVEN
DC.B "$VER: dBView 1.0.5 (28.03.97)"
EVEN
END ASSEM
SkipVer:

WINDOW 5,"dBView 1.0.5",(0,0)-(640,200)
DEFLNG a - z {*** for speed reasons ***}
CONST DBFBUFLEN&=4097 {*** Buffer length ***}
DIM q&(257) {*** holds field lengths ***}
ext$=".DBF" {*** default file name extension ***}
reverse$=empty$ {*** empty$ is empty ***}

{*** SUB declarations ***}

DECLARE SUB STRING ibm2ansi(cvi$)
DECLARE SUB STRING trim(a$)
DECLARE SUB XBCVI(a$)
DECLARE SUB XBCVL(a$)

LIBRARY "exec.library"
DECLARE FUNCTION AllocMem&(l&,r&) LIBRARY "exec"
DECLARE FUNCTION FreeMem&(b&,l&) LIBRARY "exec"

LIBRARY "dos.library"
DECLARE FUNCTION _Open&(n&,m&) LIBRARY "dos"
DECLARE FUNCTION _Close&(fh&) LIBRARY "dos"
DECLARE FUNCTION _Read&(fh&,buf&,l&) LIBRARY "dos"
DECLARE FUNCTION Delay&(dti&) LIBRARY "dos"
DECLARE FUNCTION Seek&(fh&,p&,m&) LIBRARY "dos"

{*** ASCII to ANSI conversion: setup ***}

DIM dbfansi$(300)
RESTORE 
FOR i%=0 TO 257
  READ t%
  dbfansi$(i%)=CHR$(t%)
NEXT i%

{*** Main ***}

back$=FILEBOX$(".DBF-Datei anzeigen")

IF back$>"" THEN
  {*** Open file ***}
  fhbuf&=AllocMem&(DBFBUFLEN&,65539&)
  bac$=back$+CHR$(0)
  back&=SADD(bac$)
  fhdos&=_Open&(back&,1004)
  r&=_Read&(fhdos&,fhbuf&,1)
  dbfvers$=CHR$(PEEK(fhbuf&))
  dbf&=ASC(dbfvers$) {*** dBase version flag ***}
  update$=empty$ {*** holds creation date... ***}
  r&=_Read(fhdos&,fhbuf&,1)
  update$=STR$(PEEK(fhbuf&))
  r&=_Read(fhdos&,fhbuf&,1)
  update$=STR$(PEEK(fhbuf&))+"."+update$
  r&=_Read(fhdos&,fhbuf&,1)
  update$=STR$(PEEK(fhbuf&))+"."+update$
  r&=_Read&(fhdos&,fhbuf&,4)
  intelinteger$=CHR$(PEEK(fhbuf&+3))+CHR$(PEEK(fhbuf&+2))+CHR$(PEEK(fhbuf&+1))+CHR$(PEEK(fhbuf&))
  reccount&=XBCVL(intelinteger$) {*** record count ***}
  r&=_Read&(fhdos&,fhbuf&,2)
  intelinteger$=CHR$(PEEK(fhbuf&+1))+CHR$(PEEK(fhbuf&))
  headerlength&=XBCVI(intelinteger$)
  r&=_Read&(fhdos&,fhbuf&,2)
  intelinteger$=CHR$(PEEK(fhbuf&+1))+CHR$(PEEK(fhbuf&))
  reclength&=XBCVI(intelinteger$) {*** record length ***}
  fieldcount&=(headerlength&-1)/32-1
  {*** Processing dBase file header information ***}
  DIM fld_nam$(257),fldtyp$(257),fldadr&(257)
  DIM fldlen&(257),fld_dec&(257)
  dbf$="<unknown>"
  dbt$=dbf$
  db3p$="Ashton Tate dBASE III+"
  fp25$="Microsoft FoxPro 2.5"
  la3$="Lotus Approach 3.0 [dBASE IV]"
  IF dbf&=3 THEN
    dbf$=db3p$
    dbt$="<none>"
  END IF
  IF dbf&=131 THEN
    dbf$=db3p$
    dbt$=LEFT$(back$,LEN(back$)-3)+"DBT"
  END IF
  IF dbf&=139 THEN
    dbf$=la3$
    dbt$=LEFT$(back$,LEN(back$)-3)+"DBT"
  END IF
  IF dbf&=245 THEN
    dbf$=fp25$
    dbt$=LEFT$(back$,LEN(back$)-3)+"FPT"
  END IF
  {*** Display header information ***}
  PRINT "1. File"
  PRINT "--------"
  PRINT
  PRINT "Name:          ";back$
  PRINT "Version :      ";dbf$
  PRINT "Memos:         ";dbt$
  PRINT "Date:          ";update$
  PRINT "Fields:        ";fieldcount&
  PRINT "Records:       ";reccount&
  PRINT "Header length: ";headerlength&
  PRINT
  INPUT , a$
  field&=0
  FOR i& = 1 TO fieldcount&
    CLS
    PRINT "2. Fields"
    PRINT "---------"    
    PRINT
    r&=Seek&(fhdos&,(32*i&),(-1&))
    r&=_Read&(fhdos&,fhbuf&,11&)
    POKE fhbuf&+11,0
    PRINT "Field: ";i&
    fldnam$=CSTR(fhbuf&)
    fld_nam$(i&)=fldnam$:
    PRINT "Name: ";fld_nam$(i&)
    r&=_Read&(fhdos&,fhbuf&,1&)
    fldtyp$(i&)=CHR$(PEEK(fhbuf&))
    PRINT "Type: ";fldtyp$(i&)
    r&=_Read&(fhdos&,fhbuf&,4&)
    intelinteger$=CHR$(PEEK(fhbuf&+3))+CHR$(PEEK(fhbuf&+2))+CHR$(PEEK(fhbuf&+1))+CHR$(PEEK(fhbuf&))
    fldadr&(i&)=XBCVL(intelinteger$)
    PRINT "Address: ";fldadr&(i&)
    r&=_Read&(fhdos&,fhbuf&,1&)
    fldlen&(i&)=PEEK(fhbuf&)
    PRINT "Length: ";fldlen&(i&);",";
    r&=_Read&(fhdos&,fhbuf&,1&)
    fld_dec&(i&)=PEEK(fhbuf&)
    PRINT fld_dec&(i&)
    IF fldtyp$(i&)="M" THEN
      q&(i&)=0
    ELSE
      ++field&
      q&(i&)=fldlen&(i&)
    END IF
    IF fldtyp$(i&)="D" THEN
      q&(i&)=q&(i&)+2
    END IF
    INPUT , a$
  NEXT i&
    CLS
    PRINT "3. Record contents"
    PRINT "------------------"
    PRINT
    ic$="J"
  PRINT "Convert IBM ASCII to ANSI (Y|N) ";
  INPUT ic$
  IF UCASE$(ic$)="Y" THEN
    ic! = 1 {*** ANSI conversion flag ***}
  ELSE
    ic! = 0
  END IF
  PRINT
  PRINT
  i&=1
  WHILE UCASE$(proceed$)<>"Q"
    p&=Seek&(fhdos&,headerlength&+reclength&*(i&-1),-1&)
    r&=_Read&(fhdos&,fhbuf&,1&)
    recdel$=CHR$(PEEK(fhbuf&)) {*** record deletion mark set by dBase ***}
    out$= empty$
    CLS
    PRINT "3. Record contents"
    PRINT "------------------"
    PRINT
    PRINT "Record: ";i&;
    LOCATE CSRLIN,50
    IF recdel$="*" THEN
      PRINT "*Deleted*"
    END IF
    PRINT
    FOR t&=1 TO fieldcount&
      PRINT fld_nam$(t&);":";
      LOCATE CSRLIN,15
      r&=_Read&(fhdos&,fhbuf&,fldlen&(t&))
      POKE fhbuf&+fldlen&(t&),0
      a$=CSTR(fhbuf&)
      d$ = empty$
      ft$= fldtyp$(t&)
      IF ft$ = "C" THEN {*** character ***}
        IF ic! THEN
          d$=ibm2ansi(a$)
        ELSE
          d$=a$
        END IF
      END IF
      IF ft$ = "N" THEN {*** number ***}
        IF fld_dec&(t&)=0 THEN
          d$=a$
        ELSE
          d$=LEFT$(a$,fldlen&(t&)-fld_dec&(t&)-1)+"."+MID$(a$,fldlen&(t&)-fld_dec&(t&)+1)
          IF LEFT$(d$,1)="." THEN
            d$=MID$(d$,2)
          END IF
        END IF
        uix&=INSTR(d$,",")
        IF uix&<>0 THEN
          d$=LEFT$(d$,uix&)+"."+MID$(d$,uix& + 1)
        END IF
      END IF
      IF ft$ = "D" THEN {*** date ***}
        d$=RIGHT$(a$,2)+"."+MID$(a$,5,2)+"."+LEFT$(a$,4)
      END IF
      IF ft$ = "M" THEN {*** memo ***}
        d$="<Memos are not supported>"
      END IF
      IF ft$="L" THEN {boolean / logical}
        d$=a$
      END IF
      PRINT d$ {*** field contents ***}
      {You can convert the dBase file to a sequential file by writing the string
       d$ to disk. Have a look at the ACE documentation to see how sequential
       files are handled.}
      IF INKEY$<>"" THEN
        INPUT , x$
      END IF
    NEXT t&
    INPUT , proceed$ {*** Proceed? ***}
    IF proceed$="+" THEN
      ++i&
    END IF
    IF proceed$="*" THEN
      i& = i& + 10
    END IF
    IF proceed$="-" THEN
      --i&
    END IF
    IF proceed$="_" THEN
      i& = i& - 10
    END IF  
    IF (i& > reccount&) THEN
      i&=1
    END IF
    IF (i& < 1) THEN
      i&=reccount&
    END IF
  WEND
  {*** Cleanup ***}
  r&=_Close&(fhdos&)
  r&=FreeMem&(fhbuf&,DBFBUFLEN&)
END IF
WINDOW CLOSE 5
END

SUB STRING ibm2ansi(tvi$)
{This sub converts an ASCII string to ANSI.}
  SHARED dbfansi$
  FOR tt&=1 TO LEN(tvi$)
    ft%=ASC(MID$(tvi$,tt&,1))
    tvw$=dbfansi$(ft%)
    IF (ASC(tvw$) <> 1) THEN
      ibm2a$=ibm2a$+tvw$
    END IF
  NEXT tt&
 ibm2ansi=ibm2a$
END SUB

SUB STRING trim(a$)
{Deletes leading / trailing blanks and control characters.}
  tr$ = empty$
  FOR tr& = 1 TO LEN(a$)
    IF ((ASC(MID$(a$,tr&,1))) AND 127) > 32 THEN
      tr$=tr$+MID$(a$,tr&,1)
    END IF
  NEXT tr&
  trim=tr$
END SUB

SUB XBCVI(A$)
{Emulates the CVI() function of standard Basic. It converts a string of
 one or to bytes to an integer value.}
  IF LEN(a$) = 2 THEN
    XBCVI=ASC(left$(a$,1))*256 + ASC(RIGHT$(a$,1))
  ELSE
    XBCVI = ASC(a$)
  END IF
END SUB

SUB XBCVL(a$)
{Emulates the CVL() function of standard Basic. It converts a four byte
 string to a long integer value.}
  cv = ASC(MID$(a$,1,1))
  cv = cv + ASC(MID$(a$,2,1)) * 256
  cv = cv + ASC(MID$(a$,3,1)) * 65536
  cv = cv + ASC(MID$(a$,4,1)) * 16777216
  XBCVL = cv
END SUB

{*** Data for ASCII to ANSI conversion ***}

DATA 1, 1, 1, 1, 1, 1, 1, 183, 176, 1, 1, 1, 1, 1, 1, 45, 1, 1
DATA 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 32, 33, 34, 35, 36
DATA 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55
DATA 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74
DATA 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93
DATA 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109
DATA 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124
DATA 125, 126, 1, 199, 252, 233, 226, 228, 224, 229, 231, 234, 235, 232, 239
DATA 238, 236, 196, 197, 201, 230, 198, 244, 246, 242, 251, 249, 255, 214, 220
DATA 162, 163, 165, 1, 1, 225, 237, 243, 250, 241, 209, 170, 186, 191, 1, 172
DATA 189, 188, 161, 171, 187, 1, 1, 1, 124, 1, 1, 1, 1, 1, 1, 1, 1
DATA 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
DATA 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
DATA 223, 1, 182, 1, 1, 181, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 177, 1
DATA 1, 1, 1, 1, 1, 176, 183, 183, 1, 1, 178, 183, 32, 1, 1, 1, 1, 1

