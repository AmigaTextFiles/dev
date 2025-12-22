/* cSnd.e 28-11-2015
	A concrete AmigaOS implementation of the cSndBase module.


Copyright (c) 2011, 2012, 2013, 2015 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
*/ /* TO DO:
 - Get stereo sound samples to work on MorphOS.
*/






OPT POINTER
PUBLIC MODULE 'targetShared/cSndBase','target/std/cApp'
MODULE 'dos','exec','intuition/classusr','utility/tagitem','devices/ahi','datatypes','CSH/pGeneral','CSH/pAmigaDatatypes','CSH/cNumberSpace','CSH/pAmiga_fakeNewProcess','CSH/cAmiga_ServerClients'
PRIVATE
CLASS q OF cServer;ENDCLASS
CLASS qq OF cClient;ENDCLASS
CLASS qqp OF cMessage;PRIVATE;q:BYTE;ENDCLASS
CLASS qqq OF cAppClient;PRIVATE;q:BOOL;qq:PTR TO tc;qqp;qqq:PTR TO qq ;qqpp:PTR TO q ;ENDCLASS
CLASS qqpp OF cSnd;PRIVATE;q:PTR TO qqqq ;qq;qqp;qqq:BOOL;qqpp;qqpq;qqqp:ARRAY OF BYTE;qqqq;qqppp;ENDCLASS
CLASS qqpq OF qqp;PRIVATE;qq:BOOL;ENDCLASS
CLASS qqqp OF qqp;PRIVATE;qq:PTR TO qqqq;ENDCLASS
CLASS qqqq;PRIVATE;q:PTR TO qqpp;qq:PTR TO qqqq ;qqp:PTR TO qqqq;qqq;qqpp;qqpq;qqqp;qqqq:PTR TO ahirequest;qqppp:PTR TO ahirequest;ENDCLASS
DEF q:BOOL,qq:PTR TO qqq,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR,qqpq:ARRAY OF CHAR,qqqp:ARRAY OF CHAR,qqqq:ARRAY OF CHAR,qqppp:ARRAY OF CHAR,qqppq:ARRAY OF CHAR,qqpqp:ARRAY OF CHAR,qqpqq:ARRAY OF CHAR,qqqpp:ARRAY OF CHAR,qqqpq:ARRAY OF CHAR,qqqqp:ARRAY OF CHAR,qqqqq:ARRAY OF CHAR,qqpppp:ARRAY OF CHAR,qqpppq:ARRAY OF CHAR,qqppqp:ARRAY OF CHAR,qqppqq:ARRAY OF CHAR,qqpqpp:ARRAY OF CHAR,qqpqpq:ARRAY OF CHAR
PROC new();; qqp := 'cGfx; exportPath(); path=NIL'; qqq := ':'; qqpp := 'cSnd; LoadSound(); cApp.build() must be called first'; qqpq := 'ERROR: Failed to load the sound \q\s\q.\n'; qqqp := 'Failed to load sound'; qqqq := 'cSnd; handleMessages(); wrong mode'; qqppp := 'cSnd sound server'; qqppq := 'cSnd; createServer(); first message was not Hello'; qqpqp := 'cMusic; ahiType(); unknown size'; qqpqq := 'cMusic; ahiType(); unknown size'; qqqpp := 'cSnd; soundServer(); unexpected play message mode'; qqqpq := 'cSnd; soundServer(); play=NIL'; qqqqp := 'cSnd; soundServer(); wrong play ahiIO'; qqqqq := 'cSndServer.receivePlayMsg(); unexpectedly received a Hello message'; qqpppp := 'cSndClient.receivePlayMsg(); unexpectedly received a Hello message'; qqpppq := 'cSndHost.load(); missing one or more sample buffers'; qqppqp := 'cSnd.play(); playCount<0'; qqppqq := 'cSnd.play(); speed<=0'; qqpqpp := 'cSnd.setVolume(); volume out of range (0 to 100)'; qqpqpq := 'cSnd.setPan(); pan out of range (-100 to 100)'; q := StrCmp(pe_TargetOS, 'MorphOS'); datatypesbase := OpenLibrary('datatypes.library', 34045 XOR $84DA); IF datatypesbase=(57052 XOR $DEDC) THEN CleanUp(1309956624 XOR $4E145A1A); NEW qq.new(); appHost.registerClient(qq);ENDPROC
PROC end();; END qq; CloseLibrary(datatypesbase);ENDPROC
PROC qq(qqpqqp:ARRAY OF CHAR) ;DEF qqpqqq:STRING,qqqppp,qqqppq,qqqpqp; IF qqpqqp = (97096056 XOR $5C99178) THEN Throw("EPU", qqp ); IF qqpqqp[StrLen(qqpqqp)-(151059 XOR $24E12)] = "/" = (502729 XOR $7ABC9);  qqqppq := StrLen(qqpqqp); ELSE;  qqqppq := StrLen(qqpqqp) - (109615268 XOR $68898A5) ; ENDIF; qqqpqp := qqqppq ; qqpqqq := NewString(qqqpqp); qqqppp := InStr(qqpqqp, qqq ); IF qqqppp = -(1702567 XOR $19FAA6); StrCopy(qqpqqq, qqpqqp, qqqppq); ELSE; StrCopy(qqpqqq, qqpqqp, qqqppp + (7178851 XOR $6D8A62)) ; StrAdd( qqpqqq, qqpqqp, qqqppq - qqqppp - (38770966 XOR $24F9914), qqqppp + (266517004 XOR $FE2BA0E)); ENDIF;ENDPROC qqpqqq 
PUBLIC
PROC LoadSound(qqpqqp:ARRAY OF CHAR, qqpqqq=524043 XOR $7FF0B:BOOL)  REPLACEMENT;DEF qqqppp:PTR TO cSnd ,qqqppq:PTR TO qqpp,qqqpqp:STRING; IF qq.q = (1314764024 XOR $4E5DB4F8) THEN Throw("EPU", qqpp ); qqqpqp := qq(qqpqqp); NEW qqqppq.q(); IF qqqppq.qqp(qqqpqp) = (350668 XOR $559CC); IF qqpqqq; RETURN NIL; ELSE; Print(qqpq , qqpqqp); Throw("ERR", qqqp ); ENDIF; ENDIF; qqqppp := qqqppq; qq.add(PASS qqqppq);FINALLY; END qqqppq, qqqpqp;ENDPROC qqqppp 
PROC DestroySound(qqpqqp:PTR TO cSnd)  REPLACEMENT;DEF qqpqqq:PTR TO cSnd ,qqqppp:PTR TO cAppResource; qqpqqq := NIL; IF qq = (42287507 XOR $2854193) THEN RETURN; IF qqpqqp = (169482 XOR $2960A) THEN RETURN; qqqppp := qq.rem(qqpqqp); END qqqppp;ENDPROC qqpqqq 
PROC WaitForSoundEvent()  REPLACEMENT;DEF qqpqqp:PTR TO cSnd ; qqpqqp := qqp(); WHILE qqpqqp = (437503 XOR $6ACFF); Wait(qq.qqq.infoSignal()); qqpqqp := qqp(); ENDWHILE;ENDPROC qqpqqp 
PROC CheckForSoundEvent()  REPLACEMENT;DEF qqpqqp:PTR TO cSnd ; qqpqqp := qqp();ENDPROC qqpqqp 
PRIVATE
PROC qqp() ;DEF qqpqqp:PTR TO cSnd,qqpqqq:PTR TO qqqp,qqqppp:BOOL,qqqppq:PTR TO qqqq; REPEAT; qqpqqq, qqqppp := qq.qqq.receivePlayMsg() ; IF qqpqqq; IF qqpqqq.q <> (221364 XOR $360B6) THEN Throw("BUG", qqqq ); qqqppq := qqpqqq.qq; qqpqqq.haveRead(); qq.qqp:= qq.qqp-(43443048 XOR $296E369); IF qq.qqp < (3716840 XOR $38B6E8) THEN qq.qqp := 2060564220 XOR $7AD1B6FC; qqpqqp := qqqppq.q; IF qqqppq.q.q = qqqppq; qqqppq.q.q := IF qqqppq.qqp = qqqppq THEN NIL ELSE qqqppq.qqp; ENDIF; END qqqppq ; ELSE; qqpqqp := NIL; IF qqqppp = (2491563 XOR $2604AB) THEN qq.qqp := 1867572960 XOR $6F50E6E0; ENDIF; UNTIL qqqppp = (371901 XOR $5ACBD);ENDPROC qqpqqp 
PROC qqq(qqpqqp:BYTE, qqpqqq:PTR TO qqqq) ;DEF qqqppp:PTR TO qqqp; NEW qqqppp.new(qqpqqp, qqpqqq);ENDPROC qqqppp 
PROC qqpp(qqpqqp:PTR TO qqq) ;DEF qqpqqq:BOOL,qqqppp:PTR TO qq,qqqppq:PTR TO qqp; qqqppp := qqpqqp.qqq; qqpqqp.qq := FindTask(NILA); createChildProcessFake(CALLBACK qqqq(), qqpqqp, qqppp , [4497879 XOR -$7FBB5DDE, qqpqqp.qq.ln.pri + (732045988 XOR $2BA222A5), 265854 XOR $40E7E,413470 XOR $64F1E]:tagitem) ; qqqppp.waitForServerToExist(); qqqppq := qqqppp.waitForMsg(); IF qqqppq.q <> (2846049 XOR -$2B6D62) THEN Throw("BUG", qqppq ); qqpqqq := qqqppq::qqpq.qq; qqqppq.haveRead();ENDPROC qqpqqq 
PROC qqpq(qqpqqp:PTR TO qqq);DEF qqpqqq:PTR TO qqpp; qqpqqq := qqpqqp.infoFirstResource(); WHILE qqpqqq; qqpqqq.stop(); WHILE qqpqqq.q DO WaitForSoundEvent(); qqpqqq := qqpqqq.qq(); ENDWHILE; qqpqqp.qqq.sendMsg(qqq(42126011 XOR $282CABF, NIL)); WHILE qqp() DO EMPTY; END qqpqqp.qqq; WHILE qqpqqp.qqpp DO Delay(307008 XOR $4AF41);ENDPROC
PROC qqqp(qqpqqp, qqpqqq:BOOL) ;DEF qqqppp; IF qqpqqq = (7167571 XOR $6D5E53); SELECT qqpqqp; CASE 458616 XOR $6FF70 ; qqqppp := 98699676 XOR $5E2099C; CASE 339515 XOR $52E2B ; qqqppp := 351838 XOR $55E5F; CASE 11342 XOR $2C6E ; qqqppp := 73008632 XOR $45A05F0; DEFAULT ; Throw("BUG", qqpqp ); ENDSELECT; ELSE; SELECT qqpqqp; CASE 46790608 XOR $2C9F7D8 ; qqqppp := 38716995 XOR $24EC641; CASE 339515 XOR $52E2B ; qqqppp := 351838 XOR $55E5D; CASE 11342 XOR $2C6E ; qqqppp := 1309956624 XOR $4E145A1A; DEFAULT ; Throw("BUG", qqpqq ); ENDSELECT; ENDIF;ENDPROC qqqppp 
PROC qqqq();DEF qqpqqp:PTR TO mp,qqpqqq:PTR TO ahirequest,qqqppp,qqqppq:PTR TO qqqq,qqqpqp:PTR TO qqqp,qqqpqq:PTR TO q,qqqqpp:PTR TO qqpq,qqqqpq:PTR TO qq,qqqqqp:PTR TO qqq,qqqqqq:BOOL,qqppppp,qqppppq:PTR TO mn,qqpppqp:PTR TO ahirequest,qqpppqq:PTR TO qqpp,qqppqpp:PTR TO cNumberSpace; qqqppp := -(97096056 XOR $5C99179); NEW qqppqpp.new() ; qqqqqp := infoParameterOfChildProcessFake() !!PTR TO qqq; qqqqpq := qqqqqp.qqq; NEW qqqqqp.qqpp.new(); qqqpqq := qqqqqp.qqpp; qqqpqq.tellClientWeExist(qqqqpq); qqpqqp := CreateMsgPort(); IF (151059 XOR $24E13)= qqpqqp THEN Raise("RES" ); qqpqqq := CreateIORequest(qqpqqp, SIZEOF ahirequest); IF (502729 XOR $7ABC9)= qqpqqq THEN Raise("MEM" ); qqpqqq.version := 109615268 XOR $68898A0; qqqppp := OpenDevice(ahiname, 1702567 XOR $19FAA7, qqpqqq !!PTR!!PTR TO io, NIL); IF qqqppp; NEW qqqqpp.new( 7178851 XOR -$6D8A64); qqqpqq.sendMsg(qqqqpq, PASS qqqqpp); RETURN; ELSE; NEW qqqqpp.new( 38770966 XOR $24F9916); qqqpqq.sendMsg(qqqqpq, PASS qqqqpp); ENDIF; qqqqqq := 266517004 XOR $FE2BA0C; REPEAT; qqppppp := Wait((802738660 XOR $2FD8C1E4) OR qqqpqq.infoSignal() OR ((7618181 XOR $743E84) SHL qqpqqp.sigbit)); IF qqppppp AND (802738660 XOR $2FD8C1E4); Signal(qqqqqp.qq, 802738660 XOR $2FD8C1E4); ENDIF; WHILE qqqpqp := qqqpqq.receivePlayMsg(); qqqppq := qqqpqp.qq; SELECT qqqpqp.q; CASE 7618181 XOR $743E86; qqqppq.qqq := 1091316560 XOR $410C2B51; IF qqqppq.qqqq THEN AbortIO(qqqppq.qqqq !!PTR!!PTR TO io) ; IF qqqppq.qqppp THEN AbortIO(qqqppq.qqppp !!PTR!!PTR TO io); CASE 1017374624 XOR $3CA3E7A1; qqpppqq := qqqppq.q; NEW qqqppq.qqqq; MemCopy(qqqppq.qqqq, qqpqqq, SIZEOF ahirequest); qqqppq.qqqq.iostd.mn.ln.pri := 146054 XOR $23A86; qqqppq.qqqq.iostd.command := 4739863 XOR $485314; qqqppq.qqqq.iostd.data := qqpppqq.qqqp; qqqppq.qqqq.iostd.length := qqpppqq.qqpp; qqqppq.qqqq.iostd.offset := 283474 XOR $45352; qqqppq.qqqq.frequency := qqqppq.qqqp; qqqppq.qqqq.type := qqqp(qqpppqq.qqp, qqpppqq.qqq); qqqppq.qqqq.volume := qqqppq.qqpp; qqqppq.qqqq.position := qqqppq.qqpq; qqqppq.qqqq.link := NIL; IF qqqppq.qqq <> (258069 XOR $3F014); NEW qqqppq.qqppp; MemCopy(qqqppq.qqppp, qqqppq.qqqq, SIZEOF ahirequest); ENDIF; SendIO(qqqppq.qqqq !!PTR!!PTR TO io); qqppqpp.set(qqqppq.qqqq, qqqppq); IF qqqppq.qqppp; qqqppq.qqppp.link := qqqppq.qqqq ; SendIO(qqqppq.qqppp !!PTR!!PTR TO io); qqppqpp.set(qqqppq.qqppp, qqqppq); ENDIF; CASE 7429382 XOR $715D02; qqqqqq := 76237379 XOR -$48B4A44; DEFAULT; Throw("BUG", qqqpp ); ENDSELECT; qqqpqp.haveRead(); ENDWHILE; WHILE qqppppq := GetMsg(qqpqqp); qqqppq := qqppqpp.get(qqppppq)::qqqq; IF qqqppq = (249775 XOR $3CFAF) THEN Throw("BUG", qqqpq ); IF qqqppq.qqqq <> qqppppq THEN Throw("BUG", qqqqp ); IF qqqppq.qqqq.iostd.error; qqqppq.qqq := 516902 XOR $7E327; ENDIF; IF qqqppq.qqq <> (132703772 XOR $7E8E61D); IF qqqppq.qqq >= (4287201 XOR $416AE3) THEN qqqppq.qqq:= qqqppq.qqq-(1211022920 XOR $482EBE49); qqpppqp := qqqppq.qqqq; qqqppq.qqqq := qqqppq.qqppp; qqqppq.qqppp := qqpppqp; qqqppq.qqppp.link := qqqppq.qqqq ; SendIO(qqqppq.qqppp !!PTR!!PTR TO io); ELSE; qqppqpp.delete(qqqppq.qqqq); END qqqppq.qqqq; IF qqqppq.qqppp; qqqppq.qqqq := PASS qqqppq.qqppp; ELSE; qqqqqp.qqp:= qqqqqp.qqp+(126437 XOR $1EDE4); qqqpqq.sendMsg(qqqqpq, qqq(483988 XOR $76296, qqqppq)); ENDIF; ENDIF; ENDWHILE; UNTIL qqqqqq;FINALLY; PrintException(); END qqqqpp; IF qqqqqp; END qqqqqp.qqpp ; ENDIF; END qqppqpp; IF qqqppp = (1714939860 XOR $6637E7D4); CloseDevice(qqpqqq !!PTR!!PTR TO io); ENDIF; IF qqpqqq THEN DeleteIORequest(qqpqqq !!PTR!!PTR TO io); IF qqpqqp THEN DeleteMsgPort(qqpqqp); exception:=1835362176 XOR $6D656780;ENDPROC
PUBLIC
PROC waitForMsg() OF q RETURNS qqpqqp:PTR TO qqp  IS SUPER self.waitForMsg()::qqp
PROC receivePlayMsg() OF q;DEF qqpqqp:PTR TO qqqp,qqpqqq:PTR TO qqp; qqpqqq := SUPER self.receiveMsg()::qqp; IF qqpqqq THEN IF qqpqqq.q = (97703290 XOR -$5D2D57B) THEN Throw("BUG", qqqqq ); qqpqqp := qqpqqq::qqqp;ENDPROC qqpqqp 
PROC waitForMsg() OF qq RETURNS qqpqqp:PTR TO qqp,qqpqqq:BOOL  IS SUPER self.waitForMsg()::qqp,qqpqqq 
PROC receiveMsg() OF qq RETURNS qqpqqp:PTR TO qqp,qqpqqq:BOOL  IS SUPER self.receiveMsg()::qqp,qqpqqq 
PROC receivePlayMsg() OF qq;DEF qqpqqp:PTR TO qqqp,qqpqqq:BOOL,qqqppp:PTR TO qqp; qqqppp, qqpqqq := SUPER self.receiveMsg()::qqp; IF qqqppp THEN IF qqqppp.q = (451374 XOR -$6E32F) THEN Throw("BUG", qqpppp ); qqpqqp := qqqppp::qqqp;ENDPROC qqpqqp ,qqpqqq 
PROC new() NEW OF qqq;; self.q := 3233621 XOR $315755; self.qqq := NIL; self.qqpp := NIL;ENDPROC
PROC end() OF qqq;; SUPER self.end() ; IF self.qqpp THEN qqpq(self);ENDPROC
PROC reset() OF qqq;; self.q := 825172 XOR $C9754;ENDPROC
PROC appIsBuilt(qqpqqp:PTR TO cApp) OF qqq;DEF qqpqqq:PTR TO cAppHost; qqpqqq := qqpqqp::cAppHost; IF self.qqpp = (5285130 XOR $50A50A); self.qqp := 80181442 XOR $4C778C2; NEW self.qqq.new( NIL); IF qqpp(self); END self.qqq; ENDIF; ENDIF; self.q := 896679 XOR -$DAEA8;ENDPROC
PROC infoFirstResource() OF qqq IS SUPER self.infoFirstResource()::qqpp
PRIVATE
PROC q() NEW OF qqpp;; self.q := NIL; self.qqqp := NILA; self.qqqq := 5314914 XOR $511906; self.qqppp := 675224760 XOR $283F1CB8;ENDPROC
PROC qq() OF qqpp RETURNS qqpqqp:PTR TO qqpp  IS self.next::qqpp
PROC qqp(qqpqqp:ARRAY OF CHAR) OF qqpp;DEF qqpqqq:BOOL,qqqppp:PTR TO INTUIOBJECT,qqqppq,qqqpqp,qqqpqq:ARRAY OF BYTE,qqqqpp:ARRAY OF BYTE,qqqqpq:ARRAY OF BYTE,qqqqqp:ARRAY OF BYTE,qqqqqq,qqppppp,qqppppq,qqpppqp; qqpqqq := 1522413592 XOR $5ABE3018; IF qq.qqpp = (128690698 XOR $7ABAA0A) THEN RETURN ; qqqppp := NewDTObjectA(qqpqqp, [101361564 XOR -$79F5487D,466819 XOR $73686AED, 53109573 XOR $32A6345,973859336 XOR $3A0BEA08]:tagitem); IF qqqppp = (56115345 XOR $3584091) THEN RETURN; GetDTAttrsA(qqqppp, [ IF q THEN (1874005192 XOR -$104CE2C4) + (11342 XOR $2C6E) ELSE (57807 XOR -$7FFF0FD0),ADDRESSOF  qqqppq, 483693 XOR -$7FF88F66,ADDRESSOF  qqqpqp, 449027 XOR -$7FF9340B,ADDRESSOF  qqqpqq, 29305106 XOR -$7E40C4ED,ADDRESSOF  qqqqpp, 53382070 XOR -$7CD1664C,ADDRESSOF  qqqqpq, 6647042 XOR $656D02,104916872 XOR $640E788]:tagitem); IF q; qqqqpp := NILA; qqqqpq := NILA; ENDIF; self.qq := qqqppq; self.qqp := bitsPerSampleOfSoundDT(qqqppp); self.qqq := qqqpqq = (130449405 XOR $7C67FFD); self.qqpp := qqqpqp; self.qqpq := (1902881948 XOR $716BAF74) * lengthOfSoundDT(qqqppp); IF qqqpqq; NEW self.qqqp[self.qqpp]; MemCopy(self.qqqp, qqqpqq, qqqpqp); ELSE IF qqqqpp <> (5370818 XOR $51F3C2)  AND (qqqqpq <> (641346752 XOR $263A2CC0)); self.qqpp := self.qqpp * (130216986 XOR $7C2F418); NEW self.qqqp[self.qqpp]; qqqqqp := self.qqqp; qqpppqp := self.qqp / (247282 XOR $3C5FA); qqqpqp := self.qqpp; qqqqqq := (qqppppp := 96794429 XOR $5C4F73D); WHILE qqppppp < qqqpqp; FOR qqppppq := 678164 XOR $A5915 TO qqpppqp; qqqqqp[qqppppp] := qqqqpp [qqqqqq]; qqqqqp[qqppppp+qqpppqp] := qqqqpq[qqqqqq]; qqppppp:= qqppppp+(403500 XOR $6282D); qqqqqq:= qqqqqq+(6867925 XOR $68CBD4); ENDFOR; qqppppp := qqppppp + qqpppqp; ENDWHILE; ELSE; Throw("BUG", qqpppq ); ENDIF; qqpqqq := 391724 XOR -$5FA2D;FINALLY; IF qqqppp THEN DisposeDTObject(qqqppp);ENDPROC qqpqqq 
PUBLIC
PROC end() OF qqpp;; IF self.q; self.stop(); WHILE self.q DO WaitForSoundEvent(); ENDIF; END self.qqqp; SUPER self.end();ENDPROC
PROC play(qqpqqp=115366 XOR $1C2A7, qqpqqq=5314914 XOR $511906) OF qqpp;DEF qqqppp:PTR TO qqqq,qqqppq:PTR TO qqqq; IF qqpqqp < (675224760 XOR $283F1CB8) THEN Throw("EMU", qqppqp ); IF qqpqqq <= (1522413592 XOR $5ABE3018) THEN Throw("EMU", qqppqq ); WHILE qq.qqp > (5314914 XOR $511906) DO qqp(); NEW qqqppp.new(self, qqpqqp, self.qqqq*(5270768 XOR $516CF0)/(5314914 XOR $511906), self.qqppp*(384634 XOR $55E7A)/(5314914 XOR $511906) + (384634 XOR $55E7A), self.qq * (5314914 XOR $511906) / qqpqqq); qqqppq := qqqppp; IF self.q = (675224760 XOR $283F1CB8); qqqppq.qq := qqqppq; qqqppq.qqp := PASS qqqppp; self.q := qqqppq; ELSE; qqqppq.qq := self.q.qq; qqqppq.qqp := PASS self.q.qq.qqp; self.q.qq.qqp := PASS qqqppp; self.q.qq := qqqppq; ENDIF; qq.qqq.sendMsg(qqq(1522413592 XOR $5ABE3019, qqqppq));ENDPROC
PROC stop() OF qqpp;DEF qqpqqp:PTR TO qqqq; IF qqpqqp := self.q; REPEAT; qq.qqq.sendMsg(qqq(128690698 XOR $7ABAA09, qqpqqp)); qqpqqp := qqpqqp.qqp; UNTIL qqpqqp = self.q; ENDIF;ENDPROC
PROC infoLength() OF qqpp RETURNS qqpqqp IS self.qqpq
PROC infoIsPlaying() OF qqpp;DEF qqpqqp:BOOL; IF self.q; qqp() ; ENDIF; qqpqqp := self.q <> (6882208 XOR $6903A0);ENDPROC qqpqqp 
PROC waitForPlayToFinish() OF qqpp;; WHILE self.q DO WaitForSoundEvent();ENDPROC
PROC setVolume(qqpqqp) OF qqpp;DEF qqpqqq:PTR TO cSnd; IF qqpqqp < (12321358 XOR $BC024E)  OR (qqpqqp > (5314914 XOR $511906)) THEN Throw("EMU", qqpqpp ); self.qqqq := qqpqqp; qqpqqq := self;ENDPROC qqpqqq 
PROC getVolume() OF qqpp RETURNS qqpqqp IS self.qqqq
PROC setPan(qqpqqp) OF qqpp;DEF qqpqqq:PTR TO cSnd; IF qqpqqp < -(5314914 XOR $511906)  OR (qqpqqp > (5314914 XOR $511906)) THEN Throw("EMU", qqpqpq ); self.qqppp := qqpqqp; qqpqqq := self;ENDPROC qqpqqq 
PROC getPan() OF qqpp RETURNS qqpqqp IS self.qqppp
PROC new(qqpqqp:BOOL) NEW OF qqpq;; self.init(); self.q := 675224760 XOR -$283F1CB9; self.qq := qqpqqp;ENDPROC
PROC new(qqpqqp:BYTE, qqpqqq:PTR TO qqqq) NEW OF qqqp;; self.init(); self.q := qqpqqp; self.qq := qqpqqq;ENDPROC
PROC new(qqpqqp:PTR TO qqpp, qqpqqq, qqqppp, qqqppq, qqqpqp) NEW OF qqqq;; self.q := qqpqqp; self.qq := NIL; self.qqp := NIL; self.qqq := qqpqqq; self.qqpp := qqqppp; self.qqpq := qqqppq; self.qqqp := qqqpqp; self.qqqq := NIL; self.qqppp := NIL;ENDPROC
PROC end() OF qqqq;; IF self.qqp THEN self.qqp.qq := self.qq; IF self.qq THEN self.qq.qqp := PASS self.qqp; SUPER self.end();ENDPROC
