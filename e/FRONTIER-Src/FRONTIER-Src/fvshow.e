/* ----------------------------------------------------------------
 *
 *  Project   : Filevirus Library
 *
 *  Program   : fvshow.c
 *
 *  Author    : Bjorn Reese <breese@imada.ou.dk>
 *
 *  Translator: Mathias Grundler <turrican@starbase.inka.de>
 *
 *  Short     : Example showing fvShow(Next)FVInfo.
 *              Compile with "ec fvshow.e"
 *
 * ---------------------------------------------------------------- */

MODULE  'exec/types'
MODULE  'filevirus'
MODULE  'libraries/filevirus'

/* ---------------------------------------------------------------- */

PROC main()
 DEF    p :PTR TO filevirusnode,
        pi:PTR TO filevirusinfo,
        fvbase:PTR TO filevirusbase,
        xs,
        type

  IF (filevirusbase:=OpenLibrary('filevirus.library', 2))
   fvbase:=filevirusbase
   IF (p:=FvAllocNode())
    WriteF('Known viruses [total: \d]\n', fvbase.fb_VInfoTotal)
     pi:=FvShowFVInfo(p)
      REPEAT
       type:=pi.fvi_Type
        SELECT   type
         CASE    FV_LINK
           xs:= 'link'
         CASE    FV_DELETE
           xs:= 'delete'
         CASE    FV_RENAME
           xs:= 'rename'
         CASE    FV_CODE
           xs:= 'code'
         CASE    FV_OVERLAY
           xs:= 'overlay'
         DEFAULT
           xs:= 'unknown'
        ENDSELECT
       WriteF(' \d[4] \s[40] (\s)\n', p.fv_VInfoCount, pi.fvi_Name, xs)
      UNTIL (pi:=FvShowNextFVInfo(p))=NIL
    FvFreeNode(p)
   ELSE
    WriteF('FvAllocNode() failed\n')
   ENDIF
  CloseLibrary(filevirusbase)
  ELSE
   WriteF('Cannot open "filevirus.library" V.2+\n')
  ENDIF
ENDPROC
