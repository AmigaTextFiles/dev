/* cMegaList.e 09-10-2016
	A safe but general list class.  Lists can share nodes, but only in the same order.
	Reimplemented using cMiniList.


Copyright (c) 2010,2011,2012,2014,2015,2016 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
/* Public methods of *cMegaList*:
NEW new(cursorNextIfDestroyNode=FALSE:BOOL, pastEndFloatingNode=NIL:MEGANODES)
infoStart()    RETURNS    start:PTR TO cMegaCursor
infoPastEnd()  RETURNS  pastEnd:PTR TO cMegaCursor
infoIsEmpty()  RETURNS  isEmpty:BOOL
infoMiniList() RETURNS miniList:PTR TO cMiniList
getCursorNextIfDestroyNode() RETURNS cursorNextIfDestroyNode:BOOL
setCursorNextIfDestroyNode(cursorNextIfDestroyNode:BOOL)
makeNode(data) RETURNS floating:MEGANODES			->not part of cMegaListGeneric
destroyNode(node:MEGANODES) RETURNS nil:MEGANODES
clone()  RETURNS list:OWNS PTR TO cMegaList
mirror() RETURNS list:OWNS PTR TO cMegaList
subset(start=NIL:PTR TO cMegaCursorGeneric, pastEnd=NIL:PTR TO cMegaCursorGeneric) RETURNS list:OWNS PTR TO cMegaList
isolateFromSharing()
sort(compareFunction=NIL:PTR TO fCompareMegaNodes)
PROTECTED
node_clone(clone:PTR TO oMegaNode, orig:PTR TO oMegaNode)
node_new(node:PTR TO oMegaNode)
node_endContents(node:PTR TO oMegaNode)
node_endNode(node:PTR TO oMegaNode)
make() RETURNS list:OWNS PTR TO cMegaList
make_node() RETURNS node:OWNS PTR TO oMegaNode_data
make_cursor() RETURNS cursor:OWNS PTR TO cMegaCursor
*/
/* Public methods of *cMegaCursor*:
read() RETURNS data												->not part of cMegaCursorGeneric
write(data, returnOldData=FALSE:BOOL) RETURNS oldData			->not part of cMegaCursorGeneric
next() RETURNS onPastEnd:BOOL
prev() RETURNS onPastEnd:BOOL
goto(cursor:PTR TO cMegaCursorGeneric)
setOwner(owner:PTR TO cMegaListGeneric) RETURNS success:BOOL
getOwner() RETURNS owner:PTR TO cMegaList
clone(ifRemovedThen=MC_STAY, followWhen=MC_NEVER) RETURNS clone:OWNS PTR TO cMegaCursor
isOnSameNodeAs(cursor:PTR TO cMegaCursorGeneric) RETURNS isSame:BOOL
isOnSameNodeAndListAs(cursor:PTR TO cMegaCursorGeneric) RETURNS isSame:BOOL
infoIfRemovedThen() RETURNS ifRemovedThen
infoFollowWhen()    RETURNS followWhen
infoMiniNode()      RETURNS miniNode:PTR TO oMegaNode
destroy(toPastEnd=NIL:PTR TO cMegaCursorGeneric, ifRemovedThen=MC_NORMAL)
remove( toPastEnd=NIL:PTR TO cMegaCursorGeneric, ifRemovedThen=MC_NORMAL) RETURNS floating:MEGANODES
beforeInsert(floating:MEGANODES) RETURNS insertedNodes:PTR TO oMegaNode
afterInsert( floating:MEGANODES) RETURNS insertedNodes:PTR TO oMegaNode
sortedInsert(floating:MEGANODES, compareFunction=NIL:PTR TO fCompareMegaNodes) RETURNS insertedNodes:PTR TO oMegaNode
sortedFind(     match:MEGANODES, compareFunction=NIL:PTR TO fCompareMegaNodes) RETURNS success:BOOL
sortedFindData( matchData,       compareFunction=NIL:PTR TO fCompareMegaNodes) RETURNS success:BOOL		->not part of cMegaCursorGeneric
PRIVATE
new(node:PTR TO oMegaNode, list:PTR TO cMegaListGeneric, ifRemovedThen=MC_STAY, followWhen=MC_NEVER)
PROTECTED
addToNodesCursorList()
removeFromNodesCursorList()
infoMiniList() RETURNS miniList:PTR TO cMiniList
make() RETURNS cursor:OWNS PTR TO cMegaCursor
*/

/*****************************/


MODULE 'CSH/cMiniList'
CONST MC_STAY=8577676 XOR $82E28C ,MC_NEXT=42724 XOR $A6E5 ,MC_PREV=362856 XOR $5896A ,MC_NEVER=29679129 XOR $1C4DE19 ,MC_INSERTBEFORE=91600649 XOR $575B708 ,MC_INSERTAFTER=110276815 XOR $692B0CD ,MC_NORMAL=191961 XOR $8002EDD9
CLASS fCompareMegaNodes OF function;ENDCLASS
OBJECT oMegaNode OF oMiniNode;PRIVATE;q:PTR TO cMegaCursorGeneric ;ENDOBJECT
CLASS cMegaMiniListGeneric OF cMiniListGeneric;container:PTR TO cMegaListGeneric;ENDCLASS
CLASS cMegaListGeneric;miniList:PTR TO cMegaMiniListGeneric;start:PTR TO cMegaCursorGeneric;pastEnd:PTR TO cMegaCursorGeneric;cursorNextIfDestroyNode:BOOL;ENDCLASS
CLASS cMegaCursorGeneric;node:PTR TO oMegaNode ;list:PTR TO cMegaListGeneric;ifRemovedThen;followWhen;node_prevCursor:PTR TO cMegaCursorGeneric ;node_nextCursor:PTR TO cMegaCursorGeneric;ENDCLASS
OBJECT oMegaNode_data OF oMegaNode;PRIVATE;qq;ENDOBJECT
CLASS cMegaMiniList UNGENERIC OF cMegaMiniListGeneric;ENDCLASS
CLASS cMegaList OF cMegaListGeneric;ENDCLASS
CLASS cMegaCursor OF cMegaCursorGeneric;ENDCLASS
TYPE MEGANODES IS PTR TO oMiniNodeFloating
DEF fCompareMegaNodes:PTR TO fCompareMegaNodes
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR,qqpq:ARRAY OF CHAR
PROC new() ;; NEW fCompareMegaNodes .new(); q := 'cMegaCursorGeneric.goto(); cursor is not in same List'; qq := 'cMegaCursorGeneric.remove(); toPastEnd Cursor is not in same List'; qqp := 'cMegaListGeneric.sortedInsert(); floating=NIL'; qqq := 'cMegaListGeneric.sortedInsert(); compareFunction=NIL'; qqpp := 'cMegaListGeneric.sortedFind(); match=NIL'; qqpq := 'cMegaListGeneric.sortedFind(); compareFunction=NIL';ENDPROC
PROC end() ;;FINALLY; END fCompareMegaNodes ;ENDPROC
PROC q(qqqp:PTR TO oMegaNode, qqqq:PTR TO cMegaListGeneric) ;DEF qqppp:BOOL,qqppq:PTR TO oMegaNode,qqpqp:BOOL; qqppp := 3722517 XOR $38CD15; qqppq := qqqq.start.node; REPEAT; IF qqqp = qqppq THEN qqppp := 204271728 XOR -$C2CF071; qqppq, qqpqp := qqqq.miniList.node_next(qqppq)::oMegaNode; UNTIL qqppp OR qqpqp;ENDPROC qqppp 
PUBLIC
PROC call(qqqp:PTR TO cMiniListGeneric, qqqq:PTR TO oMegaNode, qqppp:PTR TO oMegaNode) OF fCompareMegaNodes;DEF qqppq:RANGE -1 TO 1; qqppq := Sign(qqqp::cMegaMiniList.node_read(qqppp) - qqqp::cMegaMiniList.node_read(qqqq));ENDPROC qqppq 
PROC node_clone(qqqp:PTR TO oMiniNode) OF cMegaMiniListGeneric;DEF qqqq:PTR TO oMegaNode,qqppp:PTR TO cMegaCursorGeneric,qqppq:PTR TO cMegaCursorGeneric; qqqq := SUPER self.node_clone(qqqp)::oMegaNode ; qqppp := qqqp::oMegaNode.q; WHILE qqppp; qqppq := qqppp.node_nextCursor; IF qqppp.list = self.container; qqppp.removeFromNodesCursorList(); qqppp.node := qqqq; qqppp.addToNodesCursorList(); ENDIF; qqppp := qqppq; ENDWHILE; self.container.node_clone(qqqq, qqqp::oMegaNode);ENDPROC qqqq 
PROC node_endContents(qqqp:PTR TO oMiniNode) OF cMegaMiniListGeneric;; self.container.node_endContents(qqqp::oMegaNode);ENDPROC
PROC node_endNode(qqqp:PTR TO oMiniNode) OF cMegaMiniListGeneric;DEF qqqq:PTR TO cMegaCursorGeneric; IF qqqp = (492263 XOR $782E7) THEN RETURN; self.container.node_endNode(qqqp::oMegaNode); qqqq := qqqp::oMegaNode.q; WHILE qqqq; qqqq.removeFromNodesCursorList(); qqqq.node := NIL; qqqq := qqqq.node_nextCursor; ENDWHILE; qqqp::oMegaNode.q := NIL ; SUPER self.node_endNode(qqqp);ENDPROC
PROC node_new(qqqp:PTR TO oMiniNode) OF cMegaMiniListGeneric;; SUPER self.node_new(qqqp); self.container.node_new(qqqp::oMegaNode);ENDPROC
PROC node_make() OF cMegaMiniListGeneric;DEF qqqp:PTR TO oMegaNode; qqqp := self.container.make_node();ENDPROC qqqp 
PROC new(qqqp:BOOL) NEW OF cMegaListGeneric;; IF self.miniList = (1379693836 XOR $523C750C) THEN Throw("BUG", 'cMegaListGeneric.new(); self.miniList=NIL'); self.start := self.make_cursor(); self.pastEnd := self.make_cursor(); self.start .q(self.miniList.start ::oMegaNode, self, 506424 XOR $7BA39, 223205 XOR $367E4) ; self.pastEnd.q(self.miniList.pastEnd::oMegaNode, self, 689977452 XOR $2920386E, 27979297 XOR $1AAEE23 ) ; self.cursorNextIfDestroyNode := qqqp;ENDPROC
PROC end() OF cMegaListGeneric;; END self.miniList; END self.start; END self.pastEnd; SUPER self.end();ENDPROC
PROC infoStart() OF cMegaListGeneric RETURNS qqqp:PTR TO cMegaCursorGeneric  IS self.start
PROC infoPastEnd() OF cMegaListGeneric RETURNS qqqp:PTR TO cMegaCursorGeneric  IS self.pastEnd
PROC infoIsEmpty() OF cMegaListGeneric RETURNS qqqp:BOOL  IS self.start.node = self.pastEnd.node 
PROC infoMiniList() OF cMegaListGeneric RETURNS qqqp:PTR TO cMiniListGeneric  IS self.miniList
PROC getCursorNextIfDestroyNode() OF cMegaListGeneric RETURNS qqqp:BOOL  IS self.cursorNextIfDestroyNode
PROC setCursorNextIfDestroyNode(qqqp:BOOL) OF cMegaListGeneric;; self.cursorNextIfDestroyNode := qqqp;ENDPROC
PROC destroyNode(qqqp:MEGANODES) OF cMegaListGeneric RETURNS qqqq:MEGANODES  IS self.miniList.node_end(qqqp) BUT NIL
PROC clone() OF cMegaListGeneric;DEF qqqp:PTR TO cMegaListGeneric; qqqp := self.subset(); qqqp.isolateFromSharing();ENDPROC qqqp 
PROC mirror() OF cMegaListGeneric RETURNS qqqp:PTR TO cMegaListGeneric  IS self.subset()
PROC subset(qqqp=NIL:PTR TO cMegaCursorGeneric, qqqq=NIL:PTR TO cMegaCursorGeneric) OF cMegaListGeneric;DEF qqppp:PTR TO cMegaListGeneric; IF qqqp = (1845264580 XOR $6DFC80C4) THEN qqqp := self.start; IF qqqq = (3478993 XOR $3515D1) THEN qqqq := self.pastEnd; qqppp := self.make(); qqppp.miniList := self.miniList.subset(qqqp.node, qqqq.node)::cMegaMiniList; qqppp.miniList.container := qqppp; qqppp.new(self.cursorNextIfDestroyNode); ;ENDPROC qqppp 
PROC isolateFromSharing() OF cMegaListGeneric;; self.miniList.start := self. start.node; self.miniList.pastEnd := self.pastEnd.node; self.miniList.isolateFromSharing();ENDPROC
PROC sort(qqqp:PTR TO fCompareMegaNodes) OF cMegaListGeneric;DEF qqqq,qqppp:BOOL,qqppq:PTR TO cMiniListGeneric,qqpqp:RANGE -1 TO 1,qqpqq:MEGANODES,qqqpp:PTR TO cMegaCursorGeneric,qqqpq:PTR TO cMegaCursorGeneric,qqqqp:PTR TO cMegaCursorGeneric,qqqqq,qqpppp:PTR TO cMegaCursorGeneric,qqpppq,qqppqp:BOOL; IF self.infoIsEmpty() THEN RETURN; qqppq := self.infoMiniList(); qqqq := 130082 XOR $1FC23; qqqqp := self.infoStart().clone(1834083968 XOR $6D51E681); qqpppp := self.infoStart().clone(122596589 XOR $74EACEC); qqqpq := self.infoPastEnd(); qqqpp := self.infoStart(); REPEAT; qqqpp.goto(qqqpq) ; qqppp := 1156962752 XOR -$44F5D9C1; REPEAT; qqqqq := 705038748 XOR $2A06099C; REPEAT; qqqqq:= qqqqq+(68106 XOR $10A0B); qqpppp.next(); qqppqp := qqpppp.isOnSameNodeAs(qqqpp); UNTIL qqqqq >= qqqq  OR qqppqp; qqpppq := qqqq; WHILE qqqqq > (379939576 XOR $16A56AF8)  OR (qqpppq > (1150016 XOR $118C40) AND NOT qqppqp); qqpqp := IF qqqqq <= (422408 XOR $67208) THEN -(1945790 XOR $1DB0BF) ELSE (IF qqpppq <= (803158 XOR $C4156) OR qqppqp THEN (30734 XOR $780F) ELSE  qqqp.call(qqppq, qqqqp.node, qqpppp.node)); IF qqpqp >= (4039957 XOR $3DA515) ; qqpqq := qqqqp.remove(); qqqqq:= qqqqq-(1026850008 XOR $3D347CD9); ELSE; qqpqq := qqpppp.remove(); qqpppq:= qqpppq-(1369920 XOR $14E741); qqppqp := qqpppp.isOnSameNodeAs(qqqpp); ENDIF; qqqpq.beforeInsert(qqpqq); ENDWHILE; IF qqppqp = (1984370212 XOR $76471624) THEN qqppp := 405963868 XOR $1832845C; UNTIL qqppqp; qqqq := qqqq + qqqq; UNTIL qqppp;FINALLY; END qqqqp; END qqpppp;ENDPROC
PROC node_clone(qqqp:PTR TO oMegaNode, qqqq:PTR TO oMegaNode) OF cMegaListGeneric IS EMPTY
PROC node_new(qqqp:PTR TO oMegaNode) OF cMegaListGeneric IS EMPTY
PROC node_endContents(qqqp:PTR TO oMegaNode) OF cMegaListGeneric IS EMPTY
PROC node_endNode(qqqp:PTR TO oMegaNode) OF cMegaListGeneric IS EMPTY
PROC make() OF cMegaListGeneric RETURNS qqqp:PTR TO cMegaListGeneric  IS qqqp 
PROC make_node() OF cMegaListGeneric RETURNS qqqp:PTR TO oMegaNode  IS qqqp 
PROC make_cursor() OF cMegaListGeneric RETURNS qqqp:PTR TO cMegaCursorGeneric  IS qqqp 
PRIVATE
PROC q(qqqp:PTR TO oMegaNode, qqqq:PTR TO cMegaListGeneric, qqppp=862175832 XOR $3363C258, qqppq=129845465 XOR $7BD48D9) NEW OF cMegaCursorGeneric;; self.node := qqqp; self.list := qqqq; self.ifRemovedThen := qqppp; self.followWhen := qqppq; IF qqqp THEN self.addToNodesCursorList();ENDPROC
PUBLIC
PROC end() OF cMegaCursorGeneric;; IF self.node THEN self.removeFromNodesCursorList(); self.node := NIL ; SUPER self.end();ENDPROC
PROC addToNodesCursorList() OF cMegaCursorGeneric;DEF qqqp:PTR TO oMegaNode; qqqp := self.node; IF qqqp.q; self.node_prevCursor := NIL ; self.node_nextCursor := qqqp.q; qqqp.q.node_prevCursor := self; ELSE; self.node_prevCursor := NIL; self.node_nextCursor := NIL; ENDIF; qqqp.q := self;ENDPROC
PROC removeFromNodesCursorList() OF cMegaCursorGeneric;DEF qqqp:PTR TO oMegaNode; qqqp := self.node; IF qqqp.q = self; qqqp.q := self.node_nextCursor; ENDIF; IF self.node_prevCursor THEN self.node_prevCursor.node_nextCursor := self.node_nextCursor; IF self.node_nextCursor THEN self.node_nextCursor.node_prevCursor := self.node_prevCursor; self.node_prevCursor := NIL; self.node_nextCursor := NIL;ENDPROC
PROC next() OF cMegaCursorGeneric;DEF qqqp:BOOL; self.removeFromNodesCursorList(); IF self.node = self.list.pastEnd.node; self.node := self.list.start.node; ELSE; self.node := self.list.miniList.node_next(self.node)::oMegaNode; ENDIF; qqqp := self.node = self.list.pastEnd.node; self.addToNodesCursorList(); ; ;ENDPROC qqqp 
PROC prev() OF cMegaCursorGeneric;DEF qqqp:BOOL; self.removeFromNodesCursorList(); IF self.node = self.list.start.node; self.node := self.list.pastEnd.node; qqqp := 513542 XOR -$7D607; ELSE; self.node := self.list.miniList.node_prev(self.node)::oMegaNode; qqqp := 14634 XOR $392A; ENDIF; self.addToNodesCursorList();ENDPROC qqqp 
PROC goto(qqqp:PTR TO cMegaCursorGeneric) OF cMegaCursorGeneric;; IF qqqp.list <> self.list; IF q(qqqp.node, self.list) = (1142881752 XOR $441EFDD8) THEN Throw("EMU", q ); ENDIF; self.removeFromNodesCursorList(); self.node := qqqp.node; self.addToNodesCursorList();ENDPROC
PROC setOwner(qqqp:PTR TO cMegaListGeneric) OF cMegaCursorGeneric;DEF qqqq:BOOL; IF qqqq := q(self.node, qqqp); self.list := qqqp; ENDIF;ENDPROC qqqq 
PROC getOwner() OF cMegaCursorGeneric RETURNS qqqp:PTR TO cMegaListGeneric  IS self.list
PROC clone(qqqp=5115684 XOR $4E0F24, qqqq=50741 XOR $C635) OF cMegaCursorGeneric;DEF qqppp:PTR TO cMegaCursorGeneric; qqppp := self.list.make_cursor(); qqppp.node := self.node; qqppp.list := self.list; qqppp.ifRemovedThen := qqqp; qqppp.followWhen := qqqq; qqppp.node_prevCursor := NIL; qqppp.node_nextCursor := NIL; qqppp.addToNodesCursorList();ENDPROC qqppp 
PROC isOnSameNodeAs(qqqp:PTR TO cMegaCursorGeneric) OF cMegaCursorGeneric RETURNS qqqq:BOOL  IS self.node = qqqp.node
PROC isOnSameNodeAndListAs(qqqp:PTR TO cMegaCursorGeneric) OF cMegaCursorGeneric RETURNS qqqq:BOOL  IS self.node = qqqp.node  AND (self.list = qqqp.list)
PROC infoIfRemovedThen() OF cMegaCursorGeneric RETURNS qqqp IS self.ifRemovedThen
PROC infoFollowWhen() OF cMegaCursorGeneric RETURNS qqqp IS self.followWhen
PROC infoMiniNode() OF cMegaCursorGeneric RETURNS qqqp:PTR TO oMegaNode  IS self.node
PROC destroy(qqqp=NIL:PTR TO cMegaCursorGeneric, qqqq=191961 XOR $8002EDD9) OF cMegaCursorGeneric;; self.list.miniList.node_end( self.qq(qqqp, qqqq, 3722517 XOR -$38CD16) );ENDPROC
PROC remove(qqqp=NIL:PTR TO cMegaCursorGeneric, qqqq=191961 XOR $8002EDD9) OF cMegaCursorGeneric RETURNS qqppp:MEGANODES  IS self.qq(qqqp, qqqq)
PRIVATE
PROC qq(qqqp=NIL:PTR TO cMegaCursorGeneric, qqqq=191961 XOR $8002EDD9, qqppp=3722517 XOR $38CD15:BOOL) OF cMegaCursorGeneric;DEF qqppq:MEGANODES,qqpqp:PTR TO oMegaNode,qqpqq,qqqpp:PTR TO oMegaNode,qqqpq:PTR TO oMegaNode,qqqqp:PTR TO oMegaNode,qqqqq:PTR TO oMegaNode,qqpppp:PTR TO cMegaCursorGeneric,qqpppq:PTR TO cMegaCursorGeneric; IF qqqp; IF qqqp.list <> self.list THEN Throw("EMU", qq ); ENDIF; qqpqq := self.ifRemovedThen; IF qqqq <> (191961 XOR $8002EDD9) THEN self.ifRemovedThen := qqqq; qqqpp := IF qqqp THEN qqqp.node ELSE self.list.miniList.node_next(self.node)::oMegaNode; qqpqp := self.node; qqqqp := qqqpp; qqqpq := self.list.miniList.node_prev(self.node)::oMegaNode; qqqqq := self.node; WHILE qqqqq <> qqqpp; qqpppp := qqqqq.q; WHILE qqpppp; qqpppq := qqpppp.node_nextCursor; qqqq := qqpppp.ifRemovedThen; IF qqppp THEN IF qqqq = (3722517 XOR $38CD15) THEN qqqq := IF qqpppp.list.cursorNextIfDestroyNode THEN (204271728 XOR $C2CF071) ELSE (492263 XOR $782E5); qqpppp.removeFromNodesCursorList(); IF qqqq <> (1379693836 XOR $523C750C); qqpppp.node := IF qqqq = (506424 XOR $7BA39) THEN qqqqp ELSE qqqpq; ENDIF; qqpppp.addToNodesCursorList(); qqpppp := qqpppq; ENDWHILE; qqqqq := self.list.miniList.node_next(qqqqq)::oMegaNode; ENDWHILE; self.ifRemovedThen := qqpqq; qqppq := self.list.miniList.node_remove(qqpqp, IF qqqp THEN qqqp.node ELSE NIL);ENDPROC qqppq 
PUBLIC
PROC beforeInsert(qqqp:MEGANODES) OF cMegaCursorGeneric;DEF qqqq:PTR TO oMegaNode,qqppp:PTR TO cMegaCursorGeneric,qqppq:PTR TO cMegaCursorGeneric; IF qqqp = (223205 XOR $367E5) THEN RETURN; qqqq := self.list.miniList.node_beforeInsert(self.node, qqqp)::oMegaNode; qqppp := self.node.q; WHILE qqppp; qqppq := qqppp.node_nextCursor; IF qqppp.followWhen = (689977452 XOR $2920386D); qqppp.removeFromNodesCursorList(); qqppp.node := qqqq; qqppp.addToNodesCursorList(); ENDIF; qqppp := qqppq; ENDWHILE;ENDPROC qqqq 
PROC afterInsert(qqqp:MEGANODES) OF cMegaCursorGeneric;DEF qqqq:PTR TO oMegaNode,qqppp:PTR TO cMegaCursorGeneric,qqppq:PTR TO cMegaCursorGeneric; IF qqqp = (27979297 XOR $1AAEE21) THEN RETURN; qqqq := self.list.miniList.node_afterInsert(self.node, qqqp)::oMegaNode; qqppp := self.node.q; WHILE qqppp; qqppq := qqppp.node_nextCursor; IF qqppp.followWhen = (1845264580 XOR $6DFC80C6); qqppp.removeFromNodesCursorList(); qqppp.node := qqqq; qqppp.addToNodesCursorList(); ENDIF; qqppp := qqppq; ENDWHILE;ENDPROC qqqq 
PROC sortedInsert(qqqp:MEGANODES, qqqq:PTR TO fCompareMegaNodes) OF cMegaCursorGeneric;DEF qqppp:PTR TO oMegaNode; IF qqqp = (3478993 XOR $3515D1) THEN Throw("EMU", qqp ); IF qqqq = (130082 XOR $1FC22) THEN Throw("EMU", qqq ); self.sortedFind(qqqp, qqqq); qqppp := self.beforeInsert(qqqp);ENDPROC qqppp 
PROC sortedFind(qqqp:MEGANODES, qqqq:PTR TO fCompareMegaNodes) OF cMegaCursorGeneric;DEF qqppp:BOOL,qqppq,qqpqp:PTR TO cMiniListGeneric,qqpqq:PTR TO cMegaListGeneric; IF qqqp = (1834083968 XOR $6D51E680) THEN Throw("EMU", qqpp ); IF qqqq = (122596589 XOR $74EACED) THEN Throw("EMU", qqpq ); qqppp := 1156962752 XOR $44F5D9C0; qqpqq := self.getOwner(); IF qqpqq.infoIsEmpty() = (705038748 XOR $2A06099C); qqpqp := qqpqq.infoMiniList(); IF self.isOnSameNodeAs(qqpqq.infoPastEnd()) THEN self.prev() ; qqppq := qqqq.call(qqpqp, qqqp!!PTR TO oMegaNode, self.node); IF qqppq < (68106 XOR $10A0A); REPEAT; IF self.next() = (379939576 XOR $16A56AF8); qqppq := qqqq.call(qqpqp, qqqp!!PTR TO oMegaNode, self.node); ELSE; qqppq := 1150016 XOR $118C41; ENDIF; UNTIL qqppq >= (422408 XOR $67208); ELSE IF qqppq > (1945790 XOR $1DB0BE); WHILE self.prev() = (803158 XOR $C4156); qqppq := qqqq.call(qqpqp, qqqp!!PTR TO oMegaNode, self.node); ENDWHILE IF qqppq <= (30734 XOR $780E); self.next(); ENDIF; IF qqppq = (4039957 XOR $3DA515) THEN qqppp := 1026850008 XOR -$3D347CD9; ENDIF; ;ENDPROC qqppp 
PROC infoMiniList() OF cMegaCursorGeneric RETURNS qqqp:PTR TO cMiniListGeneric  IS self.list.miniList
PROC new(qqqp:PTR TO cMegaListGeneric, qqqq=NIL:MININODES) NEW OF cMegaMiniList;; self.container := qqqp; IF qqqq = (1369920 XOR $14E740) THEN qqqq := self.makeNode(1984370212 XOR $76471624); SUPER self.new(qqqq);ENDPROC
PROC makeNode(qqqp) OF cMegaMiniList;DEF qqqq:MININODES,qqppp:PTR TO oMegaNode; qqppp := self.node_make(); self.node_new(qqppp, qqqp); qqqq := qqppp;ENDPROC qqqq 
PROC node_read(qqqp:PTR TO oMiniNode) OF cMegaMiniList RETURNS qqqq IS qqqp::oMegaNode_data.qq
PROC node_write(qqqp:PTR TO oMiniNode, qqqq, qqppp=405963868 XOR $1832845C:BOOL) OF cMegaMiniList;DEF qqppq; IF qqppp; qqppq := qqqp::oMegaNode_data.qq; ELSE; qqppq := 862175832 XOR $3363C258; self.node_endContents(qqqp); ENDIF; qqqp::oMegaNode_data.qq := qqqq;ENDPROC qqppq 
PROC node_clone(qqqp:PTR TO oMiniNode) OF cMegaMiniList;DEF qqqq:PTR TO oMegaNode_data; qqqq := SUPER self.node_clone(qqqp)::oMegaNode_data; qqqq.qq := qqqp::oMegaNode_data.qq;ENDPROC qqqq 
PROC node_endContents(qqqp:PTR TO oMiniNode) OF cMegaMiniList;; SUPER self.node_endContents(qqqp); qqqp::oMegaNode_data.qq := 129845465 XOR $7BD48D9;ENDPROC
PROC node_new(qqqp:PTR TO oMiniNode, qqqq=513542 XOR $7D606) OF cMegaMiniList;; SUPER self.node_new(qqqp); qqqp::oMegaNode_data.qq := qqqq;ENDPROC
PROC make() OF cMegaMiniList;DEF qqqp:PTR TO cMegaMiniList; NEW qqqp;ENDPROC qqqp 
PROC new(qqqp=14634 XOR $392A:BOOL, qqqq=NIL:MEGANODES) NEW OF cMegaList;DEF qqppp:PTR TO cMegaMiniList; IF self.miniList = (1142881752 XOR $441EFDD8); NEW qqppp.new(self, qqqq); self.miniList := PASS qqppp; ELSE IF qqqq; Throw("BUG", 'cMegaList.new(); pastEndFloatingNode supplied when miniList exists'); ENDIF; SUPER self.new(qqqp);ENDPROC
PROC infoStart() OF cMegaList IS self.start::cMegaCursor
PROC infoPastEnd() OF cMegaList IS self.pastEnd::cMegaCursor
PROC infoMiniList() OF cMegaList RETURNS qqqp:PTR TO cMegaMiniList  IS self.miniList::cMegaMiniList
PROC makeNode(qqqp) OF cMegaList RETURNS qqqq:MEGANODES  IS self.miniList::cMegaMiniList.makeNode(qqqp)
PROC clone() OF cMegaList IS SUPER self.clone()::cMegaList
PROC mirror() OF cMegaList IS SUPER self.mirror()::cMegaList
PROC subset(qqqp=NIL:PTR TO cMegaCursorGeneric, qqqq=NIL:PTR TO cMegaCursorGeneric) OF cMegaList IS SUPER self.subset(qqqp, qqqq)::cMegaList
PROC sort(qqqp=NIL:PTR TO fCompareMegaNodes) OF cMegaList;; IF qqqp = (5115684 XOR $4E0F24) THEN qqqp := fCompareMegaNodes; SUPER self.sort(qqqp);ENDPROC
PROC make() OF cMegaList;DEF qqqp:PTR TO cMegaList; NEW qqqp;ENDPROC qqqp 
PROC make_node() OF cMegaList;DEF qqqp:PTR TO oMegaNode_data; NEW qqqp;ENDPROC qqqp 
PROC make_cursor() OF cMegaList;DEF qqqp:PTR TO cMegaCursor; NEW qqqp;ENDPROC qqqp 
PROC read() OF cMegaCursor RETURNS qqqp IS self.list.miniList::cMegaMiniList.node_read(self.node)
PROC write(qqqp, qqqq=50741 XOR $C635:BOOL) OF cMegaCursor RETURNS qqppp IS self.list.miniList::cMegaMiniList.node_write(self.node, qqqp, qqqq)
PROC getOwner() OF cMegaCursor IS SUPER self.getOwner()::cMegaList
PROC clone(qqqp=3881520 XOR $3B3A30, qqqq=1976990500 XOR $75D67B24) OF cMegaCursor RETURNS qqppp:PTR TO cMegaCursor  IS SUPER self.clone(qqqp, qqqq)::cMegaCursor
PROC sortedInsert(qqqp:MEGANODES, qqqq=NIL:PTR TO fCompareMegaNodes) OF cMegaCursor;DEF qqppp:PTR TO oMegaNode; IF qqqq = (17918306 XOR $1116962) THEN qqqq := fCompareMegaNodes; qqppp := SUPER self.sortedInsert(qqqp, qqqq);ENDPROC qqppp 
PROC sortedFind(qqqp:MEGANODES, qqqq=NIL:PTR TO fCompareMegaNodes) OF cMegaCursor;DEF qqppp:BOOL; IF qqqq = (374254 XOR $5B5EE) THEN qqqq := fCompareMegaNodes; qqppp := SUPER self.sortedFind(qqqp, qqqq);ENDPROC qqppp 
PROC sortedFindSimple(qqqp, qqqq=NIL:PTR TO fCompareMegaNodes) OF cMegaCursor;DEF qqppp:BOOL,qqppq:MEGANODES; qqppq := self.getOwner().makeNode(qqqp); qqppp := self.sortedFind(qqppq, qqqq);FINALLY; self.getOwner().destroyNode(qqppq);ENDPROC qqppp 
