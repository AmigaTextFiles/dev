/* cMiniList_STRING.e 23-10-2014
	A version of the list class, specialised to hold STRINGs.
*/
PUBLIC MODULE 'CSH/cMiniList'

PROC main()
	DEF list :OWNS PTR TO cMiniList_STRING, node:PTR TO oMiniNode
	DEF list2:OWNS PTR TO cMiniList_STRING
	
	NEW list.new()
	list.node_beforeInsert(list.pastEnd, list.makeNode(NEW '1'))
	list.node_beforeInsert(list.pastEnd, list.makeNode(NEW '2'))
	list.node_beforeInsert(list.pastEnd, list.makeNode(NEW '3'))
	list.node_beforeInsert(list.pastEnd, list.makeNode(NEW '4'))
	list.node_beforeInsert(list.pastEnd, list.makeNode(NEW '5'))
	list.node_beforeInsert(list.pastEnd, list.makeNode(NEW '6'))
	
	Print('First list\n')
	show(list)
	
	
	list2 := list.subset()
	list2.start   := list2.node_next(list2.start)
	list2.pastEnd := list2.node_prev(list2.pastEnd)
	list2.isolateFromSharing()
	
	node := list.node_next(list.start)
	list.node_write(node, NEW '222')
	Print('First list\n')
	show(list)
	
	Print('Second list\n')
	show(list2)
	
	
	Print('\nDone\n')
FINALLY
	PrintException()
	END list
	END list2
ENDPROC

PRIVATE
PROC show(list:PTR TO cMiniList_STRING)
	DEF node:PTR TO oMiniNode
	
	node := list.start
	WHILE node <> list.pastEnd
		Print('node data = "\s"\n', list.node_read(node))
		
		node := list.node_next(node)
	ENDWHILE
ENDPROC
PUBLIC

/*****************************/
PRIVATE
OBJECT oMiniNode_STRING OF oMiniNode PRIVATE
	data:OWNS STRING
ENDOBJECT
PUBLIC

/*****************************/

CLASS cMiniList_STRING OF cMiniListGeneric
ENDCLASS


PROC new(pastEndNode=NIL:MININODES) OF cMiniList_STRING
	IF pastEndNode = NIL THEN pastEndNode := self.makeNode(NILS)
	SUPER self.new(pastEndNode)
ENDPROC

PROC makeNode(data:OWNS STRING) OF cMiniList_STRING RETURNS floating:MININODES
	DEF node:PTR TO oMiniNode_STRING
	node := self.node_make()
	self.node_new(node)
	node.data := PASS data
	floating := node
ENDPROC

PROC clone() OF cMiniList_STRING IS SUPER self.clone()::cMiniList_STRING

PROC mirror() OF cMiniList_STRING IS SUPER self.mirror()::cMiniList_STRING

PROC subset(start=NIL:PTR TO oMiniNode, pastEnd=NIL:PTR TO oMiniNode) OF cMiniList_STRING IS SUPER self.subset(start, pastEnd)::cMiniList_STRING


PROC node_read(node:PTR TO oMiniNode) OF cMiniList_STRING RETURNS data:STRING IS node::oMiniNode_STRING.data

PROC node_write(node:PTR TO oMiniNode, data:OWNS STRING, returnOldData=FALSE:BOOL) OF cMiniList_STRING RETURNS oldData:OWNS STRING
	IF returnOldData
		oldData := PASS node::oMiniNode_STRING.data
	ELSE
		oldData := NILS
		self.node_endContents(node)
	ENDIF
	
	node::oMiniNode_STRING.data := PASS data
ENDPROC

->PROTECTED
PROC node_clone(node:PTR TO oMiniNode) OF cMiniList_STRING RETURNS clone:PTR TO oMiniNode_STRING
	clone := self.node_make()
	self.node_new(clone)
	NEW clone.data[StrMax(node::oMiniNode_STRING.data)] ; StrCopy(clone.data, node::oMiniNode_STRING.data)
ENDPROC

->PROTECTED
PROC node_endContents(node:PTR TO oMiniNode) OF cMiniList_STRING
	END node::oMiniNode_STRING.data
ENDPROC

->PROTECTED
PROC node_make() OF cMiniList_STRING RETURNS node:OWNS PTR TO oMiniNode_STRING
	NEW node
ENDPROC

->PROTECTED
PROC make() OF cMiniList_STRING RETURNS list:OWNS PTR TO cMiniList_STRING
	NEW list
ENDPROC
