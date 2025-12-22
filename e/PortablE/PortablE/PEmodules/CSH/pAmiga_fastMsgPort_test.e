OPT MULTITHREADED, POINTER
MODULE '*pAmiga_fastMsgPort', 'CSH/pAmiga_fakeNewProcess'

PROC main()
	parent()
FINALLY
	PrintException()
ENDPROC

PROC parent()
	DEF parent:port, child:PTR TO port, msg:QUAD
	zeroPort(parent)
	
	->set-up
	initPort(parent)
	IF createChildProcessFake(CALLBACK child(), parent) = NIL THEN Throw("RES", 'parent(); failed to create child process')
	child := waitForMsg(parent) !!PTR TO port
	->(child is running & has provided it's port)
	
	->tests
	Print('parent(); starting test\n')
	sendMsgTo(child, "HELO", parent)
	sendMsgTo(child, "WRLD", parent)
	msg := waitForMsg(parent) !!QUAD
	Print('parent(); received the msg "\s"\n', QuadToStr(msg))
	
	Print('parent(); quitting\n')
FINALLY
	PrintException()
	endPort(parent)
	Print('Parent destroyed without problem\n')
	exception := 0
ENDPROC

PROC child()
	DEF child:port, parent:PTR TO port, msg:QUAD
	zeroPort(child)
	
	->set-up
	initPort(child)
	parent := infoParameterOfChildProcessFake() !!PTR TO port
	sendMsgTo(parent, /*msg*/ child, child)
	->(we know the parent's port, and it knows ours)
	
	->tests
	Print('child(); starting test\n')
	msg := waitForMsg(child) !!QUAD
	Print('child(); received the msg "\s"\n', QuadToStr(msg))
	msg := waitForMsg(child) !!QUAD
	Print('child(); received the msg "\s"\n', QuadToStr(msg))
	sendMsgTo(parent, "BYE", child)
	
	Print('child(); quitting\n')
FINALLY
	PrintException()
	endPort(child)
	Print('Child destroyed without problem\n')
	exception := 0
ENDPROC
