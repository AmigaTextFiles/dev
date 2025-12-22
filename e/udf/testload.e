/***********************************************************
**                                                        **
**  Load test Program for UDF                             **
**                                                        **
**  ©2000 M&F Software Corporation                        **
**  All Right Reserved                                    **
**                                                        **
**  AmigaE 3.3                                            **
**                                                        **
**  $VER: 0.2.0 (28.01.00)                                **
**                                                        **
***********************************************************/

/*

  Recover the tree which has been saved previousl and display all udf
  archive and chunks contents.

*/

OPT OSVERSION=37
OPT PREPROCESS
OPT REG=3

MODULE  'M&F/udf', 'exec/lists'

#define filename 'RAM:archive1.udf'

PROC main()
  DEF t=NIL:PTR TO udf, err=0
  DEF l=NIL:PTR TO lh, node=NIL:PTR TO ck_node
  DEF ver=0, rev=0, count=0
  DEF meta=NIL:PTR TO metack
  DEF lh=NIL:PTR TO lh
  
  NEW t.new(filename)
  
  IF (err:=t.load())=NIL
    PrintF('name: \s\n', t.getname())
    PrintF('size: \d\n', t.getsize())
    ver, rev := t.getversion()
    PrintF('version: \d.\d\n', ver, rev)
    
    l:=t.collectchunks([
      CK_ID, ID_TEXT,
      0]:LONG)
    
    node := l.head
    WHILE node:=node.succ DO count++

    PrintF('Total collected chunk: \d\n\n', count)
    PrintF('-----------------------+\n')
    
    IF IsListEmpty(l) 
      PrintF('No chunk collected\n')
    ELSE
      node := l.head
      WHILE node.succ
        
        PrintF('Chunk content:         |\n')
        PrintF('"\s"\n', node.chunk.getdatabuffer())
        
        count:=0
        lh:=node.chunk.getmetachunklist()
        meta:=lh.head
        WHILE meta.succ
          IF count=0 THEN PrintF('\nMetachunk content:\n')
          PrintF('"\s"\n', meta.data)
          meta:=meta.succ
          count++
        ENDWHILE
        PrintF('-----------------------+\n')
        node := node.succ
      ENDWHILE
    ENDIF
  
    t.disposechunklist(l)
    PrintF('\nTotal number of chunks: \d\n', t.countchunks())
    
  ELSE
    PrintF('(\d) Could not open UDF file\n',err)
  ENDIF

  END t

ENDPROC
