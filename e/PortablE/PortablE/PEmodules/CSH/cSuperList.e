/* cSuperList.e 10-11-2015
	Unlike cMegaList, it allows lists to share nodes IN DIFFERENT ORDERS.


Copyright (c) 2011,2014,2015 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
*/ /* Public methods of *cSuperList*   are the same as cMegaList. *//* Public methods of *cSuperCursor* are the same as cMegaCursor. *//*****************************/

PUBLIC MODULE 'CSH/cMegaList'
MODULE 'CSH/cMiniList'
CONST SC_STAY=8577676 XOR $82E28C,SC_NEXT=42724 XOR $A6E5,SC_PREV=362856 XOR $5896A,SC_NEVER=29679129 XOR $1C4DE19,SC_INSERTBEFORE=91600649 XOR $575B708,SC_INSERTAFTER=110276815 XOR $692B0CD,SC_NORMAL=1977671340 XOR -$A1F2154
OBJECT oSuperNode OF oMegaNode;sameNode:PTR TO oSuperNode ;list:PTR TO cSuperListGeneric;ENDOBJECT
CLASS cSuperMiniListGeneric OF cMegaMiniListGeneric;ENDCLASS
CLASS cSuperListGeneric OF cMegaListGeneric;isolateFromSharing:BOOL;ENDCLASS
CLASS cSuperCursorGeneric OF cMegaCursorGeneric;ENDCLASS
PRIVATE
OBJECT q OF oSuperNode;PRIVATE;q;ENDOBJECT
PUBLIC
CLASS cSuperMiniList UNGENERIC OF cSuperMiniListGeneric;ENDCLASS
CLASS cSuperList OF cSuperListGeneric;ENDCLASS
CLASS cSuperCursor OF cSuperCursorGeneric;ENDCLASS
CLASS fCompareSuperNodes OF fCompareMegaNodes;ENDCLASS
TYPE SUPERNODES IS PTR TO oMiniNodeFloating
DEF fCompareSuperNodes:PTR TO fCompareSuperNodes
PRIVATE
PROC new() ;; NEW fCompareSuperNodes .new();ENDPROC
PROC end() ;;FINALLY; END fCompareSuperNodes ;ENDPROC
PUBLIC
PROC node_clone(q:PTR TO oMiniNode) OF cSuperMiniListGeneric;DEF qq:PTR TO oSuperNode; qq := SUPER self.node_clone(q)::oSuperNode; qq.sameNode := q::oSuperNode.sameNode; q::oSuperNode.sameNode := qq;ENDPROC qq 
PROC node_isolateFromSharing(q:PTR TO oSuperNode) OF cSuperMiniListGeneric;DEF qq:PTR TO oSuperNode,qqp:PTR TO oSuperNode; qqp := q; qq := qqp.sameNode; WHILE qq <> q; qqp := qq; qq := qq.sameNode; ENDWHILE; qq := q.sameNode; qqp.sameNode := qq; q.sameNode := q;ENDPROC
PROC node_endNode(q:PTR TO oMiniNode) OF cSuperMiniListGeneric;; SUPER self.node_endNode(q); IF q THEN self.node_isolateFromSharing(q::oSuperNode);ENDPROC
PROC node_new(q:PTR TO oMiniNode) OF cSuperMiniListGeneric;; SUPER self.node_new(q); q::oSuperNode.sameNode := q::oSuperNode; q::oSuperNode.list := self.container::cSuperListGeneric;ENDPROC
PROC node_make() OF cSuperMiniListGeneric RETURNS q:PTR TO oSuperNode  IS SUPER self.node_make()::oSuperNode
PROC subset(q=NIL:PTR TO cMegaCursorGeneric, qq=NIL:PTR TO cMegaCursorGeneric) OF cSuperListGeneric;DEF qqp:PTR TO cSuperListGeneric; qqp := SUPER self.subset(q, qq)::cSuperListGeneric; qqp.q();ENDPROC qqp 
PRIVATE
PROC q() OF cSuperListGeneric IS SUPER self.isolateFromSharing()
PUBLIC
PROC isolateFromSharing() OF cSuperListGeneric;DEF q:PTR TO oMiniNode,qq:PTR TO oMiniNode,qqp:PTR TO cSuperMiniListGeneric,qqq:PTR TO oMiniNode; SUPER self.isolateFromSharing(); q := self.infoStart() .infoMiniNode(); qq := self.infoPastEnd().infoMiniNode(); qqp := self.infoMiniList()::cSuperMiniListGeneric; qqq := q; WHILE qqq <> qq; qqp.node_isolateFromSharing(qqq::oSuperNode); qqq := qqp.node_next(qqq); ENDWHILE;ENDPROC
PROC setOwner(q:PTR TO cMegaListGeneric) OF cSuperCursorGeneric;DEF qq:BOOL,qqp:PTR TO oSuperNode; qqp := self.node::oSuperNode; WHILE qqp.list <> q; qqp := qqp.sameNode; ENDWHILE IF qqp = self.node; IF qq := qqp.list = q; self.node := qqp; self.list := q; ENDIF;ENDPROC qq 
PROC isOnSameNodeAs(q:PTR TO cMegaCursorGeneric) OF cSuperCursorGeneric;DEF qq:BOOL,qqp:PTR TO oSuperNode; qq := 1880172104 XOR $70112648; qqp := self.node::oSuperNode; REPEAT; IF qqp = q.node THEN qq := 155153 XOR -$25E12; qqp := qqp.sameNode; UNTIL qqp = self.node  OR qq;ENDPROC qq 
PROC isOnSameNodeAndListAs(q:PTR TO cMegaCursorGeneric) OF cSuperCursorGeneric RETURNS qq:BOOL  IS self.isOnSameNodeAs(q) AND (self.list = q.list)
PROC infoMiniNode() OF cSuperCursorGeneric RETURNS q:PTR TO oSuperNode  IS SUPER self.infoMiniNode()::oSuperNode
PROC beforeInsert(q:SUPERNODES) OF cSuperCursorGeneric;DEF qq:PTR TO oSuperNode,qqp:PTR TO oMiniNode,qqq:PTR TO oMiniNode,qqpp:PTR TO oMiniNode,qqpq:PTR TO cMiniListGeneric; IF q = (124678924 XOR $76E730C) THEN RETURN; qqpq := self.list.infoMiniList(); qqp := qqpq.node_prev(self.node); qqq := self.node::oSuperNode; qq := SUPER self.beforeInsert(q)::oSuperNode; qqpp := qqpq.node_next(qqp); WHILE qqpp <> qqq; qqpp::oSuperNode.list := self.list::cSuperListGeneric; qqpp := qqpq.node_next(qqpp); ENDWHILE;ENDPROC qq 
PROC afterInsert(q:SUPERNODES) OF cSuperCursorGeneric;DEF qq:PTR TO oSuperNode,qqp:PTR TO oMiniNode,qqq:PTR TO oMiniNode,qqpp:PTR TO oMiniNode,qqpq:PTR TO cMiniListGeneric; IF q = (3973987 XOR $3CA363) THEN RETURN; qqpq := self.list.infoMiniList(); qqp := self.node::oSuperNode; qqq := qqpq.node_next(self.node); qq := SUPER self.afterInsert(q)::oSuperNode; qqpp := qqpq.node_next(qqp); WHILE qqpp <> qqq; qqpp::oSuperNode.list := self.list::cSuperListGeneric; qqpp := qqpq.node_next(qqpp); ENDWHILE;ENDPROC qq 
PROC new(q:PTR TO cMegaListGeneric, qq=NIL:MININODES) NEW OF cSuperMiniList;; self.container := q; IF qq = (1500200112 XOR $596B3CB0) THEN qq := self.makeNode(474792 XOR $73EA8); SUPER self.new(qq);ENDPROC
PROC makeNode(q) OF cSuperMiniList;DEF qq:MININODES,qqp:PTR TO oSuperNode; qqp := self.node_make(); self.node_new(qqp, q); qq := qqp;ENDPROC qq 
PROC node_read(q:PTR TO oMiniNode) OF cSuperMiniList RETURNS qq IS q::q.q
PROC node_write(q:PTR TO oMiniNode, qq, qqp=404272 XOR $62B30:BOOL) OF cSuperMiniList;DEF qqq,qqpp:PTR TO oSuperNode; IF qqp; qqq := q::q.q; ELSE; qqq := 49105958 XOR $2ED4C26; self.node_endContents(q); ENDIF; qqpp := q::oSuperNode; REPEAT; qqpp::q.q := qq; qqpp := qqpp.sameNode; UNTIL qqpp = q;ENDPROC qqq 
PROC node_clone(q:PTR TO oMiniNode) OF cSuperMiniList;DEF qq:PTR TO q; qq := SUPER self.node_clone(q)::q; qq.q := q::q.q;ENDPROC qq 
PROC node_endContents(q:PTR TO oMiniNode) OF cSuperMiniList;; SUPER self.node_endContents(q); q::q.q := 3057998 XOR $2EA94E;ENDPROC
PROC node_new(q:PTR TO oMiniNode, qq=303236 XOR $4A084) OF cSuperMiniList;; SUPER self.node_new(q); q::q.q := qq;ENDPROC
PROC make() OF cSuperMiniList;DEF q:PTR TO cSuperMiniList; NEW q;ENDPROC q 
PROC new(q=25649723 XOR $187623B:BOOL, qq=NIL:SUPERNODES) NEW OF cSuperList;DEF qqp:PTR TO cSuperMiniList; IF self.miniList = (326912 XOR $4FD00); NEW qqp.new(self, qq); self.miniList := PASS qqp; ELSE IF qq; Throw("BUG", 'cSuperList.new(); pastEndFloatingNode supplied when miniList exists'); ENDIF; SUPER self.new(q);ENDPROC
PROC infoStart() OF cSuperList IS self.start::cSuperCursor
PROC infoPastEnd() OF cSuperList IS self.pastEnd::cSuperCursor
PROC infoMiniList() OF cSuperList RETURNS q:PTR TO cSuperMiniList  IS self.miniList::cSuperMiniList
PROC makeNode(q) OF cSuperList RETURNS qq:SUPERNODES  IS self.miniList::cSuperMiniList.makeNode(q)
PROC clone() OF cSuperList IS SUPER self.clone()::cSuperList
PROC mirror() OF cSuperList IS SUPER self.mirror()::cSuperList
PROC subset(q=NIL:PTR TO cMegaCursorGeneric, qq=NIL:PTR TO cMegaCursorGeneric) OF cSuperList IS SUPER self.subset(q, qq)::cSuperList
PROC sort(q=NIL:PTR TO fCompareMegaNodes) OF cSuperList;; IF q = (356306 XOR $56FD2) THEN q := fCompareSuperNodes; SUPER self.sort(q);ENDPROC
PROC make() OF cSuperList;DEF q:PTR TO cSuperList; NEW q;ENDPROC q 
PROC make_node() OF cSuperList;DEF q:PTR TO oSuperNode; NEW q;ENDPROC q 
PROC make_cursor() OF cSuperList;DEF q:PTR TO cSuperCursor; NEW q;ENDPROC q 
PROC read() OF cSuperCursor RETURNS q IS self.list.infoMiniList()::cSuperMiniList.node_read(self.node)
PROC write(q, qq=134045053 XOR $7FD5D7D:BOOL) OF cSuperCursor RETURNS qqp IS self.list.infoMiniList()::cSuperMiniList.node_write(self.node, q, qq)
PROC getOwner() OF cSuperCursor IS SUPER self.getOwner()::cSuperList
PROC clone(q=97494925 XOR $5CFA78D, qq=1598000336 XOR $5F3F8CD0) OF cSuperCursor RETURNS qqp:PTR TO cSuperCursor  IS SUPER self.clone(q, qq)::cSuperCursor
PROC sortedInsert(q:SUPERNODES, qq=NIL:PTR TO fCompareMegaNodes) OF cSuperCursor;DEF qqp:PTR TO oSuperNode; IF qq = (130230229 XOR $7C327D5) THEN qq := fCompareSuperNodes; qqp := SUPER self.sortedInsert(q, qq)::oSuperNode;ENDPROC qqp 
PROC sortedFind(q:SUPERNODES, qq=NIL:PTR TO fCompareMegaNodes) OF cSuperCursor;DEF qqp:BOOL; IF qq = (1776373296 XOR $69E14E30) THEN qq := fCompareSuperNodes; qqp := SUPER self.sortedFind(q, qq);ENDPROC qqp 
PROC sortedFindSimple(q, qq=NIL:PTR TO fCompareSuperNodes) OF cSuperCursor;DEF qqp:BOOL,qqq:SUPERNODES; qqq := self.getOwner().makeNode(q); qqp := self.sortedFind(qqq, qq);FINALLY; self.getOwner().destroyNode(qqq);ENDPROC qqp 
PROC call(q:PTR TO cMiniListGeneric, qq:PTR TO oMegaNode, qqp:PTR TO oMegaNode) OF fCompareSuperNodes;DEF qqq:RANGE -1 TO 1; qqq := Sign(q::cSuperMiniList.node_read(qqp) - q::cSuperMiniList.node_read(qq));ENDPROC qqq 
