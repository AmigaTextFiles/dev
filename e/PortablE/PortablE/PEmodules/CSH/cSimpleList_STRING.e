/* cSimpleList_STRING.e 21-01-2012
	A version of the list class, specialised to hold STRINGs.
*/

OPT POINTER
PUBLIC MODULE 'CSH/cSimpleList'

PROC main()
	DEF list :OWNS PTR TO cSimpleList_STRING, node:PTR TO cSimpleNode_STRING
	DEF list2:OWNS PTR TO cSimpleList_STRING
	
	NEW list.new()
	list.infoPastEnd().beforeInsert( list.makeNode(NEW '1') )
	list.infoPastEnd().beforeInsert( list.makeNode(NEW '2') )
	list.infoPastEnd().beforeInsert( list.makeNode(NEW '3') )
	list.infoPastEnd().beforeInsert( list.makeNode(NEW '4') )
	list.infoPastEnd().beforeInsert( list.makeNode(NEW '5') )
	list.infoPastEnd().beforeInsert( list.makeNode(NEW '6') )
	
	Print('First list:\n')
	show(list)
	
	
	->list2 := list.clone()
	list2 := list.subset(list.infoStart().infoNext(), list.infoPastEnd().infoPrev()) ; list2.isolateFromSharing()
	
	node := list2.infoStart().infoNext()
	node.write(NEW '333')
	
	Print('Second list:\n')
	show(list2)
	
	Print('\nDone\n')
FINALLY
	PrintException()
	END list, list2
ENDPROC

PRIVATE
PROC show(list:PTR TO cSimpleList_STRING)
	DEF node:PTR TO cSimpleNode_STRING
	
	node := list.infoStart()
	REPEAT
		Print('node data = "\s"\n', node.read())
		node := node.infoNext()
	UNTIL node = list.infoPastEnd()
ENDPROC
PUBLIC

/*****************************/

CLASS cSimpleNode_STRING OF cSimpleNodeGeneric
ENDCLASS

PROC read() OF cSimpleNode_STRING RETURNS data:STRING IS SUPER self.read()!!STRING

PROC write(data:STRING, returnOldData=FALSE:BOOL) OF cSimpleNode_STRING RETURNS oldData:STRING IS self.writeUngeneric(data) !!STRING

PROC infoNext() OF cSimpleNode_STRING RETURNS next:PTR TO cSimpleNode_STRING, onPastEnd:BOOL
	next, onPastEnd := SUPER self.infoNext()::cSimpleNode_STRING
ENDPROC

PROC infoPrev() OF cSimpleNode_STRING RETURNS prev:PTR TO cSimpleNode_STRING, onPastEnd:BOOL
	prev, onPastEnd := SUPER self.infoPrev()::cSimpleNode_STRING
ENDPROC

PROC infoOwner() OF cSimpleNode_STRING RETURNS list:PTR TO cSimpleList_STRING IS SUPER self.infoOwner()::cSimpleList_STRING

PROC beforeInsert(floating:SIMPLENODES) OF cSimpleNode_STRING RETURNS insertedNode:PTR TO cSimpleNode_STRING IS SUPER self.beforeInsert(floating)::cSimpleNode_STRING

PROC afterInsert( floating:SIMPLENODES) OF cSimpleNode_STRING RETURNS insertedNode:PTR TO cSimpleNode_STRING IS SUPER self.afterInsert( floating)::cSimpleNode_STRING

->PROTECTED
PROC isolateDataFromSharing() OF cSimpleNode_STRING RETURNS data:STRING
	DEF oldData:STRING
	data := IF oldData := self.read() THEN StrJoin(oldData) ELSE NILS
ENDPROC

/*****************************/

CLASS cSimpleList_STRING OF cSimpleListGeneric
	autoDealloc:BOOL
ENDCLASS

PROC new(pastEndFloatingNode=NIL:SIMPLENODES, autoDealloc=FALSE:BOOL) OF cSimpleList_STRING
	SUPER self.new(pastEndFloatingNode)
	
	self.autoDealloc := autoDealloc
ENDPROC

PROC infoStart()   OF cSimpleList_STRING RETURNS start  :PTR TO cSimpleNode_STRING IS SUPER self.infoStart()  ::cSimpleNode_STRING

PROC infoPastEnd() OF cSimpleList_STRING RETURNS pastEnd:PTR TO cSimpleNode_STRING IS SUPER self.infoPastEnd()::cSimpleNode_STRING

PROC clone()  OF cSimpleList_STRING RETURNS list:OWNS PTR TO cSimpleList_STRING IS SUPER self.clone() ::cSimpleList_STRING

PROC mirror() OF cSimpleList_STRING RETURNS list:OWNS PTR TO cSimpleList_STRING IS SUPER self.mirror()::cSimpleList_STRING

PROC subset(start=NIL:PTR TO cSimpleNodeGeneric, toPastEnd=NIL:PTR TO cSimpleNodeGeneric) OF cSimpleList_STRING RETURNS list:OWNS PTR TO cSimpleList_STRING IS SUPER self.subset(start, toPastEnd)::cSimpleList_STRING

PROC makeNode(data:STRING) OF cSimpleList_STRING RETURNS floating:SIMPLENODES IS self.makeNodeUngeneric(data)

->PROTECTED
PROC node_endData(data) OF cSimpleList_STRING
	IF self.autoDealloc THEN DisposeString(data !!STRING)
ENDPROC

->PROTECTED
PROC make_node() OF cSimpleList_STRING RETURNS node:OWNS PTR TO cSimpleNode_STRING
	NEW node
ENDPROC

->PROTECTED
PROC make() OF cSimpleList_STRING RETURNS list:OWNS PTR TO cSimpleList_STRING
	NEW list
ENDPROC

/*****************************/
