/* Müßte auf jeden Rechner gehen (getestet auf A500(OS1.3/OS2.04),A1200) */

DEF w

PROC main()
 w:=OpenW(0,0,150,30,$200,$F,'LED Win',NIL,1,NIL)
 TextF(10,20,'LED Dunkel')
 PutInt(12574721,Int(12574721)OR 2) /* led on */
 Delay(250)
 TextF(10,20,'LED Hell   ')
 PutInt(12574721,Int(12574721)AND 253) /* led off */
 Delay(150)
 CloseW(w)
ENDPROC
