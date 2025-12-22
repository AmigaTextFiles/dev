/* EClock 7-Oct-93 by Kai.Nikulainen@utu.fi */

MODULE 'intuition/intuition'

CONST LEFT=8,TOP=13

PROC get_time(h,m)
DEF time[3]:ARRAY OF LONG
   DateStamp(time)
   ^h:=time[1]/60
   ^m:=(time[1]-(^h*60))
ENDPROC

PROC display(mask,pos)
DEF x
   x:=LEFT+ListItem([0,28,0,67,95],pos)
   Box(x+4,TOP,x+19,TOP+1,1+(And(mask,%1)=FALSE)*3)
   Box(x,TOP+2,x+3,TOP+11,1+(And(mask,%10)=FALSE)*3)
   Box(x+20,TOP+2,x+23,TOP+11,1+(And(mask,%100)=FALSE)*3)
   Box(x+4,TOP+12,x+19,TOP+13,1+(And(mask,%1000)=FALSE)*3)
   Box(x,TOP+14,x+3,TOP+23,1+(And(mask,%10000)=FALSE)*3)
   Box(x+4,TOP+24,x+19,TOP+25,1+(And(mask,%100000)=FALSE)*3)
   Box(x+20,TOP+14,x+23,TOP+23,1+(And(mask,%1000000)=FALSE)*3)
ENDPROC

PROC display_time(hr,mi,m)
DEF n
   n:=hr/10
   display(m[n],0)
   display(m[hr-(n*10)],1)
   n:=mi/10
   display(m[n],3)
   display(m[mi-(n*10)],4)
ENDPROC

PROC main()
DEF h,m,w:PTR TO window,mask,msg=NIL
   mask:=[%1110111,%1000100,%0111101,%1101101,%1001110,
         %1101011,%1111011,%1000111,%1111111,%1101111]:CHAR
   w:=OpenW(500,22,137,43,IDCMP_CLOSEWINDOW,
   WFLG_DEPTHGADGET+WFLG_CLOSEGADGET+WFLG_DRAGBAR,'EClock',NIL,1,NIL)
   IF w
      Box(LEFT+57,TOP+8,LEFT+61,TOP+10,3)
      Box(LEFT+57,TOP+15,LEFT+61,TOP+17,3)
      WHILE msg=NIL
         get_time({h},{m})   
         display_time(h,m,mask) 
         Delay(100)
         msg:=GetMsg(w.userport)
      ENDWHILE
      ReplyMsg(msg)
      msg:=GetMsg(w.userport)
      WHILE msg<>NIL
        ReplyMsg(msg)
        msg:=GetMsg(w.userport)
      ENDWHILE
      CloseW(w)
      CleanUp(0)
   ELSE
      WriteF('Can\at open window!\n')
      CleanUp(5)
   ENDIF
ENDPROC
