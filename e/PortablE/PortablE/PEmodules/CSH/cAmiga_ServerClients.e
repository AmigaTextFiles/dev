/* cAmiga_ServerClients.e 13-01-2012
	A flexible but fairly simple client/server messaging module.

Copyright (c) 2012 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/ /* Public procedures:
createNamedPort(portName:ARRAY OF CHAR, portPriority=0:BYTE) RETURNS port:PTR TO mp
getServerForNamedPort(serverPortName:ARRAY OF CHAR) RETURNS server:PTR TO cServer
*//* Public methods of *cServer*:
new(port=NIL:PTR TO mp)
tellClientWeExist(client:PTR TO cClient)
sendMsg(target:PTR TO cClient, msg:PTR TO cMessage, returnMsgOnRead=FALSE:BOOL)
->receiveMsg() RETURNS msg:PTR TO cMessage
->waitForMsg() RETURNS msg:PTR TO cMessage
->infoSignal() RETURNS signal
*//* Public methods of *cClient*:
new(server:NULL PTR TO cServer)
waitForServerToExist()
sendMsg(msg:PTR TO cMessage, returnMsgOnRead=FALSE:BOOL)
receiveMsg() RETURNS msg:PTR TO cMessage, quit:BOOL
waitForMsg() RETURNS msg:PTR TO cMessage, quit:BOOL
->infoSignal() RETURNS signal
*//* Public methods of *cMessage*:
init()
haveRead()
infoRead()   RETURNS isRead:BOOL
infoSender() RETURNS sender:PTR TO cActor
*/



MODULE 'exec','CSH/pAmiga_stdSemaphores'
PRIVATE
OBJECT q OF mn;PRIVATE;q:PTR TO cMessage;ENDOBJECT
PUBLIC
CLASS cMessage;mn:q ;PRIVATE;q:BOOL;qq:BYTE;qqp:PTR TO cActor;ENDCLASS
CLASS cActor;port:PTR TO mp;pendingReplies;ENDCLASS
CLASS cServer OF cActor;sem:SEMAPHORE ;head:PTR TO cClient ;tail:PTR TO cClient;task:PTR TO tc ;ENDCLASS
PRIVATE
CLASS qq OF cMessage;ENDCLASS
PUBLIC
CLASS cClient UNGENERIC OF cActor;server:PTR TO cServer;prev:PTR TO cClient;next:PTR TO cClient;ENDCLASS
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR,qqpq:ARRAY OF CHAR,qqqp:ARRAY OF CHAR,qqqq:ARRAY OF CHAR,qqppp:ARRAY OF CHAR,qqppq:ARRAY OF CHAR,qqpqp:ARRAY OF CHAR,qqpqq:ARRAY OF CHAR,qqqpp:ARRAY OF CHAR
PUBLIC
PROC createNamedPort(qqqpq:ARRAY OF CHAR, qqqqp=8577676 XOR $82E28C:BYTE) ;DEF qqqqq:PTR TO mp; Forbid(); IF FindPort(qqqpq) = (42724 XOR $A6E4); IF qqqqq := CreateMsgPort(); qqqqq.ln.name := qqqpq; qqqqq.ln.pri := qqqqp; AddPort(qqqqq); ENDIF; ENDIF; Permit();ENDPROC qqqqq 
PROC getServerForNamedPort(qqqpq:ARRAY OF CHAR) ;DEF qqqqp:PTR TO cServer,qqqqq:PTR TO mp,qqpppp:PTR TO mp,qqpppq:PTR TO qq,qqppqp:PTR TO q; qqpppp := CreateMsgPort(); IF qqpppp = (362856 XOR $58968) THEN Throw("RES", q ); NEW qqpppq.q(29679129 XOR $1C4DE1A); qqpppq.qqp := NIL; qqpppq.q := 91600649 XOR -$575B70A; qqpppq.mn.replyport := qqpppp; qqpppq.mn.length := SIZEOF q!!UINT; Forbid(); IF qqqqq := FindPort(qqqpq) THEN PutMsg(qqqqq, qqpppq.mn); Permit(); IF qqqqq = (110276815 XOR $692B0CF) THEN RETURN; REPEAT; WaitPort(qqpppp); qqppqp := GetMsg(qqpppp)::q; UNTIL qqppqp; IF qqppqp <> qqpppq.mn THEN Throw("BUG", qq ); IF qqppqp.ln.type <> (332484 XOR $512C3) THEN Throw("BUG", qqp ); qqqqp := qqpppq.qqp::cServer;FINALLY; IF qqpppp THEN DeleteMsgPort(qqpppp); END qqpppq;ENDPROC qqqqp 
PRIVATE
PROC new() ;; q := 'cAmiga_ServerClients; getServerForNamedPort(); CreateMsgPort() failed'; qq := 'cAmiga_ServerClients; getServerForNamedPort(); unexpected message'; qqp := 'cAmiga_ServerClients; getServerForNamedPort(); unexpected message type'; qqq := 'ERROR: cMessage.end(); message is being ENDed without having been read.\n'; qqpp := 'cMessage.haveRead(); the message was already returned to the sender (or was never sent in the first place)'; qqpq := 'cActor.sendMsgTo(); the message\as hasRead() method must be called first, so probably the receiver is wrongly trying to re-use the message'; qqqp := 'cServer.tellClientWeExist(); the client already knows we exist'; qqqq := 'cServer.tellClientWeExist(); received an unexpected message (from the client?)'; qqppp := 'cServer.tellClientWeExist(); the client still does not know we exist'; qqppq := 'cClient.serverNowExists(); had already been told about the server'; qqpqp := 'cClient.end(); server.head<>self'; qqpqq := 'cClient.waitForServerToExist(); received an unexpected message (from the server?)'; qqqpp := 'cClient.sendMsg(); the serverNowExists() method has not been called yet';ENDPROC
PUBLIC
PROC init() OF cMessage;; self.mn.q := self; self.qq := 8073841 XOR $7B3271; self.mn.ln.type := 8219878 XOR $7D6CE1 ; self.qqp := NIL;ENDPROC
PROC end() OF cMessage;; IF self.infoRead() = (2641284 XOR $284D84) THEN Print(qqq ); SUPER self.end();ENDPROC
PROC haveRead() OF cMessage;; IF self.mn.ln.type = (659831524 XOR $27543AE3) THEN Throw("EMU", qqpp ); ReplyMsg(self.mn);ENDPROC
PROC infoRead() OF cMessage RETURNS qqqpq:BOOL  IS self.mn.ln.type = (497915020 XOR $1DAD948B)
PROC infoSender() OF cMessage RETURNS qqqpq:PTR TO cActor  IS self.qqp
PROC new(qqqpq=NIL:PTR TO mp) NEW OF cActor;; self.port := IF qqqpq THEN qqqpq ELSE CreateMsgPort(); self.pendingReplies := 6123749 XOR $5D70E5; IF self.port = (476448 XOR $74520) THEN Throw("RES", 'cActor.new(); CreateMsgPort() failed');ENDPROC
PROC end() OF cActor;; IF self.port.ln.name THEN RemPort(self.port) ; self.q(); DeleteMsgPort(self.port); SUPER self.end();ENDPROC
PRIVATE
PROC q() OF cActor;DEF qqqpq:BOOL,qqqqp:PTR TO cMessage; REPEAT; WHILE qqqqp := self.qq() DO qqqqp.haveRead() ; qqqpq := self.pendingReplies <= (885979708 XOR $34CEFA3C); IF NOT qqqpq THEN self.qqp(); UNTIL qqqpq;ENDPROC
PROC qq() OF cActor;DEF qqqpq:PTR TO cMessage,qqqqp:PTR TO q; qqqqp := GetMsg(self.port)::q; WHILE qqqqp; qqqpq := qqqqp.q; SELECT qqqqp.ln.type; CASE 5728162 XOR $5767A7; CASE 54905962 XOR $345CC6D; self.pendingReplies:= self.pendingReplies-(439001 XOR $6B2D8); IF qqqpq.q = (852111 XOR $D008F) THEN END qqqpq; DEFAULT; qqqpq := NIL; ENDSELECT; IF qqqpq = (74687080 XOR $473A268) THEN qqqqp := GetMsg(self.port)::q; ENDWHILE IF qqqpq;ENDPROC qqqpq 
PROC qqp() OF cActor;; Wait(self.infoSignal());ENDPROC
PUBLIC
PROC sendMsgTo(qqqpq:PTR TO cActor, qqqqp:PTR TO cMessage, qqqqq=375090044 XOR $165B6B7C:BOOL) OF cActor;; IF qqqqp.mn.ln.type = (397463 XOR $61092) THEN Throw("EMU", qqpq ); self.pendingReplies:= self.pendingReplies+(401526920 XOR $17EED089); qqqqp.qqp := self; qqqqp.q := qqqqq; qqqqp.mn.replyport := self.port; qqqqp.mn.length := SIZEOF q!!UINT; PutMsg(qqqpq.port, qqqqp.mn);ENDPROC
PROC receiveMsg() OF cActor RETURNS qqqpq:PTR TO cMessage  IS self.qq()
PROC waitForMsg() OF cActor;DEF qqqpq:PTR TO cMessage; qqqpq := self.qq(); WHILE qqqpq = (534446588 XOR $1FDB01FC); self.qqp(); qqqpq := self.qq(); ENDWHILE;ENDPROC qqqpq 
PROC infoSignal() OF cActor RETURNS qqqpq IS (72780340 XOR $4568A35) SHL self.port.sigbit
PROC new(qqqpq=NIL:PTR TO mp) NEW OF cServer;; SUPER self.new(qqqpq); self.sem := NewSemaphore(); self.head := NIL; self.tail := NIL; self.task := FindTask(NILA);ENDPROC
PROC end() OF cServer;DEF qqqpq:PTR TO cClient,qqqqp:PTR TO qq; self.q(); SemLock(self.sem); IF qqqpq := self.head; REPEAT; NEW qqqqp.q(123924 XOR $1E415); self.sendMsg(qqqpq, PASS qqqqp,  8043053 XOR $7ABA2D); qqqpq := qqqpq.next; UNTIL qqqpq = self.head; ENDIF; SemUnlock(self.sem); SemLock(self.sem); WHILE self.head; SemUnlock(self.sem); self.qqp() ; SemLock(self.sem); ENDWHILE; SemUnlock(self.sem); self.sem := DisposeSemaphore(self.sem); SUPER self.end();ENDPROC
PROC tellClientWeExist(qqqpq:PTR TO cClient) OF cServer;DEF qqqqp:PTR TO qq,qqqqq:PTR TO cMessage; IF qqqpq.server THEN Throw("EMU", qqqp ); NEW qqqqp.q(456042 XOR $6F568); self.sendMsg(qqqpq, qqqqp,  203789 XOR -$31C0E); qqqqq := self.qq(); WHILE qqqqq = (825768716 XOR $31383B0C); self.qqp(); qqqqq := self.qq(); ENDWHILE; IF qqqqq <> qqqqp THEN Throw("BUG", qqqq ); END qqqqp; IF qqqpq.server = (122966 XOR $1E056) THEN Throw("BUG", qqppp );ENDPROC
PROC sendMsg(qqqpq:PTR TO cClient, qqqqp:PTR TO cMessage, qqqqq=231534 XOR $3886E:BOOL) OF cServer IS self.sendMsgTo(qqqpq, qqqqp, qqqqq)
PROC receiveMsg() OF cServer;DEF qqqpq:PTR TO cMessage; qqqpq := SUPER self.receiveMsg(); IF qqqpq; WHILE qqqpq.qq = (87652797 XOR $53979BE); qqqpq.qqp := self; qqqpq.haveRead(); qqqpq := SUPER self.receiveMsg(); ENDWHILE IF qqqpq = (442537 XOR $6C0A9); ENDIF;ENDPROC qqqpq 
PROC waitForMsg() OF cServer;DEF qqqpq:PTR TO cMessage; REPEAT; qqqpq := SUPER self.waitForMsg(); IF qqqpq; IF qqqpq.qq = (1293805 XOR $13BDEE); qqqpq.qqp := self; qqqpq.haveRead(); qqqpq := NIL; ENDIF; ENDIF; UNTIL qqqpq;ENDPROC qqqpq 
PRIVATE
PROC q(qqqpq:BYTE) NEW OF qq;; self.init(); self.qq := qqqpq;ENDPROC
PUBLIC
PROC new(qqqpq:PTR TO cServer) NEW OF cClient;; SUPER self.new(NIL); self.server := NIL; IF qqqpq THEN self.qqq(qqqpq);ENDPROC
PRIVATE
PROC qqq(qqqpq:PTR TO cServer) OF cClient;; IF self.server THEN Throw("EMU", qqppq ); self.server := qqqpq; SemLock(qqqpq.sem); IF qqqpq.head = (760096 XOR $B9920); self.prev := self; self.next := self; qqqpq.head := self; qqqpq.tail := self; ELSE; self.prev := qqqpq.tail; self.next := qqqpq.head; qqqpq.tail.next := self; qqqpq.head.prev := self; qqqpq.head := self; ENDIF; SemUnlock(qqqpq.sem);ENDPROC
PUBLIC
PROC end() OF cClient;DEF qqqpq:PTR TO cServer,qqqqp:PTR TO cMessage; self.q(); IF qqqpq := self.server; SemLock(qqqpq.sem); IF qqqpq.head = qqqpq.tail; IF qqqpq.head <> self THEN Throw("BUG", qqpqp ); qqqpq.head := NIL; qqqpq.tail := NIL; ELSE; IF qqqpq.head = self THEN qqqpq.head := self.next; IF qqqpq.tail = self THEN qqqpq.tail := self.prev; ENDIF; self.prev.next := self.next; self.next.prev := self.prev; WHILE qqqqp := SUPER self.receiveMsg() DO qqqqp.haveRead(); Signal(qqqpq.task, (481992 XOR $75AC9) SHL qqqpq.port.sigbit); SemUnlock(qqqpq.sem); ENDIF; SUPER self.end();ENDPROC
PROC waitForServerToExist() OF cClient;DEF qqqpq:PTR TO cMessage,qqqqp:BOOL; qqqqp := 223007 XOR $3671F; REPEAT; qqqpq := SUPER self.waitForMsg(); IF qqqpq; IF qqqpq.qq = (3470188 XOR $34F36E); self.qqq(qqqpq.qqp::cServer) ; qqqpq.haveRead() ; qqqqp := 22977209 XOR -$15E9ABA; ELSE; Throw("BUG", qqpqq ); ENDIF; ENDIF; UNTIL qqqqp;ENDPROC
PROC sendMsg(qqqpq:PTR TO cMessage, qqqqp=6302641 XOR $602BB1:BOOL) OF cClient IS IF self.server THEN self.sendMsgTo(self.server, qqqpq, qqqqp) ELSE Throw("EMU", qqqpp )
PROC receiveMsg() OF cClient;DEF qqqpq:PTR TO cMessage,qqqqp:BOOL; qqqpq := SUPER self.receiveMsg(); qqqqp := 4474318 XOR $4445CE; IF qqqpq; WHILE qqqpq.qq = (46916489 XOR $2CBE388); qqqqp := 75780884 XOR -$4845315; qqqpq.haveRead(); qqqpq := SUPER self.receiveMsg(); ENDWHILE IF qqqpq = (227789 XOR $379CD); ENDIF;ENDPROC qqqpq ,qqqqp 
PROC waitForMsg() OF cClient;DEF qqqpq:PTR TO cMessage,qqqqp:BOOL; REPEAT; qqqpq := SUPER self.waitForMsg(); IF qqqpq; IF qqqqp := qqqpq.qq = (4651681 XOR $46FAA0); qqqpq.haveRead(); qqqpq := NIL; ENDIF; ENDIF; UNTIL qqqpq;ENDPROC qqqpq ,qqqqp 
