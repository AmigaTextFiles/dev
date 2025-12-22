/* cMegaList_STRING.e 28-10-2012
	A version of the list class, specialised to hold STRINGs.
*/
OPT INLINE
PUBLIC MODULE 'CSH/cMegaList'
MODULE 'CSH/cMiniList'

PROC main()
	DEF list :OWNS PTR TO cMegaList_STRING, cursor :OWNS PTR TO cMegaCursor_STRING
	DEF list2:OWNS PTR TO cMegaList_STRING, cursor2:OWNS PTR TO cMegaCursor_STRING
	
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
	list2.isolateFromSharing()
	
	cursor.goto(list.infoStart()) ; cursor.next()
	cursor.write(NEW '555')
	Print('First list\n')
	show(list, cursor)
	
	list.sort(fCompareMegaNodes_STRING)
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
PROC show(list:PTR TO cMegaList_STRING, tempCursor:PTR TO cMegaCursor_STRING)
	IF list.infoIsEmpty() = FALSE
		tempCursor.goto(list.infoStart())
		REPEAT
			Print('node data = "\s"\n', tempCursor.read())
		UNTIL tempCursor.next()
	ENDIF
ENDPROC
PUBLIC

/*****************************/

OBJECT oMegaNode_STRING OF oMegaNode PRIVATE
	data:OWNS STRING
ENDOBJECT

/*****************************/

CLASS cMegaMiniList_STRING UNGENERIC OF cMegaMiniListGeneric
ENDCLASS

PROC new(container:PTR TO cMegaListGeneric, pastEndNode=NIL:MININODES) OF cMegaMiniList_STRING
	self.container := container
	IF pastEndNode = NIL THEN pastEndNode := self.makeNode(NILS)
	SUPER self.new(pastEndNode)
ENDPROC

PROC makeNode(data:OWNS STRING) OF cMegaMiniList_STRING RETURNS floating:MININODES
	DEF node:PTR TO oMegaNode
	node := self.node_make()
	self.node_new(node, PASS data)
	floating := node
ENDPROC

PROC node_read(node:PTR TO oMiniNode) OF cMegaMiniList_STRING RETURNS data:STRING IS node::oMegaNode_STRING.data

PROC node_write(node:PTR TO oMiniNode, data:OWNS STRING, returnOldData=FALSE:BOOL) OF cMegaMiniList_STRING RETURNS oldData:OWNS STRING
	IF returnOldData
		oldData := PASS node::oMegaNode_STRING.data
	ELSE
		oldData := NILS
		self.node_endContents(node)
	ENDIF
	
	node::oMegaNode_STRING.data := PASS data
ENDPROC

->PROTECTED
PROC node_clone(node:PTR TO oMiniNode) OF cMegaMiniList_STRING RETURNS clone:PTR TO oMegaNode_STRING
	clone := SUPER self.node_clone(node)::oMegaNode_STRING
	NEW     clone.data[StrMax(node::oMegaNode_STRING.data)]
	StrCopy(clone.data,       node::oMegaNode_STRING.data)
ENDPROC

->PROTECTED
PROC node_endContents(node:PTR TO oMiniNode) OF cMegaMiniList_STRING
	SUPER self.node_endContents(node)
	END node::oMegaNode_STRING.data
ENDPROC

->PROTECTED
PROC node_new(node:PTR TO oMiniNode, data=NILS:OWNS STRING) OF cMegaMiniList_STRING
	SUPER self.node_new(node)
	node::oMegaNode_STRING.data := PASS data
ENDPROC

->PROTECTED
PROC make() OF cMegaMiniList_STRING RETURNS list:OWNS PTR TO cMegaMiniList_STRING
	NEW list
ENDPROC

/*****************************/

CLASS cMegaList_STRING OF cMegaListGeneric
ENDCLASS

PROC new(cursorNextIfDestroyNode=FALSE:BOOL, pastEndFloatingNode=NIL:MEGANODES) OF cMegaList_STRING
	DEF miniList:OWNS PTR TO cMegaMiniList_STRING
	
	IF self.miniList = NIL
		NEW miniList.new(self, pastEndFloatingNode)
		self.miniList := PASS miniList
		
	ELSE IF pastEndFloatingNode
		Throw("BUG", 'cMegaList_STRING.new(); pastEndFloatingNode supplied when miniList exists')
	ENDIF
	
	SUPER self.new(cursorNextIfDestroyNode)
ENDPROC

PROC infoStart() OF cMegaList_STRING IS self.start/*SUPER self.infoStart()*/::cMegaCursor_STRING

PROC infoPastEnd() OF cMegaList_STRING IS self.pastEnd/*SUPER self.infoPastEnd()*/::cMegaCursor_STRING

PROC infoMiniList() OF cMegaList_STRING RETURNS miniList:PTR TO cMegaMiniList_STRING IS self.miniList/*SUPER self.infoMiniList()*/::cMegaMiniList_STRING

PROC makeNode(data:OWNS STRING) OF cMegaList_STRING RETURNS floating:MEGANODES IS self.miniList::cMegaMiniList_STRING.makeNode(PASS data)

PROC clone() OF cMegaList_STRING IS SUPER self.clone()::cMegaList_STRING

PROC mirror() OF cMegaList_STRING IS SUPER self.mirror()::cMegaList_STRING

PROC subset(start=NIL:PTR TO cMegaCursorGeneric, pastEnd=NIL:PTR TO cMegaCursorGeneric) OF cMegaList_STRING IS SUPER self.subset(start, pastEnd)::cMegaList_STRING

->this adds a default sorting function (case-sensitive)
PROC sort(compareFunction=NIL:PTR TO fCompareMegaNodes) OF cMegaList_STRING
	IF compareFunction = NIL THEN compareFunction := fCompareMegaNodes_STRING
	SUPER self.sort(compareFunction)
ENDPROC

->PROTECTED
PROC make() OF cMegaList_STRING RETURNS list:OWNS PTR TO cMegaList_STRING
	NEW list
ENDPROC

->PROTECTED
PROC make_node() OF cMegaList_STRING RETURNS node:OWNS PTR TO oMegaNode_STRING
	NEW node
ENDPROC

->PROTECTED
PROC make_cursor() OF cMegaList_STRING RETURNS cursor:OWNS PTR TO cMegaCursor_STRING
	NEW cursor
ENDPROC

/*****************************/

CLASS cMegaCursor_STRING OF cMegaCursorGeneric
ENDCLASS

PROC read() OF cMegaCursor_STRING RETURNS data:STRING IS self.list.infoMiniList()::cMegaMiniList_STRING.node_read(self.node)

PROC write(data:OWNS STRING, returnOldData=FALSE:BOOL) OF cMegaCursor_STRING RETURNS oldData:OWNS STRING IS self.list.infoMiniList()::cMegaMiniList_STRING.node_write(self.node, PASS data, returnOldData)

PROC getOwner() OF cMegaCursor_STRING IS SUPER self.getOwner()::cMegaList_STRING

PROC clone(ifRemovedThen=MC_STAY, followWhen=MC_NEVER) OF cMegaCursor_STRING RETURNS clone:OWNS PTR TO cMegaCursor_STRING IS SUPER self.clone(ifRemovedThen, followWhen)::cMegaCursor_STRING

->PROC infoMiniNode() OF cMegaCursor_STRING IS SUPER self.infoMiniNode()::oMegaNode_STRING

PROC beforeInsert(floating:MEGANODES) OF cMegaCursor_STRING RETURNS insertedNodes:PTR TO oMegaNode_STRING IS SUPER self.beforeInsert(floating)::oMegaNode_STRING

PROC afterInsert( floating:MEGANODES) OF cMegaCursor_STRING RETURNS insertedNodes:PTR TO oMegaNode_STRING IS SUPER self. afterInsert(floating)::oMegaNode_STRING

->this adds a default sorting function (case-sensitive)
PROC sortedInsert(floating:MEGANODES, compareFunction=NIL:PTR TO fCompareMegaNodes) OF cMegaCursor_STRING RETURNS insertedNodes:PTR TO oMegaNode_STRING
	IF compareFunction = NIL THEN compareFunction := fCompareMegaNodes_STRING
	insertedNodes := SUPER self.sortedInsert(floating, compareFunction)::oMegaNode_STRING
ENDPROC

->this adds a default sorting function (case-sensitive)
PROC sortedFind(match:MEGANODES, compareFunction=NIL:PTR TO fCompareMegaNodes) OF cMegaCursor_STRING RETURNS success:BOOL
	IF compareFunction = NIL THEN compareFunction := fCompareMegaNodes_STRING
	success := SUPER self.sortedFind(match, compareFunction)
ENDPROC

PROC sortedFindSimple(matchData:STRING, compareFunction=NIL:PTR TO fCompareMegaNodes) OF cMegaCursor_STRING RETURNS success:BOOL
	DEF tempNode:MEGANODES, list:PTR TO cMegaList_STRING
	
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

PROC miniNode_read_STRING(miniList:PTR TO cMiniListGeneric, node:PTR TO oMegaNode) IS miniList::cMegaMiniList_STRING.node_read(node)

->case-sensitive sorting
FUNC fCompareMegaNodes_STRING(miniList:PTR TO cMiniListGeneric, left:PTR TO oMegaNode, right:PTR TO oMegaNode) OF fCompareMegaNodes RETURNS sign:RANGE -1 TO 1
	sign := OstrCmp(miniNode_read_STRING(miniList, left), miniNode_read_STRING(miniList, right))
ENDFUNC

->case-insensitive sorting
FUNC fCompareMegaNodes_STRING_NoCase(miniList:PTR TO cMiniListGeneric, left:PTR TO oMegaNode, right:PTR TO oMegaNode) OF fCompareMegaNodes RETURNS sign:RANGE -1 TO 1
	sign := OstrCmpNoCase(miniNode_read_STRING(miniList, left), miniNode_read_STRING(miniList, right))
ENDFUNC
