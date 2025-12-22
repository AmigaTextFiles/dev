OPT MODULE

MODULE 'dos/dos'



EXPORT PROC gReadFile(filename,memflags=0,lenght=-1)
   MOVEM.L   D3-D5,-(A7)
   MOVEQ     #NIL,D5
   MOVEQ     #NIL,D3
   MOVEA.L   dosbase,A6
   MOVE.L    filename,D1
   MOVE.L    #OLDFILE,D2
   JSR       Open(A6)
   MOVE.L    D0,D4
   BEQ.S     exit
   MOVEQ     #0,D2
   MOVE.L    D4,D1
   MOVEQ     #OFFSET_END,D3
   JSR       Seek(A6)
   MOVE.L    D4,D1
   MOVEQ     #OFFSET_BEGINING,D3
   JSR       Seek(A6)
   MOVE.L    D0,D3
   MOVE.L    lenght,D0
   CMP.L     D0,D3
   BLS.S     bigger
   MOVE.L    D0,D3
bigger:
   MOVE.L    D3,D2
   ADDQ.L    #8,D2
   MOVE.L    D2,D0
   MOVE.L    memflags,D1
   MOVEA.L   execbase,A6
   JSR       AllocMem(A6)
   MOVEA.L   dosbase,A6
   TST.L     D0
   BEQ.S     close
   MOVEA.L   D0,A0
   CLR.L     -4(A0,D2.L)
   MOVE.L    D2,(A0)+
   MOVE.L    A0,D5
   MOVE.L    D4,D1
   MOVE.L    D5,D2
   JSR       Read(A6)
   CMP.L     D0,D3
   BEQ.S     close
   MOVE.L    D5,-(A7)
   BSR.S     gFreeFile
   ADDQ.W    #4,A7
   MOVEA.L   dosbase,A6
   MOVEQ     #NIL,D5
close:
   MOVE.L    D4,D1
   JSR       Close(A6)
exit:
   MOVE.L    D3,D1
   MOVE.L    D5,D0
   MOVEM.L   (A7)+,D3-D5
ENDPROC D0



EXPORT PROC gFreeFile(filebuf)
   MOVE.L   filebuf,D0
   BEQ.S    quit_free
   MOVEA.L  D0,A1
   MOVE.L   -(A1),D0
   MOVEA.L  execbase,A6
   JSR      FreeMem(A6)
quit_free:
ENDPROC D0



EXPORT PROC gWriteFile(filename,memory,length)
   MOVEM.L   D3-D5,-(A7)
   MOVEQ     #FALSE,D5
   MOVE.L    filename,D1
   MOVE.L    #NEWFILE,D2
   MOVEA.L   dosbase,A6
   JSR       Open(A6)
   MOVE.L    D0,D4
   BEQ.S     quit
   MOVE.L    D0,D1
   MOVE.L    memory,D2
   MOVE.L    length,D3
   JSR       Write(A6)
   CMP.L     D0,D3
   BNE.S     clsfile
   MOVEQ     #TRUE,D5
clsfile:
   MOVE.L    D4,D1
   JSR       Close(A6)
   TST.L     D5
   BNE.S     quit
   MOVE.L    filename,D1
   JSR       DeleteFile(A6)
quit:
   MOVE.L    D5,D0
   MOVEM.L   (A7)+,D3-D5
ENDPROC D0




