/* This will do inclusions of modules into my source code.
   It is a replacement for EPP.

   I probably allocated a whole bunch of stuff I didn't need to
   but this was really just an experiment.

   Started:  July 26, 1993
   Version:  1
   Revision: 0

   © 1993, Kevin Connell, All Rights Reserved
*/

/* OPT OSVERSION=37 */

DEF source[255]:STRING,object[255]:STRING,
    strip_src[255]:STRING,root[255]:STRING
DEF outfiles[10]:LIST

PROC main()
  getargs()
  openall(strip_src)                      /* open all output files      */
  include(source)                         /* do the inclusion           */
  closeall()                              /* close all the output files */
  merge(strip_src)
  clean(strip_src)
ENDPROC

PROC openall(names)
  StrCopy(root,names,ALL)
  WriteF(' ** Opening output files for << \s >>\n',names)
  StringF(object,'\s\s',root,'_bod.e') ; outfiles[0]:=Open(object,NEWFILE)
  StringF(object,'\s\s',root,'_mod.e') ; outfiles[1]:=Open(object,NEWFILE)
  StringF(object,'\s\s',root,'_def.e') ; outfiles[2]:=Open(object,NEWFILE)
  StringF(object,'\s\s',root,'_con.e') ; outfiles[3]:=Open(object,NEWFILE)
  StringF(object,'\s\s',root,'_set.e') ; outfiles[4]:=Open(object,NEWFILE)
  StringF(object,'\s\s',root,'_enu.e') ; outfiles[5]:=Open(object,NEWFILE)
  StringF(object,'\s\s',root,'_opt.e') ; outfiles[6]:=Open(object,NEWFILE)
ENDPROC

PROC closeall()
  DEF i
  WriteF(' ** Closing output files\n')
  FOR i:=0 TO 6
    IF outfiles[i] THEN Close(outfiles[i])
  ENDFOR
ENDPROC

PROC merge(names)
  DEF final[255]:STRING, passit[255]:STRING
  DEF i, j, bool
  StrCopy(root,names,ALL)
  WriteF(' ** Merging Included Files\n')
  StringF(object,'\s\s',root,'_mod.e') ; outfiles[0]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_def.e') ; outfiles[1]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_con.e') ; outfiles[2]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_set.e') ; outfiles[3]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_enu.e') ; outfiles[4]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_bod.e') ; outfiles[5]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_opt.e') ; outfiles[6]:=Open(object,OLDFILE)
  StringF(object,'\s\s',root,'_inc.e') ; final      :=Open(object,NEWFILE)
  j:=1
  FOR i:=0 TO 6
    REPEAT
      bool:=ReadStr(outfiles[i],passit)
      Write(final,passit,StrLen(passit))
      Write(final,'\n',STRLEN)
      WriteF('\c\b',ListItem(["|","/","-","\\"],j))
      IF j=5 THEN j:=1 ELSE j++
    UNTIL bool = -1
  ENDFOR
  closeall()
  IF final THEN Close(final)
  StringF(object,'\s\s',root,'_inc.e') ; outfiles[1]:=Open(object,OLDFILE)
  StrCopy(root,source,StrLen(source)-2)
  StringF(object,'\s\s',root,'_inc.e') ; final      :=Open(object,NEWFILE)
  REPEAT
    bool:=ReadStr(outfiles[1],passit)
    Write(final,passit,StrLen(passit))
    Write(final,'\n',STRLEN)
  UNTIL bool = -1
  IF outfiles[1] THEN Close(outfiles[1])
  IF final       THEN Close(final)
ENDPROC

PROC clean(names)
  StrCopy(root,names,ALL)
  WriteF(' ** Cleaning Up...\n')
  StringF(object,'\s\s',root,'_bod.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_mod.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_def.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_con.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_set.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_enu.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_opt.e') ; DeleteFile(object)
  StringF(object,'\s\s',root,'_inc.e') ; DeleteFile(object)
ENDPROC

PROC include(infile)
  DEF inhand, bool, begin, end, currout, global
  DEF checkline[255]:STRING,incfile[255]:STRING
  global:=TRUE
  IF FileLength(infile)=-1
    DisplayBeep(0)
    WriteF(' !! Could Not Find \s!\n',infile)
    WriteF(' !! Not Including file\n')
    RETURN
   ENDIF
  WriteF(' ** Found Source File: <<\s>>\n',infile)
  inhand:=Open(infile,OLDFILE)
  currout:=0
  REPEAT
    bool:=ReadStr(inhand,checkline) /* ; currout:=0 */
    IF global
      IF InStr(checkline,'MODULE',0)=0 THEN currout:=1
      IF InStr(checkline,'DEF',0)=0    THEN currout:=2
      IF InStr(checkline,'CONST',0)=0  THEN currout:=3
      IF InStr(checkline,'SET',0)=0    THEN currout:=4
      IF InStr(checkline,'ENUM',0)=0   THEN currout:=5
      IF InStr(checkline,'OPT',0)=0    THEN currout:=6
      IF InStr(checkline,'PROC',0)=0
        global:=FALSE
        currout:=0
       ENDIF
     ENDIF
    IF InStr(checkline,'INCLUDE',0)
      IF InStr(checkline,'PROC main()',0)=FALSE
        IF StrCmp(infile,source,ALL)=FALSE
          REPEAT
            ReadStr(inhand,checkline)
          UNTIL (InStr(checkline,'ENDPROC',0)=0)
          StrCopy(checkline,' ',ALL)
        ENDIF
      ENDIF
      IF StrLen(checkline) > 0
        Write(outfiles[currout],checkline,StrLen(checkline))
        Write(outfiles[currout],'\n',STRLEN)
      ENDIF
    ELSE
      Write(outfiles[0],'\n/* *** Including File: ',STRLEN)
      begin:=InStr(checkline,'"',0)
      end:=InStr(checkline,'"',begin+2)
      MidStr(incfile,checkline,begin+1,(end-begin)-1)
      Write(outfiles[0],incfile,StrLen(incfile))
      Write(outfiles[0],' *** */ \n\n',STRLEN)
      include(incfile)
      Write(outfiles[0],'\n/* *** End Including File: ',STRLEN)
      Write(outfiles[0],incfile,StrLen(incfile))
      Write(outfiles[0],' *** */ \n\n',STRLEN)
    ENDIF
  UNTIL bool = -1
  Close(inhand)
ENDPROC

PROC getargs()
  DEF path
  path:=0
  StrCopy(source,arg,StrLen(arg))
  IF Val(arg,NIL)
     WriteF('Usage: Include <sourcecodefile>\n')
     CleanUp(5)
   ENDIF
  IF InStr(source,' ',0) > -1
    StrCopy(source,source,InStr(source,' ',0))
   ENDIF
  IF InStr(source,'.e',StrLen(source)-3) = -1
    StrAdd(source,'.e',2)
   ENDIF
  StrCopy(strip_src,source,ALL)
  IF InStr(strip_src,':',0) > -1  /* Strips off the device part of the name */
    MidStr(strip_src,strip_src,InStr(strip_src,':',0)+1,StrLen(strip_src)-InStr(strip_src,':',0))
  ENDIF
  REPEAT
    path:=InStr(strip_src,'/',path)
    MidStr(strip_src,strip_src,InStr(strip_src,'/',0)+1,StrLen(strip_src)-InStr(strip_src,'/',0))
    IF CtrlC() THEN CleanUp(5)
   UNTIL path = -1
   StringF(strip_src,'t:\s',strip_src)
   SetStr(strip_src,StrLen(strip_src)-2)
ENDPROC
