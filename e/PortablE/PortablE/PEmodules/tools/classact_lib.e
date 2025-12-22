/* ClassAct wrapper using ReAction */
PUBLIC MODULE 'target/reaction', 'target/utility', 'target/layout', 'target/radiobutton', 'target/chooser', 'target/listbrowser'
MODULE 'exec', 'target/intuition'

PROC chooserLabelsA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) IS ChooserLabelsA(labelarray)
PROC freeChooserLabels(chooserlist:PTR TO lh) IS FreeChooserLabels(chooserlist)

PROC radioButtonsA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) IS RadioButtonsA(labelarray)
PROC freeRadioButtons(radiolist:PTR TO lh) IS FreeRadioButtons(radiolist)

->PROC openLayoutWindowTagList(layout,screen,tags)

->PROC getCode(msg)

PROC openClass(name:/*STRPTR*/ ARRAY OF CHAR, version/*:ULONG*/) IS OpenLibrary(name, version)

->PROC openLibs(libs)
->PROC closeLibs(libs)

PROC libDoGadgetMethodA(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, msg:PTR TO msg) IS LibDoGadgetMethodA(gad, win, req, msg)

PROC getAttrsA(o:PTR TO INTUIOBJECT, t:ARRAY OF tagitem) IS GetAttrsA(o, t)

PROC browserNodesA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) IS BrowserNodesA(labelarray)
PROC freeBrowserNodes(browserlist:PTR TO lh) IS FreeBrowserNodes(browserlist)

PROC clickTabsA(labelarray:ARRAY OF /*STRPTR*/ ARRAY OF CHAR) IS ClickTabsA(labelarray)
PROC freeClickTabs(clicktabslist:PTR TO lh) IS FreeClickTabs(clicktabslist)

PROC lbAddNode( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, node:PTR TO ln, tags:PTR TO tagitem) IS LbAddNodeA( gad, win, req, node, tags)
PROC lbEditNode(gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, node:PTR TO ln, tags:PTR TO tagitem) IS LbEditNodeA(gad, win, req, node, tags)
PROC lbRemNode( gad:PTR TO gadget, win:PTR TO window, req:PTR TO requester, node:PTR TO ln)                      IS LbRemNode(  gad, win, req, node)
