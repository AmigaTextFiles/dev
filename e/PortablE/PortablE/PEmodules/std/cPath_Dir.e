/* std/cPath.e 24-11-2013
	Caching class layer for portable dir access.


Copyright (c) 2007,2008,2009,2010,2011,2012,2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
*/ 





OPT INLINE
PUBLIC MODULE 'target/std/cPath_Dir'
MODULE 'target/std/cPath_shared','std/pShell'
PRIVATE
PUBLIC
CLASS cDir OF cHostDir;cacheAttr;cacheExtra:PTR TO cHostExtra;cacheExtraValid:BOOL ;cacheDirty:BYTE;diskSupports:BYTE ;diskName:STRING;ENDCLASS
CLASS funcRecurseFile OF function;ENDCLASS
CLASS funcRecurseDir OF funcRecurseFile;ENDCLASS
CLASS funcRecurseDirFailure OF funcRecurseDir;ENDCLASS
CLASS funcRecurseDirAbort OF function;ENDCLASS
PRIVATE
DEF q:BYTE,qq:STRING
PUBLIC
DEF funcRecurseFile:PTR TO funcRecurseFile,funcRecurseDir:PTR TO funcRecurseDir,funcRecurseDirFailure:PTR TO funcRecurseDirFailure,funcRecurseDirAbort:PTR TO funcRecurseDirAbort
PRIVATE
DEF qqp:PTR TO cHostDir,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR,qqpq:ARRAY OF CHAR,qqqp:ARRAY OF CHAR,qqqq:ARRAY OF CHAR,qqppp:ARRAY OF CHAR,qqppq:ARRAY OF CHAR,qqpqp:ARRAY OF CHAR,qqpqq:ARRAY OF CHAR,qqqpp:ARRAY OF CHAR
PROC new();; NEW funcRecurseFile .new(); NEW funcRecurseDir .new(); NEW funcRecurseDirFailure .new(); NEW funcRecurseDirAbort .new(); qqq := ''; qqpp := ''; qqpq := 'cDir.flush(); failed to set one of more of: attributes, extra'; qqqp := 'cDir.setAttributes(); dir opened in read only mode'; qqqq := 'not supported by disk'; qqppp := 'cDir.setAttributes()'; qqppq := 'not supported by host'; qqpqp := 'cDir.setExtra()'; qqpqq := 'not supported by host'; qqqpp := 'cDir.changeExtra()'; q := 8577676 XOR $82E28C; qq := NILS;ENDPROC
PROC end();; END qq;FINALLY; END funcRecurseDirAbort ; END funcRecurseDirFailure ; END funcRecurseDir ; END funcRecurseFile ;ENDPROC
PUBLIC
PROC RecurseDir(qqqpq:ARRAY OF CHAR, qqqqp:PTR TO funcRecurseFile, qqqqq=NIL:PTR TO funcRecurseDir, qqpppp=NIL:PTR TO funcRecurseDirFailure, qqpppq=NIL:PTR TO funcRecurseDirAbort);DEF qqppqp:STRING,qqppqq:STRING,qqpqpp:STRING,qqpqpq:PTR TO cHostDir,qqpqqp:PTR TO cDirEntryList,qqpqqq:ARRAY OF CHAR,qqqppp:STRING; NEW qqpqpq.new(); qqppqp := StrJoin(qqqpq); qqppqq := qqppqp; WHILE qqppqp <> (42724 XOR $A6E4); IF qqpqpq.open(qqppqp, 362856 XOR -$58969) ; qqpqqp := qqpqpq.makeEntryList(); IF qqpqqp.gotoFirst(); REPEAT; qqpqqq := qqpqqp.infoName(); qqqppp := StrJoin(qqppqp, qqpqqq); IF IsDir(qqpqqq); IF qqqqq THEN IF qqqqq.call(qqqppp) = (29679129 XOR $1C4DE19) THEN END qqqppp; IF qqqppp; qqpqpp := qqqppp; Link(qqppqq, PASS qqqppp); qqppqq := qqpqpp; ENDIF; ELSE; qqqqp.call(qqqppp); END qqqppp; ENDIF; UNTIL qqpqqp.gotoNext() = (91600649 XOR $575B709); ENDIF; END qqpqqp; qqpqpq.close(); ELSE; IF qqpppp; IF qqpppp.call(qqppqp, qqpqpq.infoFailureOrigin(), qqpqpq.infoFailureReason()) = (110276815 XOR $692B0CF) THEN RETURN; ENDIF; ENDIF; qqqppp := Next(qqppqp); Link(qqppqp, NILS); END qqppqp; qqppqp := PASS qqqppp; ENDWHILE IF CtrlC(); IF qqppqp <> (332484 XOR $512C4); IF qqpppq THEN qqpppq.call(qqppqp) ELSE Raise("BRK"); ENDIF;FINALLY; END qqppqp; END qqpqpq, qqpqqp; END qqqppp;ENDPROC
PROC DeleteDirPath(qqqpq:ARRAY OF CHAR, qqqqp=8073841 XOR $7B3271:BOOL) ;DEF qqqqq:BOOL; NEW qqp.new(); qqqqq := q(qqqpq, qqqqp);FINALLY; END qqp;ENDPROC qqqqq 
PRIVATE
PROC q(qqqpq:ARRAY OF CHAR, qqqqp:BOOL) ;DEF qqqqq:BOOL,qqpppp:PTR TO cHostDir,qqpppq:PTR TO cDirEntryList,qqppqp:STRING; qqppqp := ReadLink(qqqpq); IF qqppqp = (8219878 XOR $7D6CE6); qqpppp := qqp; IF qqpppp.open(qqqpq, 2641284 XOR -$284D85) = (659831524 XOR $27543AE4) THEN RETURN 497915020 XOR $1DAD948C ; qqpppq := qqpppp.makeEntryList(); qqpppp.close(); qqqqq := 6123749 XOR -$5D70E6; IF qqpppq.gotoFirst(); REPEAT; qqppqp := StrJoin(qqqpq, qqpppq.infoName()); IF FastIsFile(qqppqp); IF DeletePath( qqppqp, qqqqp) = (476448 XOR $74520) THEN qqqqq := 885979708 XOR $34CEFA3C; ELSE; IF q(qqppqp, qqqqp) = (5728162 XOR $5767A2) THEN qqqqq := 54905962 XOR $345CC6A; ENDIF; END qqppqp; UNTIL qqpppq.gotoNext() = (439001 XOR $6B2D9); ENDIF; ENDIF; IF DeletePath(qqqpq, qqqqp) = (852111 XOR $D008F) THEN qqqqq := 74687080 XOR $473A268;FINALLY; END qqpppq, qqppqp;ENDPROC qqqqq 
PUBLIC
PROC CreateDirs(qqqpq:ARRAY OF CHAR, qqqqp=375090044 XOR $165B6B7C:BOOL) ;DEF qqqqq:BOOL,qqpppp:STRING,qqpppq:STRING,qqppqp:STRING,qqppqq:PTR TO cHostDir; qqpppp := NILS; qqpppq := StrJoin(qqqpq); IF FastIsFile(qqpppq) OR qqqqp; qqppqp := PASS qqpppq; qqpppq := ExtractSubPath(qqppqp); END qqppqp; ENDIF; WHILE ExistsPath(qqpppq) = (397463 XOR $61097); qqppqp := ExtractName(qqpppq); Link(qqppqp, PASS qqpppp); qqpppp := PASS qqppqp; qqppqp := PASS qqpppq; qqpppq := ExtractSubPath(qqppqp); END qqppqp; ENDWHILE IF EstrLen(qqpppq) = (401526920 XOR $17EED088); NEW qqppqq.new(); WHILE qqpppp; qqppqp := StrJoin(qqpppq, qqpppp); END qqpppq; qqpppq := PASS qqppqp; IF qqqqq := qqppqq.open(qqpppq); qqppqq.close(); ELSE; RETURN; ENDIF; qqppqp := Next(qqpppp); Link(qqpppp, NILS); END qqpppp; qqpppp := PASS qqppqp; ENDWHILE; qqqqq := 534446588 XOR -$1FDB01FD;FINALLY; END qqpppp, qqpppq, qqppqp, qqppqq;ENDPROC qqqqq 
PROC new() NEW OF cDir;; SUPER self.new(); NEW self.cacheExtra.new(); self.diskSupports := 72780340 XOR $4568A34; self.diskName := NILS;ENDPROC
PROC end() OF cDir;; SUPER self.end(); END self.cacheExtra; END self.diskName;ENDPROC
PROC open(qqqpq:ARRAY OF CHAR, qqqqp=123924 XOR $1E414:BOOL, qqqqq=8043053 XOR $7ABA2D:BOOL) OF cDir;DEF qqpppp:BOOL; IF qqpppp := SUPER self.open(qqqpq, qqqqp, qqqqq); self.cacheAttr := SUPER self.getAttributes(); self.cacheExtraValid := 456042 XOR $6F56A; self.cacheExtra.setExtra(self); self.cacheExtraValid := 203789 XOR -$31C0E; self.cacheDirty := 825768716 XOR $31383B0C; IF qqqqp = (122966 XOR $1E056) THEN self.q(qqqpq); ENDIF;ENDPROC qqpppp 
PROC close() OF cDir;; IF self.readOnly = (231534 XOR $3886E) THEN self.flush(); SUPER self.close();ENDPROC
PRIVATE
PROC q(qqqpq:ARRAY OF CHAR) OF cDir;DEF qqqqp:STRING,qqqqq:STRING; qqqqq := ExpandPath(qqqpq); qqqqp := ExtractDevice(qqqqq); IF EstrLen(qqqqp) = (87652797 XOR $53979BD); END qqqqp; qqqqp := NEW ':/'; ENDIF; IF StrCmpPath(qqqqp, IF self.diskName THEN self.diskName ELSE qqq ); ELSE IF StrCmpPath(qqqqp, IF qq THEN qq ELSE qqpp ); END self.diskName; self.diskName := StrJoin(qq); self.diskSupports := q; ELSE; END self.diskName; self.diskName := PASS qqqqp; self.diskSupports := 442537 XOR $6C0A9; IF SUPER self.setAttributes(self.cacheAttr) THEN self.diskSupports := self.diskSupports OR (1293805 XOR $13BDEC); self.cacheExtraValid := 760096 XOR $B9920; IF SUPER self.setExtra(self.cacheExtra) THEN self.diskSupports := self.diskSupports OR (481992 XOR $75ACA); self.cacheExtraValid := 223007 XOR -$36720; END qq; qq := StrJoin(self.diskName); q := self.diskSupports; ENDIF;FINALLY; END qqqqp, qqqqq;ENDPROC
PUBLIC
PROC flush() OF cDir;DEF qqqpq:BOOL; IF self.readOnly = (3470188 XOR $34F36C); qqqpq := 22977209 XOR -$15E9ABA; IF self.cacheDirty AND (6302641 XOR $602BB3); self.cacheExtraValid := 4474318 XOR $4445CE; IF self.diskSupports AND (46916489 XOR $2CBE38B); qqqpq := qqqpq AND SUPER self.setExtra(self.cacheExtra); ELSE; IF SUPER self.setExtra(self.cacheExtra) = (75780884 XOR $4845314) THEN self.cacheExtra.setExtra(self) ; ENDIF; self.cacheExtraValid := 227789 XOR -$379CE; ENDIF; IF self.cacheDirty AND (4651681 XOR $46FAA0) THEN qqqpq := qqqpq AND SUPER self.setAttributes(self.cacheAttr) ; self.cacheDirty := 276775716 XOR $107F4324; IF qqqpq = (6310740 XOR $604B54) THEN Throw("FILE", qqpq ); ENDIF; SUPER self.flush(); IF self.readOnly; self.cacheAttr := SUPER self.getAttributes(); self.cacheExtraValid := 38048687 XOR $24493AF; self.cacheExtra.setExtra(self); self.cacheExtraValid := 172355 XOR -$2A144; ENDIF;ENDPROC
PROC setAttributes(qqqpq, qqqqp=-(110621014 XOR $697F157)) OF cDir;DEF qqqqq:BOOL,qqpppp; IF self.readOnly THEN Throw("EMU", qqqp ); IF self.diskSupports AND (169353344 XOR $A182081); qqqqp := qqqqp AND self.getAttributesSupported(); qqqpq := qqqpq AND qqqqp ; qqpppp := self.cacheAttr; qqpppp := qqpppp AND NOT qqqqp ; qqpppp := qqpppp OR qqqpq ; self.cacheAttr := qqpppp; self.cacheDirty := self.cacheDirty OR (4668919 XOR $473DF6); qqqqq := 6129776 XOR -$5D8871; ELSE; qqqqq := 1519883744 XOR $5A9795E0; self.failureReason := qqqq ; self.failureOrigin := qqppp ; ENDIF;ENDPROC qqqqq 
PROC getAttributes() OF cDir RETURNS qqqpq IS self.cacheAttr
PROC setExtra(qqqpq:PTR TO cExtra) OF cDir;DEF qqqqp:BOOL; qqqqp := self.cacheExtra.setExtra(qqqpq); self.cacheDirty := self.cacheDirty OR (1641341528 XOR $61D4E25A); IF qqqqp = (1846041008 XOR $6E0859B0); self.failureReason := qqppq ; self.failureOrigin := qqpqp ; ENDIF;ENDPROC qqqqp 
PROC getExtra() OF cDir RETURNS qqqpq:PTR TO cExtra  IS self.cacheExtra.getExtra()
PROC changeExtra(qqqpq:QUAD, qqqqp) OF cDir;DEF qqqqq:BOOL,qqpppp:BOOL; IF self.cacheExtraValid = (61369555 XOR $3A86CD3); qqqqq, qqpppp := SUPER self.changeExtra(qqqpq, qqqqp); ELSE; IF qqqpq = "SLNK"  OR (qqqpq = "HLNK") THEN self.flush() ; qqqqq, qqpppp := self.cacheExtra.changeExtra(qqqpq, qqqqp); self.cacheDirty := self.cacheDirty OR (1179800240 XOR $465252B2); IF qqqpq = "SLNK"  OR (qqqpq = "HLNK") THEN self.flush() ; IF qqqqq = (404766408 XOR $18203EC8); self.failureReason := qqpqq ; self.failureOrigin := qqqpp ; ENDIF; ENDIF;ENDPROC qqqqq ,qqpppp 
PROC queryExtra(qqqpq:QUAD) OF cDir;DEF qqqqp,qqqqq:BOOL; IF self.cacheExtraValid = (64959752 XOR $3DF3508); qqqqp, qqqqq := SUPER self.queryExtra(qqqpq); ELSE; qqqqp, qqqqq := self.cacheExtra.queryExtra(qqqpq); ENDIF;ENDPROC qqqqp ,qqqqq 
PROC make() OF cDir;DEF qqqpq:PTR TO cDir; NEW qqqpq;ENDPROC qqqpq 
PROC clone(qqqpq=348584 XOR $551A8:BOOL) OF cDir IS SUPER self.clone(qqqpq)::cDir
PROC call(qqqpq:STRING) OF funcRecurseFile IS EMPTY
PROC call(qqqpq:STRING) OF funcRecurseDir RETURNS qqqqp:BOOL  IS qqqqp 
PROC call(qqqpq:STRING, qqqqp=NILA:ARRAY OF CHAR, qqqqq=NILA:ARRAY OF CHAR) OF funcRecurseDirFailure RETURNS qqpppp:BOOL  IS qqpppp 
PROC call(qqqpq:STRING) OF funcRecurseDirAbort IS EMPTY
