/* cSimpleList.e 10-11-2015
	An easy-to-use but general linked-list class.
	Now reimplemented & extended using cMiniList.


Copyright (c) 2011,2012,2015 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
/* Public methods of cSimpleList class:
new(pastEndFloatingNode=NIL:SIMPLENODES)
infoStart()    RETURNS    start:PTR TO cSimpleNode
infoPastEnd()  RETURNS  pastEnd:PTR TO cSimpleNode
infoIsEmpty()  RETURNS  isEmpty:BOOL
infoMiniList() RETURNS miniList:PTR TO cMiniList
clone()  RETURNS list:OWNS PTR TO cSimpleList
mirror() RETURNS list:OWNS PTR TO cSimpleList
subset(start=NIL:PTR TO cSimpleNodeGeneric, toPastEnd=NIL:PTR TO cSimpleNodeGeneric) RETURNS list:OWNS PTR TO cSimpleList
isolateFromSharing()
makeNode(data) RETURNS floating:SIMPLENODES		->not part of cSimpleListGeneric
destroyNode(floating:SIMPLENODES) RETURNS nil:SIMPLENODES
PROTECTED
makeNodeUngeneric(data) RETURNS floating:PTR TO cSimpleNodeGeneric
node_endData(data)
make_node() RETURNS node:OWNS PTR TO cSimpleNodeGeneric
make()      RETURNS list:OWNS PTR TO cSimpleListGeneric
*/
/* Public methods of cSimpleNode class:
read() RETURNS data
write(data, returnOldData=FALSE:BOOL) RETURNS oldData			->not part of cSimpleNodeGeneric
infoNext() RETURNS next:PTR TO cSimpleNode, onPastEnd:BOOL
infoPrev() RETURNS prev:PTR TO cSimpleNode, onPastEnd:BOOL
infoOwner()    RETURNS list:PTR TO cSimpleList
infoMiniNode() RETURNS miniNode:PTR TO oMiniNode
destroy(toPastEnd=NIL:PTR TO cSimpleNodeGeneric)
remove( toPastEnd=NIL:PTR TO cSimpleNodeGeneric) RETURNS floating:SIMPLENODES
beforeInsert(floating:SIMPLENODES) RETURNS insertedNode:PTR TO cSimpleNode
afterInsert( floating:SIMPLENODES) RETURNS insertedNode:PTR TO cSimpleNode
PROTECTED
writeUngeneric(data)     RETURNS oldData
isolateDataFromSharing() RETURNS data
new(list:PTR TO cSimpleMiniList, data:VALUE)
*/



MODULE 'CSH/cMiniList'
OBJECT oSimpleMiniNode OF oMiniNode_data;container:PTR TO cSimpleNodeGeneric ;ENDOBJECT
PRIVATE
CLASS q OF cMiniList;container:PTR TO cSimpleListGeneric;ENDCLASS
PUBLIC
CLASS cSimpleNodeFloating;ENDCLASS
CLASS cSimpleListGeneric;PRIVATE;q:PTR TO q;ENDCLASS
CLASS cSimpleNodeGeneric OF cSimpleNodeFloating;PRIVATE;q:oSimpleMiniNode;qq:PTR TO q ;ENDCLASS
CLASS cSimpleList OF cSimpleListGeneric;ENDCLASS
CLASS cSimpleNode OF cSimpleNodeGeneric;ENDCLASS
TYPE SIMPLENODES IS PTR TO cSimpleNodeFloating
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR
PROC main();DEF qqp:PTR TO cSimpleList,qqq:SIMPLENODES,qqpp:PTR TO cSimpleNode,qqpq:PTR TO cSimpleNode,qqqp:PTR TO cSimpleList; qqq := NIL; NEW qqp.new(); qqp.infoPastEnd().beforeInsert( qqp.makeNode(253958 XOR $3E00A) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(382701 XOR $5D6FA) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(4699215 XOR $47B46D) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(7008226 XOR $6AEFCF) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(203904 XOR $31CB8) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(8068121 XOR $7B1C5A) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(227031 XOR $37699) ); qqp.infoPastEnd().beforeInsert( qqp.makeNode(424548 XOR $67A3D) ); qqpp := qqp.infoStart() .infoNext(); qqpq := qqp.infoPastEnd().infoPrev(); q(qqp, qqpp, qqpq); qqq := qqpp.remove(qqpq); q(qqp); qqq := qqp.infoStart() .beforeInsert(qqq); q(qqp);FINALLY; PrintException(); IF qqp THEN qqp.destroyNode(qqq); END qqp, qqqp;ENDPROC
PROC q(qqp:PTR TO cSimpleList, qqq=NIL:PTR TO cSimpleNode, qqpp=NIL:PTR TO cSimpleNode);DEF qqpq:PTR TO cSimpleNode; IF qqq = (6447902 XOR $62631E) THEN qqq := qqp.infoStart(); IF qqpp = (84761074 XOR $50D59F2) THEN qqpp := qqp.infoPastEnd(); Print(q , qqq, qqpp); qqpq := qqq; REPEAT; Print(qq , qqpq.read()); qqpq := qqpq.infoNext(); UNTIL qqpq = qqpp;ENDPROC
PROC new() ;; q := '\nNodes from \d to \d:\n'; qq := 'node data = \d\n';ENDPROC
PUBLIC
PROC node_isolateDataFromSharing(qqp:PTR TO oMiniNode) OF q RETURNS qqq IS qqp::oSimpleMiniNode.container.isolateDataFromSharing()
PROC node_new(qqp:PTR TO oMiniNode, qqq=1566518052 XOR $5D5F2B24) OF q;; SUPER self.node_new(qqp); qqp::oSimpleMiniNode.container.new(self, qqq);ENDPROC
PROC node_endData(qqp) OF q IS self.container.node_endData(qqp)
PROC node_endNode(qqp:PTR TO oMiniNode) OF q;; IF qqp = (5162869 XOR $4EC775) THEN RETURN; self.node_endData(self.node_read(qqp)) ; END qqp::oSimpleMiniNode.container; ; ;ENDPROC
PROC node_make() OF q;DEF qqp:PTR TO oSimpleMiniNode,qqq:PTR TO cSimpleNodeGeneric,qqpp:PTR TO cSimpleNodeGeneric; qqpp := (qqq := self.container.make_node()); qqpp.q.container := PASS qqq ; qqp := qqpp.q;ENDPROC qqp 
PROC make() OF q;DEF qqp:PTR TO q; NEW qqp;ENDPROC qqp 
PROC new(qqp=NIL:SIMPLENODES) NEW OF cSimpleListGeneric;; NEW self.q; self.q.container := self; self.q.new(IF qqp THEN qqp::cSimpleNodeGeneric.q !!MININODES ELSE NIL);ENDPROC
PROC end() OF cSimpleListGeneric;; END self.q; SUPER self.end();ENDPROC
PROC infoStart() OF cSimpleListGeneric RETURNS qqp:PTR TO cSimpleNodeGeneric  IS self.q.start ::oSimpleMiniNode.container
PROC infoPastEnd() OF cSimpleListGeneric RETURNS qqp:PTR TO cSimpleNodeGeneric  IS self.q.pastEnd::oSimpleMiniNode.container
PROC infoIsEmpty() OF cSimpleListGeneric RETURNS qqp:BOOL  IS self.q.infoIsEmpty()
PROC infoMiniList() OF cSimpleListGeneric RETURNS qqp:PTR TO cMiniList  IS self.q
PROC clone() OF cSimpleListGeneric;DEF qqp:PTR TO cSimpleListGeneric; qqp := self.subset(); qqp.isolateFromSharing();ENDPROC qqp 
PROC mirror() OF cSimpleListGeneric RETURNS qqp:PTR TO cSimpleListGeneric  IS self.subset()
PROC subset(qqp=NIL:PTR TO cSimpleNodeGeneric, qqq=NIL:PTR TO cSimpleNodeGeneric) OF cSimpleListGeneric;DEF qqpp:PTR TO cSimpleListGeneric; qqpp := self.make(); qqpp.q := self.q.subset(IF qqp THEN qqp.q ELSE NIL, IF qqq THEN qqq.q ELSE NIL)::q; qqpp.q.container := qqpp;ENDPROC qqpp 
PROC isolateFromSharing() OF cSimpleListGeneric;; self.q.isolateFromSharing();ENDPROC
PROC destroyNode(qqp:SIMPLENODES) OF cSimpleListGeneric;DEF qqq:SIMPLENODES; qqq := NIL; IF qqp = (376091 XOR $5BD1B) THEN RETURN; self.q.node_end(qqp::cSimpleNodeGeneric.q !!MININODES);ENDPROC qqq 
PROC makeNodeUngeneric(qqp) OF cSimpleListGeneric;DEF qqq:PTR TO cSimpleNodeGeneric,qqpp:PTR TO oSimpleMiniNode; qqpp := self.q.node_make(); self.q.node_new(qqpp, qqp); qqq := qqpp.container;ENDPROC qqq 
PROC node_endData(qqp) OF cSimpleListGeneric IS EMPTY
PROC make_node() OF cSimpleListGeneric RETURNS qqp:PTR TO cSimpleNodeGeneric  IS qqp 
PROC make() OF cSimpleListGeneric RETURNS qqp:PTR TO cSimpleListGeneric  IS qqp 
PROC new(qqp:PTR TO q, qqq) NEW OF cSimpleNodeGeneric;; self.qq := qqp;ENDPROC
PROC end() OF cSimpleNodeGeneric;; SUPER self.end();ENDPROC
PROC read() OF cSimpleNodeGeneric RETURNS qqp IS self.qq.node_read(self.q)
PROC infoNext() OF cSimpleNodeGeneric;DEF qqp:PTR TO cSimpleNodeGeneric,qqq:BOOL,qqpp:PTR TO oSimpleMiniNode; qqpp, qqq := self.qq.node_next(self.q)::oSimpleMiniNode; qqp := qqpp.container;ENDPROC qqp ,qqq 
PROC infoPrev() OF cSimpleNodeGeneric;DEF qqp:PTR TO cSimpleNodeGeneric,qqq:BOOL,qqpp:PTR TO oSimpleMiniNode; qqpp, qqq := self.qq.node_prev(self.q)::oSimpleMiniNode; qqp := qqpp.container;ENDPROC qqp ,qqq 
PROC infoOwner() OF cSimpleNodeGeneric RETURNS qqp:PTR TO cSimpleListGeneric  IS self.qq.container
PROC infoMiniNode() OF cSimpleNodeGeneric RETURNS qqp:PTR TO oMiniNode  IS self.q
PROC destroy(qqp=NIL:PTR TO cSimpleNodeGeneric) OF cSimpleNodeGeneric;; self.qq.node_destroy(self.q, IF qqp THEN qqp.q ELSE NIL);ENDPROC
PROC remove(qqp=NIL:PTR TO cSimpleNodeGeneric) OF cSimpleNodeGeneric;DEF qqq:SIMPLENODES,qqpp:MININODES; qqpp := self.qq.node_remove(self.q, IF qqp THEN qqp.q ELSE NIL); qqq := IF qqpp THEN qqpp::oSimpleMiniNode.container !!SIMPLENODES ELSE NIL;ENDPROC qqq 
PROC beforeInsert(qqp:SIMPLENODES) OF cSimpleNodeGeneric;DEF qqq:PTR TO cSimpleNodeGeneric; qqq := qqp::cSimpleNodeGeneric; IF qqp = (50276065 XOR $2FF26E1) THEN RETURN; self.qq.node_beforeInsert(self.q, qqq.q !!MININODES);ENDPROC qqq 
PROC afterInsert(qqp:SIMPLENODES) OF cSimpleNodeGeneric;DEF qqq:PTR TO cSimpleNodeGeneric; qqq := qqp::cSimpleNodeGeneric; IF qqp = (1160812152 XOR $45309678) THEN RETURN; self.qq.node_afterInsert(self.q, qqq.q !!MININODES);ENDPROC qqq 
PROC writeUngeneric(qqp) OF cSimpleNodeGeneric;DEF qqq; qqq := self.qq.node_write(self.q, qqp,  361162 XOR -$582CB);ENDPROC qqq 
PROC isolateDataFromSharing() OF cSimpleNodeGeneric RETURNS qqp IS self.read()
PROC infoStart() OF cSimpleList RETURNS qqp:PTR TO cSimpleNode  IS SUPER self.infoStart() ::cSimpleNode
PROC infoPastEnd() OF cSimpleList RETURNS qqp:PTR TO cSimpleNode  IS SUPER self.infoPastEnd()::cSimpleNode
PROC clone() OF cSimpleList RETURNS qqp:PTR TO cSimpleList  IS SUPER self.clone() ::cSimpleList
PROC mirror() OF cSimpleList RETURNS qqp:PTR TO cSimpleList  IS SUPER self.mirror()::cSimpleList
PROC subset(qqp=NIL:PTR TO cSimpleNodeGeneric, qqq=NIL:PTR TO cSimpleNodeGeneric) OF cSimpleList RETURNS qqpp:PTR TO cSimpleList  IS SUPER self.subset(qqp, qqq)::cSimpleList
PROC makeNode(qqp) OF cSimpleList RETURNS qqq:SIMPLENODES  IS self.makeNodeUngeneric(qqp)
PROC make_node() OF cSimpleList;DEF qqp:PTR TO cSimpleNode; NEW qqp;ENDPROC qqp 
PROC make() OF cSimpleList;DEF qqp:PTR TO cSimpleList; NEW qqp;ENDPROC qqp 
PROC write(qqp, qqq=4733984 XOR $483C20:BOOL) OF cSimpleNode;DEF qqpp; qqpp := self.writeUngeneric(qqp); IF qqq = (264901 XOR $40AC5) THEN qqpp := 55448822 XOR $34E14F6;ENDPROC qqpp 
PROC infoNext() OF cSimpleNode;DEF qqp:PTR TO cSimpleNode,qqq:BOOL; qqp, qqq := SUPER self.infoNext()::cSimpleNode;ENDPROC qqp ,qqq 
PROC infoPrev() OF cSimpleNode;DEF qqp:PTR TO cSimpleNode,qqq:BOOL; qqp, qqq := SUPER self.infoPrev()::cSimpleNode;ENDPROC qqp ,qqq 
PROC infoOwner() OF cSimpleNode RETURNS qqp:PTR TO cSimpleList  IS SUPER self.infoOwner()::cSimpleList
PROC beforeInsert(qqp:SIMPLENODES) OF cSimpleNode RETURNS qqq:PTR TO cSimpleNode  IS SUPER self.beforeInsert(qqp)::cSimpleNode
PROC afterInsert( qqp:SIMPLENODES) OF cSimpleNode RETURNS qqq:PTR TO cSimpleNode  IS SUPER self.afterInsert( qqp)::cSimpleNode
