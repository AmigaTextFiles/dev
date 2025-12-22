/* loads an iff-file, displays the chunks and their contents.
** Then write an modified version of the file
*/

OPT PREPROCESS

MODULE 'iffparse','libraries/iffparse',
       'tools/exceptions',
       'other/split',
       'sven/support/iffparse'

RAISE "LIB"  IF OpenLibrary()=NIL

PROC main() HANDLE
DEF arglist:PTR TO LONG,
    file[256]:STRING

  WriteF('Start\n')
  iffparsebase:=OpenLibrary('iffparse.library',0)

  IF arglist:=argSplit()
    StrCopy(file,arglist[])
    IF StrCmp(file,'')=FALSE
      testsaveiff(file)
      testloadiff(StrAdd(file,'1'))
    ENDIF
  ENDIF

EXCEPT DO
  IF iffparsebase THEN CloseLibrary(iffparsebase)

  report_exception()
  WriteF('Ende\n')
ENDPROC

PROC testsaveiff(name) HANDLE
DEF siff=NIL:PTR TO iffhandle,
    buf=NIL:PTR TO CHAR,
    size=20,i,b,id,hsize
DEF idbuf[5]:ARRAY

  WriteF('Save : \s\n',name)
  NEW buf[size]
  siff:=initSaveIFF(name,"TEST")
  FOR i:=0 TO 5

    id:=Shl(Rnd("Z"-"A")+"A",24)+
        Shl(Rnd("Z"-"A")+"A",16)+
        Shl(Rnd("Z"-"A")+"A",8)+
           (Rnd("Z"-"A")+"A")
    WriteF('ID: \s\n',IdtoStr(id, idbuf))

    hsize:=Rnd(size)+1
    FOR b:=0 TO hsize-1 DO buf[b]:=Rnd(256)
    WriteF('Size: \d\n',hsize)
    WriteF('Buf: ')
    FOR b:=0 TO hsize-1 DO WriteF('\d,',buf[b])
    WriteF('\n')

    newChunk(siff,id)
    writeCurrentChunk(siff,buf,hsize)
    endChunk(siff)

  ENDFOR

EXCEPT DO
  closeSaveIFF(siff)
  END buf[size]
  WriteF('Ende\n')
ENDPROC

PROC testloadiff(name) HANDLE
DEF liff=NIL:PTR TO iffhandle,
    cn:PTR TO contextnode,
    finish=FALSE
DEF i,idbuf[5]:ARRAY,
    id,size,type,
    buf:PTR TO CHAR,
    readbytes

  WriteF('Load: \s\n',name)
  liff:=initLoadIFF(name)

  REPEAT
    finish,cn:=stepIFF(liff)
    IF cn
      FOR i:=1 TO liff.depth DO WriteF('. ')

      id,size,type:=analyseChunk(cn)
      WriteF('\s,\d,', IdtoStr(id, idbuf), size)
      WriteF('\s\n',   IdtoStr(type, idbuf))

      IF size<50

        size,buf,readbytes:=readCurrentChunk(liff,size)
        WriteF('Wanted: \d, Got:\d\n',size,readbytes)
        FOR i:=0 TO (readbytes-1) DO WriteF('\d,',buf[i])
        WriteF('\n')
        END buf[size]

      ENDIF

    ENDIF
  UNTIL finish

EXCEPT DO
  closeLoadIFF(liff)
ENDPROC

