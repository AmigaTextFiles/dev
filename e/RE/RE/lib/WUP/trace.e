/*

*/
OPT NOHEAD,NOEXE,CPU='WUP'

MODULE
        'dos',
        'dos/dos',
        'exec',
        'exec/memory'

DEF source:PTR TO LONG,tcon,disabled

IMPORT DEF PowerPCBase ->necessary if OPT NOHEAD

PROC TraceLine(curs:PTR TO CHAR,str=0,lst=0:PTR TO LONG,file=0,end=0)
  DEF p,n=0,tlist[10]:ARRAY OF LONG,tconstr[10]:STRING

  IF disabled THEN RETURN
  IF end
    IF source THEN FreeMem(source-8,source[-1]+4+4+1)
    IF tcon THEN Close(tcon)
    RETURN
  ENDIF
  IFN source
    IFN source:=loadfile(file) THEN RETURN
    tcon:=Open('con:0/11/640/80/RE debug output',1006)
  ENDIF

  curs += source
  p:=curs
  FPutC(tcon,12) ->CLS = FF
  ->go back 1 line
  WHILE curs[]<>"\n" DO curs--
  curs--
  WHILE curs[]<>"\n" DO curs--
  curs++
  ->print 3 lines
  WHILE curs[]<>"\n" DO FPutC(tcon,curs[]++)
  FPutC(tcon,"\n")
  curs++
  WHILE curs[]<>"\n"
    IF curs=p THEN FPuts(tcon,'>>>')
    FPutC(tcon,curs[])
    curs++
  ENDWHILE
  FPutC(tcon,"\n")
  curs++
  WHILE curs[]<>"\n" DO FPutC(tcon,curs[]++)

  FPuts(tcon,'\n--------') ; FPuts(tcon,StringF(tconstr,'$\h',tcon)) ; FPutC(tcon,"\n")
  ->copy vars
  WHILE (lst[n]<>0) AND (n<10)
    tlist[n] := ^lst[n]
    n++
  ENDWHILE
  VFPrintF(tcon,str,tlist)

  ->WHILE FGetC(tcon)<>"\n" ; ENDWHILE->wait for a return
  n:=TRUE
  WHILE n
    p:=FGetC(tcon)
    IF p="\n"
      n:=FALSE
    ELSEIF p=$1b
      TraceLine(0,0,0,0,TRUE) ->free mem
      disabled := TRUE
      n:=FALSE
    ENDIF
  ENDWHILE
    
ENDPROC

PROC loadfile(filename)(LONG,LONG)
  DEF file=0,filelen=0,mem=0:PTR TO LONG

  IF file:=Open(filename,OLDFILE)
    filelen:=FileLength(filename)

    IF mem := AllocMem(filelen+4+4+1,MEMF_PUBLIC)
      mem[]++:=file ; mem[]++:=filelen
      IF Read(file,mem,filelen)<>filelen
        FreeMem(mem-8,mem[-1]+4+4+1)
        mem:=0
        SetIoErr(310) ->random number!
      ENDIF
    ELSE
      SetIoErr(ERROR_NO_FREE_STORE)
    ENDIF
    Close(file)
  ENDIF
ENDPROC mem
