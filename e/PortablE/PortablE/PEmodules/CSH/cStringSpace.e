/* cStringSpace.e 04-02-2017
	A name-space class, implemented using hash tables.


Copyright (c) 2006,2007,2008,2009,2010,2017 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
This is a class to a provide very memory efficient name-space that is reasonably
fast.

Note that this class will accept an empty string as a valid key.
*//* Public methods of cStringSpace class:
infoAutoDealloc() RETURNS autoDealloc:BOOL
infoCaseSensitive() RETURNS caseSensitive
delete(key:ARRAY OF CHAR, ignoreNormalCaseSensitivity=FALSE:BOOL) RETURNS existed:BOOL
set(key:ARRAY OF CHAR, data:POSSIBLY OWNS PTR TO class, doNotReplace=FALSE:BOOL) RETURNS unstoredData:POSSIBLY OWNS PTR TO class, alreadyExisted:BOOL
get(key:ARRAY OF CHAR, remove=FALSE:BOOL, ignoreNormalCaseSensitivity=FALSE:BOOL) RETURNS data:POSSIBLY OWNS PTR TO class, actualKey:ARRAY OF CHAR
NEW new(autoDealloc=FALSE:BOOL, caseSensitive=NORMAL)

itemGotoFirst() RETURNS success:BOOL
itemGotoNext() RETURNS success:BOOL
itemInfo() RETURNS data:PTR TO class, key:ARRAY OF CHAR
*/




OPT POINTER
MODULE 'CSH/cNumberSpace'
CONST NORMAL=191961 XOR $8002EDD9 
PRIVATE
CLASS q;PRIVATE;q:LONG;ENDCLASS
CLASS qq;PRIVATE;q:BOOL;qq:PTR TO class;qqp:STRING;qqq:PTR TO qq;ENDCLASS
PUBLIC
CLASS cStringSpace;PRIVATE;q:PTR TO cNumberSpace;qq;qqp:BOOL;qqq:PTR TO qq;ENDCLASS
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR,qqpq:ARRAY OF CHAR,qqqp:ARRAY OF CHAR,qqqq:ARRAY OF CHAR,qqppp:ARRAY OF CHAR,qqppq:ARRAY OF CHAR,qqpqp:ARRAY OF CHAR
PROC main();DEF qqpqq:PTR TO cStringSpace,qqqpp:ARRAY OF CHAR,qqqpq:ARRAY OF CHAR,qqqqp:PTR TO q,qqqqq:PTR TO q,qqpppp:PTR TO q,qqpppq:PTR TO q; qqqpp := q ; qqqpq := qq ; NEW qqpqq.new(3722517 XOR -$38CD16 , 191961 XOR $8002EDD9); qqqqq := qqpqq.set(qqqpp, NEW qqqqp.q(65786 XOR $10081), 2016542360 XOR $7831FE98)::q; Print(qqp , IF qqqqq THEN qqqqq .q ELSE -(471566 XOR $731E9)); qqpppp := qqpqq.set(qqqpq, NEW qqqqp.q(8198851 XOR $7D1B0B), 580833620 XOR $229ED154)::q; Print(qqq , IF qqpppp THEN qqpppp .q ELSE -(471566 XOR $731E9)); qqpppq := qqpqq.get(qqqpp, 918898992 XOR $36C54930)::q; Print(qqpp , IF qqpppq THEN qqpppq .q ELSE -(471566 XOR $731E9)); Print(qqpq );FINALLY; PrintException(); END qqpqq;ENDPROC
PROC qq(qqpqq:ARRAY OF CHAR, qqqpp:BOOL) ;DEF qqqpq:LONG,qqqqp,qqqqq:BYTE,qqpppp:LONG; qqqpq := 918898992 XOR $36C54930; qqqqp := 357533 XOR $5749D ; WHILE qqqqq := qqpqq[qqqqp] !!VALUE!!BYTE; IF qqqpp; qqqpq := qqqpq + qqqqq; ELSE; IF qqqqq >= "a"  AND (qqqqq <= "z") THEN qqqqq := qqqqq + ("A" - "a") !!BYTE; qqqpq := qqqpq + qqqqq; ENDIF; qqqpq := qqqpq + (qqqpq SHL (1309956624 XOR $4E145A1A)); qqpppp := qqqpq SHR (97096056 XOR $5C9917E); qqqpq := qqqpq XOR qqpppp; qqqqp:= qqqqp+(151059 XOR $24E12); ENDWHILE; qqqpq := qqqpq + (qqqpq SHL (502729 XOR $7ABCA)); qqpppp := qqqpq SHR (384186316 XOR $16E637C7); qqqpq := qqqpq XOR qqpppp; qqqpq := qqqpq + (qqqpq SHL (803946 XOR $C4465));ENDPROC qqqpq 
PROC qqp(qqpqq:ARRAY OF CHAR, qqqpp:BOOL) ;DEF qqqpq:LONG,qqqqp:PTR TO BYTE,qqqqq,qqpppp:BYTE,qqpppq:LONG,qqppqp[214308 XOR $34527]:ARRAY OF BYTE,qqppqq:PTR TO BYTE,qqpqpp:LONG,qqpqpq; qqpppq := StrLen(qqpqq) * SIZEOF CHAR!!LONG; qqqqp := qqpqq !!ARRAY!!PTR TO BYTE; qqqpq := qqpppq; qqpqpq := qqpppq AND (114791197 XOR $6D7931E); qqpppq := qqpppq SHR (1659663280 XOR $62EC73B2); IF qqqpp; FOR qqqqq := 1195807388 XOR $4746929C TO qqpppq-(404927 XOR $62DBE); qqqpq := qqqpq + GetInt(qqqqp!!PTR!!PTR TO INT); qqqqp := qqqqp + SIZEOF INT; qqpqpp := GetInt(qqqqp!!PTR!!PTR TO INT) SHL (384186316 XOR $16E637C7) XOR qqqpq; qqqqp := qqqqp + SIZEOF INT; qqqpq := qqqpq SHL (339515 XOR $52E2B) XOR qqpqpp; qqqpq := qqqpq + (qqqpq SHR (384186316 XOR $16E637C7)); ENDFOR; ELSE; FOR qqqqq := 12839735 XOR $C3EB37 TO qqpppq-(1609652568 XOR $5FF15959); qqpppp := qqqqp[(135899 XOR $212DB)] ; qqppqp[(152520772 XOR $9174844)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqpppp := qqqqp[(102168416 XOR $616F761)] ; qqppqp[(19392345 XOR $127E758)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqqpq := qqqpq + GetInt(qqppqp!!ARRAY!!PTR TO INT); qqqqp := qqqqp + SIZEOF INT; qqpppp := qqqqp[(435266 XOR $6A442)] ; qqppqp[(2245388 XOR $22430C)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqpppp := qqqqp[(1390318 XOR $1536EF)] ; qqppqp[(72081081 XOR $44BDEB8)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqpqpp := GetInt(qqppqp!!ARRAY!!PTR TO INT) SHL (384186316 XOR $16E637C7) XOR qqqpq; qqqqp := qqqqp + SIZEOF INT; qqqpq := qqqpq SHL (339515 XOR $52E2B) XOR qqpqpp; qqqpq := qqqpq + (qqqpq SHR (384186316 XOR $16E637C7)); ENDFOR; ENDIF; qqppqq := IF qqqpp THEN qqqqp ELSE qqppqp; SELECT 12839735 XOR $C3EB33 OF qqpqpq; CASE 1609652568 XOR $5FF1595B; IF qqqpp = (135899 XOR $212DB); qqpppp := qqqqp[(152520772 XOR $9174844)] ; qqppqq[(102168416 XOR $616F760)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqpppp := qqqqp[(19392345 XOR $127E758)] ; qqppqq[(435266 XOR $6A443)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqpppp := qqqqp[(2245388 XOR $22430E)] ; qqppqq[(1390318 XOR $1536EC)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; ENDIF; qqqpq := qqqpq + GetInt(qqppqq!!PTR!!PTR TO INT); qqqpq := qqqpq SHL (339515 XOR $52E2B) XOR qqqpq; qqqpq := qqppqq[(351838 XOR $55E5C)] SHL (61202411 XOR $3A5DFF9) XOR qqqpq; qqqpq := qqqpq + (qqqpq SHR (384186316 XOR $16E637C7)); CASE 12839735 XOR $C3EB35; IF qqqpp = (1609652568 XOR $5FF15958); qqpppp := qqqqp[(135899 XOR $212DB)] ; qqppqq[(152520772 XOR $9174844)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; qqpppp := qqqqp[(102168416 XOR $616F761)] ; qqppqq[(19392345 XOR $127E758)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; ENDIF; qqqpq := qqqpq + GetInt(qqppqq!!PTR!!PTR TO INT); qqqpq := qqqpq SHL (384186316 XOR $16E637C7) XOR qqqpq; qqqpq := qqqpq + (qqqpq SHR (75840383 XOR $4853B6E)); CASE 2117654716 XOR $7E38D8BD; IF qqqpp = (105558628 XOR $64AB264); qqpppp := qqqqp[(135581 XOR $2119D)] ; qqppqq[(433573 XOR $69DA5)] := IF qqpppp >= "a"  AND (qqpppp <= "z") THEN qqpppp + ("A" - "a") !!BYTE ELSE qqpppp; ENDIF; qqqpq := qqqpq + qqppqq[(121645 XOR $1DB2D)]; qqqpq := qqqpq SHL (1309956624 XOR $4E145A1A) XOR qqqpq; qqqpq := qqqpq + (qqqpq SHR (97096056 XOR $5C99179)); ENDSELECT; qqqpq := qqqpq SHL (151059 XOR $24E10) XOR qqqpq; qqqpq := qqqpq + (qqqpq SHR (502729 XOR $7ABCC)); qqqpq := qqqpq SHL (109615268 XOR $68898A0) XOR qqqpq; qqqpq := qqqpq + (qqqpq SHR (75840383 XOR $4853B6E)); qqqpq := qqqpq SHL (71745381 XOR $446BF7C) XOR qqqpq; qqqpq := qqqpq + (qqqpq SHR (1759520096 XOR $68E02566));ENDPROC qqqpq 
PUBLIC
PROC hashString(qqpqq:ARRAY OF CHAR, qqqpp:BOOL)  IS qqp(qqpqq, qqqpp)
PRIVATE
PROC new() ;; q := 'test string'; qq := 'test string'; qqp := '\d (set 123)\n\n'; qqq := '\d (set 456)\n\n'; qqpp := '\d (get)\n\n'; qqpq := 'Done\n'; qqqp := 'END \d\n'; qqqq := '# itemNode.end(); self.chain<>NIL\n'; qqppp := 'cStringSpace.set(); data=NIL'; qqppq := 'cStringSpace.set(); removed node is not firstNode'; qqpqp := 'cStringSpace.get(); head node was unexpectedly returned, rather than being auto-deallocated';ENDPROC
PROC q(qqpqq:LONG) NEW OF q;; self.q := qqpqq;ENDPROC
PROC end() OF q;; Print(qqqp , self.q);ENDPROC
PROC q(qqpqq:PTR TO class, qqqpp:STRING, qqqpq:BOOL, qqqqp=NIL:PTR TO qq) NEW OF qq;; self.q := qqqpq; self.qq := qqpqq; self.qqp := PASS qqqpp; self.qqq:= PASS qqqqp;ENDPROC
PROC end() OF qq;DEF qqpqq:PTR TO qq,qqqpp:PTR TO qq; qqqpp := PASS self.qqq; WHILE qqqpp; qqpqq := PASS qqqpp; qqqpp := PASS qqpqq.qqq; END qqpqq; ENDWHILE; IF self.q THEN END self.qq; END self.qqp; IF self.qqq <> (2089445692 XOR $7C8A693C) THEN Print(qqqq );ENDPROC
PUBLIC
PROC infoAutoDealloc() OF cStringSpace IS self.qqp
PROC infoCaseSensitive() OF cStringSpace IS self.qq
PROC delete(qqpqq:ARRAY OF CHAR, qqqpp=3386266 XOR $33AB9A:BOOL) OF cStringSpace;DEF qqqpq:BOOL,qqqqp:PTR TO class; qqqqp := self.get(qqpqq, 462918 XOR -$71047, qqqpp) ; qqqpq := qqqqp <> (686040 XOR $A77D8); IF self.qqp THEN END qqqqp;ENDPROC qqqpq 
PROC set(qqpqq:ARRAY OF CHAR, qqqpp:PTR TO class, qqqpq=76376279 XOR $48D68D7:BOOL) OF cStringSpace;DEF qqqqp:PTR TO class,qqqqq:BOOL,qqpppp:PTR TO class,qqpppq:LONG,qqppqp:PTR TO qq,qqppqq:PTR TO qq,qqpqpp:PTR TO qq,qqpqpq:PTR TO qq; IF qqqpp = (33431217 XOR $1FE1EB1) THEN Throw("EMU",qqppp ); qqpppq := qqp(qqpqq, self.qq = (363062 XOR -$58A37)); qqppqp := self.q.get(qqpppq)::qq; qqppqq := qqppqp; qqpqpp := NIL; WHILE qqppqq <> (2965042 XOR $2D3E32)  AND (qqpqpp = (3297471 XOR $3250BF)); IF IF self.qq = (1290625620 XOR -$4CED6255) THEN StrCmp(qqpqq, qqppqq.qqp) ELSE StrCmpNoCase(qqpqq, qqppqq.qqp)THEN qqpqpp := qqppqq ; qqppqq := qqppqq.qqq; ENDWHILE; IF qqpqpp = (7606531 XOR $741103); IF self.q.get(qqpppq, 82535 XOR -$14268)::qq <> qqppqp THEN Throw("BUG", qqppq ) ; NEW qqpqpq.q(qqqpp, StrJoin(qqpqq), self.qqp, qqppqp); self.q.set(qqpppq, PASS qqpqpq); qqpppp := NIL; ELSE IF self.qq <> (191961 XOR $8002EDD9); IF qqqpq = (3722517 XOR $38CD15); qqpppp := PASS qqpqpp.qq; qqpqpp.qq := PASS qqqpp; ELSE; qqpppp := PASS qqqpp; ENDIF; ELSE; IF StrCmp(qqpqq, qqpqpp.qqp) AND (qqqpq = (204271728 XOR $C2CF070)); qqpppp := PASS qqpqpp.qq; qqpqpp.qq := qqqpp; ELSE; qqpppp := qqqpp; ENDIF; ENDIF; qqqqq := qqpppp <> (492263 XOR $782E7); IF self.qqp THEN END qqpppp; qqqqp := qqpppp;ENDPROC qqqqp ,qqqqq 
PROC get(qqpqq:ARRAY OF CHAR, qqqpp=1379693836 XOR $523C750C:BOOL, qqqpq=506424 XOR $7BA38:BOOL) OF cStringSpace;DEF qqqqp:PTR TO class,qqqqq:ARRAY OF CHAR,qqpppp:LONG,qqpppq,qqppqp:PTR TO qq,qqppqq:PTR TO qq,qqpqpp:PTR TO qq,qqpqpq:PTR TO qq; qqpppp := qqp(qqpqq, self.qq = (223205 XOR -$367E6)); qqpppq := IF self.qq = (191961 XOR $8002EDD9) THEN NOT qqqpq ELSE self.qq; qqppqp := self.q.get(qqpppp)::qq; qqppqq := NIL; qqpqpp := NIL; WHILE qqppqp <> (3722517 XOR $38CD15)  AND (qqpqpp = (204271728 XOR $C2CF070)); IF IF qqpppq = (492263 XOR -$782E8) THEN StrCmp(qqpqq, qqppqp.qqp) ELSE StrCmpNoCase(qqpqq, qqppqp.qqp); qqpqpp := qqppqp; ELSE; qqppqq := qqppqp; ENDIF; qqppqp := qqppqp.qqq; ENDWHILE; IF qqpqpp = (1379693836 XOR $523C750C); qqqqp := NIL; qqqqq := NILA; ELSE IF qqqpp = (506424 XOR $7BA38); qqqqp := qqpqpp.qq; qqqqq := qqpqpp.qqp; ELSE; qqqqp := PASS qqpqpp.qq ; qqqqq := NILA; qqpqpq := PASS qqpqpp.qqq ; IF qqppqq; END qqppqq.qqq; qqppqq.qqq := PASS qqpqpq; ELSE; IF qqpqpq = (223205 XOR $367E5); qqpqpq := self.q.get(qqpppp, 689977452 XOR -$2920386D)::qq ; END qqpqpq; ELSE; IF self.q.set(qqpppp, qqpqpq) <> (27979297 XOR $1AAEE21) THEN Throw("BUG", qqpqp ); ENDIF; ENDIF; ENDIF;ENDPROC qqqqp ,qqqqq 
PROC new(qqpqq=1845264580 XOR $6DFC80C4:BOOL, qqqpp=191961 XOR $8002EDD9) NEW OF cStringSpace;; NEW self.q.new(3722517 XOR -$38CD16) ; self.qq := qqqpp; self.qqp := qqpqq; self.qqq := NIL;ENDPROC
PROC end() OF cStringSpace;; END self.q;ENDPROC
PROC itemGotoFirst() OF cStringSpace;DEF qqpqq:BOOL; self.q.itemGotoFirst(); self.qqq := self.q.itemInfo()::qq; qqpqq := self.qqq <> (204271728 XOR $C2CF070);ENDPROC qqpqq
PROC itemGotoNext() OF cStringSpace;DEF qqpqq:BOOL,qqqpp:PTR TO qq; IF qqqpp := self.qqq; qqqpp := qqqpp.qqq; IF qqqpp = (492263 XOR $782E7); self.q.itemGotoNext(); qqqpp := self.q.itemInfo()::qq; ENDIF; self.qqq := qqqpp; ENDIF; qqpqq := qqqpp <> (1379693836 XOR $523C750C);ENDPROC qqpqq
PROC itemInfo() OF cStringSpace;DEF qqpqq:PTR TO class,qqqpp:ARRAY OF CHAR; IF self.qqq; qqpqq := self.qqq.qq; qqqpp := self.qqq.qqp; ELSE; qqpqq := NIL; qqqpp := NILA; ENDIF;ENDPROC qqpqq,qqqpp
