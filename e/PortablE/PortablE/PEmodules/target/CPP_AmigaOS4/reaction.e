/* based on $VER: reaction_lib_protos.h 53.21 (29.9.2013) */
OPT NATIVE, POINTER
MODULE 'target/exec/types', 'target/utility/tagitem', 'target/intuition/classusr', 'target/reaction/reaction', 'target/intuition/intuition'
MODULE 'target/exec', 'target/intuition'
MODULE 'target/listbrowser', 'target/gadgets/listbrowser', 'target/chooser', 'target/gadgets/chooser', 'target/radiobutton', 'target/gadgets/radiobutton', 'target/clicktab', 'target/gadgets/clicktab'

->usage demoed in ClassAct2Demo/AmigaE/LayoutExample.e, and code provided in SDK:Examples/ReAction/os4examples/Layout/LayoutExample.c
PROC ChooserLabelsA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) RETURNS chooserlist:PTR TO lh
	DEF node:PTR TO ln, index
	
	chooserlist := New(SIZEOF lh) ; IF chooserlist = NIL THEN RETURN
	NewList_exec(chooserlist)
	
	index := 0
	WHILE labelarray[index]
		IF node := AllocChooserNodeA([CNA_TEXT, labelarray[index], TAG_DONE]:tagitem) THEN AddTail(chooserlist, node)
		index++
	ENDWHILE
ENDPROC
PROC FreeChooserLabels(chooserlist:PTR TO lh)
	DEF node:PTR TO ln
	
	IF chooserlist
		WHILE node := RemHead(chooserlist) DO FreeChooserNode(node)
		/*
		DEF , next:PTR TO ln
		node := chooserlist.head
		WHILE next := node.succ
			FreeChooserNode(node)
			node := next
		ENDWHILE
		*/
		
		Dispose(chooserlist)
	ENDIF
ENDPROC

->usage demoed in ClassAct2Demo/Examples/RadioButton/radioexample.c & ClassAct2Demo/Demo/ClassActDemo.c
PROC RadioButtonsA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) RETURNS radiolist:PTR TO lh
	DEF node:PTR TO ln, index
	
	radiolist := New(SIZEOF lh) ; IF radiolist = NIL THEN RETURN
	NewList_exec(radiolist)
	
	index := 0
	WHILE labelarray[index]
		IF node := AllocRadioButtonNodeA(1, [RBNA_LABEL, labelarray[index], TAG_DONE]:tagitem) THEN AddTail(radiolist, node)
		index++
	ENDWHILE
ENDPROC
PROC FreeRadioButtons(radiolist:PTR TO lh)
	DEF node:PTR TO ln
	
	IF radiolist
		WHILE node := RemHead(radiolist) DO FreeRadioButtonNode(node)
		Dispose(radiolist)
	ENDIF
ENDPROC

->NOT IMPLEMENTED
->PROC OpenLayoutWindowTagList( param1:PTR TO gadget, param2:PTR TO screen, param3:PTR TO tagitem) RETURNS win:PTR TO window

->NOT IMPLEMENTED
->PROC GetCode(msg:PTR TO intuimessage) RETURNS code

->OBSOLETE usage demoed by ClassAct2Demo/AmigaE/LayoutExample.e & ClassAct2Demo/AmigaE/PenMapExample.e, and code provided in SDK:Examples/ReAction/os4examples/Layout/ListBrowserExample.c
->PROC OpenClass(name:/*STRPTR*/ ARRAY OF CHAR, version/*:ULONG*/) RETURNS classbase:PTR TO lib IS OpenLibrary(name, version)

->NOT IMPLEMENTED
->PROC OpenLibs(param1:APTR) RETURNS unknown:/*STRPTR*/ ARRAY OF CHAR
->PROC CloseLibs(param1:APTR)

->based upon LbAddNodeA()/etc implementation
PROC LibDoGadgetMethodA(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, msg:PTR TO msg) RETURNS ret/*:ULONG*/ IS DoGadgetMethodA(gad, win, req, msg)

->NO NEED TO IMPLEMENT, as Intuition already provides this function (and the name clashes so we can't re-declare it anyway)
->PROC GetAttrsA(o:PTR TO INTUIOBJECT, t:PTR TO tagitem) RETURNS count/*:ULONG*/ IS GetAttrsA(o, t)

->usage demoed in ClassAct2Demo/AmigaE/LayoutExample.e, and code provided in SDK:Examples/ReAction/os4examples/Layout/LayoutExample.c
PROC BrowserNodesA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) RETURNS browserlist:PTR TO lh
	DEF node:PTR TO ln, index
	
	browserlist := New(SIZEOF lh) ; IF browserlist = NIL THEN RETURN
	NewList_exec(browserlist)
	
	index := 0
	WHILE labelarray[index]
		IF node := AllocListBrowserNodeA(1, [LBNCA_TEXT, labelarray[index], TAG_DONE]:tagitem) THEN AddTail(browserlist, node)
		index++
	ENDWHILE
ENDPROC
PROC FreeBrowserNodes(browserlist:PTR TO lh)
	IF browserlist
		FreeListBrowserList(browserlist)
		Dispose(browserlist)
	ENDIF
ENDPROC

->usage demoed in ClassAct2Demo/Examples/ClickTab/pageexample.c, and approx code provided in ClassAct2Demo/AmigaE/ClickTabExample.e
PROC ClickTabsA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) RETURNS clicktabslist:PTR TO lh
	DEF node:PTR TO ln, index
	
	clicktabslist := New(SIZEOF lh) ; IF clicktabslist = NIL THEN RETURN
	NewList_exec(clicktabslist)
	
	index := 0
	WHILE labelarray[index]
		IF node := AllocClickTabNodeA([TNA_TEXT,labelarray[index], TNA_NUMBER,index, TAG_DONE]:tagitem) THEN AddTail(clicktabslist, node)
		index++
	ENDWHILE
ENDPROC
PROC FreeClickTabs(clicktabslist:PTR TO lh)
	DEF node:PTR TO ln
	
	IF clicktabslist
		WHILE node := RemHead(clicktabslist) DO FreeClickTabNode(node)
		Dispose(clicktabslist)
	ENDIF
ENDPROC

->based upon autodocs for listbrowser.gadget/LBM_ADDNODE & DoGadgetMethodA()
PROC LbAddNodeA( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, node:PTR TO ln, tags:PTR TO tagitem) RETURNS node2:PTR TO ln   IS DoGadgetMethodA(gad, win, req, [LBM_ADDNODE,  NIL, node, tags]:addnode !!ARRAY!!PTR TO msg) !!PTR TO ln
PROC LbEditNodeA(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, node:PTR TO ln, tags:PTR TO tagitem) RETURNS success/*:ULONG*/ IS DoGadgetMethodA(gad, win, req, [LBM_EDITNODE, NIL, node, tags]:editnode!!ARRAY!!PTR TO msg)
PROC LbRemNode(  gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, node:PTR TO ln)                      RETURNS success/*:ULONG*/ IS DoGadgetMethodA(gad, win, req, [LBM_REMNODE,  NIL, node      ]:remnode !!ARRAY!!PTR TO msg)
