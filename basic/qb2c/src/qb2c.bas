REM  qb2c-3.2k QuickBASIC to C converter version 04/04/1996 rev XX.XX.XXXX
REM  Cast by Mario Stipcevic, Rudjer Boskovic Institute, Zagreb, Croatia
REM  E-mail: stipcevi@rudjer.irb.hr URL: http://faust.irb.hr/~stipy
REM  This is (itself !) a QB2C code. Translate it with: qb2c -c -t qb2c
DECLARE SUB varpost (line$)
DECLARE SUB quadrix (h$)
DECLARE SUB inputfmt (list$, formt$, prt$, ntok%, flag%)
DECLARE SUB declarix (typ$, varlist$, dn%)
DECLARE SUB splitdec (varlist$, ntok%, dn%)
DECLARE SUB stringx (h$)
DECLARE SUB brackets (h$)
DECLARE SUB printfmt (h$, formt$, prt$, nflag%)
DECLARE SUB arraydim (h$)
DECLARE SUB vartyp (tok$, ttyp%)
DECLARE SUB tokenix (h$, ntok%, sep$, sep2$)
DECLARE SUB mathexp (h$)
DECLARE SUB sparser (h$, i%, bin$)
DECLARE SUB qbfunc ()
DECLARE SUB qbfdecl ()
DECLARE SUB logix (h$)
DECLARE SUB gulix (h$)

CONST NSMX = 72: REM Max no of SUBroutines
CONST NTKM = 30: REM Max no of lines per phys. line
CONST GMAX = 16: REM Max level of nesting GOSUBs
CONST NCMX = 20: REM Max number of CONSTants
CONST CMAX = 15: REM Max number of CH and CM lines (-C flag on)
CONST TMAX = 120: REM Max dimension of tmp$()

DIM tmp%(16): REM for various temporary use (eg. 600,...)
DIM tmp$(TMAX): REM for temporary use (tokens from tokenix etc.) 
DIM temp$(10): REM another temporary use
DIM tok%(NTKM): REM Used in (spliter 900)
DIM ctok$(12): REM COMMAND$ tokens
DIM atmp$(50, |80): REM List of possibly used arrays in a SUB
DIM shrd$(200, |80): REM contains list of all SHARED variables and arrays
DIM shtok$(NSMX, TMAX, |80): REM SHARED variables and arrays storage
DIM statfl%(NSMX): REM Static variables flags for SUBs
DIM nshtok%(NSMX): REM Max second index in shtok$(,) and statfl%()
DIM linetok$(NTKM): REM Line tokens (spliter 900)
DIM cnst$(NCMX, |80), tcnst$(NCMX, |80): REM global CONST-ant declarations
DIM vari$(NSMX): REM Declaration strings. Toliko subrutina max.
DIM varr$(NSMX), vars$(NSMX), varl$(NSMX), vard$(NSMX), varb$(NSMX)
DIM fopen%(20): REM (max No of SUBs, max No open files)
DIM lfopen$(21), lfopen%(21)
DIM subvar$(NSMX, 21, |255): DIM nsubvar%(NSMX): REM Lists of arguments of all SUBs
DIM subname$(NSMX): REM user SUB names
DIM vlist$(NSMX, 200, |80): DIM nvlist%(NSMX): REM List of local variables
DIM funames$(NSMX, |80): REM Names of user FUNCTIONs
DIM funtyl$(NSMX): REM variable type lists for FUNCTION declaration
DIM funcfl%(NSMX): REM funcfl%(i) set to 1 if i-th sub is a FUNCTION
DIM darr$(80, |80), alist%(30): REM list of SHARED arrays which are used in MAIN
DIM atyp$(8)
DIM cg$(CMAX), cm$(CMAX): REM global and MAIN declarations

c$ = COMMAND$
tttt = TIMER
Version$ = "3.2k 29.Mar.1999 Free version."
fff$ = "": REM contains *fp pointers of all SUBs and MAIN
statfl%(0) = 1: REM variables in MAIN are always static
nfuncs% = 0: REM Number of user FUNCTIONs
nSHRDtk% = 0: REM Number of global SHARED variables
shred$ = "": REM all shared variables string
lspac% = 1: spc$ = SPACE$(lspac%): REM Left margin level counter
nsub% = 0: REM Number of subroutines
jopn% = 0: REM translation-time 'OPEN' counter
nlopen% = 0: REM dynamic last-OPEN-file counter
expflg% = 0: REM Pure expression ( x = ... ) flag ( for -m, see mathexp )
endmain% = 0
usersub% = 0: REM User SUB or FUNCTION usage flag
initline% = 0: ni% = 0: REM for initialization commands which appear in MAIN
chartfl% = 0: longtfl% = 0: floattfl% = 0: inttfl% = 0: byttfl% = 0
ncg% = 0: ncm% = 0: REM number of global and MAIN declarations
b$ = TIME$
tmpfile$ = "tmp" + MID$(b$, 3) + ".b2c"
C tmpfile_S[3]='-';
C tmpfile_S[6]='-';
atyp$(0) = "short ": atyp$(1) = "int   ": atyp$(2) = "long  "
atyp$(3) = "float ": atyp$(4) = "double ": atyp$(5) = "char  "
atyp$(8) = "unsigned char "

SHELL "rm -f tmp-??-??.b2c"
GOSUB 50000: REM tokenization of command$
REM Order of the two below is IMPORTANT
 REM PRINT "entering 800: ", TIMER
GOSUB 800: REM preprocessing global SHARED variables
 REM PRINT "entering 700: ", TIMER
GOSUB 700: REM preprocessing for variable types in SUB's
 REM PRINT "entering 600: ", TIMER
GOSUB 600: REM preprocessing for file OPEN
 REM PRINT "entering 650: ", TIMER
GOSUB 650: REM Reseting different flags, COMMAND$
 REM PRINT "Exiting pp : ", TIMER
OPEN outf$ FOR OUTPUT AS #2
IF commff% = 1 THEN
 PRINT #2, "main(int n__arg, char *argv[])"
ELSE
 PRINT #2, "main()"
END IF
PRINT #2, "{"
ni% = 2
nl% = 0: isub% = 0: statfl%(0) = 1: nlmax% = 32767
REM lista varijabli:
tmpfl% = 0: int$ = " int  ": float$ = " float "
IF longflg% = 1 THEN int$ = " long "
IF doblflg% = 1 THEN float$ = " double "
IF vari$(isub%) <> "" THEN CALL declarix(int$, vari$(isub%), 3): tmpfl% = 1
IF varr$(isub%) <> "" THEN CALL declarix(float$, varr$(isub%), 0): tmpfl% = 1
IF vars$(isub%) <> "" THEN CALL declarix(" char ", vars$(isub%), 1): tmpfl% = 1
IF varl$(isub%) <> "" THEN CALL declarix(" long ", varl$(isub%), 4): tmpfl% = 1
IF vard$(isub%) <> "" THEN CALL declarix(" double ", vard$(isub%), 0): tmpfl% = 1
IF varb$(isub%) <> "" THEN CALL declarix(" unsigned char ", varb$(isub%), 0): tmpfl% = 1
REM Explicit declarations with CM
IF ncm% > 0 THEN
 FOR i% = 1 TO ncm%
  PRINT #2, " " + cm$(i%)
 NEXT i%
 tmpfl% = 1
 ni% = ni% + ncm%
END IF 
IF tmpfl% = 1 THEN PRINT #2, : ni% = ni% + 1
initline% = ni%
GOSUB 31000: REM Make a list of possibly used arrays in MAIN
REM Main processor:
OPEN tmpfile$ FOR INPUT AS #1
 DO WHILE NOT EOF(1)
  LINE INPUT #1, line$
  nl% = nl% + 1
  IF nl% >= nlmax% THEN
   PRINT "Max. number of input lines"; nlmax%; " reached, aborting."
C  exit(1);
  END IF
  REM croff:
C if (line_S[strlen(line_S)-1] == 13) line_S[strlen(line_S)-1]='\0'; 
  REM C text lines:
  IF cflag% = 1 THEN
C  if (memcmp(line_S,"C ",2) == 0)
C  {
    PRINT #2, line$ 
    IF isub% = 0 THEN ni% = ni% + 1
    GOTO 90
C  }
C  if (memcmp(line_S,"CG ",3) == 0 || memcmp(line_S,"CH ",3) == 0 || memcmp(line_S,"CM ",3) == 0)
C  {
    IF isub% = 0 THEN ni% = ni% + 1
    GOTO 90
C  }
  END IF
  GOSUB 900: REM line splitter
  IF ntok% > 0 THEN
   itok% = 1
   DO WHILE itok% <= ntok%
    GOSUB 30000: REM a nicer 'REM' preprocessor
    a$ = linetok$(itok%)
    IF a$ = "" THEN
     IF ntok% = 1 THEN
      PRINT #2,
      IF isub% = 0 THEN ni% = ni% + 1
     END IF
    ELSE
     GOSUB 500: REM Translator
    END IF
    itok% = itok% + 1
   LOOP
  ELSE
   GOSUB 1500: REM Check if end of main
   PRINT #2,
   IF isub% = 0 THEN ni% = ni% + 1
  END IF
90 LOOP
CLOSE #1
IF endmain% = 0 THEN GOSUB 1501
IF usersub% = 1 THEN PRINT #2, "/*- User SUBs--End -*/"
IF extrnfl% = 1 THEN
 PRINT #2,
 PRINT #2, "/* Translates of used QB's intrinsic functions: */"
 CALL qbfunc: REM Writing out C translates of intrinsic QB functions used
END IF
CLOSE #2
REM Add pointer prefixes to variables in SUBs
 GOSUB 45000
REM changing original QB variable names to suit C gramar, default = yes
IF postflg% = 1 THEN
 GOSUB 40000
END IF
GOTO 9999


500 REM Translator
  commfl% = 0
C if ( memcmp(a_S,"REM",3)==0 ) {
  GOSUB 2000: REM REM
C }
  GOSUB 1500: REM END
C   if ( commfl_int==1 ) goto Lab_509;
  GOSUB 1000: REM SUB, FUNCTION
C   if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"SHARED",6)==0 ) {
  GOSUB 1250: REM SHARED
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"DECLARE",7)==0 ) {
  GOSUB 2500: REM DECLARE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"CONST",5)==0 ) {
  GOSUB 2600: REM CONST
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"DIM ",4)==0 ) {
  GOSUB 2750: REM DIM
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"IF ",3)==0 ) {
  GOSUB 3000: REM IF
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"ELSE",4)==0 ) {
  GOSUB 3250: REM ELSE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"END IF",6)==0 ) {
  GOSUB 3500: REM END IF
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"DO WHILE",8)==0 || memcmp(a_S,"WHILE",5)==0 || memcmp(a_S,"DO UNTIL",8)==0 ) {
  GOSUB 3750: REM DO WHILE or WHILE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"LOOP",4)==0 || memcmp(a_S,"WEND",4)==0 ) {
  GOSUB 3900: REM LOOP     or WEND
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PRINT #",7)==0 ) {
  GOSUB 4000: REM PRINT #
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"LINE INPUT #",12)==0 ) {
  GOSUB 4500: REM LINE INPUT #
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PRINT",5)==0 || memcmp(a_S,"EPRINT",6)==0 ) {
  GOSUB 5000: REM PRINT, EPRINT
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"LOCATE ",7)==0 ) {
  GOSUB 5100: REM LOCATE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"COLOR",5)==0 ) {
  GOSUB 5200: REM COLOR
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"CLS",3)==0 ) {
  GOSUB 5300: REM CLS
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"INPUT #",7)==0 ) {
  GOSUB 5500: REM INPUT #
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"INPUT",5)==0 ) {
  GOSUB 5750: REM INPUT
C } if ( commfl_int==1 ) goto Lab_509;
  GOSUB 6000: REM Labels
C   if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"GOTO ",5)==0 ) {
  GOSUB 6500: REM GOTO
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"CALL",4)==0 ) {
  GOSUB 7000: REM CALL
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"LET",3)==0 ) {
  GOSUB 7500: REM LET
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"FOR ",4)==0 ) {
  GOSUB 8000: REM FOR..TO..STEP
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"NEXT",4)==0 ) {
  GOSUB 8500: REM NEXT
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"OPEN",4)==0 ) {
  GOSUB 9000: REM OPEN
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"CLOSE",5)==0 ) {
  GOSUB 9500: REM CLOSE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"GOSUB ",6)==0 ) {
  GOSUB 11000: REM GOSUB
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"RETURN",6)==0 ) {
  GOSUB 11500: REM RETURN
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"RANDOMIZE",9)==0 ) {
  GOSUB 12000: REM RANDOMIZE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PAUSE ",6)==0 ) {
  GOSUB 12200: REM PAUSE
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"SHELL",5)==0 ) {
  GOSUB 17000: REM SHELL
C } if ( commfl_int==1 ) goto Lab_509;
  GOSUB 18000: REM expressions
C   if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"END SUB",7)==0 || memcmp(a_S,"END FUNCTION",12)==0 ) {
  GOSUB 19000: REM END SUB, END FUNCTION
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"EXIT SUB",8)==0 ) {
  GOSUB 19100: REM EXIT SUB
C } if ( commfl_int==1 ) goto Lab_509;

REM   G R A P H I C S
C if ( memcmp(a_S,"LINE (",6)==0 ) {
   GOSUB 20000: REM LINE (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"MARKER ",7)==0 ) {
   GOSUB 24000: REM MARKER (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PLINE ",6)==0 ) {
   GOSUB 24500: REM PLINE (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PMARKER ",8)==0 ) {
   GOSUB 25000: REM PMARKER (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PSET ",5)==0 ) {
   GOSUB 20500: REM PSET (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XUPDATE",7)==0 ) {
   GOSUB 23000: REM XUPDATE (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XCLS",4)==0 ) {
   GOSUB 23200: REM XCLS (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XSELWI",6)==0 || memcmp(a_S,"XCLOSE",6)==0 || memcmp(a_S,"XCURSOR",7)==0) {
   GOSUB 23400: REM "XSELWI" and/or "XCLOSE" and/or "XCURSOR" (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PALETTE ",8)==0 ) {
   GOSUB 23500: REM PALETTE (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"GETCOL ",7)==0 ) {
   GOSUB 23300: REM GETCOL (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"SCREEN ",7)==0 || memcmp(a_S,"XWINDOW ",8)==0) {
   GOSUB 21000: REM "SCREEN " and/or "XWINDOW " (graphics) 
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"SET ",4)==0 ) {
   GOSUB 21500: REM SET  (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"SAVEGIF ",8)==0 ) {
   GOSUB 22000: REM SAVEGIF (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"LOADGIF ",8)==0 ) {
   GOSUB 22500: REM LOADGIF (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"GIFINFO ",8)==0 ) {
   GOSUB 22600: REM GIFINFO (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XTEXT ",6)==0 ) {
   GOSUB 25500: REM XTEXT (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"FAREA ",6)==0 ) {
   GOSUB 26000: REM FAREA (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"CIRCLE ",7)==0 ) {
   GOSUB 26500: REM CIRCLE (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"GCGET ",6)==0 ) {
   GOSUB 27000: REM GCGET (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XPOINTER ",9)==0 ) {
   GOSUB 27500: REM XPOINTER (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XTITLE ",7)==0 ) {
   GOSUB 23600: REM XTITLE (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XREQST ",7)==0 ) {
   GOSUB 23700: REM XREQST (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XCLIP ",6)==0 ) {
   GOSUB 23800: REM XCLIP (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XNOCLI ",7)==0 ) {
   GOSUB 23900: REM XNOCLI (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"XWARP ",6)==0 ) {
   GOSUB 23950: REM XWARP (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"GET ",4)==0 || memcmp(a_S,"XGETGE ",7)==0 ) {
   GOSUB 22100: REM GET (graphics)
C } if ( commfl_int==1 ) goto Lab_509;
C if ( memcmp(a_S,"PUT ",4)==0 || memcmp(a_S,"XANIM ",6)==0 ) {
   GOSUB 22200: REM PUT and/or XANIM (graphics)
C } if ( commfl_int==1 ) goto Lab_509;

REM In 650 defined: SPACE$, MID$, LEFT$, RIGHT$, STR$, CHR$, ASC, VAL, LEN,
REM                 SGN, INT, CINT, EOF, COMMAND$, CONST
  GOSUB 29000: REM anything else
509 RETURN: REM End Translator



600 REM preprocessing the whole file for OPEN files and for QB functions
    REM information on OPEN must be saved only cumulative (for all modules)
     nopen% = 0: nl% = 0
     OPEN inpf$ FOR INPUT AS #1
     DO WHILE NOT EOF(1)
      LINE INPUT #1, line$: nl% = nl% + 1
C     if (line_S[0] == 'C' && cflag_int)
C     {
C     if (memcmp(line_S,"C ",2)==0 || memcmp(line_S,"CG ",3)==0 || memcmp(line_S,"CH ",3)==0 || memcmp(line_S,"CM ",3)==0) goto Lab_609;
C     }
      GOSUB 900: REM spliter
      FOR g% = 1 TO ntok%
       line$ = linetok$(g%)
C      if (memcmp(line_S, "OPEN ", 5)==0)
C      {
        i% = 5: mode$ = ""
C       while (line_S[i_int-1] != '#') i_int++;
        IF mode$ = "" THEN mode$ = "r+"
        IF nopen% = 0 THEN
         nopen% = 1
         fopen%(nopen%) = VAL(MID$(line$, i% + 1, LEN(line$) - i%))
        ELSE
         tmpfl% = 1: n% = VAL(MID$(line$, i% + 1, LEN(line$) - i%))
         FOR j% = 1 TO nopen%
          IF fopen%(j%) = n% THEN tmpfl% = 0
         NEXT j%
         IF tmpfl% = 1 THEN
          nopen% = nopen% + 1
          fopen%(nopen%) = n%
         END IF
        END IF
C      }
      NEXT g%
609  LOOP
    CLOSE #1
    fff$ = ""
    IF nopen% > 0 THEN
      d$ = ""
      FOR i% = 1 TO nopen%
       n$ = STR$(fopen%(i%))
       n$ = MID$(n$, 2, LEN(n$) - 1)
       d$ = d$ + "*fp_" + n$ + ", "
      NEXT i%
      fff$ = LEFT$(d$, LEN(d$) - 2)
    END IF
    RETURN

650  REM Check for use of QB functions and fill flags used in
     REM mathexp, qbdecl, qbfunx and 41000 (=hederix)
     REM Preprocessing intrinsic QB functions.
     REM Important part is declaring functions in the preamble and
     REM appending C subroutines at the end of file.
     REM Here are gathered functions whose names or varlists need not to
     REM be changed beyond what QB2C normaly does + COMMAND$ and CONST.
     REM Others that need to be changed are implemented elsewhere (mathexp..)
     REM Also, stores all global and MAIN explicit declarations (headers)
     extrnfl% = 0: REM Set to 1 if ANY translated function is used
     mathfl% = 0: REM Set to 1 if any <math.h> function is used
     REM retrnfl% 'RETURN' usage flag, filled in 700
     funcflag% = 0: funcnam$ = "": REM =1 while main processor is in a FUNCTION
     timefl% = 0: REM Set to 1 if <time.h> needed
     pausefl% = 0: REM Set to 1 if include files for 'select' needed
     twsflg% = 0: REM Need for temporary storage string
     sigiff% = 0: REM For complicated FOR loops
     xwflag% = 0: REM If XWINDOW used on the right side
     spacff% = 0: midff% = 0: leftff% = 0:  rightff% = 0: strff% = 0
     chrff% = 0: ascff% = 0: valff% = 0: lenff% = 0: sgnff% = 0
     intff% = 0: nintff% = 0: eofff% = 0: commff% = 0: ncnst% = 0: existff% = 0
     vdblff% = 0: rndff% = 0: srndff% = 0: dateff% = 0: timeff% = 0
     timerff% = 0: inputff% = 0: inkeyff% = 0: colorff% = 0: clsff% = 0
     minff% = 0: maxff% = 0: grafflg% = 0
     REM SPACE$ -> SPACE_S
     REM MID$   -> MID_S
     REM LEFT$  -> LEFT_S
     REM RIGHT$ -> RIGHT_S
     REM STR$   -> STR_S
     REM CHR$   -> CHR_S
     REM INKEY$ -> INKEY_S()
     REM DATE$  -> DATE_S
     REM TIME$  -> TIME_S
     REM TIMER  -> TIMER()
     REM RND    -> RND(1), except if RND( then leave as is, but set rndff%
     REM ASC    -> ASC
     REM VAL    -> VAL
     REM LEN    -> LEN
     REM INT    -> Int
     REM ABS    -> fabs
     REM SGN    -> SGN
     REM CINT   -> Nint
     REM EOF(n) -> eof(fp_n)
     REM CONST -> #define
     REM MIN   -> #define
     REM MAX   -> #define
     OPEN inpf$ FOR INPUT AS #1
     OPEN tmpfile$ FOR OUTPUT AS #2
     nl% = 0
     DO WHILE NOT EOF(1)
      LINE INPUT #1, line$
      CALL gulix(line$): lleng% = LEN(line$): nl% = nl% + 1
C if (memcmp(line_S,"REM ",4) == 0)  
C {
   PRINT #2, line$
   GOTO 659
C }
  REM C text lines:
C if (cflag_int == 1 && line_S[0] == 'C')
C {
C  if (memcmp(line_S,"C ",2) == 0)
C  {
    PRINT #2, line$
    GOTO 659
C  }
C  if (memcmp(line_S,"CG ",3) == 0 || memcmp(line_S,"CH ",3) == 0)
C  {
C   if (++ncg_int > CMAX) { 
C   printf("qb2c: Max number of CH lines reached !\n");
C   printf("qb2c: Enlarge constant CMAX in qb2c and recompile it.\n"); exit(0);}
    cg$(ncg%) = MID$(line$, 4)
    PRINT #2, line$
    GOTO 659
C  }
C  if (memcmp(line_S,"CM ",3) == 0)
C  {
C   if (++ncm_int > CMAX) { 
C   printf("qb2c: Max number of CM lines reached !\n");
C   printf("qb2c: Enlarge constant CMAX in qb2c and recompile it.\n"); exit(0);}
    cm$(ncm%) = MID$(line$, 4)
    PRINT #2, line$
    GOTO 659
C  }
C }
CM static char c;
CH static int jrplc_int = 14, jnfun_int = 28, NFUN = 31, log_1, log_2;
REM jrplc% je zadnji redni broj imena (funkcije) koje treba mijenjati (od 0)
REM jnfun% je zadnji redni broj funkcije 
REM NFUN   je zadnji redni broj
CH static char *rplc_S[] = {"CINT",   "INT",    "ABS", "ATN", "SQR",
CH                          "LOG",    "SIN",    "COS",    "TAN",   "EXP",
CH                          "DATE$",  "TIME$",  "TIMER", "RND",
CH                          "INKEY$",
CH                          "SPACE$", "RIGHT$", "LEFT$",  "MID$",
CH                          "STR$",   "CHR$",   "ASC",    "VAL",
CH                          "MIN", "MAX",
CH                          "LEN",    "SGN",    "EOF", "EXISTS",
CH                          "RANDOMIZE", "SHELL",  "COMMAND$"};
C     lleng_int = strlen(line_S);
C     for(i_int=0; i_int <= NFUN; ++i_int)
C     {
C      n_int = strlen(strcpy(b_S, rplc_S[i_int]));
C      togfl_int = 0;
C      for(j_int=0; j_int <= lleng_int - n_int + 1; j_int++)
C      {
C       if (line_S[j_int] == 34) togfl_int = 1 - togfl_int;
C       if (togfl_int == 1) goto Lab_658;
C       if (memcmp(b_S,&line_S[j_int],n_int) == 0)
C       {
C        c=0; if(j_int > 0) c=line_S[j_int-1];
C        log_1=!(c>='a' && c<='z' || c>='A' && c<='Z' || c=='_');
C        c=line_S[j_int+n_int];
C        log_2=!(c>='a' && c<='z' || c>='A' && c<='Z' || c=='_');
C        if(log_1 && log_2)
C        {
C         if(i_int<=jrplc_int)
C         {
C           if(i_int==0) strcpy(e_S,"Nint");
C           if(i_int==1) strcpy(e_S,"Int");
C           if(i_int==2) strcpy(e_S,"fabs");
C           if(i_int==3) strcpy(e_S,"atan");
C           if(i_int==4) strcpy(e_S,"sqrt");
C           if(i_int==5) strcpy(e_S,"log");
C           if(i_int==6) strcpy(e_S,"sin");
C           if(i_int==7) strcpy(e_S,"cos");
C           if(i_int==8) strcpy(e_S,"tan");
C           if(i_int==9) strcpy(e_S,"exp");
C          if(c!='(') {
C           if(i_int==10) strcpy(e_S,"DATE$(0)");
C           if(i_int==11) strcpy(e_S,"TIME$(0)");
C           if(i_int==12) strcpy(e_S,"TIMER()");
C           if(i_int==13) strcpy(e_S,"RND(1)");
C           if(i_int==14) strcpy(e_S,"INKEY$()");
C          }
C          if(c=='(' && (i_int==10 || i_int==11 || i_int==13)) strcpy(e_S, b_S);
C          strcpy(d_S,line_S);
C          line_S[j_int]='\0'; strcat(line_S,e_S);
C          strcat(line_S,&d_S[j_int+n_int]);
C          j_int=j_int+strlen(e_S)-1;
C          lleng_int=strlen(line_S);
C         }
C   switch(i_int) {      
C         case  0: nintff_int =1; mathfl_int =1; extrnfl_int=1;
C                  break;
C         case  1: intff_int  =1; mathfl_int =1; extrnfl_int=1;
C                  break;
C         case  2: mathfl_int =1; 
C                  break;
C         case  3: mathfl_int =1; 
C                  break;
C         case  4: mathfl_int =1; 
C                  break;
C         case  5: mathfl_int =1; 
C                  break;
C         case  6: mathfl_int =1; 
C                  break;
C         case  7: mathfl_int =1; 
C                  break;
C         case  8: mathfl_int =1; 
C                  break;
C         case  9: mathfl_int =1; 
C                  break;
C         case 10: dateff_int=1; extrnfl_int=1; timefl_int=1; chartfl_int=1;
C                  break;
C         case 11: timeff_int=1; extrnfl_int=1; timefl_int=1; chartfl_int=1;
C                  break;
C         case 12: timerff_int=1; extrnfl_int=1; timefl_int=1;
C                  break;
C         case 13: rndff_int=1; extrnfl_int=1;
C                  break;
C         case 14: inkeyff_int=1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 15: spacff_int =1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 16: rightff_int=1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 17: leftff_int =1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 18: midff_int  =1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 19: strff_int  =1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 20: chrff_int  =1; extrnfl_int=1; chartfl_int=1;
C                  break;
C         case 21: ascff_int  =1; extrnfl_int=1; longtfl_int =1;
C                  break;
C         case 22: valff_int  =1; extrnfl_int=1; vdblff_int =1;
C                  break;
C         case 23: minff_int  =1; 
C                  break;
C         case 24: maxff_int  =1; 
C                  break;
C         case 25: lenff_int  =1; extrnfl_int=1; vdblff_int =1;
C                  break;
C         case 26: sgnff_int  =1; extrnfl_int=1; vdblff_int =1;
C                  break;
C         case 27: eofff_int  =1; extrnfl_int=1;
C                  break;
C         case 28: existff_int  =1; extrnfl_int=1;
C                  break;
C         case 29: srndff_int =1; extrnfl_int=1;
C                  break;
C         case 30: twsflg_int=1;
C                  break;
C         case 31: commff_int=1; extrnfl_int=1; chartfl_int=1;
C                  break;
C                 }
C        }
657
C       c=0;
C       }
658
C      c=0;
C      }
C     }
C     /* printf("%s\n",line_S); */
C     fprintf(fp_2,"%s\n",line_S);
659  LOOP
     CLOSE #1
     CLOSE #2
     RETURN


700  REM preprocessing the whole file for variables in MAIN & SUB's
     REM for a SUB do not save variables found in respective SHARED
     REM 'Variables' can also be multidimensional arrays
     REM Lists of variables of all SUBs: subvar$(isub%, i%), nsubvar%(isub%)
     nsub% = 0: nvar% = 0: shtmp$ = "": nl% = 0: retrnfl% = 0: e$ = CHR$(34)
     xtmpfl% = 0: fime$ = ""
     OPEN inpf$ FOR INPUT AS #1
     DO WHILE NOT EOF(1)
      LINE INPUT #1, line$: nl% = nl% + 1
      CALL gulix(line$)
C     if (memcmp(line_S, "FUNCTION ", 9) == 0) xtmpfl_int = 1;
      DO WHILE NOT (LEFT$(line$, 4) = "SUB " OR xtmpfl% = 1)
       IF line$ <> "" THEN
C       if (line_S[0] == 'C' && cflag_int) 
C       {
C       if (memcmp(line_S,"C ",2)==0 || memcmp(line_S,"CG ",3)==0 || memcmp(line_S,"CH ",3)==0 || memcmp(line_S,"CM ",3)==0) goto Lab_709;
C       }
C       if (memcmp(line_S,"REM ",4)==0) goto Lab_709;
        GOSUB 900: REM line splitting
        FOR ii% = 1 TO ntok%
         line$ = linetok$(ii%)
         CALL gulix(line$)
C        if (memcmp(line_S, "RETURN", 6) == 0) retrnfl_int = 1;
         REM check for "FOR":
C        if (memcmp(line_S, "FOR", 3) == 0) 
C        {   
          line$ = MID$(line$, 4)
          CALL gulix(line$)
          GOTO 704
C        }   
         REM check for "GIFINFO ":
C        if (memcmp(line_S, "GIFINFO ", 8) == 0)
C        {   
C         /* Find the second argument */
C         k_int=8; while(line_S[k_int] != ',' && line_S[k_int] !='\0') k_int++;
C         strcpy(tws__S, &line_S[++k_int]); strcpy(line_S, tws__S);
          GOSUB 735: REM Tokenize line and save variables
          GOTO 706
C        }
         REM check for "GCGET ":
C        if (memcmp(line_S, "GCGET ", 6) == 0)
C        {
          CALL tokenix(MID$(line$, 7), k%, ",", "")
C         strcpy(line_S, &tmp_S[1][1]); line_S[(c=strlen(line_S))]='\0';
C         line_S[c-1]=','; strcat(line_S, tmp_S[2]);
          GOSUB 735: REM Tokenize line and save variables
          GOTO 706
C        }
         REM check for "XPOINTER " or "XGETGE ":
C        if (memcmp(line_S,"XPOINTER ",9)==0 || memcmp(line_S,"XGETGE ",7)==0)
C        {
C         i_int = 10; if (line_S[1] == 'G') i_int = 8;
          line$ = MID$(line$, i%): lleng% = LEN(line$): i% = 0
C         while(line_S[i_int] != '(' && i_int < lleng_int) i_int++;
C         line_S[i_int] = ' '; c = 1;
C         while(i_int < lleng_int) {
C          if (line_S[i_int] == '(') c++; if (line_S[i_int] == ')') c--;
C          if (c == 0) break;
C          i_int++;
C         }
C         line_S[i_int] = ' ';
C         /* Make sure there is no more than 4 parameters in the list: */
C         i_int = 0; k_int = 0;
C         while ((c=line_S[i_int]) != 0) {
C          if (c == ',') k_int++; 
C          if (k_int >= 4) { line_S[i_int] = '\0'; i_int--; }
C          i_int++;
C         }
          GOSUB 735: REM Tokenize line and save variables
          GOTO 706
C        }
         REM check for "XREQST ":
C        if (memcmp(line_S, "XREQST ", 7) == 0)
C        {
          CALL tokenix(MID$(line$, 7), k%, ",", "")
C         strcpy(line_S, tmp_S[2]); strcat(line_S, ", ");
C         strcat(line_S, tmp_S[3]);
          GOSUB 735: REM Tokenize line and save variables
          GOTO 706
C        }
         jflg% = 0: GOSUB 730: REM check 'LINE INPUT #','INPUT #' and 'INPUT'
         IF jflg% = 1 THEN GOTO 706
         jflg% = 0: GOSUB 750: REM variables among SUB arguments, check 'CALLs'
         IF jflg% = 1 THEN GOTO 706
704      jflg% = 0
         lleng% = LEN(line$)
         FOR k% = 1 TO lleng%
C         if (line_S[k_int-1] == '=') { jflg_int = 1; goto Lab_705; }
         NEXT k%
705      IF jflg% = 1 THEN
          FOR j% = 0 TO k% - 3
C          if (line_S[j_int] == ' ') { jflg_int = 0; goto Lab_708; }
          NEXT j%
         END IF
708      IF jflg% = 1 THEN
          z$ = LEFT$(line$, k% - 2)
C         if (z_S[strlen(z_S)-1] == ')')
C         {
           j% = 0
C          while (z_S[j_int] != '(') j_int++;
C          j_int++;
C          z_S[j_int  ] = ')';
C          z_S[j_int+1] = '\0';
C         }
          GOSUB 790: REM Memorizing z$
         END IF
706     NEXT ii%
       END IF
       IF EOF(1) THEN GOTO 707
       LINE INPUT #1, line$: nl% = nl% + 1
       CALL gulix(line$)
       IF LEFT$(line$, 9) = "FUNCTION " THEN xtmpfl% = 1
      LOOP
707   IF xtmpfl% = 1 THEN xtmpfl% = 0: GOSUB 715: REM Get FUNCTION name
      nvlist%(nsub%) = nvar%
      REM Sorting variables
      int$ = "": rea$ = "": sss$ = "": lon$ = "": dbl$ = "": byt$ = ""
      IF nvar% > 0 THEN
       GOSUB 710
       IF int$ <> "" THEN int$ = LEFT$(int$, LEN(int$) - 2)
       IF rea$ <> "" THEN rea$ = LEFT$(rea$, LEN(rea$) - 2)
       IF sss$ <> "" THEN sss$ = LEFT$(sss$, LEN(sss$) - 2)
       IF lon$ <> "" THEN lon$ = LEFT$(lon$, LEN(lon$) - 2)
       IF dbl$ <> "" THEN dbl$ = LEFT$(dbl$, LEN(dbl$) - 2)
       IF byt$ <> "" THEN byt$ = LEFT$(byt$, LEN(byt$) - 2)
      END IF
      vari$(nsub%) = int$
      varr$(nsub%) = rea$
      vars$(nsub%) = sss$
      varl$(nsub%) = lon$
      vard$(nsub%) = dbl$
      varb$(nsub%) = byt$
      IF NOT EOF(1) THEN
       nvar% = 0: nsub% = nsub% + 1: shtmp$ = ""
       REM Extraction of varlist at the beginning nsub%-th SUB
       GOSUB 780
      END IF
709  LOOP
     CLOSE #1
     nsubvar%(nsub% + 1) = 0: REM Ensure this is 0 (important in 45000)
     IF ifsub% = 0 THEN endline% = nl%
     RETURN

710  REM sorting variable types
      FOR i% = 1 TO nvar%
       d$ = vlist$(nsub%, i%): CALL vartyp(d$, typ%)
       IF typ% = 0 THEN
        PRINT "ERROR can't determine vartyp of: "; d$; " in line No"; nl%
C       exit(1);
       END IF
       IF typ% < 10 THEN
        IF typ% = 1 THEN
         int$ = int$ + d$ + ", "
        ELSE
         IF typ% = 5 THEN
          sss$ = sss$ + d$ + "[LMAX], "
         ELSE
          IF typ% = 2 THEN
           lon$ = lon$ + d$ + ", "
          ELSE
           IF typ% = 4 THEN
            dbl$ = dbl$ + d$ + ", "
           ELSE
            IF typ% = 3 THEN
             rea$ = rea$ + d$ + ", "
            ELSE
             IF typ% = 8 THEN
              byt$ = byt$ + d$ + ", "
             END IF
            END IF
           END IF
          END IF
         END IF
        END IF
       ELSE
       END IF
      NEXT i%
      RETURN

715  REM Getting FUNCTION name, "" if not a FUNCTION
     REM This name is then forbidden in variable list
     fime$ = "": g% = 10
     DO WHILE MID$(line$, g%, 1) <> "("
      g% = g% + 1
     LOOP
     fime$ = MID$(line$, 10, g% - 10)
     CALL gulix(fime$)
     RETURN

720  REM Unused 
     RETURN

730  REM  Checking variable declarations in "LINE INPUT #n," statements
     CALL gulix(line$): leng% = LEN(line$)
     IF LEFT$(line$, 12) = "LINE INPUT #" OR LEFT$(line$, 7) = "INPUT #" THEN
      g% = 8: jflg% = 1
      DO WHILE MID$(line$, g%, 1) <> "," AND g% < leng%
       g% = g% + 1
      LOOP
      IF g% = leng% THEN
       PRINT "SYNTAX ERROR in line No"; nl%; ":"; line$
C      exit(1);
      ELSE
       line$ = MID$(line$, g% + 1, leng% - g%)
       GOSUB 735
       RETURN
      END IF
     ELSE
      REM  Checking variable declarations in "INPUT" statements
      IF LEFT$(line$, 5) = "INPUT" THEN
       jflg% = 1
       IF leng% = 5 THEN
        PRINT "SYNTAX ERROR in line No"; nl%; ":"; line$
C       exit(1);
       ELSE
        line$ = MID$(line$, 6, leng% - 5)
        GOSUB 735
        RETURN
       END IF
      END IF
     END IF
     RETURN

735  REM Tokenizator varijabli u INPUT, GIFINFO ... linijama
     CALL tokenix(line$, L%, ",", ";")
     FOR g% = 1 TO L%
      z$ = tmp$(g%): GOSUB 790: REM Memorizing variable z$
     NEXT g%
     RETURN

750  REM Potraga za varijablama argumentima user SUBroutina i FUNCTIONa
     REM WHOLE arrays cannot be passed at the moment !!!!
     REM Array names (when possible) passed as bare names (no brackets).
     REM Element of an array can be passed as a single number or string,
     REM however, they are not stored here (for simplicity).
     IF LEFT$(line$, 4) = "CALL" THEN
      g% = 5: leng% = LEN(line$)
      DO WHILE NOT MID$(line$, g%, 1) = "(" AND g% < leng%
       g% = g% + 1
      LOOP
      IF g% = leng% THEN RETURN
      j% = leng%
      DO WHILE NOT MID$(line$, j%, 1) = ")" AND j% > g%
       j% = j% - 1
      LOOP
       IF MID$(line$, j%, 1) <> ")" THEN
       PRINT "SYNTAX ERROR in line No"; nl%; ":" + line$
C      exit(1);
      END IF
      d$ = MID$(line$, g% + 1, j% - g% - 1): CALL gulix(d$)
      REM tokenization of the CALLed SUBroutine argument list
      CALL tokenix(d$, L%, ",", "")
      FOR g% = 1 TO L%
        z$ = tmp$(g%)
        REM Check whether z$ is a var (rather than funct. or express.)
        GOSUB 755
        IF tmpfl% = 0 THEN
         IF VAL(z$) = 0 AND LEFT$(z$, 1) <> "0" THEN GOSUB 790: REM Memorizing variable z$
        END IF
      NEXT g%
     END IF
     RETURN
755  tmpfl% = 0: REM Check whether z$ is a var (not array, funct. or expr.)
     IF LEFT$(z$, 1) = e$ THEN tmpfl% = 1: GOTO 756
     FOR j% = 1 TO LEN(z$)
     b$ = MID$(z$, j%, 1)
      IF b$ = " " OR b$ = "(" THEN tmpfl% = 1: GOTO 756
     NEXT j%
756  RETURN

780  REM Storing argumentlist of the SUB or FUNCTION
     REM and storing of the SUB name
     a$ = line$: j% = 0: k% = 0: leng% = LEN(a$): brcnt% = 0
     FOR i% = 4 TO leng%
C     c=a_S[i_int-1];
C     if (c=='(') { if (brcnt_int++ == 0)   j_int = i_int + 1; }
C     if (c==')') { if (--brcnt_int == 0) { k_int = i_int - 1; goto Lab_781; }}
     NEXT i%
781   
C    if(memcmp(a_S,"SUB ",4) == 0) {strcpy(b_S, &a_S[4]), b_S[j_int-6]='\0';}
C    if(memcmp(a_S,"FUNC",4) == 0) {strcpy(b_S, &a_S[9]), b_S[j_int-11]='\0';}
     CALL gulix(b$): subname$(nsub%) = b$
     IF j% = 0 THEN nsubvar%(nsub%) = 0: RETURN
     varlist$ = MID$(a$, j%, k% - j% + 1)
     CALL gulix(varlist$): CALL tokenix(varlist$, n%, ",", ""): REM varlist -> tmp$(), n%
     nsubvar%(nsub%) = n%
     IF n% > 0 THEN
      FOR g% = 1 TO n%
       subvar$(nsub%, g%) = tmp$(g%)
      NEXT g%
     END IF
     RETURN

790  REM Spremanje jedne varijable z$, za deklaraciju ako je NOVA
     REM i ako nije u SHARED i ako nije parametar doticne SUBroutine
     REM i ako nije char konstanta "..." ili brojna konstanta eg. 3
         IF z$ = fime$ THEN RETURN
         j% = ASC(LEFT$(z$, 1))
         IF (97 <= j% AND j% <= 122 OR 65 <= j% AND j% <= 90 OR 48 <= j% AND j% <= 57) THEN
REM       IF LEFT$(z$, 1) = e$ THEN RETURN
C         if (z_S[0] == '"') /* RETURN */ longjmp(j__buf[--j__lev],1);
          GOSUB 795
          IF nvar% = 0 AND nshtok%(nsub%) = 0 AND nsubvar%(nsub%) = 0 THEN
           nvar% = 1
           vlist$(nsub%, 1) = z$
          ELSE
           FOR j% = 1 TO nvar%
            IF vlist$(nsub%, j%) = z$ THEN RETURN
           NEXT j%
           IF nsub% = 0 THEN
            FOR j% = 1 TO nSHRDtk%
             IF shrd$(j%) = z$ THEN RETURN
            NEXT j%
           ELSE
            FOR j% = 1 TO nshtok%(nsub%)
             IF shtok$(nsub%, j%) = z$ THEN RETURN
            NEXT j%
            FOR j% = 1 TO nsubvar%(nsub%)
             IF subvar$(nsub%, j%) = z$ THEN RETURN
            NEXT j%
           END IF
           nvar% = nvar% + 1
           vlist$(nsub%, nvar%) = z$
          END IF
         END IF
     RETURN

795  REM x(...)  -->  x()
C    if (z_S[strlen(z_S)-1] == ')')
C    {
C     jj_int=0; while( z_S[jj_int] != '(' ) jj_int++;
C     z_S[++jj_int] = ')'; z_S[++jj_int] = '\0'; 
C    }
     RETURN

                       
800  REM preprocessing the whole file for SHARED variables and arrays and
     REM storing all SHARED token lists for every SUB in shtok$(jsub%,i%)
     nSHRDtk% = 0: jsub% = 0: ifsub% = 0: endline% = 0: narr% = 0: alis% = 0
     nl% = 0: g% = 0
     OPEN inpf$ FOR INPUT AS #1
     DO WHILE NOT EOF(1)
      LINE INPUT #1, line$: nl% = nl% + 1
      CALL gulix(line$)
      lleng% = LEN(line$)
      IF lleng% = 0 THEN GOTO 809
      IF LEFT$(line$, 4) = "SUB " OR LEFT$(line$, 9) = "FUNCTION " THEN
       jsub% = jsub% + 1: g% = 0
       IF ifsub% = 0 THEN ifsub% = 1: endline% = nl% - 1
      END IF
      IF jsub% > NSMX THEN
       PRINT "Max. number of SUBroutines and FUNCTIONs reached !"
       PRINT "Enlarge the NSMX parameter in QB2C, and recompile it !"
C      exit(-1);
      END IF
      REM List of dimensioned arrays in MAIN:
      REM (Those which are shared shall be declared in the preamble.)
      IF jsub% = 0 AND LEFT$(line$, 4) = "DIM " THEN
       i% = 8
       DO WHILE MID$(line$, i%, 1) <> ":" AND i% <= lleng%
        i% = i% + 1
       LOOP
       b$ = MID$(line$, 4, i% - 4): CALL gulix(b$)
       CALL tokenix(b$, ntok%, ",", "")
       FOR i% = 1 TO ntok%
        temp$(i%) = tmp$(i%)
       NEXT
       IF ntok% > 0 THEN
        FOR i% = 1 TO ntok%
         d$ = temp$(i%)
         CALL arraydim(d$)
         narr% = narr% + 1: darr$(narr%) = d$
        NEXT i%
       END IF
      END IF
      IF MID$(line$, 1, 6) = "SHARED" THEN
        d$ = MID$(line$, 8, lleng% - 7)
        GOSUB 805
      END IF
809  LOOP
     CLOSE #1
     REM Sorting variables
     IF nSHRDtk% > 0 THEN
      sint$ = "": srea$ = "": ssss$ = "": slin$ = "": sdbl$ = ""
      FOR i% = 1 TO nSHRDtk%
      d$ = shrd$(i%)
      z$ = RIGHT$(d$, 1)
      IF z$ <> ")" THEN
       CALL vartyp(d$, typ%)
       IF typ% = 1 THEN
        sint$ = sint$ + d$ + ", "
       ELSE
        IF typ% = 5 THEN
         ssss$ = ssss$ + d$ + "[LMAX], "
        ELSE
         IF typ% = 2 THEN
          slin$ = slin$ + d$ + ", "
         ELSE
          IF typ% = 4 THEN
           sdbl$ = sdbl$ + d$ + ", "
          ELSE
           srea$ = srea$ + d$ + ", "
          END IF
         END IF
        END IF
       END IF
      ELSE
       FOR j% = 1 TO narr%
        g% = LEN(d$) - 1
        IF LEFT$(d$, g%) = LEFT$(darr$(j%), g%) THEN
         alis% = alis% + 1
         alist%(alis%) = j%
        END IF
       NEXT j%
      END IF
     NEXT i%
      REM Bare variables:
      IF sint$ <> "" THEN sint$ = LEFT$(sint$, LEN(sint$) - 2)
      IF srea$ <> "" THEN srea$ = LEFT$(srea$, LEN(srea$) - 2)
      IF ssss$ <> "" THEN ssss$ = LEFT$(ssss$, LEN(ssss$) - 2)
      IF slin$ <> "" THEN slin$ = LEFT$(slin$, LEN(slin$) - 2)
      IF sdbl$ <> "" THEN sdbl$ = LEFT$(sdbl$, LEN(sdbl$) - 2)
     END IF
     IF nSHRDtk% > TMAX THEN
      PRINT "qb2c: MAIN (800): Dimension of tmp$() too small. Enlarge TMAX and recompile qb2c!"
C     exit(1);
     END IF
     FOR i% = 1 TO nSHRDtk%
      shtok$(0, i%) = shrd$(i%)
     NEXT
     nshtok%(0) = nSHRDtk%
     RETURN

805   REM tokenization of SHARED variables
      leng% = LEN(d$)
      i% = 1: REM g% = 0, this is set at the beginning of a SUB
      DO WHILE i% <= leng%
       IF MID$(d$, i%, 1) <> "," AND MID$(d$, i%, 1) <> " " THEN
        j% = i%
        i% = i% + 1
        DO WHILE NOT (MID$(d$, i%, 1) = "," OR MID$(d$, i%, 1) = "  " OR i% > leng%)
         i% = i% + 1
        LOOP
        z$ = MID$(d$, j%, i% - j%)
        g% = g% + 1
        IF g% > TMAX THEN
         PRINT "qb2c: MAIN (805): Dimension of tmp$() too small. Enlarge TMAX and recompile qb2c!"
C        exit(1);
        END IF
        shtok$(jsub%, g%) = z$
        IF nSHRDtk% = 0 THEN
         nSHRDtk% = 1
         shrd$(1) = z$
        ELSE
         tmpfl% = 0
         FOR L% = 1 TO nSHRDtk%
          IF shrd$(L%) = z$ THEN tmpfl% = 1
         NEXT L%
         IF tmpfl% = 0 THEN
          nSHRDtk% = nSHRDtk% + 1
          shrd$(nSHRDtk%) = z$
         END IF
        END IF
       END IF
       i% = i% + 1
      LOOP
      nshtok%(jsub%) = g%
      RETURN


900  REM spliting one physical line line$ into ':' pieces, line spliter
     REM Split IF lines if something after THEN and add END IF
     REM Force spliting if line labeled
     REM Returns (bare, gulix!) linetok$(), ntok%
     CALL gulix(line$): lleng% = LEN(line$)
     IF lleng% = 0 THEN ntok% = 0: RETURN
     ntok% = 0: tok%(0) = 0: lremfl% = 0: thnfl% = 0: t$ = ""
C    if (strncmp(line_S,"REM",3)==0)
C    {
      ntok% = 1: linetok$(1) = line$: RETURN
C    }
     i% = 1: togfl% = 0
     g& = VAL(line$)
     IF g& <> 0 THEN
      b$ = STR$(g&)
      line$ = b$ + ": " + MID$(line$, LEN(b$))
      lleng% = LEN(line$)
     END IF
     DO WHILE i% <= lleng% - 3
C     c = line_S[i_int-1];
C     if (c == 34) togfl_int = 1 - togfl_int;
C     if (c == ':' && togfl_int == 0) 
C     {
       ntok% = ntok% + 1: tok%(ntok%) = i%
C     }
      d$ = MID$(line$, i%, 4)
      IF d$ = "THEN" AND togfl% = 0 THEN
       f$ = MID$(line$, i% + 4): CALL gulix(f$)
       IF f$ = "" THEN GOTO 902
       IF VAL(f$) = 0 THEN
        line$ = LEFT$(line$, i% + 3) + ": " + MID$(line$, i% + 4)
        lleng% = lleng% + 2
       ELSE
        line$ = LEFT$(line$, i% + 3) + ": GOTO" + MID$(line$, i% + 4)
        lleng% = lleng% + 6
       END IF
C      thnfl_int++;
       i% = i% + 3
      END IF
      IF d$ = "REM " AND togfl% = 0 THEN lremfl% = 1: GOTO 902
      i% = i% + 1
     LOOP
901  REM split the line in tokens separated by ":"
902  ntok% = ntok% + 1
903  tok%(ntok%) = lleng% + 1
     IF lremfl% = 1 THEN
      ntok% = ntok% - 1
      t$ = MID$(line$, tok%(ntok%) + 1): CALL gulix(t$)
      t$ = MID$(t$, 5)
     END IF
     tmpfl% = 0
     FOR i% = 1 TO ntok%
      b$ = MID$(line$, tok%(i% - 1) + 1, tok%(i%) - tok%(i% - 1) - 1)
      CALL gulix(b$)
      linetok$(i% + tmpfl%) = b$
C     if (strncmp(b_S,"IF ",3)==0)
C     {      
C      j_int = 0; g_int = strlen(b_S); tmpfl_int = 0;
C      while (!(tmpfl_int==0 && (memcmp(&b_S[j_int],"GOTO",4) == 0 || memcmp(&b_S[j_int],"GOSUB",5) == 0)) && j_int < g_int)
C      { if (b_S[j_int] == '"') tmpfl_int = 1 - tmpfl_int; j_int++; }
C      if (j_int != g_int)
C      {
C       if(memcmp(&b_S[j_int],"GOTO",4) == 0) { strcpy(d_S, &b_S[j_int]); b_S[j_int] = '\0'; }
C       else 
C       {
C       if(memcmp(&b_S[j_int],"GOSUB",5) == 0) { strcpy(d_S, &b_S[j_int]); b_S[j_int] = '\0'; }
C       }
        linetok$(i% + tmpfl%) = b$ + " THEN"
C       tmpfl_int++; thnfl_int = 1;
        linetok$(i% + tmpfl%) = d$
C      }
C     }      
     NEXT i%
     ntok% = ntok% + tmpfl%
     FOR i% = 1 TO thnfl%
      ntok% = ntok% + 1
      linetok$(ntok%) = "END IF"
     NEXT i%
REM     PRINT line$
REM     FOR i% = 1 TO ntok%
REM      PRINT linetok$(i%)
REM     NEXT i%
REM     PRINT t$
     RETURN


1000 REM "SUB name(varlist...)", "FUNCTION name(varlist...)"
     IF commfl% = 1 THEN RETURN
     IF LEFT$(a$, 4) = "SUB " THEN xtmpfl% = 0: GOTO 1001
     IF LEFT$(a$, 9) = "FUNCTION " THEN
      xtmpfl% = 1: funcflag% = 1: nfuncs% = nfuncs% + 1: GOTO 1001
     END IF
     RETURN
1001 isub% = isub% + 1: jopn% = 0
     lspac% = 1: spc$ = SPACE$(lspac%)
     statfl%(isub%) = 0: funcfl%(isub%) = xtmpfl%
     GOSUB 31000: REM Make a list of possibly used arrays in the current sub
     leng% = LEN(a$)
     FOR i% = 4 TO leng%
      IF RIGHT$(a$, 7) = " STATIC" THEN
       a$ = LEFT$(a$, leng% - 7): CALL gulix(a$): leng% = LEN(a$)
       statfl%(isub%) = 1: REM Static variables flag
      END IF
     NEXT i%
     FOR i% = 4 TO leng%
      b$ = MID$(a$, i%, 1)
      IF b$ = "(" THEN j% = i% + 1
      IF b$ = ")" THEN k% = i% - 1
     NEXT i%
     IF nsubvar%(isub%) = 0 THEN
      prtf$ = MID$(a$, 4, leng% - 3): CALL gulix(prtf$)
      prtf$ = "int " + prtf$ + "(, "
      varlist$ = ""
     ELSE
      IF funcfl%(isub%) = 0 THEN
       prtf$ = MID$(a$, 4, j% - 5): CALL gulix(prtf$)
      ELSE
       prtf$ = MID$(a$, 9, j% - 10): CALL gulix(prtf$)
       funames$(nfuncs%) = prtf$
       funcnam$ = prtf$
      END IF
      IF xtmpfl% = 0 THEN 
       prtf$ = "int " + prtf$ + "("
      ELSE
       CALL vartyp(prtf$, typ%)
       z$ = "": IF typ% = 5 THEN z$ = "*"
       prtf$ = "extern " + atyp$(typ%) + z$ + prtf$ + "("
      END IF
      varlist$ = MID$(a$, j%, k% - j% + 1)
     END IF
     CALL tokenix(varlist$, n%, ",", "")
     c$ = "": b$ = "": IF funcfl%(isub%) = 0 THEN b$ = "*"
     FOR i% = 1 TO n%
      d$ = tmp$(i%): GOSUB 1010: REM type determination
      prtf$ = prtf$ + e$ + b$ + tmp$(i%) + ", "
      CALL gulix(e$)
      c$ = c$ + e$ + ", "
     NEXT i%
     prtf$ = LEFT$(prtf$, LEN(prtf$) - 2)
     IF xtmpfl% = 1 THEN
      IF c$ <> "" THEN c$ = LEFT$(c$, LEN(c$) - 2)
      funtyl$(nfuncs%) = c$
     END IF
     PRINT #2,
     PRINT #2, "/*- User SUB--Start -*/": REM Do not change, used in post. 45000
     PRINT #2, prtf$ + ")" + t$
     PRINT #2, "{"
     commfl% = 1: usersub% = 1
     IF nshtok%(isub%) > 0 THEN
     REM comment on shared variables
      b$ = ""
      FOR j% = 1 TO nshtok%(isub%)
       b$ = b$ + shtok$(isub%, j%) + ", "
      NEXT j%
      b$ = LEFT$(b$, LEN(b$) - 2)
      CALL splitdec(b$, n%, 3)
      FOR j% = 1 TO n%
       PRINT #2, "/* SHARED: " + tmp$(j%) + " */"
      NEXT j%
      PRINT #2,
     END IF
     REM lista varijabli:
     tmpfl% = 0: int$ = " int  ": float$ = " float "
     IF longflg% = 1 THEN int$ = " long "
     IF doblflg% = 1 THEN float$ = " double "
     IF vari$(isub%) <> "" THEN CALL declarix(int$, vari$(isub%), 3): tmpfl% = 1
     IF varr$(isub%) <> "" THEN CALL declarix(float$, varr$(isub%), 0): tmpfl% = 1
     IF vars$(isub%) <> "" THEN CALL declarix(" char ", vars$(isub%), 1): tmpfl% = 1
     IF varl$(isub%) <> "" THEN CALL declarix(" long ", varl$(isub%), 4): tmpfl% = 1
     IF vard$(isub%) <> "" THEN CALL declarix(" double ", vard$(isub%), 0): tmpfl% = 1
     IF varb$(isub%) <> "" THEN CALL declarix(" unsigned char ", varb$(isub%), 0): tmpfl% = 1
     IF tmpfl% = 1 THEN PRINT #2,
     RETURN

1010 REM sorting variable types (default)
     CALL vartyp(d$, typ%)
     IF (typ% = 0 OR typ% > 5) AND typ% <> 8 THEN
      PRINT "Error at label 1010 of QB2C: vartyp of "; d$; " is"; typ%; "..."
      PRINT "...in line No"; nl%; ": "; a$
      END
     ELSE
      e$ = atyp$(typ%)
     END IF
     RETURN


1250 REM "SHARED" - this is already taken care of, just skip
       commfl% = 1
     RETURN


1500 REM "END" (main)
     REM END    -> exit(0);  done here
     IF nl% = endline% + 1 THEN
1501  PRINT #2, "} /* End of MAIN */"
      endmain% = 1
      lspac% = lspac% - 1: spc$ = SPACE$(lspac%)
      IF lspac% < 0 THEN PRINT "WARNING! Braces count = "; lspac%; " at line: "; nl%; ":"; line$
      IF lspac% <> 0 THEN
C      fprintf(stderr,"ERROR: Misscount at the 'End of MAIN' brace: %d\n", lspac_int); exit(1);
      END IF
      RETURN
     END IF
     IF commfl% = 1 THEN RETURN
     IF a$ = "END" THEN
      PRINT #2, spc$ + "exit(0);" + t$
      commfl% = 1
      RETURN
     END IF
     RETURN


2000 REM "REM"
     IF commfl% = 1 THEN RETURN
     IF LEFT$(a$, 3) = "REM" THEN
      IF LEN(a$) = 3 THEN 2001
      prtf$ = "/*" + MID$(a$, 4) + " */"
      PRINT #2, spc$ + prtf$
      IF isub% = 0 THEN ni% = ni% + 1
2001  commfl% = 1
     END IF
     RETURN
  

2500 REM "DECLARE"
       commfl% = 1
       IF isub% = 0 THEN initline% = ni%
     RETURN
            

2600 REM "CONST", this has been taken care of in pp 650
       ncnst% = ncnst% + 1
       b$ = MID$(a$, 6): CALL tokenix(b$, n%, "=", "")
       IF n% <> 2 THEN
        PRINT "Preprocessor 650 ERROR in line No"; nl%; ":"; line$
        PRINT "Please define one constant per line."
C       exit(1);
       END IF
       IF ncnst% > NCMX THEN
        PRINT "Maximum number of CONStant declarations reached."
        PRINT "Enlarge parameter NCMX in qb2c, compile it and restart !"
        END
       END IF
       cnst$(ncnst%) = "#define " + tmp$(1) + " " + tmp$(2) + t$
       tcnst$(ncnst%) = tmp$(1)
       commfl% = 1
       IF isub% = 0 THEN initline% = ni%
     RETURN


2750 REM "DIM "
       commfl% = 1
       b$ = MID$(a$, 4): CALL gulix(b$): CALL tokenix(b$, n%, ",", "")
       IF n% = 0 THEN RETURN
       FOR i% = 1 TO n%
        temp$(i%) = tmp$(i%)
       NEXT
       FOR i% = 1 TO n%
        d$ = temp$(i%): CALL arraydim(d$)
        IF isub% = 0 THEN
         FOR j% = 1 TO alis%
          IF d$ = darr$(alist%(j%)) THEN GOTO 2755
         NEXT j%
        ELSE
         REM Tu nesto fali ?????
        END IF
        CALL vartyp(d$, typ%)
        GOSUB 2760: REM Get rid of dimensions & memorize arr. to atmp$()
        CALL brackets(d$)
        prtf$ = " static " + atyp$(typ% - 10) + d$ + ";" + t$
        PRINT #2, prtf$
        IF isub% = 0 THEN ni% = ni% + 1
2755   NEXT i%
       IF isub% = 0 THEN initline% = ni%
     RETURN

2760 REM Get rid of dimensions & memorize arrayname to atmp$() if new
     REM don't change the d$
     REM This dynamically fills atmp$() for a current SUB or MAIN
      z$ = d$: jj% = 1
      DO WHILE MID$(z$, jj%, 1) <> "("
       jj% = jj% + 1
      LOOP
      z$ = LEFT$(z$, jj%)
      tmpfl% = 1
      FOR j% = 1 TO natmp%
       IF z$ = atmp$(j%) THEN tmpfl% = 0: GOTO 2761
      NEXT j%
2761  IF tmpfl% = 1 THEN
       natmp% = natmp% + 1: atmp$(natmp%) = z$
      END IF
      RETURN


3000 REM "IF ... THEN ... ELSE ...END IF"
      CALL stringx(a$): REM String constant preprocessor
      e$ = CHR$(34): togfl% = 0
      leng% = LEN(a$)
      i1% = 4: i2% = 0
      FOR j% = 5 TO leng% - 3
C      if(a_S[j_int-1] == 34) togfl_int = 1 - togfl_int;
C      if((memcmp(&a_S[j_int-1],"THEN",4)==0 || memcmp(&a_S[j_int-1],"GOTO",4)==0) && !togfl_int)
C      { i2_int=j_int-2; goto Lab_3005; }
      NEXT j%
      PRINT "qb2c: SYNTAX ERROR in line No"; nl%; ":"; a$
      PRINT "qb2c: Missing keyword: THEN or GOTO"
C     exit(1);
3005 IF i2% <> 0 THEN
      b$ = MID$(a$, i1%, i2% - i1% + 1)
      CALL gulix(b$)
      CALL mathexp(b$)
      CALL logix(b$)
      CALL quadrix(b$)
      prtf$ = "if(" + b$ + ")"
      PRINT #2, spc$ + prtf$ + t$
      PRINT #2, spc$ + "{"
      lspac% = lspac% + 1
      spc$ = SPACE$(lspac%) 
      commfl% = 1
     END IF
     RETURN


3250 REM "ELSE"
      PRINT #2, SPACE$(lspac% - 1) + "}"
      PRINT #2, SPACE$(lspac% - 1) + "else" + t$
      PRINT #2, SPACE$(lspac% - 1) + "{"
      commfl% = 1
     RETURN

3500 REM "END IF"
      PRINT #2, SPACE$(lspac% - 1) + "}"
      lspac% = lspac% - 1
      spc$ = SPACE$(lspac%) 
      IF lspac% < 0 THEN PRINT "WARNING! Braces count = "; lspac%; " at line: "; nl%; ":"; line$
      commfl% = 1
      RETURN
     RETURN


3750 REM "DO WHILE" or "WHILE"
      CALL stringx(a$): REM String constant pretprocessor
C     if( memcmp(a_S,"DO WHILE",8)==0 ) { strcpy(b_S,&a_S[8]); goto Lab_3751; }
C     if( memcmp(a_S,"WHILE",5)==0 )    { strcpy(b_S,&a_S[5]); goto Lab_3751; }
C     if( memcmp(a_S,"DO UNTIL",8)==0 ) 
C     { strcpy(b_S,"NOT ("); strcat(b_S,&a_S[9]); strcat(b_S,")"); }
3751  CALL gulix(b$)
      CALL mathexp(b$)
      CALL logix(b$)
      CALL quadrix(b$)
      prtf$ = "while(" + b$ + ")"
      PRINT #2, spc$ + prtf$ + t$
      PRINT #2, spc$ + "{"
      lspac% = lspac% + 1
      spc$ = SPACE$(lspac%) 
      commfl% = 1
     RETURN


3900 REM "LOOP" or "WEND"
      PRINT #2, SPACE$(lspac% - 1) + "}"
      lspac% = lspac% - 1
      spc$ = SPACE$(lspac%) 
      IF lspac% < 0 THEN PRINT "WARNING! Braces count = "; lspac%; " at line: "; nl%; ":"; line$
      commfl% = 1
     RETURN


4000 REM "PRINT #"
      CALL stringx(a$): REM String constant pretprocessor
      leng% = LEN(a$)
      commfl% = 1: i% = 1
      DO WHILE NOT MID$(a$, i%, 1) = "#" AND i% < leng%
       i% = i% + 1
      LOOP
      j% = i% + 1
      DO WHILE NOT MID$(a$, j%, 1) = "," AND j% <= leng%
       j% = j% + 1
      LOOP
      b$ = MID$(a$, i% + 1, j% - i% - 1): CALL gulix(b$)
      d$ = MID$(a$, j% + 1, leng% - j%): CALL gulix(d$)
      IF d$ = "" THEN
       prtf$ = "fprintf(fp_" + b$ + "," + CHR$(34) + "\n" + CHR$(34) + ");"
      ELSE
       CALL printfmt(d$, formt$, prt$, nflag%)
       CALL quadrix(prt$)
       IF nflag% = 1 THEN formt$ = formt$ + "\n"
       prtf$ = "fprintf(fp_" + b$ + "," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
      END IF
      PRINT #2, spc$ + prtf$ + t$
     RETURN



4500 REM "LINE INPUT #"
      leng% = LEN(a$)
      commfl% = 1: i% = 12
      prtf$ = "fgets("
      j% = i% + 1
      DO WHILE NOT MID$(a$, j%, 1) = "," AND j% <= leng%
       j% = j% + 1
      LOOP
      IF j% >= leng% THEN
       PRINT "ERROR in line No"; nl%; ":"; a$
C      exit(1);
      END IF
      b$ = MID$(a$, i% + 1, j% - i% - 1): CALL gulix(b$)
      d$ = MID$(a$, j% + 1, leng% - j%): CALL gulix(d$)
      CALL quadrix(d$)
      prtf$ = prtf$ + d$ + ", LMAX, fp_" + b$ + ");"
      PRINT #2, spc$ + prtf$ + t$
      PRINT #2, spc$ + d$ + "[strlen(" + d$ + ") - 1] = '\0';"
     RETURN


5000 REM "PRINT"
C     if( a_S[0] == 'E' ) {
       prtf$ = "fprintf(stderr,"
C     } else {
       prtf$ = "printf("
C     }
      IF a$ = "PRINT" OR a$ = "EPRINT" THEN formt$ = "\n": prt$ = "": GOTO 5001
      CALL stringx(a$): REM String constant pretprocessor
      a$ = MID$(a$, 7): CALL gulix(a$)
      CALL printfmt(a$, formt$, prt$, nflag%): REM tokenizacija list varijabli itd. => formt$
      CALL quadrix(prt$)
      IF nflag% = 1 THEN formt$ = formt$ + "\n"
5001  prtf$ = prtf$ + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
      PRINT #2, spc$ + prtf$ + t$
      commfl% = 1
     RETURN


5100 REM "LOCATE "
      d$ = MID$(a$, 8): CALL tokenix(d$, n%, ",", "")
      IF n% <> 2 THEN 
       PRINT "qb2c: SYNTAX ERROR in line No"; nl%; ":"; a$
       PRINT "qb2c: Must be two arguments to LOCATE!"
C      exit(1);
      END IF
      b$ = tmp$(1): d$ = tmp$(2)
      CALL mathexp(b$): CALL mathexp(d$): CALL quadrix(b$)
      prtf$ = "printf(" + CHR$(34) + "\033[%d;%d;f" + CHR$(34) + ",(int)(" + b$ + "),(int)(" + d$ + "));"
      PRINT #2, spc$ + prtf$ + t$
      commfl% = 1
     RETURN

5200 REM "COLOR"
      d$ = MID$(a$, 6): CALL gulix(d$)
      IF d$ = "" THEN
        PRINT #2, spc$ + "printf(" + CHR$(34) + "\033[0m" + CHR$(34) + ");" + t$
        GOTO 5201
      END IF
      CALL tokenix(d$, n%, ",", "")
      IF n% > 2 THEN 
       PRINT "qb2c: SYNTAX ERROR in line No"; nl%; ":"; a$
       PRINT "qb2c: Must be one or two arguments to COLOR!"
C      exit(1);
      END IF
      b$ = tmp$(1): CALL mathexp(b$): CALL quadrix(b$)
      IF n% = 1 THEN
       PRINT #2, spc$ + "COLOR((int)(" + b$ + "), -1);" + t$
      ELSE
       d$ = tmp$(2): CALL mathexp(d$): CALL quadrix(b$)
       PRINT #2, spc$ + "COLOR((int)(" + b$ + "), (int)(" + d$ + "));" + t$
      END IF
      colorff% = 1
      extrnfl% = 1
5201  commfl% = 1
     RETURN

5300 REM "CLS"
      b$ = MID$(a$, 4): CALL gulix(b$)
      IF b$ = "" THEN 
       prtf$ = "printf(" + CHR$(34) + "\033[2J\033[H" + CHR$(34) + ");"
      ELSE
       CALL mathexp(b$): CALL quadrix(b$)
       prtf$ = "CLS((int)(" + b$ + "));"
       clsff% = 1
       extrnfl% = 1
      END IF
      PRINT #2, spc$ + prtf$ + t$
      commfl% = 1
     RETURN

5500 REM "INPUT #"
      leng% = LEN(a$)
      commfl% = 1: i% = 8: e$ = CHR$(34)
      DO WHILE NOT MID$(a$, i%, 1) = "," AND i% < leng%
       i% = i% + 1
      LOOP
      IF i% >= leng% THEN
       PRINT "ERROR in line No"; nl%; ":"; a$
C      exit(1);
      END IF
      b$ = MID$(a$, 8, i% - 8): CALL gulix(b$): L% = VAL(b$)
      d$ = MID$(a$, i% + 1): CALL gulix(d$)
      IF t$ <> "" THEN PRINT #2, spc$ + t$
      CALL inputfmt(d$, formt$, prt$, n%, 0)
      CALL quadrix(prt$)
      GOSUB 5505: REM get filename
      IF n% = -1 THEN
      PRINT #2, spc$ + "while(fgets(" + d$ + ", LMAX, fp_" + b$ + ")==NULL)"
      PRINT #2, spc$ + "{ printf(" + e$ + "Error in reading (probably EOF) file: %s\n" + e$ + "," + f$ + "); exit(0);}"
      PRINT #2, spc$ + d$ + "[strlen(" + d$ + ") - 1] = '\0';"
      ELSE
      PRINT #2, spc$ + "if(fscanf(fp_" + b$ + "," + e$ + formt$ + " " + e$ + prt$ + ") !=" + STR$(n%) + ")"
      PRINT #2, spc$ + "{ printf(" + e$ + "Error in reading file: %s\n" + e$ + "," + f$ + "); }"
      END IF
      chartfl% = 1
     RETURN

5505  REM get filename
      i% = 1
      DO WHILE lfopen%(i%) <> L% AND i% <= nlopen%
       i% = i% + 1
      LOOP
      IF i% > nlopen% THEN
       f$ = e$ + e$
      ELSE
       f$ = lfopen$(i%)
      END IF
      RETURN



5750 REM "INPUT"
     IF t$ <> "" THEN PRINT #2, spc$ + t$
      leng% = LEN(a$): d$ = CHR$(34)
      IF leng% = 5 THEN
       PRINT #2, spc$ + "INPUT(" + d$ + d$ + ",1)" + t$
      END IF
      i% = 6: g% = 6
      WHILE MID$(a$, i%, 1) <> d$ AND i% < leng%
       i% = i% + 1
      WEND
      IF i% < leng% THEN
       j% = i% + 1
       WHILE MID$(a$, j%, 1) <> d$ AND j% < leng%
        j% = j% + 1
       WEND
      b$ = MID$(a$, i%, j% - i% + 1)
      CALL stringx(b$): REM String constant preprocessor
      g% = j%
      ELSE
       b$ = d$ + d$
      END IF
      i% = g% + 1
      z$ = MID$(a$, i%, 1): e$ = ",1": IF z$ = "," THEN e$ = ",0"
      WHILE (z$ = " " OR z$ = "," OR z$ = ";") AND i% < leng%
       i% = i% + 1
       z$ = MID$(a$, i%, 1)
       IF z$ = ";" THEN e$ = ",1"
      WEND
      a$ = RIGHT$(a$, leng% - i% + 1): REM CALL gulix(a$)
      CALL inputfmt(a$, formt$, prt$, n%, 1)
      CALL quadrix(prt$)
      IF n% = -1 THEN
       prtf$ = "while(INPUT(" + b$ + e$ + ") == NULL) printf(" + d$ + "Redo from start:\n" + d$ + ");"
       PRINT #2, spc$ + prtf$
       PRINT #2, spc$ + "strcpy(" + prt$ + ",tws__S);"
      ELSE
       prtf$ = "while(sscanf(INPUT(" + b$ + e$ + ")," + d$ + formt$ + d$ + prt$ + ") !=" + STR$(n%) + " && tws__S[0] != '\n')"
       PRINT #2, spc$ + prtf$
       PRINT #2, spc$ + "{ printf(" + d$ + "Redo from start:\n" + d$ + "); }"
      END IF
       commfl% = 1
       inputff% = 1
       extrnfl% = 1
       twsflg% = 1
     RETURN


6000 REM Labels
     i% = ASC(LEFT$(a$, 1))
     IF i% >= 48 AND i% <= 57 THEN
      labl$ = STR$(VAL(a$))
      labl$ = MID$(labl$, 2, LEN(labl$) - 1) + ":"
      PRINT #2, "Lab_" + labl$ + t$
      commfl% = 1
     END IF
     RETURN


6500 REM "GOTO"
      leng% = LEN(a$)
      b$ = MID$(a$, 5, leng% - 4): CALL gulix(b$)
      PRINT #2, spc$ + "goto " + "Lab_" + b$ + ";" + t$
      commfl% = 1
     RETURN


7000 REM "CALL"
     commfl% = 1: e$ = CHR$(34)
     leng% = LEN(a$): j% = 0
     FOR i% = 5 TO leng%
      b$ = MID$(a$, i%, 1)
      IF b$ = "(" THEN j% = i%: GOTO 7001
     NEXT i%
7003 prtf$ = MID$(a$, 5, leng% - 4): CALL gulix(prtf$)
     PRINT #2, spc$ + prtf$ + "();" + t$
     RETURN
7001 prtf$ = MID$(a$, 5, j% - 5): CALL gulix(prtf$)
     FOR k% = 1 TO nsub% 
      IF prtf$ = subname$(k%) THEN GOTO 7004 
     NEXT k%
     PRINT "WARNING: " + prtf$ + " is not a user defined SUBroutine or FUNCTION"
     GOTO 7003
7004 
     varlist$ = MID$(a$, j% + 1, leng% - j% - 1)
     CALL tokenix(varlist$, n%, ",", "")
     varlist$ = ""
     tmp1% = 0: tmp2% = 0: tmp3% = 0: tmp4% = 0: tmp8% = 0
     FOR i% = 1 TO n%
      d$ = tmp$(i%): CALL vartyp(d$, typ%)
      IF typ% = 7 THEN
       PRINT "ERROR: String expressions not allowed as function parameters in line"; nl%; ":"
       PRINT line$
C      exit(1);
      END IF
      IF constfl% = 1 OR typ% = 6 THEN
       tip% = 0: b$ = subvar$(k%, i%): CALL vartyp(b$, tip%)
       IF tip% = 1 OR tip% = 6 THEN
        IF tmp1% = 0 THEN PRINT #2, spc$ + "i__stmp = ++i__s % 16;"
        PRINT #2, spc$; "w__s[(i__stmp +"; tmp1%; ") % 16] = "; d$; ";"
C    sprintf(tws__S,"%s%s%d%s",varlist_S,"&w__s[(i__stmp+",tmp1_int,")%16], ");
C    strcpy(varlist_S,tws__S);
C       tmp1_int++;
        inttfl% = 1
       ELSE
        IF tip% = 2 THEN
         IF tmp2% = 0 THEN PRINT #2, spc$ + "i__ltmp = ++i__l % 16;"
         PRINT #2, spc$; "w__l[(i__ltmp +"; tmp2%; ") % 16] = "; d$; ";"
C    sprintf(tws__S,"%s%s%d%s",varlist_S,"&w__l[(i__ltmp+",tmp2_int,")%16], ");
C    strcpy(varlist_S,tws__S);
C        tmp2_int++;
         longtfl% = 1
        ELSE
         IF tip% = 3 THEN
          IF tmp3% = 0 THEN PRINT #2, spc$ + "i__ftmp = ++i__f % 16;"
          PRINT #2, spc$; "w__f[(i__ftmp +"; tmp3%; ") % 16] = "; d$; ";"
C    sprintf(tws__S,"%s%s%d%s",varlist_S,"&w__f[(i__ftmp+",tmp3_int,")%16], ");
C    strcpy(varlist_S,tws__S);
C         tmp3_int++;
          floattfl% = 1
         ELSE
          IF tip% = 4 THEN
           IF tmp4% = 0 THEN PRINT #2, spc$ + "i__dtmp = ++i__d % 16;"
           PRINT #2, spc$; "w__d[(i__dtmp +"; tmp4%; ") % 16] = "; d$; ";"
C    sprintf(tws__S,"%s%s%d%s",varlist_S,"&w__d[(i__dtmp+",tmp4_int,")%16], ");
C    strcpy(varlist_S,tws__S);
C          tmp4_int++;
           vdblff% = 1
          ELSE
           IF tip% = 5 THEN
REM         PRINT #2, spc$ + "if(++j__S == 16) j__S=0;"
REM         PRINT #2, spc$ + "strcpy(w__S[j__S], " + d$ + ");"
REM         varlist$ = varlist$ + "w__S[j__S], "
REM         chartfl% = 1
            varlist$ = varlist$ + d$ + ", "
           ELSE
            IF tip% = 8 THEN
             IF tmp8% = 0 THEN PRINT #2, spc$ + "i__btmp = ++i__b % 16;"
             PRINT #2, spc$; "w__b[(i__btmp +"; tmp8%; ") % 16] = "; d$; ";"
C    sprintf(tws__S,"%s%s%d%s",varlist_S,"&w__b[(i__btmp+",tmp8_int,")%16], ");
C    strcpy(varlist_S,tws__S);
C            tmp8_int++;
             byttfl% = 1
            ELSE
             PRINT "ERROR: Unrecognized argument: "; d$; " in subroutine: " + subname$(k%)
             PRINT "when calling: "; line$; " in line No: "; nl%
C            exit(1);
            END IF
           END IF
          END IF
         END IF
        END IF
       END IF
      ELSE
       IF typ% = 5 OR typ% = 15 THEN
        varlist$ = varlist$ + d$ + ", "
       ELSE
        varlist$ = varlist$ + "&" + d$ + ", "
       END IF
      END IF
     NEXT i%
     varlist$ = LEFT$(varlist$, LEN(varlist$) - 2)
     CALL quadrix(varlist$)
     prtf$ = prtf$ + "(" + varlist$ + ");"
     IF tmp1% THEN PRINT #2, spc$; "i__s = (i__s +"; tmp1% - 1; ") % 16;"
     IF tmp2% THEN PRINT #2, spc$; "i__l = (i__l +"; tmp2% - 1; ") % 16;"
     IF tmp3% THEN PRINT #2, spc$; "i__f = (i__f +"; tmp3% - 1; ") % 16;"
     IF tmp4% THEN PRINT #2, spc$; "i__d = (i__d +"; tmp4% - 1; ") % 16;"
     IF tmp8% THEN PRINT #2, spc$; "i__b = (i__b +"; tmp8% - 1; ") % 16;"
     PRINT #2, spc$ + prtf$ + t$
     RETURN


7500 REM "LET"
      a$ = MID$(a$, 4): GOTO 18000: REM expression
     RETURN


8000 REM "FOR "
      leng% = LEN(a$)
      ix0% = 5
      j% = ix0%
      DO WHILE MID$(a$, j%, 3) <> "TO " AND j% < leng%
       j% = j% + 1
      LOOP
      IF j% = leng% THEN 
       PRINT "ERROR: missing TO in line No"; nl%; ":"; line$
C      exit(1);
      END IF
      b$ = MID$(a$, ix0%, j% - ix0% - 1)
      CALL gulix(b$)
      CALL mathexp(b$)
      CALL quadrix(b$)
      k% = 1
      DO WHILE MID$(b$, k%, 1) <> "="
       k% = k% + 1
      LOOP
      e$ = MID$(b$, 1, k% - 2)
      c$ = MID$(b$, k% + 2): CALL gulix(c$)
      L% = j% + 3
      DO WHILE MID$(a$, L%, 4) <> "STEP" AND L% <= leng%
       L% = L% + 1
      LOOP
      d$ = MID$(a$, j% + 3, L% - j% - 3)
      CALL gulix(d$): CALL mathexp(d$): CALL quadrix(d$)
      IF leng% - L% - 3 >= 0 THEN
       f$ = RIGHT$(a$, leng% - L% - 3)
       CALL gulix(f$)
       x = VAL(f$)
       IF (x > 0!) THEN
        prtf$ = spc$ + "for(" + b$ + "; " + e$ + " <= " + d$ + "; " + e$ + " = " + e$ + " + " + f$ + ")"
       ELSE
        IF (x < 0!) THEN
         prtf$ = spc$ + "for(" + b$ + "; " + e$ + " >= " + d$ + "; " + e$ + " = " + e$ + f$ + ")"
        ELSE
         CALL mathexp(f$): CALL quadrix(f$)
         PRINT #2, spc$ + "if(++j__sig == 16) j__sig=0;" + t$
         t$ = "": sigiff% = 1
         PRINT #2, spc$ + "sig__i[j__sig] = 1; if(" + f$ + " < 0) sig__i[j__sig] = -1;"
         prtf$ = spc$ + "for(" + b$ + "; sig__i[j__sig]*" + e$ + " <= sig__i[j__sig]*" + d$ + "; " + e$ + " = " + e$ + " + " + f$ + ")"
        END IF
       END IF
      ELSE
       prtf$ = spc$ + "for(" + b$ + "; " + e$ + " <= " + d$ + "; " + e$ + "++)"
      END IF
      PRINT #2, prtf$ + t$
      PRINT #2, spc$ + "{"
      lspac% = lspac% + 1
      spc$ = SPACE$(lspac%) 
      commfl% = 1
     RETURN


8500 REM "NEXT"
      PRINT #2, SPACE$(lspac% - 1) + "}"
      lspac% = lspac% - 1
      spc$ = SPACE$(lspac%) 
      IF lspac% < 0 THEN PRINT "WARNING! Braces count = "; lspac%; " at line: "; nl%; ":"; line$
      commfl% = 1
     RETURN


9000 REM "OPEN..."
      leng% = LEN(a$)
      jopn% = jopn% + 1: i% = 4: j% = 0
      DO WHILE i% < leng% AND MID$(a$, i%, 1) <> "#"
       IF MID$(a$, i%, 3) = "FOR" THEN j% = i%
       d$ = MID$(a$, i%, 6)
       IF d$ = "INPUT " THEN mode$ = "r"
       IF d$ = "OUTPUT" THEN mode$ = "w"
       IF d$ = "APPEND" THEN mode$ = "a"
REM    IF d$ = "RANDOM" THEN mode$ = "r+"
REM    IF d$ = "BINARY" THEN mode$ = "??"
       i% = i% + 1
      LOOP
      IF mode$ = "" THEN mode$ = "r+"
      IF j% = 0 THEN
       PRINT "ERROR missing FOR in line No"; nl%; ":"; line$
C      exit(1);
      ELSE
       f$ = MID$(a$, 5, j% - 5)
       CALL quadrix(f$)
       CALL tokenix(f$, n%, "+", "")
       IF n% > 1 THEN
        CALL printfmt(f$, formt$, prt$, nflag%)
        prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
        PRINT #2, spc$ + prtf$
        f$ = "tws__S"
        twsflg% = 1
       END IF
      END IF
      CALL gulix(f$)
      n% = VAL(MID$(a$, i% + 1))
      d$ = STR$(n%)
      n$ = MID$(d$, 2)
      prtf$ = "if((fp_" + n$ + " = fopen(" + f$ + ", " + CHR$(34) + mode$ + CHR$(34) + ")) == NULL)"
      PRINT #2, spc$ + prtf$ + t$
      PRINT #2, spc$ + "{"
      PRINT #2, SPACE$(lspac% + 1) + "fprintf(stderr," + CHR$(34) + "Can't open file %s\n" + CHR$(34) + "," + f$ + "); exit(1);"
      PRINT #2, spc$ + "}"
      commfl% = 1
      i% = 1
      DO WHILE lfopen%(i%) <> n% AND i% <= nlopen%
       i% = i% + 1
      LOOP
      IF i% <= nlopen% THEN
       lfopen%(i%) = n%
       lfopen$(i%) = f$
      ELSE
       nlopen% = nlopen% + 1
       lfopen%(nlopen%) = n%
       lfopen$(nlopen%) = f$
      END IF
     RETURN


9500 REM "CLOSE"
      leng% = LEN(a$)
      i% = 6
      DO WHILE i% < leng% AND MID$(a$, i%, 1) <> "#"
       i% = i% + 1
      LOOP
      IF i% = leng% THEN RETURN
      g& = VAL(MID$(a$, i% + 1, leng% - i%))
      n$ = STR$(g&): n$ = MID$(n$, 2, LEN(n$) - 1)
      PRINT #2, spc$ + "fclose(fp_" + n$ + ");" + t$
      commfl% = 1
     RETURN


11000 REM "GOSUB "
       leng% = LEN(a$)
       b$ = MID$(a$, 6, leng% - 5): CALL gulix(b$)
       prtf$ = "if (setjmp(j__buf[j__lev++])==0) goto Lab_" + b$ + ";"
       PRINT #2, spc$ + "/* GOSUB Lab_" + b$ + " */ " + t$
       PRINT #2, spc$ + prtf$
       commfl% = 1
      RETURN


11500 REM "RETURN"
       prtf$ = "longjmp(j__buf[--j__lev],1);"
       PRINT #2, spc$ + "/* RETURN */"
       PRINT #2, spc$ + prtf$ + t$
       commfl% = 1
      RETURN


12000 REM "RANDOMIZE"
       b$ = MID$(a$, 10): CALL gulix(b$)
       CALL quadrix(b$)
C      if (strlen(b_S)==0) {
       prtf$ = "RANDOMIZE(32767);"
C      } else {
       prtf$ = "RANDOMIZE((long)" + b$ + ");"
C      }
       PRINT #2, spc$ + prtf$ + t$
       commfl% = 1
      RETURN


12200 REM "PAUSE "
       b$ = MID$(a$, 7): CALL gulix(b$)
       IF b$ = "" THEN RETURN
       CALL quadrix(b$)
       PRINT #2, spc$ + "t__.tv_sec = floor(" + b$ + ");"
       PRINT #2, spc$ + "t__.tv_usec= 1000000*(" + b$ + "-t__.tv_sec);"
       PRINT #2, spc$ + "select(0, (void *)0, (void *)0, (void *)0, &t__);" + t$
       mathfl% = 1
       pausefl% = 1
       commfl% = 1
      RETURN


17000 REM "SHELL"  Only explicite form "..." of shell commands is suported.
      REM eg. "del " + name$
      commfl% = 1
      IF a$ = "SHELL" THEN a$ = "": GOTO 17030
      a$ = MID$(a$, 6): CALL stringx(a$): CALL gulix(a$): leng% = LEN(a$)
      IF noshell% = 1 THEN GOTO 17015
      ii% = 1: togfl% = 0
      DO WHILE ii% < leng%
       IF ASC(MID$(a$, ii%, 1)) = 34 THEN togfl% = 1 - togfl%
       IF togfl% = 0 THEN GOTO 17010
       b$ = MID$(a$, ii%, 3)
       d$ = MID$(a$, ii%, 4)
       e$ = MID$(a$, ii%, 6)
C      if (ii_int == 1) 
C      { i1_int=32; }
C      else
C      { i1_int=a_S[ii_int-2]; }
REM
       IF i1% <> 32 AND i1% <> 34 THEN GOTO 17010
       IF d$ = "copy" THEN
C       i2_int=a_S[ii_int-1+4];
C       if (i2_int!=32 && i2_int!=34) goto Lab_17010;
        a$ = LEFT$(a$, ii% - 1) + "cp" + RIGHT$(a$, leng% - ii% - 3)
        leng% = leng% - 2: ii% = ii% + 2
        GOTO 17010
       END IF
REM
       IF e$ = "rename" THEN
C       i2_int=a_S[ii_int-1+6];
C       if (i2_int!=32 && i2_int!=34) goto Lab_17010;
        a$ = LEFT$(a$, ii% - 1) + "mv" + RIGHT$(a$, leng% - ii% - 5)
        leng% = leng% - 4: ii% = ii% + 2
        GOTO 17010
       END IF
REM
       IF b$ = "del" THEN
C       i2_int=a_S[ii_int-1+3];
C       if (i2_int!=32 && i2_int!=34) goto Lab_17010;
        a$ = LEFT$(a$, ii% - 1) + "rm -f" + RIGHT$(a$, leng% - ii% - 2)
        leng% = leng% + 2: ii% = ii% + 5
        GOTO 17010
       END IF
REM
       IF b$ = "dir" THEN
C       i2_int=a_S[ii_int-1+3];
C       if (i2_int!=32 && i2_int!=34) goto Lab_17010;
        a$ = LEFT$(a$, ii% - 1) + "ls -l" + RIGHT$(a$, leng% - ii% - 2)
        leng% = leng% + 2: ii% = ii% + 5
        GOTO 17010
       END IF
REM
       IF b$ = "cls" THEN
C       i2_int=a_S[ii_int-1+3];
C       if (i2_int!=32 && i2_int!=34) goto Lab_17010;
        a$ = LEFT$(a$, ii% - 1) + "clear" + RIGHT$(a$, leng% - ii% - 2)
        leng% = leng% + 2: ii% = ii% + 5
        GOTO 17010
       END IF
17010 ii% = ii% + 1
      LOOP
17015 CALL gulix(a$)
      CALL tokenix(a$, n%, "+", "")
      IF n% > 1 THEN
       CALL printfmt(a$, formt$, prt$, nflag%)
       CALL quadrix(prt$)
       prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
       PRINT #2, spc$ + prtf$
       a$ = "tws__S"
       twsflg% = 1
      END IF
17030 CALL quadrix(a$)
      prtf$ = "system(" + a$ + ");"
      PRINT #2, spc$ + prtf$ + t$
      RETURN


18000 REM numerical and string expressions
      IF commfl% = 1 THEN RETURN
      leng% = LEN(a$): togfl% = 0: i% = 1
C     while (! (togfl_int == 0 && a_S[i_int-1] == '=') && i_int < leng_int) {
C      if (a_S[i_int-1] == '"') togfl_int = 1 - togfl_int;
C      i_int++;
C     }
      IF i% = leng% THEN RETURN
      commfl% = 1: tmpfl% = 0: expflg% = 1: fcond% = 0: togfl% = 0
      e$ = LEFT$(a$, i% - 1): CALL gulix(e$): CALL vartyp(e$, typ%)
      IF funcflag% = 1 THEN
       IF e$ = funcnam$ THEN fcond% = 1: REM Function assignment line
      END IF
      IF typ% = 5 OR typ% = 15 THEN
       a$ = MID$(a$, i% + 1): CALL gulix(a$)
       CALL stringx(a$): REM String constant pretprocessor
       CALL vartyp(a$, typ%)
       CALL printfmt(a$, formt$, prt$, nflag%): REM string expression processing
       IF typ% = 7 THEN
        FOR j% = 1 TO nptk%
         IF e$ = tmp$(j%) THEN tmpfl% = 1: GOTO 18001
        NEXT j%
18001   IF tmpfl% = 1 AND fcond% = 1 THEN 
         PRINT "SYNTAX ERROR in line No"; nl%; ":"; line$
         PRINT "Function name must be on the left side only"
C        exit(1);
        END IF
        IF tmpfl% = 1 OR fcond% = 1 THEN
         prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
         twsflg% = 1
         IF fcond% = 1 THEN togfl% = 1
        ELSE
         CALL quadrix(e$)
         prtf$ = "sprintf(" + e$ + "," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
        END IF
       ELSE
        IF fcond% = 1 THEN
         prtf$ = "return " + MID$(prt$, 2) + ";"
        ELSE
         CALL quadrix(e$)
         prtf$ = "strcpy(" + e$ + prt$ + ");"
        END IF
       END IF
      ELSE
C      strcpy(b_S, &a_S[i_int]);
       CALL gulix(b$)
       IF LEFT$(b$, 8) = "XWINDOW " THEN
        xwflag% = 1: f$ = e$: CALL quadrix(f$): a$ = b$
        GOTO 21000
       END IF
       CALL mathexp(a$): REM Translating math. functions
       IF fcond% = 1 THEN
        prtf$ = "return " + MID$(a$, i% + 1) + ";"
       ELSE
        prtf$ = a$ + ";"
       END IF
       expflg% = 0
      END IF
      CALL quadrix(prtf$)
      PRINT #2, spc$ + prtf$ + t$
      IF tmpfl% = 1 THEN
       IF NOT fcond% THEN CALL quadrix(e$)
       PRINT #2, spc$ + "strcpy(" + e$ + ",tws__S);"
      END IF
      IF togfl% = 1 THEN
       PRINT #2, spc$ + "return tws__S;"
      END IF
      expflg% = 0
     RETURN


19000 REM "END SUB"  and "END FUNCTION"
      PRINT #2, "}"
      IF lspac% <> 1 THEN
       IF funcflag% = 1 THEN
C       fprintf(stderr,"ERROR: Brace misscount of %d occured at the end of FUNCTION: %s\n",lspac_int-1, subname_S[isub_int]); exit(1);
       ELSE
C       fprintf(stderr,"ERROR: Brace misscount of %d occured at the end of SUBroutine: %s\n",lspac_int-1, subname_S[isub_int]); exit(1);
       END IF
      END IF
      commfl% = 1
      funcflag% = 0
     RETURN



19100 REM "EXIT SUB"
      prtf$ = "return;"
      PRINT #2, spc$ + prtf$ + t$
      commfl% = 1
     RETURN


20000 REM "LINE " (graphics) statement
      REM Draws a line and sets the new current position x=xy(0,0), y=xy(0,1)
        b$ = MID$(a$, 5)
        CALL quadrix(b$)
        CALL tokenix(b$, k%, "-", ",")
C       strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
C       strcpy(d_S,tmp_S[2]+1); d_S[strlen(d_S)-1]='\0';
        CALL tokenix(b$, n%, ",", "")
        temp$(1) = tmp$(1): temp$(2) = tmp$(2)
        CALL tokenix(d$, n%, ",", "")
        temp$(3) = tmp$(1): temp$(4) = tmp$(2)
        tmpfl% = 0: GOSUB 20050: IF tmpfl% = 1 THEN GOTO 20009 
      PRINT #2, spc$ + "xy__pos[1][0]=" + temp$(1) + "; xy__pos[1][1]=" + temp$(2) + ";" + t$
      PRINT #2, spc$ + "xy__pos[0][0]=" + temp$(3) + "; xy__pos[0][1]=" + temp$(4) + ";"
      PRINT #2, spc$ + "ixline(2,xy__pos);"
20009 IF updateff% = 1 THEN
       PRINT #2, spc$ + "ixupdwi(0);"
      END IF
      grafflg% = 1
      commfl% = 1
      RETURN

20050 REM options handling (color, B[F], style)
      IF k% >= 3 THEN
       b$ = tmp$(3)
       CALL quadrix(b$)
       PRINT #2, spc$ + "ixsetlc((int)" + b$ + ");"
      END IF
      IF k% >= 5 THEN
       REM PRINT #2, spc$ + ""
       PRINT "WARNING: dashing style is not supported in LINE command ! Ignored."
       PRINT "Set the dashing style with SET DMOD in line No."; nl%
      END IF
      IF k% >= 4 THEN
C      if (tmp_S[4][0]=='\0')
C      {
       RETURN
C      } 
       IF tmp$(4) = "BF" THEN
        PRINT #2, spc$ + "ixsetfc((int)" + b$ + "); ixsetfs(1, 1);"
        e$ = "),1);"
       ELSE
        e$ = "),2);"
       END IF
       PRINT #2, spc$ + "ixbox((int)(" + temp$(1) + "),(int)(" + temp$(3) + "),(int)(" + temp$(2) + "),(int)(" + temp$(4) + e$ + t$
       tmpfl% = 1
      END IF
      RETURN


20500 REM "PSET " (graphics) statement
      REM Draws a point and sets the new current position x=xy(0,0), y=xy(0,1)
      b$ = MID$(a$, 5): CALL gulix(b$)
C     if (b_S[0] != '(') goto Lab_20509;
      CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
      IF k% > 2 THEN 29000
      IF k% = 2 THEN
       d$ = "),(int)(" + tmp$(2) + ")"
      ELSE
       d$ = "),-1"
      END IF
C     strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
      CALL tokenix(b$, n%, ",", "")
      PRINT #2, spc$ + "ixpset((int)(" + tmp$(1) +"),(int)(" + tmp$(2) + d$ + ");" + t$
REM   IF updateff% = 1 THEN
REM    PRINT #2, spc$ + "ixupdwi(0);"
REM   END IF
      grafflg% = 1
      commfl% = 1
20509 RETURN


21000 REM "SCREEN " and/or "XWINDOW " (graphics)
      REM SCREEN: Initialize graphics and open an X-window
      REM Original syntax:   SCREEN mode
      REM Additional syntax: SCREEN (x, y)[, w, h[, title$[, Xfont_name$]]]
      REM XWINDOW: Open a new X-window. SCREEN opens window with ID=0, whereas
      REM XWINDOW opens ID=1, 2, ... 20. It is NOT a BASIC command.
      REM Syntax: XWINDOW (x, y)[, w, h[, title$]]
      REM (x, y)=position, (w, h)=size in pixels
      REM 819x484 -misc-fixed-medium-r-normal-*-20-140-*-100-c-100-iso8859-1
      e$ = CHR$(34)
      twsflg% = 1
C     if ( memcmp(a_S,"SCREEN ",7)==0 ) {
       PRINT #2, spc$ + "/* SCREEN initializations */"
       PRINT #2, spc$ + "if (ixopnds(" + e$ + e$ + ")==-1) exit(0);"
C     }
      b$ = MID$(a$, 8): CALL gulix(b$)
      IF b$ = "" THEN GOTO 29000
      typ% = 0: REM Used as a flag
C     c = b_S[0];
      CALL tokenix(b$, k%, ",", "")
C     if (c == '(')
C     {
C      k_int++;
       temp$(6) = tmp$(5)
       temp$(5) = tmp$(4)
       temp$(4) = tmp$(3)
       temp$(3) = tmp$(2)
C      strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
       CALL tokenix(b$, n%, ",", "")
       IF n% <> 2 THEN RETURN
       temp$(2) = tmp$(2)
       temp$(1) = tmp$(1)

       CALL vartyp(temp$(5), typ%)
       IF typ% = 7 THEN
        CALL printfmt(temp$(5), formt$, prt$, nflag%)
        prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
REM     PRINT #2, spc$ + prtf$
        temp$(5) = "tws__S"
        twsflg% = 1
       END IF
C     }
      b$ = e$ + "QB2C" + e$
      d$ = "-misc-fixed-medium-r-normal-*-20-140-*-100-c-100-iso8859-1"
      d$ = e$ + d$ + e$
      IF k% > 4 THEN b$ = temp$(5): REM title
      IF k% > 5 THEN d$ = temp$(6): REM font
C     if (k_int == 1 && c != '(')
C     {
       IF tmp$(1) = "10" THEN
        prt$ = spc$ + "ixopnwi(100,100,819,484," + b$ + ",0);" + t$
        commfl% = 1
       ELSE
        IF tmp$(1) = "0" THEN
         PRINT "WARNING! SCREEN 0 is obsolete, ignored since"
         PRINT "there is no need to switch to tty mode."
         commfl% = 1
         RETURN
        ELSE
         PRINT a$; " not supported! Mode must be 0 or 10"
        END IF
       END IF 
C     }
C     else
C     {
       IF k% = 2 THEN
        temp$(3) = "819"
        temp$(4) = "484"
       ELSE 
        IF k% < 4 THEN RETURN
       END IF
       prt$ = "ixopnwi((int)" + temp$(1) + ",(int)" + temp$(2) + ",(int)" + temp$(3) + ",(int)" + temp$(4) + "," + b$ + ",0);" + t$
C     }
C     if ( memcmp(a_S,"SCREEN ",7)==0 ) {
       PRINT #2, spc$ + "ixsetfs(0,0); ixsetfc(1); ixsettc(1); ixsetta(0,0); ixsetms(0,5,xy__pos);"
       PRINT #2, spc$ + "strcpy(tws__S," + d_S + ");"
       PRINT #2, spc$ + "if(ixsettf(1,tws__S)==1)"
       PRINT #2, spc$ + "{ fprintf(stderr," + e$ + "Requested Xfont not found: %s\n" + e$ + ",tws__S); }"
C     }
      IF typ% = 7 THEN
       PRINT #2, spc$ + prtf$
      END IF
      IF xwflag% THEN
       PRINT #2, spc$ + f$ + "=" + prt$
       xwflag% = 0
      ELSE
       PRINT #2, spc$ + prt$
      END IF
      grafflg% = 1
      commfl% = 1
      RETURN


21500 REM "SET " (graphics) statement
      e$ = CHR$(34): j% = LEN(a$)
C     i_int = 4; while(a_S[i_int] != ' ' && i_int < j_int) i_int++;
      IF i% = j% THEN
       PRINT "ERROR: Syntax error in line No"; nl%; ": "; a$
C      exit(1);
      END IF
      d$ = MID$(a$, 5, i% - 4): REM Opcija od SET
      b$ = MID$(a$, i% + 2)
      CALL quadrix(b$)
      CALL tokenix(b$, k%, ",", "")
      IF k% = 1 THEN
       prt$ = "((int)(" + tmp$(1) + ")); " + t$
      ELSE
       IF k% = 2 THEN
        prt$ = "((int)(" + tmp$(1) + ") ,(int)(" + tmp$(2) + "));" + t$
       END IF
      END IF
      IF d$ = "PLCI" OR d$ = "LCOL" THEN
       IF k% <> 1 THEN 29000 
       PRINT #2, spc$ + "ixsetlc" + prt$
       commfl% = 1
      ELSE
       IF d$ = "LWID" THEN
        IF k% <> 1 THEN 29000 
        PRINT #2, spc$ + "ixsetln" + prt$
        commfl% = 1
       ELSE
        IF d$ = "PMTS" THEN
         IF k% <> 2 THEN 29000 
         PRINT #2, spc$ + "ixsetmts" + prt$
         commfl% = 1
        ELSE
         IF d$ = "PMCI" THEN
          IF k% <> 1 THEN 29000 
          PRINT #2, spc$ + "ixsetmc" + prt$
          commfl% = 1
         ELSE
          IF d$ = "FASI" THEN
           IF k% <> 2 THEN 29000 
           PRINT #2, spc$ + "ixsetfs" + prt$
           commfl% = 1
          ELSE
           IF d$ = "FACI" THEN
            IF k% <> 1 THEN 29000 
            PRINT #2, spc$ + "ixsetfc" + prt$
            commfl% = 1
           ELSE
            IF d$ = "TXCI" THEN
             IF k% <> 1 THEN 29000 
             PRINT #2, spc$ + "ixsettc" + prt$
             commfl% = 1
            ELSE
             IF d$ = "TFON" THEN
              PRINT #2, spc$ + "if(ixsettf(1," + tmp$(1) + ")==1)" + t$
              PRINT #2, spc$ + "{ fprintf(stderr," + e$ + "Requested Xfont not found: %s\n" + e$ + ",tws__S); }"
              commfl% = 1
             ELSE
              IF d$ = "TXAL" THEN
               IF k% <> 2 THEN 29000 
               PRINT #2, spc$ + "ixsetta" + prt$
               commfl% = 1
              ELSE
               IF d$ = "BG" THEN
                PRINT #2, spc$ + "ixsetbg" + prt$
                commfl% = 1
               ELSE
                IF d$ = "DRMD" THEN
                 IF k% <> 1 THEN 29000 
                 PRINT #2, spc$ + "ixdrmde" + prt$
                 commfl% = 1
                ELSE
                 IF d$ = "DMOD" THEN
                  IF k% > 10 THEN
C                  fprintf(stderr,"Too many arguments to DMOD (>10)\n");exit(1);
                  END IF
                  IF k% = 1 THEN
                   PRINT #2, spc$ + "D__[0] = " + tmp$(1) + ";" + t$
                   PRINT #2, spc$ + "ixsetls(1, D__);"
                  ELSE
                   IF k% >= 2 THEN
C                   strcpy(b_S,"D__[0]="); 
C                   strcat(b_S,tmp_S[1]); strcat(b_S,"; ");
                    FOR i% = 2 TO k%
C                    strcat(b_S,"D__["); c='0'+i_int-1; strcat(b_S,&c);
C                    strcat(b_S,"]="); strcat(b_S,tmp_S[i_int]);
C                    strcat(b_S,"; ");
                    NEXT i%
                    PRINT #2, spc$ + b$ + t$
                    PRINT #2, spc$ + "ixsetls((int)" + STR$(k%) + ", D__);"
                   ELSE
                    PRINT #2, spc$ + "ixsetls(0, D__);" + t$
                   END IF
                  END IF
                  grafflg% = 1
                  commfl% = 1
                 END IF
                END IF
               END IF
              END IF
             END IF
            END IF
           END IF
          END IF
         END IF
        END IF
       END IF
      END IF
      RETURN


22000 REM "SAVEGIF " (graphics) statement
      REM save the picture into the file
      REM Syntax: SAVEGIF filename$
       b$ = MID$(a$, 8): CALL gulix(b$)
       CALL stringx(b$)
       CALL vartyp(b$, typ%)
       IF typ% = 7 THEN
        CALL printfmt(b$, formt$, prt$, nflag%)
        prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
        PRINT #2, spc$ + prtf$
        b$ = "tws__S"
        twsflg% = 1
       END IF
       PRINT #2, spc$ + "ixdogif(" + b$ + ");" + t$
       commfl% = 1
      RETURN


22500 REM "LOADGIF " (graphics) statement
      REM load a picture from the file
      REM Syntax: LOADGIF (x%, y%), filename$[, ipal%], bgcolor%]
      b$ = MID$(a$, 8): CALL gulix(b$)
C     if (b_S[0] != '(') goto Lab_22509;
      CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
      IF k% < 2 THEN RETURN
      b$ = tmp$(1)
      d$ = tmp$(2): CALL stringx(d$): CALL quadrix(d$)
C     strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
      CALL tokenix(b$, n%, ",", "")
      IF k% >= 3 THEN
       b$ = tmp$(3): CALL quadrix(b$)
      ELSE
       b$ = "0": REM default for ipal
      END IF
      IF k% >= 4 THEN
       f$ = tmp$(4): CALL quadrix(f$)
      ELSE
       f$ = "-1": REM default for bgcolor
      END IF
      temp$(1) = tmp$(1): temp$(2) = tmp$(2)

      CALL tokenix(d$, n%, "+", "")
      IF n% > 1 THEN
       CALL printfmt(d$, formt$, prt$, nflag%)
       prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
       PRINT #2, spc$ + prtf$
       d$ = "tws__S"
       twsflg% = 1
      END IF

      PRINT #2, spc$ + "ixldgif((int)(" + temp$(1) + "),(int)(" + temp$(2) + ")," + d$ + ",(int)(" + b$ + "),(int)(" + f$ + "));" + t$
      grafflg% = 1
      commfl% = 1
      IF updateff% = 1 THEN
       PRINT #2, spc$ + "ixupdwi(0);"
      END IF
22509 RETURN


22600 REM "GIFINFO " (graphics) statement
      REM Obtain width, height and ncol of a GIF
      REM Syntax: GIFINFO file$, width[, height[, ncol]]
      b$ = MID$(a$, 8): CALL gulix(b$)
      CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
      IF k% < 2 THEN RETURN
      prt$ = spc$ + tmp$(2) + " = GInf__[0]; "
      IF k% >= 3 THEN prt$ = prt$ + tmp$(3) + " = GInf__[1]; "
      IF k% >= 4 THEN prt$ = prt$ + tmp$(4) + " = GInf__[2];"
      PRINT #2, spc$ + "gifinfo(" + tmp$(1) + ", GInf__);" + t$
      PRINT #2, prt$
      grafflg% = 1
      commfl% = 1
      RETURN


22100 REM "GET " OR "XGETGE " (graphics) statements
      REM GET: get image in an array of pixels
      REM Syntax: GET (x%, y%), w%, h%, array?
      REM XGETGE: get window (win% >= 0) or the root window (win% < 0) geometry
      REM Syntax: XGETGE (x%, y%), w%, h%, win%
      tmpfl% = 0
C     if (a_S[0] == 'G') tmpfl_int = 1;
      IF tmpfl% THEN b$ = MID$(a$, 4): CALL gulix(b$)
      IF NOT tmpfl% THEN b$ = MID$(a$, 7): CALL gulix(b$)
      CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
C     if (b_S[0] != '(' || k_int != 4) {
       PRINT "ERROR in line"; STR$(nl%) + " probably wrong number of arguments:"
       PRINT line$
C      exit(1);
C     }
      b$ = tmp$(1)
      d$ = tmp$(2)
C     strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
      CALL tokenix(b$, n%, ",", "")
      IF n% <> 2 THEN RETURN
      IF tmpfl% THEN
       PRINT #2, spc$ + "ixpicget((int)(" + tmp$(1) + "),(int)(" + tmp$(2) + "),(int)(" + d$ + "),(int)(" + tmp$(3) + ")," + tmp$(4) + ");" + t$
      ELSE
       PRINT #2, spc$ + "ixgetge(" + tmp$(4) + ",&" + tmp$(1) + ",&" + tmp$(2) + ",&" + d$ + ",&" + tmp$(3) + ");" + t$
      END IF
      commfl% = 1
      RETURN


22200 REM "PUT " and/or "XANIM "(graphics) statement
      REM Put array of pixels on window:
      REM Syntax: PUT (x%, y%), array?, w%, h%[, (xs%, ys%)[, sw%, sh%]]
      REM Animate series of arrays: 
      REM Syntax: XANIM (x%, y%), array?, w%, h%[, (xs%, ys%)[, sw%, sh%]]
      flag% = 1
C     if (memcmp(a_S,"XANIM ",6)==0) flag_int = 0;
      IF flag% THEN
       b$ = MID$(a$, 4)
      ELSE
       b$ = MID$(a$, 6)
      END IF
      CALL gulix(b$): CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
C     if (b_S[0] != '(' || (k_int != 4 && k_int != 5 && k_int != 7)) {
       GOTO 29500: REM Error message on No of args and exit
C     }
      d$ = tmp$(2)
      b$ = tmp$(1)
C     strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
      CALL tokenix(b$, n%, ",", "")
      IF n% <> 2 THEN RETURN
      temp$(1) = tmp$(1): temp$(2) = tmp$(2)
      IF k% > 4 THEN
       b$ = tmp$(5)
C      strcpy(b_S,tmp_S[5]+1); b_S[strlen(b_S)-1]='\0';
       CALL tokenix(b$, n%, ",", "")
       IF n% <> 2 THEN RETURN
      END IF
      IF k% = 5 THEN
       tmp$(6) = tmp$(3) + "-" + tmp$(1)
       tmp$(7) = tmp$(4) + "-" + tmp$(2)
      END IF
      IF k% = 4 THEN
       tmp$(1) = "0": tmp$(2) = "0"
       tmp$(6) = tmp$(3): tmp$(7) = tmp$(4)
      END IF
      prt$ = "((int)(" + temp$(1) + "),(int)(" + temp$(2) + ")," + d$ + ",(int)(" + tmp$(3) + "),(int)(" + tmp$(4) + "),(int)(" + tmp$(1) + "),(int)(" + tmp$(2) + "),(int)(" + tmp$(6) + "),(int)(" + tmp$(7) + "));"
      IF flag% THEN
       PRINT #2, spc$ + "ixpicput" + prt$ + t$
      ELSE
       PRINT #2, spc$ + "ixpicanim" + prt$ + t$
      END IF
      commfl% = 1
      RETURN


23000 REM "XUPDATE" (graphics) statement
      REM update (refresh) the X-window
       PRINT #2, spc$ + "ixupdwi(0); " + t$
       commfl% = 1
      RETURN


23200 REM "XCLS" (graphics) statement
      REM Clear the current window according to the current background or
      REM change background color and then clear.
       b$ = MID$(a$, 6)
       CALL gulix(b$)
       CALL quadrix(b$)
       IF b$ = "" THEN
        PRINT #2, spc$ + "ixclrwi(); " + t$
       ELSE
        PRINT #2, spc$ + "ixsetbg((int)" + b$ + "); ixclrwi();" + t$
       END IF
       commfl% = 1
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
      RETURN


23300 REM "GETCOL " (graphics) statement
      REM get color components 
      REM getcol index%, r%, g%, b%  Input: index%, Output r%,g%,b%<=255
      b$ = MID$(a$, 7): CALL tokenix(b$, n%, ",", "")
      IF n% = 4 THEN
       prt$ = tmp$(1) + ")," + tmp$(2) + "," + tmp$(3) + "," + tmp$(4)
       PRINT #2, spc$ + "ixgetcol((int)(" + prt$ + ");" + t$
      ELSE
       GOTO 29500: REM Error message on No of args and exit
      END IF
      commfl% = 1
      RETURN


23400 REM "XSELWI" and/or "XCLOSE" and/or "XCURSOR" (graphics) statement
      REM select and raise window to which subseq. output is sent D=current
       b$ = MID$(a$, 8)
       CALL gulix(b$)
       CALL quadrix(b$)
       IF b$ = "" THEN
        prt$ = "(-1); "
       ELSE
        prt$ = "((int)(" + b$ + ")); "
       END IF
C      if ( memcmp(a_S,"XSELWI",6)==0 ) {
        d$ = "ixselwi"
C      } else {
C       if ( memcmp(a_S,"XCLOSE",6)==0 ) {
         d$ = "ixclswi"
C       } else {
         d$ = "ixcursor"
C       }
C      }
       PRINT #2, spc$ + d$ + prt$ + t$
       commfl% = 1
       grafflg% = 1
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
      RETURN


23500 REM "PALETTE " (graphics) statement
      REM palette index,#hex_color   or
      REM palette index,r,g,b  where r,g,b<=255
      b$ = MID$(a$, 9): CALL tokenix(b$, n%, ",", "")
      IF n% = 4 THEN
       prt$ = tmp$(1) + ")," + tmp$(2) + "," + tmp$(3) + "," + tmp$(4)
       PRINT #2, spc$ + "ixsetco((int)(" + prt$ + ");" + t$
      ELSE
       GOTO 29500: REM Error message on No of args and exit
      END IF
      commfl% = 1
      RETURN


23600 REM "XTITLE " (graphics) statement
      REM xtitle title$[, win%]  Set window title
       b$ = MID$(a$, 7): CALL tokenix(b$, n%, ",", "")
       IF n% = 1 THEN
        d$ = "-1"
       ELSE
        IF n% = 2 THEN
         d$ = "(int)(" + tmp$(2) + ")"
        ELSE
         GOTO 29500: REM Error message on No of args and exit
        END IF
       END IF
       PRINT #2, spc$ + "ixtitle(" + tmp$(1) + "," + d$ + ");" + t$
       commfl% = 1
      RETURN


23700 REM "XREQST " (graphics) statement
      REM xreqst (x%, y%), test$, status% - request string at the postition
      REM and return status 0 = <Esc>, 1 = <Return>
       b$ = MID$(a$, 7): CALL quadrix(b$): CALL tokenix(b$, n%, ",", "")
       IF n% <> 3 THEN
        GOTO 29500: REM Error message on No of args and exit
       END IF
       temp$(2) = tmp$(2)
C      strcpy(d_S,tmp_S[1]+1); d_S[strlen(d_S)-1]='\0';
       CALL tokenix(d$, n%, ",", "")
       PRINT #2, spc$ + tmp$(3) + " = ixreqst((int)(" + tmp$(1) + "),(int)(" + tmp$(2) + ")," + temp$(2) + ");" + t$
       commfl% = 1
      RETURN


23800 REM "XCLIP " (graphics) statement
      REM xclip (x1%, y1%)-(x2%, y2%), win% - set clipping rectangle in
      REM the window win%
       b$ = MID$(a$, 6)
       CALL quadrix(b$)
       CALL tokenix(b$, k%, "-", ",")
       IF k% <> 3 THEN
        GOTO 29500: REM Error message on No of args and exit
       END IF
C      strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
C      strcpy(d_S,tmp_S[2]+1); d_S[strlen(d_S)-1]='\0';
       CALL tokenix(b$, n%, ",", "")
       temp$(1) = tmp$(1): temp$(2) = tmp$(2)
       CALL tokenix(d$, n%, ",", "")
       temp$(3) = tmp$(1): temp$(4) = tmp$(2)
       PRINT #2, spc$ + "ixclip1((int)(" + tmp$(3) + "),(int)(" + temp$(1) + "),(int)(" + temp$(2) + "),(int)(" + temp$(3) + "),(int)(" + temp$(4) +  "));" + t$
       commfl% = 1
      RETURN


23900 REM "XNOCLI " (graphics) statement
      REM xnocli win% - set no clipping for win%
       b$ = MID$(a$, 7)
       CALL quadrix(b$)
       PRINT #2, spc$ + "ixnocli((int)(" + b$ + "));" + t$
       commfl% = 1
      RETURN


23950 REM "XWARP " (graphics) statement
      REM xwarp (x%, y%) - move graphical cursor (pointer) to the position
      REM (x%, y%) in the current window
       b$ = MID$(a$, 6)
       CALL quadrix(b$)
C      b_S[0]=' '; b_S[strlen(b_S)-1]='\0';
       CALL tokenix(b$, n%, ",", "")
       IF n% <> 2 THEN
        GOTO 29500: REM Error message on No of args and exit
       END IF
       PRINT #2, spc$ + "ixwarp((int)(" + tmp$(1) + "),(int)(" + tmp$(2) + "));" + t$
       commfl% = 1
      RETURN


24000 REM "MARKER " (graphics) statement
       b$ = MID$(a$, 8): CALL gulix(b$)
C      if (b_S[0] != '(') goto Lab_24009;
       CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
       IF k% >= 2 THEN
        PRINT #2, spc$ + "ixsetmc(" + tmp$(2) + ");"
       END IF
C      strcpy(b_S,tmp_S[1]+1); b_S[strlen(b_S)-1]='\0';
       CALL tokenix(b$, n%, ",", "")
       PRINT #2, spc$ + "xy__pos[0][0]=" + tmp$(1) + "; xy__pos[0][1]=" + tmp$(2) + ";" + t$
       PRINT #2, spc$ + "ixmarke(1,xy__pos);"
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
       grafflg% = 1
       commfl% = 1
24009 RETURN


24500 REM "PLINE " (graphics) statement
       b$ = MID$(a$, 7): CALL tokenix(b$, n%, ",", "")
       CALL quadrix(tmp$(1)): CALL quadrix(tmp$(2))
       IF n% > 2 THEN
        CALL quadrix(tmp$(3))
        PRINT #2, spc$ + "ixsetlc(" + tmp$(3) + ");"
       END IF
       PRINT #2, spc$ + "ixline(" + tmp$(1) + "," + tmp$(2) + ");" + t$
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
       commfl% = 1
      RETURN


25000 REM "PMARKER " (graphics) statement
       b$ = MID$(a$, 9): CALL tokenix(b$, n%, ",", "")
       CALL quadrix(tmp$(1)): CALL quadrix(tmp$(2))
       IF n% > 2 THEN
        CALL quadrix(tmp$(3))
        PRINT #2, spc$ + "ixsetmc(" + tmp$(3) + ");"
       END IF
       PRINT #2, spc$ + "ixmarke(" + tmp$(1) + "," + tmp$(2) + ");" + t$
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
       commfl% = 1
      RETURN


25500 REM "XTEXT " (graphics) statement
       b$ = MID$(a$, 7): CALL quadrix(b$)
       CALL tokenix(b$, k%, ",", "")
       b$ = tmp$(2): REM    CALL stringix(d$)
       temp$(5) = tmp$(4): temp$(4) = tmp$(3)
C      strcpy(d_S,tmp_S[1]+1); d_S[strlen(d_S)-1]='\0';
       CALL tokenix(d$, n%, ",", "")
       temp$(2) = tmp$(2): temp$(1) = tmp$(1) 
       IF k%  = 2 THEN temp$(4) = "0."
       IF k% <= 3 THEN temp$(5) = "1."
       CALL vartyp(b$, typ%)
       IF typ% = 7 THEN
        CALL printfmt(b$, formt$, prt$, nflag%)
        prtf$ = "sprintf(tws__S," + CHR$(34) + formt$ + CHR$(34) + prt$ + ");"
        PRINT #2, spc$ + prtf$
        b$ = "tws__S"
        twsflg% = 1
       END IF
       PRINT #2, spc$ + "ixtext(0,(int)(" + temp$(1) + "),(int)(" + temp$(2) + "),(float)(" + temp$(4) + "),(float)(" + temp$(5) + ")," + b$ + ");" + t$
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
       commfl% = 1
      RETURN


26000 REM "FAREA " (graphics) statement
       b$ = MID$(a$, 7): CALL quadrix(b$)
       CALL tokenix(b$, n%, ",", "")
       IF n% > 2 THEN
        CALL quadrix(tmp$(3))
        PRINT #2, spc$ + "ixsetfc(" + tmp$(3) + ");"
       END IF
       PRINT #2, spc$ + "ixflare(" + tmp$(1) + "," + tmp$(2) + ");" + t$
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
       commfl% = 1
      RETURN


26500 REM "CIRCLE " (graphics) statement
       b$ = MID$(a$, 8): CALL quadrix(b$)
C      tmp_S[3][0] = '\0';
C      tmp_S[4][0] = '\0';
C      tmp_S[5][0] = '\0';
C      tmp_S[6][0] = '\0';
       CALL tokenix(b$, k%, ",", "")
       tmp$(0) = tmp$(2)
C      strcpy(d_S,tmp_S[1]+1); d_S[strlen(d_S)-1]='\0';
       CALL tokenix(d$, n%, ",", "")
       prt$ = "ixcirc((int)(" + tmp$(1) + "),(int)(" + tmp$(2) + "),(int)(" + tmp$(0)
C      if (tmp_S[3][0]!='\0')
C      {
        PRINT #2, spc$ + "ixsetlc(" + tmp$(3) + ");"
C      }
C      if (tmp_S[4][0]=='\0')
C      {
       tmp$(4) = "0."
C      }
C      if (tmp_S[5][0]=='\0')
C      {
       tmp$(5) = "6.2832"
C      }
C      if (tmp_S[6][0]=='\0')
C      {
       tmp$(6) = "1."
C      }
       prt$ = prt$ + ")," + tmp$(4) + "," + tmp$(5) + "," + tmp$(6) + ");"
       PRINT #2, spc$ + prt$ + t$
       IF updateff% = 1 THEN
        PRINT #2, spc$ + "ixupdwi(0);"
       END IF
       commfl% = 1
      RETURN


27000 REM "GCGET " (graphics) statement
      REM Request mouse position: gcget (x%, y%), answ%[, typ%[, mode%]]
       b$ = MID$(a$, 7): CALL gulix(b$)
       CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
       IF k% < 2 OR k% > 4 THEN 29000
       IF k% < 3 THEN tmp$(3) = "0": REM Default ityp
       IF k% < 4 THEN tmp$(4) = "1": REM Default mode
       tmp$(0) = tmp$(2): d$ = tmp$(1)
C      strcpy(d_S,tmp_S[1]+1); d_S[strlen(d_S)-1]='\0';
       CALL tokenix(d$, n%, ",", "")
       IF n% <> 2 THEN 29000
       PRINT #2, spc$ + tmp$(0) + "=ixreqlo((int)" + tmp$(4) + ",(int)" + tmp$(3) + ",&" + tmp$(1) + ",&" + tmp$(2) + ");" + t$
       commfl% = 1
      RETURN


27500 REM "XPOINTER " (graphics) statement
      REM Request mouse position:xpointer (x%, y%), win%, answ%[, typ%[, mode%]]
       b$ = MID$(a$, 10): CALL gulix(b$)
       CALL quadrix(b$): CALL tokenix(b$, k%, ",", "")
       IF k% < 3 OR k% > 5 THEN 29000
       IF k% < 4 THEN tmp$(4) = "1": REM Default ityp
       IF k% < 5 THEN tmp$(5) = "1": REM Default mode
       tmp$(0) = tmp$(2): d$ = tmp$(1)
C      strcpy(d_S,tmp_S[1]+1); d_S[strlen(d_S)-1]='\0';
       CALL tokenix(d$, n%, ",", "")
       IF n% <> 2 THEN 29000
       PRINT #2, spc$ + tmp$(3) + "=ixwptrq(&" + tmp$(1) + ",&" + tmp$(2) + ",&" + tmp$(0) + ",(int)" + tmp$(4) + ",(int)" + tmp$(5) + ");" + t$
       commfl% = 1
      RETURN


29000 REM Anything else not covered yet
      IF commfl% = 1 THEN RETURN
      PRINT "ERROR in line"; STR$(nl%) + ": " + line$
      PRINT "'"; a$; "'" + " cannot be translated ! Please see the manual."
C     exit(1);
      commfl% = 1
      RETURN


29500 REM Error message on number of arguments
      PRINT "ERROR on line"; STR$(nl%) + " probably wrong number of arguments in:"
      PRINT a$
C     exit(1);


30000 REM for nicer 'REM' placements
      REM input: lremfl%, itok%, ntok%
      IF lremfl% = 1 AND itok% = 1 THEN
       t$ = SPACE$(3) + "/* " + t$ + " */"
       lremfl% = 0
      ELSE
       t$ = ""
      END IF
      RETURN


31000 REM Called before every sub (and MAIN) makes a list of possibly used
REM   arrays "name(" which are converted to C format in 28000
      REM Inputs:
      REM 1) list of shared     vars. & arrs. shtok$(isub%,i%), nsthok%(isub%)
      REM 2) list of used local vars. & arrs. vlist$(isub%,i%), nvlist%(isub%)
      REM 3) list of SUB arguments (NOT YET ! arrays cannot be passed yet)
      REM Outputs:
      REM atmp$(), natmp%
      natmp% = 0: REM Extracting all array names
      FOR i% = 1 TO nshtok%(isub%)
       z$ = shtok$(isub%, i%)
       IF RIGHT$(z$, 1) = ")" THEN
        natmp% = natmp% + 1
        atmp$(natmp%) = LEFT$(z$, LEN(z$) - 1)
       END IF
      NEXT i%
REM   Not needed since DIM fills dynamycally arrays of this class
REM   FOR i% = 1 TO nvlist%(isub%)
REM    z$ = vlist$(isub%, i%)
REM    IF RIGHT$(z$, 1) = ")" THEN
REM      natmp% = natmp% + 1
REM      atmp$(natmp%) = LEFT$(z$, LEN(z$) - 1)
REM    END IF
REM   NEXT i%
      RETURN


40000 REM postprocessing i% -> i_int, i& -> i_long, c$ -> c_S
      REM and array brackets (except in declarations which is done).
      REM Also handles MID$(a$,i%) -> MID_S(a_S,i_int,LMAX)
      OPEN outf$ FOR INPUT AS #3
      OPEN tmpfile$ FOR OUTPUT AS #2
      GOSUB 41000: REM Writing out headers and global declarations
      e$ = CHR$(34): togfl% = 0
      DO WHILE NOT EOF(3)
       LINE INPUT #3, line$
C      if (togfl_int == 1) goto Lab_40001;
C      if (strncmp(line_S,"/* Trans",8) == 0) 
C      { if (strncmp(line_S,"/* Translates of used QB's intrinsic functions: */",50) == 0)
C        togfl_int = 1; goto Lab_40001; }
C      if (cflag_int==1 && strncmp(line_S,"C ",2)==0)
C      {
C       line_S[0] = ' ';
C      }
C      else
C      {
        CALL varpost(line$): REM Postprocessing variable names
C      }
40001  PRINT #2, line$
      LOOP
      CLOSE #3
      CLOSE #2
      REM Cleanup:
      SHELL "mv -f " + tmpfile$ + " " + outf$
      RETURN


41000 REM Writes out headers: #include files and global declarations
      REM before the 'main(...)'
      lspac% = 0: isub% = 0: statfl%(isub%) = 1: REM dirty...
      spc$ = SPACE$(lspac%) 
      PRINT #2, "#include <stdio.h>"
      PRINT #2, "#include <string.h>"
      PRINT #2, "#include <stddef.h>"
      PRINT #2, "#include <stdlib.h>"
      IF retrnfl% = 1 THEN PRINT #2, "#include <setjmp.h>"
      IF timefl% = 1 THEN PRINT #2, "#include <time.h>"
      IF mathfl% = 1 THEN PRINT #2, "#include <math.h>"
      IF grafflg% = 1 THEN PRINT #2, "#include <X11/cursorfont.h>"
      PRINT #2, "#include <ctype.h>"
      IF inkeyff% = 1 AND tflg% = 0 THEN
       PRINT #2, "#include <unistd.h>"
       PRINT #2, "#include <fcntl.h>"
       PRINT #2, "#include <sys/ioctl.h>"
       PRINT #2, "#include <termio.h>"
       PRINT #2, "#include <termios.h>"
      END IF
      IF pausefl% THEN 
       PRINT #2, "#include <sys/types.h>"
       PRINT #2, "#include <sys/time.h>"
      END IF
      PRINT #2,
      PRINT #2, "/* This file was generated by QuickBasic to C translator */"
      PRINT #2, "/* qb2c  ver." + Version$ + "                            */"
      PRINT #2,
      REM Global constants:
      REM PRINT #2, "#define LMAX 32767"
      PRINT #2, "#define LMAX 1024": REM Max. in/out line length (max 32767)
      IF minff% = 1 THEN
       PRINT #2, "#define MIN(a,b) ((a) < (b) ? (a) : (b))"
      END IF
      IF maxff% = 1 THEN
       PRINT #2, "#define MAX(a,b) ((a) > (b) ? (a) : (b))"
      END IF
      IF ncnst% > 0 THEN
       FOR i% = 1 TO ncnst%
        prtf$ = cnst$(i%): CALL varpost(prtf$)
        PRINT #2, prtf$
       NEXT i%
      END IF
      IF ncg% > 0 THEN
       FOR i% = 1 TO ncg%
        PRINT #2, cg$(i%)
       NEXT i%
      END IF 
      PRINT #2,
      PRINT #2, "/* Function declarations */"
      IF extrnfl% = 1 THEN
       CALL qbfdecl
      END IF
      FOR i% = 1 TO nfuncs%
       b$ = funames$(i%): CALL vartyp(b$, typ%): CALL varpost(b$)
       z$ = "": IF typ% = 5 THEN z$ = "*"
       PRINT #2, "extern " + atyp$(typ%) + z$ + b$ + "(" + funtyl$(i%) + ");"
      NEXT i%
      PRINT #2,
      tmpfl% = 0
      PRINT #2, "/* Shared variables and arrays declarations */"
      IF retrnfl% = 1 THEN
       PRINT #2, "static jmp_buf j__buf["; GMAX; "];"
       PRINT #2, "static int  j__lev=0;"
       tmpfl% = 1
      END IF
      IF grafflg% = 1 THEN
       PRINT #2, "static short xy__pos[3][2], D__[10], GInf__[3];" 
       tmpfl% = 1
      END IF
      IF inkeyff% = 1 AND tflg% = 0 THEN
       PRINT #2, "static struct termio term_orig;"
       PRINT #2, "static int  kbdflgs;"
       PRINT #2, "static char keyb__S[30][9], keyq__S[30][4];"
       tmpfl% = 1
      END IF
      IF pausefl% THEN 
       PRINT #2, "static struct timeval t__;"
      END IF
      REM Declaring arrays in MAIN
      IF alis% > 0 THEN
       FOR i% = 1 TO alis%
        d$ = darr$(alist%(i%)): CALL vartyp(d$, typ%): CALL brackets(d$)
        prtf$ = atyp$(typ% - 10) + d$ + ";"
        CALL varpost(prtf$)
        PRINT #2, "static " + prtf$
        tmpfl% = 1
       NEXT i%
      END IF
      IF chartfl% = 1 THEN
       PRINT #2, "static char   w__S[16][LMAX];"
       PRINT #2, "static int    j__S = 0, j__Stmp;"
       tmpfl% = 1
      END IF
      IF inttfl% = 1 THEN
       PRINT #2, "static int    w__s[16];"
       PRINT #2, "static int    i__s = 0, i__stmp;"
       tmpfl% = 1
      END IF
      IF longtfl% = 1 THEN
       PRINT #2, "static long   w__l[16];"
       PRINT #2, "static int    i__l = 0, i__ltmp;"
       tmpfl% = 1
      END IF
      IF floattfl% = 1 THEN
       PRINT #2, "static float  w__f[16];"
       PRINT #2, "static int    i__f = 0, i__ftmp;"
       tmpfl% = 1
      END IF
      IF vdblff% = 1 THEN
       PRINT #2, "static double w__d[16];"
       PRINT #2, "static int    i__d = 0, i__dtmp;"
       tmpfl% = 1
      END IF
      IF byttfl% = 1 THEN
       PRINT #2, "static unsigned char w__b[16];"
       PRINT #2, "static int    i__b = 0, i__btmp;"
       tmpfl% = 1
      END IF
      IF sigiff% = 1 THEN
       PRINT #2, "static int  sig__i[16];"
       PRINT #2, "static int  j__sig = 0;"
       tmpfl% = 1
      END IF
      IF twsflg% = 1 THEN tmpfl% = 1: PRINT #2, "static char tws__S[LMAX];"
      IF nSHRDtk% > 0 THEN
       int$ = " int  ": float$ = " float "
       IF longflg% = 1 THEN int$ = " long "
       IF doblflg% = 1 THEN float$ = " double "
       IF sint$ <> "" THEN CALL declarix(int$, sint$, 3): tmpfl% = 1
       IF srea$ <> "" THEN CALL declarix(float$, srea$, 0): tmpfl% = 1
       IF ssss$ <> "" THEN CALL declarix(" char ", ssss$, 1): tmpfl% = 1
       IF slin$ <> "" THEN CALL declarix(" long ", slin$, 4): tmpfl% = 1
       IF sdbl$ <> "" THEN CALL declarix(" double ", sdbl$, 0): tmpfl% = 1
      END IF
      PRINT #2,
      PRINT #2, "/* Open files pointers */"
      IF nopen% > 0 THEN PRINT #2, "FILE " + fff$ + ";": tmpfl% = 1
      IF tmpfl% = 1 THEN PRINT #2,
     RETURN



45000 REM Adding pointer prefixes '*' to variables in SUBs (postprocess)
      REM except in FUNCTIONs
      REM Also handles Labels to override HP compiler problem
      REM Must be done *before* 40000 post.
      REM Does not change comment lines ????
      REM writes out initializations in MAIN that appear after declarations
      isub% = 0: lbfl% = 0: nl% = 0: tmpfl% = 0
      OPEN outf$ FOR INPUT AS #2
      OPEN tmpfile$ FOR OUTPUT AS #3
      DO WHILE NOT EOF(2)
       LINE INPUT #2, line$: nl% = nl% + 1
       IF tmpfl% = 1 THEN 45010
       GOSUB 45050: IF lbfl% = 1 THEN 45011
       lleng% = LEN(line$): togfl% = 0
       IF lleng% <= 2 THEN GOTO 45010
       b$ = LEFT$(line$, 18)
       IF b$ = "/*- User SUBs--End" THEN tmpfl% = 1: GOTO 45010
       IF b$ = "/*- User SUB--Star" THEN
        isub% = isub% + 1
        PRINT #3, line$: LINE INPUT #2, line$: PRINT #3, line$
        GOTO 45015
       END IF
       IF funcfl%(isub%) = 1 THEN 45010
       IF isub% > 0 THEN
REM     Processing will pass here only for all non-empty lines within a SUB
C       if (cflag_int==1 && strncmp(line_S,"C ",2)==0) goto Lab_45010;
        IF nsubvar%(isub%) > 0 THEN
         FOR i% = 1 TO nsubvar%(isub%)
          z$ = subvar$(isub%, i%)
          CALL vartyp(z$, typ%): IF typ% = 5 OR typ% = 15 THEN GOTO 45005
          j% = 0: lz% = LEN(z$): togfl% = 0: flag% = 0
          leng% = LEN(line$): g% = 0
45001     flag% = 0
          DO WHILE (NOT flag%) AND j% <= leng%
C          if (line_S[j_int] == '"') togfl_int = 1 - togfl_int;
C          if (!togfl_int) {
C           if (memcmp(&line_S[j_int], "/* ", 3) == 0) flag_int=1;
C           if (memcmp(&line_S[j_int], z_S, lz_int) == 0) flag_int = 2;
C          }
           j% = j% + 1
          LOOP
          IF flag% = 1 THEN GOTO 45005
          IF flag% = 2 THEN
C          c = line_S[j_int + lz_int - 1];
           if (c==' ' || c==',' || c==')' || c==';' || c==']') {
            IF j% > 1 THEN g% = ASC(MID$(line$, j% - 1, 1))
            IF j% = 1 OR NOT (g% > 96 AND g% < 123 OR g% > 64 AND g% < 91) THEN
             line$ = LEFT$(line$, j% - 1) + "*" + MID$(line$, j%)
             leng% = 1 + leng%: j% = j% + lz%
            END IF
C          }
          END IF
          j% = j% + 1
          IF j% < leng% THEN GOTO 45001
45005    NEXT i%
        END IF
       END IF
45010  PRINT #3, line$
45011  IF nl% = initline% THEN
        IF inkeyff% = 1 AND tflg% = 0 THEN PRINT #3, " keybd__init();"
       END IF
45015 LOOP
      CLOSE #3
      CLOSE #2
      SHELL "mv -f " + tmpfile$ + " " + outf$
      RETURN

45050 
C     if (memcmp(line_S, "Lab_", 4) == 0)
C     {
       lbfl% = 1
       e$ = line$
C     }
C     else
C     {
       IF lbfl% = 1 THEN
        t$ = line$: CALL gulix(t$)
C       if (memcmp(t_S, "/*", 2) == 0) goto Lab_45051;
C       if (t_S[0] == '}')
C       {
C        c=0;
C        while (e_S[c] != ':' && c <= strlen(e_S)) c++;
C        strcpy(tws__S, e_S); tws__S[c+1] = ';';
C        strcpy(&tws__S[c+2], &e_S[c+1]); strcpy(e_S, tws__S);
C       }
        PRINT #3, e$
        lbfl% = 0
       END IF
C     }
45051 RETURN


50000 REM COMMAND$ line tokenization and options handling
      REM -i or -int => implicit integers i*,j*,k*,l*,m*,n* or upper case
      REM -d or -double => all floats -> double
      REM -c64 or -C64 => C-64 specific syntax, switches on -b flag also
      REM -p or -post => do not perform postprocessing varnames
      REM -l or -long => all integers (except short)-> long
      REM -b or -bcpp => insensitive to case & spacing in QBASIC text
      REM -a or -ansi => OBSOLETE and NOT USED
      REM -c or -C    => allows C text lines commented with 'C '
      REM -m or -M    => disallow logical expr. in math. expression
      REM -t or -T    => INKEY_S is dead (<termios.h> etc. not specified)      
      REM -n or -N    => To supress SHELL command interpreter: all cmds literal
      REM -u          => Do not update SCREEN after every LINE, PSET, etc.
      REM -s          => Strip type sufixes from variable and function names
      REM -D          => implicit doubles d*, D*
      REM -r          => integer fractions became double: '/' -> '/ (double)'
      REM -v          => print version and exit
       intflg% = 0: c64flg% = 0: postflg% = 1: longflg% = 0: cflag% = 0
       Dflg% = 0: doblflg% = 0: bcppflg% = 0: ansiflg% = 0: mflg% = 1: rflag%=0
       tflg% = 0: noshell% = 0: updateff% = 1: stripff% = 0: REM default flags
       leng% = LEN(c$): nctok% = 0: i% = 1
       FOR k% = 1 TO 12
         DO WHILE MID$(c$, i%, 1) = " " AND i% <= leng%
          i% = i% + 1
         LOOP
         j% = i% + 1
         DO WHILE MID$(c$, j%, 1) <> " " AND j% <= leng%
          j% = j% + 1
         LOOP
         ctok$(k%) = MID$(c$, i%, j% - i%)
         IF ctok$(k%) = "" THEN GOTO 50005
         i% = j% + 1
       NEXT k%
50005  nctok% = k% - 1: j% = 0
       FOR i% = 1 TO nctok%
        d$ = ctok$(i%)
        IF d$ = "-v" OR d$ = "-V" THEN EPRINT "Version: "; Version$: END
        IF d$ = "-i" OR d$ = "-int" THEN
         intflg% = 1
        ELSE
         IF d$ = "-C64" OR d$ = "-c64" THEN
          c64flg% = 1: bcppflg% = 1
         ELSE
          IF d$ = "-p" OR d$ = "-post" THEN
           postflg% = 0
          ELSE
           IF d$ = "-l" OR d$ = "-long" THEN
            longflg% = 1
           ELSE
            IF d$ = "-d" OR d$ = "-double" THEN
             doblflg% = 1
            ELSE
             IF d$ = "-b" OR d$ = "-bcpp" THEN
              bcppflg% = 1
             ELSE
              IF d$ = "-a" OR d$ = "-ansi" THEN
               ansiflg% = 1
              ELSE
               IF d$ = "-c" OR d$ = "-C" THEN
                cflag% = 1
               ELSE
                IF d$ = "-m" OR d$ = "-M" THEN
                 mflg% = 0
                ELSE
                 IF d$ = "-t" OR d$ = "-T" THEN
                  tflg% = 1
                 ELSE
                  IF d$ = "-n" OR d$ = "-N" THEN
                   noshell% = 1
                  ELSE
                   IF d$ = "-u" THEN
                    updateff% = 0
                   ELSE
                    IF d$ = "-s" THEN
                     stripff% = 1
                    ELSE
                     IF d$ = "-D" THEN
                      Dflg% = 1
                     ELSE
                      IF d$ = "-r" THEN
                       rflag% = 1
                      ELSE
                       IF MID$(d$, 1, 1) = "-" THEN
                        PRINT "qb2c: Unrecognized option, ignored: "; d$
                       ELSE
                        j% = j% + 1
                        ctok$(j%) = d$
                       END IF
                      END IF
                     END IF
                    END IF
                   END IF
                  END IF
                 END IF
                END IF
               END IF
              END IF
             END IF
            END IF
           END IF
          END IF
         END IF
        END IF
       NEXT i%
       nctok% = j%
       IF nctok% = 0 OR nctok% > 2 THEN
        PRINT "Usage: qb2c [-option [...]] input_file[.bas] [output_file]"
C       exit(1);
       ELSE
        inpf$ = ctok$(1)
        IF nctok% >= 1 THEN
         b$ = inpf$
         IF LEN(inpf$) > 4 THEN
          IF RIGHT$(inpf$, 4) = ".bas" THEN
           b$ = LEFT$(inpf$, LEN(inpf$) - 4)
          END IF
         END IF
         inpf$ = b$ + ".bas"
         outf$ = b$ + ".c"
        END IF
        IF nctok% = 2 THEN
         outf$ = ctok$(2)
        END IF
       END IF
       PRINT "qb2c: translating  "; inpf$ + "  -->  "; outf$
       IF bcppflg% = 1 THEN
        z$ = ""
        IF c64flg% = 1 THEN z$ = z$ + " -C64"
        IF cflag% = 1 THEN z$ = z$ + " -C"
        IF rflag% = 1 THEN z$ = z$ + " -r"
        SHELL "bcpp" + z$ + " -q " + inpf$
        inpf$ = b$ + ".bcp"
        bcp$ = inpf$
       END IF
       RETURN

9999 REM End Main
     REM Cleanup
     IF bcppflg% = 1 THEN SHELL "del " + bcp$
     PRINT "Translation done in"; TIMER - tttt; "sec."
     END

SUB arraydim (h$)
SHARED tmp$()
REM  Translates array dimensions from QB to C standard (partly, see 800)
REM  h$ mora biti 'oguljen' (gulix)
     i% = 1
C    while (h_S[i_int] != '(') i_int++;
     b$ = MID$(h$, i% + 2, LEN(h$) - i% - 2)
     CALL tokenix(b$, ntok%, ",", "")
     d$ = ""
     FOR itok% = 1 TO ntok%
      j& = VAL(tmp$(itok%))
      IF j& > 0 THEN
       e$ = STR$(j& + 1)
       d$ = d$ + RIGHT$(e$, LEN(e$) - 1) + ", "
      ELSE
       d$ = d$ + tmp$(itok%) + "+1, "
      END IF
     NEXT itok%
     h$ = LEFT$(h$, i% + 1) + LEFT$(d$, LEN(d$) - 2) + ")"
END SUB

SUB brackets (h$)
SHARED tmp$()
C   char b, c;
REM Converts array brackets from QB to C standard in DIM statement
REM Eg. a(10) -> a[10], b(10, 15) -> b[10][15]
REM Assumes that the last char is ")" eg. xxxx(...)
    i% = 1
C   while (h_S[i_int] != '(') i_int++;
C   b=h_S[i_int-1];
    a$ = MID$(h$, i% + 2, LEN(h$) - i% - 2): CALL tokenix(a$, n%, ",", "")
    h$ = LEFT$(h$, i%)
C   c = 0;
    FOR i% = 1 TO n%
C    if(tmp_S[i_int][0]=='|') 
C    { c = 1; }
C    else
C    {
      h$ = h$ + "[" + tmp$(i%) + "]"
C    }
    NEXT i%
C   if (b=='$')
C   { 
C    if (!c)
C    { strcat(h_S, "[LMAX]"); }
C    else
C    { strcat(h_S, "["); strcat(h_S, &tmp_S[n_int][1]); strcat(h_S, "]"); }
C   }
END SUB

SUB declarix (typ$, varlist$, dn%)
SHARED tmp$(), isub%, ni%, spc$, statfl%()
REM Declares variables (+ splits long lines with splitdec)
REM Variable names ran through varpost() name postprocessor
    CALL splitdec(varlist$, ntok%, dn%)
    FOR i% = 1 TO ntok%
     prtf$ = tmp$(i%)
     CALL varpost(prtf$)
     IF statfl%(isub%) = 1 THEN
      PRINT #2, spc$ + "static" + typ$ + prtf$ + ";"
     ELSE
      PRINT #2, spc$ + typ$ + prtf$ + ";"
     END IF
     IF isub% = 0 THEN ni% = ni% + 1
    NEXT i%
END SUB

SUB gulix (h$)
REM Strip off leading and trailing spaces
  leng% = LEN(h$)
  IF leng% <> 0 THEN
   i% = 0
C  while(h_S[i_int] == ' ' && i_int < leng_int) ++i_int;
   IF i% = leng% THEN h$ = "": GOTO 99
   j% = leng% - 1
C  while(h_S[j_int] == ' ' && j_int > 0) --j_int;
C  memmove(h_S,&h_S[i_int],(leng_int=j_int-i_int+1)); h_S[leng_int]='\0';
  END IF
99
END SUB

SUB inputfmt (list$, formt$, prt$, ntok%, flag%)
SHARED tmp$(), nl%
REM Solves argument lists in "INPUT #" and "INPUT" input statements
REM 'list$' is the input list and is not changed.
REM 'formt$' is format string and 'prt$' is complete argument list
REM to sscanf at the output.
       formt$ = "": prt$ = "": ltyp% = 0
       CALL tokenix(list$, ntok%, ",", ";")
       IF ntok% = 1 THEN
        b$ = tmp$(1): CALL vartyp(b$, typ%)
        IF typ% = 5 OR typ% = 15 THEN
         prt$ = list$: ntok% = -1
         GOTO 315
        END IF
       END IF
       FOR i% = 1 TO ntok%
        b$ = tmp$(i%): CALL vartyp(b$, typ%)
        IF typ% = 0 THEN PRINT "qb2c: inputfmt: Error in input format of "; b$; "in line No"; nl%
        IF typ% > 10 THEN typ% = typ% - 10
        IF typ% <= 2 THEN
         z$ = "%d"
        ELSE
         IF typ% = 3 THEN
          z$ = "%f"
         ELSE
          IF typ% = 4 THEN
           z$ = "%le"
          ELSE
           IF typ% = 5 THEN
            z$ = "%s"
           ELSE
            PRINT "qb2c: inputfmt: Error in input format of "; b$; "in line No"; nl%
           END IF
          END IF
         END IF
        END IF
        IF flag% = 1 THEN
          formt$ = formt$ + " ," + z$
        ELSE
         formt$ = formt$ + "  " + z$
        END IF
        IF typ% <> 5 THEN
         prt$ = prt$ + ",&" + b$
        ELSE
         prt$ = prt$ + "," + b$
        END IF
        ltyp% = typ%
       NEXT i%
       formt$ = MID$(formt$, 3)
315
END SUB

SUB logix (h$)
REM Handles logical expressions
C char c, k, flagc, flagk, a3_S[4];
 leng% = LEN(h$)
 i% = 1
 DO WHILE i% <= leng%
C strncpy(a3_S, &h_S[i_int-1], 3); a3_S[3]='\0';
C if (a3_S[0] == '=') {
   IF MID$(h$, i% - 1, 1) <> " " THEN 115
   CALL sparser(h$, i%, "="): REM String logical expression handler
   leng% = LEN(h$)
   GOTO 115
C }
C if (memcmp(a3_S, "<>", 2) == 0) {
   CALL sparser(h$, i%, "<>"): REM String logical expression handler
   leng% = LEN(h$)
   GOTO 115
C }
C c = ' '; if (i_int > 1) c = tolower(h_S[i_int-2]);
C if (c<'a' || c>'z') { flagc = 1; } else { flagc = 0; }
C k = ' '; if (i_int+1 < leng_int) k = tolower(h_S[i_int+1]);
C if (k<'a' || k>'z') { flagk = 1; } else { flagk = 0; }
C if ( memcmp(a3_S, "OR", 2) == 0 && flagc && flagk) {
   h$ = MID$(h$, 1, i% - 1) + "||" + MID$(h$, i% + 2, leng% - i% - 1)
   leng% = LEN(h$)
   i% = i% + 1
   GOTO 115
C }
C k = ' '; if (i_int+2 < leng_int) k = tolower(h_S[i_int+2]);
C if (k<'a' || k>'z') { flagk = 1; } else { flagk = 0; }
C if ( memcmp(a3_S, "AND", 3) == 0 && flagc && flagk) {
   h$ = MID$(h$, 1, i% - 1) + "&&" + MID$(h$, i% + 3, leng% - i% - 1)
   leng% = leng% - 1
   i% = i% + 1
   GOTO 115
C }
C if ( memcmp(a3_S, "NOT", 3) == 0 && flagc && flagk) {
   h$ = MID$(h$, 1, i% - 1) + "!" + MID$(h$, i% + 3, leng% - i% - 1)
   leng% = leng% - 2
   GOTO 115
C }
C if ( memcmp(a3_S, "EOF", 3) == 0 && flagc && flagk) {
   j% = i% + 4
   DO WHILE MID$(h$, j%, 1) <> ")" AND j% < leng%
    j% = j% + 1
   LOOP
   z$ = MID$(h$, i% + 4, j% - i% - 4): CALL gulix(z$)
   h$ = MID$(h$, 1, i% - 1) + "eof(fp_" + z$ + MID$(h$, j%, leng% - j% + 1)
   leng% = LEN(h$)
   GOTO 115
C }
115 i% = i% + 1
 LOOP
END SUB

SUB mathexp (h$)
SHARED mathfl%, mflg%, expflg%, extrnfl%
C   char d;
REM Translates mathematical and logical expressions, including math. functions:
REM ^ -> pow(,), MOD

    h$ = " " + h$: leng% = LEN(h$)
    i% = 1: togfl% = 0
    DO WHILE i% <= leng%
C    d = h_S[i_int-1];
C    if (d == 34) togfl_int = 1 - togfl_int;
     IF togfl% = 1 THEN GOTO 114
C    if (d == '!') h_S[i_int-1] = '.';
     IF i% > leng% - 2 THEN GOTO 114
C    if (h_S[i_int-1] == '^')
C    {
      CALL sparser(h$, i%, "^"): REM Finds left and right operands in binary ops.
      leng% = LEN(h$): REM      Caution both h$ and i% are changed
      mathfl% = 1
      GOTO 114
C    }
C    if (memcmp(&h_S[i_int-1], " MOD ", 5)==0) {
      i% = 1 + i%
      CALL sparser(h$, i%, "MOD")
      GOTO 114
C    }
114  i% = i% + 1
     LOOP
     h$ = MID$(h$, 2)
     IF mflg% = 1 AND expflg% = 1 THEN
      i% = 1: leng% = LEN(h$)
C     while (h_S[i_int-1] != '=' && i_int != leng_int) i_int++;     
      IF i% = leng% THEN
       CALL logix(h$)
      ELSE
       b$ = MID$(h$, i% + 2)
       CALL logix(b$)
       h$ = LEFT$(h$, i% + 1) + b$
      END IF
     END IF
END SUB

SUB printfmt (h$, formt$, prt$, nflag%)
SHARED tmp$(), isub%, vdblff%, nptk%, extrnfl%
REM Solves argument lists in "PRINT #" and "PRINT" output statements
REM 'h$' is the input expression and is not changed.
REM 'formt$' is format string and 'prt$' is complete argument list
REM to sprintf or printf at the output.
C char b;
       REM tokenizacija list varijabli itd. => formt$
       nflag% = 1: prt$ = "": zarfl% = 0: tzarfl% = 0
       IF RIGHT$(h$, 1) = ";" THEN
        nflag% = 0
       END IF
       IF nflag% = 1 THEN h$ = h$ + ";"
       leng% = LEN(h$): togfl% = 0: brfl% = 0: i% = 1: j% = 1: formt$ = ""
       DO WHILE j% <= leng%
C       b = h_S[j_int - 1];
C       if (b == 34) togfl_int = 1 - togfl_int;
        IF togfl% = 0 THEN
C        if (b == '(') brfl_int++;
C        if (b == ')') brfl_int--;
        END IF
C       if (!togfl_int && !brfl_int && (b == ';' || b == ',')) {
C        zarfl_int = 0; if (b == ',') zarfl_int = 1;
C        tzarfl_int = 0; if (b == ';') tzarfl_int = 1;
         d$ = MID$(h$, i%, j% - i%): CALL gulix(d$)
         CALL vartyp(d$, typ%)
         IF typ% = 1 OR typ% = 2 OR typ% = 8 OR typ% = 10 OR typ% = 11 OR typ% = 12 THEN
          z$ = "% d"
          IF zarfl% = 1 THEN z$ = " %-14d"
          IF tzarfl% = 1 THEN z$ = "% d "
          formt$ = formt$ + z$
          GOTO 195
         END IF
         IF typ% <> 5 AND typ% <> 7 AND typ% <> 15 THEN
          IF zarfl% = 1 THEN 
           z$ = " %-14G"
          ELSE
           IF typ% = 14 THEN
            z$ = "% .16G"
            IF tzarfl% = 1 THEN z$ = "% .16G "
           ELSE
            z$ = "% .7G"
            IF tzarfl% = 1 THEN z$ = "% .7G "
           END IF
          END IF
          formt$ = formt$ + z$
          IF typ% = 6 OR 11 <= typ% AND typ% <= 14 THEN
           CALL mathexp(d$)
           IF typ% <= 12 THEN
            d$ = "DBL(" + d$ + ")"
            vdblff% = 1: extrnfl% = 1
           END IF
          ELSE
           IF typ% = 20 THEN
            d$ = "DBL(" + d$ + ")"
            vdblff% = 1: extrnfl% = 1
           END IF
          END IF
         ELSE
          z$ = "%s": IF zarfl% = 1 THEN z$ = "%-14s"
          IF typ% = 7 THEN
           CALL tokenix(d$, nptk%, "+", "")
           d$ = ""
           FOR g% = 1 TO nptk%
            IF isub% = 0 THEN
             IF tmp$(g%) = "COMMAND$" THEN tmp$(g%) = "COMMAND$(n__arg, argv)"
            END IF
            d$ = d$ + tmp$(g%) + ","
            formt$ = formt$ + "%s"
           NEXT g%
           d$ = LEFT$(d$, LEN(d$) - 1)
          ELSE
           IF isub% = 0 THEN
            IF d$ = "COMMAND$" THEN d$ = "COMMAND$(n__arg, argv)"
           END IF
           formt$ = formt$ + z$
          END IF
         END IF
195      prt$ = prt$ + "," + d$
         i% = j% + 1
C       }
        j% = j% + 1
       LOOP
END SUB

SUB qbfdecl
SHARED spacff%, midff%, leftff%, rightff%, strff%, chrff%, ascff%, valff%
SHARED lenff%, sgnff%, intff%, nintff%, eofff%, commff%, vdblff%, rndff%
SHARED srndff%, timerff%, dateff%, timeff%, inkeyff%, inputff%, colorff%
SHARED clsff%

  IF spacff% = 1 THEN PRINT #2, "extern char  *SPACE_S(int);"
  IF midff% = 1 THEN PRINT #2, "extern char  *MID_S(char *, int, int);"
  IF leftff% = 1 THEN PRINT #2, "extern char  *LEFT_S(char *, int);"
  IF rightff% = 1 THEN PRINT #2, "extern char  *RIGHT_S(char *, int);"
  IF strff% = 1 THEN PRINT #2, "extern char  *STR_S(double);"
  IF chrff% = 1 THEN PRINT #2, "extern char  *CHR_S(int);"
  IF ascff% = 1 THEN PRINT #2, "extern long   ASC(char *);"
  IF valff% = 1 THEN PRINT #2, "extern double VAL(char *);"
  IF lenff% = 1 THEN PRINT #2, "extern int    LEN(char *);"
  IF sgnff% = 1 THEN PRINT #2, "extern double SGN(double);"
  IF intff% = 1 THEN PRINT #2, "extern long   Int(double);"
  IF nintff% = 1 THEN PRINT #2, "extern long   Nint(double);"
  IF eofff% = 1 THEN PRINT #2, "extern int    eof(FILE *);"
  IF commff% = 1 THEN PRINT #2, "extern char  *COMMAND_S(int, char *argv[]);"
  IF rndff% = 1 THEN PRINT #2, "extern double  RND(double);"
  IF srndff% = 1 THEN PRINT #2, "extern void    RANDOMIZE(long);"
  IF timerff% = 1 THEN PRINT #2, "extern float  TIMER(void);"
  IF vdblff% = 1 THEN PRINT #2, "extern double DBL(double);"
  IF dateff% = 1 THEN PRINT #2, "extern char  *DATE_S(int);"
  IF timeff% = 1 THEN PRINT #2, "extern char  *TIME_S(int);"
  IF inkeyff% = 1 THEN PRINT #2, "extern char  *INKEY_S(void);"
  IF inputff% = 1 THEN PRINT #2, "extern char  *INPUT(const char*, int);"
  IF colorff% = 1 THEN PRINT #2, "extern int    COLOR(int fg, int bg);"
  IF clsff% = 1 THEN PRINT #2, "extern int    CLS(int n_int);"
END SUB

SUB qbfunc
SHARED spacff%, midff%, leftff%, rightff%, strff%, chrff%, ascff%, valff%
SHARED lenff%, sgnff%, intff%, nintff%, eofff%, commff%, vdblff%, rndff%
SHARED srndff%, timerff%, dateff%, timeff%, inkeyff%, inputff%, tflg%
SHARED colorff%, clsff%, existff%

  d$ = CHR$(34): REM Quotes
  IF spacff% = 1 THEN
   REM  Calls: SPACE_S(j), SPACE_S(2)
   PRINT #2,
   PRINT #2, "extern char *SPACE_S(int n)"
   PRINT #2, "{"
   PRINT #2, " int i;"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " if (n < 0) n = 0;"
   PRINT #2, " strcpy(w__S[j__S]," + CHR$(34) + CHR$(34) + ");"
   PRINT #2, " for(i = 1; i <= n; i++)"
   PRINT #2, " {"
   PRINT #2, "  strcat(w__S[j__S]," + d$ + " " + d$ + ");"
   PRINT #2, " }"
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF midff% = 1 THEN
   REM  Calls: eg. MID_S(a_S,2,j)
   PRINT #2,
   PRINT #2, "extern char *MID_S(char *a_S, int start, int length)"
   PRINT #2, "{"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " if(length < 0) { "
   PRINT #2, "  printf(" + CHR$(34) + "Error: in MID_S: length < 0\n" + CHR$(34) + ");"
   PRINT #2, "  exit(0); }"
   PRINT #2, " if(start  < 0) {"
   PRINT #2, "  printf(" + CHR$(34) + "Error: in MID_S: start < 1\n" + CHR$(34) + ");"
   PRINT #2, "  exit(0); }"
   PRINT #2, " if(start > strlen(a_S)) "
   PRINT #2, " { w__S[j__S][0]='\0'; }"
   PRINT #2, " else"
   PRINT #2, " { strncpy(w__S[j__S], &a_S[start-1], length);"
   PRINT #2, "   w__S[j__S][length]='\0'; }"
   PRINT #2,
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF leftff% = 1 THEN
   REM Calls:  LEFT_S(a_S,j), LEFT_S(a_S,3)
   PRINT #2,
   PRINT #2, "extern char *LEFT_S(char *a_S, int length)"
   PRINT #2, "{"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " if(length < 0) { "
   PRINT #2, "  printf(" + CHR$(34) + "Error: in LEFT_S: length < 0\n" + CHR$(34) + ");"
   PRINT #2, "  exit(0); }"
   PRINT #2, " strncpy(w__S[j__S], a_S, length);"
   PRINT #2, " w__S[j__S][length]='\0';"
   PRINT #2,
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF rightff% = 1 THEN
   REM Calls:  RIGHT_S(a_S,j), RIGHT_S(a_S,3)
   PRINT #2,
   PRINT #2, "extern char *RIGHT_S(char *a_S, int length)"
   PRINT #2, "{"
   PRINT #2, " int  start;"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " if ((start = strlen(a_S) - length) < 0) start = 0;"
   PRINT #2, " if (length < 0) {"
   PRINT #2, "  printf(" + CHR$(34) + "Error: in RIGHT_S: length < 0\n" + CHR$(34) + ");"
   PRINT #2, "  exit(0); }"
   PRINT #2, " strncpy(w__S[j__S], &a_S[start], length);"
   PRINT #2, " w__S[j__S][length]='\0';"
   PRINT #2,
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF strff% = 1 THEN
   REM Calls: STR_S(j), STR_S(123.5)
   PRINT #2,
   PRINT #2, "extern char *STR_S(double d)"
   PRINT #2, "{"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " sprintf(w__S[j__S]," + d$ + "% G" + d$ + ",d);"
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF chrff% = 1 THEN
   REM Calls: CHR_S(j), CHR_S(65)
   PRINT #2,
   PRINT #2, "extern char *CHR_S(int i)"
   PRINT #2, "{"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " w__S[j__S][0]=i;"
   PRINT #2, " w__S[j__S][1]='\0';"
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF ascff% = 1 THEN
   REM Calls: i=ASC(a_S), i=ASC("ABCD")
   PRINT #2,
   PRINT #2, "extern long ASC(char *c_S)"
   PRINT #2, "{"
   PRINT #2, " if (++i__l == 16) i__l=0;"
   PRINT #2, " if((w__l[i__l]=c_S[0]) < 0) w__l[i__l]=256+w__l[i__l];" 
   PRINT #2, " return w__l[i__l];"
   PRINT #2, "}"
  END IF
  IF valff% = 1 THEN
   REM  Calls: VAL(a_S), VAL("1234.5abcd")
   PRINT #2,
   PRINT #2, "extern double VAL(char *a_S)"
   PRINT #2, "{"
   PRINT #2, " if (++i__d == 16) i__d = 0;"
   PRINT #2, " w__d[i__d] = atof(a_S);"
   PRINT #2, " return w__d[i__d];"
   PRINT #2, "}"
  END IF
  IF lenff% = 1 THEN
   REM  Calls: LEN(a_S), LEN("1234.5abcd")
   PRINT #2,
   PRINT #2, "extern int LEN(char *a_S)"
   PRINT #2, "{"
   PRINT #2, " if (++i__d == 16) i__d = 0;"
   PRINT #2, " w__d[i__d] = strlen(a_S);"
   PRINT #2, " return w__d[i__d];"
   PRINT #2, "}"
  END IF
  IF sgnff% = 1 THEN
   REM  Calls: SGN(x), SGN(-123.4)
   PRINT #2,
   PRINT #2, "extern double SGN(double x)"
   PRINT #2, "{"
   PRINT #2, " if (++i__d == 16) i__d = 0;"
   PRINT #2, " if(x == (double) 0) {"
   PRINT #2, "  w__d[i__d] = 0.; }"
   PRINT #2, " else {"
   PRINT #2, "  w__d[i__d] = x / fabs(x); }"
   PRINT #2, " return w__d[i__d];"
   PRINT #2, "}"
  END IF
  IF intff% = 1 THEN
   REM  Calls: Int(x), Int(-123.4)
   PRINT #2,
   PRINT #2, "extern long Int(double x)"
   PRINT #2, "{"
   PRINT #2, " return floor(x);"
   PRINT #2, "}"
  END IF
  IF nintff% = 1 THEN
   REM  Calls: Nint(x), Nint(-123.4)
   PRINT #2,
   PRINT #2, "extern long Nint(double x)"
   PRINT #2, "{"
   PRINT #2, " return floor(0.5 + x); "
   PRINT #2, "}"
  END IF
  IF eofff% = 1 THEN
   REM  Calls:  while ( ! eof(fp_n) )
   PRINT #2,
   PRINT #2, "extern int eof(FILE *stream)"
   PRINT #2, "{"
   PRINT #2, " static int c, istat;"
   PRINT #2,
   PRINT #2, " istat=((c=fgetc(stream))==EOF);"
   PRINT #2, " ungetc(c,stream);"
   PRINT #2, " return istat; "
   PRINT #2, "}"
  END IF
  IF commff% = 1 THEN
   REM  Calls:  COMMAND_S(n__arg, argv);
   PRINT #2,
   PRINT #2, "extern char *COMMAND_S(int n__arg, char *argv[])"
   PRINT #2, "{"
   PRINT #2, " int i;"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " for(i = 1; i < n__arg; i++)"
   PRINT #2, " {"
   PRINT #2, "  strcat(w__S[j__S],argv[i]);"
   PRINT #2, "  strcat(w__S[j__S]," + d$ + " " + d$ + ");"
   PRINT #2, " }"
   PRINT #2, " w__S[j__S][strlen(w__S[j__S])-1]='\0';"
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF vdblff% = 1 THEN
   REM  Calls: DBL(num_expression)
   PRINT #2,
   PRINT #2, "extern double DBL(double d)"
   PRINT #2, "{"
   PRINT #2, " if (++i__d == 16) i__d = 0;"
   PRINT #2, " w__d[i__d] = d;"
   PRINT #2, " return w__d[i__d];"
   PRINT #2, "}"
  END IF
  IF rndff% = 1 THEN
   REM  Calls: RND(num_expression)
   PRINT #2,
   PRINT #2, "extern double RND(double d)"
   PRINT #2, "{"
   PRINT #2, " static double y;"
   PRINT #2,
   PRINT #2, " if(d == 0) {"
   PRINT #2, "  return y;"
   PRINT #2, " }"
   PRINT #2, " else {"
   PRINT #2, "  return (y = rand()/((double) RAND_MAX));"
   PRINT #2, " }"
   PRINT #2, "}"
  END IF
  IF srndff% = 1 THEN
   REM  Calls: RANDOMIZE(num_expression)
   PRINT #2,
   PRINT #2, "extern void RANDOMIZE(long n)"
   PRINT #2, "{"
   PRINT #2, " srand(n % 65536);"
   PRINT #2, "}"
  END IF
  IF timerff% = 1 THEN
   REM  Calls: x = TIMER()
   PRINT #2,
   PRINT #2, "extern float TIMER()"
   PRINT #2, "{"
   PRINT #2, " time_t etime;"
   PRINT #2, " char w_S[12];"
   PRINT #2,
   PRINT #2, " time(&etime);"
   PRINT #2, " strftime(w_S,10," + d$ + "%S:%M:%H" + d$ + ",localtime(&etime));"
   PRINT #2, " return (atof(&w_S[0])+60*(atof(&w_S[3])+60*atof(&w_S[6])));"
   PRINT #2, "}"
  END IF
  IF dateff% = 1 THEN
   REM  Calls: a_S = DATE_S[(i)]
   PRINT #2,
   PRINT #2, "extern char *DATE_S(int i)"
   PRINT #2, "{"
   PRINT #2, " static struct tm *tp;"
   PRINT #2, " long elapse_time;"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " time(&elapse_time);"
   PRINT #2, " tp=localtime(&elapse_time);"
   PRINT #2, " switch (i) {"
   PRINT #2, "  case 1:  strftime(w__S[j__S],LMAX," + d$ + "%d.%m.%Y" + d$ + ",tp);"
   PRINT #2, "  break;"
   PRINT #2, "  case 2:  strftime(w__S[j__S],LMAX," + d$ + "%d/%m/%Y" + d$ + ",tp);"
   PRINT #2, "  break;"
   PRINT #2, "  case 3:  strftime(w__S[j__S],LMAX," + d$ + "%d-%b-%Y" + d$ + ",tp);"
   PRINT #2, "  break;"
   PRINT #2, "  case 4:  strcpy(w__S[j__S],asctime(tp));"
   PRINT #2, "           w__S[j__S][strlen(w__S[j__S])-1]='\0';"
   PRINT #2, "  break;"
   PRINT #2, "  default: strftime(w__S[j__S],LMAX," + d$ + "%m-%d-%Y" + d$ + ",tp);"
   PRINT #2, "  break;"
   PRINT #2, " }"
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF timeff% = 1 THEN
   REM  Calls: a_S = TIME_S[(i)]
   PRINT #2,
   PRINT #2, "extern char *TIME_S(int i)"
   PRINT #2, "{"
   PRINT #2, " static struct tm *tp;"
   PRINT #2, " long elapse_time;"
   PRINT #2,
   PRINT #2, " if (++j__S == 16) j__S=0;"
   PRINT #2, " time(&elapse_time);"
   PRINT #2, " tp=localtime(&elapse_time);"
   PRINT #2, " strftime(w__S[j__S],LMAX," + d$ + "%H:%M:%S" + d$ + ",tp);"
   PRINT #2, " return w__S[j__S];"
   PRINT #2, "}"
  END IF
  IF inkeyff% = 1 AND tflg% = 0 THEN
   REM  Calls:  INKEY_S()
   PRINT #2,
   PRINT #2, "extern char  *INKEY_S(void)"
   PRINT #2, "{"
   PRINT #2, " int  i, len;"
   PRINT #2, " static char b[33];"
   PRINT #2,
   PRINT #2, " input_mode();"
   PRINT #2, " while((len=read(0,b,32)) < 1);"
   PRINT #2, " b[len]='\0';"
   PRINT #2, " system_mode();"
   PRINT #2, " if(b[0] == 3) exit(0);"
   PRINT #2, " i = 1;"
   PRINT #2, " while (b[i] != 27 && b[i] != '\0' && i < len) i++;"
   PRINT #2, " if (b[i] == 27) len = i;"
   PRINT #2, " b[len]='\0';"
   PRINT #2, " for(i = 0; i <= 21; i++)"
   PRINT #2, " if(memcmp(b, keyb__S[i], len) == 0) return (keyq__S[i]);"
   PRINT #2,
   PRINT #2, " return (b);"
   PRINT #2, "}"
   PRINT #2,
   PRINT #2, "int system_mode(void)"
   PRINT #2, "{"
   PRINT #2, "    if (ioctl(0, TCSETA, &term_orig) == -1) {"
   PRINT #2, "        return (0);"
   PRINT #2, "    }"
   PRINT #2, "    fcntl(0, F_SETFL, kbdflgs);"
   PRINT #2, "}"
   PRINT #2,
   PRINT #2, "int input_mode(void)"
   PRINT #2, "{"
   PRINT #2, "    static struct termio term;"
   PRINT #2, "    static int flags;"
   PRINT #2,
   PRINT #2, "    if (ioctl(0, TCGETA, &term) == -1) {"
   PRINT #2, "        return (-1);"
   PRINT #2, "    }"
   PRINT #2, "    (void) ioctl(0, TCGETA, &term_orig);"
   PRINT #2, "    term.c_iflag = 0;"
   PRINT #2, "    term.c_oflag = 0;"
   PRINT #2, "    term.c_lflag = 0;"
   PRINT #2, "    term.c_cc[VMIN] = 1;"
   PRINT #2, "    term.c_cc[VTIME] = 0;"
   PRINT #2, "    if (ioctl(0, TCSETA, &term) == -1) {"
   PRINT #2, "        return (-1);"
   PRINT #2, "    }"
   PRINT #2, "    kbdflgs = fcntl(0, F_GETFL, 0);"
   PRINT #2, "    flags = fcntl(0, F_GETFL);"
   PRINT #2, "    flags &= ~O_NDELAY;"
   PRINT #2, "    fcntl(0, F_SETFL, flags);"
   PRINT #2, "    return (0);"
   PRINT #2, "}"
   PRINT #2,
   PRINT #2, "int keybd__init(void)"
   PRINT #2, "{"
   PRINT #2, " FILE *filep;"
   PRINT #2, " int i;"
   PRINT #2, " char w_S[LMAX];"
   PRINT #2,
   PRINT #2, " strcpy(w_S,getenv(" + d$ + "HOME" + d$ + "));"
   PRINT #2, " strcat(w_S," + d$ + "/.kbcalib" + d$ + ");"
   PRINT #2, " if((filep=fopen(w_S, " + d$ + "r" + d$ + ")) == NULL)"
   PRINT #2, " { printf(" + d$ + "Cant open file %s ! No default !\n" + d$ + ", w_S);"
   PRINT #2, "   return -1; }"
   PRINT #2, " for(i = 0; i <= 21; i++) {"
   PRINT #2, "  fgets(keyb__S[i], 8, filep);"
   PRINT #2, "  keyb__S[i][strlen(keyb__S[i])-1]='\0';"
   PRINT #2, "  keyq__S[i][0]=1; }"
   PRINT #2, " for(i = 0; i <= 9; i++) {"
   PRINT #2, "  keyq__S[i][1]=59+i; }"
   PRINT #2, " keyq__S[10][1]=133; keyq__S[11][1]=134; keyq__S[12][1]=82;"
   PRINT #2, " keyq__S[13][1]=71;  keyq__S[14][1]=73;  keyq__S[15][1]=83;"
   PRINT #2, " keyq__S[16][1]=79;  keyq__S[17][1]=81;  keyq__S[18][1]=72;"
   PRINT #2, " keyq__S[19][1]=75;  keyq__S[20][1]=80;  keyq__S[21][1]=77;"
   PRINT #2, " return fclose(filep);"
   PRINT #2, "}"
  END IF
  IF inputff% = 1 THEN
   REM  Calls: a_S = INPUT("Prompt...",0)
   PRINT #2,
   PRINT #2, "extern char *INPUT(const char *a_S, int i)"
   PRINT #2, "{"
   PRINT #2, " if(i == 0) printf(" + d$ + "%s" + d$ + ",a_S);"
   PRINT #2, " if(i == 1) printf(" + d$ + "%s? " + d$ + ",a_S);"
   PRINT #2, " fgets(tws__S,255,stdin);"
   PRINT #2, " tws__S[strlen(tws__S)-1]='\0';"
   PRINT #2, " return tws__S;"
   PRINT #2, "}"
  END IF
  IF colorff% = 1 THEN
   REM  Calls: COLOR((int) fg, (int) bg)
   PRINT #2,
   PRINT #2, "extern int COLOR(int fg, int bg)"
   PRINT #2, "{"
   PRINT #2, " int col, att;" 
   PRINT #2, " char a_S[32];"
   PRINT #2, " if (bg>=0) { printf(" + d$ + "\033[0;%dm" + d$ + ",40+(bg % 8));}"
   PRINT #2, " else { printf(" + d$ + "\033[0m" + d$ + ");}"
   PRINT #2, " fg = fg % 32;"
   PRINT #2, " if (fg <= 7) { printf(" + d$ + "\033[%dm" + d$ + ",30+fg); }"
   PRINT #2, " if ( 7 < fg && fg <= 15) { printf(" + d$ + "\033[1;%dm" + d$ + ",22+fg); }"
   PRINT #2, " if (15 < fg && fg <= 23) { printf(" + d$ + "\033[5;%dm" + d$ + ",14+fg); }"
   PRINT #2, " if (23 < fg) { printf(" + d$ + "\033[1;5;%dm" + d$ + ",6+fg); }"
   PRINT #2, "}"
  END IF
  IF clsff% = 1 THEN
   REM  Calls: CLS((int) n_int) 
   PRINT #2,
   PRINT #2, "extern int CLS(int n)"
   PRINT #2, "{"
   PRINT #2, " int i;"
   PRINT #2, " if (n == 0) printf(" + d$ + "\033[2J\033[H" + d$ + ");"
   PRINT #2, " if (n == 2) 
   PRINT #2, " { printf(" + d$ + "\033[H" + d$ + ");" 
   PRINT #2, "   for (i=1; i<=24; i++) printf(" + d$ + "\033[%d;0;f\033[K" + d$ + ",i);"
   PRINT #2, " }"
   PRINT #2, "}"
  END IF
  IF existff% = 1 THEN
   REM  Calls: EXISTS( file$ ) 
   PRINT #2,
   PRINT #2, "extern int EXISTS(char *file_S)"
   PRINT #2, "{"
   PRINT #2, " if(fopen(file_S, " + d$ + "r" + d$ + ") == NULL) return 0;"
   PRINT #2, " return 1;"
   PRINT #2, "}"
  END IF

END SUB

SUB quadrix (h$)
SHARED atmp$(), natmp%
REM Converts brackets in used arrays to square brackets.
REM Input string h$ is changed at the exit.
175   REM changes Array variable brackets from QB to C convention
      REM 31000 must be called before, once per SUB (or MAIN)
      REM hmm.... SUB and SHARED must be executed before; most of the others after
      REM Improved - it will not change exp( if an array xp( is declared !
      h$ = " " + h$
      i% = 1: togfl% = 0: c% = 0: L% = 0: g% = 0
C     while (i_int < strlen(h_S))
C     { 
C      if (h_S[i_int-1] == 34) togfl_int=1-togfl_int;
C      if ((c_int=h_S[i_int-1]) == '(' && togfl_int == 0)
C      {
        FOR j% = 1 TO natmp%
         z$ = atmp$(j%)
C        L_int = strlen(z_S);
         IF i% > L% THEN
          k% = i% - L% + 1
          IF MID$(h$, k%, L%) = z$ THEN
C          g_int=0; if(k_int >= 2) g_int = h_S[k_int - 2];
           IF NOT (g% > 96 AND g% < 123 OR g% > 64 AND g% < 91) THEN GOSUB 176
          END IF
         END IF
        NEXT j%
C      }
C      ++i_int;
C     }
      CALL gulix(h$)
      EXIT SUB

176   REM Ugradnja kvadratnih zagrada u polja u izrazima (ne u DIM)
      REM Ulaz: h$, i%, Izlaz: izmijenjena linija h$ i (eventualno) novi i%
      h$ = LEFT$(h$, i% - 1) + "[" + MID$(h$, i% + 1)
      g% = i% + 1: brfl% = 1: e$ = MID$(h$, g%, 1)
      DO WHILE brfl% <> 0
       IF e$ = "," THEN
        h$ = LEFT$(h$, g% - 1) + "][" + MID$(h$, g% + 2)
        g% = g% + 2
       END IF
       g% = g% + 1
       e$ = MID$(h$, g%, 1)
       IF e$ = "(" THEN brfl% = brfl% + 1
       IF e$ = ")" THEN brfl% = brfl% - 1
      LOOP
      h$ = LEFT$(h$, g% - 1) + "]" + MID$(h$, g% + 1)
      RETURN
END SUB

SUB sparser (h$, z%, bin$)
C char c;
SHARED nl%
REM finds left and right operands of binary operation 'bin$':
REM eg. (a + b) ^ ((a - 1) * 2)
REM On input z% is the position where the leftmost character of operator
REM appears in h$. Both h$ and z% are changed at the exit, according to bin$.

     L$ = "": R$ = "": prt$ = "": leng% = LEN(h$): olen% = LEN(bin$)
REM Left:
     i% = z% - 1: bcnt% = 0: togfl% = 0: REM Bracket & quotes counters
     DO WHILE MID$(h$, i%, 1) = " " AND i% >= 1
      i% = i% - 1
     LOOP
     IF i% <= 0 THEN
      PRINT "ERROR in parsing math expression: "; h$; " in line No"; nl%
C     exit(1);
     END IF
     j% = i%
C    c = h_S[j_int-1]; 
C    if (c == '"') togfl_int = 1 - togfl_int;
C    if (c == ')' && togfl_int == 0) bcnt_int++;
C    while ((!(c==' ' && bcnt_int==0 || c=='(' && bcnt_int<0) || togfl_int==1) && j_int<=leng_int) {
      j% = j% - 1: IF j% = 0 THEN GOTO 197
C     c = h_S[j_int-1];
C     if (c == '"') togfl_int = 1 - togfl_int;
      IF togfl% = 0 THEN
C      if (c == ')') bcnt_int++;
C      if (c == '(') bcnt_int--;
      END IF
C    }
197  L$ = MID$(h$, j% + 1, i% - j%): j0% = j%
REM Right:
     i% = z% + olen%: bcnt% = 0: : togfl% = 0: REM Bracket & quotes counters
     DO WHILE MID$(h$, i%, 1) = " " AND i% < leng%
      i% = i% + 1
     LOOP
     j% = i%
C    c = h_S[j_int-1];
C    if (c == '"') togfl_int = 1 - togfl_int;
C    if (c == '(') bcnt_int++;
C    while ((!(c==' ' && bcnt_int==0 || c==')' && bcnt_int<0) || togfl_int==1) && j_int<=leng_int) {
      j% = j% + 1
C     c = h_S[j_int-1];
C     if (c == '"') togfl_int = 1 - togfl_int;
      IF togfl% = 0 THEN
C      if (c == '(') bcnt_int++;
C      if (c == ')') bcnt_int--;
      END IF
C    }
     R$ = MID$(h$, i%, j% - i%): j1% = j%

REM
     REM math ^
     IF bin$ = "^" THEN
      prt$ = "pow(" + L$ + "," + R$ + ")"
      h$ = LEFT$(h$, j0%) + prt$ + RIGHT$(h$, leng% - j1% + 1)
      z% = j0% + LEN(prt$)
      GOTO 199
     END IF

     REM logical =
     IF bin$ = "=" THEN
      CALL vartyp(L$, typ%)
      IF typ% = 7 THEN
       PRINT "ERROR in line No"; nl%
       PRINT "string expressions not (yet) allowed in logical: " + h$
C      exit(1);
      END IF
      IF typ% = 5 OR typ% = 15 THEN
       h$ = LEFT$(h$, j0%) + "strcmp(" + L$ + ", " + R$ + ") == 0" + RIGHT$(h$, leng% - j1% + 1)
       z% = z% + 14 + LEN(R$)
      ELSE
       h$ = LEFT$(h$, z% - 1) + "==" + RIGHT$(h$, leng% - z%)
       z% = z% + 1
      END IF
      GOTO 199
     END IF

     REM logical <>
     IF bin$ = "<>" THEN
      CALL vartyp(L$, typ%)
      IF typ% = 7 THEN
       PRINT "ERROR in line No"; nl%
       PRINT "string expressions not (yet) allowed in logical: " + h$
C      exit(1);
      END IF
      IF typ% = 5 OR typ% = 15 THEN
       h$ = LEFT$(h$, j0%) + "strcmp(" + L$ + ", " + R$ + ") != 0" + RIGHT$(h$, leng% - j1% + 1)
       z% = z% + 14 + LEN(R$)
      ELSE
       h$ = LEFT$(h$, z% - 1) + "!=" + RIGHT$(h$, leng% - z% - 1)
       z% = z% + 1
      END IF
      GOTO 199
     END IF
 
     IF bin$ = "MOD" THEN
      prt$ = "((int)(.5+" + L$ + ")) % ((int)(.5+" + R$ + "))"
      h$ = LEFT$(h$, j0%) + prt$ + RIGHT$(h$, leng% - j1% + 1)
      z% = j0% + LEN(prt$)
      GOTO 199
     END IF

199 REM End sparser
END SUB

SUB splitdec (varlist$, ntok%, dn%)
SHARED tmp$()
REM Split too long declaration lines into pieces not longer than maxl% chars
REM Declaration lines are strings of tokens delimited by ","
    maxl% = 64: i% = 1: ntok% = 0: dn% = dn% + 2
    IF LEN(varlist$) > maxl% THEN
     CALL tokenix(varlist$, n%, ",", "")
119  b$ = "": lb% = dn%
     DO WHILE lb% + LEN(tmp$(i%)) <= maxl% AND i% <= n%
      b$ = b$ + ", " + tmp$(i%)
      lb% = lb% + LEN(tmp$(i%)) + dn%
      i% = i% + 1
     LOOP
     ntok% = ntok% + 1
     tmp$(ntok%) = MID$(b$, 3, LEN(b$) - 2)
     IF i% <= n% THEN GOTO 119
    ELSE
     ntok% = 1
     tmp$(1) = varlist$
    END IF
END SUB

SUB stringx (h$)
REM String constants pretprocessor "...\.." --> "...\\..."
REM Called from the following processors/translators:
REM DO WHILE, WHILE, IF.., PRINT, PRINT #, INPUT, exp
     i% = 1: togfl% = 0: leng% = LEN(h$)
     DO WHILE i% <= leng% - 1
      b$ = MID$(h$, i%, 1)
      IF ASC(b$) = 34 THEN
       togfl% = 1 - togfl%
       GOTO 191
      END IF
      IF b$ = "\" THEN
       h$ = LEFT$(h$, i%) + "\" + RIGHT$(h$, leng% - i%)
       leng% = 1 + leng%: i% = 1 + i%
      END IF
191  i% = 1 + i%
     LOOP
END SUB

SUB tokenix (h$, ntok%, sep$, sep2$)
SHARED tmp$()
C     char b;
REM   Tokenizes h$ with respect to separators sep$, sep2$.
REM   Returns list of ntok% bare (gulix !) tokens in tmp$(), h$ unchanged.
      ntok% = 0: brfl% = 0: togfl% = 0: z$ = h$ + sep$: leng% = LEN(z$): b$ = ""
      IF h$ = "" THEN GOTO 169
      i% = 0: j% = 1
C     while (i_int < leng_int)
C     {
C      b = z_S[i_int];
C      if (b == 34) { togfl_int = 1 - togfl_int; goto Lab_168; }
C      if (! togfl_int)
C      {
C       if (b == '(') { brfl_int++; goto Lab_168; }
C       if (b == ')') { brfl_int--; goto Lab_168; }
C      }
C      if((b==sep_S[0] || b==sep2_S[0]) && !brfl_int && !togfl_int)
C      {
        IF i% + 1 - j% > 0 THEN
         b$ = MID$(z$, j%, i% + 1 - j%): CALL gulix(b$)
         ntok% = ntok% + 1: tmp$(ntok%) = b$
         IF ntok% > TMAX THEN
          PRINT "qb2c: tokenix: Dimension of tmp$() too small. Enlarge TMAX and recompile qb2c!"
C         exit(1);
         END IF
        END IF
        j% = i% + 2
C      }
168    i% = i% + 1
C     }
169 REM
END SUB

SUB varpost (line$)
SHARED stripff%
C  char b_S[10], b, c, t;
REM (post)processing i% -> i_int, i& -> i_long, c$ -> c_S
REM and array brackets (except in declarations which is done).
REM Also handles MID$(a$,i%) -> MID_S(a_S,i_int,LMAX)
REM This works a line at the time: line$ is input and output
C      t = 32;
       lleng% = LEN(line$)
       i% = 1: togfl% = 0: tmpfl% = 0
       DO WHILE i% <= lleng%
        z$ = MID$(line$, i%, 2)
C       b = line_S[i_int-1];
C       if (b == 34) togfl_int = 1 - togfl_int;
        IF togfl% = 0 THEN
C        if (strncmp(&line_S[i_int-1],"/*",2)==0) { tmpfl_int=1; goto Lab_205;}
C        if (strncmp(&line_S[i_int-1],"*/",2)==0) { tmpfl_int=0; goto Lab_205;}
        END IF
        IF togfl% = 0 AND tmpfl% = 0 THEN
C        if (b=='$')
C        {
C         if (i_int >= 4)
C         {
           IF MID$(line$, i% - 3, 4) = "MID$" THEN
            g% = i% + 2: brcnt% = 1
C           while (brcnt_int > 0)
C           {
C            c = line_S[g_int];
C            g_int++;
C            if (c == '(') brcnt_int++;
C            if (c == ')') brcnt_int--;
C           }
            d$ = MID$(line$, i% + 2, g% - i% - 2)
            CALL tokenix(d$, n%, ",", "")
            IF n% = 2 THEN
             line$ = LEFT$(line$, i% - 1) + "_S(" + d$ + ", LMAX" + MID$(line$, g%)
             lleng% = lleng% + 7: i% = i% + 1: GOTO 205
            ELSE
             line$ = LEFT$(line$, i% - 1) + "_S" + MID$(line$, i% + 1)
             lleng% = lleng% + 1: i% = i% + 1: GOTO 205
            END IF
           ELSE
            line$ = LEFT$(line$, i% - 1) + "_S" + MID$(line$, i% + 1)
            lleng% = lleng% + 1: i% = i% + 1: GOTO 205
           END IF
C         }
C         else
C         {
           line$ = LEFT$(line$, i% - 1) + "_S" + MID$(line$, i% + 1)
           lleng% = lleng% + 1: i% = i% + 1: GOTO 205
C         }
C        }
C        if( 95<=t && t<=122 || 65<=t && t<=90 || 48<=t && t<=57)
C        {
C         if (b=='%')
C         {
C          b_S[0]='\0'; c=-1; if(stripff_int==0) {strcpy(b_S,"_int"); c=3;}
C          line_S[i_int-1]='\0'; strcpy(tws__S, line_S); strcat(tws__S, b_S); 
C          strcat(tws__S, &line_S[i_int]); strcpy(line_S, tws__S);
C          lleng_int = lleng_int + c; i_int = i_int + c;
           GOTO 205
C         }
C         else
C         {
C          if ( b=='&' )
C          {
C           b_S[0]='\0'; c=-1; if(stripff_int==0) {strcpy(b_S,"_long"); c=4;}
            line$ = LEFT$(line$, i% - 1) + b$ + MID$(line$, i% + 1)
C           lleng_int = lleng_int + c; i_int = i_int + c;
            GOTO 205
C          }
C          else
C          {
C           if ( b=='#' )
C           {
C            b_S[0]='\0'; c=-1; if(stripff_int==0) {strcpy(b_S,"_double"); c=6;}
             line$ = LEFT$(line$, i% - 1) + b$ + MID$(line$, i% + 1)
C            lleng_int = lleng_int + c; i_int = i_int + c;
             GOTO 205
C           }
C           else
C           {
C            if ( b=='?' )
C            {
C             b_S[0]='\0'; c=-1; if(stripff_int==0) {strcpy(b_S,"_byte"); c=4;}
              line$ = LEFT$(line$, i% - 1) + b$ + MID$(line$, i% + 1)
C             lleng_int = lleng_int + c; i_int = i_int + c;
              GOTO 205
C            }
C           }
C          }
C         }
C        }
        END IF
205     
C      t = b; i_int++;
       LOOP
END SUB

SUB vartyp (tok$, ttyp%)
SHARED intflg%, Dflg%, doblflg%, longflg%, constfl%, tcnst$(), ncnst%
C  static char cx, b;
REM Determins the type 'ttyp%' of the token being variable or array:
REM Takes into account 'intflg%' and 'longflg%' flags.
REM Constants (eg 321.) are either typ%=2 (no decimal dot) or typ%=4.
REM constfl% = 1 => it is a constant of a given type.
REM ttyp% = 0 => undecided.
REM tok$ must be ran through 'gulix'.
REM         1 => int
REM         2 => long
REM         3 => float
REM         4 => double
REM         5 => string
REM         6 => numerical expression
REM         7 => string expression
REM         8 => byte (unsigned char)
REM        10 => array of short int (2 byte) or function
REM        11 => array of int     or function
REM        12 => array of long    or function
REM        13 => array of float   or function
REM        14 => array of double  or function
REM        15 => array of strings or function
REM        18 => array of bytes (unsigned chars)
REM        20 => declared CONSTant number
REM        25 => declared CONSTant string  NOT YET
REM
REM variable types when intflg% or Dflg% flag set
REM -i: i,j,k,l,m,n  (upper or lower case, if not $) are implicit 'int' type
REM -d: d (upper or lower case, if not $) are implicit 'double' type
REM sorting variable types (default):
    ttyp% = 0: constfl% = 0: ad% = 0: leng% = LEN(tok$)
    ilog% = 0: jlog% = 0: REM For -c or -d flags set
    IF leng% = 0 THEN GOTO 149
    FOR i% = 1 TO ncnst%
     IF tok$ = tcnst$(i%) THEN ttyp% = 20: GOTO 149
    NEXT i%
    REM Test for expression:
     expf% = 0: strf% = 0: brfl% = 0: togfl% = 0
     IF leng% = 1 THEN 147
     FOR i% = 1 TO leng%
C     cx = tok_S[i_int - 1];
C     if (cx == 34) togfl_int = 1 - togfl_int;
      IF togfl% = 0 THEN
C      if ( cx == '(' ) brfl_int = brfl_int + 1;
C      if ( cx == ')' ) brfl_int = brfl_int - 1;
      END IF
      IF brfl% = 0 AND togfl% = 0 THEN
C      if (cx == '$') strf_int = 1;
C      if ( cx == 34 ) { strf_int = 1; constfl_int = 1; }
C      if ( cx == 32 ) expf_int =1;
C      if ( cx == '+') expf_int =1;
      END IF
     NEXT i%
    IF expf% = 1 AND strf% = 0 THEN ttyp% = 6: GOTO 149
    IF expf% = 1 AND strf% = 1 THEN ttyp% = 7: GOTO 149
147 IF VAL(tok$) <> 0 OR LEFT$(tok$, 1) = "0" THEN
     constfl% = 1: i% = 1
C    cx = tok_S[0];
C    while ( cx != '.' && cx != '!' && i_int < leng_int )
C    {
C     i_int++;
C     cx = tok_S[i_int - 1];
C    }
C    if (cx == '.') 
C    {
C      *ttyp_int = 3;
C    }
C    else
C    {
C     if (cx == '!')
C     {
C      *ttyp_int = 3;
C      tok_S[i_int - 1] = '.';
C     }
C     else
C     {
C      *ttyp_int = 1;
C     }
C    }
     GOTO 149
    END IF
146 
C   cx = tok_S[leng_int-1];
C   if (cx == ')')
C   {
     i% = 1: ad% = 10
C    while (tok_S[i_int] != '(') i_int++;
C    cx = tok_S[i_int - 1];
C   }
    IF intflg% = 1 THEN
C    b = tok_S[0];
C    if((b >= 105 && b <= 110 || b >= 73 && b <= 78) && cx != '&' && cx != '$')
C    {
      ilog% = 1
C    }
    END IF
    IF Dflg% = 1 THEN
C    if (tok_S[0] == 68 || tok_S[0] == 100)
C    {
      jlog% = 1
C    }
    END IF
C   if (cx == '%' || ilog_int == 1)
C   {
     ttyp% = 1
C    if (ad_int == 10 && i_int >= 2 && tok_S[i_int-2] == '_') *ttyp_int = 0;
C   }
C   else
C   {
C    if (cx == '$' || cx == 34)
C    {
      ttyp% = 5
C    }
C    else
C    {
C     if (cx == '&')
C     {
       ttyp% = 2
C     }
C     else
C     {
C      if (cx == '?')
C      {
        ttyp% = 8
C      }
C      else
C      {
C       if (cx == '#' || jlog_int == 1)
C       {
         ttyp% = 4
C       }
C       else
C       {
         ttyp% = 3
C       }
C      }
C     }
C    }
C   }
REM
    ttyp% = ttyp% + ad%
    IF ttyp% = 13 THEN
C    if (strncmp(tok_S,"LEN(",4)==0 || strncmp(tok_S,"ASC(",4)==0 || strncmp(tok_S,"EOF(",4)==0) *ttyp_int=11; 
C    if (strncmp(tok_S,"Int(",4)==0 || strncmp(tok_S,"Nint(",5)==0) *ttyp_int=12; 
    END IF
    IF ttyp% = 3 THEN
REM  IF tok$ = "TIMER" THEN ttyp% = 13: Sredjeno u 650
     IF tok$ = "RND" THEN ttyp% = 14
    END IF
    IF longflg% = 1 THEN
C    switch(*ttyp_int) {
C         case  1: *ttyp_int = 2;
C                  break;
C         case 11: *ttyp_int =12;
C                  break;
C    }
    END IF
    IF doblflg% = 1 THEN
C    switch(*ttyp_int) {
C         case  3: *ttyp_int = 4;
C                  break;
C         case 13: *ttyp_int =14;
C                  break;
C    }
    END IF
149 REM End vartyp
END SUB
