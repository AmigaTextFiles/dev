/* Name : fd2module
** Version : v1.1
** Authors : original programming by Alex McCracken
**           modified on 11.11.96 by Dominique Dutoit (ddutoit@arcadis.be)
**
** Comments from Alex :
** This program is heavily based on Wouter van Oortmerssen's pragma2module.
** In fact about 90% of the code belongs to Wouter, so I claim no credit for
** this. However, since Wouter's praga2module works very well for files in
** the correct format, I must state that if this fails it is most probably my
** fault.  You may use this program as you see fit, however should it fail and
** eat your dog, cause your telly to explode, or cause any problems
** what-so-ever, I will not be held responsible.  In other word use this at
** your own risk.  I have made every effort to ensure it works, but I cannot
** guarantee to have found all the niggly little ones that plauge almost all
** programs.
**
** Comments from Dom:
** - "_lib.fd" is gone away forever, really usefull with Opus5.
** - fd2module is also able to find the library name by himself if the lib name
**   is in the first comment of the fd file.
**
** Usage :
** The program in invoked by typing (CLI only):
**     fd2module <libname>
**
** where libname is the name of the fd file. (no more _lib.fd)
** This will produce a file <libname>.m .  At the moment the program echos the
** fd file as it reads it, but this may change in a future release.  You will
** need to give the program the name of the library explicitly, again this may
** change.
**
** Distribution:
** Public domain, you can modify and distribute the codes again and again.
*/

/* FD2Module
**   convert a library fd file to an E module.
**   Usage: fd2module <file>
**   converts <file.fd> to <file.m>
*/
   
ENUM INPUT_ERROR=10,OUTPUT_ERROR,FORMAT_ERROR

DEF cfh,efh,eof,done,
    gotbase=FALSE,
    gotlibname=FALSE,
    public=TRUE,
    offset=30,
    cfile[200]:STRING,
    efile[200]:STRING,
    cstring[200]:STRING,
    libstr[50]:STRING

PROC main()
    DEF p

    StrCopy( cfile, arg, ALL)
    p:= InStr( cfile, '_lib.fd')
    IF ( p = -1 ) THEN p := InStr( cfile, '.fd' )
    MidStr( efile, cfile, 0, p)
    StrAdd( efile, '.m', ALL)
    WriteF( 'Amiga E FD2Module\nconverting: "\s" to "\s"\n', cfile, efile)
    IF ( cfh := Open( cfile, OLDFILE)) = 0 THEN closeAll(INPUT_ERROR)
    IF ( efh := Open( efile, NEWFILE)) = 0 THEN closeAll(OUTPUT_ERROR)
    REPEAT
        eof := ReadStr(cfh,cstring)
        done := convert(cstring)
    UNTIL eof OR done
    WriteF( 'last offset: -\d\n', offset)
    Out( efh, $FF)
    WriteF( 'Done.\n')
    closeAll(0)
ENDPROC

PROC closeAll(er)
    IF ( cfh <> 0) THEN Close(cfh)
    IF ( efh <> 0) THEN Close(efh)
    SELECT er
        CASE INPUT_ERROR;  WriteF( 'Could not open input file!\n')
        CASE OUTPUT_ERROR; WriteF( 'Could not open output file!\n')
        CASE FORMAT_ERROR; WriteF( 'Function definition file format error!\n')
    ENDSELECT
    CleanUp(er)
ENDPROC

/* format of line to convert:
   ##base _<Basename>
     or
   ##bias <offset>
     or
   ##public
     or
   ##private
     or
   ##end
     or
   * <comment> or <libname>
     or
   <funcname>(<paramlist>)(<reglist>)*/

PROC convert(str)

    DEF pos,pos2,off2,len,narg,a,empty,dstr[50]:STRING,basestr[50]:STRING,
        funcstr[50]:STRING,regstr[20]:STRING,
        tstr[80]:STRING,t2str[80]:STRING,t3str[80]:STRING,reg,check

    MidStr(tstr,str,TrimStr(str)-str,ALL)
    LowerStr(tstr)
    WriteF('\s\n',str)
    IF StrCmp(tstr,'* "', STRLEN) AND ( gotlibname = FALSE )
        pos:=STRLEN
        pos2:=InStr(tstr,'.library"',0)
        IF ( pos2 = -1 ) THEN pos2:=InStr(tstr,'.device"',0)
        IF ( pos2 > -1 )
            MidStr( libstr, str, 3, StrLen( str ) - 4 )
            WriteF('Library will be: \s\n',libstr)
            gotlibname := TRUE
        ENDIF
    ELSEIF StrCmp(tstr,'##base ',STRLEN) OR StrCmp(tstr,'##base\t',STRLEN)
        pos:=STRLEN
        pos2:=InStr(tstr,'_',0)
        IF pos2=-1 THEN closeAll(FORMAT_ERROR)
        IF gotbase=FALSE
            gotbase:=TRUE
            MidStr(basestr,str,(pos2+1),ALL)
            LowerStr(basestr)
            WriteF('Base will be: \s\n',basestr)
            IF ( gotlibname = FALSE )
                WriteF('Correct name of this library (with the ".library" or ".device"):\n>')
                ReadStr(stdout,libstr)
                WriteF('Library will be: \s\n',libstr)
            ENDIF
            Write(efh,["EM","OD",6]:INT,6)
            Write(efh,libstr,EstrLen(libstr)+1)
            Write(efh,basestr,EstrLen(basestr)+1)
        ENDIF
    ELSEIF StrCmp(tstr,'##bias ',STRLEN) OR StrCmp(tstr,'##bias\t',STRLEN)
        pos:=STRLEN
        MidStr(t2str,tstr,pos,ALL)
        pos2:=TrimStr(t2str)
        MidStr(t3str,t2str,pos2-t2str,ALL)
        off2:=Val(t3str,NIL)
        IF off2=0 THEN closeAll(FORMAT_ERROR)
        WHILE off2<>offset
            Write(efh,'Dum',3)                     /* "empty function slots" */
            Out(efh,16)
            IF offset>off2 THEN closeAll(FORMAT_ERROR)
            offset:=offset+6
        ENDWHILE
    ELSEIF StrCmp(tstr,'##private',ALL)
        public:=FALSE
    ELSEIF StrCmp(tstr,'##public',ALL)
        public:=TRUE
    ELSEIF StrCmp(tstr,'##end',ALL)
        RETURN TRUE
    ELSEIF StrCmp(tstr,'*',STRLEN)
        NOP
    ELSE
        IF public
            pos:=0
            pos2:=InStr(str,'(',pos)
            IF pos2=-1 THEN closeAll(FORMAT_ERROR)
            MidStr(funcstr,str,pos,pos2-pos)
            IF funcstr[0]>="a" THEN funcstr[0]:=funcstr[0]-32
            IF funcstr[1]<"a" THEN funcstr[1]:=funcstr[1]+32
            Write(efh,funcstr,EstrLen(funcstr))
            pos:=pos2+1
            pos2:=InStr(str,'(',pos)
            IF pos2=-1 THEN closeAll(FORMAT_ERROR)
            narg:=0
            MidStr(dstr,str,pos2+1,ALL)
            UpperStr(dstr)
            WHILE StrCmp(dstr,')',1)=FALSE
                IF EstrLen(dstr)<2 THEN closeAll(FORMAT_ERROR)
                MidStr(regstr,dstr,0,2)
                IF StrCmp(regstr,'D',1) OR StrCmp(regstr,'A',1)
                    IF StrCmp(regstr,'D',1)
                        reg:=0
                    ELSEIF StrCmp(regstr,'A',1)
                        reg:=8
                    ENDIF
                    MidStr(regstr,regstr,1,ALL)
                    reg:=reg+Val(regstr,{check})
                    IF check<1 THEN closeAll(FORMAT_ERROR)
                ELSE
                    closeAll(FORMAT_ERROR)
                ENDIF
                MidStr(dstr,dstr,2,ALL)
                IF StrCmp(dstr,',',1) OR StrCmp(dstr,'/',1)
                    MidStr(dstr,dstr,1,ALL)
                ENDIF
                Out(efh,reg)
                INC narg
            ENDWHILE
            IF narg=0 THEN Out(efh,16)
            offset:=offset+6
        ELSE
            Write(efh,'Dum',3)
            Out(efh,16)
            offset:=offset+6
        ENDIF
    ENDIF
ENDPROC FALSE

version:
CHAR'\0$VER: fd2module 1.1 (11.11.96) \tWritten by Dominique Dutoit (ddutoit@arcadis.be)\0'
