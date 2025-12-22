/* cNumberSpace_safe.e 13-08-2022, finished 14-10-2011
	Modified cNumberSpace doesn't use multiple return values, and so is multi-thread safe.


Copyright (c) 2006,2007,2009,2010,2011,2022 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
set(key, data:POSSIBLY OWNS PTR TO class, doNotReplace=FALSE:BOOL, returnAlreadyExisted=NILA:ARRAY OF BOOL) RETURNS unstoredData:PTR TO class
get(key, remove=FALSE:BOOL) RETURNS data:POSSIBLY OWNS PTR TO class
NEW new(autoDealloc=FALSE:BOOL)

itemGotoFirst() RETURNS success:BOOL
itemGotoNext() RETURNS success:BOOL
itemInfo(returnKey=NILA:ARRAY OF VALUE) RETURNS data:PTR TO class
*/




OPT POINTER,INLINE,PREPROCESS
MODULE 'std/pShell'
PRIVATE
OBJECT q;data:PTR TO class;key;chain:PTR TO q;ENDOBJECT
PUBLIC
CLASS cNumberSpace;PRIVATE;q:BOOL;qq:BYTE ;qqp;qqq:ARRAY OF PTR TO q ;qqpp;qqpq;qqqp:ARRAY OF PTR TO q ;qqqq;qqppp;qqppq:ARRAY OF PTR TO q;qqpqp;qqpqq;qqqpp;qqqpq:PTR TO q;ENDCLASS
CLASS cNumberSpace_VALUE ORPHAN OF cNumberSpace;ENDCLASS
PRIVATE
TYPE PTR_TO_itemNode IS PTR TO q
DEF q:ILIST,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR
PROC new() ;; q := [8577676 XOR $82E28C, 42724 XOR $A6E4, 362856 XOR $58968, 29679129 XOR $1C4DE19, 91600649 XOR $575B709, 110276815 XOR $692B0CF, 4415852 XOR $436159, 85903122 XOR $51EC773, 1668428516 XOR $63723225, 127148777 XOR $794236C, 6377693 XOR $6153DC, 5660121 XOR $565BDE, 871874040 XOR $33F7B1FF, 183010 XOR $2D2E5, 1680191044 XOR $64259E45, 4516523 XOR $448ABA, 89693 XOR $19E58, 7148982 XOR $6C95BB, 53582347 XOR $3329A0E, 104688196 XOR $63B6A5D, 412514 XOR $A4B63, 2788304 XOR $328BD5, 1795008540 XOR $6ACDA817, 344220272 XOR $14E4627D, 68732 XOR $C10C79, 96406420 XOR $43F0B87, 1375311192 XOR $52F9955D, 394278 XOR $6060431, 108710669 XOR $A7ACB1E, 1025974 XOR $180FA7B3, 583618940 XOR $12C95125] ; qq := 'cNumberSpace.set(); tempNode=NIL'; qqp := 'cNumberSpace.set(); data=NIL'; qqq := 'cNumberSpace.end(); power<>MINPOWER'; qqpp := 'cNumberSpace.end(); table<>NIL';ENDPROC
PUBLIC
PROC findMatchingItem(qqpq, qqqp=451039 XOR $6E1DF:BOOL, qqqq=NILA:ARRAY OF PTR TO q, qqppp=NILA:ARRAY OF ARRAY OF PTR_TO_itemNode, qqppq=NILA:ARRAY OF PTR TO q, qqpqp=NILA:ARRAY OF VALUE) OF cNumberSpace;DEF qqpqq:PTR TO class,qqqpp:PTR TO q,qqqpq:ARRAY OF PTR TO q,qqqqp:PTR TO q,qqqqq,qqpppp,qqpppq; qqqpq := self.qqq; qqpppp := self.qq; REPEAT; qqpppq := q[qqpppp]; qqqqq := FastMod(qqpq AND (8008421 XOR $7F85CD1A), qqpppq); qqqpp := qqqpq[qqqqq]; IF qqqpp; qqqqp := NIL; WHILE qqqpp.key <> qqpq; qqqqp := qqqpp; qqqpp := qqqpp.chain; ENDWHILE IF qqqpp = (294111 XOR $47CDF); ENDIF; IF qqqpp = (706070204 XOR $2A15C6BC); qqqpq := IF qqqpq = self.qqq THEN self.qqqp ELSE NILA; qqpppp := qqpppp - (277327 XOR $43B4D); ENDIF; UNTIL qqqpp <> (68261010 XOR $4119492)  OR (qqqpq = (120905126 XOR $734DDA6)); IF qqqpp = (1621302004 XOR $60A31AF4); qqpqq := NIL; ELSE; qqpqq := qqqpp.data; IF qqqp; IF qqqqp = (70804670 XOR $43864BE); qqqpq[qqqqq] := qqqpp.chain; ELSE; qqqqp.chain := qqqpp.chain; ENDIF; END qqqpp; IF qqqpq = self.qqq; self.qqpp:= self.qqpp-(55248500 XOR $34B0675); ELSE; self.qqqq:= self.qqqq-(510306 XOR $7C963); ENDIF; ENDIF; ENDIF; IF qqqq THEN qqqq[(121774955 XOR $742236B)] := qqqpp; IF qqppp THEN qqppp [(6255698 XOR $5F7452)] := qqqpq; IF qqppq THEN qqppq[(364171 XOR $58E8B)] := qqqqp; IF qqpqp THEN qqpqp [(100454533 XOR $5FCD085)] := qqqqq;ENDPROC qqpqq 
PROC infoAutoDealloc() OF cNumberSpace IS self.q
PROC delete(qqpq) OF cNumberSpace;DEF qqqp:BOOL,qqqq:PTR TO class; qqqq := self.findMatchingItem(qqpq, 327244 XOR -$4FE4D) ; qqqp := qqqq <> (4385965 XOR $42ECAD); IF self.q THEN END qqqq;ENDPROC qqqp 
PRIVATE
PROC q(qqpq:PTR TO q, qqqp:ARRAY OF PTR TO q, qqqq:PTR TO q, qqppp) OF cNumberSpace;DEF qqppq:ARRAY OF PTR TO q,qqpqp:PTR TO q,qqpqq; IF qqpq <> (1009229492 XOR $3C279EB4)  AND (qqqp = self.qqqp); IF qqqq = (117567 XOR $1CB3F); qqqp[qqppp] := qqpq.chain; ELSE; qqqq.chain := qqpq.chain; ENDIF; qqppp := FastMod(qqpq.key AND (8008421 XOR $7F85CD1A), self.qqp); qqqp := self.qqq; qqpq.chain := qqqp[qqppp]; qqqp[qqppp] := qqpq; self.qqpp:= self.qqpp+(294111 XOR $47CDE); self.qqqq:= self.qqqq-(706070204 XOR $2A15C6BD); IF self.qqqq = (277327 XOR $43B4F); self.qqpq := 68261010 XOR $4119492; END self.qqqp; ENDIF; ELSE IF self.qqqq > (120905126 XOR $734DDA6); qqppq := self.qqqp; qqpqq := self.qqppp; WHILE qqppq[qqpqq] = (1621302004 XOR $60A31AF4)  AND (qqpqq > (70804670 XOR $43864BE)) DO qqpqq:= qqpqq-(55248500 XOR $34B0675); self.qqppp := qqpqq; qqpqp := qqppq[qqpqq]; IF qqpqp = (510306 XOR $7C962) THEN Throw("BUG", qq ); qqppq[qqpqq] := qqpqp.chain; qqpqq := FastMod(qqpqp.key AND (8008421 XOR $7F85CD1A), self.qqp); qqppq := self.qqq; qqpqp.chain := qqppq[qqpqq]; qqppq[qqpqq] := qqpqp; self.qqpp:= self.qqpp+(294111 XOR $47CDE); self.qqqq:= self.qqqq-(706070204 XOR $2A15C6BD); IF self.qqqq = (277327 XOR $43B4F); self.qqpq := 68261010 XOR $4119492; END self.qqqp; ENDIF; ENDIF;ENDPROC qqpq,qqqp
PUBLIC
PROC set(qqpq, qqqp:PTR TO class, qqqq=120905126 XOR $734DDA6:BOOL, qqppp=NILA:ARRAY OF BOOL) OF cNumberSpace;DEF qqppq:PTR TO class,qqpqp:BOOL,qqpqq:ARRAY OF PTR TO q,qqqpp,qqqpq,qqqqp:PTR TO q,qqqqq:PTR TO class,qqpppp:PTR TO q; IF qqqp = (1621302004 XOR $60A31AF4) THEN Throw("EMU",qqp ); qqqqq := self.findMatchingItem(qqpq, 70804670 XOR $43864BE, ADDRESSOF  qqqqp, ADDRESSOF  qqpqq, ADDRESSOF  qqpppp, ADDRESSOF  qqqpq); qqqqp, qqpqq := self.q(qqqqp, qqpqq, qqpppp, qqqpq); IF qqqqp = (55248500 XOR $34B0674); qqqpp := self.qqp; qqpqq := self.qqq; IF self.qqpp >= (qqqpp + qqqpp)  AND (self.qqqp = (510306 XOR $7C962)) AND (self.qq <= (98783552 XOR $5E3515E)); self.qqpq := self.qqp; self.qqqp := self.qqq; self.qqqq := self.qqpp; self.qqppp := self.qqpq - (1569576312 XOR $5D8DD579); self.qq := self.qq + (7970380 XOR $799E4E) ; IF self.qq > (98783552 XOR $5E3515E) THEN self.qq := 98783552 XOR $5E3515E; self.qqp := q[self.qq]; NEW qqpqq[qqqpp := self.qqp]; self.qqq := qqpqq; self.qqpp := 1569576312 XOR $5D8DD578; ENDIF; qqqpq := FastMod(qqpq AND (8008421 XOR $7F85CD1A), qqqpp); NEW qqqqp; qqqqp.key := qqpq; qqqqp.chain := qqpqq[qqqpq]; qqpqq[qqqpq] := qqqqp; qqqqq := NIL; self.qqpp := self.qqpp + (294111 XOR $47CDE); ENDIF ; IF qqqq = (706070204 XOR $2A15C6BC)  OR (qqqqq = (277327 XOR $43B4F)); qqqqp.data := qqqp ; ELSE; qqqqq := qqqp; ENDIF; qqpqp := qqqqq <> (68261010 XOR $4119492); IF self.q THEN END qqqqq; qqppq := qqqqq; IF qqppp THEN qqppp[(120905126 XOR $734DDA6)] := qqpqp;ENDPROC qqppq 
PROC get(qqpq, qqqp=1621302004 XOR $60A31AF4:BOOL) OF cNumberSpace;DEF qqqq:PTR TO class,qqppp:PTR TO q,qqppq:ARRAY OF PTR TO q,qqpqp:PTR TO q,qqpqq; qqqq := self.findMatchingItem(qqpq, qqqp, ADDRESSOF  qqppp, ADDRESSOF  qqppq, ADDRESSOF  qqpqp, ADDRESSOF  qqpqq) ; IF self.qqqp THEN self.q(qqppp, qqppq, qqpqp, qqpqq);ENDPROC qqqq 
PROC new(qqpq=70804670 XOR $43864BE:BOOL) NEW OF cNumberSpace;; self.q := qqpq; self.qq := 55248500 XOR $34B067C; self.qqp := q[(510306 XOR $7C96A)]; NEW self.qqq[self.qqp]; self.qqpp := 121774955 XOR $742236B; self.qqpq := 6255698 XOR $5F7452; self.qqqp := NILA; self.qqqq := 364171 XOR $58E8B; self.qqppp := 100454533 XOR $5FCD085; self.qqppq := NILA; self.qqpqp := 327244 XOR $4FE4C; self.qqpqq := 4385965 XOR $42ECAD; self.qqqpp := 1009229492 XOR $3C279EB4; self.qqqpq := NIL; ; ; ; ;ENDPROC
PROC end() OF cNumberSpace;DEF qqpq:ARRAY OF PTR TO q,qqqp,qqqq,qqppp,qqppq:PTR TO q,qqpqp:ARRAY OF PTR TO q,qqpqq:PTR TO q; qqpq := self.qqq; qqqp := self.qq; REPEAT; qqqq := q[qqqp]; qqppp := 117567 XOR $1CB3F; WHILE qqppp < qqqq ; qqppq := qqpq[qqppp]; WHILE qqppq; qqpqq := qqppq.chain; IF self.q THEN END qqppq.data; END qqppq; qqppq := qqpqq; ENDWHILE; qqppp:= qqppp+(426967 XOR $683D6); ENDWHILE; qqpqp := IF qqpq = self.qqq THEN self.qqqp ELSE NILA; END qqpq; qqpq := qqpqp; qqqp := qqqp - (223539 XOR $36931); UNTIL qqpq = (97014819 XOR $5C85423)  OR (qqqp < (811889028 XOR $3064718C)) ; qqqp := qqqp + (1403024848 XOR $53A075D2); IF qqqp <> (1767665224 XOR $695C6E40) THEN Throw("BUG", qqq ); IF qqpq <> (13400088 XOR $CC7818) THEN Throw("BUG", qqpp );ENDPROC
PROC itemGotoFirst() OF cNumberSpace;DEF qqpq:BOOL,qqqp,qqqq:ARRAY OF PTR TO q; self.qqppq := self.qqq; self.qqpqp := self.qq; self.qqpqq := q[self.qqpqp]; qqqq := self.qqppq; qqqp := self.qqpqq - (120173466 XOR $729B39B); WHILE qqqq[qqqp] = (78883379 XOR $4B3AA33)  AND (qqqp > (5438469 XOR $52FC05)) DO qqqp:= qqqp-(1175202 XOR $11EEA3); self.qqqpp := qqqp; self.qqqpq := qqqq[qqqp]; qqpq := self.qqqpq <> (368511 XOR $59F7F);ENDPROC qqpq
PROC itemGotoNext() OF cNumberSpace;DEF qqpq:BOOL,qqqp,qqqq:ARRAY OF PTR TO q,qqppp:PTR TO q; IF qqppp := self.qqqpq; qqppp := qqppp.chain; WHILE qqppp = (2112811240 XOR $7DEEF0E8); qqqp := self.qqqpp; IF qqqp > (395101 XOR $6075D); qqqq := self.qqppq; REPEAT; qqqp:= qqqp-(362612 XOR $58875); UNTIL qqqq[qqqp] <> (1036230312 XOR $3DC39EA8)  OR (qqqp <= (651641716 XOR $26D74374)); self.qqqpp := qqqp; qqppp := qqqq[qqqp]; ENDIF; IF qqppp = (26658379 XOR $196C64B); self.qqppq := IF self.qqppq = self.qqq THEN self.qqqp ELSE NILA; self.qqpqp := self.qqpqp - (22359263 XOR $1552CDD); self.qqpqq := q[self.qqpqp]; IF self.qqppq ; qqqq := self.qqppq; qqqp := self.qqpqq - (30703056 XOR $1D47DD1); WHILE qqqq[qqqp] = (133111856 XOR $7EF2030)  AND (qqqp > (5989446 XOR $5B6446)) DO qqqp:= qqqp-(96380218 XOR $5BEA53B); self.qqqpp := qqqp; qqppp := qqqq[qqqp]; ELSE; qqqq := NILA; ENDIF; ENDIF; ENDWHILE IF qqqq = (36380760 XOR $22B2058); self.qqqpq := qqppp; ENDIF; qqpq := qqppp <> (99174837 XOR $5E949B5);ENDPROC qqpq
PROC itemInfo(qqpq=NILA:ARRAY OF VALUE) OF cNumberSpace;DEF qqqp:PTR TO class,qqqq; IF self.qqqpq; qqqp := self.qqqpq.data; qqqq := self.qqqpq.key; ELSE; qqqp := NIL; qqqq := 38821358 XOR $2505DEE; ENDIF; IF qqpq THEN qqpq[(4413977 XOR $435A19)] := qqqq;ENDPROC qqqp 
PROC new() NEW OF cNumberSpace_VALUE ORPHAN;; SUPER self.new(836240304 XOR $31D803B0);ENDPROC
PROC set(qqpq, qqqp, qqqq=220099 XOR $35BC3:BOOL, qqppp=NILA:ARRAY OF BOOL) OF cNumberSpace_VALUE ORPHAN IS SUPER self.set(qqpq, qqqp!!PTR TO class, qqqq, qqppp)
PROC get(qqpq, qqqp=4565615 XOR $45AA6F:BOOL) OF cNumberSpace_VALUE ORPHAN IS SUPER self.get(qqpq, qqqp)!!VALUE
