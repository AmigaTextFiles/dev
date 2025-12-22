
/*************************************************************
*                                                            *
*     10mins - © 14-Mar-1995 by Maik "Blizzer" Schreiber     *
*     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯     *
*  Version 1.1          Source for AmigaE          FREEWARE  *
*                                                            *
*                                                            *
*  SnailMail: Maik Schreiber                                 *
*             Ruschvitzstraße 19                             *
*             D-18528 Bergen                                 *
*             FR Germany                                     *
*                                                            *
*  EMail    : blizzer@freeway.shnet.org                      *
*             blizzer@empire.insider.sub.de                  *
*                                                            *
*************************************************************/

/*
** Usage:
** ¯¯¯¯¯¯
** 10mins -t <text file> [-v60] [-s <seconds>] [-o <output>] [-nb]
**_____________________________________________________________________________
**
** History:
** ¯¯¯¯¯¯¯¯
** - 1.0, 10-Mar-1995:
**   - intial version of 10mins (Source for AmigaE)
**
** - 1.1, 14-Mar-1995:
**   - now only runs under OS2.04 or higher
**   - new parameters "TEXT=-t/A", "VBF60=-v60/S", "SECS=-s/N", "OUTPUT=-o" and
**     "NOBEEP=-nb/S"
*/


MODULE 'utility'


ENUM ARG_TEXT,ARG_VBF60,ARG_SECS,ARG_OUTPUT,ARG_NOBEEP,
     NUMARGS

ENUM ER_NONE,ER_UTIL,ER_BADARGS,ER_TEXT,ER_OUTPUT


DEF secs=600,beepf=TRUE,vbf=50,output,text

DEF infile=NIL,rawwin=NIL,line[256]:STRING,eof,dummy,rdargs=NIL,
    args[NUMARGS]:LIST


PROC main() HANDLE
  IF KickVersion(37)=FALSE
    WriteF('Requires OS2.04 (V37) or higher !!\n')
    CleanUp(20)
  ENDIF

  IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTIL)
  FOR dummy:=0 TO NUMARGS-1 DO args[dummy]:=0
  rdargs:=ReadArgs('TEXT=-t/A,VBF60=-v60/S,SECS=-s/N,OUTPUT=-o,NOBEEP=-nb/S',args,NIL)
  IF rdargs=NIL THEN Raise(ER_BADARGS)

  output:='RAW:0/203/640/53/Reminder/NOSIZE'
  IF args[ARG_TEXT] THEN text:=args[ARG_TEXT]
  IF args[ARG_VBF60] THEN vbf:=60
  IF args[ARG_SECS] THEN secs:=Long(args[ARG_SECS])
  IF args[ARG_OUTPUT] THEN output:=args[ARG_OUTPUT]
  IF args[ARG_NOBEEP] THEN beepf:=FALSE

  IF (infile:=Open(text,OLDFILE))=NIL THEN Raise(ER_TEXT)

  IF (rawwin:=Open(output,NEWFILE))=NIL THEN Raise(ER_OUTPUT)
  SetStdOut(rawwin)
  stdout:=rawwin

  WriteF('\c0 p\n',155)
  IF beepf THEN WriteF('\c',7)
  REPEAT
    eof:=ReadStr(infile,line)
    WriteF(line)
    Out(rawwin,10)
  UNTIL eof

  FOR dummy:=0 TO (secs-1)

    /* English should use this ..
    */
    WriteF('\e[3;32m\d secs left (<Ctrl c> exits) .. \c',secs-dummy,13)

    /* .. and Germans this (remove the /* */ stuff !)
    */
/*  WriteF('\e[3;32mNoch \d sec (<Ctrl c> bricht ab) .. \c',secs-dummy,13) */

    Delay(vbf)
    IF CtrlC() THEN dummy:=secs
  ENDFOR
  Raise(ER_NONE)
EXCEPT
  IF rawwin THEN Close(rawwin)
  IF infile THEN Close(infile)
  IF rdargs THEN FreeArgs(rdargs)
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
    CASE ER_UTIL;    WriteF('Couldn''t open utility.library 37 !!\n')
    CASE ER_BADARGS; WriteF('Bad args !!\n')
    CASE ER_TEXT;    WriteF('Couldn''t open text file ''\s'' !!\n',text)
    CASE ER_OUTPUT;  WriteF('Couldn''t open output ''\s'' !!\n',output)
  ENDSELECT
  CleanUp(0)
ENDPROC


CHAR '$VER: 10mins 1.1 (14-Mar-1995) © by Maik "Blizzer" Schreiber [FREEWARE]'

