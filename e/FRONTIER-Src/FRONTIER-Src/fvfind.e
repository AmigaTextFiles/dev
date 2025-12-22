/* ----------------------------------------------------------------
 *
 *  Project  : Filevirus Library
 *
 *  Program  : fvfind.e
 *
 *  E-Author : Mathias Grundler <turrican@starbase.inka.de>
 *
 *  C-Author : Bjorn Reese <breese@imada.ou.dk>
 *
 *  Short    : Example of a simple virus detector that uses unpack.library
 *             Compile with "ec fvfind.e"
 *
 * ---------------------------------------------------------------- */
MODULE  'exec/memory'
MODULE  'dos/dos'
MODULE  'dos/doshunks'
MODULE  'dos/dostags'
MODULE  'unpack'
MODULE  'libraries/unpack'
MODULE  'filevirus'
MODULE  'libraries/filevirus'

/* ---------------------------------------------------------------- */

PROC scanner(p:PTR TO filevirusnode,pu:PTR TO unpackinfo)

 p.fv_Buffer    := pu.decrunchadr
  p.fv_BufferLen := pu.decrunchlen

   WriteF('File: "\s" ', pu.filename)

    IF (FvCheckFile(p)=0)
     IF (p.fv_FileInfection <> NIL)
      WriteF('*** virus "\s" found\n', (p.fv_FileInfection.fi_VirusName))
     ELSE
      WriteF('clean\n')
     ENDIF
    ELSE
    WriteF('error \d\n', p.fv_Status)
   ENDIF
ENDPROC

/* ---------------------------------------------------------------- */

PROC unpackscanner(p:PTR TO filevirusnode, fname)
 DEF pu:PTR TO unpackinfo

  IF (unpackbase:=OpenLibrary('unpack.library', 39) )
   IF (pu:=UpAllocCInfo())
  WriteF('arg=\s - name=\s\n',arg,fname)
    pu.filename := fname
    pu.path     := 'TEMP:' /* must be unique as all files here will be deleted */
    pu.jump     := {scanner}
    pu.trackjump:= {scanner}
    pu.userdata := p
    pu.flag     := 1 AND UFB_DELETE

     IF (UpDetermineFile(pu, fname))
      WriteF('Cruncher: \s\n', pu.crunchername)
       UpUnpack(pu)
     ELSE
      IF (UpLoadFile(pu))
       scanner(p, pu)
        UpFreeFile(pu)
      ENDIF
      UpFreeCInfo(pu);
     ENDIF
   ENDIF
   CloseLibrary(unpackbase);
  ENDIF
ENDPROC

/* ---------------------------------------------------------------- */

PROC main()
 DEF p:PTR TO filevirusnode

  IF (filevirusbase:=OpenLibrary('filevirus.library', 0) )
   IF (p:=FvAllocNode())
    unpackscanner(p, arg)
     FvFreeNode(p)
   ELSE
    WriteF('FvAllocNode() failed\n')
   ENDIF
   CloseLibrary(filevirusbase)
  ELSE
  WriteF('Cannot open "filevirus.library"\n')
 ENDIF
ENDPROC
