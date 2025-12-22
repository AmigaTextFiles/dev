/* pString.e 04-09-2017
	A collection of procedures for advanced manipulation of strings.


Copyright (c) 1999,2000,2002,2004,2005,2006,2008,2009,2010,2011,2012,2013,2014,2016,2017 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
mergeSort(unsorted:OWNS STRING, sortFunc:PTR TO fMergeSortCompare) RETURNS sorted:OWNS STRING
       translateStr(input:ARRAY OF CHAR, dictionary:ARRAY OF ARRAY OF CHAR,       inputLength=0, noChangeReturnNILS=FALSE:BOOL, inputOffset=0) RETURNS output:OWNS STRING
dynamicTranslateStr(input:ARRAY OF CHAR, dictionary:ARRAY OF translateDictionary, inputLength=0, noChangeReturnNILS=FALSE:BOOL, inputOffset=0) RETURNS output:OWNS STRING
joinTranslateDictionarys(array:ARRAY OF ARRAY OF translateDictionary) RETURNS dictionary:OWNS ARRAY OF translateDictionary
joinSeveralTranslateDictionarys(dict1:ARRAY OF translateDictionary, dict2:ARRAY OF translateDictionary) RETURNS dictionary:OWNS ARRAY OF translateDictionary
*//* Public functions:
	fMergeSortCompare( firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR) RETURNS order:RANGE -1 TO 1
	fMergeSort_NoCase( firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR) RETURNS order:RANGE -1 TO 1	->case-insensitive sort (optimised)
	fMergeSort_Case(   firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR) RETURNS order:RANGE -1 TO 1	->case-sensitive sort (optimised)
	fMergeSort_Numeric(firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR) RETURNS order:RANGE -1 TO 1	->parse & sort as numbers (optimised)
	
	fTranslateMatcher(input:ARRAY OF CHAR, startPos, dictionary:PTR TO translateDictionary) RETURNS matchPos, matchLen, replaceLen, replaceStr:OWNS STRING
	fTranslateAdder(  input:ARRAY OF CHAR, matchPos, dictionary:PTR TO translateDictionary, output:STRING)
	
	fSimpleTranslateMatcher(input:ARRAY OF CHAR, startPos, dictionary:PTR TO translateDictionary) RETURNS matchPos, matchLen, replaceLen, replaceStr:OWNS STRING
	 fDummyTranslateMatcher(input:ARRAY OF CHAR, startPos, dictionary:PTR TO translateDictionary) RETURNS matchPos, matchLen, replaceLen, replaceStr:OWNS STRING
*/

MODULE 'CSH/pGeneral','CSH/cMegaList','CSH/cMiniList'
CLASS fMergeSortCompare OF function;ENDCLASS
CLASS fMergeSort_NoCase OF fMergeSortCompare;ENDCLASS
CLASS fMergeSort_Case OF fMergeSortCompare;ENDCLASS
CLASS fMergeSort_Numeric OF fMergeSortCompare;ENDCLASS
PRIVATE
OBJECT q OF oMegaNode;matchPos;dictIndex;inputLen;outputLen;replaceStr:STRING;ENDOBJECT
CLASS qq UNGENERIC OF cMegaMiniListGeneric;ENDCLASS
PUBLIC
CLASS matchList OF cMegaListGeneric;ENDCLASS
PRIVATE
CLASS qqp OF cMegaCursorGeneric;ENDCLASS
PUBLIC
CLASS fCompareMegaNodes_match OF fCompareMegaNodes;ENDCLASS
CLASS fTranslateMatcher OF function;ENDCLASS
CLASS fTranslateAdder OF function;ENDCLASS
OBJECT translateDictionary;matchFunc:PTR TO fTranslateMatcher;matchStr:ARRAY OF CHAR ;addFunc:PTR TO fTranslateAdder ;paramValue;paramArray:ARRAY;paramPtr:PTR TO object;ENDOBJECT
CLASS fSimpleTranslateMatcher OF fTranslateMatcher;ENDCLASS
CLASS fFixedTranslateMatcher OF fTranslateMatcher;ENDCLASS
CLASS fFixedTranslateAdder OF fTranslateAdder;ENDCLASS
CLASS fDummyTranslateMatcher OF fTranslateMatcher;ENDCLASS
PRIVATE
TYPE MATCHNODES IS PTR TO oMiniNodeFloating;TYPE ARRAY_OF_translateDictionary IS ARRAY OF translateDictionary
PUBLIC
DEF fMergeSortCompare:PTR TO fMergeSortCompare,fMergeSort_NoCase:PTR TO fMergeSort_NoCase,fMergeSort_Case:PTR TO fMergeSort_Case,fMergeSort_Numeric:PTR TO fMergeSort_Numeric,fCompareMegaNodes_match:PTR TO fCompareMegaNodes_match,fTranslateMatcher:PTR TO fTranslateMatcher,fTranslateAdder:PTR TO fTranslateAdder,fSimpleTranslateMatcher:PTR TO fSimpleTranslateMatcher,fFixedTranslateMatcher:PTR TO fFixedTranslateMatcher,fFixedTranslateAdder:PTR TO fFixedTranslateAdder,fDummyTranslateMatcher:PTR TO fDummyTranslateMatcher
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR
PUBLIC
PROC mergeSort(qqpp:STRING, qqpq:PTR TO fMergeSortCompare) ;DEF qqqp:STRING,qqqq,qqppp:STRING,qqppq:STRING,qqpqp:RANGE -1 TO 1,qqpqq:BOOL,qqqpp:STRING,qqqpq:STRING,qqqqp,qqqqq:STRING,qqpppp:STRING,qqpppq; IF qqpp = (8577676 XOR $82E28C) THEN RETURN; qqqq := 42724 XOR $A6E5; qqqpp := PASS qqpp; REPEAT; qqpqq := 362856 XOR -$58969; REPEAT; qqqqp := 29679129 XOR $1C4DE19; qqpppp := qqqpp; REPEAT; qqqqp:= qqqqp+(91600649 XOR $575B708); qqqpq := qqpppp; qqpppp := Next(qqqpq); UNTIL qqqqp >= qqqq  OR (qqpppp = (110276815 XOR $692B0CF)); qqqqq := LinkReplace(qqqpq, NILS) ; IF qqqqq <> (332484 XOR $512C4) THEN qqpqq := 8073841 XOR $7B3271; qqpppq := 8219878 XOR $7D6CE6; WHILE qqqqq <> (2641284 XOR $284D84)  AND (qqpppq < qqqq); IF qqqpp = (659831524 XOR $27543AE4) ; qqpqp := -(497915020 XOR $1DAD948D); ELSE IF qqpq = fMergeSort_NoCase ; qqpqp := OstrCmpNoCase(qqqpp, qqqqq); ELSE IF qqpq = fMergeSort_Case ; qqpqp := OstrCmp(qqqpp, qqqqq); ELSE IF qqpq = fMergeSort_Numeric ; qqpqp := Sign(Val(qqqqq) - Val(qqqpp)); ELSE ; qqpqp := qqpq.call(qqqpp, qqqqq); ENDIF; IF qqpqp >= (6123749 XOR $5D70E5) ; qqppq := PASS qqqpp; qqqpp := LinkReplace(qqppq, NILS); ELSE; qqppq := PASS qqqqq; qqqqq := LinkReplace(qqppq, NILS); qqpppq:= qqpppq+(476448 XOR $74521); ENDIF; qqqp, qqppp := q(PASS qqqp, qqppp, PASS qqppq); ENDWHILE; IF qqqpp THEN qqqp, qqppp := qq(PASS qqqp, qqppp, PASS qqqpp, qqqpq) ; qqqpp := PASS qqqqq; UNTIL qqqpp = (885979708 XOR $34CEFA3C)  OR qqpqq; qqqq := qqqq + qqqq; qqqpp := PASS qqqp; UNTIL qqpqq; qqqp := PASS qqqpp;FINALLY; IF exception THEN END qqqp; END qqppq; END qqqpp; END qqqqq;ENDPROC qqqp 
PRIVATE
PROC new() ;; NEW fMergeSortCompare .new(); NEW fMergeSort_NoCase .new(); NEW fMergeSort_Case .new(); NEW fMergeSort_Numeric .new(); NEW fCompareMegaNodes_match .new(); NEW fTranslateMatcher .new(); NEW fTranslateAdder .new(); NEW fSimpleTranslateMatcher .new(); NEW fFixedTranslateMatcher .new(); NEW fFixedTranslateAdder .new(); NEW fDummyTranslateMatcher .new(); q := 'pString; dynamicTranslateStr(); closestMatchPos=-1'; qq := 'dynamicTranslateStr(); next match is before current position (1)'; qqp := 'dynamicTranslateStr(); next match is before current position (2)'; qqq := 'translateStr(); dictionary is not an even number of items (pairs)';ENDPROC
PROC end() ;;FINALLY; END fDummyTranslateMatcher ; END fFixedTranslateAdder ; END fFixedTranslateMatcher ; END fSimpleTranslateMatcher ; END fTranslateAdder ; END fTranslateMatcher ; END fCompareMegaNodes_match ; END fMergeSort_Numeric ; END fMergeSort_Case ; END fMergeSort_NoCase ; END fMergeSortCompare ;ENDPROC
PROC q(qqpp:STRING, qqpq:STRING, qqqp:STRING);; IF qqpp = (5728162 XOR $5767A2); qqpp := PASS qqqp; qqpq := qqpp; ELSE; qqpq := LinkAppend(qqpq, PASS qqqp); ENDIF;ENDPROC qqpp,qqpq
PROC qq(qqpp:STRING, qqpq:STRING, qqqp:STRING, qqqq:STRING);; IF qqpp = (54905962 XOR $345CC6A); qqpp := PASS qqqp; qqpq := qqqq; ELSE; Link(qqpq, PASS qqqp); qqpq := qqqq; ENDIF;ENDPROC qqpp,qqpq
PUBLIC
PROC dynamicTranslateStr(qqpp:ARRAY OF CHAR, qqpq:ARRAY OF translateDictionary, qqqp=439001 XOR $6B2D9, qqqq=852111 XOR $D008F:BOOL, qqppp=74687080 XOR $473A268) ;DEF qqppq:STRING,qqpqp:PTR TO translateDictionary,qqpqq:PTR TO matchList,qqqpp,qqqpq,qqqqp:PTR TO matchList,qqqqq,qqpppp,qqpppq,qqppqp,qqppqq:PTR TO q,qqpqpp,qqpqpq,qqpqqp:STRING,qqpqqq:PTR TO q,qqqppp:PTR TO qqp,qqqppq; qqpppp := qqppp; qqqpp := 375090044 XOR $165B6B7C ; WHILE qqpq[qqqpp].matchFunc <> (397463 XOR $61097); qqpqp := qqpq[qqqpp]; qqqpq := IF qqpqp.matchStr = (401526920 XOR $17EED088) THEN qqpppp ELSE InStr(qqpp, qqpqp.matchStr, qqpppp); IF qqqpq = -(534446588 XOR $1FDB01FD); qqpppq := -(72780340 XOR $4568A35); ELSE; qqpppq, qqpqpp, qqpqpq, qqpqqp := qqpqp.matchFunc.call(qqpp, qqqpq, qqpqp) ; ENDIF; IF qqpppq <> -(123924 XOR $1E415); IF qqpqq = (8043053 XOR $7ABA2D) THEN NEW qqpqq.new( 456042 XOR $6F56A,  NIL,  -(203789 XOR $31C0C),  825768716 XOR $31383B0C,  122966 XOR $1E056,  231534 XOR $3886E,  NILS) ; qqpqq.append(qqpppq,  qqqpp,  qqpqpp, qqpqpq, PASS qqpqqp); ENDIF; qqqpp:= qqqpp+(87652797 XOR $53979BC); ENDWHILE; IF qqpqq = (442537 XOR $6C0A9); IF qqqq; RETURN; ELSE; IF qqqp = (1293805 XOR $13BDED) THEN qqqp := StrLen(qqpp); NEW qqppq[qqqp]; StrCopy(qqppq, qqpp); RETURN; ENDIF; ENDIF; qqpqq.sort() ; NEW qqqqp.new( 760096 XOR $B9920,  NIL,  -(481992 XOR $75AC9),  -(223007 XOR $3671F),  3470188 XOR $34F36C,  22977209 XOR $15E9AB9,  NILS); qqqppp := qqpqq.infoStart().clone( 6302641 XOR $602BB0); IF qqqp = (4474318 XOR $4445CE) THEN qqqp := StrLen(qqpp); qqqqq := qqqp - qqppp; WHILE qqpqq.infoIsEmpty() = (46916489 XOR $2CBE389); qqppqq := qqpqq.infoStart().infoMiniNode() ; qqppqp := qqppqq.matchPos; IF qqppqp = -(75780884 XOR $4845315) THEN Throw("BUG", q ); qqqqp.append(qqppqp, qqppqq.dictIndex, qqppqq.inputLen, qqppqq.outputLen, PASS qqppqq.replaceStr); qqpppp := qqppqp + qqppqq.inputLen; qqqqq := qqqqq - qqppqq.inputLen + qqppqq.outputLen; qqpqqq := qqpqq.infoStart().infoMiniNode(); REPEAT; END qqpqqq.replaceStr; qqqpp := qqpqqq.dictIndex; qqpqp := qqpq[qqqpp]; qqqpq := IF qqpqp.matchStr = (227789 XOR $379CD) THEN qqpppp ELSE InStr(qqpp, qqpqp.matchStr, qqpppp); IF qqqpq = -(4651681 XOR $46FAA0); qqpqqq.matchPos := -(276775716 XOR $107F4325); ELSE; qqpqqq.matchPos, qqpqqq.inputLen, qqpqqq.outputLen, qqpqqq.replaceStr := qqpqp.matchFunc.call(qqpp, qqqpq, qqpqp); ENDIF; IF qqpqqq.matchPos <> -(6310740 XOR $604B55); qqqppp.sortedInsert( qqpqq.infoStart().remove() ); ELSE; qqpqq.infoStart().destroy(); ENDIF; qqpqqq := qqpqq.infoStart().infoMiniNode(); UNTIL qqpqqq.matchPos >= qqpppp  OR (qqpqqq.matchPos = -(38048687 XOR $24493AE)); ENDWHILE; NEW qqppq[qqqqq]; qqpppp := qqppp; IF qqqqp.infoIsEmpty() = (172355 XOR $2A143); END qqqppp; qqqppp := qqqqp.infoStart().clone(); REPEAT; qqpqqq := qqqppp.infoMiniNode(); qqqppq := qqpqqq.matchPos - qqpppp; IF qqqppq > (110621014 XOR $697F156) THEN StrAdd(qqppq, qqpp, qqqppq, qqpppp); IF qqqppq < (169353344 XOR $A182080) THEN Throw("BUG", qq ); IF qqpqqq.replaceStr; StrAdd(qqppq, qqpqqq.replaceStr); ELSE; qqqpp := qqpqqq.dictIndex; qqpq[qqqpp].addFunc.call(qqpp, qqpqqq.matchPos, qqpq[qqqpp], qqppq); ENDIF; qqpppp := qqpqqq.matchPos + qqpqqq.inputLen; UNTIL  qqqppp.next(); ENDIF; qqqppq := qqqp - qqpppp; IF qqqppq > (4668919 XOR $473DF7) THEN StrAdd(qqppq, qqpp, qqqppq, qqpppp); IF qqqppq < (6129776 XOR $5D8870) THEN Throw("BUG", qqp );FINALLY; IF exception THEN END qqppq; END qqpqq; END qqqqp, qqpqqp; END qqqppp;ENDPROC qqppq 
PROC joinTranslateDictionarys(qqpp:ARRAY OF ARRAY OF translateDictionary) ;DEF qqpq:ARRAY OF translateDictionary,qqqp,qqqq,qqppp,qqppq,qqpqp:ARRAY OF translateDictionary,qqpqq:PTR TO translateDictionary,qqqpp:PTR TO translateDictionary,qqqpq,qqqqp; qqqp := 1519883744 XOR $5A9795E0; qqqq := 1641341528 XOR $61D4E258; qqqpq := qqqq; qqqq:= qqqq+(1846041008 XOR $6E0859B1); WHILE qqpqp := qqpp[qqqpq ]; qqppp := 61369555 XOR $3A86CD3; WHILE qqpqp[qqppp].matchFunc <> (1179800240 XOR $465252B0) DO qqppp:= qqppp+(404766408 XOR $18203EC9); qqqp := qqqp + qqppp; qqqpq := qqqq; qqqq:= qqqq+(64959752 XOR $3DF3509); ENDWHILE; NEW qqpq[qqqp+(348584 XOR $551A9)]; qqppq := 3925 XOR $F55; qqqq := 1206976312 XOR $47F0FF38; qqqqp := qqqq; qqqq:= qqqq+(1158630340 XOR $450F4BC5); WHILE qqpqp := qqpp[qqqqp ]; qqppp := 18947 XOR $4A03; WHILE qqpqp[qqppp].matchFunc <> (7537784 XOR $730478); qqpqq := qqpqp[qqppp]; qqqpp := qqpq[qqppq]; qqqpp.matchFunc := qqpqq.matchFunc; qqqpp.matchStr := qqpqq.matchStr; qqqpp. addFunc := qqpqq. addFunc; qqqpp.paramValue := qqpqq.paramValue; qqqpp.paramArray := qqpqq.paramArray; qqqpp.paramPtr := qqpqq.paramPtr; qqppq:= qqppq+(79024240 XOR $4B5D071); qqppp:= qqppp+(169293 XOR $2954C); ENDWHILE; qqqqp := qqqq; qqqq:= qqqq+(48513454 XOR $2E441AF); ENDWHILE; qqpq[qqqp].matchFunc := NIL ;ENDPROC qqpq 
PROC joinSeveralTranslateDictionarys(qqpp:ARRAY OF translateDictionary, qqpq:ARRAY OF translateDictionary) ;DEF qqqp:ARRAY OF translateDictionary; qqqp := joinTranslateDictionarys([ qqpp, qqpq, NILA]:ARRAY_OF_translateDictionary);ENDPROC qqqp 
PROC translateStr(qqpp:ARRAY OF CHAR, qqpq:ARRAY OF ARRAY OF CHAR, qqqp=34619441 XOR $2104031, qqqq=360123 XOR $57EBB:BOOL, qqppp=1809373888 XOR $6BD8DAC0) ;DEF qqppq:STRING,qqpqp:ARRAY OF translateDictionary,qqpqq,qqqpp,qqqpq:PTR TO translateDictionary; qqqpp := 602661 XOR $93225; WHILE qqpq[qqqpp] <> (1919618 XOR $1D4A82) DO qqqpp:= qqqpp+(134264 XOR $20C79); qqqpp, qqpqq := Mod(qqqpp, 25740732 XOR $188C5BE); IF qqqpp <> (738740 XOR $B45B4) THEN Throw("EPU", qqq ); NEW qqpqp[qqpqq+(316900 XOR $4D5E5)]; FOR qqqpp := 1294021660 XOR $4D21341C TO qqpqq-(32704124 XOR $1F3067D); qqqpq := qqpqp[qqqpp]; qqqpq.matchFunc := fFixedTranslateMatcher; qqqpq.matchStr := qqpq[qqqpp*(4661058 XOR $471F40)]; qqqpq.addFunc := fFixedTranslateAdder; qqqpq.paramArray := qqpq[qqqpp*(1656171776 XOR $62B72D02)+(115108926 XOR $6DC6C3F)]; ENDFOR; qqpqp[qqpqq].matchFunc := NIL; qqppq := dynamicTranslateStr(qqpp, qqpqp, qqqp, qqqq, qqppp);FINALLY; END qqpqp;ENDPROC qqppq 
PROC call(qqpp:ARRAY OF CHAR, qqpq:ARRAY OF CHAR) OF fMergeSortCompare RETURNS qqqp:RANGE -1 TO 1 IS qqqp 
PROC call(qqpp:ARRAY OF CHAR, qqpq:ARRAY OF CHAR) OF fMergeSort_NoCase RETURNS qqqp:RANGE -1 TO 1 IS OstrCmpNoCase(qqpp, qqpq)
PROC call(qqpp:ARRAY OF CHAR, qqpq:ARRAY OF CHAR) OF fMergeSort_Case RETURNS qqqp:RANGE -1 TO 1 IS OstrCmp(qqpp, qqpq)
PROC call(qqpp:ARRAY OF CHAR, qqpq:ARRAY OF CHAR) OF fMergeSort_Numeric RETURNS qqqp:RANGE -1 TO 1 IS Sign(Val(qqpq) - Val(qqpp))
PROC new(qqpp:PTR TO cMegaListGeneric, qqpq:MININODES, qqqp=164071 XOR $280E7, qqqq=3716266 XOR $38B4AA, qqppp=1564878444 XOR $5D46266C, qqppq=192611 XOR $2F063, qqpqp=NILS:STRING) NEW OF qq;; self.container := qqpp; IF qqpq = (404008992 XOR $1814B020) THEN qqpq := self.makeNode(qqqp, qqqq, qqppp, qqppq, qqpqp); SUPER self.new(qqpq);ENDPROC
PROC makeNode(qqpp, qqpq, qqqp, qqqq=1071229392 XOR $3FD9A9D0, qqppp=NILS:STRING) OF qq;DEF qqppq:MININODES,qqpqp:PTR TO oMegaNode; qqpqp := self.node_make(); self.node_new(qqpqp, qqpp, qqpq, qqqp, qqqq, qqppp); qqppq := qqpqp;ENDPROC qqppq 
PROC node_clone(qqpp:PTR TO oMiniNode) OF qq;DEF qqpq:PTR TO q; qqpq := SUPER self.node_clone(qqpp)::q; qqpq.matchPos := qqpp::q.matchPos; qqpq.dictIndex := qqpp::q.dictIndex; qqpq.inputLen := qqpp::q.inputLen; qqpq.outputLen := qqpp::q.outputLen; qqpq.replaceStr:= StrClone(qqpp::q.replaceStr);ENDPROC qqpq 
PROC node_endContents(qqpp:PTR TO oMiniNode) OF qq;; SUPER self.node_endContents(qqpp); END qqpp::q.replaceStr;ENDPROC
PROC node_new(qqpp:PTR TO oMiniNode, qqpq=261060 XOR $3FBC4, qqqp=4719806 XOR $4804BE, qqqq=493534 XOR $787DE, qqppp=61140720 XOR $3A4EEF0, qqppq=NILS:STRING) OF qq;DEF qqpqp:PTR TO q; SUPER self.node_new(qqpp); qqpqp := qqpp::q; qqpqp.matchPos := qqpq; qqpqp.dictIndex := qqqp; qqpqp.inputLen := qqqq; qqpqp.outputLen := qqppp; qqpqp.replaceStr:= PASS qqppq;ENDPROC
PROC make() OF qq;DEF qqpp:PTR TO qq; NEW qqpp;ENDPROC qqpp 
PROC new(qqpp=1810853260 XOR $6BEF6D8C:BOOL, qqpq=NIL:MATCHNODES, qqqp=64215851 XOR $3D3DB2B, qqqq=165983 XOR $2885F, qqppp=1330498800 XOR $4F4DCCF0, qqppq=21073951 XOR $141901F, qqpqp=NILS:STRING) NEW OF matchList;DEF qqpqq:PTR TO qq; IF self.miniList = (70531768 XOR $4343AB8); NEW qqpqq.new(self, qqpq, qqqp, qqqq, qqppp, qqppq, qqpqp); self.miniList := PASS qqpqq; ELSE IF qqpq; Throw("BUG", 'matchList.new(); pastEndFloatingNode supplied when miniList exists'); ENDIF; SUPER self.new(qqpp);ENDPROC
PROC append(qqpp, qqpq, qqqp, qqqq=20452261 XOR $13813A5, qqppp=NILS:STRING) OF matchList;DEF qqppq:MATCHNODES; qqppq := self.makeNode(qqpp, qqpq, qqqp, qqqq, PASS qqppp); self.pastEnd.beforeInsert(qqppq);ENDPROC
PROC infoStart() OF matchList IS self.start::qqp
PROC infoPastEnd() OF matchList IS self.pastEnd::qqp
PROC infoMiniList() OF matchList RETURNS qqpp:PTR TO qq  IS self.miniList::qq
PROC makeNode(qqpp, qqpq, qqqp, qqqq=4826136 XOR $49A418, qqppp=NILS:STRING) OF matchList RETURNS qqppq:MATCHNODES  IS self.miniList::qq.makeNode(qqpp, qqpq, qqqp, qqqq, qqppp)
PROC clone() OF matchList IS SUPER self.clone()::matchList
PROC mirror() OF matchList IS SUPER self.mirror()::matchList
PROC subset(qqpp=NIL:PTR TO cMegaCursorGeneric, qqpq=NIL:PTR TO cMegaCursorGeneric) OF matchList IS SUPER self.subset(qqpp, qqpq)::matchList
PROC sort(qqpp=NIL:PTR TO fCompareMegaNodes) OF matchList;; IF qqpp = (4577009 XOR $45D6F1) THEN qqpp := fCompareMegaNodes_match; SUPER self.sort(qqpp);ENDPROC
PROC make() OF matchList;DEF qqpp:PTR TO matchList; NEW qqpp;ENDPROC qqpp 
PROC make_node() OF matchList;DEF qqpp:PTR TO q; NEW qqpp;ENDPROC qqpp 
PROC make_cursor() OF matchList;DEF qqpp:PTR TO qqp; NEW qqpp;ENDPROC qqpp 
PROC getOwner() OF qqp IS SUPER self.getOwner()::matchList
PROC clone(qqpp=301206 XOR $49896, qqpq=6253797 XOR $5F6CE5) OF qqp RETURNS qqqp:PTR TO qqp  IS SUPER self.clone(qqpp, qqpq)::qqp
PROC infoMiniNode() OF qqp IS SUPER self.infoMiniNode()::q
PROC beforeInsert(qqpp:MEGANODES) OF qqp RETURNS qqpq:PTR TO q  IS SUPER self.beforeInsert(qqpp)::q
PROC afterInsert( qqpp:MEGANODES) OF qqp RETURNS qqpq:PTR TO q  IS SUPER self. afterInsert(qqpp)::q
PROC sortedInsert(qqpp:MEGANODES, qqpq=NIL:PTR TO fCompareMegaNodes) OF qqp;DEF qqqp:PTR TO q; IF qqpq = (236391 XOR $39B67) THEN qqpq := fCompareMegaNodes_match; qqqp := SUPER self.sortedInsert(qqpp, qqpq)::q;ENDPROC qqqp 
PROC sortedFind(qqpp:MEGANODES, qqpq=NIL:PTR TO fCompareMegaNodes) OF qqp;DEF qqqp:BOOL; IF qqpq = (146643 XOR $23CD3) THEN qqpq := fCompareMegaNodes_match; qqqp := SUPER self.sortedFind(qqpp, qqpq);ENDPROC qqqp 
PROC sortedFindSimple(qqpp, qqpq=NIL:PTR TO fCompareMegaNodes) OF qqp;DEF qqqp:BOOL,qqqq:MATCHNODES; qqqq := self.getOwner().makeNode(qqpp,  112378287 XOR $6B2C1AF,  930050688 XOR $376F7280); qqqp := self.sortedFind(qqqq, qqpq);FINALLY; IF qqqq THEN self.getOwner().destroyNode(qqqq);ENDPROC qqqp 
PROC call(qqpp:PTR TO cMiniListGeneric, qqpq:PTR TO oMegaNode, qqqp:PTR TO oMegaNode) OF fCompareMegaNodes_match;DEF qqqq:RANGE -1 TO 1,qqppp:PTR TO q,qqppq:PTR TO q; qqppp := qqpq::q; qqppq := qqqp::q; IF qqppq.matchPos = -(145376 XOR $237E1); qqqq := IF qqppp.matchPos=-(290658 XOR $46F63) THEN (191083 XOR $2EA6B) ELSE (2721923 XOR $298882); ELSE IF qqppp.matchPos = -(683781100 XOR $28C1ABED); qqqq := -(455281 XOR $6F270); ELSE; qqqq := Sign(qqppq.matchPos - qqppp.matchPos); IF qqqq = (15603334 XOR $EE1686) THEN qqqq := Sign(qqppq.dictIndex - qqppp.dictIndex); ENDIF;ENDPROC qqqq 
PROC call(qqpp:ARRAY OF CHAR, qqpq, qqqp:PTR TO translateDictionary) OF fTranslateMatcher RETURNS qqqq,qqppp,qqppq,qqpqp:STRING IS qqqq ,qqppp ,qqppq ,qqpqp 
PROC call( qqpp:ARRAY OF CHAR, qqpq, qqqp:PTR TO translateDictionary, qqqq:STRING) OF fTranslateAdder IS EMPTY
PROC call(qqpp:ARRAY OF CHAR, qqpq, qqqp:PTR TO translateDictionary) OF fSimpleTranslateMatcher;DEF qqqq,qqppp,qqppq,qqpqp:STRING; qqqq := qqpq; qqppp := StrLen(qqqp.matchStr); qqppq := StrLen(qqqp.paramArray !!ARRAY OF CHAR); NEW qqpqp[qqppq] ; StrCopy(qqpqp, qqqp.paramArray !!ARRAY OF CHAR);ENDPROC qqqq ,qqppp ,qqppq ,qqpqp 
PROC call(qqpp:ARRAY OF CHAR, qqpq, qqqp:PTR TO translateDictionary) OF fFixedTranslateMatcher;DEF qqqq,qqppp,qqppq,qqpqp:STRING; qqqq := qqpq; qqppp := StrLen(qqqp.matchStr); qqppq := StrLen(qqqp.paramArray !!ARRAY OF CHAR);ENDPROC qqqq ,qqppp ,qqppq ,qqpqp 
PROC call(qqpp:ARRAY OF CHAR, qqpq, qqqp:PTR TO translateDictionary, qqqq:STRING) OF fFixedTranslateAdder;; StrAdd(qqqq, qqqp.paramArray !!ARRAY OF CHAR);ENDPROC
PROC call(qqpp:ARRAY OF CHAR, qqpq, qqqp:PTR TO translateDictionary) OF fDummyTranslateMatcher;DEF qqqq,qqppp,qqppq,qqpqp:STRING; qqqq := -(131312 XOR $200F1);ENDPROC qqqq ,qqppp ,qqppq ,qqpqp 
