/* Spielt ein Sound im Raw-Data Format dauernt im hintergrund ab
   ohne das program zu unterbrechen*/

DEF file,lenge,w,buffer,lese

PROC main()
 w:=OpenW(0,0,455,30,$200,$F+4096,'Sound Fenster',NIL,1,NIL)
 file:=Open('df0:alarm',OLDFILE)      /* Von  hier */
 lenge:=FileLength('df0:alarm')            /* : */
 buffer:=AllocMem(lenge+1,2)              /* : */
 lese:=Read(file,buffer,lenge)       /* bis ist klar oder ? */
 Close(file)

 PutLong(14676128,buffer) /* Adresse des Sound's */
 PutInt(14676132,lenge/2)    /* Lenge in Worten     */
 PutInt(14676136,64)      /* Volumen             */
 PutInt(14676134,Int(buffer))     /* Speed DMA 0         */

 PutInt(14676118,32769)   /* DMA 0 Ein           */
 TextF(10,20,'Bitte Schliessgadget anklicken zum beenden')
 ende:
 WaitIMessage(w)
 PutInt(14676118,1)       /* DMA 0 Ausschalten   */
 FreeMem(buffer,lenge+1)
 CloseW(w)
ENDPROC
