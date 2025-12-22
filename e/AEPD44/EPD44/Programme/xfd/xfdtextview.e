-> show a textfile in a nice juicy scrolling window
-> NEW from DII: XFD support added 12/4/96
->
-> Modified to work with v37 xfdmaster-includes on 12/6/96 by Sven Steiniger.

OPT PREPROCESS
OPT REG=5

MODULE 'tools/file',
       'class/sctext',
       'xfdmaster','libraries/xfdmaster',
       'exec/memory'

PROC main() HANDLE
DEF mem,
    length,
    strinr,
    list,
    sc=NIL:PTR TO scrolltext,
    bufinf=NIL:PTR TO xfdBufferInfo,
    cruncher,
    title[60]:STRING,
    succ=FALSE

  IF (XFDMasterBase:=OpenLibrary(XFDM_NAME,XFDM_VERSION))=NIL THEN
    Throw("LIB",'Could not open xfdmaster.library')
  
  IF (bufinf:=xfdAllocObject(XFDOBJ_BUFFERINFO))=NIL THEN Raise("MEM")

  mem,length:=readfile(arg)
  cruncher:='ASCII'
  bufinf.xfdbi_SourceBuffer:=mem
  bufinf.xfdbi_SourceBufLen:=length
  IF xfdRecogBuffer(bufinf)

    IF bufinf.xfdbi_PackerFlags AND (XFDPFF_PASSWORD OR XFDPFF_KEY16 OR XFDPFF_KEY32) THEN
      Throw("p/k",'Unsupported. Requires password or key.')

    bufinf.xfdbi_TargetBufMemType:=MEMF_PUBLIC
    IF xfdDecrunchBuffer(bufinf)=FALSE THEN Throw("decr",'Failed to decrunch file.')

    length   := bufinf.xfdbi_TargetBufSaveLen
    mem      := bufinf.xfdbi_TargetBuffer
    cruncher := bufinf.xfdbi_PackerName
    succ:=TRUE

  ENDIF
    
  list:=stringsinfile(mem,length,strinr:=countstrings(mem,length))

  StringF(title,'TextView 1.0 (\s)',cruncher)
  NEW sc.settext(list,100)
  sc.open(title,20,20,300,150)

  WHILE sc.handle()=FALSE DO Wait(-1)

EXCEPT DO

  IF sc THEN END sc
  IF succ THEN FreeMem(bufinf.xfdbi_TargetBuffer,
                       bufinf.xfdbi_TargetBufLen)
  IF bufinf THEN xfdFreeObject(bufinf)
  IF XFDMasterBase THEN CloseLibrary(XFDMasterBase)

  IF exception
    SELECT exception
      CASE "MEM"  ; WriteF('Not enough memeory\n')
      CASE "OPEN" ; WriteF('Could not open file \s\n',IF exceptioninfo THEN exceptioninfo ELSE '')
      DEFAULT     ; WriteF('"\s": \s\n',[exception,0]:LONG,IF exception THEN exceptioninfo ELSE '')
    ENDSELECT
  ENDIF

ENDPROC

