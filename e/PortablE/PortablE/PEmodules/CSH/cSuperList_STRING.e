/* cSuperList_STRING.e 29-10-2014
	A version of the list class, specialised to hold STRINGs.
*/
PUBLIC MODULE 'CSH/cSuperList'
MODULE 'CSH/cMiniList'

PROC main()
	DEF list :OWNS PTR TO cSuperList_STRING, cursor :OWNS PTR TO cSuperCursor_STRING
	DEF list2:OWNS PTR TO cSuperList_STRING, cursor2:OWNS PTR TO cSuperCursor_STRING
	
	NEW list.new()
	cursor := list.infoPastEnd().clone()
	
	list.infoPastEnd().beforeInsert(list.makeNode(NEW '6'))
	list.infoPastEnd().beforeInsert(list.makeNode(NEW '5'))
	list.infoPastEnd().beforeInsert(list.makeNode(NEW '4'))
	list.infoPastEnd().beforeInsert(list.makeNode(NEW '3'))
	list.infoPastEnd().beforeInsert(list.makeNode(NEW '2'))
	list.infoPastEnd().beforeInsert(list.makeNode(NEW '1'))
	
	Print('First list\n')
	show(list, cursor)
	
	
	list2 := list.subset()
	list2.infoStart()  .next()
	list2.infoPastEnd().prev()
	
	->this is optional
	list2.isolateFromSharing()
	
	cursor.goto(list.infoPastEnd()) ; cursor.prev() ; cursor.prev()
	cursor.write(NEW '222')
	Print('First list\n')
	show(list, cursor)
	
	list.sort(fCompareSuperNodes_STRING)
	Print('First list\n')
	show(list, cursor)
	
	cursor2 := list2.infoPastEnd().clone()
	Print('Second list\n')
	show(list2, cursor2)
	
	
	Print('\nDone\n')
FINALLY
	PrintException()
	END list, cursor
	END list2, cursor2
ENDPROC

PRIVATE
PROC show(list:PTR TO cSuperList_STRING, tempCursor:PTR TO cSuperCursor_STRING)
	IF list.infoIsEmpty() = FALSE
		tempCursor.goto(list.infoStart())
		REPEAT
			Print('node data = "\s"\n', tempCursor.read())
		UNTIL tempCursor.next()
	ENDIF
ENDPROC
PUBLIC

/*****************************/

PRIVATE
OBJECT oSuperNode_STRING OF oSuperNode PRIVATE
	data:/*SHARED*/ OWNS STRING
ENDOBJECT
PUBLIC

/*****************************/

CLASS cSuperMiniList_STRING UNGENERIC OF cSuperMiniListGeneric
ENDCLASS

PROC new(container:PTR TO cMegaListGeneric, pastEndNode=NIL:MININODES) OF cSuperMiniList_STRING
	self.container := container
	IF pastEndNode = NIL THEN pastEndNode := self.makeNode(NILS)
	SUPER self.new(pastEndNode)
ENDPROC

PROC makeNode(data:OWNS STRING) OF cSuperMiniList_STRING RETURNS floating:MININODES
	DEF node:PTR TO oSuperNode
	node := self.node_make()
	self.node_new(node, PASS data)
	floating := node
ENDPROC

PROC node_read(node:PTR TO oMiniNode) OF cSuperMiniList_STRING RETURNS data:STRING IS node::oSuperNode_STRING.data

PROC node_write(node:PTR TO oMiniNode, data:OWNS STRING, returnOldData=FALSE:BOOL) OF cSuperMiniList_STRING RETURNS oldData:OWNS STRING
	DEF superNode:PTR TO oSuperNode
	
	IF returnOldData
		oldData := PASS node::oSuperNode_STRING.data
	ELSE
		oldData := NILS
		self.node_endContents(node)
	ENDIF
	
	->go through every Same Node, and write data to it
	superNode := node::oSuperNode.sameNode
	WHILE superNode <> node
		superNode::oSuperNode_STRING.data := data
		
		superNode := superNode.sameNode
	ENDWHILE
	
	node::oSuperNode_STRING.data := PASS data
ENDPROC

->PROTECTED
PROC node_clone(node:PTR TO oMiniNode) OF cSuperMiniList_STRING RETURNS clone:PTR TO oSuperNode_STRING
	clone := SUPER self.node_clone(node)::oSuperNode_STRING
	clone.data := node::oSuperNode_STRING.data
ENDPROC

->PROTECTED
PROC node_isolateFromSharing(node:PTR TO oSuperNode) OF cSuperMiniList_STRING
	DEF oldData:STRING
	
	SUPER self.node_isolateFromSharing(node)
	
	IF oldData := node::oSuperNode_STRING.data
		NEW     node::oSuperNode_STRING.data[StrMax(oldData)]
		StrCopy(node::oSuperNode_STRING.data,       oldData)
	ENDIF
ENDPROC

->PROTECTED
PROC node_endContents(node:PTR TO oMiniNode) OF cSuperMiniList_STRING
	IF node::oSuperNode.sameNode = node
		END node::oSuperNode_STRING.data
	ENDIF
	SUPER self.node_endContents(node)
ENDPROC

->PROTECTED
PROC node_new(node:PTR TO oMiniNode, data=NILS:OWNS STRING) OF cSuperMiniList_STRING
	SUPER self.node_new(node)
	node::oSuperNode_STRING.data := PASS data
ENDPROC

->PROTECTED
PROC make() OF cSuperMiniList_STRING RETURNS list:OWNS PTR TO cSuperMiniList_STRING
	NEW list
ENDPROC

/*****************************/

CLASS cSuperList_STRING OF cSuperListGeneric
ENDCLASS

PROC new(cursorNextIfDestroyNode=FALSE:BOOL, pastEndFloatingNode=NIL:SUPERNODES) OF cSuperList_STRING
	DEF miniList:OWNS PTR TO cSuperMiniList_STRING
	
	IF self.miniList = NIL
		NEW miniList.new(self, pastEndFloatingNode)
		self.miniList := PASS miniList
		
	ELSE IF pastEndFloatingNode
		Throw("BUG", 'cSuperList_STRING.new(); pastEndFloatingNode supplied when miniList exists')
	ENDIF
	
	SUPER self.new(cursorNextIfDestroyNode)
ENDPROC

PROC infoStart() OF cSuperList_STRING IS self.start/*SUPER self.infoStart()*/::cSuperCursor_STRING

PROC infoPastEnd() OF cSuperList_STRING IS self.pastEnd/*SUPER self.infoPastEnd()*/::cSuperCursor_STRING

PROC infoMiniList() OF cSuperList_STRING RETURNS miniList:PTR TO cSuperMiniList_STRING IS self.miniList/*SUPER self.infoMiniList()*/::cSuperMiniList_STRING

PROC makeNode(data:OWNS STRING) OF cSuperList_STRING RETURNS floating:SUPERNODES IS self.miniList::cSuperMiniList_STRING.makeNode(PASS data)

PROC clone() OF cSuperList_STRING IS SUPER self.clone()::cSuperList_STRING

PROC mirror() OF cSuperList_STRING IS SUPER self.mirror()::cSuperList_STRING

PROC subset(start=NIL:PTR TO cMegaCursorGeneric, pastEnd=NIL:PTR TO cMegaCursorGeneric) OF cSuperList_STRING IS SUPER self.subset(start, pastEnd)::cSuperList_STRING

->this provides a default sorting function (case-sensitive)
PROC sort(compareFunction=NIL:PTR TO fCompareMegaNodes) OF cSuperList_STRING
	IF compareFunction = NIL THEN compareFunction := fCompareSuperNodes_STRING
	SUPER self.sort(compareFunction)
ENDPROC

->PROTECTED
PROC make() OF cSuperList_STRING RETURNS list:OWNS PTR TO cSuperList_STRING
	NEW list
ENDPROC

->PROTECTED
PROC make_node() OF cSuperList_STRING RETURNS node:OWNS PTR TO oSuperNode_STRING
	NEW node
ENDPROC

->PROTECTED
PROC make_cursor() OF cSuperList_STRING RETURNS cursor:OWNS PTR TO cSuperCursor_STRING
	NEW cursor
ENDPROC

/*****************************/

CLASS cSuperCursor_STRING OF cSuperCursorGeneric
ENDCLASS

PROC read() OF cSuperCursor_STRING RETURNS data:STRING IS self.list.infoMiniList()::cSuperMiniList_STRING.node_read(self.node)

PROC write(data:OWNS STRING, returnOldData=FALSE:BOOL) OF cSuperCursor_STRING RETURNS oldData:OWNS STRING IS self.list.infoMiniList()::cSuperMiniList_STRING.node_write(self.node, PASS data, returnOldData)

PROC getOwner() OF cSuperCursor_STRING IS SUPER self.getOwner()::cSuperList_STRING

PROC clone(ifRemovedThen=SC_STAY, followWhen=SC_NEVER) OF cSuperCursor_STRING RETURNS clone:OWNS PTR TO cSuperCursor_STRING IS SUPER self.clone(ifRemovedThen, followWhen)::cSuperCursor_STRING

->this provides a default sorting function (case-sensitive)
PROC sortedInsert(floating:SUPERNODES, compareFunction=NIL:PTR TO fCompareMegaNodes) OF cSuperCursor_STRING
	IF compareFunction = NIL THEN compareFunction := fCompareSuperNodes_STRING
	SUPER self.sortedInsert(floating, compareFunction)
ENDPROC

->this provides a default sorting function (case-sensitive)
PROC sortedFind(match:SUPERNODES, compareFunction=NIL:PTR TO fCompareMegaNodes) OF cSuperCursor_STRING RETURNS success:BOOL
	IF compareFunction = NIL THEN compareFunction := fCompareSuperNodes_STRING
	success := SUPER self.sortedFind(match, compareFunction)
ENDPROC

PROC sortedFindSimple(matchData:STRING, compareFunction=NIL:PTR TO fCompareSuperNodes_STRING) OF cSuperCursor_STRING RETURNS success:BOOL
	DEF tempNode:SUPERNODES, list:PTR TO cSuperList_STRING
	
	tempNode := self.getOwner().makeNode(/*OWNS*/ matchData)
	
	success := self.sortedFind(tempNode, compareFunction)
FINALLY
	IF tempNode
		list := self.getOwner()
		list.infoMiniList().node_write(tempNode !!PTR TO oMiniNode, NILS, /*returnOldData*/ TRUE)	->prevent the supplied STRING from being auto-deallocated
		self.getOwner().destroyNode(tempNode)	->### would be much easier if this method allowed "returnData" ###
	ENDIF
ENDPROC

/*****************************/

PROC miniNode_read_STRING(miniList:PTR TO cMiniListGeneric, node:PTR TO oMegaNode) IS miniList::cSuperMiniList_STRING.node_read(node)

->case-sensitive sorting
FUNC fCompareSuperNodes_STRING(miniList:PTR TO cMiniListGeneric, left:PTR TO oMegaNode, right:PTR TO oMegaNode) OF fCompareMegaNodes RETURNS sign:RANGE -1 TO 1
	sign := OstrCmp(miniNode_read_STRING(miniList, left), miniNode_read_STRING(miniList, right))
ENDFUNC

->case-insensitive sorting
FUNC fCompareSuperNodes_STRING_NoCase(miniList:PTR TO cMiniListGeneric, left:PTR TO oMegaNode, right:PTR TO oMegaNode) OF fCompareMegaNodes RETURNS sign:RANGE -1 TO 1
	sign := OstrCmpNoCase(miniNode_read_STRING(miniList, left), miniNode_read_STRING(miniList, right))
ENDFUNC
