/* cMiniList.e 23-10-2014
	An efficient but general & re-usable list class.


Copyright (c) 2009,2010,2011,2012,2014 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
/* Public methods of *cMiniList*:
NEW new(pastEndFloatingNode=NIL:MININODES)
start  :PTR TO oMiniNode		->member
pastEnd:PTR TO oMiniNode		->member
makeNode(data) RETURNS floating:MININODES			->not part of cMiniListGeneric
clone()  RETURNS list:OWNS PTR TO cMiniList
mirror() RETURNS list:OWNS PTR TO cMiniList
subset(start=NIL:PTR TO oMiniNode, pastEnd=NIL:PTR TO oMiniNode) RETURNS list:OWNS PTR TO cMiniList
isolateFromSharing()
infoIsEmpty() RETURNS isEmpty:BOOL

node_read( node:PTR TO oMiniNode) RETURNS data											->not part of cMiniListGeneric
node_write(node:PTR TO oMiniNode, data, returnOldData=FALSE:BOOL) RETURNS oldData		->not part of cMiniListGeneric
node_next( node:PTR TO oMiniNode) RETURNS next:PTR TO oMiniNode, onPastEnd:BOOL
node_prev( node:PTR TO oMiniNode) RETURNS prev:PTR TO oMiniNode, onPastEnd:BOOL

node_destroy(node:PTR TO oMiniNode, toPastEnd=NIL:PTR TO oMiniNode)
node_remove( node:PTR TO oMiniNode, toPastEnd=NIL:PTR TO oMiniNode) RETURNS floating:MININODES
node_beforeInsert(node:PTR TO oMiniNode, floating:MININODES) RETURNS insertedNode:PTR TO oMiniNode
node_afterInsert( node:PTR TO oMiniNode, floating:MININODES) RETURNS insertedNode:PTR TO oMiniNode
node_end(floating:MININODES) RETURNS nil:MININODES

PROTECTED
node_clone(node:PTR TO oMiniNode) RETURNS clone:PTR TO oMiniNode
node_new(node:PTR TO oMiniNode)
node_endContents(node:PTR TO oMiniNode)
node_endNode(node:PTR TO oMiniNode)
node_make() RETURNS node:PTR TO oMiniNode
make() RETURNS list:OWNS PTR TO cMiniList
*/


PRIVATE
PUBLIC
OBJECT oMiniNodeFloating;ENDOBJECT
OBJECT oMiniNode OF oMiniNodeFloating;PRIVATE;q:PTR TO oMiniNode;qq:PTR TO oMiniNode ;ENDOBJECT
PRIVATE
CLASS q;headNode:PTR TO oMiniNode ;headList:PTR TO cMiniListGeneric ;ENDCLASS
PUBLIC
CLASS cMiniListGeneric;PUBLIC;start:PTR TO oMiniNode;pastEnd:PTR TO oMiniNode;PROTECTED;root:PTR TO q;root_nextList:PTR TO cMiniListGeneric ;ENDCLASS
OBJECT oMiniNode_data OF oMiniNode;PRIVATE;qqp;ENDOBJECT
CLASS cMiniList OF cMiniListGeneric;ENDCLASS
TYPE MININODES IS PTR TO oMiniNodeFloating
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR
PROC main();DEF qqpq:PTR TO cMiniList,qqqp:MININODES,qqqq:PTR TO oMiniNode,qqppp:PTR TO oMiniNode,qqppq:PTR TO oMiniNode,qqpqp:PTR TO cMiniList; qqqp := NIL; NEW qqpq.new(); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(253958 XOR $3E00A)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(382701 XOR $5D6FA)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(4699215 XOR $47B46D)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(7008226 XOR $6AEFCF)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(203904 XOR $31CB8)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(8068121 XOR $7B1C5A)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(227031 XOR $37699)); qqpq.node_beforeInsert(qqpq.pastEnd, qqpq.makeNode(424548 XOR $67A3D)); qqqq := qqpq.node_next(qqpq.start); qqppp := qqpq.node_prev(qqpq.pastEnd); q(qqpq, qqqq, qqppp); qqqp := qqpq.node_remove(qqqq, qqppp); q(qqpq); qqpq.node_beforeInsert(qqppq := qqpq.start, qqqp) ; qqqp := NIL; q(qqpq); qqpqp := qqpq.subset(qqqq, qqppq); qqpqp.isolateFromSharing(); qqpq.node_write(qqqq, 471566 XOR $731E9) ; q(qqpqp); Print(q , qqpq.start, qqpqp.start);FINALLY; PrintException(); IF qqpq THEN qqpq.node_end(qqqp); END qqpq, qqpqp;ENDPROC
PROC q(qqpq:PTR TO cMiniList, qqqp=NIL:PTR TO oMiniNode, qqqq=NIL:PTR TO oMiniNode);DEF qqppp:PTR TO oMiniNode; IF qqqp = (918898992 XOR $36C54930) THEN qqqp := qqpq.start; IF qqqq = (357533 XOR $5749D) THEN qqqq := qqpq.pastEnd; Print(qq , qqqp, qqqq); qqppp := qqqp; REPEAT; Print(qqp , qqpq.node_read(qqppp)); qqppp := qqpq.node_next(qqppp); UNTIL qqppp = qqqq;ENDPROC
PROC new() ;; q := 'list.start=\d, list2.start=\d\n'; qq := '\nNodes from \d to \d:\n'; qqp := 'node = \d\n'; qqq := 'cMiniListGeneric.node_beforeInsert(); ownedStart<>start'; qqpp := 'cMiniListGeneric.node_afterInsert(); ownedStart<>start';ENDPROC
PROC q(qqpq:PTR TO oMiniNode, qqqp:PTR TO cMiniListGeneric) NEW OF q;; self.headNode := qqpq; self.headList := qqqp;ENDPROC
PROC qq(qqpq:PTR TO cMiniListGeneric) OF q;; qqpq.root_nextList := self.headList.root_nextList; self.headList.root_nextList := qqpq;ENDPROC
PROC qqp(qqpq:PTR TO cMiniListGeneric) OF q;DEF qqqp:BOOL,qqqq:PTR TO cMiniListGeneric,qqppp:PTR TO cMiniListGeneric; qqppp := qqpq; REPEAT; qqqq := qqppp; qqppp := qqppp.root_nextList; UNTIL qqppp = qqpq; IF self.headList = qqpq THEN self.headList := qqqq; qqqq.root_nextList := qqpq.root_nextList; qqpq.root_nextList := qqpq ; qqqp := qqqq = qqpq;ENDPROC qqqp 
PROC qqq() OF q IS self.headList = self.headList.root_nextList
PUBLIC
PROC end() OF q;; self.headList.node_end(self.headNode !!MININODES); SUPER self.end();ENDPROC
PROC new(qqpq:MININODES) NEW OF cMiniListGeneric;; self.start := qqpq::oMiniNode.qq; self.pastEnd := qqpq::oMiniNode; NEW self.root.q(self.pastEnd, self); self.root_nextList := self;ENDPROC
PROC end() OF cMiniListGeneric;; IF self.root.qqp(self) THEN END self.root; SUPER self.end();ENDPROC
PROC clone() OF cMiniListGeneric;DEF qqpq:PTR TO cMiniListGeneric; qqpq := self.subset(); qqpq.isolateFromSharing();ENDPROC qqpq 
PROC mirror() OF cMiniListGeneric RETURNS qqpq:PTR TO cMiniListGeneric  IS self.subset()
PROC subset(qqpq=NIL:PTR TO oMiniNode, qqqp=NIL:PTR TO oMiniNode) OF cMiniListGeneric;DEF qqqq:PTR TO cMiniListGeneric; IF qqpq = (1160813448 XOR $45309B88) THEN qqpq := self.start; IF qqqp = (325360276 XOR $13649A94) THEN qqqp := self.pastEnd; qqqq := self.make(); qqqq.start := qqpq; qqqq.pastEnd := qqqp; qqqq.root := self.root; qqqq.root.qq(qqqq);ENDPROC qqqq 
PROC isolateFromSharing() OF cMiniListGeneric;DEF qqpq:PTR TO oMiniNode,qqqp:PTR TO oMiniNode,qqqq:PTR TO oMiniNode,qqppp:PTR TO oMiniNode,qqppq:PTR TO oMiniNode,qqpqp:PTR TO oMiniNode; IF self.root.qqq() THEN RETURN; qqqp := self.start; qqqq := self.pastEnd; qqpqp := NIL; qqpq := qqqp; REPEAT; qqppp := self.node_clone(qqpq); IF qqpqp = (752818136 XOR $2CDF17D8); qqpqp := qqppp; ELSE; qqppq := qqppp.qq; qqppp.qq := qqpqp.q.qq; qqppp.q := qqpqp.q; qqpqp.q.qq := qqppq; qqpqp.q := qqppp; qqppq := NIL; ENDIF; qqpq := qqpq.qq; UNTIL qqpq = qqqq.qq; self.start := qqpqp; self.pastEnd := qqpqp.q; self.root.qqp(self); NEW self.root.q(self.pastEnd, self);FINALLY; self.node_endNode(qqppq);ENDPROC
PROC infoIsEmpty() OF cMiniListGeneric RETURNS qqpq:BOOL  IS self.start = self.pastEnd
PROC node_next(qqpq:PTR TO oMiniNode) OF cMiniListGeneric;DEF qqqp:PTR TO oMiniNode,qqqq:BOOL; qqqp := qqpq.qq; qqqq := qqqp = self.pastEnd;ENDPROC qqqp ,qqqq 
PROC node_prev(qqpq:PTR TO oMiniNode) OF cMiniListGeneric;DEF qqqp:PTR TO oMiniNode,qqqq:BOOL; qqqp := qqpq.q; qqqq := qqqp = self.pastEnd;ENDPROC qqqp ,qqqq 
PROC node_destroy(qqpq:PTR TO oMiniNode, qqqp=NIL:PTR TO oMiniNode) OF cMiniListGeneric;DEF qqqq:PTR TO oMiniNode,qqppp:PTR TO oMiniNode; IF qqpq = (3532773 XOR $35E7E5) THEN RETURN; self.node_remove(qqpq, qqqp); qqqq := qqpq.q.qq ; qqpq.q.qq := NIL; REPEAT; qqppp := qqqq.qq ; qqqq.qq := NIL; self.node_endNode(qqqq); qqqq := qqppp ; qqppp := NIL; UNTIL qqqq = (582588908 XOR $22B999EC);FINALLY; self.node_endNode(qqqq); self.node_endNode(qqppp);ENDPROC
PROC node_remove(qqpq:PTR TO oMiniNode, qqqp=NIL:PTR TO oMiniNode) OF cMiniListGeneric;DEF qqqq:MININODES,qqppp:PTR TO oMiniNode,qqppq:PTR TO oMiniNode,qqpqp:PTR TO oMiniNode,qqpqq:PTR TO oMiniNode,qqqpp:PTR TO oMiniNode; IF qqpq = qqqp THEN RETURN NIL; qqppp := qqpq; qqpqp := IF qqqp THEN qqqp.q ELSE qqpq; qqppq := qqppp.q.qq ; qqppp.q.qq := NIL; qqpqq := qqppp.q; qqqpp := qqpqp.qq; qqpqq.qq := qqpqp.qq ; qqpqp.qq := NIL; qqqpp .q := qqpqq; qqppp.q := qqpqp; qqpqp .qq := qqppq ; qqppq := NIL; IF self.root.headNode = qqppp; self.root.headNode := qqqpp; ENDIF; qqqq := qqppp; IF qqppp = self.start THEN self.start := qqqpp; IF qqpqp = self.pastEnd THEN self.pastEnd := qqpqq;FINALLY; self.node_endNode(qqppq);ENDPROC qqqq 
PROC node_beforeInsert(qqpq:PTR TO oMiniNode, qqqp:MININODES) OF cMiniListGeneric;DEF qqqq:PTR TO oMiniNode,qqppp:PTR TO oMiniNode,qqppq:PTR TO oMiniNode,qqpqp:PTR TO oMiniNode,qqpqq:PTR TO oMiniNode,qqqpp:PTR TO oMiniNode; qqqq := qqqp::oMiniNode; IF qqqp = (6636916 XOR $654574) THEN RETURN; qqppp := qqqq; qqppq := qqppp.q; qqpqp := qqpq.q; qqpqq := qqpq; qqqpp :=  qqppq.qq ; qqppq.qq := NIL; IF qqqpp <> qqppp THEN Throw("BUG", qqq ) ; qqppp.q := qqpqp; qqppq .qq :=  qqpqp.qq ; qqpqp.qq := NIL ; qqpqp.qq :=  qqqpp ; qqqpp := NIL; qqpqq .q := qqppq; IF qqpq = self.start THEN self.start := qqppp;FINALLY; self.node_endNode(qqqpp);ENDPROC qqqq 
PROC node_afterInsert(qqpq:PTR TO oMiniNode, qqqp:MININODES) OF cMiniListGeneric;DEF qqqq:PTR TO oMiniNode,qqppp:PTR TO oMiniNode,qqppq:PTR TO oMiniNode,qqpqp:PTR TO oMiniNode,qqpqq:PTR TO oMiniNode,qqqpp:PTR TO oMiniNode; qqqq := qqqp::oMiniNode; IF qqqp = (1057591 XOR $102337) THEN RETURN; qqppp := qqqq; qqppq := qqppp.q; qqpqp := qqpq; qqpqq := qqpq.qq; qqqpp := qqppq.qq ; qqppq.qq := NIL; IF qqqpp <> qqppp THEN Throw("BUG", qqpp ) ; qqppp.q := qqpqp; qqppq .qq := qqpqp.qq ; qqpqp.qq := NIL ; qqpqp.qq := qqqpp ; qqqpp := NIL; qqpqq .q := qqppq; IF qqpq = self.pastEnd THEN self.pastEnd := qqppq;FINALLY; self.node_endNode(qqqpp);ENDPROC qqqq 
PROC node_end(qqpq:MININODES) OF cMiniListGeneric;DEF qqqp:MININODES,qqqq:PTR TO oMiniNode,qqppp:PTR TO oMiniNode; qqqp := NIL; IF qqpq = (5540293 XOR $5489C5) THEN RETURN; qqqq := qqpq::oMiniNode.qq ; qqpq::oMiniNode.qq := NIL; WHILE qqqq <> (5207889 XOR $4F7751)  AND (qqqq <> qqpq); qqppp := qqqq.qq ; qqqq.qq := NIL; self.node_endNode(qqqq); qqqq := qqppp ; qqppp := NIL; ENDWHILE; self.node_endNode(qqqq) ; qqqq := NIL;FINALLY; self.node_endNode(qqppp);ENDPROC qqqp 
PROC node_clone(qqpq:PTR TO oMiniNode) OF cMiniListGeneric;DEF qqqp:PTR TO oMiniNode; qqqp := self.node_make(); self.node_new(qqqp);ENDPROC qqqp 
PROC node_new(qqpq:PTR TO oMiniNode) OF cMiniListGeneric;; qqpq.q := qqpq; qqpq.qq := qqpq;ENDPROC
PROC node_endContents(qqpq:PTR TO oMiniNode) OF cMiniListGeneric IS EMPTY
PROC node_endNode(qqpq:PTR TO oMiniNode) OF cMiniListGeneric;; IF qqpq THEN self.node_endContents(qqpq); END qqpq;ENDPROC
PROC node_make() OF cMiniListGeneric RETURNS qqpq:PTR TO oMiniNode  IS qqpq 
PROC make() OF cMiniListGeneric RETURNS qqpq:PTR TO cMiniListGeneric  IS qqpq 
PROC new(qqpq=NIL:MININODES) NEW OF cMiniList;; IF qqpq = (2074465512 XOR $7BA5D4E8) THEN qqpq := self.makeNode(2627138 XOR $281642); SUPER self.new(qqpq);ENDPROC
PROC makeNode(qqpq) OF cMiniList;DEF qqqp:MININODES,qqqq:PTR TO oMiniNode_data; qqqq := self.node_make(); self.node_new(qqqq); qqqq.qqp := qqpq; qqqp := qqqq;ENDPROC qqqp 
PROC clone() OF cMiniList IS SUPER self.clone()::cMiniList
PROC mirror() OF cMiniList IS SUPER self.mirror()::cMiniList
PROC subset(qqpq=NIL:PTR TO oMiniNode, qqqp=NIL:PTR TO oMiniNode) OF cMiniList IS SUPER self.subset(qqpq, qqqp)::cMiniList
PROC node_read(qqpq:PTR TO oMiniNode) OF cMiniList RETURNS qqqp IS qqpq::oMiniNode_data.qqp
PROC node_write(qqpq:PTR TO oMiniNode, qqqp, qqqq=114333559 XOR $6D09777:BOOL) OF cMiniList;DEF qqppp; IF qqqq; qqppp := qqpq::oMiniNode_data.qqp; ELSE; qqppp := 8187738 XOR $7CEF5A; self.node_endContents(qqpq); ENDIF; qqpq::oMiniNode_data.qqp := qqqp;ENDPROC qqppp 
PROC node_clone(qqpq:PTR TO oMiniNode) OF cMiniList;DEF qqqp:PTR TO oMiniNode_data; qqqp := self.node_make(); self.node_new(qqqp); qqqp.qqp := qqpq::oMiniNode_data.qqp;ENDPROC qqqp 
PROC node_endContents(qqpq:PTR TO oMiniNode) OF cMiniList;; qqpq::oMiniNode_data.qqp := 466241 XOR $71D41;ENDPROC
PROC node_make() OF cMiniList;DEF qqpq:PTR TO oMiniNode_data; NEW qqpq;ENDPROC qqpq 
PROC make() OF cMiniList;DEF qqpq:PTR TO cMiniList; NEW qqpq;ENDPROC qqpq 
