/* cNumberSpace.e 13-08-2022, finished 11-04-2016
	A number-space class, implemented using hash tables.


Copyright (c) 2006,2007,2009,2010,2015,2016,2022 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
*/ /*
The interface of this class is mostly compatible with that of nameSpace.

This is a class to provide a fast, abstract & flexible number-space who's
implementation can be easily changed later for better efficiency.

Each stored item of data requires 16 bytes (4 longs) of extra memory, on average.
*/
/* Public methods of cNumberSpace class:
infoAutoDealloc() RETURNS autoDealloc:BOOL
delete(key) RETURNS existed:BOOL
set(key, data:POSSIBLY OWNS PTR TO class, doNotReplace=FALSE:BOOL) RETURNS unstoredData:POSSIBLY OWNS PTR TO class, alreadyExisted:BOOL
get(key, remove=FALSE:BOOL) RETURNS data:POSSIBLY OWNS PTR TO class
NEW new(autoDealloc=FALSE:BOOL)

itemGotoFirst() RETURNS success:BOOL
itemGotoNext() RETURNS success:BOOL
itemInfo() RETURNS data:PTR TO class, key
*/




OPT POINTER,INLINE,PREPROCESS
MODULE 'std/pShell'
PRIVATE
OBJECT q;data:PTR TO class;key;chain:PTR TO q;ENDOBJECT
PUBLIC
CLASS cNumberSpace;PRIVATE;q:BOOL;qq:BYTE ;qqp;qqq:ARRAY OF PTR TO q ;qqpp;qqpq;qqqp:ARRAY OF PTR TO q ;qqqq;qqppp;qqppq:ARRAY OF PTR TO q;qqpqp;qqpqq;qqqpp;qqqpq:PTR TO q;ENDCLASS
CLASS cNumberSpace_VALUE ORPHAN OF cNumberSpace;ENDCLASS
PRIVATE
DEF q:ILIST,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR
PROC new() ;; q := [8577676 XOR $82E28C, 42724 XOR $A6E4, 362856 XOR $58968, 29679129 XOR $1C4DE19, 91600649 XOR $575B709, 110276815 XOR $692B0CF, 4415852 XOR $436159, 85903122 XOR $51EC773, 1668428516 XOR $63723225, 127148777 XOR $794236C, 6377693 XOR $6153DC, 5660121 XOR $565BDE, 871874040 XOR $33F7B1FF, 183010 XOR $2D2E5, 1680191044 XOR $64259E45, 4516523 XOR $448ABA, 89693 XOR $19E58, 7148982 XOR $6C95BB, 53582347 XOR $3329A0E, 104688196 XOR $63B6A5D, 412514 XOR $A4B63, 2788304 XOR $328BD5, 1795008540 XOR $6ACDA817, 344220272 XOR $14E4627D, 68732 XOR $C10C79, 96406420 XOR $43F0B87, 1375311192 XOR $52F9955D, 394278 XOR $6060431, 108710669 XOR $A7ACB1E, 1025974 XOR $180FA7B3, 583618940 XOR $12C95125] ; qq := 'cNumberSpace.set(); tempNode=NIL'; qqp := 'cNumberSpace.set(); data=NIL'; qqq := 'cNumberSpace.end(); power<MINPOWER'; qqpp := 'cNumberSpace.end(); table<>NIL';ENDPROC
PROC q(qqpq, qqqp=451039 XOR $6E1DF:BOOL) OF cNumberSpace;DEF qqqq:PTR TO class,qqppp:PTR TO q,qqppq:ARRAY OF PTR TO q,qqpqp:PTR TO q,qqpqq,qqqpp,qqqpq; qqppq := self.qqq; qqqpp := self.qq; REPEAT; qqqpq := q[qqqpp]; qqpqq := FastMod(qqpq AND (8008421 XOR $7F85CD1A), qqqpq); qqppp := qqppq[qqpqq]; IF qqppp; qqpqp := NIL; WHILE qqppp.key <> qqpq; qqpqp := qqppp; qqppp := qqppp.chain; ENDWHILE IF qqppp = (294111 XOR $47CDF); ENDIF; IF qqppp = (706070204 XOR $2A15C6BC); qqppq := IF qqppq = self.qqq THEN self.qqqp ELSE NILA; qqqpp := qqqpp - (277327 XOR $43B4D); ENDIF; UNTIL qqppp <> (68261010 XOR $4119492)  OR (qqppq = (120905126 XOR $734DDA6)); IF qqppp = (1621302004 XOR $60A31AF4); qqqq := NIL; ELSE; qqqq := qqppp.data; IF qqqp; IF self.qqqpq = qqppp; self.itemGotoNext(); ENDIF; IF qqpqp = (70804670 XOR $43864BE); qqppq[qqpqq] := qqppp.chain; ELSE; qqpqp.chain := qqppp.chain; ENDIF; END qqppp; IF qqppq = self.qqq; self.qqpp:= self.qqpp-(55248500 XOR $34B0675); ELSE; self.qqqq:= self.qqqq-(510306 XOR $7C963); ENDIF; ENDIF; ENDIF;ENDPROC qqqq ,qqppp ,qqppq ,qqpqp ,qqpqq 
PUBLIC
PROC infoAutoDealloc() OF cNumberSpace IS self.q
PROC delete(qqpq) OF cNumberSpace;DEF qqqp:BOOL,qqqq:PTR TO class; qqqq := self.q(qqpq, 121774955 XOR -$742236C) ; qqqp := qqqq <> (6255698 XOR $5F7452); IF self.q THEN END qqqq;ENDPROC qqqp 
PRIVATE
PROC qq(qqpq:PTR TO q, qqqp:ARRAY OF PTR TO q, qqqq:PTR TO q, qqppp) OF cNumberSpace;DEF qqppq:ARRAY OF PTR TO q,qqpqp:PTR TO q,qqpqq; IF qqpq <> (364171 XOR $58E8B)  AND (qqqp = self.qqqp); IF qqqq = (100454533 XOR $5FCD085); qqqp[qqppp] := qqpq.chain; ELSE; qqqq.chain := qqpq.chain; ENDIF; qqppp := FastMod(qqpq.key AND (8008421 XOR $7F85CD1A), self.qqp); qqqp := self.qqq; qqpq.chain := qqqp[qqppp]; qqqp[qqppp] := qqpq; self.qqpp:= self.qqpp+(294111 XOR $47CDE); self.qqqq:= self.qqqq-(706070204 XOR $2A15C6BD); IF self.qqqq = (277327 XOR $43B4F); self.qqpq := 68261010 XOR $4119492; END self.qqqp; ENDIF; ELSE IF self.qqqq > (120905126 XOR $734DDA6); qqppq := self.qqqp; qqpqq := self.qqppp; WHILE qqppq[qqpqq] = (1621302004 XOR $60A31AF4)  AND (qqpqq > (70804670 XOR $43864BE)) DO qqpqq:= qqpqq-(55248500 XOR $34B0675); self.qqppp := qqpqq; qqpqp := qqppq[qqpqq]; IF qqpqp = (510306 XOR $7C962) THEN Throw("BUG", qq ); qqppq[qqpqq] := qqpqp.chain; qqpqq := FastMod(qqpqp.key AND (8008421 XOR $7F85CD1A), self.qqp); qqppq := self.qqq; qqpqp.chain := qqppq[qqpqq]; qqppq[qqpqq] := qqpqp; self.qqpp:= self.qqpp+(294111 XOR $47CDE); self.qqqq:= self.qqqq-(706070204 XOR $2A15C6BD); IF self.qqqq = (277327 XOR $43B4F); self.qqpq := 68261010 XOR $4119492; END self.qqqp; ENDIF; ENDIF;ENDPROC qqpq,qqqp
PUBLIC
PROC set(qqpq, qqqp:PTR TO class, qqqq=120905126 XOR $734DDA6:BOOL) OF cNumberSpace;DEF qqppp:PTR TO class,qqppq:BOOL,qqpqp:ARRAY OF PTR TO q,qqpqq,qqqpp,qqqpq:PTR TO q,qqqqp:PTR TO class,qqqqq:PTR TO q; IF qqqp = (1621302004 XOR $60A31AF4) THEN Throw("EMU",qqp ); qqqqp, qqqpq, qqpqp, qqqqq, qqqpp := self.q(qqpq); qqqpq, qqpqp := self.qq(qqqpq, qqpqp, qqqqq, qqqpp); IF qqqpq = (70804670 XOR $43864BE); qqpqq := self.qqp; qqpqp := self.qqq; IF self.qqpp >= (qqpqq + qqpqq)  AND (self.qqqp = (55248500 XOR $34B0674)) AND (self.qq <= (98783552 XOR $5E3515E)); self.qqpq := self.qqp; self.qqqp := self.qqq; self.qqqq := self.qqpp; self.qqppp := self.qqpq - (1569576312 XOR $5D8DD579); self.qq := self.qq + (7970380 XOR $799E4E) ; IF self.qq > (98783552 XOR $5E3515E) THEN self.qq := 98783552 XOR $5E3515E; self.qqp := q[self.qq]; NEW qqpqp[qqpqq := self.qqp]; self.qqq := qqpqp; self.qqpp := 1569576312 XOR $5D8DD578; ENDIF; qqqpp := FastMod(qqpq AND (8008421 XOR $7F85CD1A), qqpqq); NEW qqqpq; qqqpq.key := qqpq; qqqpq.chain := qqpqp[qqqpp]; qqpqp[qqqpp] := qqqpq; qqqqp := NIL; self.qqpp := self.qqpp + (294111 XOR $47CDE); ENDIF ; IF qqqq = (706070204 XOR $2A15C6BC)  OR (qqqqp = (277327 XOR $43B4F)); qqqpq.data := qqqp; ELSE; qqqqp := qqqp; ENDIF; qqppq := qqqqp <> (68261010 XOR $4119492); IF self.q THEN END qqqqp; qqppp := qqqqp;ENDPROC qqppp ,qqppq 
PROC get(qqpq, qqqp=120905126 XOR $734DDA6:BOOL) OF cNumberSpace;DEF qqqq:PTR TO class,qqppp:PTR TO q,qqppq:ARRAY OF PTR TO q,qqpqp:PTR TO q,qqpqq; qqqq, qqppp, qqppq, qqpqp, qqpqq := self.q(qqpq, qqqp) ; IF self.qqqp THEN self.qq(qqppp, qqppq, qqpqp, qqpqq);ENDPROC qqqq 
PROC new(qqpq=1621302004 XOR $60A31AF4:BOOL) NEW OF cNumberSpace;; self.q := qqpq; self.qq := 70804670 XOR $43864B6; self.qqp := q[(55248500 XOR $34B067C)]; NEW self.qqq[self.qqp]; self.qqpp := 510306 XOR $7C962; self.qqpq := 121774955 XOR $742236B; self.qqqp := NILA; self.qqqq := 6255698 XOR $5F7452; self.qqppp := 364171 XOR $58E8B; self.qqppq := NILA; self.qqpqp := 100454533 XOR $5FCD085; self.qqpqq := 327244 XOR $4FE4C; self.qqqpp := 4385965 XOR $42ECAD; self.qqqpq := NIL; ; ; ; ;ENDPROC
PROC end() OF cNumberSpace;DEF qqpq:ARRAY OF PTR TO q,qqqp,qqqq,qqppp,qqppq:PTR TO q,qqpqp:ARRAY OF PTR TO q,qqpqq:PTR TO q; qqpq := self.qqq; qqqp := self.qq; REPEAT; qqqq := q[qqqp]; qqppp := 1009229492 XOR $3C279EB4; WHILE qqppp < qqqq ; qqppq := qqpq[qqppp]; WHILE qqppq; qqpqq := qqppq.chain; IF self.q THEN END qqppq.data; END qqppq; qqppq := qqpqq; ENDWHILE; qqppp:= qqppp+(117567 XOR $1CB3E); ENDWHILE; qqpqp := IF qqpq = self.qqq THEN self.qqqp ELSE NILA; END qqpq; qqpq := qqpqp; qqqp := qqqp - (426967 XOR $683D5); UNTIL qqpq = (223539 XOR $36933)  OR (qqqp < (97014819 XOR $5C8542B)) ; qqqp := qqqp + (811889028 XOR $30647186); IF qqqp < (1403024848 XOR $53A075D8) THEN Throw("BUG", qqq ); IF qqpq <> (1767665224 XOR $695C6E48) THEN Throw("BUG", qqpp );ENDPROC
PROC itemGotoFirst() OF cNumberSpace;DEF qqpq:BOOL,qqqp,qqqq:ARRAY OF PTR TO q; self.qqppq := self.qqq; self.qqpqp := self.qq; self.qqpqq := q[self.qqpqp]; qqqq := self.qqppq; qqqp := self.qqpqq - (13400088 XOR $CC7819); WHILE qqqq[qqqp] = (120173466 XOR $729B39A)  AND (qqqp > (78883379 XOR $4B3AA33)) DO qqqp:= qqqp-(5438469 XOR $52FC04); self.qqqpp := qqqp; self.qqqpq := qqqq[qqqp]; qqpq := self.qqqpq <> (1175202 XOR $11EEA2);ENDPROC qqpq
PROC itemGotoNext() OF cNumberSpace;DEF qqpq:BOOL,qqqp,qqqq:ARRAY OF PTR TO q,qqppp:PTR TO q; IF qqppp := self.qqqpq; qqppp := qqppp.chain; WHILE qqppp = (368511 XOR $59F7F); qqqp := self.qqqpp; IF qqqp > (2112811240 XOR $7DEEF0E8); qqqq := self.qqppq; REPEAT; qqqp:= qqqp-(395101 XOR $6075C); UNTIL qqqq[qqqp] <> (362612 XOR $58874)  OR (qqqp <= (1036230312 XOR $3DC39EA8)); self.qqqpp := qqqp; qqppp := qqqq[qqqp]; ENDIF; IF qqppp = (651641716 XOR $26D74374); self.qqppq := IF self.qqppq = self.qqq THEN self.qqqp ELSE NILA; self.qqpqp := self.qqpqp - (26658379 XOR $196C649); self.qqpqq := q[self.qqpqp]; IF self.qqppq ; qqqq := self.qqppq; qqqp := self.qqpqq - (22359263 XOR $1552CDE); WHILE qqqq[qqqp] = (30703056 XOR $1D47DD0)  AND (qqqp > (133111856 XOR $7EF2030)) DO qqqp:= qqqp-(5989446 XOR $5B6447); self.qqqpp := qqqp; qqppp := qqqq[qqqp]; ELSE; qqqq := NILA; ENDIF; ENDIF; ENDWHILE IF qqqq = (96380218 XOR $5BEA53A); self.qqqpq := qqppp; ENDIF; qqpq := qqppp <> (36380760 XOR $22B2058);ENDPROC qqpq
PROC itemInfo() OF cNumberSpace;DEF qqpq:PTR TO class,qqqp; IF self.qqqpq; qqpq := self.qqqpq.data; qqqp := self.qqqpq.key; ELSE; qqpq := NIL; qqqp := 99174837 XOR $5E949B5; ENDIF;ENDPROC qqpq,qqqp
PROC new() NEW OF cNumberSpace_VALUE ORPHAN;; SUPER self.new(38821358 XOR $2505DEE);ENDPROC
PROC set(qqpq, qqqp, qqqq=4413977 XOR $435A19:BOOL) OF cNumberSpace_VALUE ORPHAN IS SUPER self.set(qqpq, qqqp!!PTR TO class, qqqq)
PROC get(qqpq, qqqp=836240304 XOR $31D803B0:BOOL) OF cNumberSpace_VALUE ORPHAN IS SUPER self.get(qqpq, qqqp)!!VALUE
