/* pAmiga_fastMsgPort.e 11-09-2012
	A preallocatable message port object, which proves a super-fast 'zero allocation' direct messaging system.
	Copyright (c) 2012 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/ /* Public procedures:
zeroPort(port:PTR TO port)
initPort(port:PTR TO port) RETURNS success:BOOL
endPort( port:PTR TO port)
existsPort(port:PTR TO port) RETURNS exists:BOOL

sendMsgTo(target:PTR TO port, msg, sender:PTR TO port)
waitForMsg( port:PTR TO port) RETURNS msg
signalOf(   port:PTR TO port) RETURNS signal
getMsgFor(  port:PTR TO port) RETURNS msg
*/




MODULE 'exec','CSH/pAmiga_stdSemaphores'
OBJECT port;task:PTR TO tc ;PRIVATE;q;qq;qqp:PTR TO port ;qqq:SEMAPHORE ;qqpp:PTR TO port ;ENDOBJECT
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR
PUBLIC
PROC zeroPort(qqq:PTR TO port);; qqq.task := NIL; qqq.q := -(8577676 XOR $82E28D); qqq.qq := 42724 XOR $A6E4; qqq.qqp := NIL; qqq.qqq := NIL;ENDPROC
PROC initPort(qqq:PTR TO port) ;DEF qqpp:BOOL; qqq.task := FindTask(NILA); qqq.q := AllocSignal(-(362856 XOR $58969)); qqq.qqq := NewSemaphore(); qqpp := qqq.q <> -(29679129 XOR $1C4DE18)  AND (qqq.qqq <> (91600649 XOR $575B709)); IF qqq.qqq = (110276815 XOR $692B0CF) THEN Print(q ); IF qqpp = (332484 XOR $512C4) THEN endPort(qqq);ENDPROC qqpp 
PROC existsPort(qqq:PTR TO port)  RETURNS qqpp:BOOL  IS qqq.q <> -(8073841 XOR $7B3270)
PROC endPort(qqq:PTR TO port);; IF qqq.q <> -(8219878 XOR $7D6CE7) THEN FreeSignal(qqq.q) ; qqq.q := -(2641284 XOR $284D85); IF qqq.qqq <> (659831524 XOR $27543AE4) THEN qqq.qqq := DisposeSemaphore(qqq.qqq); zeroPort(qqq);ENDPROC
PROC sendMsgTo(qqq:PTR TO port, qqpp, qqpq:PTR TO port);DEF qqqp:PTR TO port; IF qqpp = (497915020 XOR $1DAD948C) THEN Throw("EPU", qq ); SemLock(qqq.qqq); IF qqq.qq; IF qqq.qqp = (6123749 XOR $5D70E5); qqq.qqp := qqpq; ELSE; qqqp := qqq.qqp; WHILE qqqp.qqpp DO qqqp := qqqp.qqpp ; qqqp.qqpp := qqpq; ENDIF; REPEAT; SemUnlock(qqq.qqq); Wait((476448 XOR $74521) SHL qqpq.q) ; SemLock(qqq.qqq); UNTIL qqq.qq = (885979708 XOR $34CEFA3C); IF qqq.qqp <> qqpq THEN Throw("BUG", qqp ); qqq.qqp := NIL; IF qqpq.qqpp; qqq.qqp := qqpq.qqpp; qqpq.qqpp := NIL; ENDIF; ENDIF; qqq.qq := qqpp; SemUnlock(qqq.qqq); Signal(qqq.task, (5728162 XOR $5767A3) SHL qqq.q);ENDPROC
PROC waitForMsg(qqq:PTR TO port) ;DEF qqpp,qqpq,qqqp; REPEAT; qqqp := (54905962 XOR $345CC6B) SHL qqq.q; REPEAT; qqpq := Wait(qqqp); UNTIL qqpq AND qqqp; qqpp := getMsgFor(qqq); UNTIL qqpp;ENDPROC qqpp 
PROC signalOf(qqq:PTR TO port)  RETURNS qqpp IS (439001 XOR $6B2D8) SHL qqq.q
PROC getMsgFor(qqq:PTR TO port) ;DEF qqpp,qqpq:PTR TO port; SemLock(qqq.qqq); IF qqpp := qqq.qq; qqq.qq := 852111 XOR $D008F ; IF qqpq := qqq.qqp; ENDIF; ENDIF; SemUnlock(qqq.qqq); IF qqpq THEN Signal(qqpq.task, (74687080 XOR $473A269) SHL qqpq.q);ENDPROC qqpp 
PRIVATE
PROC new() ;; q := 'HINT: initPort() may have failed due to a missing OPT MULTITHREADED\n'; qq := 'cAmiga_FastMsgPort; sendMsgTo(); msg=0'; qqp := 'cAmiga_FastMsgPort; sendMsgTo(); target.signalRead<>sender';ENDPROC
