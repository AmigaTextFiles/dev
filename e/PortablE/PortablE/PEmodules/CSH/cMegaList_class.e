/* cMegaList_class.e 31-07-2016
	A version of the list class, specialised to hold class objects.
*/
OPT INLINE
PUBLIC MODULE 'CSH/cMegaList'
MODULE 'CSH/cMiniList'

/*****************************/

OBJECT oMegaNode_class OF oMegaNode PRIVATE
	data:POSSIBLY OWNS PTR TO class
ENDOBJECT

/*****************************/

CLASS cMegaMiniList_class UNGENERIC OF cMegaMiniListGeneric
ENDCLASS

PROC new(container:PTR TO cMegaListGeneric, pastEndNode=NIL:MININODES) OF cMegaMiniList_class
	self.container := container
	IF pastEndNode = NIL THEN pastEndNode := self.makeNode(NIL)
	SUPER self.new(pastEndNode)
ENDPROC

PROC makeNode(data:POSSIBLY OWNS PTR TO class) OF cMegaMiniList_class RETURNS floating:MININODES
	DEF node:PTR TO oMegaNode
	node := self.node_make()
	self.node_new(node, data)
	floating := node
ENDPROC

PROC node_read(node:PTR TO oMiniNode) OF cMegaMiniList_class RETURNS data:PTR TO class IS node::oMegaNode_class.data

PROC node_write(node:PTR TO oMiniNode, data:POSSIBLY OWNS PTR TO class, returnOldData=FALSE:BOOL) OF cMegaMiniList_class RETURNS oldData:POSSIBLY OWNS PTR TO class
	IF returnOldData
		oldData := PASS node::oMegaNode_class.data
	ELSE
		oldData := NIL
		self.node_endContents(node)
	ENDIF
	
	node::oMegaNode_class.data := data
ENDPROC

->PROTECTED
PROC node_clone(node:PTR TO oMiniNode) OF cMegaMiniList_class RETURNS clone:PTR TO oMegaNode_class
	clone := SUPER self.node_clone(node)::oMegaNode_class
	clone.data := node::oMegaNode_class.data
ENDPROC

->PROTECTED
PROC node_endContents(node:PTR TO oMiniNode) OF cMegaMiniList_class
	SUPER self.node_endContents(node)
	IF self.container::cMegaList_class.autoDealloc THEN END node::oMegaNode_class.data
ENDPROC

->PROTECTED
PROC node_new(node:PTR TO oMiniNode, data=NIL:POSSIBLY OWNS PTR TO class) OF cMegaMiniList_class
	SUPER self.node_new(node)
	node::oMegaNode_class.data := data
ENDPROC

->PROTECTED
PROC make() OF cMegaMiniList_class RETURNS list:OWNS PTR TO cMegaMiniList_class
	NEW list
ENDPROC

/*****************************/

CLASS cMegaList_class OF cMegaListGeneric
	autoDealloc:BOOL
ENDCLASS

PROC new(cursorNextIfDestroyNode=FALSE:BOOL, pastEndFloatingNode=NIL:MEGANODES, autoDealloc=FALSE:BOOL) OF cMegaList_class
	DEF miniList:OWNS PTR TO cMegaMiniList_class
	
	self.autoDealloc := autoDealloc
	
	IF self.miniList = NIL
		NEW miniList.new(self, pastEndFloatingNode)
		self.miniList := PASS miniList
		
	ELSE IF pastEndFloatingNode
		Throw("BUG", 'cMegaList_class.new(); pastEndFloatingNode supplied when miniList exists')
	ENDIF
	
	SUPER self.new(cursorNextIfDestroyNode)
ENDPROC

PROC infoStart() OF cMegaList_class IS self.start/*SUPER self.infoStart()*/::cMegaCursor_class

PROC infoPastEnd() OF cMegaList_class IS self.pastEnd/*SUPER self.infoPastEnd()*/::cMegaCursor_class

PROC infoMiniList() OF cMegaList_class RETURNS miniList:PTR TO cMegaMiniList_class IS self.miniList/*SUPER self.infoMiniList()*/::cMegaMiniList_class

PROC infoAutoDealloc() OF cMegaList_class RETURNS autoDealloc:BOOL IS self.autoDealloc

PROC makeNode(data:POSSIBLY OWNS PTR TO class) OF cMegaList_class RETURNS floating:MEGANODES IS self.miniList::cMegaMiniList_class.makeNode(data)

PROC clone(noAutoDealloc=FALSE:BOOL) OF cMegaList_class RETURNS list:OWNS PTR TO cMegaList_class
	DEF origAutoDealloc:BOOL
	
	IF noAutoDealloc
		origAutoDealloc := self.autoDealloc
		self.autoDealloc := FALSE
	ELSE
		IF self.autoDealloc THEN Throw("EMU", 'cMegaList_class.clone(); this method is not supported when autoDealloc=TRUE')
	ENDIF
	
	list := SUPER self.clone()::cMegaList_class
	
	IF noAutoDealloc
		self.autoDealloc := origAutoDealloc
	ENDIF
ENDPROC

PROC mirror() OF cMegaList_class IS SUPER self.mirror()::cMegaList_class

PROC subset(start=NIL:PTR TO cMegaCursorGeneric, pastEnd=NIL:PTR TO cMegaCursorGeneric) OF cMegaList_class IS SUPER self.subset(start, pastEnd)::cMegaList_class

PROC isolateFromSharing() OF cMegaList_class
	IF self.autoDealloc THEN Throw("EMU", 'cMegaList_class.isolateFromSharing(); this method is not supported when autoDealloc=TRUE')
	
	SUPER self.isolateFromSharing()
ENDPROC

->no sorting override, since this does not make sense

->PROTECTED
PROC node_clone(clone:PTR TO oMegaNode, orig:PTR TO oMegaNode) OF cMegaList_class
	IF self.autoDealloc THEN Throw("BUG", 'cMegaList_class.node_clone(); autoDealloc=TRUE')
	
	->SUPER self.node_clone(clone, orig)
ENDPROC

->PROTECTED
PROC make() OF cMegaList_class RETURNS list:OWNS PTR TO cMegaList_class
	NEW list
ENDPROC

->PROTECTED
PROC make_node() OF cMegaList_class RETURNS node:OWNS PTR TO oMegaNode_class
	NEW node
ENDPROC

->PROTECTED
PROC make_cursor() OF cMegaList_class RETURNS cursor:OWNS PTR TO cMegaCursor_class
	NEW cursor
ENDPROC

/*****************************/

CLASS cMegaCursor_class OF cMegaCursorGeneric
ENDCLASS

PROC read() OF cMegaCursor_class RETURNS data:PTR TO class IS self.list.infoMiniList()::cMegaMiniList_class.node_read(self.node)

PROC write(data:POSSIBLY OWNS PTR TO class, returnOldData=FALSE:BOOL) OF cMegaCursor_class RETURNS oldData:POSSIBLY OWNS PTR TO class IS self.list.infoMiniList()::cMegaMiniList_class.node_write(self.node, data, returnOldData)

PROC getOwner() OF cMegaCursor_class IS SUPER self.getOwner()::cMegaList_class

PROC clone(ifRemovedThen=MC_STAY, followWhen=MC_NEVER) OF cMegaCursor_class RETURNS clone:OWNS PTR TO cMegaCursor_class IS SUPER self.clone(ifRemovedThen, followWhen)::cMegaCursor_class

->PROC infoMiniNode() OF cMegaCursor_class IS SUPER self.infoMiniNode()::oMegaNode_class

PROC beforeInsert(floating:MEGANODES) OF cMegaCursor_class RETURNS insertedNodes:PTR TO oMegaNode_class IS SUPER self.beforeInsert(floating)::oMegaNode_class

PROC afterInsert( floating:MEGANODES) OF cMegaCursor_class RETURNS insertedNodes:PTR TO oMegaNode_class IS SUPER self. afterInsert(floating)::oMegaNode_class

/* no sorting defaults, since this does not make sense */

PROC sortedInsert(floating:MEGANODES, compareFunction:PTR TO fCompareMegaNodes) OF cMegaCursor_class RETURNS insertedNodes:PTR TO oMegaNode_class IS SUPER self.sortedInsert(floating, compareFunction)::oMegaNode_class

PROC sortedFindSimple(matchData:PTR TO class, compareFunction:PTR TO fCompareMegaNodes) OF cMegaCursor_class RETURNS success:BOOL
	DEF tempNode:MEGANODES, list:PTR TO cMegaList_class
	
	tempNode := self.getOwner().makeNode(/*OWNS*/ matchData)
	
	success := self.sortedFind(tempNode, compareFunction)
FINALLY
	IF tempNode
		list := self.getOwner()
		IF list.autoDealloc THEN list.infoMiniList().node_write(tempNode !!PTR TO oMiniNode, NIL, /*returnOldData*/ TRUE)	->prevent the supplied class from being auto-deallocated
		self.getOwner().destroyNode(tempNode)	->### would be much easier if this method allowed "returnData" ###
	ENDIF
ENDPROC

/*****************************/

PROC miniNode_read_class(miniList:PTR TO cMiniListGeneric, node:PTR TO oMegaNode) IS miniList::cMegaMiniList_class.node_read(node)

->no sorting functions, since this does not make sense
