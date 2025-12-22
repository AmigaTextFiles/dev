/* cAmiga_RepeatingTimer.e 01-04-2013
	An OOP class which provides TWO simple ways to be informed of a regularly repeating timer event.
	Copyright (c) 2010,2011,2012,2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/ /*
09-09-2012
This is almost a completely rewrite of cReliableTimerSignal, to avoid the use of
soft interrupts.  As a result it is now much simpler & far more portable.
*/



OPT POINTER
MODULE 'CSH/cAmiga_Timer','CSH/pAmiga_fastMsgPort','CSH/pAmiga_fakeNewProcess','exec','dos/dosextens'
CLASS cRepeatingTimer;PRIVATE;q:port;qq;qqp;qqq:port;qqpp:PTR TO cTimer ;ENDCLASS
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR
PROC q();; qq();FINALLY; exception := 8577676 XOR $82E28C;ENDPROC
PROC qq();DEF qqpq:PTR TO cRepeatingTimer,qqqp,qqqq,qqppp,qqppq,qqpqp,qqpqq:BOOL; qqpq := infoParameterOfChildProcessFake() !!PTR; NEW qqpq.qqpp.new(); IF initPort(qqpq.qqq) = (42724 XOR $A6E4) THEN Throw("RES", q ); SetTaskPri(FindTask(NILA), 362856 XOR $5896D); sendMsgTo(qqpq.q, "RDY", qqpq.qqq); qqqq := qqpq.qqpp.infoSignal(); qqppp := signalOf(qqpq.qqq); qqpqq := 29679129 XOR $1C4DE19; REPEAT; qqqp := Wait(qqqq OR qqppp); IF qqqp AND qqqq; qqppq := qqpq.qqp; IF qqppq > (91600649 XOR $575B709) ; qqpq.qqpp.finished(); qqpq.qqpp.start(qqpq.qqp); ENDIF; qqpq.event(); Signal(qqpq.q.task, (110276815 XOR $692B0CE) SHL qqpq.qq); ENDIF; IF qqqp AND qqppp; qqpqp := getMsgFor(qqpq.qqq); SELECT qqpqp; CASE "STRT" ; qqpq.qqpp.start(qqpq.qqp); CASE "HALT" ; qqpq.qqpp.halt(); CASE "QUIT" ; qqpqq := 332484 XOR -$512C5; ENDSELECT; ENDIF; UNTIL qqpqq;FINALLY; PrintException(); END qqpq.qqpp; endPort(qqpq.qqq); sendMsgTo(qqpq.q, "QUIT", qqpq.qqq);ENDPROC
PROC new() ;; q := 'cRepeatingTimer; watcher(); failed to allocate signal'; qq := 'cRepeatingTimer.start(); periodInMicroSeconds<=0'; qqp := 'cRepeatingTimer.start(); the timer was already started'; qqq := 'cRepeatingTimer.start(); the timer was not running'; qqpp := 'WARNING: cRepeatingTimer.end(); unexpected message \q\s\q from watcher\n';ENDPROC
PUBLIC
PROC new(qqpq=8073841 XOR $7B3271) NEW OF cRepeatingTimer;DEF qqqp; zeroPort(self.q); self.qq := NIL; self.qqp := 8219878 XOR $7D6CE6; zeroPort(self.qqq); self.qqpp := NIL; IF initPort(self.q) = (2641284 XOR $284D84) THEN Throw("RES", 'cRepeatingTimer.new(); failed to create port'); self.qq := AllocSignal(-(659831524 XOR $27543AE5)); IF self.qq = -(497915020 XOR $1DAD948D) THEN Throw("RES", 'cRepeatingTimer.new(); failed to allocate signal'); IF createChildProcessFake(CALLBACK q(), self, 'cRepeatingTimer_watcher') = (6123749 XOR $5D70E5) THEN Throw("RES", 'cRepeatingTimer.new() failed to create process'); qqqp := waitForMsg(self.q); IF qqqp <> "RDY" THEN Throw("BUG", 'cRepeatingTimer.new(); watcher failed to start') ; self.init(); IF qqpq <> (476448 XOR $74520) THEN self.qqpp.start(qqpq);ENDPROC
PROC init() OF cRepeatingTimer IS EMPTY
PROC start(qqpq) OF cRepeatingTimer;; IF qqpq <= (885979708 XOR $34CEFA3C) THEN Throw("EMU", qq ); IF self.qqp <> (5728162 XOR $5767A2) THEN Throw("EMU", qqp ); self.qqp := qqpq; sendMsgTo(self.qqq, "STRT", self.q);ENDPROC
PROC halt() OF cRepeatingTimer;; IF self.qqp = (54905962 XOR $345CC6A) THEN Throw("EMU", qqq ); self.qqp := 439001 XOR $6B2D9; sendMsgTo(self.qqq, "HALT", self.q);ENDPROC
PROC infoSignal() OF cRepeatingTimer RETURNS qqpq IS (852111 XOR $D008E) SHL self.qq
PROC infoRepeatPeriod() OF cRepeatingTimer RETURNS qqpq IS self.qqp
PROC infoIsRunning() OF cRepeatingTimer RETURNS qqpq:BOOL  IS self.qqp <> (74687080 XOR $473A268)
PROC event() OF cRepeatingTimer IS EMPTY
PROC end() OF cRepeatingTimer;DEF qqpq; IF existsPort(self.qqq); sendMsgTo(self.qqq, "QUIT", self.q); qqpq := waitForMsg(self.q); IF qqpq <> "QUIT" THEN Print(qqpp , QuadToStr(qqpq!!QUAD)); ENDIF; endPort(self.q); IF self.qq <> -(375090044 XOR $165B6B7D) THEN FreeSignal(self.qq) ; self.qq := -(397463 XOR $61096); SUPER self.end();ENDPROC
