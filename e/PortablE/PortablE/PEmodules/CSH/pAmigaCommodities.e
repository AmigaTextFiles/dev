/* pAmigaCommodities.e 29-07-2012
	A collection of useful procedures/wrappers for the Commodities library.
	Copyright (C) 2009, 2010, 2012 Christopher Steven Handley.
*/
OPT INLINE
PUBLIC MODULE 'commodities'
MODULE 'exec', 'dos/dos'

PROC new()
	cxbase := OpenLibrary('commodities.library', 0)
	IF cxbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(cxbase)
ENDPROC

/*****************************/

PROC cxFilter(d)          IS CreateCxObj(CX_FILTER, d, 0)
PROC cxSender(port, id)   IS CreateCxObj(CX_SEND, port, id)
PROC cxSignal(task, sig)  IS CreateCxObj(CX_SIGNAL, task, sig)
PROC cxTranslate(ie)      IS CreateCxObj(CX_TRANSLATE, ie, 0)
PROC cxDebug(id)          IS CreateCxObj(CX_DEBUG, id, 0)
PROC cxCustom(action, id) IS CreateCxObj(CX_CUSTOM, action, id)

/*****************************/

->send an Exchange-like command to a named Commodity, and returns if the command was sent.
->NOTE: command=CXCMD_DISABLE, CXCMD_ENABLE, CXCMD_APPEAR, CXCMD_DISAPPEAR, CXCMD_KILL, CXCMD_UNIQUE.
PROC commodityCommand(name:ARRAY OF CHAR, command) RETURNS success:BOOL
	success := IF BrokerCommand(name, command) = 0 THEN TRUE ELSE FALSE
ENDPROC

PROC commmodityExists(name:ARRAY OF CHAR) RETURNS exists:BOOL
	DEF list:lh
	list.head := NIL
	
	NewList_exec(list)
	CopyBrokerList(list)
	
	exists := FindName(list, name) <> NIL
FINALLY
	IF list.head THEN FreeBrokerList(list)
ENDPROC

/*
->NOTE: This implementation makes use of private fields, which is not really recommended
PROC commmodityExists(name:ARRAY OF CHAR) RETURNS exists:BOOL
	DEF list:lh, node:PTR TO brokerNode, next:PTR TO brokerNode
	list.head := NIL
	
	NewList_exec(list)
	CopyBrokerList(list)
	
	exists := FALSE
	node := list.head::brokerNode
	IF node THEN next := node.succ::brokerNode
	WHILE next
		IF StrCmp(name, node.bName) THEN exists := TRUE
		->Print('# name=\l\s[24], title=\s[40], description=\s\n', node.bName, node.title, node.descr)
		
		node := next
		next := node.succ::brokerNode
	ENDWHILE IF exists
FINALLY
	IF list.head THEN FreeBrokerList(list)
ENDPROC

OBJECT brokerNode OF ln
	bName[CBD_NAMELEN] :ARRAY OF CHAR
	title[CBD_TITLELEN]:ARRAY OF CHAR
	descr[CBD_DESCRLEN]:ARRAY OF CHAR
	task
	dummy1
	dummy2
	flags:UINT
ENDOBJECT
*/
