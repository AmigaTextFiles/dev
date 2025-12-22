/* cSimpleList_class.e 22-01-2012
	A version of the list class, specialised to hold class objects.
*/

OPT POINTER
PUBLIC MODULE 'CSH/cSimpleList'

/*****************************/

CLASS cSimpleNode_class OF cSimpleNodeGeneric
ENDCLASS

PROC read() OF cSimpleNode_class RETURNS data:PTR TO class IS SUPER self.read()!!PTR TO class

PROC write(data:POSSIBLY OWNS PTR TO class, returnOldData=FALSE:BOOL) OF cSimpleNode_class RETURNS oldData:POSSIBLY OWNS PTR TO class IS self.writeUngeneric(data) !!PTR TO class

PROC infoNext() OF cSimpleNode_class RETURNS next:PTR TO cSimpleNode_class, onPastEnd:BOOL
	next, onPastEnd := SUPER self.infoNext()::cSimpleNode_class
ENDPROC

PROC infoPrev() OF cSimpleNode_class RETURNS prev:PTR TO cSimpleNode_class, onPastEnd:BOOL
	prev, onPastEnd := SUPER self.infoPrev()::cSimpleNode_class
ENDPROC

PROC infoOwner() OF cSimpleNode_class RETURNS list:PTR TO cSimpleList_class IS SUPER self.infoOwner()::cSimpleList_class

PROC beforeInsert(floating:SIMPLENODES) OF cSimpleNode_class RETURNS insertedNode:PTR TO cSimpleNode_class IS SUPER self.beforeInsert(floating)::cSimpleNode_class

PROC afterInsert( floating:SIMPLENODES) OF cSimpleNode_class RETURNS insertedNode:PTR TO cSimpleNode_class IS SUPER self.afterInsert( floating)::cSimpleNode_class

/*****************************/

CLASS cSimpleList_class OF cSimpleListGeneric
	autoDealloc:BOOL
ENDCLASS

PROC new(pastEndFloatingNode=NIL:SIMPLENODES, autoDealloc=FALSE:BOOL) OF cSimpleList_class
	SUPER self.new(pastEndFloatingNode)
	
	self.autoDealloc := autoDealloc
ENDPROC

PROC infoStart()   OF cSimpleList_class RETURNS start  :PTR TO cSimpleNode_class IS SUPER self.infoStart()  ::cSimpleNode_class

PROC infoPastEnd() OF cSimpleList_class RETURNS pastEnd:PTR TO cSimpleNode_class IS SUPER self.infoPastEnd()::cSimpleNode_class

PROC clone() OF cSimpleList_class RETURNS list:OWNS PTR TO cSimpleList_class
	IF self.autoDealloc THEN Throw("EMU", 'cSimpleList_class.clone(); this method is not supported when autoDealloc=TRUE')
	
	list := SUPER self.clone()::cSimpleList_class
ENDPROC

PROC mirror() OF cSimpleList_class RETURNS list:OWNS PTR TO cSimpleList_class IS SUPER self.mirror()::cSimpleList_class

PROC isolateFromSharing() OF cSimpleList_class
	IF self.autoDealloc THEN Throw("EMU", 'cSimpleList_class.isolateFromSharing(); this method is not supported when autoDealloc=TRUE')
	
	SUPER self.isolateFromSharing()
ENDPROC

PROC subset(start=NIL:PTR TO cSimpleNodeGeneric, toPastEnd=NIL:PTR TO cSimpleNodeGeneric) OF cSimpleList_class RETURNS list:OWNS PTR TO cSimpleList_class IS SUPER self.subset(start, toPastEnd)::cSimpleList_class

PROC makeNode(data:POSSIBLY OWNS PTR TO class) OF cSimpleList_class RETURNS floating:SIMPLENODES IS self.makeNodeUngeneric(data)

->PROTECTED
PROC node_endData(data) OF cSimpleList_class
	DEF ownsData:POSSIBLY OWNS PTR TO class
	
	IF self.autoDealloc
		ownsData := data !!OWNS PTR TO class
		END ownsData
	ENDIF
	->was: IF self.autoDealloc THEN Throw("BUG", 'cSimpleList_class.node_endData(); autoDealloc=TRUE')
ENDPROC

->PROTECTED
PROC make_node() OF cSimpleList_class RETURNS node:OWNS PTR TO cSimpleNode_class
	NEW node
ENDPROC

->PROTECTED
PROC make() OF cSimpleList_class RETURNS list:OWNS PTR TO cSimpleList_class
	NEW list
ENDPROC

/*****************************/
