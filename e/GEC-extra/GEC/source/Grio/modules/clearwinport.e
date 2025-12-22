
OPT MODULE


MODULE 'exec/nodes','exec/ports',
       'exec/lists','intuition/intuition'



EXPORT PROC clearWinPort(win:PTR TO window)
 DEF msg:PTR TO intuimessage, succ ,ret=NIL
 Forbid()
 IF win
    IF ret:=win.userport
       msg:=win.userport.msglist.head
       WHILE succ:=msg::ln.succ
	  IF msg.idcmpwindow=win
	     Remove(msg)
	     ReplyMsg(msg)
	  ENDIF
	  msg:=succ
       ENDWHILE
       win.userport:=NIL
       ModifyIDCMP(win,0)
    ENDIF
 ENDIF
 Permit()
ENDPROC ret




